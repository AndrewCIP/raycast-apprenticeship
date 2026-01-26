import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js";

export default class OrbitLine extends Standard2DVertexObject {
  constructor(
    device,
    canvasFormat,
    {
      center = [0, 0],
      radius = null,
      ellipse = null,
      segments = 128
    }
  ) {
    const vertices = OrbitLine.generateVertices(
      center,
      radius,
      ellipse,
      segments
    );

    super(
      device,
      canvasFormat,
      vertices,
      "/lib/Shaders/leaves.wgsl",
      "line-strip"
    );

    this._vertices = vertices;
  }

  static generateVertices(center, radius, ellipse, segments) {
    const verts = [];
    const step = (2 * Math.PI) / segments;

    for (let i = 0; i <= segments; i++) {
      const t = i * step;

      let x, y;

      // ---- Circle ----
      if (!ellipse) {
        x = center[0] + radius * Math.cos(t);
        y = center[1] + radius * Math.sin(t);
      }
      // ---- Ellipse ----
      else {
        x = center[0] + ellipse.a * Math.cos(t);
        y = center[1] + ellipse.b * Math.sin(t);
      }

      verts.push(x, y);
    }

    return new Float32Array(verts);
  }
}
