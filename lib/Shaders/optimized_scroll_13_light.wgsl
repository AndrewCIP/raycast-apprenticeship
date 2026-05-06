/*
 * Scroll 13 — Lighting & Shading
 *
 * Extends the Worksheet-10 ray-box tracer with:
 *   Three light sources  — point (0), directional (1), spotlight (2)
 *                          selected via light.params[2]
 *   Three shading models — Lambertian (0), Phong (1), Toon (2)
 *                          selected via light.params[3]
 *
 * All PGA geometry code is carried over unchanged from traceboxlight.wgsl.
 */

struct tint_symbol {
  /* @offset(0) */
  tint_symbol_1 : f32,
  /* @offset(4) */
  tint_symbol_2 : f32,
  /* @offset(8) */
  tint_symbol_3 : f32,
  /* @offset(12) */
  tint_symbol_4 : f32,
  /* @offset(16) */
  tint_symbol_5 : f32,
  /* @offset(20) */
  tint_symbol_6 : f32,
  /* @offset(24) */
  tint_symbol_7 : f32,
  /* @offset(28) */
  tint_symbol_8 : f32,
  /* @offset(32) */
  tint_symbol_9 : f32,
  /* @offset(36) */
  tint_symbol_10 : f32,
  /* @offset(40) */
  tint_symbol_11 : f32,
  /* @offset(44) */
  tint_symbol_12 : f32,
  /* @offset(48) */
  tint_symbol_13 : f32,
  /* @offset(52) */
  tint_symbol_14 : f32,
  /* @offset(56) */
  tint_symbol_15 : f32,
  /* @offset(60) */
  tint_symbol_16 : f32,
}

struct tint_symbol_55 {
  /* @offset(0) */
  tint_symbol_56 : tint_symbol,
  /* @offset(64) */
  tint_symbol_57 : vec2f,
  /* @offset(72) */
  tint_symbol_58 : vec2f,
}

struct tint_symbol_73_block {
  /* @offset(0) */
  inner : tint_symbol_55,
}

struct tint_symbol_59 {
  /* @offset(0) */
  tint_symbol_60 : vec4f,
  /* @offset(16) */
  tint_symbol_61 : vec4f,
  /* @offset(32) */
  tint_symbol_62 : vec4f,
  /* @offset(48) */
  tint_symbol_63 : vec4f,
}

alias Arr = array<tint_symbol_59, 6u>;

struct tint_symbol_64 {
  /* @offset(0) */
  tint_symbol_56 : tint_symbol,
  /* @offset(64) */
  tint_symbol_65 : vec4f,
  /* @offset(80) */
  tint_symbol_66 : Arr,
}

struct tint_symbol_74_block {
  /* @offset(0) */
  inner : tint_symbol_64,
}

struct tint_symbol_67 {
  /* @offset(0) */
  tint_symbol_68 : vec4f,
  /* @offset(16) */
  tint_symbol_69 : vec4f,
  /* @offset(32) */
  tint_symbol_70 : vec4f,
  /* @offset(48) */
  tint_symbol_71 : vec4f,
  /* @offset(64) */
  tint_symbol_72 : vec4f,
}

struct tint_symbol_76_block {
  /* @offset(0) */
  inner : tint_symbol_67,
}

struct tint_symbol_47 {
  /* @offset(0) */
  tint_symbol_23 : vec3f,
  /* @offset(12) */
  tint_symbol_48 : bool,
  /* @offset(16) */
  tint_symbol_49 : bool,
}

struct tint_symbol_95 {
  /* @offset(0) */
  tint_symbol_68 : vec4f,
  /* @offset(16) */
  tint_symbol_96 : vec3f,
}

var<private> tint_symbol_130_1 : vec3u;

var<private> tint_symbol_130_2 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_73 : tint_symbol_73_block;

@group(0) @binding(1) var<uniform> tint_symbol_74 : tint_symbol_74_block;

@group(0) @binding(2) var tint_symbol_75 : texture_storage_2d<rgba8unorm, write>;

@group(0) @binding(3) var<uniform> tint_symbol_76 : tint_symbol_76_block;

fn tint_ftoi(v : f32) -> i32 {
  return select(2147483647i, select(i32(v), i32(-2147483648), (v < -2147483648.0f)), (v < 2147483520.0f));
}

