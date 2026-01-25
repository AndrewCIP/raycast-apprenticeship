import Renderer from '/lib/Viz/FilteredRenderer.js'
import Standard2DFullScreenObject from "/lib/Scene/Standard2DFullScreenObject.js";
 import ImageFilterObject from "/lib/Scene/ImageFilterObject.js";
 import ImageNosifyFilterObject from "/lib/Scene/ImageNosifyFilterObject.js";
 import Standard2DGAPosedVertexObject from '/lib/Scene/Standard2DGAPosedVertexObject.js';

// 6 Point Requirements (1/6)
// [x] A (space-like) background using an image texture.

 async function init() {
   // Create a canvas tag
   const canvasTag = document.createElement('canvas');
   canvasTag.id = "renderCanvas";
   document.body.appendChild(canvasTag);

   // Create a simple renderer
   const renderer = new Renderer(canvasTag);
   await renderer.init();

// Create a triangle geometry
var vertices = new Float32Array([
  // x, y,
  0, 0.25, 
  -0.25, 0,
  0.25,  0,
]);

 let geometricProduct = (a, b) => {
   // ref: https://geometricalgebratutorial.com/pga/
   // eoo = 0, e00 = 1 e11 = 1
   // s + e01 + eo0 + eo1
   // ss   = s   , se01   = e01  , seo0            = eo0  , seo1          = eo1
   // e01s = e01 , e01e01 = -s   , e01eo0 = e10e0o = -eo1 , e01eo1 = -e0o = eo0
   // eo0s = eo0 , eo0e01 = eo1  , eo0eo0          = 0    , eo0eo1        = 0
   // e01s = e01 , eo1e01 = -eo0 , eo1eo0          = 0    , eo1eo1        = 0
   return [
     a[0] * b[0] - a[1] * b[1] , // scalar
     a[0] * b[1] + a[1] * b[0] , // e01
     a[0] * b[2] + a[1] * b[3] + a[2] * b[0] - a[3] * b[1], // eo0
     a[0] * b[3] - a[1] * b[2] + a[2] * b[1] + a[3] * b[0]  // eo1
   ];
 };
 let reverse = (a) => {
   return [ a[0], -a[1], -a[2], -a[3] ];
 };
 let motorNorm =  (m) => {
   return Math.sqrt(m[0] * m[0] + m[1] * m[1] + m[2] * m[2] + m[3] * m[3]);
 };
 let normalizeMotor = (m) => {
   let mnorm = motorNorm(m);
   if (mnorm == 0.0) {
     return [1, 0, 0, 0];
   }
   return [m[0] / mnorm, m[1] / mnorm, m[2] / mnorm, m[3] / mnorm];
 };

let easeInEaseOut = (t) => {
  if (t > 0.5) return t * (4 - 2 * t) -1;
  else return 2 * t * t;
}

console.log(LinearInterpolate(0, 10, 0.5));

   // Append objects

   // Add Image Background
   await renderer.appendSceneObject(new Standard2DFullScreenObject(renderer._device, renderer._canvasFormat, "/assets/space_background.jpg"));
   await renderer.appendFilterObject(new ImageFilterObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/8_bit_filter.wgsl"));
   await renderer.appendFilterObject(new ImageNosifyFilterObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/nosify.wgsl"));

   let pose0 = normalizeMotor([1, 0, -0.2, -0.25]);
let pose1 = normalizeMotor([0, 1, -0.25, 0.4]);

var pose = new Float32Array([pose0[0], pose0[1], pose0[2], pose0[3], 1, 1]);
  await renderer.appendSceneObject(new Standard2DGAPosedVertexObject(renderer._device, renderer._canvasFormat, vertices, pose, "/lib/Shaders/projective_geometric_algebra.wgsl", "triangle-list"));
   let angle = Math.PI / 100;
 // rotate about center
 let center = [0, 0];
 let dr = normalizeMotor([Math.cos(angle / 2), -Math.sin(angle / 2), -center[0] * Math.sin(angle / 2), -center[1] * Math.sin(angle / 2)]);
 let dt = normalizeMotor([1, 0, 0.01 / 2, 0 / 2]);
 let dm = normalizeMotor(geometricProduct(dt, dr));

 let timerMs = 100;
 let steps = 100;      // how many samples for a full move
 let i = 0;
 let dir = 1;

   // Render
   renderer.render();

   setInterval(() => {
  let t = i / steps;
  let tNew = easeInEaseOut(t);
  renderer.render();

  // LERP motor coefficients
  let m = [
    LinearInterpolate(pose0[0], pose1[0], tNew),
    LinearInterpolate(pose0[1], pose1[1], tNew),
    LinearInterpolate(pose0[2], pose1[2], tNew),
    LinearInterpolate(pose0[3], pose1[3], tNew),
  ];
  m = normalizeMotor(m);

  pose[0] = m[0];
  pose[1] = m[1];
  pose[2] = m[2];
  pose[3] = m[3];

  i += dir;
  if (i >= steps) dir = -1;
  if (i <= 0) dir = 1;
}, timerMs);

   return renderer;
 }

function LinearInterpolate(A, B, t) {
  return A * (1 - t) + B * t;
}

 init().then( ret => {
   console.log(ret);
 }).catch( error => {
   const pTag = document.createElement('p');
   pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
   document.body.appendChild(pTag);
   document.getElementById("renderCanvas").remove();
 });