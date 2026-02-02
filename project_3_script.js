import Renderer from '/lib/Viz/2DRenderer.js'
import Camera from '/lib/Scene/Camera.js'
import Camera2DVertexObject from '/lib/Scene/Camera2DVertexObject.js'
import StandardTextObject from '/lib/Scene/StandardTextObject.js';
import Grid from '/lib/Scene/Grid.js';
import PGA2D from '/lib/Scene/PGA2D.js';

// Features Completed (10/10)
// -> Implement the Game of Life grid using a compute shader to update the cells.
//    The grid should be at least 256 × 256 and the cells should be randomly initialized.
// -> Render the cell using a fragment shader with distinct colors for alive and dead cells.
// -> Use keyboard input to pause/resume and reset the simulation. When reset, the cells
//    should be randomly reinitialized.
// -> Use keyboard input to speedup/slowdown the simulation.
// -> Implement a 2D camera and use the keyboard to move left/right/up/down.
// -> Implement a 2D camera and use the keyboard to zoom in/out.
// -> Run at real time even with a large grid (e.g. 2048 × 2048).
// -> If there is camera interaction (e.g. after zoomed in), the mouse toggle cells still work perfectly.
// -> Use mouse input to toggle cells (i.e. to turn alive cell to dead and vice-versa).
// -> Render at least one text object to provide interaction instructions.

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);
  // Create a simple renderer
  const renderer = new Renderer(canvasTag);
  await renderer.init();

  var vertices = new Float32Array([
    // x, y
    -0.5, -0.5,
    0.5, -0.5,
    0.5,  0.5,
    -0.5, 0.5, 
    -0.5, -0.5 // loop back to the first vertex
  ]);

  var gridHeight = 2048;
  var gridWidth = 2048;

  var paused = false;

  let camera = new Camera();
  var quad = new Grid(renderer._device, renderer._canvasFormat, camera._pose, vertices, "/lib/Shaders/reverse_camera_pga_grid_dynamic.wgsl", "line-strip", gridHeight * gridWidth);
  await renderer.appendSceneObject(quad);

let fps = '??';
var fpsText = new StandardTextObject('fps: ' + fps);
fpsText.setPosition(900, 10)
var instructionText = new StandardTextObject(
  "Instructions:\n" +
  "- Toggle Cell (Left Click)\n" +
  "- Move Camera (Arrow keys / WASD)\n" +
  "- Zoom In (Q)\n" +
  "- Zoom Out (E)\n" +
  "- Pause/Resume (P)\n" +
  "- View/Hide FPS (F)\n" +
  "- Increase FPS ([)\n" +
  "- Decrease FPS (])\n" +
  "- Reset (R)"
);

  var movespeed = 0.05;
window.addEventListener("keydown", (e) => {
  switch (e.key) {
    case 'ArrowUp': case 'w': case 'W':
      camera.moveUp(movespeed);
      quad.updateCameraPose();
      break;
    case 'ArrowDown': case 's': case 'S':   
      camera.moveDown(movespeed);
      quad.updateCameraPose();     
      break;
    case 'ArrowLeft': case 'a': case 'A':  
      camera.moveLeft(movespeed);
      quad.updateCameraPose();
      break;
    case 'ArrowRight': case 'd': case 'D': 
      camera.moveRight(movespeed);
      quad.updateCameraPose();       
      break;
    case 'q': case 'Q':  
      camera.zoomIn();
      quad.updateCameraPose();       
      break;
    case 'e': case 'E':
      camera.zoomOut();
      quad.updateCameraPose();  
      break;
    case 'f': case 'F':
        fpsText.toggleVisibility();
        break;
    case 'p': case 'P':
        paused = !paused;
        if (!paused) renderFrame(); // Resume Simulation
        break;
    case 'r': case 'R':
        quad.reset();
        renderer.render();  // show the reset state immediately
        break;
    case '[':
        tgtFPS = Math.max(1, tgtFPS - 1);  // don't go below 1
        frameInterval = 1000 / tgtFPS;
        break;
    case ']':
        tgtFPS++;
        frameInterval = 1000 / tgtFPS;
        break;
  }
});

canvasTag.addEventListener('mousemove', (e) => {
  var mouseX = (e.clientX / window.innerWidth) * 2 - 1;
  var mouseY = (-e.clientY / window.innerHeight) * 2 + 1;
  mouseX /= camera._pose[4];
  mouseY /= camera._pose[5];
  let p = PGA2D.applyMotorToPoint([mouseX, mouseY], [camera._pose[0], camera._pose[1], camera._pose[2], camera._pose[3]]);
  let halfLength = 1; // half length
  let cellLength = halfLength * 2; // full length
  let u = Math.floor((p[0] + halfLength) / cellLength * gridHeight);
  let v = Math.floor((p[1] + halfLength) / cellLength * gridHeight);

  if (u >= 0 && u < gridHeight && v >= 0 && v < gridHeight) {
  let offsetX = - halfLength + u / gridHeight * cellLength + cellLength / gridHeight * 0.5;
  let offsetY = - halfLength + v / gridHeight * cellLength + cellLength / gridHeight * 0.5;
  if (-0.5 / gridHeight + offsetX <= p[0] && p[0] <= 0.5 / gridHeight + offsetX && -0.5 / gridHeight + offsetY <= p[1] && p[1] <= 0.5 / gridHeight + offsetY) {
    console.log(`in cell (${u}, ${v})`);
  }
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
    quad.updateCameraPose();
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

canvasTag.addEventListener('mousedown', (e) => {
    if (!paused) return; // only allow manual toggling when paused

    const ndc = mouseToNDC(e);
    let p = PGA2D.applyMotorToPoint([ndc[0] / camera._pose[4], ndc[1] / camera._pose[5]],
                                     [camera._pose[0], camera._pose[1], camera._pose[2], camera._pose[3]]);
    let halfLength = 1;
    let cellLength = halfLength * 2;
    let u = Math.floor((p[0] + halfLength) / cellLength * gridWidth);
    let v = Math.floor((p[1] + halfLength) / cellLength * gridHeight);

    if (u >= 0 && u < gridWidth && v >= 0 && v < gridHeight) {
        quad.toggleCell(u, v);
        renderer.render(); // immediately update the screen
    }
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
    if (!paused) requestAnimationFrame(renderFrame);
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