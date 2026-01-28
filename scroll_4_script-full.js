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
class PGA2D{static geometricProduct(a,b){return[a[0]*b[0]-a[1]*b[1],a[0]*b[1]+a[1]*b[0],a[0]*b[2]+a[1]*b[3]+a[2]*b[0]-a[3]*b[1],a[0]*b[3]-a[1]*b[2]+a[2]*b[1]+a[3]*b[0]];}
static reverse(a){return[a[0],-a[1],-a[2],-a[3]];}
static applyMotor(p,m){return PGA2D.geometricProduct(m,PGA2D.geometricProduct(p,PGA2D.reverse(m)));}
static motorNorm(m){return Math.sqrt(m[0]*m[0]+m[1]*m[1]+m[2]*m[2]+m[3]*m[3]);}
static createTranslator(dx,dy){return[1,0,-dx/2,-dy/2]}
static createRotor(angle,cx=0,cy=0){let p=PGA2D.createPoint(cx,cy);return[Math.cos(angle/2),Math.sin(angle/2)*p[1],Math.sin(angle/2)*p[2],Math.sin(angle/2)*p[3]];}
static createPoint(x,y){return[0,1,y,-x];}
static extractPoint(p){return[-p[3]/p[1],p[2]/p[1]];}
static normalizeMotor(m){let mnorm=PGA2D.motorNorm(m);if(mnorm==0.0){return[1,0,0,0];}
return[m[0]/mnorm,m[1]/mnorm,m[2]/mnorm,m[3]/mnorm];}
static applyMotorToPoint(p,m){let new_p=PGA2D.applyMotor(PGA2D.createPoint(p[0],p[1]),m);return PGA2D.extractPoint(new_p);};static isInside(v0,v1,p){const edge=PGA2D.createPoint(v1[0]-v0[0],v1[1]-v0[1]);const point=PGA2D.createPoint(p[0]-v0[0],p[1]-v0[1]);return(v1[0]-v0[0])*(p[1]-v0[1])-(v1[1]-v0[1])*(p[0]-v0[0])>0;}};class Camera{constructor(){this._pose=new Float32Array([1,0,0,0,1,1]);}
updatePose(newpose){this._pose[0]=newpose[0];this._pose[1]=newpose[1];this._pose[2]=newpose[2];this._pose[3]=newpose[3];}
moveLeft(d){let dt=PGA2D.createTranslator(-d,0);let newpose=PGA2D.normalizeMotor(PGA2D.geometricProduct(dt,[this._pose[0],this._pose[1],this._pose[2],this._pose[3]]));this.updatePose(newpose);}
moveRight(d){let dt=PGA2D.createTranslator(d,0);let newpose=PGA2D.normalizeMotor(PGA2D.geometricProduct(dt,[this._pose[0],this._pose[1],this._pose[2],this._pose[3]]));this.updatePose(newpose);}
moveUp(d){let dt=PGA2D.createTranslator(0,d);let newpose=PGA2D.normalizeMotor(PGA2D.geometricProduct(dt,[this._pose[0],this._pose[1],this._pose[2],this._pose[3]]));this.updatePose(newpose);}
moveDown(d){let dt=PGA2D.createTranslator(0,-d);let newpose=PGA2D.normalizeMotor(PGA2D.geometricProduct(dt,[this._pose[0],this._pose[1],this._pose[2],this._pose[3]]));this.updatePose(newpose);}
zoomIn(){this._pose[4]*=1.1;this._pose[5]*=1.1;}
zoomOut(){this._pose[4]/=1.1;this._pose[5]/=1.1;}}
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
compute(pass){throw new Error("Method 'compute(pass)' must be implemented.");}};class cameraPose2DVertexObject extends SceneObject{constructor(device,canvasFormat,cameraPose,vertices,shaderFile,topology){super(device,canvasFormat,shaderFile);this._cameraPose=cameraPose;this._vertices=vertices;this._topology=topology;}
async createGeometry(){this._vertexBuffer=this._device.createBuffer({label:"Vertices "+this.getName(),size:this._vertices.byteLength,usage:GPUBufferUsage.VERTEX|GPUBufferUsage.COPY_DST,});this._device.queue.writeBuffer(this._vertexBuffer,0,this._vertices);this._vertexBufferLayout={arrayStride:2*Float32Array.BYTES_PER_ELEMENT,attributes:[{shaderLocation:0,format:"float32x2",offset:0,}],};this._cameraPoseBuffer=this._device.createBuffer({label:"Camera Pose "+this.getName(),size:this._cameraPose.byteLength,usage:GPUBufferUsage.UNIFORM|GPUBufferUsage.COPY_DST,});this._device.queue.writeBuffer(this._cameraPoseBuffer,0,this._cameraPose);}
async createRenderPipeline(){this._renderPipeline=this._device.createRenderPipeline({label:"Render Pipeline "+this.getName(),layout:"auto",vertex:{module:this._shaderModule,entryPoint:"vertexMain",buffers:[this._vertexBufferLayout]},fragment:{module:this._shaderModule,entryPoint:"fragmentMain",targets:[{format:this._canvasFormat}]},primitive:{topology:this._topology}});this._bindGroup=this._device.createBindGroup({label:"Renderer Bind Group "+this.getName(),layout:this._renderPipeline.getBindGroupLayout(0),entries:[{binding:0,resource:{buffer:this._cameraPoseBuffer}}],});}
updateCameraPose(){this._device.queue.writeBuffer(this._cameraPoseBuffer,0,this._cameraPose);}
render(pass){pass.setPipeline(this._renderPipeline);pass.setVertexBuffer(0,this._vertexBuffer);pass.setBindGroup(0,this._bindGroup);pass.draw(this._vertices.length/2);}
async createComputePipeline(){}
compute(pass){}}
async function init(){const canvasTag=document.createElement('canvas');canvasTag.id="renderCanvas";document.body.appendChild(canvasTag);const renderer=new Renderer(canvasTag);await renderer.init();let camera=new Camera();let triangle=new Camera2DVertexObject(renderer._device,renderer._canvasFormat,camera._pose,new Float32Array([0,0.5,-0.5,0,0.5,0]),"/lib/Shaders/optimized_reverse_camera_pga.wgsl");await renderer.appendSceneObject(triangle);var movespeed=0.05;window.addEventListener("keydown",(e)=>{switch(e.key){case'ArrowUp':case'w':case'W':camera.moveUp(movespeed);triangle.updateCameraPose();break;case'ArrowDown':case's':case'S':camera.moveDown(movespeed);triangle.updateCameraPose();break;case'ArrowLeft':case'a':case'A':camera.moveLeft(movespeed);triangle.updateCameraPose();break;case'ArrowRight':case'd':case'D':camera.moveRight(movespeed);triangle.updateCameraPose();break;case'q':case'Q':camera.zoomIn();triangle.updateCameraPose();break;case'e':case'E':camera.zoomOut();triangle.updateCameraPose();break;}});let prevP={x:0,y:0};let dragging=false;canvasTag.addEventListener('mousemove',(e)=>{if(!dragging)return;const ndc=mouseToNDC(e);const dx=ndc[0]-prevP.x;const dy=ndc[1]-prevP.y;let diff=Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2));if(diff>0.001){prevP.x=ndc[0];prevP.y=ndc[1];if(dx>0)camera.moveRight(-dx);else camera.moveLeft(dx);if(dy>0)camera.moveUp(-dy);else camera.moveDown(dy);triangle.updateCameraPose();renderer.render();}});canvasTag.addEventListener('mousedown',(e)=>{dragging=true;const ndc=mouseToNDC(e);prevP.x=ndc[0];prevP.y=ndc[1];});canvasTag.addEventListener('mouseup',(e)=>{dragging=false;});canvasTag.addEventListener('mouseleave',(e)=>{dragging=false;});var frameCnt=0;var tgtFPS=60;var secPerFrame=1./tgtFPS;var frameInterval=secPerFrame*1000;var lastCalled;let renderFrame=()=>{let elapsed=Date.now()-lastCalled;if(elapsed>frameInterval){++frameCnt;lastCalled=Date.now()-(elapsed%frameInterval);renderer.render();}
requestAnimationFrame(renderFrame);};lastCalled=Date.now();renderFrame();setInterval(()=>{console.log(frameCnt);frameCnt=0;},1000);return renderer;}
function mouseToNDC(e){const x=(e.clientX/window.innerWidth)*2-1;const y=(-e.clientY/window.innerHeight)*2+1;return[x,y];}
init().then(ret=>{console.log(ret);}).catch(error=>{const pTag=document.createElement('p');pTag.innerHTML=navigator.userAgent+"</br>"+error.message;document.body.appendChild(pTag);document.getElementById("renderCanvas").remove();});