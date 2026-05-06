import RayTracer        from '/lib/Viz/RayTracer.js'
import RayBoxLightObject from '/lib/Scene/RayBoxLightObject.js'
import Camera            from '/lib/Viz/3DCamera.js'
import PointLight        from '/lib/Viz/PointLight.js'
import DirectionalLight  from '/lib/Viz/DirectionalLight.js'
import SpotLight         from '/lib/Viz/SpotLight.js'

// ── Mode constants ────────────────────────────────────────────────────────────
const LIGHT_POINT       = 0;
const LIGHT_DIRECTIONAL = 1;
const LIGHT_SPOT        = 2;
const LIGHT_NAMES       = ['Point Light', 'Directional Light', 'Spotlight'];

const SHADE_LAMBERTIAN = 0;
const SHADE_PHONG      = 1;
const SHADE_TOON       = 2;
const SHADE_NAMES      = ['Lambertian', 'Phong', 'Toon'];

const SHADOW_HARD = 0;
const SHADOW_AREA = 1;
const SHADOW_PCF  = 2;
const SHADOW_DIST = 3;
const SHADOW_SDF  = 4;
const SHADOW_NAMES = [
  'Hard Shadow',
  'Area Light Sampling',
  'Percentage-Closer Filtering',
  'Distance-Based',
  'SDF (Quilez)',
];

// Each shadow technique is paired with the light type that showcases it best.
// Switching shadow mode also auto-selects the matching light type.
const SHADOW_PREFERRED_LIGHT = [
  LIGHT_POINT,       // Hard  → any, use point
  LIGHT_POINT,       // Area  → point light
  LIGHT_DIRECTIONAL, // PCF   → directional
  LIGHT_SPOT,        // Dist  → spotlight
  LIGHT_POINT,       // SDF   → any, use point
];

const REFLECT_OFF    = 0;
const REFLECT_SINGLE = 1;
const REFLECT_MULTI  = 2;
const REFLECT_NAMES  = ['Off', 'Single Bounce', 'Multi-Bounce'];

const REFRACT_OFF    = 0;
const REFRACT_SINGLE = 1;
const REFRACT_MULTI  = 2;
const REFRACT_NAMES  = ['Off (Opaque Glass)', 'Single Bounce', 'Multi-Bounce'];

// ── RayBoxReflectRefractObject ─────────────────────────────────────────────────
// Extends RayBoxLightObject (bindings 0–3: camera, box, texture, light) with
// a RenderFlags uniform buffer at binding 4.
//
// RenderFlags layout (8 × u32 = 32 bytes):
//   [0] shadowEnabled   [1] shadowMode   [2] reflectMode   [3] refractMode
//   [4] shadowTransp    [5] maxBounces   [6] pad            [7] pad
class RayBoxReflectRefractObject extends RayBoxLightObject {
  constructor(device, canvasFormat, camera, shaderFile) {
    super(device, canvasFormat, camera, shaderFile);
    this._shadowEnabled = true;
    this._shadowMode    = SHADOW_HARD;
    this._reflectMode   = REFLECT_MULTI;
    this._refractMode   = REFRACT_MULTI;
    this._shadowTransp  = false;
    this._maxBounces    = 4;
  }

  async createGeometry() {
    await super.createGeometry();

    // Render-flags uniform buffer (8 × u32 = 32 bytes)
    this._renderFlagsBuffer = this._device.createBuffer({
      label: 'RenderFlags Buffer',
      size:  32,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });
    this._updateRenderFlags();
  }

  _updateRenderFlags() {
    this._device.queue.writeBuffer(
      this._renderFlagsBuffer, 0,
      new Uint32Array([
        this._shadowEnabled ? 1 : 0,
        this._shadowMode,
        this._reflectMode,
        this._refractMode,
        this._shadowTransp ? 1 : 0,
        this._maxBounces,
        0, 0,
      ])
    );
  }

  setShadowEnabled(v)  { this._shadowEnabled = v; this._updateRenderFlags(); }
  setShadowMode(v)     { this._shadowMode    = v; this._updateRenderFlags(); }
  setReflectMode(v)    { this._reflectMode   = v; this._updateRenderFlags(); }
  setRefractMode(v)    { this._refractMode   = v; this._updateRenderFlags(); }
  setShadowTransp(v)   { this._shadowTransp  = v; this._updateRenderFlags(); }
  setMaxBounces(v)     { this._maxBounces    = Math.max(0, Math.min(8, v)); this._updateRenderFlags(); }

