struct tint_symbol {
  /* @offset(0) */
  tint_symbol_1 : vec2f,
  /* @offset(8) */
  tint_symbol_2 : vec2f,
  /* @offset(16) */
  tint_symbol_3 : vec4f,
  /* @offset(32) */
  tint_symbol_4 : f32,
  /* @offset(36) */
  tint_symbol_5 : f32,
  /* @offset(40) */
  tint_symbol_6 : f32,
  /* @offset(44) */
  tint_symbol_7 : f32,
}

alias RTArr = array<tint_symbol>;

struct tint_symbol_13_block {
  /* @offset(0) */
  inner : RTArr,
}

struct tint_symbol_8 {
  /* @offset(0) */
  tint_symbol_9 : f32,
  /* @offset(4) */
  tint_symbol_10 : f32,
  /* @offset(8) */
  tint_symbol_11 : f32,
  /* @offset(12) */
  tint_symbol_12 : f32,
}

struct tint_symbol_15_block {
  /* @offset(0) */
  inner : tint_symbol_8,
}

struct tint_symbol_20 {
  /* @offset(0) */
  tint_symbol_21 : vec4f,
  /* @offset(16) */
  tint_symbol_22 : vec2f,
  /* @offset(32) */
  tint_symbol_23 : vec4f,
}

alias Arr = array<vec2f, 6u>;

var<private> tint_symbol_25_1 : u32;

var<private> tint_symbol_26_1 : u32;

var<private> tint_symbol_21_1 = vec4f();

var<private> tint_symbol_22_1 = vec2f();

var<private> tint_symbol_23_1 = vec4f();

var<private> tint_symbol_22_2 : vec2f;

var<private> tint_symbol_23_2 : vec4f;

var<private> value = vec4f();

var<private> tint_symbol_36_1 : vec3u;

@group(0) @binding(0) var<storage> tint_symbol_13 : tint_symbol_13_block;

@group(0) @binding(1) var<storage, read_write> tint_symbol_14 : tint_symbol_13_block;

@group(0) @binding(2) var<uniform> tint_symbol_15 : tint_symbol_15_block;

@group(0) @binding(3) var tint_symbol_16 : texture_2d<f32>;

@group(0) @binding(4) var tint_symbol_17 : sampler;

fn tint_symbol_18(tint_symbol_19 : f32) -> f32 {
  return fract((sin(((tint_symbol_19 * 127.09999847412109375f) + 311.70001220703125f)) * 43758.546875f));
}

const x_68 = vec2f(-1.0f);

const x_71 = vec2f(1.0f);

const x_74 = vec2f(0.0f, 1.0f);

const x_75 = vec2f(1.0f, 0.0f);

fn tint_symbol_24_inner(tint_symbol_25 : u32, tint_symbol_26 : u32) -> tint_symbol_20 {
  var tint_symbol_32 = tint_symbol_20(vec4f(), vec2f(), vec4f());
  var var_for_index = array<vec2f, 6u>();
  var var_for_index_1 = array<vec2f, 6u>();
  let x_64 = tint_symbol_13.inner[tint_symbol_25];
  let x_77 = clamp((x_64.tint_symbol_4 / x_64.tint_symbol_5), 0.0f, 1.0f);
  var_for_index = Arr(x_68, vec2f(1.0f, -1.0f), x_71, x_68, x_71, vec2f(-1.0f, 1.0f));
  let x_96 = (x_64.tint_symbol_1 + (var_for_index[tint_symbol_26] * (0.01499999966472387314f * x_77)));
  tint_symbol_32.tint_symbol_21 = vec4f(x_96.x, x_96.y, 0.0f, 1.0f);
  var_for_index_1 = Arr(x_74, x_71, x_75, x_74, x_75, vec2f());
  tint_symbol_32.tint_symbol_22 = var_for_index_1[tint_symbol_26];
  let x_109 = x_64.tint_symbol_3.xyz;
  tint_symbol_32.tint_symbol_23 = vec4f(x_109.x, x_109.y, x_109.z, (x_64.tint_symbol_3.w * x_77));
  let x_117 = tint_symbol_32;
  return x_117;
}

fn tint_symbol_24_1() {
  let x_123 = tint_symbol_25_1;
  let x_124 = tint_symbol_26_1;
  let x_122 = tint_symbol_24_inner(x_123, x_124);
  tint_symbol_21_1 = x_122.tint_symbol_21;
  tint_symbol_22_1 = x_122.tint_symbol_22;
  tint_symbol_23_1 = x_122.tint_symbol_23;
  return;
}

struct tint_symbol_24_out {
  @builtin(position)
  tint_symbol_21_1_1 : vec4f,
  @location(0)
  tint_symbol_22_1_1 : vec2f,
  @location(1)
  tint_symbol_23_1_1 : vec4f,
}

@vertex
fn vertexMain(@builtin(instance_index) tint_symbol_25_1_param : u32, @builtin(vertex_index) tint_symbol_26_1_param : u32) -> tint_symbol_24_out {
  tint_symbol_25_1 = tint_symbol_25_1_param;
  tint_symbol_26_1 = tint_symbol_26_1_param;
  tint_symbol_24_1();
  return tint_symbol_24_out(tint_symbol_21_1, tint_symbol_22_1, tint_symbol_23_1);
}

