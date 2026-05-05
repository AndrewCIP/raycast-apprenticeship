import RayTracer       from '/lib/Viz/RayTracer.js'
import RaySphereObject from '/lib/Scene/RaySphereObject.js'
import Camera          from '/lib/Viz/3DCamera.js'
import PGA3D           from '/lib/Scene/PGA3D.js'

async function init() {
  // ── Canvas & renderer ────────────────────────────────────────────────────
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  // ── Camera ────────────────────────────────────────────────────────────────
  const camera = new Camera(
    renderer._offScreenTexture.width,
    renderer._offScreenTexture.height
  );
  // Start in projective (pinhole) mode to satisfy requirement 1
  camera._isProjective = true;

  // ── Sphere scene object ───────────────────────────────────────────────────
  const raySphere = new RaySphereObject(
    renderer._device,
    renderer._canvasFormat,
    camera,
    '/lib/Shaders/tracesphere.wgsl'
  );
  await renderer.setTracerObject(raySphere);

  // Place the ellipsoid 3 units in front of the camera so it is visible
  // immediately on load (camera starts at world origin looking along +Z).
  const SPHERE_INIT_Z = 3;
  (function placeSphereAtZ(z) {
    const t = PGA3D.createTranslator(0, 0, z);
    for (let i = 0; i < 16; i++) raySphere._ellipsoid._pose[i] = t[i];
    raySphere.updateSpherePose();
  }(SPHERE_INIT_Z));

  // ── Step sizes ────────────────────────────────────────────────────────────
  const moveStep  = 0.05;
  const rotStep   = Math.PI / 36; // 5 degrees
  const sphStep   = 0.05;
  const sphRot    = Math.PI / 36;

  // ─── Sphere-motion helpers ───────────────────────────────────────────────
  function updateSpherePoseArr(newpose) {
    for (let i = 0; i < 16; i++) raySphere._ellipsoid._pose[i] = newpose[i];
    raySphere.updateSpherePose();
    updateHudSpherePos();
  }

  function moveSphere(dx, dy, dz) {
    const dt      = PGA3D.createTranslator(dx, dy, dz);
    const newpose = PGA3D.geometricProduct(dt, raySphere._ellipsoid._pose);
    updateSpherePoseArr(newpose);
  }

  function rotateSphere(angle, ax, ay, az) {
    const center  = PGA3D.applyMotorToPoint([0, 0, 0], raySphere._ellipsoid._pose);
    const dr      = PGA3D.createRotor(angle, ax, ay, az, center[0], center[1], center[2]);
    const newpose = PGA3D.geometricProduct(dr, raySphere._ellipsoid._pose);
    updateSpherePoseArr(newpose);
  }

  function resetSphere() {
    const t = PGA3D.createTranslator(0, 0, SPHERE_INIT_Z);
    updateSpherePoseArr(t);
  }

  // ─── HUD helpers ─────────────────────────────────────────────────────────
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

  // ─── Build the HUD panel ──────────────────────────────────────────────────
  const hud = document.createElement('div');
  hud.id = 'hud';

  const titleEl = document.createElement('div');
  titleEl.className   = 'hud-title';
  titleEl.textContent = 'Ray-Traced Sphere — Scroll 11';
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

  // SPHERE TRANSLATION
  const sphMovSec = addSection(hud, 'SPHERE TRANSLATION');
  addRow(sphMovSec, 'Move Forward / Back', ['I', 'K']);
  addRow(sphMovSec, 'Move Left / Right',   ['J', 'L']);
  addRow(sphMovSec, 'Move Up / Down',      ['U', 'O']);

  // SPHERE ROTATION
  const sphRotSec = addSection(hud, 'SPHERE ROTATION');
  addRow(sphRotSec, 'Rotate X-axis', ['T', 'G']);
  addRow(sphRotSec, 'Rotate Y-axis', ['F', 'V']);
  addRow(sphRotSec, 'Rotate Z-axis', ['B', 'N']);
  addRow(sphRotSec, 'Reset Sphere',  ['M']);

  // SPHERE POSITION readout
  const sphPosSec = addSection(hud, 'SPHERE CENTER');
  const hudSpherePosEl = document.createElement('span');
  hudSpherePosEl.className = 'hud-value';
  addRow(sphPosSec, '(x, y, z)', [], hudSpherePosEl);

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

  // ─── Live-value updaters ──────────────────────────────────────────────────
  function updateHudMode() {
    hudModeEl.textContent = camera._isProjective ? 'Projective' : 'Orthographic';
  }
  function updateHudFocal() {
    hudFocalEl.textContent = camera._focal[0].toFixed(1);
  }
  function updateHudSpherePos() {
    const pos = PGA3D.applyMotorToPoint([0, 0, 0], raySphere._ellipsoid._pose);
    hudSpherePosEl.textContent =
      pos[0].toFixed(2) + ', ' + pos[1].toFixed(2) + ', ' + pos[2].toFixed(2);
  }

  updateHudMode();
  updateHudFocal();
  updateHudSpherePos();

  // ─── Keyboard interaction ─────────────────────────────────────────────────
  window.addEventListener('keydown', (e) => {
    let cameraDirty = false;

    switch (e.key) {
      // ── Camera translation ───────────────────────────────────────────────
      case 'w': camera.moveZ( moveStep);  cameraDirty = true; break;
      case 's': camera.moveZ(-moveStep);  cameraDirty = true; break;
      case 'a': camera.moveX(-moveStep);  cameraDirty = true; break;
      case 'd': camera.moveX( moveStep);  cameraDirty = true; break;
      case 'q': camera.moveY( moveStep);  cameraDirty = true; break;
      case 'e': camera.moveY(-moveStep);  cameraDirty = true; break;

      // ── Camera rotation ───────────────────────────────────────────────────
      case 'ArrowUp':    camera.rotateX(-rotStep); cameraDirty = true; break;
      case 'ArrowDown':  camera.rotateX( rotStep); cameraDirty = true; break;
      case 'ArrowLeft':  camera.rotateY(-rotStep); cameraDirty = true; break;
      case 'ArrowRight': camera.rotateY( rotStep); cameraDirty = true; break;
      case 'z': camera.rotateZ(-rotStep); cameraDirty = true; break;
      case 'x': camera.rotateZ( rotStep); cameraDirty = true; break;

      // ── Camera mode toggle ────────────────────────────────────────────────
      case 'p':
        camera._isProjective = !camera._isProjective;
        updateHudMode();
        cameraDirty = true;
        break;

      // ── Camera focal length ───────────────────────────────────────────────
      case '+': case '=':
        camera._focal[0] += 0.1;
        camera._focal[1] += 0.1;
        raySphere.updateCameraFocal();
        updateHudFocal();
        break;
      case '-':
        camera._focal[0] = Math.max(0.1, camera._focal[0] - 0.1);
        camera._focal[1] = Math.max(0.1, camera._focal[1] - 0.1);
        raySphere.updateCameraFocal();
        updateHudFocal();
        break;

      // ── Camera reset ──────────────────────────────────────────────────────
      case 'r':
        camera.resetPose();
        camera._isProjective = true;
        raySphere.updateCameraFocal(); // resetPose() also resets _focal on CPU
        updateHudMode();
        updateHudFocal();
        cameraDirty = true;
        break;

      // ── Sphere translation ────────────────────────────────────────────────
      case 'i': moveSphere( 0,       0,       sphStep); break;
      case 'k': moveSphere( 0,       0,      -sphStep); break;
      case 'j': moveSphere(-sphStep, 0,       0);       break;
      case 'l': moveSphere( sphStep, 0,       0);       break;
      case 'u': moveSphere( 0,       sphStep, 0);       break;
      case 'o': moveSphere( 0,      -sphStep, 0);       break;

      // ── Sphere rotation ───────────────────────────────────────────────────
      case 't': rotateSphere( sphRot, 1, 0, 0); break;
      case 'g': rotateSphere(-sphRot, 1, 0, 0); break;
      case 'f': rotateSphere( sphRot, 0, 1, 0); break;
      case 'v': rotateSphere(-sphRot, 0, 1, 0); break;
      case 'b': rotateSphere( sphRot, 0, 0, 1); break;
      case 'n': rotateSphere(-sphRot, 0, 0, 1); break;

      // ── Sphere reset ──────────────────────────────────────────────────────
      case 'm': resetSphere(); break;

      // ── HUD toggle ────────────────────────────────────────────────────────
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
      raySphere.updateCameraPose();
    }
  });

  // ─── Render loop ──────────────────────────────────────────────────────────
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
  pTag.innerHTML = navigator.userAgent + '</br>' + error.message;
  document.body.appendChild(pTag);
  const canvas = document.getElementById('renderCanvas');
  if (canvas) canvas.remove();
});