  async createShaders() {
    await super.createShaders();

    // Override bind-group layout to add binding 4 (renderFlagsBuffer)
    this._bindGroupLayout = this._device.createBindGroupLayout({
      label: 'Project9 Bind Group Layout',
      entries: [
        { binding: 0, visibility: GPUShaderStage.COMPUTE, buffer: {} },
        { binding: 1, visibility: GPUShaderStage.COMPUTE, buffer: {} },
        { binding: 2, visibility: GPUShaderStage.COMPUTE, storageTexture: { format: this._canvasFormat } },
        { binding: 3, visibility: GPUShaderStage.COMPUTE, buffer: {} },
        { binding: 4, visibility: GPUShaderStage.COMPUTE, buffer: {} },
      ],
    });

    this._pipelineLayout = this._device.createPipelineLayout({
      label:            'Project9 Pipeline Layout',
      bindGroupLayouts: [this._bindGroupLayout],
    });
  }

  createBindGroup(outTexture) {
    this._bindGroup = this._device.createBindGroup({
      label:  'Project9 Bind Group',
      layout: this._computePipeline.getBindGroupLayout(0),
      entries: [
        { binding: 0, resource: { buffer: this._cameraBuffer } },
        { binding: 1, resource: { buffer: this._boxBuffer } },
        { binding: 2, resource: outTexture.createView() },
        { binding: 3, resource: { buffer: this._lightBuffer } },
        { binding: 4, resource: { buffer: this._renderFlagsBuffer } },
      ],
    });
    this._wgWidth  = Math.ceil(outTexture.width);
    this._wgHeight = Math.ceil(outTexture.height);
  }
}

