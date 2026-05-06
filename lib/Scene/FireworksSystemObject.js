/*
 * FireworksSystemObject.js
 *
 * WebGPU particle system – Effect 1: Fireworks.
 *
 * Particles burst outward from an emitter whose position is updated by the
 * main script on every mouse click. Gravity pulls sparks downward; they
 * fade over their lifespan and respawn at the emitter when dead.
 *
 * GPU layout (fireworks_particles.wgsl):
 *   Particle struct  – 48 bytes / 12 f32 per particle
 *   Uniforms struct  – 16 bytes / 4  f32
 *   Bindings 0-1     – ping-pong particle storage buffers
 *   Binding  2       – uniform buffer (emitter pos + time)
 *   Binding  3       – soft-circle sprite texture (rgba8unorm, 64×64)
 *   Binding  4       – linear sampler
 */

import SceneObject from '/lib/Scene/SceneObject.js'

export default class FireworksSystemObject extends SceneObject {
  constructor(device, canvasFormat, shaderFile, numParticles = 10000) {
    super(device, canvasFormat, shaderFile);
    this._numParticles = numParticles;
    this._step = 0;
    // CPU-side uniform array: [emitterX, emitterY, time, _pad]
    this._uniformsArray = new Float32Array([0.0, 0.0, 0.0, 0.0]);
  }

  // ----------------------------------------------------------------
  // Public API called by the main script
  // ----------------------------------------------------------------

  /** Move the fireworks emitter to NDC coordinates (x, y). */
  setEmitter(x, y) {
    this._uniformsArray[0] = x;
    this._uniformsArray[1] = y;
  }

  // ----------------------------------------------------------------
  // SceneObject interface
  // ----------------------------------------------------------------

  async createGeometry() {
    // 12 f32 per particle: [x, y, vx, vy, r, g, b, a, lifespan, maxLifespan, 0, 0]
    this._particles = new Float32Array(this._numParticles * 12);

    this._particleBuffers = [
      this._device.createBuffer({
        label: 'Fireworks Buffer 0 ' + this.getName(),
        size: this._particles.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
      }),
      this._device.createBuffer({
        label: 'Fireworks Buffer 1 ' + this.getName(),
        size: this._particles.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
      }),
    ];

    this._uniformsBuffer = this._device.createBuffer({
      label: 'Fireworks Uniforms ' + this.getName(),
      size: this._uniformsArray.byteLength,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });

    // Procedural soft-circle sprite texture
    this._spriteTexture = this._createSpriteTexture();
    this._spriteSampler = this._device.createSampler({
      magFilter: 'linear',
      minFilter: 'linear',
    });

    this._step = 0;
    this._resetParticles();
  }

  updateGeometry() {}

  async createShaders() {
    await super.createShaders();
    this._bindGroupLayout = this._device.createBindGroupLayout({
      label: 'Fireworks BGL ' + this.getName(),
      entries: [
        {
          binding: 0,
          visibility: GPUShaderStage.VERTEX | GPUShaderStage.COMPUTE,
          buffer: { type: 'read-only-storage' },
        },
        {
          binding: 1,
          visibility: GPUShaderStage.COMPUTE,
          buffer: { type: 'storage' },
        },
        {
          binding: 2,
          visibility: GPUShaderStage.COMPUTE,
          buffer: { type: 'uniform' },
        },
        {
          binding: 3,
          visibility: GPUShaderStage.VERTEX | GPUShaderStage.FRAGMENT,
          texture: {},
        },
        {
          binding: 4,
          visibility: GPUShaderStage.VERTEX | GPUShaderStage.FRAGMENT,
          sampler: {},
        },
      ],
    });
    this._pipelineLayout = this._device.createPipelineLayout({
      label: 'Fireworks Pipeline Layout ' + this.getName(),
      bindGroupLayouts: [this._bindGroupLayout],
    });
  }

  async createRenderPipeline() {
    this._renderPipeline = this._device.createRenderPipeline({
      label: 'Fireworks Render Pipeline ' + this.getName(),
      layout: this._pipelineLayout,
      vertex: {
        module: this._shaderModule,
        entryPoint: 'vertexMain',
      },
      fragment: {
        module: this._shaderModule,
        entryPoint: 'fragmentMain',
        targets: [{
          format: this._canvasFormat,
          // Additive blending – sparks glow and layer on top of each other
          blend: {
            color: { srcFactor: 'src-alpha', dstFactor: 'one', operation: 'add' },
            alpha: { srcFactor: 'one',       dstFactor: 'one', operation: 'add' },
          },
        }],
      },
      primitive: { topology: 'triangle-list' },
    });

    this._bindGroups = this._createBindGroups(this._renderPipeline);
  }

