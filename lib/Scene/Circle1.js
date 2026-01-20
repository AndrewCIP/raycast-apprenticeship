import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class Circle1 extends Standard2DVertexObject {
  constructor(device, canvasFormat, xPos = 0, yPos = 0, scale = 1, segments = 32) {
    let vertices = Circle1.generateVertices(xPos, yPos, scale, segments);
    super(device, canvasFormat, vertices, '/lib/Shaders/standard2d.wgsl', 'triangle-list');
    this._vertices = vertices;
  }

  static generateVertices(xPos, yPos, scale, segments) {
    const verts = [];
    const angleStep = (2 * Math.PI) / segments;
    for (let i = 0; i < segments; i++) {
      const theta = i * angleStep;
      const nextTheta = ((i + 1) % segments) * angleStep;

      // triangle fan for each segment
      verts.push(0 * scale + xPos, 0 * scale + yPos); // center
      verts.push(Math.cos(theta) * 0.5 * scale + xPos, Math.sin(theta) * 0.5 * scale + yPos);
      verts.push(Math.cos(nextTheta) * 0.5 * scale + xPos, Math.sin(nextTheta) * 0.5 * scale + yPos);
    }
    return new Float32Array(verts);
  }
}
