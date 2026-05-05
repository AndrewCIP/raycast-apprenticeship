/*
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

import RayBoxObject from "/lib/Scene/RayBoxObject.js"

export default class RayBoxLightObject extends RayBoxObject {
  constructor(device, canvasFormat, camera, shaderFile, showTexture = true) {
    super(device, canvasFormat, camera, shaderFile);
    this._showTexture = showTexture;
  }
  
  async createGeometry() {
    await super.createGeometry();
    // Create light buffer to store the light in GPU
    // Note: our light has a common memory layout - check the abstract light class
    this._lightBuffer = this._device.createBuffer({
      label: "Light " + this.getName(),
      size: 20 * Float32Array.BYTES_PER_ELEMENT,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    }); 
  }
    
  updateLight(light) {
    // this function update the light buffer
    let offset = 0;
    this._device.queue.writeBuffer(this._lightBuffer, offset, light._intensity);
    offset += light._intensity.byteLength;
    this._device.queue.writeBuffer(this._lightBuffer, offset, light._position);
    offset += light._position.byteLength;
    this._device.queue.writeBuffer(this._lightBuffer, offset, light._direction);
    offset += light._direction.byteLength;
    this._device.queue.writeBuffer(this._lightBuffer, offset, light._attenuation);
    offset += light._attenuation.byteLength;
    this._device.queue.writeBuffer(this._lightBuffer, offset, light._params);
  }

  async createShaders() {
    await super.createShaders();
    // Create the bind group layout
    this._bindGroupLayout = this._device.createBindGroupLayout({
      label: "Ray Trace Box Layout " + this.getName(),
      entries: [{
        binding: 0,
        visibility: GPUShaderStage.COMPUTE,
        buffer: {} // Camera uniform buffer
      }, {
        binding: 1,
        visibility: GPUShaderStage.COMPUTE,
        buffer: {} // Box uniform buffer
      }, {
        binding: 2,
        visibility: GPUShaderStage.COMPUTE,
        storageTexture: { format: this._canvasFormat } // texture
      }, {
        binding: 3,
        visibility: GPUShaderStage.COMPUTE,
        buffer: {} // Light uniform buffer
      }]
    });
    this._pipelineLayout = this._device.createPipelineLayout({
      label: "Ray Trace Box Pipeline Layout",
      bindGroupLayouts: [ this._bindGroupLayout ],
    });
  }
  
  createBindGroup(outTexture) {
    // Create a bind group
    this._bindGroup = this._device.createBindGroup({
      label: "Ray Trace Box Bind Group",
      layout: this._computePipeline.getBindGroupLayout(0),
      entries: [
      {
        binding: 0,
        resource: { buffer: this._cameraBuffer }
      },
      {
        binding: 1,
        resource: { buffer: this._boxBuffer }
      },
      {
        binding: 2,
        resource: outTexture.createView()
      },
      {
        binding: 3,
        resource: { buffer: this._lightBuffer }
      }
      ],
    });
    this._wgWidth = Math.ceil(outTexture.width);
    this._wgHeight = Math.ceil(outTexture.height);
  }
}
