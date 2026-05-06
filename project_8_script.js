/*
 * Copyright (c) 2026 Sing Chun LEE @ Bucknell University. CC BY-NC 4.0.
 *
 * This code is provided mainly for educational purposes at University of the Pacific.
 *
 * This code is licensed under the Creative Commons Attribution-NonCommercial 4.0
 * International License. To view a copy of the license, visit
 *   https://creativecommons.org/licenses/by-nc/4.0/
 * or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * You are free to:
 *  - Share: copy and redistribute the material in any medium or format.
 *  - Adapt: remix, transform, and build upon the material.
 *
 * Under the following terms:
 *  - Attribution: You must give appropriate credit, provide a link to the license,
 *                 and indicate if changes were made.
 *  - NonCommercial: You may not use the material for commercial purposes.
 *  - No additional restrictions: You may not apply legal terms or technological
 *                                measures that legally restrict others from doing
 *                                anything the license permits.
 */

/*
 * Project 8 — Materials Studio
 *
 * Demonstrates all required lighting, shading, and texture features using
 * a ray-traced box scene (camera inside the box = "Materials Studio" room).
 *
 * Features:
 *   Light types    : Point, Directional, Spotlight
 *   Shading models : Lambertian, Phong, Toon, Blinn-Phong, Cook-Torrance
 *   Texture mapping: Diffuse (stone tile on floor), Bump, Environment (cube map)
 *   Procedural tex : Checkerboard on back wall, Wood grain on left wall
 *   Materials      : Brushed steel (ceiling), stone (floor + front), wood (left),
 *                    red plastic (right), teal stone (back)
 *
 * Keyboard controls:
 *   W/S/A/D/Q/E    — camera translation
 *   Arrow / Z / X  — camera rotation
 *   P              — toggle projective / orthographic
 *   + / -          — focal length
 *   R              — reset camera
 *   1 / 2 / 3      — point / directional / spotlight
 *   N              — cycle lights
 *   4–8            — Lambertian / Phong / Toon / Blinn-Phong / Cook-Torrance
 *   M              — cycle shading models
 *   T              — toggle stone texture on floor
 *   B              — toggle bump mapping
 *   C              — toggle environment cube map
 *   V              — toggle procedural checkerboard on back wall
 *   H              — hide / show HUD
 */

import RayTracer        from '/lib/Viz/RayTracer.js'
import RayBoxLightObject from '/lib/Scene/RayBoxLightObject.js'
import Camera           from '/lib/Viz/3DCamera.js'
import PointLight       from '/lib/Viz/PointLight.js'
import DirectionalLight from '/lib/Viz/DirectionalLight.js'
import SpotLight        from '/lib/Viz/SpotLight.js'

// ── Light-type indices ────────────────────────────────────────────────────────
const LIGHT_POINT       = 0;
const LIGHT_DIRECTIONAL = 1;
const LIGHT_SPOT        = 2;
const LIGHT_NAMES       = ['Point Light', 'Directional Light', 'Spotlight'];

// ── Shading-model indices ─────────────────────────────────────────────────────
const SHADE_LAMBERTIAN   = 0;
const SHADE_PHONG        = 1;
const SHADE_TOON         = 2;
const SHADE_BLINNPHONG   = 3;
const SHADE_COOKTORRANCE = 4;
const SHADE_NAMES = ['Lambertian', 'Phong', 'Toon', 'Blinn-Phong', 'Cook-Torrance'];

