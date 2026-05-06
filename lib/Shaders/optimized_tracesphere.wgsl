/*
 * Copyright (c) 2026 Sing Chun LEE @ Bucknell University. CC BY-NC 4.0.
 *
 * This code is provided mainly for educational purposes at University of the Pacific.
 *
 * This code is licensed under the Creative Commons Attribution-NonCommercial 4.0
 * International License. To view a copy of the license, visit
 *   https://creativecommons.org/licenses/by-nc/4.0/
 * or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * You are free to:
 *  - Share: copy and redistribute the material in any medium or format.
 *  - Adapt: remix, transform, and build upon the material.
 *
 * Under the following terms:
 *  - Attribution: You must give appropriate credit, provide a link to the license,
 *                 and indicate if changes were made.
 *  - NonCommercial: You may not use the material for commercial purposes.
 *  - No additional restrictions: You may not apply legal terms or technological
 *                                measures that legally restrict others from doing
 *                                anything the license permits.
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

struct tint_symbol_32 {
  /* @offset(0) */
  tint_symbol_33 : tint_symbol,
  /* @offset(64) */
  tint_symbol_34 : vec2f,
  /* @offset(72) */
  tint_symbol_35 : vec2f,
}

struct tint_symbol_40_block {
  /* @offset(0) */
  inner : tint_symbol_32,
}

struct tint_symbol_36 {
  /* @offset(0) */
  tint_symbol_33 : tint_symbol,
  /* @offset(64) */
  tint_symbol_37 : vec4f,
}

struct tint_symbol_41_block {
  /* @offset(0) */
  inner : tint_symbol_36,
}

struct tint_symbol_38 {
  /* @offset(0) */
  tint_symbol_39 : u32,
}

struct tint_symbol_43_block {
  /* @offset(0) */
  inner : tint_symbol_38,
}

struct tint_symbol_74 {
  /* @offset(0) */
  tint_symbol_75 : vec3f,
  /* @offset(12) */
  tint_symbol_76 : f32,
}

var<private> tint_symbol_98_1 : vec3u;

var<private> tint_symbol_98_2 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_40 : tint_symbol_40_block;

@group(0) @binding(1) var<uniform> tint_symbol_41 : tint_symbol_41_block;

@group(0) @binding(2) var tint_symbol_42 : texture_storage_2d<rgba8unorm, write>;

@group(0) @binding(3) var<uniform> tint_symbol_43 : tint_symbol_43_block;

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
  let x_818 = tint_symbol_20;
  return x_818;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_854 = tint_symbol_21(tint_symbol_24);
  let x_855 = tint_symbol_17(tint_symbol_23, x_854);
  let x_856 = tint_symbol_17(tint_symbol_24, x_855);
  return x_856;
}