fn tint_symbol_17(tint_symbol_18 : tint_symbol, tint_symbol_19 : tint_symbol) -> tint_symbol {
  var tint_symbol_20 = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  tint_symbol_20.tint_symbol_1 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_1) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_2)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_3)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_4)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_8)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_14));
  tint_symbol_20.tint_symbol_2 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_2) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_14)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_13)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_8));
  tint_symbol_20.tint_symbol_3 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_3) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_2)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_8)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_12));
  tint_symbol_20.tint_symbol_4 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_4) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_2)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_1)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_8)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_13));
  tint_symbol_20.tint_symbol_5 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_5) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_6)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_7)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_16)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_2)) - (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_11)) + (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_8)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_15)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_9)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_10)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_12)) - (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_4));
  tint_symbol_20.tint_symbol_6 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_6) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_5)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_16)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_7)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_2)) + (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_4)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_10)) - (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_8)) + (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_13)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_9)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_15)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_11)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_3));
  tint_symbol_20.tint_symbol_7 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_7) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_16)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_5)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_6)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_1)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_9)) - (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_8)) - (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_12)) - (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_13)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_10)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_11)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_15)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_2));
  tint_symbol_20.tint_symbol_8 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_8) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_1)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_4)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_2));
  tint_symbol_20.tint_symbol_9 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_9) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_15)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_11)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_10)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_13)) - (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_8)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_7)) + (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_3)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_6)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_5)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_16)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_2)) + (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_14));
  tint_symbol_20.tint_symbol_10 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_10) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_11)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_15)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_9)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_8)) - (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_6)) + (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_2)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_7)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_16)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_5)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_3)) - (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_13));
  tint_symbol_20.tint_symbol_11 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_11) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_10)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_9)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_15)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_8)) + (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_13)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_5)) - (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_2)) + (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_16)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_7)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_6)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_12));
  tint_symbol_20.tint_symbol_12 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_12) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_8)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_2)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_3));
  tint_symbol_20.tint_symbol_13 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_13) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_8)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_14)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_2)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_4));
  tint_symbol_20.tint_symbol_14 = ((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_14) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_8)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_12)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_13)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_2)) + (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_4)) + (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_1));
  tint_symbol_20.tint_symbol_15 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_15) - (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_9)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_10)) - (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_11)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_12)) + (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_14)) + (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_16)) - (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_2)) - (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_3)) - (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_4)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_5)) - (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_6)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_7)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_1)) - (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_8));
  tint_symbol_20.tint_symbol_16 = ((((((((((((((((tint_symbol_18.tint_symbol_1 * tint_symbol_19.tint_symbol_16) + (tint_symbol_18.tint_symbol_2 * tint_symbol_19.tint_symbol_7)) - (tint_symbol_18.tint_symbol_3 * tint_symbol_19.tint_symbol_6)) + (tint_symbol_18.tint_symbol_4 * tint_symbol_19.tint_symbol_5)) + (tint_symbol_18.tint_symbol_5 * tint_symbol_19.tint_symbol_4)) - (tint_symbol_18.tint_symbol_6 * tint_symbol_19.tint_symbol_3)) + (tint_symbol_18.tint_symbol_7 * tint_symbol_19.tint_symbol_2)) - (tint_symbol_18.tint_symbol_8 * tint_symbol_19.tint_symbol_15)) + (tint_symbol_18.tint_symbol_9 * tint_symbol_19.tint_symbol_14)) - (tint_symbol_18.tint_symbol_10 * tint_symbol_19.tint_symbol_13)) + (tint_symbol_18.tint_symbol_11 * tint_symbol_19.tint_symbol_12)) - (tint_symbol_18.tint_symbol_12 * tint_symbol_19.tint_symbol_11)) + (tint_symbol_18.tint_symbol_13 * tint_symbol_19.tint_symbol_10)) - (tint_symbol_18.tint_symbol_14 * tint_symbol_19.tint_symbol_9)) + (tint_symbol_18.tint_symbol_15 * tint_symbol_19.tint_symbol_8)) + (tint_symbol_18.tint_symbol_16 * tint_symbol_19.tint_symbol_1));
  let x_835 = tint_symbol_20;
  return x_835;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_871 = tint_symbol_21(tint_symbol_24);
  let x_872 = tint_symbol_17(tint_symbol_23, x_871);
  let x_873 = tint_symbol_17(tint_symbol_24, x_872);
  return x_873;
}

fn tint_symbol_25(tint_symbol_24_1 : tint_symbol) -> f32 {
  var tint_symbol_26 = 0.0f;
  tint_symbol_26 = 0.0f;
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_1 * tint_symbol_24_1.tint_symbol_1));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_2 * tint_symbol_24_1.tint_symbol_2));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_3 * tint_symbol_24_1.tint_symbol_3));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_4 * tint_symbol_24_1.tint_symbol_4));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_5 * tint_symbol_24_1.tint_symbol_5));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_6 * tint_symbol_24_1.tint_symbol_6));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_7 * tint_symbol_24_1.tint_symbol_7));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_8 * tint_symbol_24_1.tint_symbol_8));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_9 * tint_symbol_24_1.tint_symbol_9));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_10 * tint_symbol_24_1.tint_symbol_10));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_11 * tint_symbol_24_1.tint_symbol_11));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_12 * tint_symbol_24_1.tint_symbol_12));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_13 * tint_symbol_24_1.tint_symbol_13));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_14 * tint_symbol_24_1.tint_symbol_14));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_15 * tint_symbol_24_1.tint_symbol_15));
  tint_symbol_26 = (tint_symbol_26 + (tint_symbol_24_1.tint_symbol_16 * tint_symbol_24_1.tint_symbol_16));
  let x_962 = tint_symbol_26;
  return sqrt(x_962);
}

fn tint_symbol_27(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_970 = tint_symbol_25(tint_symbol_24_2);
  if ((x_970 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_2.tint_symbol_1 / x_970), (tint_symbol_24_2.tint_symbol_2 / x_970), (tint_symbol_24_2.tint_symbol_3 / x_970), (tint_symbol_24_2.tint_symbol_4 / x_970), (tint_symbol_24_2.tint_symbol_5 / x_970), (tint_symbol_24_2.tint_symbol_6 / x_970), (tint_symbol_24_2.tint_symbol_7 / x_970), (tint_symbol_24_2.tint_symbol_8 / x_970), (tint_symbol_24_2.tint_symbol_9 / x_970), (tint_symbol_24_2.tint_symbol_10 / x_970), (tint_symbol_24_2.tint_symbol_11 / x_970), (tint_symbol_24_2.tint_symbol_12 / x_970), (tint_symbol_24_2.tint_symbol_13 / x_970), (tint_symbol_24_2.tint_symbol_14 / x_970), (tint_symbol_24_2.tint_symbol_15 / x_970), (tint_symbol_24_2.tint_symbol_16 / x_970));
  }
  let x_1014 = tint_return_value;
  return x_1014;
}

