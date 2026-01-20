import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js"

 export default class Triangle2 extends Standard2DVertexObject {
   constructor(device, canvasFormat, xPos, yPos, scale) {
     let vertices = new Float32Array([
     // x, y
       (0 * scale) + xPos, (0.5 * scale) + yPos,
       (-0.5 * scale) + xPos, (0 * scale) + yPos,
       (0.5 * scale) + xPos,  (0 * scale) + yPos,
       (0 * scale) + xPos, (0.5 * scale) + yPos
     ]);
     super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'line-strip');
     this._vertices = vertices;
   }
 }