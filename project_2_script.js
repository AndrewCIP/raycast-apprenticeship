import Renderer from '/lib/Viz/FilteredRenderer.js'
import Standard2DFullScreenObject from "/lib/Scene/Standard2DFullScreenObject.js";
import ImageFilterObject from "/lib/Scene/ImageFilterObject.js";
import ImageNosifyFilterObject from "/lib/Scene/ImageNosifyFilterObject.js";
import Standard2DGAPosedVertexObject from '/lib/Scene/Standard2DGAPosedVertexObject.js';

async function init() {
  // Canvas
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);

  const renderer = new Renderer(canvasTag);
  await renderer.init();

  // Triangle geometry
  const vertices = new Float32Array([
    0,  0.25,
   -0.25, 0,
    0.25, 0,
  ]);

  // ---------- PGA helpers ----------
  let motorNorm = (m) =>
    Math.sqrt(m[0]*m[0] + m[1]*m[1] + m[2]*m[2] + m[3]*m[3]);

  let normalizeMotor = (m) => {
    let n = motorNorm(m);
    return n === 0 ? [1,0,0,0] : m.map(v => v / n);
  };

  // ---------- Scene ----------
  await renderer.appendSceneObject(
    new Standard2DFullScreenObject(
      renderer._device,
      renderer._canvasFormat,
      "/assets/space_background.jpg"
    )
  );

  await renderer.appendFilterObject(
    new ImageFilterObject(
      renderer._device,
      renderer._canvasFormat,
      "/lib/Shaders/grayscale.wgsl"
    )
  );

  await renderer.appendFilterObject(
    new ImageNosifyFilterObject(
      renderer._device,
      renderer._canvasFormat,
      "/lib/Shaders/nosify.wgsl"
    )
  );

  // ---------- Initial pose ----------
  let pose = new Float32Array([1, 0, 0, 0, 1, 1]);

  await renderer.appendSceneObject(
    new Standard2DGAPosedVertexObject(
      renderer._device,
      renderer._canvasFormat,
      vertices,
      pose,
      "/lib/Shaders/projective_geometric_algebra.wgsl",
      "triangle-list"
    )
  );

  // ======================================================
  // 🔵 ORBIT PARAMETERS (THIS IS WHERE RADIUS LIVES)
  // ======================================================

  let theta = 0;
  let angularSpeed = 0.03;

  let center = [0.0, 0.0];

  // ---- Choose ONE ----

  // Perfect circle
  let radius = 0.45;

  // Ellipse (comment circle out if using this)
  // let a = 0.6;   // x radius
  // let b = 0.3;   // y radius

  // ---------- Animation ----------
  setInterval(() => {
    renderer.render();

    // ---- Circle ----
    let x = center[0] + radius * Math.cos(theta);
    let y = center[1] + radius * Math.sin(theta);

    // ---- Ellipse (alternative) ----
    // let x = center[0] + a * Math.cos(theta);
    // let y = center[1] + b * Math.sin(theta);

    // Translation motor
    let m = normalizeMotor([1, 0, x / 2, y / 2]);

    pose[0] = m[0];
    pose[1] = m[1];
    pose[2] = m[2];
    pose[3] = m[3];

    theta += angularSpeed;
  }, 16); // ~60 FPS

  return renderer;
}

init().catch(error => {
  const p = document.createElement('p');
  p.innerHTML = navigator.userAgent + "<br>" + error.message;
  document.body.appendChild(p);
});