fn tint_symbol_29(tint_symbol_30 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_30.z, -(tint_symbol_30.y), tint_symbol_30.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_31(tint_symbol_1 : vec3f, tint_symbol_30_1 : vec3f) -> tint_symbol {
  let x_1030 = tint_symbol_29(tint_symbol_30_1);
  let x_1031 = tint_symbol_27(x_1030);
  return tint_symbol(0.0f, x_1031.tint_symbol_2, x_1031.tint_symbol_3, x_1031.tint_symbol_4, -(((-(x_1031.tint_symbol_3) * tint_symbol_1.z) - (x_1031.tint_symbol_2 * tint_symbol_1.y))), -(((x_1031.tint_symbol_2 * tint_symbol_1.x) - (x_1031.tint_symbol_4 * tint_symbol_1.z))), -(((x_1031.tint_symbol_4 * tint_symbol_1.y) + (x_1031.tint_symbol_3 * tint_symbol_1.x))), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_34(tint_symbol_24_3 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_24_3.tint_symbol_1, tint_symbol_24_3.tint_symbol_2, tint_symbol_24_3.tint_symbol_3, tint_symbol_24_3.tint_symbol_4, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_35(tint_symbol_23_1 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, -(tint_symbol_23_1.z), tint_symbol_23_1.y, -(tint_symbol_23_1.x), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_36(tint_symbol_23_2 : tint_symbol) -> vec3f {
  return vec3f((-(tint_symbol_23_2.tint_symbol_11) / tint_symbol_23_2.tint_symbol_8), (tint_symbol_23_2.tint_symbol_10 / tint_symbol_23_2.tint_symbol_8), (-(tint_symbol_23_2.tint_symbol_9) / tint_symbol_23_2.tint_symbol_8));
}

fn tint_symbol_37(tint_symbol_38 : vec3f, tint_symbol_39 : vec3f, tint_symbol_40 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, ((((tint_symbol_39.y * tint_symbol_40.z) - (tint_symbol_40.y * tint_symbol_39.z)) - ((tint_symbol_38.y * tint_symbol_40.z) - (tint_symbol_40.y * tint_symbol_38.z))) + ((tint_symbol_38.y * tint_symbol_39.z) - (tint_symbol_39.y * tint_symbol_38.z))), -(((((tint_symbol_39.x * tint_symbol_40.z) - (tint_symbol_40.x * tint_symbol_39.z)) - ((tint_symbol_38.x * tint_symbol_40.z) - (tint_symbol_40.x * tint_symbol_38.z))) + ((tint_symbol_38.x * tint_symbol_39.z) - (tint_symbol_39.x * tint_symbol_38.z)))), ((((tint_symbol_39.x * tint_symbol_40.y) - (tint_symbol_40.x * tint_symbol_39.y)) - ((tint_symbol_38.x * tint_symbol_40.y) - (tint_symbol_40.x * tint_symbol_38.y))) + ((tint_symbol_38.x * tint_symbol_39.y) - (tint_symbol_39.x * tint_symbol_38.y))), -((((tint_symbol_38.x * ((tint_symbol_39.y * tint_symbol_40.z) - (tint_symbol_40.y * tint_symbol_39.z))) - (tint_symbol_39.x * ((tint_symbol_38.y * tint_symbol_40.z) - (tint_symbol_40.y * tint_symbol_38.z)))) + (tint_symbol_40.x * ((tint_symbol_38.y * tint_symbol_39.z) - (tint_symbol_39.y * tint_symbol_38.z))))), 0.0f);
}

fn tint_symbol_44(tint_symbol_23_3 : vec3f, tint_symbol_24_4 : tint_symbol) -> vec3f {
  let x_1209 = tint_symbol_35(tint_symbol_23_3);
  let x_1210 = tint_symbol_22(x_1209, tint_symbol_24_4);
  let x_1211 = tint_symbol_36(x_1210);
  return x_1211;
}

fn tint_symbol_45(tint_symbol_30_2 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1216 = tint_symbol_34(tint_symbol_24_5);
  let x_1217 = tint_symbol_35(tint_symbol_30_2);
  let x_1218 = tint_symbol_22(x_1217, x_1216);
  let x_1219 = tint_symbol_36(x_1218);
  return x_1219;
}

fn tint_symbol_50(tint_symbol_51 : tint_symbol, tint_symbol_52 : tint_symbol) -> tint_symbol_47 {
  var tint_symbol_54 = tint_symbol_47(vec3f(), false, false);
  var x_1246 : bool;
  var x_1247 : bool;
  var x_1252 : bool;
  var x_1253 : bool;
  var x_1258 : bool;
  var x_1259 : bool;
  let x_1226 = tint_symbol_17(tint_symbol_51, tint_symbol_52);
  let x_1232 = tint_symbol_36(x_1226);
  tint_symbol_54.tint_symbol_23 = x_1232;
  tint_symbol_54.tint_symbol_48 = !((abs(x_1226.tint_symbol_8) <= 0.00000000999999993923f));
  let x_1241 = tint_symbol_54.tint_symbol_48;
  x_1247 = x_1241;
  if (x_1241) {
    x_1246 = (abs(x_1226.tint_symbol_9) <= 0.00000000999999993923f);
    x_1247 = x_1246;
  }
  x_1253 = x_1247;
  if (x_1247) {
    x_1252 = (abs(x_1226.tint_symbol_10) <= 0.00000000999999993923f);
    x_1253 = x_1252;
  }
  x_1259 = x_1253;
  if (x_1253) {
    x_1258 = (abs(x_1226.tint_symbol_11) <= 0.00000000999999993923f);
    x_1259 = x_1258;
  }
  tint_symbol_54.tint_symbol_49 = x_1259;
  let x_1260 = tint_symbol_54;
  return x_1260;
}

fn tint_symbol_77(tint_symbol_30_3 : vec3f) -> vec3f {
  var tint_symbol_78 = vec3f();
  let x_1268 = tint_symbol_73.inner.tint_symbol_56;
  let x_1265 = tint_symbol_45(tint_symbol_30_3, x_1268);
  tint_symbol_78 = x_1265;
  let x_1271 = tint_symbol_78;
  let x_1274 = tint_symbol_74.inner.tint_symbol_56;
  let x_1272 = tint_symbol_21(x_1274);
  let x_1275 = tint_symbol_45(x_1271, x_1272);
  tint_symbol_78 = x_1275;
  tint_symbol_78 = (tint_symbol_78 / tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1282 = tint_symbol_78;
  return x_1282;
}

fn tint_symbol_79(tint_symbol_80 : vec3f) -> vec3f {
  var tint_symbol_78_1 = vec3f();
  let x_1288 = tint_symbol_73.inner.tint_symbol_56;
  let x_1286 = tint_symbol_44(tint_symbol_80, x_1288);
  tint_symbol_78_1 = x_1286;
  let x_1290 = tint_symbol_78_1;
  let x_1293 = tint_symbol_74.inner.tint_symbol_56;
  let x_1291 = tint_symbol_21(x_1293);
  let x_1294 = tint_symbol_44(x_1290, x_1291);
  tint_symbol_78_1 = x_1294;
  tint_symbol_78_1 = (tint_symbol_78_1 / tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1300 = tint_symbol_78_1;
  return x_1300;
}

fn tint_symbol_81(tint_symbol_32 : vec3f) -> vec3f {
  var tint_symbol_78_2 = vec3f();
  tint_symbol_78_2 = (tint_symbol_32 * tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1310 = tint_symbol_78_2;
  let x_1312 = tint_symbol_74.inner.tint_symbol_56;
  let x_1309 = tint_symbol_45(x_1310, x_1312);
  tint_symbol_78_2 = x_1309;
  let x_1314 = tint_symbol_78_2;
  return normalize(x_1314);
}

fn tint_symbol_82(tint_symbol_80_1 : vec3f) -> vec3f {
  var tint_symbol_78_3 = vec3f();
  tint_symbol_78_3 = (tint_symbol_80_1 * tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1324 = tint_symbol_78_3;
  let x_1326 = tint_symbol_74.inner.tint_symbol_56;
  let x_1323 = tint_symbol_44(x_1324, x_1326);
  tint_symbol_78_3 = x_1323;
  let x_1327 = tint_symbol_78_3;
  return x_1327;
}

fn tint_symbol_83(tint_symbol_1_1 : vec3f, tint_symbol_30_4 : vec3f, tint_symbol_84 : tint_symbol_59, tint_symbol_85 : f32) -> vec2f {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = vec2f();
  var tint_symbol_54_1 = tint_symbol_47(vec3f(), false, false);
  var tint_symbol_86 = 0.0f;
  let x_1339 = tint_symbol_31(tint_symbol_1_1, tint_symbol_30_4);
  let x_1341 = tint_symbol_84.tint_symbol_60;
  let x_1343 = tint_symbol_84.tint_symbol_61;
  let x_1345 = tint_symbol_84.tint_symbol_62;
  let x_1340 = tint_symbol_37(x_1341.xyz, x_1343.xyz, x_1345.xyz);
  let x_1347 = tint_symbol_50(x_1339, x_1340);
  tint_symbol_54_1 = x_1347;
  if (tint_symbol_54_1.tint_symbol_48) {
    var x_1375 : bool;
    var x_1376 : bool;
    var x_1391 : bool;
    var x_1392 : bool;
    if ((abs((tint_symbol_84.tint_symbol_60.z - tint_symbol_84.tint_symbol_62.z)) <= 0.00000000999999993923f)) {
      let x_1368 = (tint_symbol_84.tint_symbol_60.x <= tint_symbol_54_1.tint_symbol_23.x);
      x_1376 = x_1368;
      if (x_1368) {
        x_1375 = (tint_symbol_54_1.tint_symbol_23.x <= tint_symbol_84.tint_symbol_62.x);
        x_1376 = x_1375;
      }
      var x_1390 : bool;
      x_1392 = x_1376;
      if (x_1376) {
        let x_1383 = (tint_symbol_84.tint_symbol_60.y <= tint_symbol_54_1.tint_symbol_23.y);
        x_1391 = x_1383;
        if (x_1383) {
          x_1390 = (tint_symbol_54_1.tint_symbol_23.y <= tint_symbol_84.tint_symbol_62.y);
          x_1391 = x_1390;
        }
        x_1392 = x_1391;
      }
      tint_symbol_54_1.tint_symbol_48 = x_1392;
    } else {
      var x_1415 : bool;
      var x_1416 : bool;
      var x_1431 : bool;
      var x_1432 : bool;
      if ((abs((tint_symbol_84.tint_symbol_60.y - tint_symbol_84.tint_symbol_62.y)) <= 0.00000000999999993923f)) {
        let x_1408 = (tint_symbol_84.tint_symbol_60.x <= tint_symbol_54_1.tint_symbol_23.x);
        x_1416 = x_1408;
        if (x_1408) {
          x_1415 = (tint_symbol_54_1.tint_symbol_23.x <= tint_symbol_84.tint_symbol_62.x);
          x_1416 = x_1415;
        }
        var x_1430 : bool;
        x_1432 = x_1416;
        if (x_1416) {
          let x_1423 = (tint_symbol_84.tint_symbol_60.z <= tint_symbol_54_1.tint_symbol_23.z);
          x_1431 = x_1423;
          if (x_1423) {
            x_1430 = (tint_symbol_54_1.tint_symbol_23.z <= tint_symbol_84.tint_symbol_62.z);
            x_1431 = x_1430;
          }
          x_1432 = x_1431;
        }
        tint_symbol_54_1.tint_symbol_48 = x_1432;
      } else {
        var x_1454 : bool;
        var x_1455 : bool;
        var x_1470 : bool;
        var x_1471 : bool;
        if ((abs((tint_symbol_84.tint_symbol_60.x - tint_symbol_84.tint_symbol_62.x)) <= 0.00000000999999993923f)) {
          let x_1447 = (tint_symbol_84.tint_symbol_60.y <= tint_symbol_54_1.tint_symbol_23.y);
          x_1455 = x_1447;
          if (x_1447) {
            x_1454 = (tint_symbol_54_1.tint_symbol_23.y <= tint_symbol_84.tint_symbol_62.y);
            x_1455 = x_1454;
          }
          var x_1469 : bool;
          x_1471 = x_1455;
          if (x_1455) {
            let x_1462 = (tint_symbol_84.tint_symbol_60.z <= tint_symbol_54_1.tint_symbol_23.z);
            x_1470 = x_1462;
            if (x_1462) {
              x_1469 = (tint_symbol_54_1.tint_symbol_23.z <= tint_symbol_84.tint_symbol_62.z);
              x_1470 = x_1469;
            }
            x_1471 = x_1470;
          }
          tint_symbol_54_1.tint_symbol_48 = x_1471;
        }
      }
    }
    if (tint_symbol_54_1.tint_symbol_48) {
      tint_symbol_86 = -1.0f;
      if ((tint_symbol_30_4.x > 0.00000000999999993923f)) {
        tint_symbol_86 = ((tint_symbol_54_1.tint_symbol_23.x - tint_symbol_1_1.x) / tint_symbol_30_4.x);
      } else {
        if ((tint_symbol_30_4.y > 0.00000000999999993923f)) {
          tint_symbol_86 = ((tint_symbol_54_1.tint_symbol_23.y - tint_symbol_1_1.y) / tint_symbol_30_4.y);
        } else {
          tint_symbol_86 = ((tint_symbol_54_1.tint_symbol_23.z - tint_symbol_1_1.z) / tint_symbol_30_4.z);
        }
      }
      if ((tint_symbol_86 < 0.0f)) {
        tint_return_flag_1 = true;
        tint_return_value_1 = vec2f(tint_symbol_85, -1.0f);
      } else {
        if ((tint_symbol_85 < 0.0f)) {
          tint_return_flag_1 = true;
          tint_return_value_1 = vec2f(tint_symbol_86, 1.0f);
        } else {
          if ((tint_symbol_86 < tint_symbol_85)) {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_86, 1.0f);
          } else {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_85, -1.0f);
          }
        }
      }
    }
  }
  if (!(tint_return_flag_1)) {
    tint_return_flag_1 = true;
    tint_return_value_1 = vec2f(tint_symbol_85, -1.0f);
  }
  let x_1531 = tint_return_value_1;
  return x_1531;
}

fn tint_symbol_87(tint_symbol_1_2 : vec3f, tint_symbol_30_5 : vec3f) -> vec2f {
  var tint_symbol_88 = 0.0f;
  var tint_symbol_89 = 0.0f;
  var tint_symbol_90 = 0i;
  tint_symbol_88 = -1.0f;
  tint_symbol_89 = -1.0f;
  tint_symbol_90 = 0i;
  loop {
    if (!((tint_symbol_90 < 6i))) {
      break;
    }
    let x_1555 = tint_symbol_74.inner.tint_symbol_66[tint_symbol_90];
    let x_1556 = tint_symbol_88;
    let x_1551 = tint_symbol_83(tint_symbol_1_2, tint_symbol_30_5, x_1555, x_1556);
    if ((x_1551.y > 0.0f)) {
      tint_symbol_88 = x_1551.x;
      tint_symbol_89 = f32(tint_symbol_90);
    }

    continuing {
      tint_symbol_90 = (tint_symbol_90 + 1i);
    }
  }
  let x_1566 = tint_symbol_88;
  let x_1567 = tint_symbol_89;
  return vec2f(x_1566, x_1567);
}

const x_1572 = vec4f(0.0f, 0.0f, 0.0f, 1.0f);

fn tint_symbol_92() -> vec4f {
  return x_1572;
}

fn tint_symbol_93(tint_symbol_89_1 : i32) -> vec4f {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = vec4f();
  switch(tint_symbol_89_1) {
    case 5i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.65490198135375976562f, 0.65882354974746704102f, 0.6666666865348815918f, 1.0f);
    }
    case 4i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.85098040103912353516f, 0.85098040103912353516f, 0.83921569585800170898f, 1.0f);
    }
    case 3i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.34901961684226989746f, 0.79607844352722167969f, 0.90980392694473266602f, 1.0f);
    }
    case 2i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.0f, 0.50980395078659057617f, 0.72941178083419799805f, 1.0f);
    }
    case 1i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(1.0f, 0.63921570777893066406f, 0.0f, 1.0f);
    }
    case 0i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.90980392694473266602f, 0.46666666865348815918f, 0.13333334028720855713f, 1.0f);
    }
    default: {
      tint_return_flag_2 = true;
      tint_return_value_2 = x_1572;
    }
  }
  let x_1608 = tint_return_value_2;
  return x_1608;
}

