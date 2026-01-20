 import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js"

 export default class Triangle1 extends Standard2DVertexObject {
   constructor(device, canvasFormat, xPos, yPos, scale) {
     let vertices = new Float32Array([
     // x, y
       (0 + xPos) * scale, (0.5 + yPos) * scale,
       (-0.5 + xPos) * scale, (0 + yPos) * scale,
       (0.5 + xPos) * scale,  (0 + yPos) * scale
     ]);
     super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'triangle-list');
     this._vertices = vertices;
   }
 }
