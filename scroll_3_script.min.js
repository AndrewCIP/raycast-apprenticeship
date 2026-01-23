class Renderer{constructor(canvas){this._canvas=canvas;this._objects=[];this._clearColor={r:0.95,g:0.92,b:0.88,a:1.0};}
async init(){if(!navigator.gpu){throw Error("WebGPU is not supported in this browser.");}
const adapter=await navigator.gpu.requestAdapter();if(!adapter){throw Error("Couldn't request WebGPU adapter.");}
this._device=await adapter.requestDevice();this._context=this._canvas.getContext("webgpu");this._canvasFormat=navigator.gpu.getPreferredCanvasFormat();this._context.configure({device:this._device,format:this._canvasFormat,});this.resizeCanvas();window.addEventListener('resize',this.resizeCanvas.bind(this));}
resizeCanvas(){const devicePixelRatio=window.devicePixelRatio||1;const width=window.innerWidth*devicePixelRatio;const height=window.innerHeight*devicePixelRatio;this._canvas.width=width;this._canvas.height=height;this._canvas.style.width=`${window.innerWidth}px`;this._canvas.style.height=`${window.innerHeight}px`;this.render();}
async appendSceneObject(obj){await obj.init();this._objects.push(obj);}
renderToSelectedView(outputView){for(const obj of this._objects){obj?.updateGeometry();}
let encoder=this._device.createCommandEncoder();const pass=encoder.beginRenderPass({colorAttachments:[{view:outputView,clearValue:this._clearColor,loadOp:"clear",storeOp:"store",}]});for(const obj of this._objects){obj?.render(pass);}
pass.end();const computePass=encoder.beginComputePass();for(const obj of this._objects){obj?.compute(computePass);}
computePass.end();const commandBuffer=encoder.finish();this._device.queue.submit([commandBuffer]);}
render(){this.renderToSelectedView(this._context.getCurrentTexture().createView());}}
class FilteredRenderer extends Renderer{constructor(canvas){super(canvas);this._filters=[];}
async init(){if(!navigator.gpu){throw Error("WebGPU is not supported in this browser.");}
const adapter=await navigator.gpu.requestAdapter();if(!adapter){throw Error("Couldn't request WebGPU adapter.");}
this._device=await adapter.requestDevice();this._context=this._canvas.getContext("webgpu");this._canvasFormat="rgba8unorm";this._context.configure({device:this._device,format:this._canvasFormat,});this._shaderModule=this._device.createShaderModule({label:"Image Filter Renderer Shader",code:`
      @vertex
      fn vertexMain(@builtin(vertex_index) vIdx: u32) -> @builtin(position) vec4f {
        var pos = array<vec2f, 6>(
          vec2f(-1, -1), vec2f(1, -1), vec2f(-1, 1),
          vec2f(-1, 1), vec2f(1, -1), vec2f(1, 1)
        );
        return vec4f(pos[vIdx], 0, 1);
      }
      
      @group(0) @binding(0) var inTexture: texture_2d<f32>;
      @group(0) @binding(1) var inSampler: sampler;
      
      @fragment
      fn fragmentMain(@builtin(position) fragCoord: vec4f) -> @location(0) vec4f {
        let uv = fragCoord.xy / vec2f(textureDimensions(inTexture, 0));
        return textureSample(inTexture, inSampler, uv);
      }
      `});this._pipeline=this._device.createRenderPipeline({label:"Image Filter Renderer Pipeline",layout:"auto",vertex:{module:this._shaderModule,entryPoint:"vertexMain",},fragment:{module:this._shaderModule,entryPoint:"fragmentMain",targets:[{format:this._canvasFormat}]}});this._sampler=this._device.createSampler({label:"Image Filter Renderer Sampler",magFilter:"linear",minFilter:"linear"});this.resizeCanvas();window.addEventListener('resize',this.resizeCanvas.bind(this));}
resizeCanvas(){const devicePixelRatio=window.devicePixelRatio||1;const width=window.innerWidth*devicePixelRatio;const height=window.innerHeight*devicePixelRatio;let imgSize={width:width,height:height};this._textures=[];this._textures.push(this._device.createTexture({size:imgSize,format:this._canvasFormat,usage:GPUTextureUsage.RENDER_ATTACHMENT|GPUTextureUsage.TEXTURE_BINDING|GPUTextureUsage.STORAGE_BINDING,}),this._device.createTexture({size:imgSize,format:this._canvasFormat,usage:GPUTextureUsage.RENDER_ATTACHMENT|GPUTextureUsage.TEXTURE_BINDING|GPUTextureUsage.STORAGE_BINDING,}),);for(const obj of this._filters){obj._imgWidth=this._textures[0].width;obj._imgHeight=this._textures[0].height;obj.updateGeometry();}
super.resizeCanvas();}
async appendFilterObject(obj){await obj.init();obj._imgWidth=this._textures[0].width;obj._imgHeight=this._textures[0].height;obj.updateGeometry();this._filters.push(obj);}
render(){super.renderToSelectedView(this._textures[0].createView());for(let i=0;i<this._filters.length;++i){let encoder=this._device.createCommandEncoder();const computePass=encoder.beginComputePass();this._filters[i].createBindGroup(this._textures[i%2],this._textures[(i+1)%2]);this._filters[i].compute(computePass);computePass.end();const commandBuffer=encoder.finish();this._device.queue.submit([commandBuffer]);}
let encoder=this._device.createCommandEncoder();const pass=encoder.beginRenderPass({colorAttachments:[{view:this._context.getCurrentTexture().createView(),clearValue:this._clearColor,loadOp:"clear",storeOp:"store",}]});const bindGroup=this._device.createBindGroup({label:"Image Filter Renderer Bind Group",layout:this._pipeline.getBindGroupLayout(0),entries:[{binding:0,resource:this._textures[this._filters.length%2].createView()},{binding:1,resource:this._sampler}],});pass.setPipeline(this._pipeline);pass.setBindGroup(0,bindGroup);pass.draw(6);pass.end();const commandBuffer=encoder.finish();this._device.queue.submit([commandBuffer]);}}
class SceneObject{static _objectCnt=0;constructor(device,canvasFormat,shaderFile){if(this.constructor==SceneObject){throw new Error("Abstract classes can't be instantiated.");}
this._device=device;this._canvasFormat=canvasFormat;this._shaderFile=shaderFile;SceneObject._objectCnt+=1;}
getName(){return this.constructor.name+" "+SceneObject._objectCnt.toString();}
async init(){await this.createGeometry();await this.createShaders();await this.createRenderPipeline();await this.createComputePipeline();}
async createGeometry(){throw new Error("Method 'createGeometry()' must be implemented.");}
updateGeometry(){}
loadShader(filename){return new Promise((resolve,reject)=>{const xhttp=new XMLHttpRequest();xhttp.open("GET",filename);xhttp.setRequestHeader("Cache-Control","no-cache, no-store, max-age=0");xhttp.onload=function(){if(xhttp.readyState===XMLHttpRequest.DONE&&xhttp.status===200){resolve(xhttp.responseText);}
else{reject({status:xhttp.status,statusText:xhttp.statusText});}};xhttp.onerror=function(){reject({status:xhttp.status,statusText:xhttp.statusText});};xhttp.send();});}
async createShaders(){let shaderCode=await this.loadShader(this._shaderFile);this._shaderModule=this._device.createShaderModule({label:" Shader "+this.getName(),code:shaderCode,});}
async createRenderPipeline(){throw new Error("Method 'createRenderPipeline()' must be implemented.");}
render(pass){throw new Error("Method 'render(pass)' must be implemented.");}
async createComputePipeline(){throw new Error("Method 'createComputePipeline()' must be implemented.");}
compute(pass){throw new Error("Method 'compute(pass)' must be implemented.");}}
class Standard2DFullScreenObject extends SceneObject{constructor(device,canvasFormat,img){super(device,canvasFormat,"/lib/Shaders/optimized_optimized_fullscreenTexture.wgsl");this._img=new Image();this._img.src=img;}
async createGeometry(){await this._img.decode();this._bitmap=await createImageBitmap(this._img);this._texture=this._device.createTexture({label:"Texture "+this.getName(),size:[this._bitmap.width,this._bitmap.height,1],format:"rgba8unorm",usage:GPUTextureUsage.TEXTURE_BINDING|GPUTextureUsage.COPY_DST|GPUTextureUsage.RENDER_ATTACHMENT,});this._device.queue.copyExternalImageToTexture({source:this._bitmap},{texture:this._texture},[this._bitmap.width,this._bitmap.height]);this._sampler=this._device.createSampler({magFilter:"linear",minFilter:"linear"});}
async createRenderPipeline(){this._renderPipeline=this._device.createRenderPipeline({label:"Render Pipeline "+this.getName(),layout:"auto",vertex:{module:this._shaderModule,entryPoint:"vertexMain",},fragment:{module:this._shaderModule,entryPoint:"fragmentMain",targets:[{format:this._canvasFormat}]}});this._bindGroup=this._device.createBindGroup({layout:this._renderPipeline.getBindGroupLayout(0),entries:[{binding:0,resource:this._texture.createView(),},{binding:1,resource:this._sampler,}],});}
render(pass){pass.setPipeline(this._renderPipeline);pass.setBindGroup(0,this._bindGroup);pass.draw(6,1,0,0);}
async createComputePipeline(){}
compute(pass){}};class ImageFilterObject extends SceneObject{async createGeometry(){}
updateGeometry(){}
async createRenderPipeline(){}
render(pass){}
async createComputePipeline(){this._computePipeline=this._device.createComputePipeline({label:"Image Filter Pipeline "+this.getName(),layout:"auto",compute:{module:this._shaderModule,entryPoint:"computeMain",}});}
createBindGroup(inTexture,outTexture){this._bindGroup=this._device.createBindGroup({label:"Image Filter Bind Group",layout:this._computePipeline.getBindGroupLayout(0),entries:[{binding:0,resource:inTexture.createView()},{binding:1,resource:outTexture.createView()}],});this._wgWidth=Math.ceil(inTexture.width);this._wgHeight=Math.ceil(inTexture.height);}
compute(pass){pass.setPipeline(this._computePipeline);pass.setBindGroup(0,this._bindGroup);pass.dispatchWorkgroups(this._wgWidth,this._wgHeight);}};;class ImageNosifyFilterObject extends ImageFilterObject{async createGeometry(){this.updateGeometry();}
updateGeometry(){if(this._imgWidth&&this._imgHeight){this._randomArray=new Float32Array(this._imgWidth*this._imgHeight);this._randomBuffer=this._device.createBuffer({label:"Random Buffer "+this.getName(),size:this._randomArray.byteLength,usage:GPUBufferUsage.STORAGE|GPUBufferUsage.COPY_DST,});for(let i=0;i<this._imgWidth*this._imgHeight;++i){this._randomArray[i]=Math.random()*2-1;}
this._device.queue.writeBuffer(this._randomBuffer,0,this._randomArray);}}
createBindGroup(inTexture,outTexture){this._bindGroup=this._device.createBindGroup({label:"Image Filter Bind Group",layout:this._computePipeline.getBindGroupLayout(0),entries:[{binding:0,resource:inTexture.createView()},{binding:1,resource:outTexture.createView()},{binding:2,resource:{buffer:this._randomBuffer}}],});this._wgWidth=Math.ceil(inTexture.width);this._wgHeight=Math.ceil(inTexture.height);}};;class Standard2DVertexObject extends SceneObject{constructor(device,canvasFormat,vertices,shaderFile,topology){super(device,canvasFormat,shaderFile);this._vertices=vertices;this._topology=topology;}
async createGeometry(){this._vertexBuffer=this._device.createBuffer({label:"Vertices "+this.getName(),size:this._vertices.byteLength,usage:GPUBufferUsage.VERTEX|GPUBufferUsage.COPY_DST,});this._device.queue.writeBuffer(this._vertexBuffer,0,this._vertices);this._vertexBufferLayout={arrayStride:2*Float32Array.BYTES_PER_ELEMENT,attributes:[{shaderLocation:0,format:"float32x2",offset:0,}],};}
async createRenderPipeline(){this._renderPipeline=this._device.createRenderPipeline({label:"Render Pipeline "+this.getName(),layout:"auto",vertex:{module:this._shaderModule,entryPoint:"vertexMain",buffers:[this._vertexBufferLayout]},fragment:{module:this._shaderModule,entryPoint:"fragmentMain",targets:[{format:this._canvasFormat}]},primitive:{topology:this._topology}});}
render(pass){pass.setPipeline(this._renderPipeline);pass.setVertexBuffer(0,this._vertexBuffer);pass.draw(this._vertices.length/2);}
async createComputePipeline(){}
compute(pass){}};class Standard2DGAPosedVertexObject extends Standard2DVertexObject{constructor(device,canvasFormat,vertices,pose,shaderFile,topology){super(device,canvasFormat,vertices,shaderFile,topology);this._pose=pose;}
async createGeometry(){super.createGeometry();this._poseBuffer=this._device.createBuffer({label:"Pose "+this.getName(),size:this._pose.byteLength,usage:GPUBufferUsage.UNIFORM|GPUBufferUsage.COPY_DST,});this.updateGeometry();}
updateGeometry(){this._device.queue.writeBuffer(this._poseBuffer,0,this._pose);}
async createRenderPipeline(){super.createRenderPipeline();this._bindGroup=this._device.createBindGroup({label:"Render Bind Group "+this.getName(),layout:this._renderPipeline.getBindGroupLayout(0),entries:[{binding:0,resource:{buffer:this._poseBuffer},}],});}
render(pass){pass.setBindGroup(0,this._bindGroup);super.render(pass);}};async function init(){const canvasTag=document.createElement('canvas');canvasTag.id="renderCanvas";document.body.appendChild(canvasTag);const renderer=new Renderer(canvasTag);await renderer.init();var vertices=new Float32Array([0,0.25,-0.25,0,0.25,0,]);let geometricProduct=(a,b)=>{return[a[0]*b[0]-a[1]*b[1],a[0]*b[1]+a[1]*b[0],a[0]*b[2]+a[1]*b[3]+a[2]*b[0]-a[3]*b[1],a[0]*b[3]-a[1]*b[2]+a[2]*b[1]+a[3]*b[0]];};let reverse=(a)=>{return[a[0],-a[1],-a[2],-a[3]];};let motorNorm=(m)=>{return Math.sqrt(m[0]*m[0]+m[1]*m[1]+m[2]*m[2]+m[3]*m[3]);};let normalizeMotor=(m)=>{let mnorm=motorNorm(m);if(mnorm==0.0){return[1,0,0,0];}
return[m[0]/mnorm,m[1]/mnorm,m[2]/mnorm,m[3]/mnorm];};let easeInEaseOut=(t)=>{if(t>0.5)return t*(4-2*t)-1;else return 2*t*t;}
console.log(LinearInterpolate(0,10,0.5));await renderer.appendSceneObject(new Standard2DFullScreenObject(renderer._device,renderer._canvasFormat,"/assets/kirby_background.jpg"));await renderer.appendFilterObject(new ImageFilterObject(renderer._device,renderer._canvasFormat,"/lib/Shaders/optimized_8_bit_filter.wgsl"));await renderer.appendFilterObject(new ImageNosifyFilterObject(renderer._device,renderer._canvasFormat,"/lib/Shaders/optimized_nosify.wgsl"));let pose0=normalizeMotor([1,0,-0.2,-0.25]);let pose1=normalizeMotor([0,1,-0.25,0.4]);var pose=new Float32Array([pose0[0],pose0[1],pose0[2],pose0[3],1,1]);await renderer.appendSceneObject(new Standard2DGAPosedVertexObject(renderer._device,renderer._canvasFormat,vertices,pose,"/lib/Shaders/optimized_projective_geometric_algebra.wgsl","triangle-list"));let angle=Math.PI/100;let center=[0,0];let dr=normalizeMotor([Math.cos(angle/2),-Math.sin(angle/2),-center[0]*Math.sin(angle/2),-center[1]*Math.sin(angle/2)]);let dt=normalizeMotor([1,0,0.01/2,0/2]);let dm=normalizeMotor(geometricProduct(dt,dr));let timerMs=100;let steps=100;let i=0;let dir=1;renderer.render();setInterval(()=>{let t=i/steps;let tNew=easeInEaseOut(t);renderer.render();let m=[LinearInterpolate(pose0[0],pose1[0],tNew),LinearInterpolate(pose0[1],pose1[1],tNew),LinearInterpolate(pose0[2],pose1[2],tNew),LinearInterpolate(pose0[3],pose1[3],tNew),];m=normalizeMotor(m);pose[0]=m[0];pose[1]=m[1];pose[2]=m[2];pose[3]=m[3];i+=dir;if(i>=steps)dir=-1;if(i<=0)dir=1;},timerMs);return renderer;}
function LinearInterpolate(A,B,t){return A*(1-t)+B*t;}
init().then(ret=>{console.log(ret);}).catch(error=>{const pTag=document.createElement('p');pTag.innerHTML=navigator.userAgent+"</br>"+error.message;document.body.appendChild(pTag);document.getElementById("renderCanvas").remove();});