const x_1625 = vec3f(0.0f, -1.0f, 0.0f);

const x_1624 = vec3f(-1.0f, 0.0f, 0.0f);

const x_1623 = vec3f(0.0f, 0.0f, -1.0f);

fn tint_symbol_94(tint_symbol_89_2 : i32) -> vec3f {
  var tint_return_flag_3 = false;
  var tint_return_value_3 = vec3f();
  switch(tint_symbol_89_2) {
    case 5i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1625;
    }
    case 4i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1625;
    }
    case 3i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1624;
    }
    case 2i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1624;
    }
    case 1i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1623;
    }
    case 0i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1623;
    }
    default: {
      tint_return_flag_3 = true;
      tint_return_value_3 = vec3f();
    }
  }
  let x_1626 = tint_return_value_3;
  return x_1626;
}

fn tint_symbol_97(tint_symbol_98 : vec3f, tint_symbol_99 : vec3f, tint_symbol_100 : vec3f) -> tint_symbol_95 {
  var tint_symbol_78_4 = tint_symbol_95(vec4f(), vec3f());
  var x_1686 = vec4f();
  var x_1709 = vec4f();
  var x_1637 : i32;
  let x_1640 = tint_symbol_76.inner.tint_symbol_72.z;
  x_1637 = tint_ftoi(x_1640);
  if ((x_1637 == 1i)) {
    tint_symbol_78_4.tint_symbol_68 = tint_symbol_76.inner.tint_symbol_68;
    tint_symbol_78_4.tint_symbol_96 = normalize(tint_symbol_99);
  } else {
    if ((x_1637 == 2i)) {
      let x_1654 = normalize((tint_symbol_100 - tint_symbol_98));
      let x_1656 = dot(normalize(tint_symbol_99), x_1654);
      let x_1661 = tint_symbol_76.inner.tint_symbol_72.y;
      if ((x_1656 > cos(tint_symbol_76.inner.tint_symbol_72[0i]))) {
        let x_1668 = length((tint_symbol_100 - tint_symbol_98));
        tint_symbol_78_4.tint_symbol_68 = ((tint_symbol_76.inner.tint_symbol_68 * pow(x_1656, x_1661)) / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_1668 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_1668 * x_1668) * tint_symbol_76.inner.tint_symbol_71.z))));
      } else {
        tint_symbol_78_4.tint_symbol_68 = vec4f();
      }
      tint_symbol_78_4.tint_symbol_96 = x_1654;
    } else {
      let x_1692 = length((tint_symbol_100 - tint_symbol_98));
      tint_symbol_78_4.tint_symbol_68 = (tint_symbol_76.inner.tint_symbol_68 / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_1692 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_1692 * x_1692) * tint_symbol_76.inner.tint_symbol_71.z))));
      tint_symbol_78_4.tint_symbol_96 = normalize((tint_symbol_100 - tint_symbol_98));
    }
  }
  let x_1712 = tint_symbol_78_4;
  return x_1712;
}