// ── TGA texture loader ────────────────────────────────────────────────────────
// Parses uncompressed (type 2) and RLE (type 10) true-colour TGA files and
// uploads the decoded RGBA pixels to a GPUTexture.
async function loadTGATexture(device, url) {
  const response = await fetch(url);
  const buffer   = await response.arrayBuffer();
  const bytes    = new Uint8Array(buffer);

  const idLength   = bytes[0];
  const imageType  = bytes[2];
  const width      = bytes[12] | (bytes[13] << 8);
  const height     = bytes[14] | (bytes[15] << 8);
  const depth      = bytes[16];
  const descriptor = bytes[17];
  const flipY      = (descriptor & 0x20) === 0;

  const bpp       = depth >> 3;
  const dataStart = 18 + idLength;
  const rgba      = new Uint8Array(width * height * 4);

  if (imageType === 2) {
    // Uncompressed — TGA stores pixels in BGR order.
    for (let row = 0; row < height; row++) {
      const srcRow  = flipY ? (height - 1 - row) : row;
      const srcBase = dataStart + srcRow * width * bpp;
      const dstBase = row * width * 4;
      for (let x = 0; x < width; x++) {
        const s = srcBase + x * bpp;
        const d = dstBase + x * 4;
        rgba[d]     = bytes[s + 2];
        rgba[d + 1] = bytes[s + 1];
        rgba[d + 2] = bytes[s];
        rgba[d + 3] = bpp >= 4 ? bytes[s + 3] : 255;
      }
    }
  } else if (imageType === 10) {
    // RLE true-colour.
    let offset = dataStart;
    let pixel  = 0;
    while (pixel < width * height) {
      const header = bytes[offset++];
      const count  = (header & 0x7f) + 1;
      if (header & 0x80) {
        const r = bytes[offset + 2];
        const g = bytes[offset + 1];
        const b = bytes[offset];
        const a = bpp >= 4 ? bytes[offset + 3] : 255;
        offset += bpp;
        for (let i = 0; i < count; i++, pixel++) {
          const row  = Math.floor(pixel / width);
          const col  = pixel % width;
          const dRow = flipY ? (height - 1 - row) : row;
          const d    = (dRow * width + col) * 4;
          rgba[d] = r; rgba[d+1] = g; rgba[d+2] = b; rgba[d+3] = a;
        }
      } else {
        for (let i = 0; i < count; i++, pixel++) {
          const row  = Math.floor(pixel / width);
          const col  = pixel % width;
          const dRow = flipY ? (height - 1 - row) : row;
          const d    = (dRow * width + col) * 4;
          rgba[d]     = bytes[offset + 2];
          rgba[d + 1] = bytes[offset + 1];
          rgba[d + 2] = bytes[offset];
          rgba[d + 3] = bpp >= 4 ? bytes[offset + 3] : 255;
          offset += bpp;
        }
      }
    }
  }

  const texture = device.createTexture({
    label: 'Stone Tile Texture',
    size:  [width, height],
    format: 'rgba8unorm',
    usage: GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.COPY_DST,
  });
  device.queue.writeTexture({ texture }, rgba, { bytesPerRow: width * 4 }, [width, height]);
  return texture;
}

// ── Cube-map loader ──────────────────────────────────────────────────────────
// Loads six face images in WebGPU order (+X, -X, +Y, -Y, +Z, -Z) and returns
// a GPUTexture usable as texture_cube<f32>.
async function loadCubeMapTexture(device, faceUrls) {
  const bitmaps = await Promise.all(faceUrls.map(url => {
    const img = new Image();
    img.src = url;
    return img.decode().then(() => createImageBitmap(img));
  }));

  const w = bitmaps[0].width;
  const h = bitmaps[0].height;

  const cubeTexture = device.createTexture({
    label: 'Yokohama Cube Map',
    size:  [w, h, 6],
    format: 'rgba8unorm',
    usage: GPUTextureUsage.TEXTURE_BINDING |
           GPUTextureUsage.COPY_DST        |
           GPUTextureUsage.RENDER_ATTACHMENT,
  });

  for (let i = 0; i < 6; i++) {
    device.queue.copyExternalImageToTexture(
      { source: bitmaps[i] },
      { texture: cubeTexture, origin: [0, 0, i] },
      [w, h]
    );
  }
  return cubeTexture;
}

// ── RayBoxProject8Object ─────────────────────────────────────────────────────
// Extends RayBoxLightObject with four extra GPU bindings (same layout as
// Scroll 14's RayBoxTexObject) plus a showProc flag for the checkerboard:
//   4 – texSampler  (repeat-wrap, linear-filter sampler)
//   5 – floorTex    (stone tile 2-D texture)
//   6 – envMap      (Yokohama cube-map texture)
//   7 – texFlags    (u32 × 4: showTexture, showBump, showCubeMap, showProc)
class RayBoxProject8Object extends RayBoxLightObject {
  constructor(device, canvasFormat, camera, shaderFile) {
    super(device, canvasFormat, camera, shaderFile);
    this._showTexture = true;
    this._showBump    = false;
    this._showCubeMap = true;
    this._showProc    = false;
  }

