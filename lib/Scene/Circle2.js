import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class Circle2 extends Standard2DVertexObject {
  constructor(device, canvasFormat, xPos = 0, yPos = 0, xScale = 1, yScale = 1, segments = 32) {
    let vertices = Circle2.generateVertices(xPos, yPos, xScale, yScale, segments);
    super(device, canvasFormat, vertices, '/lib/Shaders/leaves.wgsl', 'line-strip');
    this._vertices = vertices;
  }

  static generateVertices(xPos, yPos, xScale, yScale, segments) {
    const verts = [];
    const angleStep = (2 * Math.PI) / segments;
    for (let i = 0; i < segments; i++) {
      const theta = i * angleStep;
      const nextTheta = ((i + 1) % segments) * angleStep;

      // triangle fan for each segment
      verts.push(0 * xScale + xPos, 0 * yScale + yPos); // center
      verts.push(Math.cos(theta) * 0.5 * xScale + xPos, Math.sin(theta) * 0.5 * yScale + yPos);
      verts.push(Math.cos(nextTheta) * 0.5 * xScale + xPos, Math.sin(nextTheta) * 0.5 * yScale + yPos);
      verts.push(0 * xScale + xPos, 0 * yScale + yPos); // center
    }
    return new Float32Array(verts);
  }
}
