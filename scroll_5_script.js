import Renderer from '/lib/Viz/2DRenderer.js'
import Camera from '/lib/Scene/Camera.js'
import Camera2DVertexObject from '/lib/Scene/Camera2DVertexObject.js'
import StandardTextObject from '/lib/Scene/StandardTextObject.js';

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);
  // Create a simple renderer
  const renderer = new Renderer(canvasTag);
  await renderer.init();
  let camera = new Camera();
  let triangle = new Camera2DVertexObject(renderer._device, renderer._canvasFormat, camera._pose, new Float32Array([0, 0.5, -0.5, 0, 0.5, 0]), "/lib/Shaders/reverse_camera_pga.wgsl");
  await renderer.appendSceneObject(triangle);

let fps = '??';
var fpsText = new StandardTextObject('fps: ' + fps);

  var movespeed = 0.05;
window.addEventListener("keydown", (e) => {
  switch (e.key) {
    case 'ArrowUp': case 'w': case 'W':
      camera.moveUp(movespeed);
      triangle.updateCameraPose();
      break;
    case 'ArrowDown': case 's': case 'S':   
      camera.moveDown(movespeed);
      triangle.updateCameraPose();     
      break;
    case 'ArrowLeft': case 'a': case 'A':  
      camera.moveLeft(movespeed);
      triangle.updateCameraPose();
      break;
    case 'ArrowRight': case 'd': case 'D': 
      camera.moveRight(movespeed);
      triangle.updateCameraPose();       
      break;
    case 'q': case 'Q':  
      camera.zoomIn();
      triangle.updateCameraPose();       
      break;
    case 'e': case 'E':
      camera.zoomOut();
      triangle.updateCameraPose();  
      break;
    case 'f': case 'F':
        fpsText.toggleVisibility();
        break;
  }
});

let prevP = { x: 0, y: 0 };

let dragging = false;            // are we currently dragging?
canvasTag.addEventListener('mousemove', (e) => {
  if (!dragging) return;
  const ndc = mouseToNDC(e);
  const dx = ndc[0] - prevP.x;
  const dy = ndc[1] - prevP.y;
  let diff = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
  if (diff > 0.001) { // a dirty flag spell
    prevP.x = ndc[0];
    prevP.y = ndc[1];
    // Note: we apply the opposite direction to make the mouse movement align with the object
    if (dx > 0) camera.moveRight(-dx);
    else camera.moveLeft(dx);
    if (dy > 0) camera.moveUp(-dy);
    else camera.moveDown(dy);
    triangle.updateCameraPose();
    renderer.render();
  }
});
canvasTag.addEventListener('mousedown', (e) => {
  dragging = true;
  // 1) mouse -> scene
  const ndc = mouseToNDC(e);
  // 2) store previous location
  prevP.x = ndc[0];
  prevP.y = ndc[1];
});

canvasTag.addEventListener('mouseup', (e) => {
  dragging = false;
});

canvasTag.addEventListener('mouseleave', (e) => {
  dragging = false;
});

  // run animation at 60 fps
  var frameCnt = 0;
  var tgtFPS = 60;
  var secPerFrame = 1. / tgtFPS;
  var frameInterval = secPerFrame * 1000;
  var lastCalled;
  let renderFrame = () => {
    let elapsed = Date.now() - lastCalled;
    if (elapsed > frameInterval) {
      ++frameCnt;
      lastCalled = Date.now() - (elapsed % frameInterval);
      renderer.render();
    }
    requestAnimationFrame(renderFrame);
  };
  lastCalled = Date.now();
  renderFrame();
  setInterval(() => { 
    fpsText.updateText('fps: ' + frameCnt);
    frameCnt = 0;
  }, 1000); // call every 1000 ms
  return renderer;
}

function mouseToNDC(e) {
  const x = (e.clientX / window.innerWidth) * 2 - 1;
  const y = (-e.clientY / window.innerHeight) * 2 + 1;
  return [x, y];
}

init().then( ret => {
  console.log(ret);
}).catch( error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
  document.body.appendChild(pTag);
  document.getElementById("renderCanvas").remove();
});