  async createGeometry() {
    await super.createGeometry();

    // Linear, repeat-wrap sampler for tiled stone texture.
    this._texSampler = this._device.createSampler({
      label:        'Texture Sampler',
      addressModeU: 'repeat',
      addressModeV: 'repeat',
      magFilter:    'linear',
      minFilter:    'linear',
    });

    // Stone tile diffuse texture (TGA, 4096 × 4096).
    this._floorTexture = await loadTGATexture(
      this._device,
      '/assets/T_Tile_Stone_01_4096_D.tga'
    );

    // Yokohama environment cube map.
    this._envCubeMap = await loadCubeMapTexture(this._device, [
      '/assets/Yokohama3/posx.jpg',
      '/assets/Yokohama3/negx.jpg',
      '/assets/Yokohama3/posy.jpg',
      '/assets/Yokohama3/negy.jpg',
      '/assets/Yokohama3/posz.jpg',
      '/assets/Yokohama3/negz.jpg',
    ]);

    // Texture-feature flags uniform buffer (u32 × 4 = 16 bytes).
    this._texFlagsBuffer = this._device.createBuffer({
      label: 'TexFlags Buffer',
      size:  16,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });
    this._updateTexFlags();
  }

  _updateTexFlags() {
    this._device.queue.writeBuffer(
      this._texFlagsBuffer, 0,
      new Uint32Array([
        this._showTexture ? 1 : 0,
        this._showBump    ? 1 : 0,
        this._showCubeMap ? 1 : 0,
        this._showProc    ? 1 : 0,
      ])
    );
  }

  setShowTexture(v) { this._showTexture = v; this._updateTexFlags(); }
  setShowBump(v)    { this._showBump    = v; this._updateTexFlags(); }
  setShowCubeMap(v) { this._showCubeMap = v; this._updateTexFlags(); }
  setShowProc(v)    { this._showProc    = v; this._updateTexFlags(); }

  async createShaders() {
    // Compile the WGSL module via the parent chain, then rebuild the bind-group
    // layout to include the four additional texture/sampler entries.
    await super.createShaders();

    this._bindGroupLayout = this._device.createBindGroupLayout({
      label: 'Project8 Bind Group Layout',
      entries: [
        { binding: 0, visibility: GPUShaderStage.COMPUTE, buffer: {} },
        { binding: 1, visibility: GPUShaderStage.COMPUTE, buffer: {} },
        {
          binding:        2,
          visibility:     GPUShaderStage.COMPUTE,
          storageTexture: { format: this._canvasFormat },
        },
        { binding: 3, visibility: GPUShaderStage.COMPUTE, buffer: {} },
        { binding: 4, visibility: GPUShaderStage.COMPUTE, sampler: { type: 'filtering' } },
        { binding: 5, visibility: GPUShaderStage.COMPUTE, texture: { viewDimension: '2d',   sampleType: 'float' } },
        { binding: 6, visibility: GPUShaderStage.COMPUTE, texture: { viewDimension: 'cube', sampleType: 'float' } },
        { binding: 7, visibility: GPUShaderStage.COMPUTE, buffer: {} },
      ],
    });

    this._pipelineLayout = this._device.createPipelineLayout({
      label:            'Project8 Pipeline Layout',
      bindGroupLayouts: [this._bindGroupLayout],
    });
  }

  createBindGroup(outTexture) {
    this._bindGroup = this._device.createBindGroup({
      label:  'Project8 Bind Group',
      layout: this._computePipeline.getBindGroupLayout(0),
      entries: [
        { binding: 0, resource: { buffer: this._cameraBuffer } },
        { binding: 1, resource: { buffer: this._boxBuffer } },
        { binding: 2, resource: outTexture.createView() },
        { binding: 3, resource: { buffer: this._lightBuffer } },
        { binding: 4, resource: this._texSampler },
        { binding: 5, resource: this._floorTexture.createView() },
        { binding: 6, resource: this._envCubeMap.createView({ dimension: 'cube' }) },
        { binding: 7, resource: { buffer: this._texFlagsBuffer } },
      ],
    });
    this._wgWidth  = Math.ceil(outTexture.width);
    this._wgHeight = Math.ceil(outTexture.height);
  }
}

