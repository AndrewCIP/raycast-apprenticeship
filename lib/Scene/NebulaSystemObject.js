/*
 * NebulaSystemObject.js
 *
 * WebGPU particle system – Effect 2: Space Nebula.
 *
 * Ten thousand drifting particles in a blue/purple/teal colour palette.
 * Arrow keys steer a wind force; holding the mouse button pulls all
 * particles toward the cursor. Particles wrap toroidally at the screen edges
 * and are slowly respawned at random positions as they age out.
 *
 * GPU layout (nebula_particles.wgsl):
 *   Particle struct  – 32 bytes / 8 f32 per particle
 *   Uniforms struct  – 32 bytes / 8 f32
 *   Bindings 0-1     – ping-pong particle storage buffers
 *   Binding  2       – uniform buffer (wind, mouse, attract, time)
 *   Binding  3       – soft-circle sprite texture (rgba8unorm, 64×64)
 *   Binding  4       – linear sampler
 */

import SceneObject from '/lib/Scene/SceneObject.js'

export default class NebulaSystemObject extends SceneObject {
  constructor(device, canvasFormat, shaderFile, numParticles = 10000) {
    super(device, canvasFormat, shaderFile);
    this._numParticles = numParticles;
    this._step = 0;
    // CPU-side uniform array: [windX, windY, mouseX, mouseY, attract, time, _pad1, _pad2]
    this._uniformsArray = new Float32Array([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
  }

  // ----------------------------------------------------------------
  // Public API called by the main script
  // ----------------------------------------------------------------

  /** Set the wind direction vector (normalised or raw key state). */
  setWind(x, y) {
    this._uniformsArray[0] = x;
    this._uniformsArray[1] = y;
  }

  /** Set mouse NDC position for the attraction force. */
  setMousePos(x, y) {
    this._uniformsArray[2] = x;
    this._uniformsArray[3] = y;
  }

  /** 1.0 = attract toward mouse; 0.0 = gentle drift toward centre. */
  setAttract(v) {
    this._uniformsArray[4] = v;
  }

  // ----------------------------------------------------------------
  // SceneObject interface
  // ----------------------------------------------------------------

  async createGeometry() {
    // 8 f32 per particle: [x, y, vx, vy, lifespan, maxLifespan, colorSeed, _pad]
    this._particles = new Float32Array(this._numParticles * 8);

    this._particleBuffers = [
      this._device.createBuffer({
        label: 'Nebula Buffer 0 ' + this.getName(),
        size: this._particles.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
      }),
      this._device.createBuffer({
        label: 'Nebula Buffer 1 ' + this.getName(),
        size: this._particles.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
      }),
    ];

    this._uniformsBuffer = this._device.createBuffer({
      label: 'Nebula Uniforms ' + this.getName(),
      size: this._uniformsArray.byteLength,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });

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
      label: 'Nebula BGL ' + this.getName(),
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
      label: 'Nebula Pipeline Layout ' + this.getName(),
      bindGroupLayouts: [this._bindGroupLayout],
    });
  }

  async createRenderPipeline() {
    this._renderPipeline = this._device.createRenderPipeline({
      label: 'Nebula Render Pipeline ' + this.getName(),
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
          // Additive blending creates a luminous nebula look
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
      label: 'Nebula Compute Pipeline ' + this.getName(),
      layout: this._pipelineLayout,
      compute: { module: this._shaderModule, entryPoint: 'computeMain' },
    });
  }

  render(pass) {
    pass.setPipeline(this._renderPipeline);
    pass.setBindGroup(0, this._bindGroups[this._step % 2]);
    pass.draw(6, this._numParticles);
  }

  compute(pass) {
    this._uniformsArray[5] = performance.now() / 1000.0;
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
    for (let i = 0; i < this._numParticles; i++) {
      const base = i * 8;
      // Random position across the full NDC screen
      this._particles[base + 0] = Math.random() * 2.0 - 1.0;
      this._particles[base + 1] = Math.random() * 2.0 - 1.0;
      // Slow random drift
      const angle = Math.random() * Math.PI * 2;
      const speed = 0.0005 + Math.random() * 0.002;
      this._particles[base + 2] = Math.cos(angle) * speed;
      this._particles[base + 3] = Math.sin(angle) * speed;
      // Stagger lifespans
      const maxLife = 200 + Math.random() * 200;
      this._particles[base + 4] = maxLife * Math.random();
      this._particles[base + 5] = maxLife;
      this._particles[base + 6] = Math.random(); // colorSeed
      this._particles[base + 7] = 0.0;           // _pad
    }
    this._device.queue.writeBuffer(this._particleBuffers[0], 0, this._particles);
  }

  /**
   * Procedural 64×64 RGBA soft-circle sprite: white centre fading to
   * transparent at the edge via a quadratic falloff on the alpha channel.
   */
  _createSpriteTexture() {
    const size = 64;
    const half = size / 2;
    const data = new Uint8Array(size * size * 4);

    for (let y = 0; y < size; y++) {
      for (let x = 0; x < size; x++) {
        const dx = x - half, dy = y - half;
        const dist = Math.sqrt(dx * dx + dy * dy) / half;
        const alpha = Math.max(0, 1.0 - dist * dist);
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
