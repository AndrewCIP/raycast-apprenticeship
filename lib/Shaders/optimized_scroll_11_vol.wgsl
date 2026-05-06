/*
 * Copyright (c) 2026 Sing Chun LEE @ Bucknell University. CC BY-NC 4.0.
 *
 * This code is provided mainly for educational purposes at University of the Pacific.
 *
 * This code is licensed under the Creative Commons Attribution-NonCommercial 4.0
 * International License. To view a copy of the license, visit
 *   https://creativecommons.org/licenses/by-nc/4.0/
 *
 * Scroll 11 — Volume Rendering Worksheet
 *
 * This shader implements three volume-rendering modes via ray marching:
 *   1. Maximum Intensity Projection (MIP)
 *   2. Digitally Reconstructed Radiograph (DRR) — Beer–Lambert absorption
 *   3. Depth-based false-color encoding
 *
 * For each mode, both orthogonal and projective (pinhole) cameras are provided,
 * giving six compute entry points in total.
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

struct tint_symbol_40 {
  /* @offset(0) */
  tint_symbol_41 : tint_symbol,
  /* @offset(64) */
  tint_symbol_42 : vec2f,
  /* @offset(72) */
  tint_symbol_43 : vec2f,
}

struct tint_symbol_47_block {
  /* @offset(0) */
  inner : tint_symbol_40,
}

struct tint_symbol_44 {
  /* @offset(0) */
  tint_symbol_45 : vec4f,
  /* @offset(16) */
  tint_symbol_46 : vec4f,
}

struct tint_symbol_48_block {
  /* @offset(0) */
  inner : tint_symbol_44,
}

alias RTArr = array<f32>;

struct tint_symbol_49_block {
  /* @offset(0) */
  inner : RTArr,
}

alias Arr = array<vec3f, 2u>;

var<private> tint_symbol_111_1 : vec3u;

var<private> tint_symbol_111_2 : vec3u;

var<private> tint_symbol_111_3 : vec3u;

var<private> tint_symbol_111_4 : vec3u;

var<private> tint_symbol_111_5 : vec3u;

var<private> tint_symbol_111_6 : vec3u;

var<private> tint_symbol_111_7 : vec3u;

var<private> tint_symbol_111_8 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_47 : tint_symbol_47_block;

@group(0) @binding(1) var<uniform> tint_symbol_48 : tint_symbol_48_block;

@group(0) @binding(2) var<storage> tint_symbol_49 : tint_symbol_49_block;

@group(0) @binding(3) var tint_symbol_50 : texture_storage_2d<rgba8unorm, write>;

fn tint_ftoi(v : vec3f) -> vec3i {
  return select(vec3i(2147483647i), select(vec3i(v), vec3i(i32(-2147483648)), (v < vec3f(-2147483648.0f))), (v < vec3f(2147483520.0f)));
}

fn tint_ftoi_1(v_1 : f32) -> i32 {
  return select(2147483647i, select(i32(v_1), i32(-2147483648), (v_1 < -2147483648.0f)), (v_1 < 2147483520.0f));
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
  let x_855 = tint_symbol_20;
  return x_855;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_891 = tint_symbol_21(tint_symbol_24);
  let x_892 = tint_symbol_17(tint_symbol_23, x_891);
  let x_893 = tint_symbol_17(tint_symbol_24, x_892);
  return x_893;
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
  let x_982 = tint_symbol_26;
  return sqrt(x_982);
}

fn tint_symbol_27(tint_symbol_28 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_28.z, -(tint_symbol_28.y), tint_symbol_28.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_32(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_999 = tint_symbol_25(tint_symbol_24_2);
  if ((x_999 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_2.tint_symbol_1 / x_999), (tint_symbol_24_2.tint_symbol_2 / x_999), (tint_symbol_24_2.tint_symbol_3 / x_999), (tint_symbol_24_2.tint_symbol_4 / x_999), (tint_symbol_24_2.tint_symbol_5 / x_999), (tint_symbol_24_2.tint_symbol_6 / x_999), (tint_symbol_24_2.tint_symbol_7 / x_999), (tint_symbol_24_2.tint_symbol_8 / x_999), (tint_symbol_24_2.tint_symbol_9 / x_999), (tint_symbol_24_2.tint_symbol_10 / x_999), (tint_symbol_24_2.tint_symbol_11 / x_999), (tint_symbol_24_2.tint_symbol_12 / x_999), (tint_symbol_24_2.tint_symbol_13 / x_999), (tint_symbol_24_2.tint_symbol_14 / x_999), (tint_symbol_24_2.tint_symbol_15 / x_999), (tint_symbol_24_2.tint_symbol_16 / x_999));
  }
  let x_1043 = tint_return_value;
  return x_1043;
}

