struct tint_symbol {
  /* @offset(0) */
  tint_symbol_1 : vec2f,
  /* @offset(8) */
  tint_symbol_2 : vec2f,
  /* @offset(16) */
  tint_symbol_3 : f32,
  /* @offset(20) */
  tint_symbol_4 : f32,
  /* @offset(24) */
  tint_symbol_5 : f32,
  /* @offset(28) */
  tint_symbol_6 : f32,
}

alias RTArr = array<tint_symbol>;

struct tint_symbol_16_block {
  /* @offset(0) */
  inner : RTArr,
}

struct tint_symbol_7 {
  /* @offset(0) */
  tint_symbol_8 : f32,
  /* @offset(4) */
  tint_symbol_9 : f32,
  /* @offset(8) */
  tint_symbol_10 : f32,
  /* @offset(12) */
  tint_symbol_11 : f32,
  /* @offset(16) */
  tint_symbol_12 : f32,
  /* @offset(20) */
  tint_symbol_13 : f32,
  /* @offset(24) */
  tint_symbol_14 : f32,
  /* @offset(28) */
  tint_symbol_15 : f32,
}

struct tint_symbol_18_block {
  /* @offset(0) */
  inner : tint_symbol_7,
}

struct tint_symbol_28 {
  /* @offset(0) */
  tint_symbol_29 : vec4f,
  /* @offset(16) */
  tint_symbol_30 : vec2f,
  /* @offset(32) */
  tint_symbol_27 : vec4f,
}

alias Arr = array<vec2f, 6u>;

var<private> tint_symbol_32_1 : u32;

var<private> tint_symbol_33_1 : u32;

var<private> tint_symbol_29_1 = vec4f();

var<private> tint_symbol_30_1 = vec2f();

var<private> tint_symbol_27_1 = vec4f();

var<private> tint_symbol_30_2 : vec2f;

var<private> tint_symbol_27_2 : vec4f;

var<private> value = vec4f();

var<private> tint_symbol_42_1 : vec3u;

@group(0) @binding(0) var<storage> tint_symbol_16 : tint_symbol_16_block;

@group(0) @binding(1) var<storage, read_write> tint_symbol_17 : tint_symbol_16_block;

@group(0) @binding(2) var<uniform> tint_symbol_18 : tint_symbol_18_block;

@group(0) @binding(3) var tint_symbol_19 : texture_2d<f32>;

@group(0) @binding(4) var tint_symbol_20 : sampler;

fn tint_symbol_21(tint_symbol_22 : f32) -> f32 {
  return fract((sin(((tint_symbol_22 * 127.09999847412109375f) + 311.70001220703125f)) * 43758.546875f));
}

fn tint_symbol_23(tint_symbol_24 : f32, tint_symbol_25 : f32) -> vec4f {
  var tint_symbol_27 = vec3f();
  var x_60 : f32;
  x_60 = tint_symbol_21(((tint_symbol_24 * 0.69999998807907104492f) + 0.30000001192092895508f));
  if ((x_60 < 0.33000001311302185059f)) {
    tint_symbol_27 = vec3f(0.20000000298023223877f, 0.5f, 1.0f);
  } else {
    if ((x_60 < 0.66000002622604370117f)) {
      tint_symbol_27 = vec3f(0.55000001192092895508f, 0.20000000298023223877f, 1.0f);
    } else {
      tint_symbol_27 = vec3f(0.10000000149011611938f, 0.85000002384185791016f, 0.80000001192092895508f);
    }
  }
  let x_90 = tint_symbol_27;
  return vec4f(x_90.x, x_90.y, x_90.z, (tint_symbol_25 * 0.75f));
}

const x_110 = vec2f(-1.0f);

const x_112 = vec2f(1.0f);

const x_115 = vec2f(0.0f, 1.0f);

const x_116 = vec2f(1.0f, 0.0f);