fn tint_symbol_109(tint_symbol_110 : f32) -> f32 {
  var tint_return_flag_4 = false;
  var tint_return_value_4 = 0.0f;
  if ((tint_symbol_110 < 0.10000000149011611938f)) {
    tint_return_flag_4 = true;
    tint_return_value_4 = 0.0f;
  } else {
    if ((tint_symbol_110 < 0.34999999403953552246f)) {
      tint_return_flag_4 = true;
      tint_return_value_4 = 0.20000000298023223877f;
    } else {
      if ((tint_symbol_110 < 0.64999997615814208984f)) {
        tint_return_flag_4 = true;
        tint_return_value_4 = 0.5f;
      } else {
        if ((tint_symbol_110 < 0.89999997615814208984f)) {
          tint_return_flag_4 = true;
          tint_return_value_4 = 0.80000001192092895508f;
        } else {
          tint_return_flag_4 = true;
          tint_return_value_4 = 1.0f;
        }
      }
    }
  }
  let x_1742 = tint_return_value_4;
  return x_1742;
}

const x_1775 = vec4f(0.5f, 0.5f, 0.5f, 0.0f);

const x_1776 = vec4f(0.10000000149011611938f, 0.10000000149011611938f, 0.10000000149011611938f, 0.0f);

fn tint_symbol_111(tint_symbol_112 : vec4f, tint_symbol_113 : vec4f, tint_symbol_114 : vec3f, tint_symbol_115 : tint_symbol_95, tint_symbol_116 : vec3f, tint_symbol_117 : vec3f) -> vec4f {
  var tint_return_flag_5 = false;
  var tint_return_value_5 = vec4f();
  var x_1754 : vec3f;
  var x_1755 : vec4f;
  var x_1756 : i32;
  var x_1760 : f32;
  x_1754 = tint_symbol_115.tint_symbol_96;
  x_1755 = tint_symbol_115.tint_symbol_68;
  let x_1759 = tint_symbol_76.inner.tint_symbol_72.w;
  x_1756 = tint_ftoi(x_1759);
  x_1760 = max(dot(tint_symbol_114, -(x_1754)), 0.0f);
  if ((x_1756 == 1i)) {
    tint_return_flag_5 = true;
    tint_return_value_5 = (((tint_symbol_112 + ((tint_symbol_113 * x_1755) * x_1760)) + ((x_1775 * x_1755) * pow(max(dot(normalize((tint_symbol_116 - tint_symbol_117)), -(reflect(x_1754, tint_symbol_114))), 0.0f), 64.0f))) + (x_1776 * x_1755));
  } else {
    if ((x_1756 == 2i)) {
      let x_1796 = tint_symbol_109(x_1760);
      let x_1797 = tint_symbol_109(pow(max(dot(normalize((tint_symbol_116 - tint_symbol_117)), -(reflect(x_1754, tint_symbol_114))), 0.0f), 64.0f));
      tint_return_flag_5 = true;
      tint_return_value_5 = (((tint_symbol_112 + ((tint_symbol_113 * x_1755) * x_1796)) + ((x_1775 * x_1755) * x_1797)) + (x_1776 * x_1755));
    } else {
      tint_return_flag_5 = true;
      tint_return_value_5 = (tint_symbol_112 + ((tint_symbol_113 * x_1755) * x_1760));
    }
  }
  let x_1809 = tint_return_value_5;
  return x_1809;
}

