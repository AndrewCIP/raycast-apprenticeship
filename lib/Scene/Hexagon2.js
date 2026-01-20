import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class Hexagon2 extends Standard2DVertexObject {
  constructor(device, canvasFormat, xPos = 0, yPos = 0, scale = 1) {

    // Precomputed unit hexagon (flat-top)
    const vertices = new Float32Array([
      // Triangle 1
       0.5 * scale + xPos,  0.0 * scale + yPos,
       0.25 * scale + xPos,  0.433 * scale + yPos,
      -0.25 * scale + xPos,  0.433 * scale + yPos,

      // Triangle 2
       0.5 * scale + xPos,  0.0 * scale + yPos,
      -0.25 * scale + xPos,  0.433 * scale + yPos,
      -0.5 * scale + xPos,  0.0 * scale + yPos,

      // Triangle 3
      -0.5 * scale + xPos,  0.0 * scale + yPos,
      -0.25 * scale + xPos, -0.433 * scale + yPos,
       0.25 * scale + xPos, -0.433 * scale + yPos,

      // Triangle 4
      -0.5 * scale + xPos,  0.0 * scale + yPos,
       0.25 * scale + xPos, -0.433 * scale + yPos,
       0.5 * scale + xPos,  0.0 * scale + yPos,

       0.5 * scale + xPos,  0.0 * scale + yPos,
    ]);

    super(
      device,
      canvasFormat,
      vertices,
      "/lib/Shaders/standard2d.wgsl",
      "line-strip"
    );

    this._vertices = vertices;
  }
}
