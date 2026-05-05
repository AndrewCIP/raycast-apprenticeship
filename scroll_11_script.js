import RayTracer             from '/lib/Viz/RayTracer.js'
import VolumeRenderingObject from '/lib/Scene/VolumeRenderingObject.js'
import Camera                from '/lib/Viz/3DCamera.js'

// ── Rendering mode constants ─────────────────────────────────────────────────
const MODE_MIP   = 0;
const MODE_DRR   = 1;
const MODE_DEPTH = 2;
const MODE_NAMES = ['MIP (Maximum Intensity)', 'DRR (Beer–Lambert)', 'Depth (False Color)'];

// ── Scroll11VolumeObject ─────────────────────────────────────────────────────
//
// Extends VolumeRenderingObject to support three rendering modes (MIP, DRR,
// Depth) by creating six compute pipelines (mode × camera type) and selecting
// the correct one each frame based on the current mode and camera setting.

class Scroll11VolumeObject extends VolumeRenderingObject {
  constructor(device, canvasFormat, camera, volumeFile, shaderFile) {
    super(device, canvasFormat, camera, volumeFile, shaderFile);
    this._mode = MODE_MIP;
  }

  setMode(mode) {
    this._mode = mode;
  }

  async createComputePipeline() {
    // Helper to build a compute pipeline for a given entry point
    const make = (entryPoint) => this._device.createComputePipeline({
      label: `Scroll11 ${entryPoint}`,
      layout: this._pipelineLayout,
      compute: { module: this._shaderModule, entryPoint },
    });

    // _pipelines[mode][isProjective ? 1 : 0]
    this._pipelines = [
      [make('computeOrthogonalMIPMain'),   make('computeProjectiveMIPMain')],
      [make('computeOrthogonalDRRMain'),   make('computeProjectiveDRRMain')],
      [make('computeOrthogonalDepthMain'), make('computeProjectiveDepthMain')],
    ];

    // The parent class uses _computePipeline to build the bind group layout;
    // point it at one of our pipelines so createBindGroup works correctly.
    this._computePipeline           = this._pipelines[0][0];
    this._computeProjectivePipeline = this._pipelines[0][1];
  }