// ── Main ──────────────────────────────────────────────────────────────────────
async function init() {
  // Canvas & renderer
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  // Camera — projective by default for the 3-D "room" feel.
  const camera = new Camera(
    renderer._offScreenTexture.width,
    renderer._offScreenTexture.height
  );
  camera._isProjective = true;

  // Scene object — uses the project_8 WGSL shader.
  const lightBox = new RayBoxProject8Object(
    renderer._device,
    renderer._canvasFormat,
    camera,
    '/project_8_light.wgsl'
  );
  await renderer.setTracerObject(lightBox);

  // ── Light source instances ──────────────────────────────────────────────────
  // Point light — above-right of the box; visible attenuation with distance.
  const pointLight = new PointLight(
    [1.5, 1.5, 1.5],
    [2, 2, -1],
    [1, 0.14, 0.07]
  );

  // Directional light — from the upper-left-front; no position, no attenuation.
  const dirLight = new DirectionalLight(
    [1.2, 1.2, 1.2],
    [0.577, -0.577, 0.577]
  );

  // Spotlight — same position as point light; narrow 30° cone aimed at box centre.
  const spotLight = new SpotLight(
    [2.0, 2.0, 2.0],
    [2, 2, -1],
    [-0.667, -0.667, 0.333],
    [1, 0.14, 0.07],
    Math.PI / 6,
    8
  );

  const lights = [pointLight, dirLight, spotLight];

  // ── Current state ───────────────────────────────────────────────────────────
  let lightIdx   = LIGHT_POINT;
  let shadingIdx = SHADE_PHONG; // Phong is a good default to show diffuse+specular

  function applyLight() {
    const L = lights[lightIdx];
    L._params[2] = lightIdx;   // light type
    L._params[3] = shadingIdx; // shading model
    lightBox.updateLight(L);
  }
  applyLight();

  const moveStep = 0.05;
  const rotStep  = Math.PI / 36; // 5 degrees

  // ── HUD helpers ─────────────────────────────────────────────────────────────
  function addKey(parent, label) {
    const btn = document.createElement('span');
    btn.className   = 'hud-button';
    btn.textContent = label;
    parent.appendChild(btn);
  }

  function addRow(parent, labelText, keys, liveEl) {
    const row = document.createElement('div');
    row.className = 'hud-control-row';
    const lbl = document.createElement('span');
    lbl.className   = 'hud-label';
    lbl.textContent = labelText;
    row.appendChild(lbl);
    for (const k of keys) addKey(row, k);
    if (liveEl) row.appendChild(liveEl);
    parent.appendChild(row);
  }

  function addSection(hud, title) {
    const sec = document.createElement('div');
    sec.className = 'hud-section';
    const hdr = document.createElement('div');
    hdr.className   = 'hud-section-header';
    hdr.textContent = title;
    sec.appendChild(hdr);
    hud.appendChild(sec);
    return sec;
  }

  // ── Build HUD ───────────────────────────────────────────────────────────────
  const hud = document.createElement('div');
  hud.id = 'hud';

  const titleEl = document.createElement('div');
  titleEl.className   = 'hud-title';
  titleEl.textContent = 'Project 8 — Materials Studio';
  hud.appendChild(titleEl);

  // Camera movement
  const movSec = addSection(hud, 'CAMERA MOVEMENT');
  addRow(movSec, 'Move Forward / Back', ['W', 'S']);
  addRow(movSec, 'Move Left / Right',   ['A', 'D']);
  addRow(movSec, 'Move Up / Down',      ['Q', 'E']);

  // Camera rotation
  const rotSec = addSection(hud, 'CAMERA ROTATION');
  addRow(rotSec, 'Pitch (X-axis)', ['↑', '↓']);
  addRow(rotSec, 'Yaw (Y-axis)',   ['←', '→']);
  addRow(rotSec, 'Roll (Z-axis)',  ['Z', 'X']);

  // Camera settings
  const camSec = addSection(hud, 'CAMERA');
  const hudModeEl = document.createElement('span');
  hudModeEl.className = 'hud-value';
  addRow(camSec, 'Toggle Projective / Orthographic', ['P'], hudModeEl);
  const hudFocalEl = document.createElement('span');
  hudFocalEl.className = 'hud-value';
  addRow(camSec, 'Focal Length', ['+', '-'], hudFocalEl);
  addRow(camSec, 'Reset Camera', ['R']);

  // Lighting
  const lightSec = addSection(hud, 'LIGHTING');
  addRow(lightSec, 'Point Light',       ['1']);
  addRow(lightSec, 'Directional Light', ['2']);
  addRow(lightSec, 'Spotlight',         ['3']);
  const hudLightEl = document.createElement('span');
  hudLightEl.className = 'hud-value';
  addRow(lightSec, 'Cycle Light', ['N'], hudLightEl);

  // Shading models
  const shadeSec = addSection(hud, 'SHADING MODEL');
  addRow(shadeSec, 'Lambertian (flat / diffuse only)', ['4']);
  addRow(shadeSec, 'Phong (diffuse + specular + ambient)', ['5']);
  addRow(shadeSec, 'Toon / Cel  (quantised Phong)', ['6']);
  addRow(shadeSec, 'Blinn-Phong  (half-vector specular)', ['7']);
  addRow(shadeSec, 'Cook-Torrance  (PBR — GGX + Fresnel)', ['8']);
  const hudShadeEl = document.createElement('span');
  hudShadeEl.className = 'hud-value';
  addRow(shadeSec, 'Cycle Shading', ['M'], hudShadeEl);

  // Texture features
  const texSec = addSection(hud, 'TEXTURE FEATURES');
  const hudTexEl = document.createElement('span');
  hudTexEl.className = 'hud-value';
  addRow(texSec, 'Stone Texture — floor  (diffuse mapping)', ['T'], hudTexEl);
  const hudBumpEl = document.createElement('span');
  hudBumpEl.className = 'hud-value';
  addRow(texSec, 'Bump Mapping — all faces', ['B'], hudBumpEl);
  const hudCubeEl = document.createElement('span');
  hudCubeEl.className = 'hud-value';
  addRow(texSec, 'Env. Map — Yokohama cube map', ['C'], hudCubeEl);
  const hudProcEl = document.createElement('span');
  hudProcEl.className = 'hud-value';
  addRow(texSec, 'Procedural Checker — back wall', ['V'], hudProcEl);

  // Materials legend (static information)
  const matSec = addSection(hud, 'MATERIALS  (Cook-Torrance)');
  addRow(matSec, 'Ceiling  — Brushed Steel  (metallic)', []);
  addRow(matSec, 'Floor    — Stone Tile  (textured, rough)', []);
  addRow(matSec, 'Left     — Wood Panelling  (procedural grain)', []);
  addRow(matSec, 'Right    — Red Plastic  (smooth dielectric)', []);
  addRow(matSec, 'Front    — Rough Stone  (very rough)', []);
  addRow(matSec, 'Back     — Teal Stone / Checkerboard', []);

  const info = document.createElement('div');
  info.className   = 'hud-info';
  info.textContent = 'H — Hide / Show HUD';
  hud.appendChild(info);
  document.body.appendChild(hud);

  // Show-HUD toggle button (visible when HUD is hidden)
  const showBtn = document.createElement('button');
  showBtn.id          = 'show-hud-toggle';
  showBtn.textContent = 'Show HUD';
  showBtn.addEventListener('click', () => {
    hud.style.display     = '';
    showBtn.style.display = 'none';
  });
  document.body.appendChild(showBtn);

  // ── Live-value updaters ──────────────────────────────────────────────────────
  function updateHudCameraMode() {
    hudModeEl.textContent = camera._isProjective ? 'Projective' : 'Orthographic';
  }
  function updateHudFocal() {
    hudFocalEl.textContent = `fx:${camera._focal[0].toFixed(1)}  fy:${camera._focal[1].toFixed(1)}`;
  }
  function updateHudLight()   { hudLightEl.textContent  = LIGHT_NAMES[lightIdx]; }
  function updateHudShading() { hudShadeEl.textContent  = SHADE_NAMES[shadingIdx]; }
  function updateHudTex() {
    hudTexEl.textContent  = lightBox._showTexture ? 'ON' : 'OFF';
    hudBumpEl.textContent = lightBox._showBump    ? 'ON' : 'OFF';
    hudCubeEl.textContent = lightBox._showCubeMap ? 'ON' : 'OFF';
    hudProcEl.textContent = lightBox._showProc    ? 'ON' : 'OFF';
  }

  updateHudCameraMode();
  updateHudFocal();
  updateHudLight();
  updateHudShading();
  updateHudTex();

  // ── Keyboard interaction ─────────────────────────────────────────────────────
  window.addEventListener('keydown', (e) => {
    let cameraDirty = false;

    switch (e.key) {
      // Camera translation
      case 'w': camera.moveZ( moveStep); cameraDirty = true; break;
      case 's': camera.moveZ(-moveStep); cameraDirty = true; break;
      case 'a': camera.moveX(-moveStep); cameraDirty = true; break;
      case 'd': camera.moveX( moveStep); cameraDirty = true; break;
      case 'q': camera.moveY( moveStep); cameraDirty = true; break;
      case 'e': camera.moveY(-moveStep); cameraDirty = true; break;

      // Camera rotation
      case 'ArrowUp':    camera.rotateX(-rotStep); cameraDirty = true; break;
      case 'ArrowDown':  camera.rotateX( rotStep); cameraDirty = true; break;
      case 'ArrowLeft':  camera.rotateY(-rotStep); cameraDirty = true; break;
      case 'ArrowRight': camera.rotateY( rotStep); cameraDirty = true; break;
      case 'z': camera.rotateZ(-rotStep); cameraDirty = true; break;
      case 'x': camera.rotateZ( rotStep); cameraDirty = true; break;

      // Camera mode
      case 'p':
        camera._isProjective = !camera._isProjective;
        updateHudCameraMode();
        cameraDirty = true;
        break;

      // Focal length
      case '+': case '=':
        camera._focal[0] += 0.1;
        camera._focal[1] += 0.1;
        lightBox.updateCameraFocal();
        updateHudFocal();
        break;
      case '-':
        camera._focal[0] = Math.max(0.1, camera._focal[0] - 0.1);
        camera._focal[1] = Math.max(0.1, camera._focal[1] - 0.1);
        lightBox.updateCameraFocal();
        updateHudFocal();
        break;

      // Camera reset
      case 'r':
        camera.resetPose();
        camera._isProjective = true;
        lightBox.updateCameraFocal();
        updateHudCameraMode();
        updateHudFocal();
        cameraDirty = true;
        break;

      // Light selection
      case '1': lightIdx = LIGHT_POINT;       updateHudLight(); applyLight(); break;
      case '2': lightIdx = LIGHT_DIRECTIONAL; updateHudLight(); applyLight(); break;
      case '3': lightIdx = LIGHT_SPOT;        updateHudLight(); applyLight(); break;
      case 'n': case 'N':
        lightIdx = (lightIdx + 1) % lights.length;
        updateHudLight(); applyLight();
        break;

      // Shading model selection
      case '4': shadingIdx = SHADE_LAMBERTIAN;   updateHudShading(); applyLight(); break;
      case '5': shadingIdx = SHADE_PHONG;        updateHudShading(); applyLight(); break;
      case '6': shadingIdx = SHADE_TOON;         updateHudShading(); applyLight(); break;
      case '7': shadingIdx = SHADE_BLINNPHONG;   updateHudShading(); applyLight(); break;
      case '8': shadingIdx = SHADE_COOKTORRANCE; updateHudShading(); applyLight(); break;
      case 'm': case 'M':
        shadingIdx = (shadingIdx + 1) % SHADE_NAMES.length;
        updateHudShading(); applyLight();
        break;

      // Texture feature toggles
      case 't': case 'T':
        lightBox.setShowTexture(!lightBox._showTexture); updateHudTex(); break;
      case 'b': case 'B':
        lightBox.setShowBump(!lightBox._showBump); updateHudTex(); break;
      case 'c': case 'C':
        lightBox.setShowCubeMap(!lightBox._showCubeMap); updateHudTex(); break;
      case 'v': case 'V':
        lightBox.setShowProc(!lightBox._showProc); updateHudTex(); break;

      // HUD toggle
      case 'h': case 'H':
        if (hud.style.display === 'none') {
          hud.style.display     = '';
          showBtn.style.display = 'none';
        } else {
          hud.style.display     = 'none';
          showBtn.style.display = '';
        }
        return; // no GPU update needed

      default: return;
    }

    if (cameraDirty) {
      lightBox.updateCameraPose();
    }
  });

  // ── Render loop ───────────────────────────────────────────────────────────────
  function renderFrame() {
    renderer.render();
    requestAnimationFrame(renderFrame);
  }
  renderFrame();

  return renderer;
}

init().then(ret => {
  console.log(ret);
}).catch(error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + '<br>' + error.message;
  document.body.appendChild(pTag);
  const canvas = document.getElementById('renderCanvas');
  if (canvas) canvas.remove();
});