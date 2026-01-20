import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class Star1 extends Standard2DVertexObject {
  constructor(device, canvasFormat, xPos = 0, yPos = 0, scale = 1) {
    let vertices = new Float32Array([
      // first triangle
      (0 * scale) + xPos, (0.5 * scale) + yPos,
      (0.112 * scale) + xPos, (0.154 * scale) + yPos,
      (0.475 * scale) + xPos, (0.154 * scale) + yPos,

      // second triangle
      (0.112 * scale) + xPos, (0.154 * scale) + yPos,
      (0.293 * scale) + xPos, (-0.118 * scale) + yPos,
      (0.475 * scale) + xPos, (0.154 * scale) + yPos,

      // third triangle
      (0.293 * scale) + xPos, (-0.118 * scale) + yPos,
      (0 * scale) + xPos, (-0.191 * scale) + yPos,
      (-0.293 * scale) + xPos, (-0.118 * scale) + yPos,

      // fourth triangle
      (-0.293 * scale) + xPos, (-0.118 * scale) + yPos,
      (-0.112 * scale) + xPos, (0.154 * scale) + yPos,
      (0 * scale) + xPos, (0.5 * scale) + yPos
    ]);
    super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'triangle-list');
    this._vertices = vertices;
  }
}
