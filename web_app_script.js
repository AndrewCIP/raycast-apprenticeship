import Renderer from '/lib/Viz/2DRenderer.js'
 import Triangle1 from '/lib/Scene/Triangle1.js'
 import Triangle2 from '/lib/Scene/Triangle2.js'

 async function init() {
   // Create a canvas tag
   const canvasTag = document.createElement('canvas');
   canvasTag.id = "renderCanvas";
   document.body.appendChild(canvasTag);

   // Create a simple renderer
   const renderer = new Renderer(canvasTag);
   await renderer.init();

   const tri1 = new Triangle1(renderer._device, renderer._canvasFormat);
   const tri2 = new Triangle2(renderer._device, renderer._canvasFormat);
  
   // Append objects
   await renderer.appendSceneObject(tri1);
   await renderer.appendSceneObject(tri2);

   tri1.setPosition(2, 0.0);
   tri1.updateTRansform();
   tri2.setPosition(-2, 0.0);
   tri2.updateTransform();

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
