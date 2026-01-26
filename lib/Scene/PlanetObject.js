import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class PlanetObject extends Standard2DVertexObject {
  constructor(device, canvasFormat, radius = 0.5, segments = 32, shader = '/lib/Shaders/leaves.wgsl') {
    const vertices = PlanetObject.generateVertices(radius, segments);
    super(device, canvasFormat, vertices, shader, 'triangle-list');
  }

  static generateVertices(radius, segments) {
    const verts = [];
    const step = (2 * Math.PI) / segments;

    for (let i = 0; i < segments; i++) {
      const a0 = i * step;
      const a1 = (i + 1) * step;

      // center
      verts.push(0, 0);

      // edge 1
      verts.push(
        Math.cos(a0) * radius,
        Math.sin(a0) * radius
      );

      // edge 2
      verts.push(
        Math.cos(a1) * radius,
        Math.sin(a1) * radius
      );
    }

    return new Float32Array(verts);
  }
}
