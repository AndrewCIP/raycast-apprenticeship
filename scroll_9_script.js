import Renderer from '/lib/Viz/2DRenderer.js'
import PolygonObject from '/lib/Scene/PolygonObject.js'
import PGA2D from '/lib/Scene/PGA2D.js'
import Camera from '/lib/Scene/Camera.js'

// Part 1 []
// Part 2 []

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);
  // Create a simple renderer
  const renderer = new Renderer(canvasTag);
  await renderer.init();
 
  let camera = new Camera();
  var polygonObj = new PolygonObject(renderer._device, renderer._canvasFormat, "/lib/Shaders/leaves.wgsl", "/assets/star.polygon");
  await renderer.appendSceneObject(polygonObj);

  canvasTag.addEventListener('mousemove', (e) => {
    var mouseX = (e.clientX / window.innerWidth) * 2 - 1;
    var mouseY = (-e.clientY / window.innerHeight) * 2 + 1;
    mouseX /= camera._pose[4];
    mouseY /= camera._pose[5];
    console.log(`x: ${mouseX}, ${mouseY}`);
    let p = PGA2D.applyMotorToPoint([mouseX, mouseY], [camera._pose[0], camera._pose[1], camera._pose[2], camera._pose[3]]);
    
    let inside = true;

    let poly = polygonObj._polygon._polygon; // correct vertices
    let polygon = polygonObj._polygon;       // actual Polygon instance
    let wn = PGA2D.windingNumber(polygon, p);

    if (wn !== 0) console.log("inside");
    else console.log("outside");

    /*
    for (let i = 0; i < poly.length - 1; i++) {
        let v0 = poly[i];
        let v1 = poly[i + 1];

        if (!polygon.isInside(v0, v1, p)) {
            inside = false;
            break;
        }
    }

    if (inside) {
        console.log("inside");
    } else {
        console.log("outside");
    }
    */
  });
  

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