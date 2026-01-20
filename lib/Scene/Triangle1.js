 import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js"

 export default class Triangle1 extends Standard2DVertexObject {
   constructor(device, canvasFormat, x, y) {
     let vertices = new Float32Array([
     // x, y
       0 + x, 0.5 + y,
       -0.5 + x, 0 + y,
       0.5 + x,  0 + y
     ]);
     super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'triangle-list');
     this._vertices = vertices;
   }
 }
