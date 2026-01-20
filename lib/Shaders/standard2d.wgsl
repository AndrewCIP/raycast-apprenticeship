 struct Uniforms {
   color : vec4<f32>
 };

 @group(0) @binding(0)
 var<uniform> uniforms : Uniforms;

 struct VertexOut {
   @builtin(position) position : vec4<f32>,
 };

 @vertex // this compute the scene coordinate of each input vertex
 fn vertexMain(@location(0) position: vec2<f32>) -> VertexOut {
   var out : VertexOut;
   out.position = vec4<f32>(position, 0, 1);
   return out;
 }

 @fragment // this compute the color of each pixel
 fn fragmentMain() -> @location(0) vec4<f32> {
   return uniforms.color;
 }