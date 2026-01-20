import Renderer from '/lib/Viz/2DRenderer.js'
 import Triangle1 from '/lib/Scene/Triangle1.js'
 import Triangle2 from '/lib/Scene/Triangle2.js'
 import Square1 from '/lib/Scene/Square1.js'
 import Square2 from '/lib/Scene/Square2.js'
 import Circle1 from '/lib/Scene/Circle1.js'
 import Circle2 from '/lib/Scene/Circle2.js'
 import Star1 from '/lib/Scene/Star1.js'

 async function init() {
   // Create a canvas tag
   const canvasTag = document.createElement('canvas');
   canvasTag.id = "renderCanvas";
   document.body.appendChild(canvasTag);

   // Create a simple renderer
   const renderer = new Renderer(canvasTag);
   await renderer.init();

   // Append objects
   await renderer.appendSceneObject(new Triangle1(renderer._device, renderer._canvasFormat, -0.7, -0.65, 0.5, 2));
   await renderer.appendSceneObject(new Triangle2(renderer._device, renderer._canvasFormat, 0, -2, 1, 2));
   // Ground
   await renderer.appendSceneObject(new Square2(renderer._device, renderer._canvasFormat, 0, -0.775, 2.5, 0.2));
   // Trees
   await renderer.appendSceneObject(new Square2(renderer._device, renderer._canvasFormat, 0.3, -0.25, 0.025, 0.75));
   await renderer.appendSceneObject(new Circle2(renderer._device, renderer._canvasFormat, 0.2, -0.25, 0.25, 0.25));

   // Render
   renderer.render();
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