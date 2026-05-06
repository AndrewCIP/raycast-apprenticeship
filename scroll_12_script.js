import RayTracer             from '/lib/Viz/RayTracer.js'
import VolumeRenderingObject from '/lib/Scene/VolumeRenderingObject.js'
import Camera                from '/lib/Viz/3DCamera.js'
import TerrainData           from '/lib/DS/TerrainData.js'

// ── Scroll12TerrainObject ────────────────────────────────────────────────────
//
// Extends VolumeRenderingObject to render a procedurally generated terrain
// volume built from Perlin noise (2-D heightmap fBm + 3-D cave carving).
// TerrainData replaces the usual file-based VolumeData as the volume source.

class Scroll12TerrainObject extends VolumeRenderingObject {
  constructor(device, canvasFormat, camera, shaderFile) {
    // Pass null as the volumeFile — createGeometry() will replace the volume
    // with a TerrainData instance before super.createGeometry() is called.
    super(device, canvasFormat, camera, null, shaderFile);
  }

  async createGeometry() {
    // Replace the dummy VolumeData(null) set by the parent constructor
    this._volume = new TerrainData();
    // Parent's createGeometry calls this._volume.init() then creates GPU buffers
    await super.createGeometry();
  }

  async createComputePipeline() {
    const make = (entry) => this._device.createComputePipeline({
      label: `Scroll12 ${entry}`,
      layout: this._pipelineLayout,
      compute: { module: this._shaderModule, entryPoint: entry },
    });

    this._computePipeline           = make('computeOrthogonalTerrainMain');
    this._computeProjectivePipeline = make('computeProjectiveTerrainMain');
  }
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function init() {
  // ── Canvas & renderer ──────────────────────────────────────────────────────
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  // ── Camera ─────────────────────────────────────────────────────────────────
  // Start in projective (perspective) mode with a tighter FOV for terrain.
  const camera = new Camera();
  camera._isProjective  = true;
  camera._focal[0]      = 2.0;
  camera._focal[1]      = 2.0;

  // Position the camera above and behind the terrain volume, looking down
  // at roughly 45 degrees for an isometric-style Minecraft view.
  //   rotateX(π/4)  → forward = (0, −0.707, +0.707)  [tilts nose downward]
  //   moveZ(−1.5)   → pulls camera back along local z  → world pos ≈ (0, 1.06, −1.06)
  //   moveY(+0.25)  → raises slightly in camera's up direction
  camera.rotateX(Math.PI / 4);
  camera.moveZ(-1.5);
  camera.moveY(0.25);

  // ── Terrain scene object ───────────────────────────────────────────────────
  const terrainObj = new Scroll12TerrainObject(
    renderer._device,
    renderer._canvasFormat,
    camera,
    '/lib/Shaders/scroll_12_vol.wgsl'
  );
  await renderer.setTracerObject(terrainObj);

  // ── Step sizes ─────────────────────────────────────────────────────────────
  const moveStep = 0.04;
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
  titleEl.textContent = 'Scroll 12 — Perlin Noise Terrain';
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

  // NOISE INFO
  const noiseSec = addSection(hud, 'PROCEDURAL GENERATION');
  const noiseInfo = document.createElement('div');
  noiseInfo.className   = 'hud-info';
  noiseInfo.textContent = 'Heightmap: noise2D + fBm  |  Caves: noise3D';
  noiseSec.appendChild(noiseInfo);

  // Bottom hint
  const info = document.createElement('div');
  info.className   = 'hud-info';
  info.textContent = 'H — Hide / Show HUD';
  hud.appendChild(info);

  document.body.appendChild(hud);

  // Show-HUD button (visible only when HUD is hidden)
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

  updateHudCameraMode();
  updateHudFocal();

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

      // ── Camera mode toggle ──────────────────────────────────────────────
      case 'p':
        camera._isProjective = !camera._isProjective;
        updateHudCameraMode();
        cameraDirty = true;
        break;

      // ── Focal length ────────────────────────────────────────────────────
      case '+': case '=':
        camera._focal[0] += 0.2;
        camera._focal[1] += 0.2;
        terrainObj.updateCameraFocal();
        updateHudFocal();
        break;
      case '-':
        camera._focal[0] = Math.max(0.2, camera._focal[0] - 0.2);
        camera._focal[1] = Math.max(0.2, camera._focal[1] - 0.2);
        terrainObj.updateCameraFocal();
        updateHudFocal();
        break;

      // ── Camera reset ────────────────────────────────────────────────────
      case 'r':
        camera.resetPose();
        camera._isProjective = true;
        camera._focal[0]     = 2.0;
        camera._focal[1]     = 2.0;
        camera.rotateX(Math.PI / 4);
        camera.moveZ(-1.5);
        camera.moveY(0.25);
        terrainObj.updateCameraFocal();
        updateHudCameraMode();
        updateHudFocal();
        cameraDirty = true;
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
      terrainObj.updateCameraPose();
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
