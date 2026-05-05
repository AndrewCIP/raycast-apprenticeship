import RayTracer from '/lib/Viz/RayTracer.js'
import RayBoxObject from '/lib/Scene/RayBoxObject.js'
import Camera from '/lib/Viz/3DCamera.js'

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);

  // Create the ray tracer renderer
  const renderer = new RayTracer(canvasTag);
  await renderer.init();

  // Create the 3D camera (width/height will be updated on resize)
  const camera = new Camera(renderer._offScreenTexture.width, renderer._offScreenTexture.height);

  // Create the ray box object using the tracebox shader
  const rayBox = new RayBoxObject(renderer._device, renderer._canvasFormat, camera, '/lib/Shaders/tracebox.wgsl');
  await renderer.setTracerObject(rayBox);

  // Movement step and rotation step
  const moveStep = 0.05;
  const rotStep = Math.PI / 36; // 5 degrees

  // Keyboard interaction for camera control
  window.addEventListener('keydown', (e) => {
    switch (e.key) {
      // Translation controls (WASD + QE for z)
      case 'w': camera.moveZ(moveStep);  break;
      case 's': camera.moveZ(-moveStep); break;
      case 'a': camera.moveX(-moveStep); break;
      case 'd': camera.moveX(moveStep);  break;
      case 'q': camera.moveY(moveStep);  break;
      case 'e': camera.moveY(-moveStep); break;

      // Rotation controls (arrow keys for X/Y pitch/yaw, letter keys z/x for Z-axis roll)
      case 'ArrowUp':    camera.rotateX(-rotStep); break;
      case 'ArrowDown':  camera.rotateX(rotStep);  break;
      case 'ArrowLeft':  camera.rotateY(-rotStep); break;
      case 'ArrowRight': camera.rotateY(rotStep);  break;
      case 'z': camera.rotateZ(-rotStep); break;
      case 'x': camera.rotateZ(rotStep);  break;

      // Toggle between orthogonal and projective camera
      case 'p':
        camera._isProjective = !camera._isProjective;
        console.log('Projective mode:', camera._isProjective);
        break;

      // Reset pose
      case 'r':
        camera.resetPose();
        break;

      // Focal length adjustments
      case '+':
      case '=':
        camera._focal[0] += 0.1;
        camera._focal[1] += 0.1;
        rayBox.updateCameraFocal();
        console.log('Focal:', camera._focal[0].toFixed(2));
        break;
      case '-':
        camera._focal[0] = Math.max(0.1, camera._focal[0] - 0.1);
        camera._focal[1] = Math.max(0.1, camera._focal[1] - 0.1);
        rayBox.updateCameraFocal();
        console.log('Focal:', camera._focal[0].toFixed(2));
        break;

      default: return;
    }
    // After any camera pose change, push updated pose to GPU
    rayBox.updateCameraPose();
  });

  // Render loop
  function renderFrame() {
    renderer.render();
    requestAnimationFrame(renderFrame);
  }
  renderFrame();

  return renderer;
}

init().then(ret => {
  console.log(ret);
}).catch(error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
  document.body.appendChild(pTag);
  document.getElementById("renderCanvas").remove();
});
