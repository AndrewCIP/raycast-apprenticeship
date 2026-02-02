struct tint_symbol {
  /* @offset(0) */
  tint_symbol_1 : f32,
  /* @offset(4) */
  tint_symbol_2 : f32,
  /* @offset(8) */
  tint_symbol_3 : f32,
  /* @offset(12) */
  tint_symbol_4 : f32,
}

struct tint_symbol_5 {
  /* @offset(0) */
  tint_symbol_6 : tint_symbol,
  /* @offset(16) */
  tint_symbol_7 : vec2f,
}

struct tint_symbol_11_block {
  /* @offset(0) */
  inner : tint_symbol_5,
}

alias RTArr = array<u32>;

struct tint_symbol_12_block {
  /* @offset(0) */
  inner : RTArr,
}

struct tint_symbol_8 {
  /* @offset(0) */
  tint_symbol_9 : u32,
  /* @offset(4) */
  tint_symbol_10 : u32,
}

struct tint_symbol_14_block {
  /* @offset(0) */
  inner : tint_symbol_8,
}

struct tint_symbol_26 {
  /* @offset(0) */
  tint_symbol_27 : vec4f,
  /* @offset(16) */
  tint_symbol_28 : f32,
}

var<private> tint_symbol_27_1 : vec2f;

var<private> tint_symbol_30_1 : u32;

var<private> tint_symbol_27_2 = vec4f();

var<private> tint_symbol_28_1 = 0.0f;

var<private> tint_symbol_28_2 : f32;

var<private> value = vec4f();

var<private> tint_symbol_36_1 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_11 : tint_symbol_11_block;

@group(0) @binding(1) var<storage> tint_symbol_12 : tint_symbol_12_block;

@group(0) @binding(2) var<storage, read_write> tint_symbol_13 : tint_symbol_12_block;

@group(0) @binding(3) var<uniform> tint_symbol_14 : tint_symbol_14_block;

fn tint_symbol_15(tint_symbol_16 : tint_symbol, tint_symbol_17 : tint_symbol) -> tint_symbol {
  return tint_symbol(((tint_symbol_16.tint_symbol_1 * tint_symbol_17.tint_symbol_1) - (tint_symbol_16.tint_symbol_2 * tint_symbol_17.tint_symbol_2)), ((tint_symbol_16.tint_symbol_1 * tint_symbol_17.tint_symbol_2) + (tint_symbol_16.tint_symbol_2 * tint_symbol_17.tint_symbol_1)), ((((tint_symbol_16.tint_symbol_1 * tint_symbol_17.tint_symbol_3) + (tint_symbol_16.tint_symbol_2 * tint_symbol_17.tint_symbol_4)) + (tint_symbol_16.tint_symbol_3 * tint_symbol_17.tint_symbol_1)) - (tint_symbol_16.tint_symbol_4 * tint_symbol_17.tint_symbol_2)), ((((tint_symbol_16.tint_symbol_1 * tint_symbol_17.tint_symbol_4) - (tint_symbol_16.tint_symbol_2 * tint_symbol_17.tint_symbol_3)) + (tint_symbol_16.tint_symbol_3 * tint_symbol_17.tint_symbol_2)) + (tint_symbol_16.tint_symbol_4 * tint_symbol_17.tint_symbol_1)));
}

fn tint_symbol_18(tint_symbol_16_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_16_1.tint_symbol_1, -(tint_symbol_16_1.tint_symbol_2), -(tint_symbol_16_1.tint_symbol_3), -(tint_symbol_16_1.tint_symbol_4));
}

fn tint_symbol_19(tint_symbol_20 : tint_symbol, tint_symbol_21 : tint_symbol) -> tint_symbol {
  let x_102 = tint_symbol_18(tint_symbol_21);
  let x_103 = tint_symbol_15(tint_symbol_20, x_102);
  let x_104 = tint_symbol_15(tint_symbol_21, x_103);
  return x_104;
}

fn tint_symbol_22(tint_symbol_20_1 : vec2f) -> tint_symbol {
  return tint_symbol(0.0f, 1.0f, tint_symbol_20_1.y, -(tint_symbol_20_1.x));
}

fn tint_symbol_23(tint_symbol_20_2 : tint_symbol) -> vec2f {
  return vec2f((-(tint_symbol_20_2.tint_symbol_4) / tint_symbol_20_2.tint_symbol_2), (tint_symbol_20_2.tint_symbol_3 / tint_symbol_20_2.tint_symbol_2));
}

fn tint_symbol_24(tint_symbol_20_3 : vec2f, tint_symbol_21_1 : tint_symbol) -> vec2f {
  let x_131 = tint_symbol_22(tint_symbol_20_3);
  let x_132 = tint_symbol_19(x_131, tint_symbol_21_1);
  let x_133 = tint_symbol_23(x_132);
  return x_133;
}

fn tint_mod(lhs : u32, rhs : u32) -> u32 {
  return (lhs % select(rhs, 1u, (rhs == 0u)));
}

fn tint_div(lhs_1 : u32, rhs_1 : u32) -> u32 {
  return (lhs_1 / select(rhs_1, 1u, (rhs_1 == 0u)));
}

