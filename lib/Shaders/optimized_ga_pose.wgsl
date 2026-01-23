struct tint_symbol {
  /* @offset(0) */
  tint_symbol_1 : vec2f,
  /* @offset(8) */
  tint_symbol_2 : vec2f,
  /* @offset(16) */
  tint_symbol_3 : vec2f,
  /* @offset(24) */
  tint_symbol_4 : vec2f,
}

struct tint_symbol_5_block {
  /* @offset(0) */
  inner : tint_symbol,
}

var<private> tint_symbol_15_1 : vec2f;

var<private> value = vec4f();

var<private> value_1 = vec4f();

@group(0) @binding(0) var<uniform> tint_symbol_5 : tint_symbol_5_block;

fn tint_symbol_6(tint_symbol_7 : vec4f, tint_symbol_8 : vec4f) -> vec4f {
  return vec4f(((((tint_symbol_7.x * tint_symbol_8.x) + (tint_symbol_7.y * tint_symbol_8.y)) + (tint_symbol_7.z * tint_symbol_8.z)) - (tint_symbol_7.w * tint_symbol_8.w)), ((((tint_symbol_7.x * tint_symbol_8.y) + (tint_symbol_7.y * tint_symbol_8.x)) - (tint_symbol_7.z * tint_symbol_8.w)) + (tint_symbol_7.w * tint_symbol_8.z)), ((((tint_symbol_7.x * tint_symbol_8.z) + (tint_symbol_7.y * tint_symbol_8.w)) + (tint_symbol_7.z * tint_symbol_8.x)) - (tint_symbol_7.w * tint_symbol_8.y)), ((((tint_symbol_7.x * tint_symbol_8.w) + (tint_symbol_7.y * tint_symbol_8.z)) - (tint_symbol_7.z * tint_symbol_8.y)) + (tint_symbol_7.w * tint_symbol_8.x)));
}

fn tint_symbol_9(tint_symbol_7_1 : vec4f) -> vec4f {
  return vec4f(tint_symbol_7_1.x, tint_symbol_7_1.y, tint_symbol_7_1.z, -(tint_symbol_7_1.w));
}

fn tint_symbol_10(tint_symbol_11 : vec2f, tint_symbol_12 : vec2f) -> vec2f {
  let x_109 = tint_symbol_9(vec4f(tint_symbol_12.x, 0.0f, 0.0f, tint_symbol_12.y));
  let x_113 = tint_symbol_6(vec4f(0.0f, tint_symbol_11.x, tint_symbol_11.y, 0.0f), x_109);
  let x_114 = tint_symbol_6(vec4f(tint_symbol_12.x, 0.0f, 0.0f, tint_symbol_12.y), x_113);
  return vec2f(x_114.y, x_114.z);
}

fn tint_symbol_14_inner(tint_symbol_15 : vec2f) -> vec4f {
  let x_128 = tint_symbol_5.inner.tint_symbol_4;
  let x_131 = tint_symbol_5.inner.tint_symbol_1;
  let x_122 = tint_symbol_10((tint_symbol_15 - x_128), x_131);
  let x_142 = (((x_122 + tint_symbol_5.inner.tint_symbol_4) + tint_symbol_5.inner.tint_symbol_2) * tint_symbol_5.inner.tint_symbol_3);
  return vec4f(x_142.x, x_142.y, 0.0f, 1.0f);
}

fn tint_symbol_14_1() {
  let x_152 = tint_symbol_15_1;
  let x_151 = tint_symbol_14_inner(x_152);
  value = x_151;
  return;
}

struct tint_symbol_14_out {
  @builtin(position)
  value_2 : vec4f,
}

@vertex
fn vertexMain(@location(0) tint_symbol_15_1_param : vec2f) -> tint_symbol_14_out {
  tint_symbol_15_1 = tint_symbol_15_1_param;
  tint_symbol_14_1();
  return tint_symbol_14_out(value);
}

fn tint_symbol_18_inner() -> vec4f {
  return vec4f(0.93333333730697631836f, 0.46274510025978088379f, 0.13725490868091583252f, 1.0f);
}

fn tint_symbol_18_1() {
  let x_162 = tint_symbol_18_inner();
  value_1 = x_162;
  return;
}

struct tint_symbol_18_out {
  @location(0)
  value_1_1 : vec4f,
}

@fragment
fn fragmentMain() -> tint_symbol_18_out {
  tint_symbol_18_1();
  return tint_symbol_18_out(value_1);
}