  async createComputePipeline() {
    this._computePipeline = this._device.createComputePipeline({
      label: 'Fireworks Compute Pipeline ' + this.getName(),
      layout: this._pipelineLayout,
      compute: { module: this._shaderModule, entryPoint: 'computeMain' },
    });
  }

  render(pass) {
    pass.setPipeline(this._renderPipeline);
    pass.setBindGroup(0, this._bindGroups[this._step % 2]);
    pass.draw(6, this._numParticles); // 6 vertices per textured quad
  }

  compute(pass) {
    // Update time uniform each frame
    this._uniformsArray[2] = performance.now() / 1000.0;
    this._device.queue.writeBuffer(this._uniformsBuffer, 0, this._uniformsArray);

    pass.setPipeline(this._computePipeline);
    pass.setBindGroup(0, this._bindGroups[this._step % 2]);
    pass.dispatchWorkgroups(Math.ceil(this._numParticles / 256));
    ++this._step;
  }

  // ----------------------------------------------------------------
  // Private helpers
  // ----------------------------------------------------------------

  _resetParticles() {
    const colors = [
      [1.0, 0.15, 0.05],
      [1.0, 0.55, 0.05],
      [1.0, 1.00, 0.20],
      [0.40, 0.80, 1.0],
      [0.90, 0.40, 1.0],
    ];

    for (let i = 0; i < this._numParticles; i++) {
      const base = i * 12;
      // Start at emitter (centre)
      this._particles[base + 0] = 0.0;
      this._particles[base + 1] = 0.0;
      // Random outward burst velocity
      const angle = Math.random() * Math.PI * 2;
      const speed = 0.004 + Math.random() * 0.018;
      this._particles[base + 2] = Math.cos(angle) * speed;
      this._particles[base + 3] = Math.sin(angle) * speed;
      // Random colour
      const c = colors[Math.floor(Math.random() * colors.length)];
      this._particles[base + 4] = c[0];
      this._particles[base + 5] = c[1];
      this._particles[base + 6] = c[2];
      this._particles[base + 7] = 1.0;
      // Stagger lifespans so not all sparks die at once
      const maxLife = 80 + Math.random() * 120;
      this._particles[base + 8]  = maxLife * Math.random();
      this._particles[base + 9]  = maxLife;
      this._particles[base + 10] = 0.0; // _pad1
      this._particles[base + 11] = 0.0; // _pad2
    }
    this._device.queue.writeBuffer(this._particleBuffers[0], 0, this._particles);
  }

  /**
   * Generates a 64×64 RGBA soft-circle sprite texture on the GPU.
   * The centre is fully opaque white; alpha falls off quadratically to 0
   * at the edge, producing a smooth glowing-dot appearance.
   */
  _createSpriteTexture() {
    const size = 64;
    const half = size / 2;
    const data = new Uint8Array(size * size * 4);

    for (let y = 0; y < size; y++) {
      for (let x = 0; x < size; x++) {
        const dx = x - half, dy = y - half;
        const dist = Math.sqrt(dx * dx + dy * dy) / half;
        const alpha = Math.max(0, 1.0 - dist * dist); // quadratic falloff
        const i = (y * size + x) * 4;
        data[i + 0] = 255;
        data[i + 1] = 255;
        data[i + 2] = 255;
        data[i + 3] = Math.round(alpha * 255);
      }
    }

    const texture = this._device.createTexture({
      size: [size, size, 1],
      format: 'rgba8unorm',
      usage: GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.COPY_DST,
    });
    this._device.queue.writeTexture(
      { texture },
      data,
      { bytesPerRow: size * 4 },
      [size, size],
    );
    return texture;
  }

  _createBindGroups(pipeline) {
    return [0, 1].map(i => this._device.createBindGroup({
      layout: pipeline.getBindGroupLayout(0),
      entries: [
        { binding: 0, resource: { buffer: this._particleBuffers[i] } },
        { binding: 1, resource: { buffer: this._particleBuffers[1 - i] } },
        { binding: 2, resource: { buffer: this._uniformsBuffer } },
        { binding: 3, resource: this._spriteTexture.createView() },
        { binding: 4, resource: this._spriteSampler },
      ],
    }));
  }
}
