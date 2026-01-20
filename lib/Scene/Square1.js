import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class Square1 extends Standard2DVertexObject {
  constructor(device, canvasFormat, xPos = 0, yPos = 0, scale = 1) {
    // Vertices for a square using scale and position
    let vertices = new Float32Array([
      (-0.5 * scale) + xPos, (-0.5 * scale) + yPos,
       (0.5 * scale) + xPos, (-0.5 * scale) + yPos,
       (0.5 * scale) + xPos,  (0.5 * scale) + yPos,

      (-0.5 * scale) + xPos, (-0.5 * scale) + yPos,
       (0.5 * scale) + xPos,  (0.5 * scale) + yPos,
      (-0.5 * scale) + xPos,  (0.5 * scale) + yPos
    ]);
    super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'triangle-list');
    this._vertices = vertices;
  }
}