const x_1834 = vec2f(2.0f);

const x_1866 = vec4f(0.0f, 0.21960784494876861572f, 0.39607843756675720215f, 1.0f);

fn tint_symbol_129_inner(tint_symbol_130 : vec3u) {
  var tint_symbol_134 = vec3f();
  var tint_symbol_135 = vec3f();
  var tint_symbol_54_2 = vec2f();
  var tint_symbol_136 = vec4f();
  var tint_symbol_114_1 = vec3f();
  var tint_symbol_117_1 = vec3f();
  var x_1829 : bool;
  var x_1830 : bool;
  let x_1815 = bitcast<vec2i>(tint_symbol_130.xy);
  let x_1819 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_1824 = (x_1815.x >= x_1819.x);
  x_1830 = x_1824;
  if (x_1824) {
  } else {
    x_1829 = (x_1815.y >= x_1819.y);
    x_1830 = x_1829;
  }
  if (x_1830) {
    return;
  }
  let x_1839 = (x_1834 / tint_symbol_73.inner.tint_symbol_58.xy);
  tint_symbol_134 = vec3f((((f32(x_1815.x) + 0.5f) * x_1839.x) - 1.0f), (((f32(x_1815.y) + 0.5f) * x_1839.y) - 1.0f), 0.0f);
  tint_symbol_135 = vec3f(0.0f, 0.0f, 1.0f);
  let x_1857 = tint_symbol_134;
  let x_1856 = tint_symbol_79(x_1857);
  tint_symbol_134 = x_1856;
  let x_1859 = tint_symbol_135;
  let x_1858 = tint_symbol_77(x_1859);
  tint_symbol_135 = x_1858;
  let x_1861 = tint_symbol_134;
  let x_1862 = tint_symbol_135;
  let x_1860 = tint_symbol_87(x_1861, x_1862);
  tint_symbol_54_2 = x_1860;
  tint_symbol_136 = x_1866;
  if ((tint_symbol_54_2.x > 0.0f)) {
    let x_1873 = tint_symbol_92();
    let x_1877 = tint_symbol_54_2.y;
    let x_1875 = tint_ftoi(x_1877);
    let x_1874 = tint_symbol_93(x_1875);
    let x_1881 = tint_symbol_54_2.y;
    let x_1879 = tint_ftoi(x_1881);
    let x_1878 = tint_symbol_94(x_1879);
    tint_symbol_114_1 = x_1878;
    let x_1884 = tint_symbol_114_1;
    let x_1883 = tint_symbol_81(x_1884);
    tint_symbol_114_1 = x_1883;
    let x_1887 = tint_symbol_73.inner.tint_symbol_56;
    let x_1885 = tint_symbol_21(x_1887);
    let x_1890 = tint_symbol_76.inner.tint_symbol_69;
    let x_1888 = tint_symbol_44(x_1890.xyz, x_1885);
    let x_1894 = tint_symbol_73.inner.tint_symbol_56;
    let x_1892 = tint_symbol_21(x_1894);
    let x_1897 = tint_symbol_76.inner.tint_symbol_70;
    let x_1895 = tint_symbol_45(x_1897.xyz, x_1892);
    tint_symbol_117_1 = (tint_symbol_134 + (tint_symbol_135 * tint_symbol_54_2.x));
    let x_1907 = tint_symbol_117_1;
    let x_1906 = tint_symbol_82(x_1907);
    tint_symbol_117_1 = x_1906;
    let x_1909 = tint_symbol_117_1;
    let x_1908 = tint_symbol_97(x_1888, x_1895, x_1909);
    let x_1912 = tint_symbol_73.inner.tint_symbol_56;
    let x_1910 = tint_symbol_44(vec3f(), x_1912);
    let x_1914 = tint_symbol_114_1;
    let x_1915 = tint_symbol_117_1;
    let x_1913 = tint_symbol_111(x_1873, x_1874, x_1914, x_1908, x_1910, x_1915);
    tint_symbol_136 = x_1913;
  }
  let x_1918 = tint_symbol_136;
  textureStore(tint_symbol_75, x_1815, x_1918);
  return;
}

