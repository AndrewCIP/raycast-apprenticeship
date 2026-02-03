import Renderer from '/lib/Viz/2DRenderer.js'
import ParticleSystemObject from '/lib/Scene/ParticleSystemObject.js';

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);
  // Create a simple renderer
  const renderer = new Renderer(canvasTag);
  await renderer.init();

  var particles = new ParticleSystemObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/particles.wgsl");
  await renderer.appendSceneObject(particles);
  renderer.render();
}

init().then( ret => {
  console.log(ret);
}).catch( error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
  document.body.appendChild(pTag);
  document.getElementById("renderCanvas").remove();
});