fn tint_symbol_25(tint_symbol_24_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_24_1.tint_symbol_1, tint_symbol_24_1.tint_symbol_2, tint_symbol_24_1.tint_symbol_3, tint_symbol_24_1.tint_symbol_4, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_26(tint_symbol_23_1 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, -(tint_symbol_23_1.z), tint_symbol_23_1.y, -(tint_symbol_23_1.x), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_27(tint_symbol_23_2 : tint_symbol) -> vec3f {
  return vec3f((-(tint_symbol_23_2.tint_symbol_11) / tint_symbol_23_2.tint_symbol_8), (tint_symbol_23_2.tint_symbol_10 / tint_symbol_23_2.tint_symbol_8), (-(tint_symbol_23_2.tint_symbol_9) / tint_symbol_23_2.tint_symbol_8));
}

fn tint_symbol_28(tint_symbol_23_3 : vec3f, tint_symbol_24_2 : tint_symbol) -> vec3f {
  let x_899 = tint_symbol_26(tint_symbol_23_3);
  let x_900 = tint_symbol_22(x_899, tint_symbol_24_2);
  let x_901 = tint_symbol_27(x_900);
  return x_901;
}

fn tint_symbol_29(tint_symbol_30 : vec3f, tint_symbol_24_3 : tint_symbol) -> vec3f {
  let x_906 = tint_symbol_25(tint_symbol_24_3);
  let x_907 = tint_symbol_26(tint_symbol_30);
  let x_908 = tint_symbol_22(x_907, x_906);
  let x_909 = tint_symbol_27(x_908);
  return x_909;
}

fn tint_symbol_44(tint_symbol_45 : vec3f, tint_symbol_30_1 : vec3f) -> f32 {
  var tint_return_flag = false;
  var tint_return_value = 0.0f;
  let x_923 = tint_symbol_41.inner.tint_symbol_37.xyz;
  let x_924 = (tint_symbol_45 / x_923);
  let x_925 = (tint_symbol_30_1 / x_923);
  let x_926 = dot(x_925, x_925);
  let x_929 = (2.0f * dot(x_924, x_925));
  let x_936 = ((x_929 * x_929) - ((4.0f * x_926) * (dot(x_924, x_924) - 1.0f)));
  if ((x_936 < 0.0f)) {
    tint_return_flag = true;
    tint_return_value = -1.0f;
  }
  if (!(tint_return_flag)) {
    let x_946 = sqrt(x_936);
    let x_951 = ((-(x_929) - x_946) / (2.0f * x_926));
    let x_955 = ((-(x_929) + x_946) / (2.0f * x_926));
    if ((x_951 > 0.00000000999999993923f)) {
      tint_return_flag = true;
      tint_return_value = x_951;
    }
    if (!(tint_return_flag)) {
      if ((x_955 > 0.00000000999999993923f)) {
        tint_return_flag = true;
        tint_return_value = x_955;
      }
      if (!(tint_return_flag)) {
        tint_return_flag = true;
        tint_return_value = -1.0f;
      }
    }
  }
  let x_971 = tint_return_value;
  return x_971;
}

fn tint_symbol_53(tint_symbol_23_4 : vec3f) -> vec3f {
  let x_978 = tint_symbol_41.inner.tint_symbol_37.xyz;
  return normalize((tint_symbol_23_4 / (x_978 * x_978)));
}

fn tint_symbol_54(tint_symbol_45_1 : vec3f, tint_symbol_30_2 : vec3f) -> f32 {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = 0.0f;
  var tint_symbol_56 = 0.0f;
  var tint_symbol_57 = 0.0f;
  let x_990 = tint_symbol_41.inner.tint_symbol_37.xyz;
  tint_symbol_56 = -1000000015047466219876688855040.0f;
  tint_symbol_57 = 1000000015047466219876688855040.0f;
  if ((abs(tint_symbol_30_2.x) > 0.00000000999999993923f)) {
    let x_1006 = ((-(x_990.x) - tint_symbol_45_1.x) / tint_symbol_30_2.x);
    let x_1011 = ((x_990.x - tint_symbol_45_1.x) / tint_symbol_30_2.x);
    tint_symbol_56 = max(tint_symbol_56, min(x_1006, x_1011));
    tint_symbol_57 = min(tint_symbol_57, max(x_1006, x_1011));
  } else {
    if ((abs(tint_symbol_45_1.x) >= x_990.x)) {
      tint_return_flag_1 = true;
      tint_return_value_1 = -1.0f;
    }
  }
  if (!(tint_return_flag_1)) {
    if ((abs(tint_symbol_30_2.y) > 0.00000000999999993923f)) {
      let x_1039 = ((-(x_990.y) - tint_symbol_45_1.y) / tint_symbol_30_2.y);
      let x_1044 = ((x_990.y - tint_symbol_45_1.y) / tint_symbol_30_2.y);
      tint_symbol_56 = max(tint_symbol_56, min(x_1039, x_1044));
      tint_symbol_57 = min(tint_symbol_57, max(x_1039, x_1044));
    } else {
      if ((abs(tint_symbol_45_1.y) >= x_990.y)) {
        tint_return_flag_1 = true;
        tint_return_value_1 = -1.0f;
      }
    }
    if (!(tint_return_flag_1)) {
      if ((abs(tint_symbol_30_2.z) > 0.00000000999999993923f)) {
        let x_1072 = ((-(x_990.z) - tint_symbol_45_1.z) / tint_symbol_30_2.z);
        let x_1077 = ((x_990.z - tint_symbol_45_1.z) / tint_symbol_30_2.z);
        tint_symbol_56 = max(tint_symbol_56, min(x_1072, x_1077));
        tint_symbol_57 = min(tint_symbol_57, max(x_1072, x_1077));
      } else {
        if ((abs(tint_symbol_45_1.z) >= x_990.z)) {
          tint_return_flag_1 = true;
          tint_return_value_1 = -1.0f;
        }
      }
      var x_1100 : bool;
      var x_1101 : bool;
      if (!(tint_return_flag_1)) {
        let x_1096 = (tint_symbol_57 < tint_symbol_56);
        x_1101 = x_1096;
        if (x_1096) {
        } else {
          x_1100 = (tint_symbol_57 < 0.00000000999999993923f);
          x_1101 = x_1100;
        }
        if (x_1101) {
          tint_return_flag_1 = true;
          tint_return_value_1 = -1.0f;
        }
        if (!(tint_return_flag_1)) {
          if ((tint_symbol_56 > 0.00000000999999993923f)) {
            tint_return_flag_1 = true;
            tint_return_value_1 = tint_symbol_56;
          }
          if (!(tint_return_flag_1)) {
            tint_return_flag_1 = true;
            tint_return_value_1 = tint_symbol_57;
          }
        }
      }
    }
  }
  let x_1118 = tint_return_value_1;
  return x_1118;
}

fn tint_symbol_58(tint_symbol_23_5 : vec3f) -> vec3f {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = vec3f();
  var x_1138 : bool;
  var x_1139 : bool;
  let x_1129 = abs((tint_symbol_23_5 / tint_symbol_41.inner.tint_symbol_37.xyz));
  let x_1133 = (x_1129.x >= x_1129.y);
  x_1139 = x_1133;
  if (x_1133) {
    x_1138 = (x_1129.x >= x_1129.z);
    x_1139 = x_1138;
  }
  if (x_1139) {
    tint_return_flag_2 = true;
    tint_return_value_2 = vec3f(sign(tint_symbol_23_5.x), 0.0f, 0.0f);
  }
  if (!(tint_return_flag_2)) {
    if ((x_1129.y >= x_1129.z)) {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(0.0f, sign(tint_symbol_23_5.y), 0.0f);
    }
    if (!(tint_return_flag_2)) {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(0.0f, 0.0f, sign(tint_symbol_23_5.z));
    }
  }
  let x_1164 = tint_return_value_2;
  return x_1164;
}

fn tint_symbol_59(tint_symbol_45_2 : vec3f, tint_symbol_30_3 : vec3f) -> f32 {
  var tint_symbol_61 = 0.0f;
  var x_1181 : f32;
  let x_1171 = tint_symbol_41.inner.tint_symbol_37.x;
  let x_1173 = tint_symbol_41.inner.tint_symbol_37.y;
  tint_symbol_61 = -1.0f;
  x_1181 = ((tint_symbol_30_3.x * tint_symbol_30_3.x) + (tint_symbol_30_3.z * tint_symbol_30_3.z));
  if ((x_1181 > 0.00000000999999993923f)) {
    var x_1192 : f32;
    var x_1205 : f32;
    var x_1226 : bool;
    var x_1227 : bool;
    x_1192 = (2.0f * ((tint_symbol_45_2.x * tint_symbol_30_3.x) + (tint_symbol_45_2.z * tint_symbol_30_3.z)));
    x_1205 = ((x_1192 * x_1192) - ((4.0f * x_1181) * (((tint_symbol_45_2.x * tint_symbol_45_2.x) + (tint_symbol_45_2.z * tint_symbol_45_2.z)) - (x_1171 * x_1171))));
    if ((x_1205 >= 0.0f)) {
      let x_1209 = sqrt(x_1205);
      let x_1213 = ((-(x_1192) - x_1209) / (2.0f * x_1181));
      let x_1217 = ((-(x_1192) + x_1209) / (2.0f * x_1181));
      let x_1218 = (x_1213 > 0.00000000999999993923f);
      x_1227 = x_1218;
      if (x_1218) {
        x_1226 = (abs((tint_symbol_45_2.y + (x_1213 * tint_symbol_30_3.y))) <= x_1173);
        x_1227 = x_1226;
      }
      var x_1239 : bool;
      var x_1240 : bool;
      if (x_1227) {
        tint_symbol_61 = x_1213;
      } else {
        let x_1231 = (x_1217 > 0.00000000999999993923f);
        x_1240 = x_1231;
        if (x_1231) {
          x_1239 = (abs((tint_symbol_45_2.y + (x_1217 * tint_symbol_30_3.y))) <= x_1173);
          x_1240 = x_1239;
        }
        if (x_1240) {
          tint_symbol_61 = x_1217;
        }
      }
    }
  }
  if ((abs(tint_symbol_30_3.y) > 0.00000000999999993923f)) {
    var x_1251 : f32;
    var x_1276 : bool;
    var x_1277 : bool;
    x_1251 = ((x_1173 - tint_symbol_45_2.y) / tint_symbol_30_3.y);
    if ((x_1251 > 0.00000000999999993923f)) {
      var x_1275 : bool;
      let x_1258 = (tint_symbol_45_2.x + (x_1251 * tint_symbol_30_3.x));
      let x_1262 = (tint_symbol_45_2.z + (x_1251 * tint_symbol_30_3.z));
      let x_1267 = (((x_1258 * x_1258) + (x_1262 * x_1262)) <= (x_1171 * x_1171));
      x_1277 = x_1267;
      if (x_1267) {
        let x_1271 = (tint_symbol_61 < 0.0f);
        x_1276 = x_1271;
        if (x_1271) {
        } else {
          x_1275 = (x_1251 < tint_symbol_61);
          x_1276 = x_1275;
        }
        x_1277 = x_1276;
      }
      if (x_1277) {
        tint_symbol_61 = x_1251;
      }
    }
    var x_1284 : f32;
    var x_1309 : bool;
    var x_1310 : bool;
    x_1284 = ((-(x_1173) - tint_symbol_45_2.y) / tint_symbol_30_3.y);
    if ((x_1284 > 0.00000000999999993923f)) {
      var x_1308 : bool;
      let x_1291 = (tint_symbol_45_2.x + (x_1284 * tint_symbol_30_3.x));
      let x_1295 = (tint_symbol_45_2.z + (x_1284 * tint_symbol_30_3.z));
      let x_1300 = (((x_1291 * x_1291) + (x_1295 * x_1295)) <= (x_1171 * x_1171));
      x_1310 = x_1300;
      if (x_1300) {
        let x_1304 = (tint_symbol_61 < 0.0f);
        x_1309 = x_1304;
        if (x_1304) {
        } else {
          x_1308 = (x_1284 < tint_symbol_61);
          x_1309 = x_1308;
        }
        x_1310 = x_1309;
      }
      if (x_1310) {
        tint_symbol_61 = x_1284;
      }
    }
  }
  let x_1313 = tint_symbol_61;
  return x_1313;
}

const x_1328 = vec3f(0.0f, 1.0f, 0.0f);

const x_1339 = vec3f(0.0f, -1.0f, 0.0f);

fn tint_symbol_66(tint_symbol_23_6 : vec3f) -> vec3f {
  var tint_return_flag_3 = false;
  var tint_return_value_3 = vec3f();
  let x_1320 = tint_symbol_41.inner.tint_symbol_37.y;
  if ((abs((tint_symbol_23_6.y - x_1320)) < 0.00999999977648258209f)) {
    tint_return_flag_3 = true;
    tint_return_value_3 = x_1328;
  }
  if (!(tint_return_flag_3)) {
    if ((abs((tint_symbol_23_6.y + x_1320)) < 0.00999999977648258209f)) {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1339;
    }
    if (!(tint_return_flag_3)) {
      tint_return_flag_3 = true;
      tint_return_value_3 = normalize(vec3f(tint_symbol_23_6.x, 0.0f, tint_symbol_23_6.z));
    }
  }
  let x_1348 = tint_return_value_3;
  return x_1348;
}

fn tint_symbol_67(tint_symbol_45_3 : vec3f, tint_symbol_30_4 : vec3f) -> f32 {
  var tint_symbol_61_1 = 0.0f;
  var x_1374 : f32;
  var x_1387 : f32;
  var x_1398 : f32;
  let x_1354 = tint_symbol_41.inner.tint_symbol_37.x;
  let x_1356 = tint_symbol_41.inner.tint_symbol_37.y;
  let x_1358 = (x_1354 / (2.0f * x_1356));
  let x_1360 = (tint_symbol_45_3.y - x_1356);
  tint_symbol_61_1 = -1.0f;
  x_1374 = (((tint_symbol_30_4.x * tint_symbol_30_4.x) + (tint_symbol_30_4.z * tint_symbol_30_4.z)) - (((x_1358 * x_1358) * tint_symbol_30_4.y) * tint_symbol_30_4.y));
  x_1387 = (2.0f * (((tint_symbol_45_3.x * tint_symbol_30_4.x) + (tint_symbol_45_3.z * tint_symbol_30_4.z)) - (((x_1358 * x_1358) * x_1360) * tint_symbol_30_4.y)));
  x_1398 = (((tint_symbol_45_3.x * tint_symbol_45_3.x) + (tint_symbol_45_3.z * tint_symbol_45_3.z)) - (((x_1358 * x_1358) * x_1360) * x_1360));
  if ((abs(x_1374) > 0.00000000999999993923f)) {
    var x_1406 : f32;
    var x_1431 : bool;
    var x_1432 : bool;
    var x_1435 : bool;
    var x_1436 : bool;
    x_1406 = ((x_1387 * x_1387) - ((4.0f * x_1374) * x_1398));
    if ((x_1406 >= 0.0f)) {
      let x_1410 = sqrt(x_1406);
      let x_1414 = ((-(x_1387) - x_1410) / (2.0f * x_1374));
      let x_1418 = ((-(x_1387) + x_1410) / (2.0f * x_1374));
      let x_1422 = (tint_symbol_45_3.y + (x_1414 * tint_symbol_30_4.y));
      let x_1426 = (tint_symbol_45_3.y + (x_1418 * tint_symbol_30_4.y));
      let x_1427 = (x_1414 > 0.00000000999999993923f);
      x_1432 = x_1427;
      if (x_1427) {
        x_1431 = (x_1422 >= -(x_1356));
        x_1432 = x_1431;
      }
      x_1436 = x_1432;
      if (x_1432) {
        x_1435 = (x_1422 <= x_1356);
        x_1436 = x_1435;
      }
      var x_1444 : bool;
      var x_1445 : bool;
      var x_1448 : bool;
      var x_1449 : bool;
      if (x_1436) {
        tint_symbol_61_1 = x_1414;
      } else {
        let x_1440 = (x_1418 > 0.00000000999999993923f);
        x_1445 = x_1440;
        if (x_1440) {
          x_1444 = (x_1426 >= -(x_1356));
          x_1445 = x_1444;
        }
        x_1449 = x_1445;
        if (x_1445) {
          x_1448 = (x_1426 <= x_1356);
          x_1449 = x_1448;
        }
        if (x_1449) {
          tint_symbol_61_1 = x_1418;
        }
      }
    }
  }
  if ((abs(tint_symbol_30_4.y) > 0.00000000999999993923f)) {
    var x_1461 : f32;
    var x_1486 : bool;
    var x_1487 : bool;
    x_1461 = ((-(x_1356) - tint_symbol_45_3.y) / tint_symbol_30_4.y);
    if ((x_1461 > 0.00000000999999993923f)) {
      var x_1485 : bool;
      let x_1468 = (tint_symbol_45_3.x + (x_1461 * tint_symbol_30_4.x));
      let x_1472 = (tint_symbol_45_3.z + (x_1461 * tint_symbol_30_4.z));
      let x_1477 = (((x_1468 * x_1468) + (x_1472 * x_1472)) <= (x_1354 * x_1354));
      x_1487 = x_1477;
      if (x_1477) {
        let x_1481 = (tint_symbol_61_1 < 0.0f);
        x_1486 = x_1481;
        if (x_1481) {
        } else {
          x_1485 = (x_1461 < tint_symbol_61_1);
          x_1486 = x_1485;
        }
        x_1487 = x_1486;
      }
      if (x_1487) {
        tint_symbol_61_1 = x_1461;
      }
    }
  }
  let x_1490 = tint_symbol_61_1;
  return x_1490;
}

fn tint_symbol_73(tint_symbol_23_7 : vec3f) -> vec3f {
  var tint_return_flag_4 = false;
  var tint_return_value_4 = vec3f();
  let x_1497 = tint_symbol_41.inner.tint_symbol_37.y;
  let x_1501 = (tint_symbol_41.inner.tint_symbol_37.x / (2.0f * x_1497));
  if ((abs((tint_symbol_23_7.y + x_1497)) < 0.00999999977648258209f)) {
    tint_return_flag_4 = true;
    tint_return_value_4 = x_1339;
  }
  if (!(tint_return_flag_4)) {
    tint_return_flag_4 = true;
    tint_return_value_4 = normalize(vec3f(tint_symbol_23_7.x, ((-(x_1501) * x_1501) * (tint_symbol_23_7.y - x_1497)), tint_symbol_23_7.z));
  }
  let x_1521 = tint_return_value_4;
  return x_1521;
}

fn tint_symbol_77(tint_symbol_78 : vec3f, tint_symbol_79 : vec3f) -> tint_symbol_74 {
  var tint_symbol_35 = tint_symbol_74(vec3f(), 0.0f);
  var tint_symbol_45_4 = vec3f();
  var tint_symbol_30_5 = vec3f();
  var tint_symbol_76 = 0.0f;
  var tint_symbol_80 = vec3f();
  var x_1556 : u32;
  tint_symbol_35.tint_symbol_75 = x_1328;
  tint_symbol_35.tint_symbol_76 = -1.0f;
  let x_1536 = tint_symbol_40.inner.tint_symbol_33;
  let x_1533 = tint_symbol_28(tint_symbol_78, x_1536);
  tint_symbol_45_4 = x_1533;
  let x_1538 = tint_symbol_45_4;
  let x_1541 = tint_symbol_41.inner.tint_symbol_33;
  let x_1539 = tint_symbol_21(x_1541);
  let x_1542 = tint_symbol_28(x_1538, x_1539);
  tint_symbol_45_4 = x_1542;
  let x_1545 = tint_symbol_40.inner.tint_symbol_33;
  let x_1543 = tint_symbol_29(tint_symbol_79, x_1545);
  tint_symbol_30_5 = x_1543;
  let x_1547 = tint_symbol_30_5;
  let x_1550 = tint_symbol_41.inner.tint_symbol_33;
  let x_1548 = tint_symbol_21(x_1550);
  let x_1551 = tint_symbol_29(x_1547, x_1548);
  tint_symbol_30_5 = x_1551;
  x_1556 = tint_symbol_43.inner.tint_symbol_39;
  if ((x_1556 == 0u)) {
    let x_1563 = tint_symbol_45_4;
    let x_1564 = tint_symbol_30_5;
    let x_1562 = tint_symbol_44(x_1563, x_1564);
    tint_symbol_76 = x_1562;
    if ((tint_symbol_76 > 0.0f)) {
      let x_1570 = tint_symbol_45_4;
      let x_1571 = tint_symbol_76;
      let x_1572 = tint_symbol_30_5;
      let x_1569 = tint_symbol_53((x_1570 + (x_1572 * x_1571)));
      tint_symbol_80 = x_1569;
    }
  } else {
    if ((x_1556 == 1u)) {
      let x_1580 = tint_symbol_45_4;
      let x_1581 = tint_symbol_30_5;
      let x_1579 = tint_symbol_54(x_1580, x_1581);
      tint_symbol_76 = x_1579;
      if ((tint_symbol_76 > 0.0f)) {
        let x_1587 = tint_symbol_45_4;
        let x_1588 = tint_symbol_76;
        let x_1589 = tint_symbol_30_5;
        let x_1586 = tint_symbol_58((x_1587 + (x_1589 * x_1588)));
        tint_symbol_80 = x_1586;
      }
    } else {
      if ((x_1556 == 2u)) {
        let x_1597 = tint_symbol_45_4;
        let x_1598 = tint_symbol_30_5;
        let x_1596 = tint_symbol_59(x_1597, x_1598);
        tint_symbol_76 = x_1596;
        if ((tint_symbol_76 > 0.0f)) {
          let x_1604 = tint_symbol_45_4;
          let x_1605 = tint_symbol_76;
          let x_1606 = tint_symbol_30_5;
          let x_1603 = tint_symbol_66((x_1604 + (x_1606 * x_1605)));
          tint_symbol_80 = x_1603;
        }
      } else {
        let x_1610 = tint_symbol_45_4;
        let x_1611 = tint_symbol_30_5;
        let x_1609 = tint_symbol_67(x_1610, x_1611);
        tint_symbol_76 = x_1609;
        if ((tint_symbol_76 > 0.0f)) {
          let x_1617 = tint_symbol_45_4;
          let x_1618 = tint_symbol_76;
          let x_1619 = tint_symbol_30_5;
          let x_1616 = tint_symbol_73((x_1617 + (x_1619 * x_1618)));
          tint_symbol_80 = x_1616;
        }
      }
    }
  }
  if ((tint_symbol_76 > 0.0f)) {
    let x_1627 = tint_symbol_80;
    let x_1629 = tint_symbol_41.inner.tint_symbol_33;
    let x_1626 = tint_symbol_29(x_1627, x_1629);
    tint_symbol_35.tint_symbol_75 = normalize(x_1626);
    tint_symbol_35.tint_symbol_76 = tint_symbol_76;
  }
  let x_1634 = tint_symbol_35;
  return x_1634;
}

const x_1660 = vec3f(0.28999999165534973145f, 0.0f, 0.50999999046325683594f);

fn tint_symbol_85(tint_symbol_86 : vec2i, tint_symbol_35_1 : tint_symbol_74) {
  var tint_return_flag_5 = false;
  var tint_symbol_96 = vec3f();
  var x_1696 = vec3f();
  var x_1701 = vec3f();
  if ((tint_symbol_35_1.tint_symbol_76 <= 0.0f)) {
    textureStore(tint_symbol_42, tint_symbol_86, vec4f(0.0f, 0.0f, 0.0f, 1.0f));
    tint_return_flag_5 = true;
  }
  if (!(tint_return_flag_5)) {
    let x_1682 = clamp(((0.30000001192092895508f * clamp((tint_symbol_35_1.tint_symbol_76 / 10.0f), 0.0f, 1.0f)) + (0.69999998807907104492f * (1.0f - clamp(((0.5f * (0.5f + (0.5f * tint_symbol_35_1.tint_symbol_75.y))) + (0.5f * max(0.0f, dot(tint_symbol_35_1.tint_symbol_75, vec3f(0.4082482755184173584f, 0.8164965510368347168f, 0.4082482755184173584f))))), 0.0f, 1.0f)))), 0.0f, 1.0f);
    if ((x_1682 < 0.5f)) {
      tint_symbol_96 = mix(vec3f(0.87000000476837158203f, 0.73000001907348632812f, 1.0f), x_1660, vec3f((x_1682 / 0.5f)));
    } else {
      tint_symbol_96 = mix(x_1660, vec3f(0.0f, 0.0f, 0.34999999403953552246f), vec3f(((x_1682 - 0.5f) / 0.5f)));
    }
    let x_1705 = tint_symbol_96;
    textureStore(tint_symbol_42, tint_symbol_86, vec4f(x_1705.x, x_1705.y, x_1705.z, 1.0f));
  }
  return;
}

const x_1731 = vec2f(2.0f);

fn tint_symbol_97_inner(tint_symbol_98 : vec3u) {
  var x_1727 : bool;
  var x_1728 : bool;
  let x_1714 = bitcast<vec2i>(tint_symbol_98.xy);
  let x_1717 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_42)));
  let x_1722 = (x_1714.x < x_1717.x);
  x_1728 = x_1722;
  if (x_1722) {
    x_1727 = (x_1714.y < x_1717.y);
    x_1728 = x_1727;
  }
  if (x_1728) {
    let x_1736 = (x_1731 / tint_symbol_40.inner.tint_symbol_35.xy);
    let x_1750 = tint_symbol_77(vec3f((((f32(x_1714.x) + 0.5f) * x_1736.x) - 1.0f), (((f32(x_1714.y) + 0.5f) * x_1736.y) - 1.0f), 0.0f), vec3f(0.0f, 0.0f, 1.0f));
    tint_symbol_85(x_1714, x_1750);
  }
  return;
}

