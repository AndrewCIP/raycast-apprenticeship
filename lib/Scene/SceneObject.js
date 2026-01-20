 export default class SceneObject {
   static _objectCnt = 0;
   constructor(device, canvasFormat, shaderFile) {
     if (this.constructor == SceneObject) {
       throw new Error("Abstract classes can't be instantiated.");
     }
     this._device = device;
     this._canvasFormat = canvasFormat;
     this._shaderFile = shaderFile;
     this._color = new Float32Array([1, 1, 1, 1]); // default white
     SceneObject._objectCnt += 1;
   }

   getName() {
     return this.constructor.name + " " + SceneObject._objectCnt.toString();
   }

   async init() {
     await this.createGeometry();
     await this.createShaders();
     await this.createRenderPipeline();
     await this.createComputePipeline();
   }

   async createGeometry() { throw new Error("Method 'createGeometry()' must be implemented."); }

   updateGeometry() { }

   loadShader(filename) {
     return new Promise((resolve, reject) => {
       const xhttp = new XMLHttpRequest();
       xhttp.open("GET", filename);
       xhttp.setRequestHeader("Cache-Control", "no-cache, no-store, max-age=0");
       xhttp.onload = function() {
         if (xhttp.readyState === XMLHttpRequest.DONE && xhttp.status === 200) {
           resolve(xhttp.responseText);
         }
         else {
           reject({
             status: xhttp.status,
             statusText: xhttp.statusText
           });
         }
       };
       xhttp.onerror = function () {
         reject({
           status: xhttp.status,
           statusText: xhttp.statusText
         });
       };
       xhttp.send();
     });
   }

   async createShaders() { 
     let shaderCode = await this.loadShader(this._shaderFile);
     this._shaderModule = this._device.createShaderModule({
       label: " Shader " + this.getName(),
       code: shaderCode,
     }); 
   }

   createBindGroup(pipeline) {
    this._uniformBuffer = this._device.createBuffer({
      size: 16,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST
    });

    this._device.queue.writeBuffer(this._uniformBuffer, 0, this._color);

    this._bindGroup = this._device.createBindGroup({
      layout: pipeline.getBindGroupLayout(0),
      entries: [{
        binding: 0,
        resource: { buffer: this._uniformBuffer }
      }]
    });
   }

   setColor(r, g, b, a = 1) {
    this._color[0] = r;
    this._color[1] = g;
    this._color[2] = b;
    this._color[3] = a;

    if (this._uniformBuffer) {
      this._device.queue.writeBuffer(this._uniformBuffer, 0, this._color);
    } 
  }

   async createRenderPipeline() { throw new Error("Method 'createRenderPipeline()' must be implemented."); }

   render(pass) { throw new Error("Method 'render(pass)' must be implemented."); }

   async createComputePipeline() { throw new Error("Method 'createComputePipeline()' must be implemented."); }

   compute(pass) { throw new Error("Method 'compute(pass)' must be implemented."); }
 }