struct Transform {
  position : vec2f
}

@group(0) @binding(0)
var<uniform> transform : Transform;

@vertex // this compute the scene coordinate of each input vertex
 fn vertexMain(@location(0) pos: vec2f) -> @builtin(position) vec4f {
   let translation = pos + transform.position;
   return vec4f(translation, 0, 1); // (translation, Z, W) = (X, Y, Z, W)
 }

 @fragment // this compute the color of each pixel
 fn fragmentMain() -> @location(0) vec4f {
   return vec4f(238.f/255, 118.f/255, 35.f/255, 1); // (R, G, B, A)
 }
