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

import SceneObject from "/lib/Scene/SceneObject.js"
import PGA3D from '/lib/Scene/PGA3D.js'

// ─── Ellipsoid data ───────────────────────────────────────────────────────────
// Semi-axes are intentionally non-uniform so that rotations are visually
// apparent (a perfect sphere would look the same from any angle).
class Ellipsoid {
  constructor() {
    // Identity motor → sphere center starts at world origin
    this._pose  = new Float32Array(16);
    this._pose[0] = 1; // scalar = 1, rest = 0  (identity motor)

    // Semi-axes: x=0.50, y=0.35, z=0.45, w=0 (padding)
    this._radii = new Float32Array([0.50, 0.35, 0.45, 0]);
  }
}

// ─── RaySphereObject ─────────────────────────────────────────────────────────
export default class RaySphereObject extends SceneObject {
  constructor(device, canvasFormat, camera, shaderFile) {
    super(device, canvasFormat, shaderFile);
    this._ellipsoid = new Ellipsoid();
    this._camera    = camera;
  }

  // ── GPU buffer creation ───────────────────────────────────────────────────
  async createGeometry() {
    // Camera buffer: pose (64 B) + focal (8 B) + resolution (8 B) = 80 B
    this._cameraBuffer = this._device.createBuffer({
      label: "Camera " + this.getName(),
      size:  this._camera._pose.byteLength
           + this._camera._focal.byteLength
           + this._camera._resolutions.byteLength,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });
    this._device.queue.writeBuffer(this._cameraBuffer, 0, this._camera._pose);
    this._device.queue.writeBuffer(this._cameraBuffer, this._camera._pose.byteLength, this._camera._focal);
    this._device.queue.writeBuffer(
      this._cameraBuffer,
      this._camera._pose.byteLength + this._camera._focal.byteLength,
      this._camera._resolutions
    );

    // Sphere buffer: pose (64 B) + radii (16 B) = 80 B
    this._sphereBuffer = this._device.createBuffer({
      label: "Sphere " + this.getName(),
      size:  this._ellipsoid._pose.byteLength + this._ellipsoid._radii.byteLength,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });
    this._device.queue.writeBuffer(this._sphereBuffer, 0, this._ellipsoid._pose);
    this._device.queue.writeBuffer(this._sphereBuffer, this._ellipsoid._pose.byteLength, this._ellipsoid._radii);

    // Shape config buffer: 4 bytes (u32 shapeIndex, 0 = sphere by default)
    this._shapeBuffer = this._device.createBuffer({
      label: "ShapeConfig " + this.getName(),
      size:  4,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });
    this._device.queue.writeBuffer(this._shapeBuffer, 0, new Uint32Array([0]));
  }

  // ── Called on every canvas resize ────────────────────────────────────────
  updateGeometry() {
    this._camera.updateSize(this._imgWidth, this._imgHeight);
    this._device.queue.writeBuffer(
      this._cameraBuffer,
      this._camera._pose.byteLength + this._camera._focal.byteLength,
      this._camera._resolutions
    );
  }

  // ── Camera GPU-buffer updaters ────────────────────────────────────────────
  updateCameraPose() {
    this._device.queue.writeBuffer(this._cameraBuffer, 0, this._camera._pose);
  }

  updateCameraFocal() {
    this._device.queue.writeBuffer(this._cameraBuffer, this._camera._pose.byteLength, this._camera._focal);
  }

  // ── Sphere GPU-buffer updater ─────────────────────────────────────────────
  updateSpherePose() {
    this._device.queue.writeBuffer(this._sphereBuffer, 0, this._ellipsoid._pose);
  }

  // ── Shape GPU-buffer updater ──────────────────────────────────────────────
  // index: 0 = sphere, 1 = cube, 2 = cylinder, 3 = cone
  updateShape(index) {
    this._device.queue.writeBuffer(this._shapeBuffer, 0, new Uint32Array([index]));
  }

  // ── Shader & pipeline setup ───────────────────────────────────────────────
  async createShaders() {
    await super.createShaders();
    this._bindGroupLayout = this._device.createBindGroupLayout({
      label: "Ray Sphere Layout " + this.getName(),
      entries: [
        { binding: 0, visibility: GPUShaderStage.COMPUTE, buffer: {} },               // camera
        { binding: 1, visibility: GPUShaderStage.COMPUTE, buffer: {} },               // sphere
        { binding: 2, visibility: GPUShaderStage.COMPUTE,
          storageTexture: { format: this._canvasFormat } },                            // output
        { binding: 3, visibility: GPUShaderStage.COMPUTE, buffer: {} },               // shape config
      ],
    });
    this._pipelineLayout = this._device.createPipelineLayout({
      label: "Ray Sphere Pipeline Layout",
      bindGroupLayouts: [this._bindGroupLayout],
    });
  }

  async createRenderPipeline() {}
  render(_pass) {}

  async createComputePipeline() {
    this._computePipeline = this._device.createComputePipeline({
      label:   "Ray Sphere Orthogonal Pipeline " + this.getName(),
      layout:  this._pipelineLayout,
      compute: { module: this._shaderModule, entryPoint: "computeOrthogonalMain" },
    });
    this._computeProjectivePipeline = this._device.createComputePipeline({
      label:   "Ray Sphere Projective Pipeline " + this.getName(),
      layout:  this._pipelineLayout,
      compute: { module: this._shaderModule, entryPoint: "computeProjectiveMain" },
    });
  }

  // ── Bind group (re-created on every resize) ───────────────────────────────
  createBindGroup(outTexture) {
    this._bindGroup = this._device.createBindGroup({
      label:  "Ray Sphere Bind Group",
      layout: this._computePipeline.getBindGroupLayout(0),
      entries: [
        { binding: 0, resource: { buffer: this._cameraBuffer } },
        { binding: 1, resource: { buffer: this._sphereBuffer } },
        { binding: 2, resource: outTexture.createView() },
        { binding: 3, resource: { buffer: this._shapeBuffer } },
      ],
    });
    this._wgWidth  = Math.ceil(outTexture.width);
    this._wgHeight = Math.ceil(outTexture.height);
  }

  // ── Dispatch the appropriate compute pipeline ─────────────────────────────
  compute(pass) {
    const pipeline = this._camera?._isProjective
      ? this._computeProjectivePipeline
      : this._computePipeline;
    pass.setPipeline(pipeline);
    pass.setBindGroup(0, this._bindGroup);
    pass.dispatchWorkgroups(
      Math.ceil(this._wgWidth  / 16),
      Math.ceil(this._wgHeight / 16)
    );
  }
}
