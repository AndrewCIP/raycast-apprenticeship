struct tint_symbol {
  /* @offset(0) */
  tint_symbol_1 : f32,
}

struct tint_symbol_2_block {
  /* @offset(0) */
  inner : tint_symbol,
}

struct tint_symbol_8 {
  /* @offset(0) */
  tint_symbol_6 : vec4f,
  /* @offset(16) */
  tint_symbol_7 : vec2f,
}

struct tint_symbol_5 {
  /* @offset(0) */
  tint_symbol_6 : vec3f,
  /* @offset(16) */
  tint_symbol_7 : vec2f,
}

var<private> tint_symbol_6_1 : vec3f;

var<private> tint_symbol_7_1 : vec2f;

var<private> tint_symbol_6_2 = vec4f();

var<private> tint_symbol_7_2 = vec2f();

var<private> tint_symbol_6_3 : vec4f;

var<private> tint_symbol_7_3 : vec2f;

var<private> value = vec4f();

@group(0) @binding(0) var<uniform> tint_symbol_2 : tint_symbol_2_block;

@group(0) @binding(1) var tint_symbol_3 : texture_2d<f32>;

@group(0) @binding(2) var tint_symbol_4 : sampler;

fn tint_symbol_9_inner(tint_symbol_10 : tint_symbol_5) -> tint_symbol_8 {
  var tint_symbol_11 = tint_symbol_8(vec4f(), vec2f());
  let x_45 = tint_symbol_10.tint_symbol_6;
  tint_symbol_11.tint_symbol_6 = vec4f(x_45.x, x_45.y, x_45.z, 1.0f);
  tint_symbol_11.tint_symbol_7 = tint_symbol_10.tint_symbol_7;
  let x_55 = tint_symbol_11;
  return x_55;
}

fn tint_symbol_9_1() {
  let x_61 = tint_symbol_6_1;
  let x_62 = tint_symbol_7_1;
  let x_60 = tint_symbol_9_inner(tint_symbol_5(x_61, x_62));
  tint_symbol_6_2 = x_60.tint_symbol_6;
  tint_symbol_7_2 = x_60.tint_symbol_7;
  return;
}

struct tint_symbol_9_out {
  @builtin(position)
  tint_symbol_6_2_1 : vec4f,
  @location(0)
  tint_symbol_7_2_1 : vec2f,
}

@vertex
fn vs_main(@location(0) tint_symbol_6_1_param : vec3f, @location(1) tint_symbol_7_1_param : vec2f) -> tint_symbol_9_out {
  tint_symbol_6_1 = tint_symbol_6_1_param;
  tint_symbol_7_1 = tint_symbol_7_1_param;
  tint_symbol_9_1();
  return tint_symbol_9_out(tint_symbol_6_2, tint_symbol_7_2);
}

fn tint_symbol_12_inner(tint_symbol_10_1 : tint_symbol_8) -> vec4f {
  var x_89 = vec3f();
  let x_70 = textureSample(tint_symbol_3, tint_symbol_4, tint_symbol_10_1.tint_symbol_7);
  let x_82 = mix(x_70.xyz, vec3f(dot(x_70.xyz, vec3f(0.29899999499320983887f, 0.58700001239776611328f, 0.11400000005960464478f))), vec3f(tint_symbol_2.inner.tint_symbol_1));
  return vec4f(x_82.x, x_82.y, x_82.z, x_70.w);
}

fn tint_symbol_12_1() {
  let x_101 = tint_symbol_6_3;
  let x_102 = tint_symbol_7_3;
  let x_100 = tint_symbol_12_inner(tint_symbol_8(x_101, x_102));
  value = x_100;
  return;
}

struct tint_symbol_12_out {
  @location(0)
  value_1 : vec4f,
}

@fragment
fn fs_main(@builtin(position) tint_symbol_6_3_param : vec4f, @location(0) tint_symbol_7_3_param : vec2f) -> tint_symbol_12_out {
  tint_symbol_6_3 = tint_symbol_6_3_param;
  tint_symbol_7_3 = tint_symbol_7_3_param;
  tint_symbol_12_1();
  return tint_symbol_12_out(value);
}
