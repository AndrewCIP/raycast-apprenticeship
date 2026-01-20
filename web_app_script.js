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

   const tri1 = new Triangle1(device, format, 0.5, 0.0, 0.5);
   await tri1.init();
   tri1.setColor(1.0, 0.0, 0.0); // red

   // Append objects
   await renderer.appendSceneObject(tri1);
   //await renderer.appendSceneObject(new Triangle2(renderer._device, renderer._canvasFormat, 0, 0, 1));
   //await renderer.appendSceneObject(new Square2(renderer._device, renderer._canvasFormat, 0, 0, 1));

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