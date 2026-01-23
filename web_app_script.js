import Renderer from '/lib/Viz/FilteredRenderer.js'
import Standard2DFullScreenObject from "/lib/Scene/Standard2DFullScreenObject.js";
 import ImageFilterObject from "/lib/Scene/ImageFilterObject.js";
 import ImageNosifyFilterObject from "/lib/Scene/ImageNosifyFilterObject.js";
 import Standard2DGAPosedVertexObject from '/lib/Scene/Standard2DGAPosedVertexObject.js';
 import Triangle1 from '/lib/Scene/Triangle1.js'
 import Triangle2 from '/lib/Scene/Triangle2.js'
 import Square1 from '/lib/Scene/Square1.js'
 import Square2 from '/lib/Scene/Square2.js'
 import Circle1 from '/lib/Scene/Circle1.js'
 import Circle2 from '/lib/Scene/Circle2.js'
 import Star1 from '/lib/Scene/Star1.js'
 import Hexagon1 from '/lib/Scene/Hexagon1.js'
 import Hexagon2 from '/lib/Scene/Hexagon2.js'

 async function init() {
   // Create a canvas tag
   const canvasTag = document.createElement('canvas');
   canvasTag.id = "renderCanvas";
   document.body.appendChild(canvasTag);

   // Create a simple renderer
   const renderer = new Renderer(canvasTag);
   await renderer.init();

// Example vertices for a single triangle (x, y per vertex)
const vertices = new Float32Array([
   0.0,  0.5,   // top
  -0.5, -0.5,   // bottom left
   0.5, -0.5    // bottom right
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

   // Append objects

   // Add Image Background
   await renderer.appendSceneObject(new Standard2DFullScreenObject(renderer._device, renderer._canvasFormat, "/assets/kirby_background.jpg"));
   await renderer.appendFilterObject(new ImageFilterObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/8_bit_filter.wgsl"));
   await renderer.appendFilterObject(new ImageNosifyFilterObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/nosify.wgsl"));

   var pose = new Float32Array([
   1, 0, 0, 0,  // motor
   1, 1         // scale
 ]);
  pose = new Float32Array(pose);
  await renderer.appendSceneObject(new Standard2DGAPosedVertexObject(renderer._device, renderer._canvasFormat, vertices, pose, "/lib/Shaders/projective_geometric_algebra.wgsl", "triangle-list"));
   let angle = Math.PI / 100;
 // rotate about center
 let center = [0, 0.5];
 let dr = normalizeMotor([Math.cos(angle / 2), -Math.sin(angle / 2), -center[0] * Math.sin(angle / 2), -center[1] * Math.sin(angle / 2)]);
 let dt = normalizeMotor([1, 0, 0.01 / 2, 0 / 2]);
 let dm = normalizeMotor(geometricProduct(dt, dr));

   /*
   // Background Mountains
   await renderer.appendSceneObject(new Circle1(renderer._device, renderer._canvasFormat, -0.6, 0.5, 0.5, 1, '/lib/Shaders/red.wgsl'));
   await renderer.appendSceneObject(new Triangle1(renderer._device, renderer._canvasFormat, -0.725, -1, 1.5, 3, '/lib/Shaders/canvas_shadow.wgsl'));
   await renderer.appendSceneObject(new Triangle1(renderer._device, renderer._canvasFormat, -0.15, -1.5, 1.5, 3, '/lib/Shaders/canvas_shadow.wgsl'));
   await renderer.appendSceneObject(new Triangle1(renderer._device, renderer._canvasFormat, 0.9, -1.25, 1.5, 3, '/lib/Shaders/canvas_shadow.wgsl'));
   // Ground
   await renderer.appendSceneObject(new Square1(renderer._device, renderer._canvasFormat, 0, -0.775, 0.5, 0.1, '/lib/Shaders/pot1.wgsl'));
   await renderer.appendSceneObject(new Square1(renderer._device, renderer._canvasFormat, 0, -0.85, 0.3, 0.05, '/lib/Shaders/pot2.wgsl'));
   await renderer.appendSceneObject(new Triangle1(renderer._device, renderer._canvasFormat, 0, -0.725, 0.35, 0.2));
   // Tree
   await renderer.appendSceneObject(new Square1(renderer._device, renderer._canvasFormat, 0.0, -0.25, 0.025, 0.75));
   // Branches
   await renderer.appendSceneObject(new Square1(renderer._device, renderer._canvasFormat, -0.1, -0.25, 0.2, 0.02));
   await renderer.appendSceneObject(new Square1(renderer._device, renderer._canvasFormat, 0.05, -0.4, 0.1, 0.02));
   await renderer.appendSceneObject(new Square1(renderer._device, renderer._canvasFormat, 0.025, -0.15, 0.05, 0.02));
   // Leaves
   await renderer.appendSceneObject(new Circle1(renderer._device, renderer._canvasFormat, -0.2, -0.25, 0.2, 0.25));
   await renderer.appendSceneObject(new Circle1(renderer._device, renderer._canvasFormat, 0, 0.2, 0.3, 0.3));
   await renderer.appendSceneObject(new Circle1(renderer._device, renderer._canvasFormat, -0.1, 0, 0.2, 0.2));
   await renderer.appendSceneObject(new Circle1(renderer._device, renderer._canvasFormat, 0.15, -0.15, 0.25, 0.1));
   await renderer.appendSceneObject(new Circle1(renderer._device, renderer._canvasFormat, 0.175, -0.4, 0.2, 0.15));
   await renderer.appendSceneObject(new Circle1(renderer._device, renderer._canvasFormat, 0.125, -0.375, 0.175, 0.2));
   // Secondary
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, -0.2, 0, 0.05, 0.05));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0, 0.1, 0.05, 0.05));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, -0.25, -0.3, 0.03, 0.03));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, -0.15, -0.25, 0.05, 0.05));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, -0.05, 0.3, 0.05, 0.05));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.1, 0.25, 0.03, 0.03));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.2, 0.15, 0.03, 0.03));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.25, -0.05, 0.03, 0.03));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.3, -0.15, 0.03, 0.03));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.175, -0.35, 0.05, 0.05));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.125, -0.4, 0.05, 0.05));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, -0.15, -0.05, 0.03, 0.03));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.075, -0.1, 0.03, 0.03));
   await renderer.appendSceneObject(new Hexagon1(renderer._device, renderer._canvasFormat, 0.125, -0.15, 0.03, 0.03)); 
*/

   // Render
   renderer.render();

   setInterval(() => { 
   renderer.render();
   // update pose
   let newmotor = normalizeMotor(geometricProduct(dm, [pose[0], pose[1], pose[2], pose[3]]));
   pose[0] = newmotor[0];
   pose[1] = newmotor[1];
   pose[2] = newmotor[2];
   pose[3] = newmotor[3];
 }, 100); // call every 100 ms

   return renderer;
 }

 init().then( ret => {
   console.log(ret);
 }).catch( error => {
   const pTag = document.createElement('p');
   pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
   document.body.appendChild(pTag);
   document.getElementById("renderCanvas").remove();
 });