fn tint_symbol_31_inner(tint_symbol_32 : u32, tint_symbol_33 : u32) -> tint_symbol_28 {
  var tint_symbol_38 = tint_symbol_28(vec4f(), vec2f(), vec4f());
  var var_for_index = array<vec2f, 6u>();
  var var_for_index_1 = array<vec2f, 6u>();
  let x_106 = tint_symbol_16.inner[tint_symbol_32];
  let x_118 = clamp((x_106.tint_symbol_3 / x_106.tint_symbol_4), 0.0f, 1.0f);
  var_for_index = Arr(x_110, vec2f(1.0f, -1.0f), x_112, x_110, x_112, vec2f(-1.0f, 1.0f));
  let x_139 = (x_106.tint_symbol_1 + (var_for_index[tint_symbol_33] * (0.00600000005215406418f + (0.00400000018998980522f * x_118))));
  tint_symbol_38.tint_symbol_29 = vec4f(x_139.x, x_139.y, 0.0f, 1.0f);
  var_for_index_1 = Arr(x_115, x_112, x_116, x_115, x_116, vec2f());
  tint_symbol_38.tint_symbol_30 = var_for_index_1[tint_symbol_33];
  let x_150 = tint_symbol_23(x_106.tint_symbol_5, x_118);
  tint_symbol_38.tint_symbol_27 = x_150;
  let x_152 = tint_symbol_38;
  return x_152;
}

fn tint_symbol_31_1() {
  let x_158 = tint_symbol_32_1;
  let x_159 = tint_symbol_33_1;
  let x_157 = tint_symbol_31_inner(x_158, x_159);
  tint_symbol_29_1 = x_157.tint_symbol_29;
  tint_symbol_30_1 = x_157.tint_symbol_30;
  tint_symbol_27_1 = x_157.tint_symbol_27;
  return;
}

struct tint_symbol_31_out {
  @builtin(position)
  tint_symbol_29_1_1 : vec4f,
  @location(0)
  tint_symbol_30_1_1 : vec2f,
  @location(1)
  tint_symbol_27_1_1 : vec4f,
}

@vertex
fn vertexMain(@builtin(instance_index) tint_symbol_32_1_param : u32, @builtin(vertex_index) tint_symbol_33_1_param : u32) -> tint_symbol_31_out {
  tint_symbol_32_1 = tint_symbol_32_1_param;
  tint_symbol_33_1 = tint_symbol_33_1_param;
  tint_symbol_31_1();
  return tint_symbol_31_out(tint_symbol_29_1, tint_symbol_30_1, tint_symbol_27_1);
}

fn tint_symbol_39_inner(tint_symbol_30 : vec2f, tint_symbol_27_3 : vec4f) -> vec4f {
  let x_168 = textureSample(tint_symbol_19, tint_symbol_20, tint_symbol_30);
  let x_174 = tint_symbol_27_3.xyz;
  return vec4f(x_174.x, x_174.y, x_174.z, (tint_symbol_27_3.w * x_168.w));
}

fn tint_symbol_39_1() {
  let x_184 = tint_symbol_30_2;
  let x_185 = tint_symbol_27_2;
  let x_183 = tint_symbol_39_inner(x_184, x_185);
  value = x_183;
  return;
}

struct tint_symbol_39_out {
  @location(0)
  value_1 : vec4f,
}

@fragment
fn fragmentMain(@location(0) tint_symbol_30_2_param : vec2f, @location(1) tint_symbol_27_2_param : vec4f) -> tint_symbol_39_out {
  tint_symbol_30_2 = tint_symbol_30_2_param;
  tint_symbol_27_2 = tint_symbol_27_2_param;
  tint_symbol_39_1();
  return tint_symbol_39_out(value);
}