fn tint_symbol_29(tint_symbol_1 : vec3f, tint_symbol_28_1 : vec3f) -> tint_symbol {
  let x_1049 = tint_symbol_27(tint_symbol_28_1);
  let x_1050 = tint_symbol_32(x_1049);
  return tint_symbol(0.0f, x_1050.tint_symbol_2, x_1050.tint_symbol_3, x_1050.tint_symbol_4, -(((-(x_1050.tint_symbol_3) * tint_symbol_1.z) - (x_1050.tint_symbol_2 * tint_symbol_1.y))), -(((x_1050.tint_symbol_2 * tint_symbol_1.x) - (x_1050.tint_symbol_4 * tint_symbol_1.z))), -(((x_1050.tint_symbol_4 * tint_symbol_1.y) + (x_1050.tint_symbol_3 * tint_symbol_1.x))), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_34(tint_symbol_23_1 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, -(tint_symbol_23_1.z), tint_symbol_23_1.y, -(tint_symbol_23_1.x), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_35(tint_symbol_23_2 : tint_symbol) -> vec3f {
  return vec3f((-(tint_symbol_23_2.tint_symbol_11) / tint_symbol_23_2.tint_symbol_8), (tint_symbol_23_2.tint_symbol_10 / tint_symbol_23_2.tint_symbol_8), (-(tint_symbol_23_2.tint_symbol_9) / tint_symbol_23_2.tint_symbol_8));
}

fn tint_symbol_36(tint_symbol_24_3 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_24_3.tint_symbol_1, tint_symbol_24_3.tint_symbol_2, tint_symbol_24_3.tint_symbol_3, tint_symbol_24_3.tint_symbol_4, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_37(tint_symbol_23_3 : vec3f, tint_symbol_24_4 : tint_symbol) -> vec3f {
  let x_1118 = tint_symbol_34(tint_symbol_23_3);
  let x_1119 = tint_symbol_22(x_1118, tint_symbol_24_4);
  let x_1120 = tint_symbol_35(x_1119);
  return x_1120;
}

fn tint_symbol_38(tint_symbol_28_2 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1125 = tint_symbol_36(tint_symbol_24_5);
  let x_1126 = tint_symbol_34(tint_symbol_28_2);
  let x_1127 = tint_symbol_22(x_1126, x_1125);
  let x_1128 = tint_symbol_35(x_1127);
  return x_1128;
}

fn tint_symbol_51(tint_symbol_52 : vec3f) -> vec3f {
  let x_1136 = tint_symbol_47.inner.tint_symbol_41;
  let x_1133 = tint_symbol_37(tint_symbol_52, x_1136);
  return x_1133;
}

fn tint_symbol_53(tint_symbol_28_3 : vec3f) -> vec3f {
  let x_1142 = tint_symbol_47.inner.tint_symbol_41;
  let x_1140 = tint_symbol_38(tint_symbol_28_3, x_1142);
  return x_1140;
}

fn tint_symbol_55(tint_symbol_56 : vec3f) -> f32 {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = 0.0f;
  var x_1169 = vec3f();
  var x_1181 : bool;
  var x_1184 : bool;
  let x_1168 = (((tint_symbol_48.inner.tint_symbol_45.xyz * tint_symbol_48.inner.tint_symbol_46.xyz) * 0.5f) / vec3f(max(max(tint_symbol_48.inner.tint_symbol_45.x, tint_symbol_48.inner.tint_symbol_45.y), tint_symbol_48.inner.tint_symbol_45.z)));
  let x_1176 = ((tint_symbol_56 + x_1168) / (x_1168 * 2.0f));
  let x_1177 = any((x_1176 < vec3f()));
  x_1184 = x_1177;
  if (x_1177) {
  } else {
    x_1181 = any((x_1176 >= vec3f(1.0f)));
    x_1184 = x_1181;
  }
  if (x_1184) {
    tint_return_flag_1 = true;
    tint_return_value_1 = 0.0f;
  }
  if (!(tint_return_flag_1)) {
    let x_1193 = tint_symbol_48.inner.tint_symbol_45;
    let x_1191 = tint_ftoi((x_1176 * x_1193.xyz));
    let x_1199 = tint_symbol_48.inner.tint_symbol_45.x;
    let x_1197 = tint_ftoi_1(x_1199);
    let x_1203 = tint_symbol_48.inner.tint_symbol_45.y;
    let x_1201 = tint_ftoi_1(x_1203);
    let x_1208 = tint_symbol_48.inner.tint_symbol_45.x;
    let x_1206 = tint_ftoi_1(x_1208);
    tint_return_flag_1 = true;
    tint_return_value_1 = tint_symbol_49.inner[((((x_1191.z * x_1197) * x_1201) + (x_1191.y * x_1206)) + x_1191.x)];
  }
  let x_1216 = tint_return_value_1;
  return x_1216;
}

fn tint_symbol_62(tint_symbol_63 : vec2f, tint_symbol_64 : f32) -> vec2f {
  var tint_symbol_65 = vec2f();
  tint_symbol_65 = tint_symbol_63;
  if ((tint_symbol_63.x < 0.0f)) {
    tint_symbol_65.x = tint_symbol_64;
  } else {
    var x_1244 : bool;
    var x_1245 : bool;
    if ((tint_symbol_64 < tint_symbol_63.x)) {
      tint_symbol_65.y = tint_symbol_63.x;
      tint_symbol_65.x = tint_symbol_64;
    } else {
      let x_1240 = (tint_symbol_63.y < 0.0f);
      x_1245 = x_1240;
      if (x_1240) {
      } else {
        x_1244 = (tint_symbol_64 < tint_symbol_63.y);
        x_1245 = x_1244;
      }
      if (x_1245) {
        tint_symbol_65.y = tint_symbol_64;
      }
    }
  }
  let x_1249 = tint_symbol_65;
  return x_1249;
}

fn tint_symbol_66(tint_symbol_67 : f32, tint_symbol_58 : vec2f, tint_symbol_68 : f32, tint_symbol_69 : f32, tint_symbol_23_4 : vec2f, tint_symbol_28_4 : vec2f, tint_symbol_70 : vec2f) -> vec2f {
  var tint_symbol_71 = vec2f();
  tint_symbol_71 = tint_symbol_70;
  if ((abs(tint_symbol_69) > 0.00000000999999993923f)) {
    var x_1267 : f32;
    var x_1281 : bool;
    var x_1282 : bool;
    var x_1288 : bool;
    var x_1289 : bool;
    var x_1294 : bool;
    var x_1295 : bool;
    x_1267 = ((tint_symbol_67 - tint_symbol_68) / tint_symbol_69);
    if ((x_1267 > 0.0f)) {
      let x_1272 = (tint_symbol_23_4 + (tint_symbol_28_4 * x_1267));
      let x_1276 = (-(tint_symbol_58.x) < x_1272.x);
      x_1282 = x_1276;
      if (x_1276) {
        x_1281 = (x_1272.x < tint_symbol_58.x);
        x_1282 = x_1281;
      }
      x_1289 = x_1282;
      if (x_1282) {
        x_1288 = (-(tint_symbol_58.y) < x_1272.y);
        x_1289 = x_1288;
      }
      x_1295 = x_1289;
      if (x_1289) {
        x_1294 = (x_1272.y < tint_symbol_58.y);
        x_1295 = x_1294;
      }
      if (x_1295) {
        let x_1299 = tint_symbol_71;
        let x_1298 = tint_symbol_62(x_1299, x_1267);
        tint_symbol_71 = x_1298;
      }
    }
  }
  let x_1300 = tint_symbol_71;
  return x_1300;
}

fn tint_symbol_73(tint_symbol_23_5 : vec3f, tint_symbol_28_5 : vec3f) -> vec2f {
  var tint_symbol_74 = vec2f();
  var x_1324 = vec4f();
  tint_symbol_74 = vec2f(-1.0f);
  let x_1323 = (((tint_symbol_48.inner.tint_symbol_45 * tint_symbol_48.inner.tint_symbol_46) * 0.5f) / vec4f(max(max(tint_symbol_48.inner.tint_symbol_45.x, tint_symbol_48.inner.tint_symbol_45.y), tint_symbol_48.inner.tint_symbol_45.z)));
  let x_1335 = tint_symbol_74;
  let x_1328 = tint_symbol_66(x_1323.z, x_1323.xy, tint_symbol_23_5.z, tint_symbol_28_5.z, tint_symbol_23_5.xy, tint_symbol_28_5.xy, x_1335);
  tint_symbol_74 = x_1328;
  let x_1344 = tint_symbol_74;
  let x_1336 = tint_symbol_66(-(x_1323.z), x_1323.xy, tint_symbol_23_5.z, tint_symbol_28_5.z, tint_symbol_23_5.xy, tint_symbol_28_5.xy, x_1344);
  tint_symbol_74 = x_1336;
  let x_1353 = tint_symbol_74;
  let x_1345 = tint_symbol_66(-(x_1323.x), x_1323.yz, tint_symbol_23_5.x, tint_symbol_28_5.x, tint_symbol_23_5.yz, tint_symbol_28_5.yz, x_1353);
  tint_symbol_74 = x_1345;
  let x_1361 = tint_symbol_74;
  let x_1354 = tint_symbol_66(x_1323.x, x_1323.yz, tint_symbol_23_5.x, tint_symbol_28_5.x, tint_symbol_23_5.yz, tint_symbol_28_5.yz, x_1361);
  tint_symbol_74 = x_1354;
  let x_1369 = tint_symbol_74;
  let x_1362 = tint_symbol_66(x_1323.y, x_1323.xz, tint_symbol_23_5.y, tint_symbol_28_5.y, tint_symbol_23_5.xz, tint_symbol_28_5.xz, x_1369);
  tint_symbol_74 = x_1362;
  let x_1378 = tint_symbol_74;
  let x_1370 = tint_symbol_66(-(x_1323.y), x_1323.xz, tint_symbol_23_5.y, tint_symbol_28_5.y, tint_symbol_23_5.xz, tint_symbol_28_5.xz, x_1378);
  tint_symbol_74 = x_1370;
  let x_1379 = tint_symbol_74;
  return x_1379;
}

fn tint_symbol_77(tint_symbol_78 : vec2f) -> vec2f {
  var tint_symbol_79 = vec2f();
  var x_1392 : bool;
  var x_1393 : bool;
  tint_symbol_79 = tint_symbol_78;
  let x_1387 = (tint_symbol_79.y < 0.0f);
  x_1393 = x_1387;
  if (x_1387) {
    x_1392 = (tint_symbol_79.x > 0.0f);
    x_1393 = x_1392;
  }
  if (x_1393) {
    tint_symbol_79.y = tint_symbol_79.x;
    tint_symbol_79.x = 0.0f;
  }
  let x_1400 = tint_symbol_79;
  return x_1400;
}

fn tint_symbol_80(tint_symbol_64_1 : f32) -> vec3f {
  var tint_symbol_20_1 = 0.0f;
  var tint_symbol_82 = 0.0f;
  var tint_symbol_19_1 = 0.0f;
  var x_1405 : f32;
  x_1405 = clamp(tint_symbol_64_1, 0.0f, 1.0f);
  if ((x_1405 < 0.25f)) {
    tint_symbol_20_1 = 0.0f;
    tint_symbol_82 = (x_1405 / 0.25f);
    tint_symbol_19_1 = 1.0f;
  } else {
    if ((x_1405 < 0.5f)) {
      tint_symbol_20_1 = 0.0f;
      tint_symbol_82 = 1.0f;
      tint_symbol_19_1 = (1.0f - ((x_1405 - 0.25f) / 0.25f));
    } else {
      if ((x_1405 < 0.75f)) {
        tint_symbol_20_1 = ((x_1405 - 0.5f) / 0.25f);
        tint_symbol_82 = 1.0f;
        tint_symbol_19_1 = 0.0f;
      } else {
        tint_symbol_20_1 = 1.0f;
        tint_symbol_82 = (1.0f - ((x_1405 - 0.75f) / 0.25f));
        tint_symbol_19_1 = 0.0f;
      }
    }
  }
  let x_1432 = tint_symbol_20_1;
  let x_1433 = tint_symbol_82;
  let x_1434 = tint_symbol_19_1;
  return vec3f(x_1432, x_1433, x_1434);
}

fn tint_symbol_83(tint_symbol_84 : f32) -> vec3f {
  var x_1448 = vec3f();
  let x_1439 = clamp(tint_symbol_84, 0.0f, 1.0f);
  return mix((vec3f(0.44999998807907104492f, 0.69999998807907104492f, 1.0f) * 0.11999999731779098511f), vec3f(1.0f, 0.25f, 0.37999999523162841797f), vec3f(x_1439));
}

const x_1469 = vec4f(0.0f, 0.21960784494876861572f, 0.39607843756675720215f, 1.0f);

fn tint_symbol_87(tint_symbol_88 : vec2i, tint_symbol_23_6 : vec3f, tint_symbol_28_6 : vec3f) {
  var tint_return_flag_2 = false;
  var tint_symbol_89 = 0.0f;
  var tint_symbol_90 = 0.0f;
  var tint_symbol_92 = 0i;
  let x_1459 = tint_symbol_73(tint_symbol_23_6, tint_symbol_28_6);
  let x_1460 = tint_symbol_77(x_1459);
  if ((x_1460.x < 0.0f)) {
    textureStore(tint_symbol_50, tint_symbol_88, x_1469);
    tint_return_flag_2 = true;
  }
  if (!(tint_return_flag_2)) {
    tint_symbol_89 = 0.0f;
    tint_symbol_90 = x_1460.x;
    let x_1481 = ((x_1460.y - x_1460.x) / 300.0f);
    tint_symbol_92 = 0i;
    loop {
      if (!((tint_symbol_92 < 300i))) {
        break;
      }
      let x_1500 = (x_1460.x + ((f32(tint_symbol_92) + 0.5f) * x_1481));
      let x_1503 = tint_symbol_55((tint_symbol_23_6 + (tint_symbol_28_6 * x_1500)));
      if ((x_1503 > tint_symbol_89)) {
        tint_symbol_89 = x_1503;
        tint_symbol_90 = x_1500;
      }

      continuing {
        tint_symbol_92 = (tint_symbol_92 + 1i);
      }
    }
    if ((tint_symbol_89 < 10.0f)) {
      textureStore(tint_symbol_50, tint_symbol_88, x_1469);
      tint_return_flag_2 = true;
    }
    if (!(tint_return_flag_2)) {
      let x_1522 = tint_symbol_90;
      let x_1531 = tint_symbol_89;
      let x_1534 = tint_symbol_80(((x_1522 - x_1460.x) / max((x_1460.y - x_1460.x), 0.00000000999999993923f)));
      let x_1537 = (x_1534 * clamp((x_1531 / 4095.0f), 0.0f, 1.0f));
      textureStore(tint_symbol_50, tint_symbol_88, vec4f(x_1537.x, x_1537.y, x_1537.z, 1.0f));
    }
  }
  return;
}

fn tint_symbol_97(tint_symbol_88_1 : vec2i, tint_symbol_23_7 : vec3f, tint_symbol_28_7 : vec3f) {
  var tint_return_flag_3 = false;
  var tint_symbol_89_1 = 0.0f;
  var tint_symbol_92_1 = 0i;
  let x_1548 = tint_symbol_73(tint_symbol_23_7, tint_symbol_28_7);
  let x_1549 = tint_symbol_77(x_1548);
  if ((x_1549.x < 0.0f)) {
    textureStore(tint_symbol_50, tint_symbol_88_1, x_1469);
    tint_return_flag_3 = true;
  }
  if (!(tint_return_flag_3)) {
    tint_symbol_89_1 = 0.0f;
    let x_1564 = ((x_1549.y - x_1549.x) / 300.0f);
    tint_symbol_92_1 = 0i;
    loop {
      if (!((tint_symbol_92_1 < 300i))) {
        break;
      }
      let x_1577 = tint_symbol_92_1;
      let x_1583 = tint_symbol_89_1;
      let x_1584 = tint_symbol_55((tint_symbol_23_7 + (tint_symbol_28_7 * (x_1549.x + ((f32(x_1577) + 0.5f) * x_1564)))));
      tint_symbol_89_1 = max(x_1583, x_1584);

      continuing {
        tint_symbol_92_1 = (tint_symbol_92_1 + 1i);
      }
    }
    let x_1588 = tint_symbol_89_1;
    let x_1590 = tint_symbol_83((x_1588 / 4095.0f));
    textureStore(tint_symbol_50, tint_symbol_88_1, vec4f(x_1590.x, x_1590.y, x_1590.z, 1.0f));
  }
  return;
}

fn tint_symbol_98(tint_symbol_88_2 : vec2i, tint_symbol_23_8 : vec3f, tint_symbol_28_8 : vec3f) {
  var tint_return_flag_4 = false;
  var tint_symbol_99 = 0.0f;
  var tint_symbol_92_2 = 0i;
  let x_1603 = tint_symbol_73(tint_symbol_23_8, tint_symbol_28_8);
  let x_1604 = tint_symbol_77(x_1603);
  if ((x_1604.x < 0.0f)) {
    textureStore(tint_symbol_50, tint_symbol_88_2, x_1469);
    tint_return_flag_4 = true;
  }
  if (!(tint_return_flag_4)) {
    tint_symbol_99 = 1.0f;
    let x_1619 = ((x_1604.y - x_1604.x) / 300.0f);
    tint_symbol_92_2 = 0i;
    loop {
      if (!((tint_symbol_92_2 < 300i))) {
        break;
      }
      let x_1633 = tint_symbol_92_2;
      let x_1639 = tint_symbol_55((tint_symbol_23_8 + (tint_symbol_28_8 * (x_1604.x + ((f32(x_1633) + 0.5f) * x_1619)))));
      tint_symbol_99 = (tint_symbol_99 * exp((-((x_1639 / 4095.0f)) * 0.03999999910593032837f)));

      continuing {
        tint_symbol_92_2 = (tint_symbol_92_2 + 1i);
      }
    }
    let x_1648 = tint_symbol_99;
    let x_1650 = tint_symbol_83((1.0f - x_1648));
    textureStore(tint_symbol_50, tint_symbol_88_2, vec4f(x_1650.x, x_1650.y, x_1650.z, 1.0f));
  }
  return;
}

fn tint_symbol_102(tint_symbol_88_3 : vec2i, tint_symbol_23_9 : vec3f, tint_symbol_28_9 : vec3f) {
  var tint_return_flag_5 = false;
  var tint_symbol_104 = 0.0f;
  var tint_symbol_92_3 = 0i;
  let x_1663 = tint_symbol_73(tint_symbol_23_9, tint_symbol_28_9);
  let x_1664 = tint_symbol_77(x_1663);
  if ((x_1664.x < 0.0f)) {
    textureStore(tint_symbol_50, tint_symbol_88_3, x_1469);
    tint_return_flag_5 = true;
  }
  if (!(tint_return_flag_5)) {
    let x_1679 = ((x_1664.y - x_1664.x) / 300.0f);
    tint_symbol_104 = -1.0f;
    tint_symbol_92_3 = 0i;
    loop {
      if (!((tint_symbol_92_3 < 300i))) {
        break;
      }
      let x_1696 = (x_1664.x + ((f32(tint_symbol_92_3) + 0.5f) * x_1679));
      let x_1699 = tint_symbol_55((tint_symbol_23_9 + (tint_symbol_28_9 * x_1696)));
      if ((x_1699 > 200.0f)) {
        tint_symbol_104 = x_1696;
        break;
      }

      continuing {
        tint_symbol_92_3 = (tint_symbol_92_3 + 1i);
      }
    }
    if ((tint_symbol_104 < 0.0f)) {
      textureStore(tint_symbol_50, tint_symbol_88_3, x_1469);
      tint_return_flag_5 = true;
    }
    if (!(tint_return_flag_5)) {
      let x_1715 = tint_symbol_104;
      let x_1723 = tint_symbol_80(((x_1715 - x_1664.x) / max((x_1664.y - x_1664.x), 0.00000000999999993923f)));
      textureStore(tint_symbol_50, tint_symbol_88_3, vec4f(x_1723.x, x_1723.y, x_1723.z, 1.0f));
    }
  }
  return;
}

const x_1735 = vec2f(2.0f);

fn tint_symbol_105(tint_symbol_88_4 : vec2i) -> Arr {
  var tint_symbol_107 = vec3f();
  var tint_symbol_108 = vec3f();
  let x_1740 = (x_1735 / tint_symbol_47.inner.tint_symbol_43.xy);
  tint_symbol_107 = vec3f((((f32(tint_symbol_88_4.x) + 0.5f) * x_1740.x) - 1.0f), (((f32(tint_symbol_88_4.y) + 0.5f) * x_1740.y) - 1.0f), 0.0f);
  tint_symbol_108 = vec3f(0.0f, 0.0f, 1.0f);
  let x_1758 = tint_symbol_107;
  let x_1757 = tint_symbol_51(x_1758);
  tint_symbol_107 = x_1757;
  let x_1760 = tint_symbol_108;
  let x_1759 = tint_symbol_53(x_1760);
  tint_symbol_108 = x_1759;
  let x_1761 = tint_symbol_107;
  let x_1762 = tint_symbol_108;
  return Arr(x_1761, x_1762);
}

fn tint_symbol_109(tint_symbol_88_5 : vec2i) -> Arr {
  var tint_symbol_107_1 = vec3f();
  var tint_symbol_108_1 = vec3f();
  let x_1773 = (x_1735 / (tint_symbol_47.inner.tint_symbol_43.xy * tint_symbol_47.inner.tint_symbol_42));
  tint_symbol_107_1 = vec3f();
  tint_symbol_108_1 = normalize(vec3f((((f32(tint_symbol_88_5.x) + 0.5f) * x_1773.x) - (1.0f / tint_symbol_47.inner.tint_symbol_42.x)), (((f32(tint_symbol_88_5.y) + 0.5f) * x_1773.y) - (1.0f / tint_symbol_47.inner.tint_symbol_42.y)), 1.0f));
  let x_1797 = tint_symbol_107_1;
  let x_1796 = tint_symbol_51(x_1797);
  tint_symbol_107_1 = x_1796;
  let x_1799 = tint_symbol_108_1;
  let x_1798 = tint_symbol_53(x_1799);
  tint_symbol_108_1 = x_1798;
  let x_1800 = tint_symbol_107_1;
  let x_1801 = tint_symbol_108_1;
  return Arr(x_1800, x_1801);
}

fn tint_symbol_110_inner(tint_symbol_111 : vec3u) {
  var x_1820 : bool;
  var x_1821 : bool;
  let x_1807 = bitcast<vec2i>(tint_symbol_111.xy);
  let x_1810 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1815 = (x_1807.x < x_1810.x);
  x_1821 = x_1815;
  if (x_1815) {
    x_1820 = (x_1807.y < x_1810.y);
    x_1821 = x_1820;
  }
  if (x_1821) {
    let x_1824 = tint_symbol_105(x_1807);
    tint_symbol_97(x_1807, x_1824[0u], x_1824[1u]);
  }
  return;
}

fn tint_symbol_110_1() {
  let x_1832 = tint_symbol_111_1;
  tint_symbol_110_inner(x_1832);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMIPMain(@builtin(global_invocation_id) tint_symbol_111_1_param : vec3u) {
  tint_symbol_111_1 = tint_symbol_111_1_param;
  tint_symbol_110_1();
}

fn tint_symbol_114_inner(tint_symbol_111_9 : vec3u) {
  var x_1848 : bool;
  var x_1849 : bool;
  let x_1836 = bitcast<vec2i>(tint_symbol_111_9.xy);
  let x_1838 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1843 = (x_1836.x < x_1838.x);
  x_1849 = x_1843;
  if (x_1843) {
    x_1848 = (x_1836.y < x_1838.y);
    x_1849 = x_1848;
  }
  if (x_1849) {
    let x_1852 = tint_symbol_109(x_1836);
    tint_symbol_97(x_1836, x_1852[0u], x_1852[1u]);
  }
  return;
}

fn tint_symbol_114_1() {
  let x_1859 = tint_symbol_111_2;
  tint_symbol_114_inner(x_1859);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMIPMain(@builtin(global_invocation_id) tint_symbol_111_2_param : vec3u) {
  tint_symbol_111_2 = tint_symbol_111_2_param;
  tint_symbol_114_1();
}

fn tint_symbol_115_inner(tint_symbol_111_10 : vec3u) {
  var x_1875 : bool;
  var x_1876 : bool;
  let x_1863 = bitcast<vec2i>(tint_symbol_111_10.xy);
  let x_1865 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1870 = (x_1863.x < x_1865.x);
  x_1876 = x_1870;
  if (x_1870) {
    x_1875 = (x_1863.y < x_1865.y);
    x_1876 = x_1875;
  }
  if (x_1876) {
    let x_1879 = tint_symbol_105(x_1863);
    tint_symbol_98(x_1863, x_1879[0u], x_1879[1u]);
  }
  return;
}

fn tint_symbol_115_1() {
  let x_1886 = tint_symbol_111_3;
  tint_symbol_115_inner(x_1886);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalDRRMain(@builtin(global_invocation_id) tint_symbol_111_3_param : vec3u) {
  tint_symbol_111_3 = tint_symbol_111_3_param;
  tint_symbol_115_1();
}

fn tint_symbol_116_inner(tint_symbol_111_11 : vec3u) {
  var x_1902 : bool;
  var x_1903 : bool;
  let x_1890 = bitcast<vec2i>(tint_symbol_111_11.xy);
  let x_1892 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1897 = (x_1890.x < x_1892.x);
  x_1903 = x_1897;
  if (x_1897) {
    x_1902 = (x_1890.y < x_1892.y);
    x_1903 = x_1902;
  }
  if (x_1903) {
    let x_1906 = tint_symbol_109(x_1890);
    tint_symbol_98(x_1890, x_1906[0u], x_1906[1u]);
  }
  return;
}

fn tint_symbol_116_1() {
  let x_1913 = tint_symbol_111_4;
  tint_symbol_116_inner(x_1913);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveDRRMain(@builtin(global_invocation_id) tint_symbol_111_4_param : vec3u) {
  tint_symbol_111_4 = tint_symbol_111_4_param;
  tint_symbol_116_1();
}

fn tint_symbol_117_inner(tint_symbol_111_12 : vec3u) {
  var x_1929 : bool;
  var x_1930 : bool;
  let x_1917 = bitcast<vec2i>(tint_symbol_111_12.xy);
  let x_1919 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1924 = (x_1917.x < x_1919.x);
  x_1930 = x_1924;
  if (x_1924) {
    x_1929 = (x_1917.y < x_1919.y);
    x_1930 = x_1929;
  }
  if (x_1930) {
    let x_1933 = tint_symbol_105(x_1917);
    tint_symbol_102(x_1917, x_1933[0u], x_1933[1u]);
  }
  return;
}

fn tint_symbol_117_1() {
  let x_1940 = tint_symbol_111_5;
  tint_symbol_117_inner(x_1940);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalDepthMain(@builtin(global_invocation_id) tint_symbol_111_5_param : vec3u) {
  tint_symbol_111_5 = tint_symbol_111_5_param;
  tint_symbol_117_1();
}

fn tint_symbol_118_inner(tint_symbol_111_13 : vec3u) {
  var x_1956 : bool;
  var x_1957 : bool;
  let x_1944 = bitcast<vec2i>(tint_symbol_111_13.xy);
  let x_1946 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1951 = (x_1944.x < x_1946.x);
  x_1957 = x_1951;
  if (x_1951) {
    x_1956 = (x_1944.y < x_1946.y);
    x_1957 = x_1956;
  }
  if (x_1957) {
    let x_1960 = tint_symbol_109(x_1944);
    tint_symbol_102(x_1944, x_1960[0u], x_1960[1u]);
  }
  return;
}

fn tint_symbol_118_1() {
  let x_1967 = tint_symbol_111_6;
  tint_symbol_118_inner(x_1967);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveDepthMain(@builtin(global_invocation_id) tint_symbol_111_6_param : vec3u) {
  tint_symbol_111_6 = tint_symbol_111_6_param;
  tint_symbol_118_1();
}

fn tint_symbol_119_inner(tint_symbol_111_14 : vec3u) {
  var x_1983 : bool;
  var x_1984 : bool;
  let x_1971 = bitcast<vec2i>(tint_symbol_111_14.xy);
  let x_1973 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1978 = (x_1971.x < x_1973.x);
  x_1984 = x_1978;
  if (x_1978) {
    x_1983 = (x_1971.y < x_1973.y);
    x_1984 = x_1983;
  }
  if (x_1984) {
    let x_1987 = tint_symbol_105(x_1971);
    tint_symbol_87(x_1971, x_1987[0u], x_1987[1u]);
  }
  return;
}

fn tint_symbol_119_1() {
  let x_1994 = tint_symbol_111_7;
  tint_symbol_119_inner(x_1994);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalDepthMIPMain(@builtin(global_invocation_id) tint_symbol_111_7_param : vec3u) {
  tint_symbol_111_7 = tint_symbol_111_7_param;
  tint_symbol_119_1();
}

fn tint_symbol_120_inner(tint_symbol_111_15 : vec3u) {
  var x_2010 : bool;
  var x_2011 : bool;
  let x_1998 = bitcast<vec2i>(tint_symbol_111_15.xy);
  let x_2000 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_2005 = (x_1998.x < x_2000.x);
  x_2011 = x_2005;
  if (x_2005) {
    x_2010 = (x_1998.y < x_2000.y);
    x_2011 = x_2010;
  }
  if (x_2011) {
    let x_2014 = tint_symbol_109(x_1998);
    tint_symbol_87(x_1998, x_2014[0u], x_2014[1u]);
  }
  return;
}

fn tint_symbol_120_1() {
  let x_2021 = tint_symbol_111_8;
  tint_symbol_120_inner(x_2021);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveDepthMIPMain(@builtin(global_invocation_id) tint_symbol_111_8_param : vec3u) {
  tint_symbol_111_8 = tint_symbol_111_8_param;
  tint_symbol_120_1();
}
