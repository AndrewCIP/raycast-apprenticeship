import Renderer from '/lib/Viz/FilteredRenderer.js'
import Standard2DFullScreenObject from "/lib/Scene/Standard2DFullScreenObject.js";
import ImageFilterObject from "/lib/Scene/ImageFilterObject.js";
import ImageNosifyFilterObject from "/lib/Scene/ImageNosifyFilterObject.js";
import Standard2DGAPosedVertexObject from '/lib/Scene/Standard2DGAPosedVertexObject.js';
import PlanetObject from '/lib/Scene/PlanetObject.js';

// Requirements (3/6)
// [x] A space-like background using an image texture.
// [x] Apply grayscale filter.
// [x] At least one orbit is elliptical.
// [] Use simple shapes and colors to present celestial bodies and orbits.


/* --------------------------------------------------
   Utility Functions (unchanged GA helpers)
-------------------------------------------------- */

let motorNorm = (m) =>
  Math.sqrt(m[0]*m[0] + m[1]*m[1] + m[2]*m[2] + m[3]*m[3]);

let normalizeMotor = (m) => {
  let n = motorNorm(m);
  if (n === 0) return [1,0,0,0];
  return [m[0]/n, m[1]/n, m[2]/n, m[3]/n];
};

/* --------------------------------------------------
   Main Init
-------------------------------------------------- */

async function init() {

  // Canvas
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);

  // Renderer
  const renderer = new Renderer(canvasTag);
  await renderer.init();

  const planet = new PlanetObject(renderer._device, renderer._canvasFormat, 0.05, 48);

  // initial motor
  let pose0 = normalizeMotor([1, 0, -0.3, 0]);
  let pose1 = normalizeMotor([1, 0,  0.3, 0]);

  let pose = new Float32Array([
    pose0[0], pose0[1],
    pose0[2], pose0[3],
    1, 1
  ]);

  // Geometry (triangle)
  const vertices = new Float32Array([
     0,   0.25,
    -0.25, 0,
     0.25, 0
  ]);

  /* --------------------------------------------------
     Scene Objects
  -------------------------------------------------- */

  // Background
  await renderer.appendSceneObject(
    new Standard2DFullScreenObject(
      renderer._device,
      renderer._canvasFormat,
      "/assets/space_background.jpg"
    )
  );

  // Filters
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

  /* --------------------------------------------------
     Orbiting Objects System
  -------------------------------------------------- */

  const orbitingObjects = [];

  async function createOrbitingObject({
    radius = 0.4,
    speed = 0.02,
    center = [0, 0],
    ellipse = null
  }) {

    // ---- ORBIT LINE ----
  await renderer.appendSceneObject(
    new OrbitLine(
      renderer._device,
      renderer._canvasFormat,
      { center, radius, ellipse }
    )
  );

    const pose = new Float32Array([1, 0, 0, 0, 1, 1]);

    await renderer.appendSceneObject(
      new Standard2DGAPosedVertexObject(
        renderer._device,
        renderer._canvasFormat,
        planet._vertices,
        pose,
        "/lib/Shaders/projective_geometric_algebra.wgsl",
        "triangle-list"
      )
    );

    orbitingObjects.push({
      pose,
      theta: Math.random() * Math.PI * 2,
      speed,
      center,
      radius,
      ellipse
    });
  }

  /* --------------------------------------------------
     Create Multiple Orbits
  -------------------------------------------------- */

  // Perfect circle
  await createOrbitingObject({
    radius: 0.40,
    speed: 0.02
  });

  // Smaller counter-rotating circle
  await createOrbitingObject({
    radius: 0.25,
    speed: 0.035
  });

  // Elliptical orbit
  await createOrbitingObject({
    ellipse: { a: 0.6, b: 0.3 },
    speed: 0.015
  });

  /* --------------------------------------------------
     Animation Loop
  -------------------------------------------------- */

  setInterval(() => {
    renderer.render();

    for (const obj of orbitingObjects) {

      let x, y;

      // ---- Circle ----
      if (!obj.ellipse) {
        x = obj.center[0] + obj.radius * Math.cos(obj.theta);
        y = obj.center[1] + obj.radius * Math.sin(obj.theta);
      }
      // ---- Ellipse ----
      else {
        x = obj.center[0] + obj.ellipse.a * Math.cos(obj.theta);
        y = obj.center[1] + obj.ellipse.b * Math.sin(obj.theta);
      }

      // Convert to GA translation motor
      const m = normalizeMotor([1, 0, x / 2, y / 2]);

      obj.pose[0] = m[0];
      obj.pose[1] = m[1];
      obj.pose[2] = m[2];
      obj.pose[3] = m[3];

      obj.theta += obj.speed;
    }
  }, 16); // ~60 FPS

  return renderer;
}

/* --------------------------------------------------
   Boot
-------------------------------------------------- */

init()
  .then(r => console.log(r))
  .catch(error => {
    const p = document.createElement('p');
    p.innerHTML = navigator.userAgent + "<br>" + error.message;
    document.body.appendChild(p);
    document.getElementById("renderCanvas")?.remove();
  });
