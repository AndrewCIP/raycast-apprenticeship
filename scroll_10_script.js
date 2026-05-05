import RayTracer from '/lib/Viz/RayTracer.js'
import RayBoxObject from '/lib/Scene/RayBoxObject.js'
import Camera from '/lib/Viz/3DCamera.js'

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);

  // Create the ray tracer renderer
  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  // Create the 3D camera (width/height will be updated on resize)
  const camera = new Camera(renderer._offScreenTexture.width, renderer._offScreenTexture.height);

  // Create the ray box object using the tracebox shader
  const rayBox = new RayBoxObject(renderer._device, renderer._canvasFormat, camera, '/lib/Shaders/tracebox.wgsl');
  await renderer.setTracerObject(rayBox);

  // Movement step and rotation step
  const moveStep = 0.05;
  const rotStep = Math.PI / 36; // 5 degrees

  // ─── HUD ─────────────────────────────────────────────────────────────────

  // Helpers
  function addKey(parent, label) {
    const btn = document.createElement('span');
    btn.className = 'hud-button';
    btn.textContent = label;
    parent.appendChild(btn);
  }

  function addRow(parent, labelText, keys, liveEl) {
    const row = document.createElement('div');
    row.className = 'hud-control-row';
    const lbl = document.createElement('span');
    lbl.className = 'hud-label';
    lbl.textContent = labelText;
    row.appendChild(lbl);
    for (const k of keys) { addKey(row, k); }
    if (liveEl) { row.appendChild(liveEl); }
    parent.appendChild(row);
  }

  function addSection(hud, title) {
    const sec = document.createElement('div');
    sec.className = 'hud-section';
    const hdr = document.createElement('div');
    hdr.className = 'hud-section-header';
    hdr.textContent = title;
    sec.appendChild(hdr);
    hud.appendChild(sec);
    return sec;
  }

  // Build the HUD panel
  const hud = document.createElement('div');
  hud.id = 'hud';

  const title = document.createElement('div');
  title.className = 'hud-title';
  title.textContent = 'Ray-Traced Box — Scroll 10';
  hud.appendChild(title);

  // MOVEMENT
  const movSec = addSection(hud, 'MOVEMENT');
  addRow(movSec, 'Move Forward / Back', ['W', 'S']);
  addRow(movSec, 'Move Left / Right',   ['A', 'D']);
  addRow(movSec, 'Move Up / Down',      ['Q', 'E']);

  // ROTATION
  const rotSec = addSection(hud, 'ROTATION');
  addRow(rotSec, 'Pitch (X-axis)', ['↑', '↓']);
  addRow(rotSec, 'Yaw (Y-axis)',   ['←', '→']);
  addRow(rotSec, 'Roll (Z-axis)',  ['Z', 'X']);

  // CAMERA
  const camSec = addSection(hud, 'CAMERA');

  const hudModeEl = document.createElement('span');
  hudModeEl.className = 'hud-value';
  addRow(camSec, 'Toggle Projective / Orthographic', ['P'], hudModeEl);

  const hudFocalEl = document.createElement('span');
  hudFocalEl.className = 'hud-value';
  addRow(camSec, 'Focal Length', ['+', '−'], hudFocalEl);

  addRow(camSec, 'Reset Pose', ['R']);

  // INFO
  const info = document.createElement('div');
  info.className = 'hud-info';
  info.textContent = 'H — Hide / Show HUD';
  hud.appendChild(info);

  document.body.appendChild(hud);

  // Show-HUD button (visible only when HUD is hidden)
  const showBtn = document.createElement('button');
  showBtn.id = 'show-hud-toggle';
  showBtn.textContent = 'Show HUD';
  showBtn.addEventListener('click', () => {
    hud.style.display = '';
    showBtn.style.display = 'none';
  });
  document.body.appendChild(showBtn);

  // Live-value helpers
  function updateHudMode() {
    hudModeEl.textContent = camera._isProjective ? 'Projective' : 'Orthographic';
  }
  function updateHudFocal() {
    hudFocalEl.textContent = camera._focal[0].toFixed(1);
  }
  updateHudMode();
  updateHudFocal();

  // ─────────────────────────────────────────────────────────────────────────

  // Keyboard interaction for camera control
  window.addEventListener('keydown', (e) => {
    switch (e.key) {
      // Translation controls (WASD + QE for z)
      case 'w': camera.moveZ(moveStep);  break;
      case 's': camera.moveZ(-moveStep); break;
      case 'a': camera.moveX(-moveStep); break;
      case 'd': camera.moveX(moveStep);  break;
      case 'q': camera.moveY(moveStep);  break;
      case 'e': camera.moveY(-moveStep); break;

      // Rotation controls (arrow keys for X/Y pitch/yaw, letter keys z/x for Z-axis roll)
      case 'ArrowUp':    camera.rotateX(-rotStep); break;
      case 'ArrowDown':  camera.rotateX(rotStep);  break;
      case 'ArrowLeft':  camera.rotateY(-rotStep); break;
      case 'ArrowRight': camera.rotateY(rotStep);  break;
      case 'z': camera.rotateZ(-rotStep); break;
      case 'x': camera.rotateZ(rotStep);  break;

      // Toggle between orthogonal and projective camera
      case 'p':
        camera._isProjective = !camera._isProjective;
        updateHudMode();
        console.log('Projective mode:', camera._isProjective);
        break;

      // Reset pose
      case 'r':
        camera.resetPose();
        break;

      // Focal length adjustments
      case '+':
      case '=':
        camera._focal[0] += 0.1;
        camera._focal[1] += 0.1;
        rayBox.updateCameraFocal();
        updateHudFocal();
        console.log('Focal:', camera._focal[0].toFixed(2));
        break;
      case '-':
        camera._focal[0] = Math.max(0.1, camera._focal[0] - 0.1);
        camera._focal[1] = Math.max(0.1, camera._focal[1] - 0.1);
        rayBox.updateCameraFocal();
        updateHudFocal();
        console.log('Focal:', camera._focal[0].toFixed(2));
        break;

      // Toggle HUD visibility
      case 'h':
      case 'H':
        if (hud.style.display === 'none') {
          hud.style.display = '';
          showBtn.style.display = 'none';
        } else {
          hud.style.display = 'none';
          showBtn.style.display = '';
        }
        return; // no camera update needed

      default: return;
    }
    // After any camera pose change, push updated pose to GPU
    rayBox.updateCameraPose();
  });

  // Render loop
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
  pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
  document.body.appendChild(pTag);
  document.getElementById("renderCanvas").remove();
});
