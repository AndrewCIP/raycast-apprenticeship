struct tint_symbol_2_block {
  /* @offset(0) */
  inner : f32,
}

var<private> tint_symbol_4_1 : vec3u;

@group(0) @binding(0) var tint_symbol : texture_2d<f32>;

@group(0) @binding(1) var tint_symbol_1 : texture_storage_2d<rgba8unorm, write>;

@group(0) @binding(2) var<uniform> tint_symbol_2 : tint_symbol_2_block;

fn tint_symbol_3_inner(tint_symbol_4 : vec3u) {
  var x_44 = vec3f();
  let x_20 = bitcast<vec2i>(tint_symbol_4.xy);
  let x_25 = textureLoad(tint_symbol, x_20, 0i);
  let x_36 = mix(x_25.xyz, vec3f(dot(x_25.xyz, vec3f(0.29899999499320983887f, 0.58700001239776611328f, 0.11400000005960464478f))), vec3f(tint_symbol_2.inner));
  textureStore(tint_symbol_1, x_20, vec4f(x_36.x, x_36.y, x_36.z, x_25.w));
  return;
}

fn tint_symbol_3_1() {
  let x_59 = tint_symbol_4_1;
  tint_symbol_3_inner(x_59);
  return;
}

@compute @workgroup_size(8i, 8i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_4_1_param : vec3u) {
  tint_symbol_4_1 = tint_symbol_4_1_param;
  tint_symbol_3_1();
}
