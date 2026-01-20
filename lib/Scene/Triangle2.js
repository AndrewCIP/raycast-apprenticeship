import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js"

 export default class Triangle2 extends Standard2DVertexObject {
   constructor(device, canvasFormat, xPos = 0, yPos = 0, xScale = 1, yScale = 1) {
     let vertices = new Float32Array([
     // x, y
       (0 * xScale) + xPos, (0.5 * yScale) + yPos,
       (-0.5 * xScale) + xPos, (0 * yScale) + yPos,
       (0.5 * xScale) + xPos,  (0 * yScale) + yPos,
       (0 * xScale) + xPos, (0.5 * yScale) + yPos
     ]);
     super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'line-strip');
     this._vertices = vertices;
   }
 }