  compute(pass) {
    const projIdx = this._camera._isProjective ? 1 : 0;
    pass.setPipeline(this._pipelines[this._mode][projIdx]);
    pass.setBindGroup(0, this._bindGroup);
    pass.dispatchWorkgroups(
      Math.ceil(this._wgWidth  / 16),
      Math.ceil(this._wgHeight / 16)
    );
  }
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function init() {
  // ── Canvas & renderer ────────────────────────────────────────────────────
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  // ── Camera ────────────────────────────────────────────────────────────────
  // Start in orthographic mode so the full volume is visible on load.
  const camera = new Camera();
  camera._isProjective = false;

  // ── Volume scene object ───────────────────────────────────────────────────
  const volObj = new Scroll11VolumeObject(
    renderer._device,
    renderer._canvasFormat,
    camera,
    '/assets/brainweb-t1-1mm-pn0-rf0.raws',
    '/scroll_11_vol.wgsl'
  );
  await renderer.setTracerObject(volObj);

  // ── Step sizes ────────────────────────────────────────────────────────────
  const moveStep = 0.05;
  const rotStep  = Math.PI / 36; // 5 degrees

  // ── HUD helpers ───────────────────────────────────────────────────────────
  function addKey(parent, label) {
    const btn = document.createElement('span');
    btn.className   = 'hud-button';
    btn.textContent = label;
    parent.appendChild(btn);
  }

  function addRow(parent, labelText, keys, liveEl) {
    const row = document.createElement('div');
    row.className   = 'hud-control-row';
    const lbl = document.createElement('span');
    lbl.className   = 'hud-label';
    lbl.textContent = labelText;
    row.appendChild(lbl);
    for (const k of keys) { addKey(row, k); }
    if (liveEl) { row.appendChild(liveEl); }
    parent.appendChild(row);
  }

  function addSection(hud, title) {
    const sec = document.createElement('div');
    sec.className   = 'hud-section';
    const hdr = document.createElement('div');
    hdr.className   = 'hud-section-header';
    hdr.textContent = title;
    sec.appendChild(hdr);
    hud.appendChild(sec);
    return sec;
  }

  // ── Build HUD ─────────────────────────────────────────────────────────────
  const hud = document.createElement('div');
  hud.id = 'hud';

  const titleEl = document.createElement('div');
  titleEl.className   = 'hud-title';
  titleEl.textContent = 'Scroll 11 — Volume Rendering';
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

  // RENDERING MODE
  const renderSec = addSection(hud, 'RENDERING MODE');
  addRow(renderSec, 'Maximum Intensity Projection',    ['1']);
  addRow(renderSec, 'DRR (Beer–Lambert absorption)',   ['2']);
  addRow(renderSec, 'Depth false-color encoding',      ['3']);

  const hudRenderModeEl = document.createElement('span');
  hudRenderModeEl.className = 'hud-value';
  const renderModeRow = document.createElement('div');
  renderModeRow.className   = 'hud-control-row';
  const renderModeLbl = document.createElement('span');
  renderModeLbl.className   = 'hud-label';
  renderModeLbl.textContent = 'Active mode';
  renderModeRow.appendChild(renderModeLbl);
  renderModeRow.appendChild(hudRenderModeEl);
  renderSec.appendChild(renderModeRow);

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

  // ── Live-value updaters ───────────────────────────────────────────────────
  function updateHudCameraMode() {
    hudModeEl.textContent = camera._isProjective ? 'Projective' : 'Orthographic';
  }
  function updateHudFocal() {
    hudFocalEl.textContent = camera._focal[0].toFixed(1);
  }
  function updateHudRenderMode() {
    hudRenderModeEl.textContent = MODE_NAMES[volObj._mode];
  }

  updateHudCameraMode();
  updateHudFocal();
  updateHudRenderMode();

  // ── Keyboard interaction ──────────────────────────────────────────────────
  window.addEventListener('keydown', (e) => {
    let cameraDirty = false;

    switch (e.key) {
      // ── Camera translation ─────────────────────────────────────────────
      case 'w': camera.moveZ( moveStep); cameraDirty = true; break;
      case 's': camera.moveZ(-moveStep); cameraDirty = true; break;
      case 'a': camera.moveX(-moveStep); cameraDirty = true; break;
      case 'd': camera.moveX( moveStep); cameraDirty = true; break;
      case 'q': camera.moveY( moveStep); cameraDirty = true; break;
      case 'e': camera.moveY(-moveStep); cameraDirty = true; break;

      // ── Camera rotation ────────────────────────────────────────────────
      case 'ArrowUp':    camera.rotateX(-rotStep); cameraDirty = true; break;
      case 'ArrowDown':  camera.rotateX( rotStep); cameraDirty = true; break;
      case 'ArrowLeft':  camera.rotateY(-rotStep); cameraDirty = true; break;
      case 'ArrowRight': camera.rotateY( rotStep); cameraDirty = true; break;
      case 'z': camera.rotateZ(-rotStep); cameraDirty = true; break;
      case 'x': camera.rotateZ( rotStep); cameraDirty = true; break;

      // ── Camera mode toggle ─────────────────────────────────────────────
      case 'p':
        camera._isProjective = !camera._isProjective;
        updateHudCameraMode();
        cameraDirty = true;
        break;

      // ── Focal length ───────────────────────────────────────────────────
      case '+': case '=':
        camera._focal[0] += 0.1;
        camera._focal[1] += 0.1;
        volObj.updateCameraFocal();
        updateHudFocal();
        break;
      case '-':
        camera._focal[0] = Math.max(0.1, camera._focal[0] - 0.1);
        camera._focal[1] = Math.max(0.1, camera._focal[1] - 0.1);
        volObj.updateCameraFocal();
        updateHudFocal();
        break;

      // ── Camera reset ───────────────────────────────────────────────────
      case 'r':
        camera.resetPose();
        camera._isProjective = false;
        volObj.updateCameraFocal();
        updateHudCameraMode();
        updateHudFocal();
        cameraDirty = true;
        break;

      // ── Rendering mode ─────────────────────────────────────────────────
      case '1':
        volObj.setMode(MODE_MIP);
        updateHudRenderMode();
        break;
      case '2':
        volObj.setMode(MODE_DRR);
        updateHudRenderMode();
        break;
      case '3':
        volObj.setMode(MODE_DEPTH);
        updateHudRenderMode();
        break;

      // ── HUD toggle ─────────────────────────────────────────────────────
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
      volObj.updateCameraPose();
    }
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
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + '<br>' + error.message;
  document.body.appendChild(pTag);
  const canvas = document.getElementById('renderCanvas');
  if (canvas) canvas.remove();
});