fn tint_symbol_97_1() {
  let x_1757 = tint_symbol_98_1;
  tint_symbol_97_inner(x_1757);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMain(@builtin(global_invocation_id) tint_symbol_98_1_param : vec3u) {
  tint_symbol_98_1 = tint_symbol_98_1_param;
  tint_symbol_97_1();
}

fn tint_symbol_102_inner(tint_symbol_98_3 : vec3u) {
  var x_1773 : bool;
  var x_1774 : bool;
  let x_1761 = bitcast<vec2i>(tint_symbol_98_3.xy);
  let x_1763 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_42)));
  let x_1768 = (x_1761.x < x_1763.x);
  x_1774 = x_1768;
  if (x_1768) {
    x_1773 = (x_1761.y < x_1763.y);
    x_1774 = x_1773;
  }
  if (x_1774) {
    let x_1783 = (x_1731 / (tint_symbol_40.inner.tint_symbol_35.xy * tint_symbol_40.inner.tint_symbol_34));
    let x_1791 = tint_symbol_40.inner.tint_symbol_34.x;
    let x_1800 = tint_symbol_40.inner.tint_symbol_34.y;
    let x_1804 = tint_symbol_77(vec3f(), normalize(vec3f((((f32(x_1761.x) + 0.5f) * x_1783.x) - (1.0f / x_1791)), (((f32(x_1761.y) + 0.5f) * x_1783.y) - (1.0f / x_1800)), 1.0f)));
    tint_symbol_85(x_1761, x_1804);
  }
  return;
}

fn tint_symbol_102_1() {
  let x_1809 = tint_symbol_98_2;
  tint_symbol_102_inner(x_1809);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMain(@builtin(global_invocation_id) tint_symbol_98_2_param : vec3u) {
  tint_symbol_98_2 = tint_symbol_98_2_param;
  tint_symbol_102_1();
}
