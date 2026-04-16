/*!
 * Copyright (c) 2026 Sing Chun LEE @ Bucknell University. CC BY-NC 4.0.
 * 
 * This code is provided mainly for educational purposes at University of the Pacific.
 *
 * This code is licensed under the Creative Commons Attribution-NonCommercial 4.0
 * International License. To view a copy of the license, visit 
 *   https://creativecommons.org/licenses/by-nc/4.0/
 * or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * You are free to:
 *  - Share: copy and redistribute the material in any medium or format.
 *  - Adapt: remix, transform, and build upon the material.
 *
 * Under the following terms:
 *  - Attribution: You must give appropriate credit, provide a link to the license,
 *                 and indicate if changes were made.
 *  - NonCommercial: You may not use the material for commercial purposes.
 *  - No additional restrictions: You may not apply legal terms or technological 
 *                                measures that legally restrict others from doing
 *                                anything the license permits.
 */

import Standard2DVertexObject from "/lib/Scene/Standard2DVertexObject.js"
import Polygon from "/lib/DS/Polygon.js"

export default class PolygonObject extends Standard2DVertexObject {
  constructor(device, canvasFormat, shaderFile, filename) {
    super(device, canvasFormat, null, shaderFile, "line-strip");
    this._polygon = new Polygon(filename);
  }
  
  async createGeometry() {
    // Read vertices from polygon files
    await this._polygon.init();
    this._numV = this._polygon._numV;
    this._dim = this._polygon._dim;
    this._vertices = new Float32Array(this._polygon._polygon.flat());
    // Use the parent class to create the vertex buffer and layout
    await super.createGeometry();
  }

  async createStage() {
    // create a stage buffer to read from the GPU to CPU
    this._stageBuffer = this._device.createBuffer({
      size: 8,
      usage: GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST,
    });
  }
}