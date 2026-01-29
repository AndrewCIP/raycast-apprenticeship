import Camera2DVertexObject from "/lib/Scene/Camera2DVertexObject.js";

 export default class Grid extends Camera2DVertexObject {
   constructor(device, canvasFormat, cameraPose, vertices, shaderFile, topology, numInstances) {
    super(device, canvasFormat, cameraPose, vertices, shaderFile, topology, numInstances);
   }

   async createGeometry() {
    super.createGeometry();
    // an array of cell statuses in CPU
    this._cellStatus = new Uint32Array(10 * 10); 

    // Create a storage ping-pong-buffer to hold the cell status.
    this._cellStateBuffers = [
        this._device.createBuffer({
        label: "Grid status Buffer 1 " + this.getName(),
        size: this._cellStatus.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
        }),
        this._device.createBuffer({
        label: "Grid status Buffer 2 " + this.getName(),
        size: this._cellStatus.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
        })
    ];
    // Copy from CPU to GPU
    this._device.queue.writeBuffer(this._cellStateBuffers[0], 0, this._cellStatus);
    // Set a step counter
    this._step = 0;
   }

   async createRenderPipeline() {
    super.createRenderPipeline();
    // create bind group to bind the uniform buffer and the storage buffers
    this._bindGroups = [
        this._device.createBindGroup({
        label: "Grid Bind Group 1 " + this.getName(),
        layout: this._renderPipeline.getBindGroupLayout(0),
        entries: [{
            binding: 0,
            resource: { buffer: this._cameraPoseBuffer }
        }, {
            binding: 1,
            resource: { buffer: this._cellStateBuffers[0] }
        },
        {
            binding: 2,
            resource: { buffer: this._cellStateBuffers[1] }
        }],
        }),
        this._device.createBindGroup({
        label: "Grid Bind Group 2 " + this.getName(),
        layout: this._renderPipeline.getBindGroupLayout(0),
        entries: [{
            binding: 0,
            resource: { buffer: this._cameraPoseBuffer }
        }, {
            binding: 1,
            resource: { buffer: this._cellStateBuffers[1] }
        },
        {
            binding: 2,
            resource: { buffer: this._cellStateBuffers[0] }
        }],
        })
    ];
   }

   render(pass) {
    // add to render pass to draw the object
    pass.setPipeline(this._renderPipeline);
    pass.setVertexBuffer(0, this._vertexBuffer);
    pass.setBindGroup(0, this._bindGroups[this._step % 2]);  // <- this line is different
    pass.draw(this._vertices.length / 2, this._numInstances);
   }
 }