fn tint_symbol_41_inner(tint_symbol_42 : vec3u) {
  var tint_symbol_34 = tint_symbol(vec2f(), vec2f(), 0.0f, 0.0f, 0.0f, 0.0f);
  var x_225 = vec2f();
  let x_190 = tint_symbol_42.x;
  if ((x_190 >= arrayLength(&(tint_symbol_16.inner)))) {
    return;
  }
  tint_symbol_34 = tint_symbol_16.inner[x_190];
  tint_symbol_34.tint_symbol_2 = (tint_symbol_34.tint_symbol_2 + (vec2f(tint_symbol_18.inner.tint_symbol_8, tint_symbol_18.inner.tint_symbol_9) * 0.00004999999873689376f));
  let x_220 = (vec2f(tint_symbol_18.inner.tint_symbol_10, tint_symbol_18.inner.tint_symbol_11) - tint_symbol_34.tint_symbol_1);
  tint_symbol_34.tint_symbol_2 = (tint_symbol_34.tint_symbol_2 + (((x_220 / vec2f((length(x_220) + 0.00100000004749745131f))) * 0.00009999999747378752f) * tint_symbol_18.inner.tint_symbol_12));
  tint_symbol_34.tint_symbol_2 = (tint_symbol_34.tint_symbol_2 + ((-(tint_symbol_34.tint_symbol_1) * 0.0000199999994947575f) * (1.0f - tint_symbol_18.inner.tint_symbol_12)));
  tint_symbol_34.tint_symbol_2 = (tint_symbol_34.tint_symbol_2 * 0.99500000476837158203f);
  tint_symbol_34.tint_symbol_1 = (tint_symbol_34.tint_symbol_1 + tint_symbol_34.tint_symbol_2);
  tint_symbol_34.tint_symbol_3 = (tint_symbol_34.tint_symbol_3 - 1.0f);
  if ((tint_symbol_34.tint_symbol_1.x > 1.0f)) {
    tint_symbol_34.tint_symbol_1.x = (tint_symbol_34.tint_symbol_1.x - 2.0f);
  }
  if ((tint_symbol_34.tint_symbol_1.x < -1.0f)) {
    tint_symbol_34.tint_symbol_1.x = (tint_symbol_34.tint_symbol_1.x + 2.0f);
  }
  if ((tint_symbol_34.tint_symbol_1.y > 1.0f)) {
    tint_symbol_34.tint_symbol_1.y = (tint_symbol_34.tint_symbol_1.y - 2.0f);
  }
  if ((tint_symbol_34.tint_symbol_1.y < -1.0f)) {
    tint_symbol_34.tint_symbol_1.y = (tint_symbol_34.tint_symbol_1.y + 2.0f);
  }
  if ((tint_symbol_34.tint_symbol_3 <= 0.0f)) {
    let x_316 = ((tint_symbol_18.inner.tint_symbol_13 * 0.00999999977648258209f) + (f32(x_190) * 0.31830000877380371094f));
    let x_317 = tint_symbol_21(x_316);
    let x_318 = tint_symbol_21((x_316 + 0.5f));
    tint_symbol_34.tint_symbol_1 = vec2f(((x_317 * 2.0f) - 1.0f), ((x_318 * 2.0f) - 1.0f));
    let x_326 = tint_symbol_21((x_316 + 1.0f));
    let x_329 = (x_326 * 6.28318023681640625f);
    let x_330 = tint_symbol_21((x_316 + 2.0f));
    let x_335 = (0.00050000002374872565f + (x_330 * 0.00200000009499490261f));
    tint_symbol_34.tint_symbol_2 = vec2f((cos(x_329) * x_335), (sin(x_329) * x_335));
    let x_343 = tint_symbol_21((x_316 + 3.0f));
    tint_symbol_34.tint_symbol_5 = x_343;
    let x_346 = tint_symbol_21((x_316 + 4.0f));
    let x_351 = (200.0f + (x_346 * 200.0f));
    tint_symbol_34.tint_symbol_3 = x_351;
    tint_symbol_34.tint_symbol_4 = x_351;
  }
  tint_symbol_17.inner[x_190] = tint_symbol_34;
  return;
}

fn tint_symbol_41_1() {
  let x_359 = tint_symbol_42_1;
  tint_symbol_41_inner(x_359);
  return;
}

@compute @workgroup_size(256i, 1i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_42_1_param : vec3u) {
  tint_symbol_42_1 = tint_symbol_42_1_param;
  tint_symbol_41_1();
}
