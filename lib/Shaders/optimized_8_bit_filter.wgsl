var<private> tint_symbol_3_1 : vec3u;

@group(0) @binding(0) var tint_symbol : texture_2d<f32>;

@group(0) @binding(1) var tint_symbol_1 : texture_storage_2d<rgba8unorm, write>;

fn tint_symbol_2_inner(tint_symbol_3 : vec3u) {
  let x_17 = bitcast<vec2i>(tint_symbol_3.xy);
  let x_22 = textureLoad(tint_symbol, x_17, 0i);
  textureStore(tint_symbol_1, x_17, vec4f((floor((x_22.x * 7.0f)) / 7.0f), (floor((x_22.y * 7.0f)) / 7.0f), (floor((x_22.z * 7.0f)) / 7.0f), x_22.w));
  return;
}

fn tint_symbol_2_1() {
  let x_48 = tint_symbol_3_1;
  tint_symbol_2_inner(x_48);
  return;
}

@compute @workgroup_size(8i, 8i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_3_1_param : vec3u) {
  tint_symbol_3_1 = tint_symbol_3_1_param;
  tint_symbol_2_1();
}
