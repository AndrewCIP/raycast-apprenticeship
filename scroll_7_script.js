import Renderer from '/lib/Viz/2DRenderer.js'
import MassSpringSystemObject from '/lib/Scene/MassSpringSystemObject.js'

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);
  // Create a simple renderer
  const renderer = new Renderer(canvasTag);
  await renderer.init();
 
  var massSprings = new MassSpringSystemObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/massspring.wgsl");
  await renderer.appendSceneObject(massSprings);
  
  // Animation loop
  function renderFrame() {
    renderer.render();
    requestAnimationFrame(renderFrame);
  }

  renderFrame();
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