// ── Main ──────────────────────────────────────────────────────────────────────
async function init() {
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  const camera = new Camera(
    renderer._offScreenTexture.width,
    renderer._offScreenTexture.height
  );
  camera._isProjective = true;

  const scene = new RayBoxReflectRefractObject(
    renderer._device,
    renderer._canvasFormat,
    camera,
    '/project_9_light.wgsl'
  );
  await renderer.setTracerObject(scene);

  // ── Light sources ─────────────────────────────────────────────────────────
  // All positions/directions are in camera-space.
  // At startup (identity camera motor) camera-space equals world-space, so the
  // box interior spans [−0.5, +0.5]³.
  //
  //  • Point light   – near the ceiling, slightly off-centre.
  //  • Directional   – comes from above-left-back (good for PCF demo).
  //  • Spotlight     – directly above, aimed straight down (distance-shadow demo).
  const pointLight = new PointLight(
    [1.8, 1.8, 1.8],          // intensity
    [0.05, 0.38, 0.0],        // position: inside box near ceiling
    [1.0, 0.05, 0.005]        // attenuation (minimal falloff at short range)
  );
  const dirLight = new DirectionalLight(
    [1.4, 1.4, 1.4],
    [-0.2, -0.9, 0.2]         // direction vector (will be normalised in shader)
  );
  const spotLight = new SpotLight(
    [2.5, 2.5, 2.5],          // intensity
    [0.0, 0.44, 0.0],         // position: just below ceiling
    [0.0, -1.0, 0.0],         // direction: straight down
    [1.0, 0.05, 0.005],
    Math.PI / 5,              // cutoff: 36° half-angle
    8                         // dropoff
  );
  const lights = [pointLight, dirLight, spotLight];

  let lightIdx   = LIGHT_POINT;
  let shadingIdx = SHADE_PHONG;

  function applyLight() {
    const L = lights[lightIdx];
    L._params[2] = lightIdx;
    L._params[3] = shadingIdx;
    scene.updateLight(L);
  }
  applyLight();

  const moveStep = 0.05;
  const rotStep  = Math.PI / 36;

  // ── HUD helpers ────────────────────────────────────────────────────────────
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
  function liveEl() {
    const el = document.createElement('span');
    el.className = 'hud-value';
    return el;
  }

  // ── Build HUD ──────────────────────────────────────────────────────────────
  const hud = document.createElement('div');
  hud.id = 'hud';

  const titleEl = document.createElement('div');
  titleEl.className   = 'hud-title';
  titleEl.textContent = 'Project 9 — Shadows · Reflections · Refractions';
  hud.appendChild(titleEl);

  // Camera movement
  const movSec = addSection(hud, 'CAMERA MOVEMENT');
  addRow(movSec, 'Forward / Back',   ['W', 'S']);
  addRow(movSec, 'Left / Right',     ['A', 'D']);
  addRow(movSec, 'Up / Down',        ['Q', 'E']);

  // Camera rotation
  const rotSec = addSection(hud, 'CAMERA ROTATION');
  addRow(rotSec, 'Pitch (X-axis)',   ['↑', '↓']);
  addRow(rotSec, 'Yaw   (Y-axis)',   ['←', '→']);
  addRow(rotSec, 'Roll  (Z-axis)',   ['Z', 'X']);

  // Camera settings
  const camSec = addSection(hud, 'CAMERA');
  const hudCamModeEl = liveEl();
  addRow(camSec, 'Projective / Orthographic', ['P'], hudCamModeEl);
  const hudFocalEl = liveEl();
  addRow(camSec, 'Focal Length',     ['+', '−'], hudFocalEl);
  addRow(camSec, 'Reset Camera',     ['R']);

  // Lighting
  const lightSec = addSection(hud, 'LIGHTING');
  addRow(lightSec, 'Point Light',       ['1']);
  addRow(lightSec, 'Directional Light', ['2']);
  addRow(lightSec, 'Spotlight',         ['3']);
  const hudLightEl = liveEl();
  addRow(lightSec, 'Cycle Light', ['N'], hudLightEl);
  addRow(lightSec, 'Lambert / Phong / Toon', ['4', '5', '6']);
  const hudShadeEl = liveEl();
  addRow(lightSec, 'Cycle Shading', ['M'], hudShadeEl);

  // Shadows
  const shadowSec = addSection(hud, 'SHADOWS');
  const hudShadowEl = liveEl();
  addRow(shadowSec, 'Toggle Shadows', ['O'], hudShadowEl);
  const hudShadowModeEl = liveEl();
  addRow(shadowSec, 'Cycle Shadow Mode', ['K'], hudShadowModeEl);
  const hudTranspEl = liveEl();
  addRow(shadowSec, 'Glass Casts Transparent Shadow', ['T'], hudTranspEl);

  // Reflections
  const reflSec = addSection(hud, 'REFLECTIONS');
  const hudReflEl = liveEl();
  addRow(reflSec, 'Cycle Mode  (mirror + floor)', ['F'], hudReflEl);
  const hudBouncesEl = liveEl();
  addRow(reflSec, 'Max Bounces', ['[', ']'], hudBouncesEl);

  // Refractions
  const refrSec = addSection(hud, 'REFRACTIONS');
  const hudRefrEl = liveEl();
  addRow(refrSec, 'Cycle Mode  (glass sphere)', ['G'], hudRefrEl);

  const info = document.createElement('div');
  info.className   = 'hud-info';
  info.textContent = 'H — Hide / Show HUD';
  hud.appendChild(info);
  document.body.appendChild(hud);

  const showBtn = document.createElement('button');
  showBtn.id          = 'show-hud-toggle';
  showBtn.textContent = 'Show HUD';
  showBtn.addEventListener('click', () => {
    hud.style.display     = '';
    showBtn.style.display = 'none';
  });
  document.body.appendChild(showBtn);

  // ── HUD value updaters ────────────────────────────────────────────────────
  function updateHudCamMode()   { hudCamModeEl.textContent  = camera._isProjective ? 'Projective' : 'Orthographic'; }
  function updateHudFocal()     { hudFocalEl.textContent     = camera._focal[0].toFixed(1); }
  function updateHudLight()     { hudLightEl.textContent     = LIGHT_NAMES[lightIdx]; }
  function updateHudShading()   { hudShadeEl.textContent     = SHADE_NAMES[shadingIdx]; }
  function updateHudShadow()    {
    hudShadowEl.textContent     = scene._shadowEnabled ? 'ON' : 'OFF';
    hudShadowModeEl.textContent = SHADOW_NAMES[scene._shadowMode];
  }
  function updateHudTransp()    { hudTranspEl.textContent    = scene._shadowTransp ? 'ON' : 'OFF'; }
  function updateHudReflect()   { hudReflEl.textContent      = REFLECT_NAMES[scene._reflectMode]; }
  function updateHudRefract()   { hudRefrEl.textContent      = REFRACT_NAMES[scene._refractMode]; }
  function updateHudBounces()   { hudBouncesEl.textContent   = String(scene._maxBounces); }

  // Initialise all HUD values
  updateHudCamMode();
  updateHudFocal();
  updateHudLight();
  updateHudShading();
  updateHudShadow();
  updateHudTransp();
  updateHudReflect();
  updateHudRefract();
  updateHudBounces();

  // ── Keyboard handler ───────────────────────────────────────────────────────
  window.addEventListener('keydown', (e) => {
    let cameraDirty = false;
    switch (e.key) {

      // ── Camera translation ────────────────────────────────────────────────
      case 'w': camera.moveZ( moveStep); cameraDirty = true; break;
      case 's': camera.moveZ(-moveStep); cameraDirty = true; break;
      case 'a': camera.moveX(-moveStep); cameraDirty = true; break;
      case 'd': camera.moveX( moveStep); cameraDirty = true; break;
      case 'q': camera.moveY( moveStep); cameraDirty = true; break;
      case 'e': camera.moveY(-moveStep); cameraDirty = true; break;

      // ── Camera rotation ───────────────────────────────────────────────────
      case 'ArrowUp':    camera.rotateX(-rotStep); cameraDirty = true; break;
      case 'ArrowDown':  camera.rotateX( rotStep); cameraDirty = true; break;
      case 'ArrowLeft':  camera.rotateY(-rotStep); cameraDirty = true; break;
      case 'ArrowRight': camera.rotateY( rotStep); cameraDirty = true; break;
      case 'z': camera.rotateZ(-rotStep); cameraDirty = true; break;
      case 'x': camera.rotateZ( rotStep); cameraDirty = true; break;

      // ── Camera mode ───────────────────────────────────────────────────────
      case 'p':
        camera._isProjective = !camera._isProjective;
        updateHudCamMode(); cameraDirty = true; break;

      // ── Focal length ──────────────────────────────────────────────────────
      case '+': case '=':
        camera._focal[0] += 0.1; camera._focal[1] += 0.1;
        scene.updateCameraFocal(); updateHudFocal(); break;
      case '-':
        camera._focal[0] = Math.max(0.1, camera._focal[0] - 0.1);
        camera._focal[1] = Math.max(0.1, camera._focal[1] - 0.1);
        scene.updateCameraFocal(); updateHudFocal(); break;

      // ── Camera reset ──────────────────────────────────────────────────────
      case 'r':
        camera.resetPose();
        camera._isProjective = true;
        scene.updateCameraFocal();
        updateHudCamMode(); updateHudFocal();
        cameraDirty = true; break;

      // ── Light selection ───────────────────────────────────────────────────
      case '1': lightIdx = LIGHT_POINT;       updateHudLight(); applyLight(); break;
      case '2': lightIdx = LIGHT_DIRECTIONAL; updateHudLight(); applyLight(); break;
      case '3': lightIdx = LIGHT_SPOT;        updateHudLight(); applyLight(); break;
      case 'n': case 'N':
        lightIdx = (lightIdx + 1) % lights.length;
        updateHudLight(); applyLight(); break;

      // ── Shading model ─────────────────────────────────────────────────────
      case '4': shadingIdx = SHADE_LAMBERTIAN; updateHudShading(); applyLight(); break;
      case '5': shadingIdx = SHADE_PHONG;      updateHudShading(); applyLight(); break;
      case '6': shadingIdx = SHADE_TOON;       updateHudShading(); applyLight(); break;
      case 'm': case 'M':
        shadingIdx = (shadingIdx + 1) % SHADE_NAMES.length;
        updateHudShading(); applyLight(); break;

      // ── Shadow toggles ────────────────────────────────────────────────────
      case 'o': case 'O':
        scene.setShadowEnabled(!scene._shadowEnabled);
        updateHudShadow(); break;

      case 'k': case 'K': {
        // Cycle shadow mode; also switch to the recommended light type so the
        // selected technique is immediately visible.
        const next = (scene._shadowMode + 1) % SHADOW_NAMES.length;
        scene.setShadowMode(next);
        lightIdx = SHADOW_PREFERRED_LIGHT[next];
        updateHudShadow(); updateHudLight(); applyLight();
        break;
      }

      case 't': case 'T':
        scene.setShadowTransp(!scene._shadowTransp);
        updateHudTransp(); break;

      // ── Reflection mode ───────────────────────────────────────────────────
      case 'f': case 'F':
        scene.setReflectMode((scene._reflectMode + 1) % REFLECT_NAMES.length);
        updateHudReflect(); break;

      // ── Refraction mode ───────────────────────────────────────────────────
      case 'g': case 'G':
        scene.setRefractMode((scene._refractMode + 1) % REFRACT_NAMES.length);
        updateHudRefract(); break;

      // ── Max bounces ───────────────────────────────────────────────────────
      case '[': case '{':
        scene.setMaxBounces(scene._maxBounces - 1);
        updateHudBounces(); break;
      case ']': case '}':
        scene.setMaxBounces(scene._maxBounces + 1);
        updateHudBounces(); break;

      // ── HUD toggle ────────────────────────────────────────────────────────
      case 'h': case 'H':
        if (hud.style.display === 'none') {
          hud.style.display = ''; showBtn.style.display = 'none';
        } else {
          hud.style.display = 'none'; showBtn.style.display = '';
        }
        return;

      default: return;
    }

    if (cameraDirty) scene.updateCameraPose();
  });

  // ── Render loop ───────────────────────────────────────────────────────────
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
  const p = document.createElement('p');
  p.innerHTML = navigator.userAgent + '<br>' + error.message;
  document.body.appendChild(p);
  const canvas = document.getElementById('renderCanvas');
  if (canvas) canvas.remove();
});