fn tint_symbol_33_inner(tint_symbol_22 : vec2f, tint_symbol_23 : vec4f) -> vec4f {
  let x_133 = textureSample(tint_symbol_16, tint_symbol_17, tint_symbol_22);
  let x_139 = tint_symbol_23.xyz;
  return vec4f(x_139.x, x_139.y, x_139.z, (tint_symbol_23.w * x_133.w));
}

fn tint_symbol_33_1() {
  let x_149 = tint_symbol_22_2;
  let x_150 = tint_symbol_23_2;
  let x_148 = tint_symbol_33_inner(x_149, x_150);
  value = x_148;
  return;
}

struct tint_symbol_33_out {
  @location(0)
  value_1 : vec4f,
}

@fragment
fn fragmentMain(@location(0) tint_symbol_22_2_param : vec2f, @location(1) tint_symbol_23_2_param : vec4f) -> tint_symbol_33_out {
  tint_symbol_22_2 = tint_symbol_22_2_param;
  tint_symbol_23_2 = tint_symbol_23_2_param;
  tint_symbol_33_1();
  return tint_symbol_33_out(value);
}

fn tint_symbol_35_inner(tint_symbol_36 : vec3u) {
  var tint_symbol_27 = tint_symbol(vec2f(), vec2f(), vec4f(), 0.0f, 0.0f, 0.0f, 0.0f);
  let x_155 = tint_symbol_36.x;
  if ((x_155 >= arrayLength(&(tint_symbol_13.inner)))) {
    return;
  }
  tint_symbol_27 = tint_symbol_13.inner[x_155];
  tint_symbol_27.tint_symbol_2 = (tint_symbol_27.tint_symbol_2 + vec2f(0.0f, -0.00150000001303851604f));
  tint_symbol_27.tint_symbol_1 = (tint_symbol_27.tint_symbol_1 + tint_symbol_27.tint_symbol_2);
  tint_symbol_27.tint_symbol_4 = (tint_symbol_27.tint_symbol_4 - 1.0f);
  if ((tint_symbol_27.tint_symbol_1.x > 1.0f)) {
    tint_symbol_27.tint_symbol_1.x = (tint_symbol_27.tint_symbol_1.x - 2.0f);
  }
  if ((tint_symbol_27.tint_symbol_1.x < -1.0f)) {
    tint_symbol_27.tint_symbol_1.x = (tint_symbol_27.tint_symbol_1.x + 2.0f);
  }
  if ((tint_symbol_27.tint_symbol_1.y > 1.0f)) {
    tint_symbol_27.tint_symbol_1.y = (tint_symbol_27.tint_symbol_1.y - 2.0f);
  }
  if ((tint_symbol_27.tint_symbol_1.y < -1.0f)) {
    tint_symbol_27.tint_symbol_1.y = (tint_symbol_27.tint_symbol_1.y + 2.0f);
  }
  if ((tint_symbol_27.tint_symbol_4 <= 0.0f)) {
    var x_254 : f32;
    let x_232 = (tint_symbol_15.inner.tint_symbol_11 + (f32(x_155) * 0.31830000877380371094f));
    tint_symbol_27.tint_symbol_1 = vec2f(tint_symbol_15.inner.tint_symbol_9, tint_symbol_15.inner.tint_symbol_10);
    let x_239 = tint_symbol_18(x_232);
    let x_241 = (x_239 * 6.28318023681640625f);
    let x_242 = tint_symbol_18((x_232 + 1.0f));
    let x_247 = (0.00400000018998980522f + (x_242 * 0.01799999922513961792f));
    tint_symbol_27.tint_symbol_2 = vec2f((cos(x_241) * x_247), (sin(x_241) * x_247));
    x_254 = tint_symbol_18((x_232 + 2.0f));
    if ((x_254 < 0.20000000298023223877f)) {
      tint_symbol_27.tint_symbol_3 = vec4f(1.0f, 0.15000000596046447754f, 0.05000000074505805969f, 1.0f);
    } else {
      if ((x_254 < 0.40000000596046447754f)) {
        tint_symbol_27.tint_symbol_3 = vec4f(1.0f, 0.55000001192092895508f, 0.05000000074505805969f, 1.0f);
      } else {
        if ((x_254 < 0.60000002384185791016f)) {
          tint_symbol_27.tint_symbol_3 = vec4f(1.0f, 1.0f, 0.20000000298023223877f, 1.0f);
        } else {
          if ((x_254 < 0.80000001192092895508f)) {
            tint_symbol_27.tint_symbol_3 = vec4f(0.40000000596046447754f, 0.80000001192092895508f, 1.0f, 1.0f);
          } else {
            tint_symbol_27.tint_symbol_3 = vec4f(0.89999997615814208984f, 0.40000000596046447754f, 1.0f, 1.0f);
          }
        }
      }
    }
    let x_290 = tint_symbol_18((x_232 + 3.0f));
    let x_296 = (80.0f + (x_290 * 120.0f));
    tint_symbol_27.tint_symbol_4 = x_296;
    tint_symbol_27.tint_symbol_5 = x_296;
  }
  tint_symbol_14.inner[x_155] = tint_symbol_27;
  return;
}

fn tint_symbol_35_1() {
  let x_305 = tint_symbol_36_1;
  tint_symbol_35_inner(x_305);
  return;
}

@compute @workgroup_size(256i, 1i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_36_1_param : vec3u) {
  tint_symbol_36_1 = tint_symbol_36_1_param;
  tint_symbol_35_1();
}