fn tint_symbol_129_1() {
  let x_1923 = tint_symbol_130_1;
  tint_symbol_129_inner(x_1923);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMain(@builtin(global_invocation_id) tint_symbol_130_1_param : vec3u) {
  tint_symbol_130_1 = tint_symbol_130_1_param;
  tint_symbol_129_1();
}

fn tint_symbol_137_inner(tint_symbol_130_3 : vec3u) {
  var tint_symbol_134_1 = vec3f();
  var tint_symbol_135_1 = vec3f();
  var tint_symbol_54_3 = vec2f();
  var tint_symbol_136_1 = vec4f();
  var tint_symbol_114_2 = vec3f();
  var tint_symbol_117_2 = vec3f();
  var x_1939 : bool;
  var x_1940 : bool;
  let x_1927 = bitcast<vec2i>(tint_symbol_130_3.xy);
  let x_1929 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_1934 = (x_1927.x >= x_1929.x);
  x_1940 = x_1934;
  if (x_1934) {
  } else {
    x_1939 = (x_1927.y >= x_1929.y);
    x_1940 = x_1939;
  }
  if (x_1940) {
    return;
  }
  let x_1949 = (x_1834 / (tint_symbol_73.inner.tint_symbol_58.xy * tint_symbol_73.inner.tint_symbol_57));
  tint_symbol_134_1 = vec3f();
  tint_symbol_135_1 = normalize(vec3f((((f32(x_1927.x) + 0.5f) * x_1949.x) - (1.0f / tint_symbol_73.inner.tint_symbol_57.x)), (((f32(x_1927.y) + 0.5f) * x_1949.y) - (1.0f / tint_symbol_73.inner.tint_symbol_57.y)), 1.0f));
  let x_1973 = tint_symbol_134_1;
  let x_1972 = tint_symbol_79(x_1973);
  tint_symbol_134_1 = x_1972;
  let x_1975 = tint_symbol_135_1;
  let x_1974 = tint_symbol_77(x_1975);
  tint_symbol_135_1 = x_1974;
  let x_1977 = tint_symbol_134_1;
  let x_1978 = tint_symbol_135_1;
  let x_1976 = tint_symbol_87(x_1977, x_1978);
  tint_symbol_54_3 = x_1976;
  tint_symbol_136_1 = x_1866;
  if ((tint_symbol_54_3.x > 0.0f)) {
    let x_1986 = tint_symbol_92();
    let x_1990 = tint_symbol_54_3.y;
    let x_1988 = tint_ftoi(x_1990);
    let x_1987 = tint_symbol_93(x_1988);
    let x_1994 = tint_symbol_54_3.y;
    let x_1992 = tint_ftoi(x_1994);
    let x_1991 = tint_symbol_94(x_1992);
    tint_symbol_114_2 = x_1991;
    let x_1997 = tint_symbol_114_2;
    let x_1996 = tint_symbol_81(x_1997);
    tint_symbol_114_2 = x_1996;
    let x_2000 = tint_symbol_73.inner.tint_symbol_56;
    let x_1998 = tint_symbol_21(x_2000);
    let x_2003 = tint_symbol_76.inner.tint_symbol_69;
    let x_2001 = tint_symbol_44(x_2003.xyz, x_1998);
    let x_2007 = tint_symbol_73.inner.tint_symbol_56;
    let x_2005 = tint_symbol_21(x_2007);
    let x_2010 = tint_symbol_76.inner.tint_symbol_70;
    let x_2008 = tint_symbol_45(x_2010.xyz, x_2005);
    tint_symbol_117_2 = (tint_symbol_134_1 + (tint_symbol_135_1 * tint_symbol_54_3.x));
    let x_2020 = tint_symbol_117_2;
    let x_2019 = tint_symbol_82(x_2020);
    tint_symbol_117_2 = x_2019;
    let x_2022 = tint_symbol_117_2;
    let x_2021 = tint_symbol_97(x_2001, x_2008, x_2022);
    let x_2025 = tint_symbol_73.inner.tint_symbol_56;
    let x_2023 = tint_symbol_44(vec3f(), x_2025);
    let x_2027 = tint_symbol_114_2;
    let x_2028 = tint_symbol_117_2;
    let x_2026 = tint_symbol_111(x_1986, x_1987, x_2027, x_2021, x_2023, x_2028);
    tint_symbol_136_1 = x_2026;
  }
  let x_2031 = tint_symbol_136_1;
  textureStore(tint_symbol_75, x_1927, x_2031);
  return;
}

fn tint_symbol_137_1() {
  let x_2035 = tint_symbol_130_2;
  tint_symbol_137_inner(x_2035);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMain(@builtin(global_invocation_id) tint_symbol_130_2_param : vec3u) {
  tint_symbol_130_2 = tint_symbol_130_2_param;
  tint_symbol_137_1();
}
