import RayTracer        from '/lib/Viz/RayTracer.js'
import RayBoxLightObject from '/lib/Scene/RayBoxLightObject.js'
import Camera            from '/lib/Viz/3DCamera.js'
import PointLight        from '/lib/Viz/PointLight.js'
import DirectionalLight  from '/lib/Viz/DirectionalLight.js'
import SpotLight         from '/lib/Viz/SpotLight.js'

// ── Light-type and shading-model indices ─────────────────────────────────────
// These values are written into light.params[2] and light.params[3] and read
// inside scroll_13_light.wgsl to select the active light source and shading model.
const LIGHT_POINT       = 0;
const LIGHT_DIRECTIONAL = 1;
const LIGHT_SPOT        = 2;
const LIGHT_NAMES       = ['Point Light', 'Directional Light', 'Spotlight'];

const SHADE_LAMBERTIAN = 0;
const SHADE_PHONG      = 1;
const SHADE_TOON       = 2;
const SHADE_NAMES      = ['Lambertian', 'Phong', 'Toon'];

async function init() {
  // ── Canvas & renderer ──────────────────────────────────────────────────────
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  // ── Camera ─────────────────────────────────────────────────────────────────
  const camera = new Camera(
    renderer._offScreenTexture.width,
    renderer._offScreenTexture.height
  );
  camera._isProjective = true; // start in perspective mode

  // ── Lit box scene object ───────────────────────────────────────────────────
  const lightBox = new RayBoxLightObject(
    renderer._device,
    renderer._canvasFormat,
    camera,
    '/Shaders/scroll_13_light.wgsl'
  );
  await renderer.setTracerObject(lightBox);

  // ── Light source instances ─────────────────────────────────────────────────
  // Position the lights above and to one side of the box so attenuation and
  // directional differences are clearly visible.
  //
  // light.params layout (used inside the WGSL shader):
  //   [0] = spotlight cutoff angle (radians)
  //   [1] = spotlight drop-off exponent
  //   [2] = light type   — set dynamically below
  //   [3] = shading model — set dynamically below

  const pointLight = new PointLight(
    [1.5, 1.5, 1.5],       // RGB intensity (slightly bright)
    [2, 2, -1],             // world-space position: above-right, in front of box
    [1, 0.14, 0.07]         // attenuation k0, k1, k2
  );

  const dirLight = new DirectionalLight(
    [1.2, 1.2, 1.2],            // intensity
    [0.577, -0.577, 0.577]      // direction vector (from top-left-front; normalized)
  );

  const spotLight = new SpotLight(
    [2.0, 2.0, 2.0],       // intensity (brighter to compensate cone narrowing)
    [2, 2, -1],             // position — same as point light above
    [-0.667, -0.667, 0.333], // direction — pointing toward the box center
    [1, 0.14, 0.07],        // attenuation
    Math.PI / 6,            // cutoff angle: 30 degrees
    8                       // drop-off exponent (sharper falloff toward edge)
  );

  const lights = [pointLight, dirLight, spotLight];

  // ── Current state ──────────────────────────────────────────────────────────
  let lightIdx   = LIGHT_POINT;
  let shadingIdx = SHADE_PHONG; // start with Phong to demonstrate the key feature

  // Push the selected light + shading mode to GPU
  function applyLight() {
    const L = lights[lightIdx];
    L._params[2] = lightIdx;   // light type
    L._params[3] = shadingIdx; // shading model
    lightBox.updateLight(L);
  }
  applyLight();

  // ── Step sizes ─────────────────────────────────────────────────────────────
  const moveStep = 0.05;
  const rotStep  = Math.PI / 36; // 5 degrees

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

  // ── Build HUD ──────────────────────────────────────────────────────────────
  const hud = document.createElement('div');
  hud.id = 'hud';

  const titleEl = document.createElement('div');
  titleEl.className   = 'hud-title';
  titleEl.textContent = 'Scroll 13 — Lighting & Shading';
  hud.appendChild(titleEl);

  // CAMERA MOVEMENT
  const movSec = addSection(hud, 'CAMERA MOVEMENT');
  addRow(movSec, 'Move Forward / Back', ['W', 'S']);
  addRow(movSec, 'Move Left / Right',   ['A', 'D']);
  addRow(movSec, 'Move Up / Down',      ['Q', 'E']);

  // CAMERA ROTATION
  const rotSec = addSection(hud, 'CAMERA ROTATION');
  addRow(rotSec, 'Pitch (X-axis)', ['↑', '↓']);
  addRow(rotSec, 'Yaw (Y-axis)',   ['←', '→']);
  addRow(rotSec, 'Roll (Z-axis)',  ['Z', 'X']);

  // CAMERA SETTINGS
  const camSec = addSection(hud, 'CAMERA');
  const hudModeEl = document.createElement('span');
  hudModeEl.className = 'hud-value';
  addRow(camSec, 'Toggle Projective / Orthographic', ['P'], hudModeEl);
  const hudFocalEl = document.createElement('span');
  hudFocalEl.className = 'hud-value';
  addRow(camSec, 'Focal Length', ['+', '-'], hudFocalEl);
  addRow(camSec, 'Reset Camera', ['R']);

  // LIGHTING
  const lightSec = addSection(hud, 'LIGHTING');
  addRow(lightSec, 'Point Light',       ['1']);
  addRow(lightSec, 'Directional Light', ['2']);
  addRow(lightSec, 'Spotlight',         ['3']);
  const hudLightEl = document.createElement('span');
  hudLightEl.className = 'hud-value';
  addRow(lightSec, 'Cycle Light  (n/N)', ['N', 'n'], hudLightEl);

  // SHADING
  const shadeSec = addSection(hud, 'SHADING MODEL');
  addRow(shadeSec, 'Lambertian', ['4']);
  addRow(shadeSec, 'Phong',      ['5']);
  addRow(shadeSec, 'Toon',       ['6']);
  const hudShadeEl = document.createElement('span');
  hudShadeEl.className = 'hud-value';
  addRow(shadeSec, 'Cycle Shading (m/M)', ['M', 'm'], hudShadeEl);

  // Bottom hint
  const info = document.createElement('div');
  info.className   = 'hud-info';
  info.textContent = 'H — Hide / Show HUD';
  hud.appendChild(info);

  document.body.appendChild(hud);

  // Show-HUD toggle button
  const showBtn = document.createElement('button');
  showBtn.id          = 'show-hud-toggle';
  showBtn.textContent = 'Show HUD';
  showBtn.addEventListener('click', () => {
    hud.style.display     = '';
    showBtn.style.display = 'none';
  });
  document.body.appendChild(showBtn);

  // ── Live-value updaters ────────────────────────────────────────────────────
  function updateHudCameraMode() {
    hudModeEl.textContent = camera._isProjective ? 'Projective' : 'Orthographic';
  }
  function updateHudFocal() {
    hudFocalEl.textContent = `fx:${camera._focal[0].toFixed(1)}  fy:${camera._focal[1].toFixed(1)}`;
  }
  function updateHudLight() {
    hudLightEl.textContent = LIGHT_NAMES[lightIdx];
  }
  function updateHudShading() {
    hudShadeEl.textContent = SHADE_NAMES[shadingIdx];
  }

  updateHudCameraMode();
  updateHudFocal();
  updateHudLight();
  updateHudShading();

  // ── Keyboard interaction ───────────────────────────────────────────────────
  window.addEventListener('keydown', (e) => {
    let cameraDirty = false;

    switch (e.key) {
      // ── Camera translation ──────────────────────────────────────────────
      case 'w': camera.moveZ( moveStep); cameraDirty = true; break;
      case 's': camera.moveZ(-moveStep); cameraDirty = true; break;
      case 'a': camera.moveX(-moveStep); cameraDirty = true; break;
      case 'd': camera.moveX( moveStep); cameraDirty = true; break;
      case 'q': camera.moveY( moveStep); cameraDirty = true; break;
      case 'e': camera.moveY(-moveStep); cameraDirty = true; break;

      // ── Camera rotation ─────────────────────────────────────────────────
      case 'ArrowUp':    camera.rotateX(-rotStep); cameraDirty = true; break;
      case 'ArrowDown':  camera.rotateX( rotStep); cameraDirty = true; break;
      case 'ArrowLeft':  camera.rotateY(-rotStep); cameraDirty = true; break;
      case 'ArrowRight': camera.rotateY( rotStep); cameraDirty = true; break;
      case 'z': camera.rotateZ(-rotStep); cameraDirty = true; break;
      case 'x': camera.rotateZ( rotStep); cameraDirty = true; break;

      // ── Camera mode ─────────────────────────────────────────────────────
      case 'p':
        camera._isProjective = !camera._isProjective;
        updateHudCameraMode();
        cameraDirty = true;
        break;

      // ── Focal length ────────────────────────────────────────────────────
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

      // ── Camera reset ────────────────────────────────────────────────────
      case 'r':
        camera.resetPose();
        camera._isProjective = true;
        lightBox.updateCameraFocal();
        updateHudCameraMode();
        updateHudFocal();
        cameraDirty = true;
        break;

      // ── Light source selection ───────────────────────────────────────────
      case '1':
        lightIdx = LIGHT_POINT;
        updateHudLight();
        applyLight();
        break;
      case '2':
        lightIdx = LIGHT_DIRECTIONAL;
        updateHudLight();
        applyLight();
        break;
      case '3':
        lightIdx = LIGHT_SPOT;
        updateHudLight();
        applyLight();
        break;

      // Cycle through lights with n / N
      case 'n': case 'N':
        lightIdx = (lightIdx + 1) % lights.length;
        updateHudLight();
        applyLight();
        break;

      // ── Shading model selection ──────────────────────────────────────────
      case '4':
        shadingIdx = SHADE_LAMBERTIAN;
        updateHudShading();
        applyLight();
        break;
      case '5':
        shadingIdx = SHADE_PHONG;
        updateHudShading();
        applyLight();
        break;
      case '6':
        shadingIdx = SHADE_TOON;
        updateHudShading();
        applyLight();
        break;

      // Cycle through shading models with m / M
      case 'm': case 'M':
        shadingIdx = (shadingIdx + 1) % SHADE_NAMES.length;
        updateHudShading();
        applyLight();
        break;

      // ── HUD toggle ──────────────────────────────────────────────────────
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

  // ── Render loop ────────────────────────────────────────────────────────────
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
