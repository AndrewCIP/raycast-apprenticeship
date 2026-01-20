import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class Square1 extends Standard2DVertexObject {
  constructor(device, canvasFormat, xPos = 0, yPos = 0, xScale = 1, yScale = 1, shader = '/lib/Shaders/branches.wgsl') {
    // Vertices for a square using scale and position
    let vertices = new Float32Array([
      (-0.5 * xScale) + xPos, (-0.5 * yScale) + yPos,
       (0.5 * xScale) + xPos, (-0.5 * yScale) + yPos,
       (0.5 * xScale) + xPos,  (0.5 * yScale) + yPos,

      (-0.5 * xScale) + xPos, (-0.5 * yScale) + yPos,
       (0.5 * xScale) + xPos,  (0.5 * yScale) + yPos,
      (-0.5 * xScale) + xPos,  (0.5 * yScale) + yPos
    ]);
    super(device, canvasFormat, vertices, shader, 'triangle-list');
    this._vertices = vertices;
  }
}
