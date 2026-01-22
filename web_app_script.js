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

  let applyRotorToRotor = (dr, r) => {
   // r = cS + s exey
   // dr = ccS + ss exey
   // dr r = (c * cc - s * ss)S + (cc * s + ss * s) e01
   return [dr[0] * r[0] - dr[1] * r[1], dr[0] * r[1] + dr[1] * r[0]];
 };

   // Append objects

   // Add Image Background
   await renderer.appendSceneObject(new Standard2DFullScreenObject(renderer._device, renderer._canvasFormat, "/assets/kirby_background.jpg"));
   await renderer.appendFilterObject(new ImageFilterObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/8_bit_filter.wgsl"));
   await renderer.appendFilterObject(new ImageNosifyFilterObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/nosify.wgsl"));

     var pose = [1, 0, 0, 0, 1, 1]; // rotor, translator, scales
  pose = new Float32Array(pose);
  await renderer.appendSceneObject(new Standard2DGAPosedVertexObject(renderer._device, renderer._canvasFormat, vertices, pose, "/lib/Shaders/ga_pose.wgsl", "triangle-list"));
  let angle = Math.PI / 100 / 2;
  let dr = [Math.cos(angle), -Math.sin(angle)]; // a delta rotor

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
   let newrotor = applyRotorToRotor(dr, [pose[0], pose[1]]);
   pose[0] = newrotor[0];
   pose[1] = newrotor[1];
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