fn tint_symbol_29_inner(tint_symbol_27 : vec2f, tint_symbol_30 : u32) -> tint_symbol_26 {
  var x_173 = vec2f();
  var x_183 = vec2f();
  var x_188 = vec2f();
  var x_197 = vec2f();
  var tint_symbol_40 = tint_symbol_26(vec4f(), 0.0f);
  let x_162 = tint_symbol_14.inner.tint_symbol_9;
  let x_158 = tint_mod(tint_symbol_30, x_162);
  let x_165 = tint_symbol_14.inner.tint_symbol_9;
  let x_163 = tint_div(tint_symbol_30, x_165);
  let x_169 = f32(tint_symbol_14.inner.tint_symbol_9);
  let x_178 = (1.0f * 2.0f);
  let x_179 = f32(tint_symbol_14.inner.tint_symbol_9);
  let x_185 = -(1.0f);
  let x_195 = ((x_178 / f32(tint_symbol_14.inner.tint_symbol_9)) * 0.5f);
  let x_203 = tint_symbol_11.inner.tint_symbol_6;
  let x_200 = tint_symbol_18(x_203);
  let x_204 = tint_symbol_24(((tint_symbol_27 / vec2f(x_179)) + ((vec2f(x_185) + ((vec2f(f32(x_158), f32(x_163)) / vec2f(x_169)) * x_178)) + vec2f(x_195))), x_200);
  let x_208 = (x_204 * tint_symbol_11.inner.tint_symbol_7);
  tint_symbol_40.tint_symbol_27 = vec4f(x_208.x, x_208.y, 0.0f, 1.0f);
  tint_symbol_40.tint_symbol_28 = f32(tint_symbol_12.inner[tint_symbol_30]);
  let x_223 = tint_symbol_40;
  return x_223;
}

fn tint_symbol_29_1() {
  let x_229 = tint_symbol_27_1;
  let x_230 = tint_symbol_30_1;
  let x_228 = tint_symbol_29_inner(x_229, x_230);
  tint_symbol_27_2 = x_228.tint_symbol_27;
  tint_symbol_28_1 = x_228.tint_symbol_28;
  return;
}

struct tint_symbol_29_out {
  @builtin(position)
  tint_symbol_27_2_1 : vec4f,
  @location(0)
  tint_symbol_28_1_1 : f32,
}

@vertex
fn vertexMain(@location(0) tint_symbol_27_1_param : vec2f, @builtin(instance_index) tint_symbol_30_1_param : u32) -> tint_symbol_29_out {
  tint_symbol_27_1 = tint_symbol_27_1_param;
  tint_symbol_30_1 = tint_symbol_30_1_param;
  tint_symbol_29_1();
  return tint_symbol_29_out(tint_symbol_27_2, tint_symbol_28_1);
}

fn tint_symbol_41_inner(tint_symbol_28 : f32) -> vec4f {
  return (vec4f(0.93333333730697631836f, 0.46274510025978088379f, 0.13725490868091583252f, 1.0f) * tint_symbol_28);
}

fn tint_symbol_41_1() {
  let x_245 = tint_symbol_28_2;
  let x_244 = tint_symbol_41_inner(x_245);
  value = x_244;
  return;
}

struct tint_symbol_41_out {
  @location(0)
  value_1 : vec4f,
}

@fragment
fn fragmentMain(@location(0) tint_symbol_28_2_param : f32) -> tint_symbol_41_out {
  tint_symbol_28_2 = tint_symbol_28_2_param;
  tint_symbol_41_1();
  return tint_symbol_41_out(value);
}

fn tint_symbol_42_inner(tint_symbol_36 : vec3u) {
  let x_250 = tint_symbol_36.x;
  let x_251 = tint_symbol_36.y;
  let x_258 = tint_symbol_12.inner[((x_251 * tint_symbol_14.inner.tint_symbol_9) + (x_250 + 1u))];
  let x_265 = tint_symbol_12.inner[((x_251 * tint_symbol_14.inner.tint_symbol_9) + (x_250 - 1u))];
  let x_273 = tint_symbol_12.inner[(((x_251 + 1u) * tint_symbol_14.inner.tint_symbol_9) + x_250)];
  let x_281 = tint_symbol_12.inner[(((x_251 - 1u) * tint_symbol_14.inner.tint_symbol_9) + x_250)];
  let x_286 = ((x_251 * tint_symbol_14.inner.tint_symbol_9) + x_250);
  let x_287 = tint_mod((x_286 + (((x_258 + x_265) + x_273) + x_281)), 2u);
  if ((x_287 == 1u)) {
    tint_symbol_13.inner[x_286] = 1u;
  } else {
    tint_symbol_13.inner[x_286] = 0u;
  }
  return;
}

fn tint_symbol_42_1() {
  let x_299 = tint_symbol_36_1;
  tint_symbol_42_inner(x_299);
  return;
}

@compute @workgroup_size(4i, 4i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_36_1_param : vec3u) {
  tint_symbol_36_1 = tint_symbol_36_1_param;
  tint_symbol_42_1();
}
