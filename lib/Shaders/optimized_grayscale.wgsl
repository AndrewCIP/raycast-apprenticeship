var<private> tint_symbol_4_1 : vec3u;

@group(0) @binding(0) var tint_symbol : texture_2d<f32>;

@group(0) @binding(1) var tint_symbol_1 : texture_storage_2d<rgba8unorm, write>;

fn tint_symbol_3_inner(tint_symbol_4 : vec3u) {
  var x_50 = vec3f();
  if (any((tint_symbol_4.xy >= bitcast<vec2u>(vec2i(textureDimensions(tint_symbol, 0i)))))) {
    return;
  }
  let x_32 = bitcast<vec2i>(tint_symbol_4.xy);
  let x_35 = textureLoad(tint_symbol, x_32, 0i);
  let x_45 = mix(x_35.xyz, vec3f(dot(x_35.xyz, vec3f(0.29899999499320983887f, 0.58700001239776611328f, 0.11400000005960464478f))), vec3f(1.0f));
  textureStore(tint_symbol_1, x_32, vec4f(x_45.x, x_45.y, x_45.z, x_35.w));
  return;
}

fn tint_symbol_3_1() {
  let x_65 = tint_symbol_4_1;
  tint_symbol_3_inner(x_65);
  return;
}

@compute @workgroup_size(8i, 8i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_4_1_param : vec3u) {
  tint_symbol_4_1 = tint_symbol_4_1_param;
  tint_symbol_3_1();
}
