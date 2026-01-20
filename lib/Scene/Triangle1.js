 import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js"

 export default class Triangle1 extends Standard2DVertexObject {
   constructor(device, canvasFormat, xPos = 0, yPos = 0, xScale = 1, yScale = 1) {
     let vertices = new Float32Array([
     // x, y
       (0 * xPos) * xScale , (0.5 + yPos) * yScale,
       (-0.5 + xPos) * xScale, (0 + yPos) * yScale,
       (0.5 + xPos) * xScale,  (0 + yPos) * yScale
     ]);
     super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'triangle-list');
     this._vertices = vertices;
   }
 }
