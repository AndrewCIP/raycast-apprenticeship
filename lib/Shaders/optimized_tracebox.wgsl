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

struct tint_symbol_63 {
  /* @offset(0) */
  tint_symbol_64 : tint_symbol,
  /* @offset(64) */
  tint_symbol_65 : vec2f,
  /* @offset(72) */
  tint_symbol_66 : vec2f,
}

struct tint_symbol_75_block {
  /* @offset(0) */
  inner : tint_symbol_63,
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
}

alias Arr = array<tint_symbol_67, 6u>;

struct tint_symbol_72 {
  /* @offset(0) */
  tint_symbol_64 : tint_symbol,
  /* @offset(64) */
  tint_symbol_73 : vec4f,
  /* @offset(80) */
  tint_symbol_74 : Arr,
}

struct tint_symbol_76_block {
  /* @offset(0) */
  inner : tint_symbol_72,
}

struct tint_symbol_52 {
  /* @offset(0) */
  tint_symbol_23 : vec3f,
  /* @offset(12) */
  tint_symbol_53 : bool,
  /* @offset(16) */
  tint_symbol_54 : bool,
}

struct tint_symbol_98 {
  /* @offset(0) */
  tint_symbol_97 : f32,
  /* @offset(16) */
  tint_symbol_99 : vec3f,
  /* @offset(28) */
  tint_symbol_100 : bool,
  /* @offset(32) */
  tint_symbol_53 : bool,
}

var<private> tint_symbol_121_1 : vec3u;

var<private> tint_symbol_121_2 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_75 : tint_symbol_75_block;

@group(0) @binding(1) var<uniform> tint_symbol_76 : tint_symbol_76_block;

@group(0) @binding(2) var tint_symbol_77 : texture_storage_2d<rgba8unorm, write>;

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
  let x_831 = tint_symbol_20;
  return x_831;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_867 = tint_symbol_21(tint_symbol_24);
  let x_868 = tint_symbol_17(tint_symbol_23, x_867);
  let x_869 = tint_symbol_17(tint_symbol_24, x_868);
  return x_869;
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
  let x_958 = tint_symbol_26;
  return sqrt(x_958);
}

fn tint_symbol_27(tint_symbol_28 : vec3f) -> tint_symbol {
  return tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, (-(tint_symbol_28.x) / 2.0f), (-(tint_symbol_28.y) / 2.0f), (-(tint_symbol_28.z) / 2.0f), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_29(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  return tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, tint_symbol_24_2.tint_symbol_5, tint_symbol_24_2.tint_symbol_6, tint_symbol_24_2.tint_symbol_7, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_30(tint_symbol_28_1 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_28_1.z, -(tint_symbol_28_1.y), tint_symbol_28_1.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_34(tint_symbol_24_3 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_998 = tint_symbol_25(tint_symbol_24_3);
  if ((x_998 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_3.tint_symbol_1 / x_998), (tint_symbol_24_3.tint_symbol_2 / x_998), (tint_symbol_24_3.tint_symbol_3 / x_998), (tint_symbol_24_3.tint_symbol_4 / x_998), (tint_symbol_24_3.tint_symbol_5 / x_998), (tint_symbol_24_3.tint_symbol_6 / x_998), (tint_symbol_24_3.tint_symbol_7 / x_998), (tint_symbol_24_3.tint_symbol_8 / x_998), (tint_symbol_24_3.tint_symbol_9 / x_998), (tint_symbol_24_3.tint_symbol_10 / x_998), (tint_symbol_24_3.tint_symbol_11 / x_998), (tint_symbol_24_3.tint_symbol_12 / x_998), (tint_symbol_24_3.tint_symbol_13 / x_998), (tint_symbol_24_3.tint_symbol_14 / x_998), (tint_symbol_24_3.tint_symbol_15 / x_998), (tint_symbol_24_3.tint_symbol_16 / x_998));
  }
  let x_1041 = tint_return_value;
  return x_1041;
}

fn tint_symbol_31(tint_symbol_1 : vec3f, tint_symbol_28_2 : vec3f) -> tint_symbol {
  let x_1047 = tint_symbol_30(tint_symbol_28_2);
  let x_1048 = tint_symbol_34(x_1047);
  return tint_symbol(0.0f, x_1048.tint_symbol_2, x_1048.tint_symbol_3, x_1048.tint_symbol_4, -(((-(x_1048.tint_symbol_3) * tint_symbol_1.z) - (x_1048.tint_symbol_2 * tint_symbol_1.y))), -(((x_1048.tint_symbol_2 * tint_symbol_1.x) - (x_1048.tint_symbol_4 * tint_symbol_1.z))), -(((x_1048.tint_symbol_4 * tint_symbol_1.y) + (x_1048.tint_symbol_3 * tint_symbol_1.x))), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_35(tint_symbol_36 : f32, tint_symbol_28_3 : vec3f, tint_symbol_37 : vec3f) -> tint_symbol {
  let x_1086 = sin((tint_symbol_36 / 2.0f));
  let x_1088 = tint_symbol_31(tint_symbol_37, tint_symbol_28_3);
  return tint_symbol(cos((tint_symbol_36 / 2.0f)), (x_1086 * x_1088.tint_symbol_2), (x_1086 * x_1088.tint_symbol_3), (x_1086 * x_1088.tint_symbol_4), (x_1086 * x_1088.tint_symbol_5), (x_1086 * x_1088.tint_symbol_6), (x_1086 * x_1088.tint_symbol_7), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_40(tint_symbol_24_4 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_24_4.tint_symbol_1, tint_symbol_24_4.tint_symbol_2, tint_symbol_24_4.tint_symbol_3, tint_symbol_24_4.tint_symbol_4, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_41(tint_symbol_23_1 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, -(tint_symbol_23_1.z), tint_symbol_23_1.y, -(tint_symbol_23_1.x), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_42(tint_symbol_23_2 : tint_symbol) -> vec3f {
  return vec3f((-(tint_symbol_23_2.tint_symbol_11) / tint_symbol_23_2.tint_symbol_8), (tint_symbol_23_2.tint_symbol_10 / tint_symbol_23_2.tint_symbol_8), (-(tint_symbol_23_2.tint_symbol_9) / tint_symbol_23_2.tint_symbol_8));
}

fn tint_symbol_43(tint_symbol_32 : vec3f, tint_symbol_28_4 : f32) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, tint_symbol_32.x, tint_symbol_32.y, tint_symbol_32.z, -(tint_symbol_28_4), 0.0f);
}

fn tint_symbol_44(tint_symbol_45 : vec3f, tint_symbol_46 : vec3f, tint_symbol_47 : vec3f) -> tint_symbol {
  let x_1252 = tint_symbol_43(vec3f(((((tint_symbol_46.y * tint_symbol_47.z) - (tint_symbol_47.y * tint_symbol_46.z)) - ((tint_symbol_45.y * tint_symbol_47.z) - (tint_symbol_47.y * tint_symbol_45.z))) + ((tint_symbol_45.y * tint_symbol_46.z) - (tint_symbol_46.y * tint_symbol_45.z))), -(((((tint_symbol_46.x * tint_symbol_47.z) - (tint_symbol_47.x * tint_symbol_46.z)) - ((tint_symbol_45.x * tint_symbol_47.z) - (tint_symbol_47.x * tint_symbol_45.z))) + ((tint_symbol_45.x * tint_symbol_46.z) - (tint_symbol_46.x * tint_symbol_45.z)))), ((((tint_symbol_46.x * tint_symbol_47.y) - (tint_symbol_47.x * tint_symbol_46.y)) - ((tint_symbol_45.x * tint_symbol_47.y) - (tint_symbol_47.x * tint_symbol_45.y))) + ((tint_symbol_45.x * tint_symbol_46.y) - (tint_symbol_46.x * tint_symbol_45.y)))), (((tint_symbol_45.x * ((tint_symbol_46.y * tint_symbol_47.z) - (tint_symbol_47.y * tint_symbol_46.z))) - (tint_symbol_46.x * ((tint_symbol_45.y * tint_symbol_47.z) - (tint_symbol_47.y * tint_symbol_45.z)))) + (tint_symbol_47.x * ((tint_symbol_45.y * tint_symbol_46.z) - (tint_symbol_46.y * tint_symbol_45.z)))));
  return x_1252;
}

fn tint_symbol_55(tint_symbol_39 : tint_symbol, tint_symbol_56 : tint_symbol) -> tint_symbol_52 {
  var tint_symbol_58 = tint_symbol_52(vec3f(), false, false);
  var x_1281 : bool;
  var x_1282 : bool;
  var x_1287 : bool;
  var x_1288 : bool;
  var x_1293 : bool;
  var x_1294 : bool;
  let x_1261 = tint_symbol_17(tint_symbol_39, tint_symbol_56);
  let x_1267 = tint_symbol_42(x_1261);
  tint_symbol_58.tint_symbol_23 = x_1267;
  tint_symbol_58.tint_symbol_53 = !((abs(x_1261.tint_symbol_8) <= 0.00000000999999993923f));
  let x_1276 = tint_symbol_58.tint_symbol_53;
  x_1282 = x_1276;
  if (x_1276) {
    x_1281 = (abs(x_1261.tint_symbol_9) <= 0.00000000999999993923f);
    x_1282 = x_1281;
  }
  x_1288 = x_1282;
  if (x_1282) {
    x_1287 = (abs(x_1261.tint_symbol_10) <= 0.00000000999999993923f);
    x_1288 = x_1287;
  }
  x_1294 = x_1288;
  if (x_1288) {
    x_1293 = (abs(x_1261.tint_symbol_11) <= 0.00000000999999993923f);
    x_1294 = x_1293;
  }
  tint_symbol_58.tint_symbol_54 = x_1294;
  let x_1295 = tint_symbol_58;
  return x_1295;
}

fn tint_symbol_60(tint_symbol_23_3 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1301 = tint_symbol_41(tint_symbol_23_3);
  let x_1302 = tint_symbol_22(x_1301, tint_symbol_24_5);
  let x_1303 = tint_symbol_42(x_1302);
  return x_1303;
}

fn tint_symbol_61(tint_symbol_28_5 : vec3f, tint_symbol_24_6 : tint_symbol) -> vec3f {
  let x_1308 = tint_symbol_40(tint_symbol_24_6);
  let x_1309 = tint_symbol_41(tint_symbol_28_5);
  let x_1310 = tint_symbol_22(x_1309, x_1308);
  let x_1311 = tint_symbol_42(x_1310);
  return x_1311;
}

fn tint_symbol_78(tint_symbol_1_1 : vec3f, tint_symbol_28_6 : vec3f, tint_symbol_79 : tint_symbol_67, tint_symbol_80 : f32) -> vec2f {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = vec2f();
  var tint_symbol_58_1 = tint_symbol_52(vec3f(), false, false);
  var tint_symbol_81 = 0.0f;
  let x_1323 = tint_symbol_31(tint_symbol_1_1, tint_symbol_28_6);
  let x_1325 = tint_symbol_79.tint_symbol_68;
  let x_1327 = tint_symbol_79.tint_symbol_69;
  let x_1329 = tint_symbol_79.tint_symbol_70;
  let x_1324 = tint_symbol_44(x_1325.xyz, x_1327.xyz, x_1329.xyz);
  let x_1331 = tint_symbol_55(x_1323, x_1324);
  tint_symbol_58_1 = x_1331;
  if (tint_symbol_58_1.tint_symbol_53) {
    var x_1359 : bool;
    var x_1360 : bool;
    var x_1375 : bool;
    var x_1376 : bool;
    if ((abs((tint_symbol_79.tint_symbol_68.z - tint_symbol_79.tint_symbol_70.z)) <= 0.00000000999999993923f)) {
      let x_1352 = (tint_symbol_79.tint_symbol_68.x <= tint_symbol_58_1.tint_symbol_23.x);
      x_1360 = x_1352;
      if (x_1352) {
        x_1359 = (tint_symbol_58_1.tint_symbol_23.x <= tint_symbol_79.tint_symbol_70.x);
        x_1360 = x_1359;
      }
      var x_1374 : bool;
      x_1376 = x_1360;
      if (x_1360) {
        let x_1367 = (tint_symbol_79.tint_symbol_68.y <= tint_symbol_58_1.tint_symbol_23.y);
        x_1375 = x_1367;
        if (x_1367) {
          x_1374 = (tint_symbol_58_1.tint_symbol_23.y <= tint_symbol_79.tint_symbol_70.y);
          x_1375 = x_1374;
        }
        x_1376 = x_1375;
      }
      tint_symbol_58_1.tint_symbol_53 = x_1376;
    } else {
      var x_1399 : bool;
      var x_1400 : bool;
      var x_1415 : bool;
      var x_1416 : bool;
      if ((abs((tint_symbol_79.tint_symbol_68.y - tint_symbol_79.tint_symbol_70.y)) <= 0.00000000999999993923f)) {
        let x_1392 = (tint_symbol_79.tint_symbol_68.x <= tint_symbol_58_1.tint_symbol_23.x);
        x_1400 = x_1392;
        if (x_1392) {
          x_1399 = (tint_symbol_58_1.tint_symbol_23.x <= tint_symbol_79.tint_symbol_70.x);
          x_1400 = x_1399;
        }
        var x_1414 : bool;
        x_1416 = x_1400;
        if (x_1400) {
          let x_1407 = (tint_symbol_79.tint_symbol_68.z <= tint_symbol_58_1.tint_symbol_23.z);
          x_1415 = x_1407;
          if (x_1407) {
            x_1414 = (tint_symbol_58_1.tint_symbol_23.z <= tint_symbol_79.tint_symbol_70.z);
            x_1415 = x_1414;
          }
          x_1416 = x_1415;
        }
        tint_symbol_58_1.tint_symbol_53 = x_1416;
      } else {
        var x_1438 : bool;
        var x_1439 : bool;
        var x_1454 : bool;
        var x_1455 : bool;
        if ((abs((tint_symbol_79.tint_symbol_68.x - tint_symbol_79.tint_symbol_70.x)) <= 0.00000000999999993923f)) {
          let x_1431 = (tint_symbol_79.tint_symbol_68.y <= tint_symbol_58_1.tint_symbol_23.y);
          x_1439 = x_1431;
          if (x_1431) {
            x_1438 = (tint_symbol_58_1.tint_symbol_23.y <= tint_symbol_79.tint_symbol_70.y);
            x_1439 = x_1438;
          }
          var x_1453 : bool;
          x_1455 = x_1439;
          if (x_1439) {
            let x_1446 = (tint_symbol_79.tint_symbol_68.z <= tint_symbol_58_1.tint_symbol_23.z);
            x_1454 = x_1446;
            if (x_1446) {
              x_1453 = (tint_symbol_58_1.tint_symbol_23.z <= tint_symbol_79.tint_symbol_70.z);
              x_1454 = x_1453;
            }
            x_1455 = x_1454;
          }
          tint_symbol_58_1.tint_symbol_53 = x_1455;
        }
      }
    }
    if (tint_symbol_58_1.tint_symbol_53) {
      tint_symbol_81 = -1.0f;
      if ((tint_symbol_28_6.x > 0.00000000999999993923f)) {
        tint_symbol_81 = ((tint_symbol_58_1.tint_symbol_23.x - tint_symbol_1_1.x) / tint_symbol_28_6.x);
      } else {
        if ((tint_symbol_28_6.y > 0.00000000999999993923f)) {
          tint_symbol_81 = ((tint_symbol_58_1.tint_symbol_23.y - tint_symbol_1_1.y) / tint_symbol_28_6.y);
        } else {
          tint_symbol_81 = ((tint_symbol_58_1.tint_symbol_23.z - tint_symbol_1_1.z) / tint_symbol_28_6.z);
        }
      }
      if ((tint_symbol_81 < 0.0f)) {
        tint_return_flag_1 = true;
        tint_return_value_1 = vec2f(tint_symbol_80, -1.0f);
      } else {
        if ((tint_symbol_80 < 0.0f)) {
          tint_return_flag_1 = true;
          tint_return_value_1 = vec2f(tint_symbol_81, 1.0f);
        } else {
          if ((tint_symbol_81 < tint_symbol_80)) {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_81, 1.0f);
          } else {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_80, -1.0f);
          }
        }
      }
    }
  }
  if (!(tint_return_flag_1)) {
    tint_return_flag_1 = true;
    tint_return_value_1 = vec2f(tint_symbol_80, -1.0f);
  }
  let x_1515 = tint_return_value_1;
  return x_1515;
}

fn tint_symbol_82(tint_symbol_28_7 : vec3f) -> vec3f {
  var tint_symbol_83 = vec3f();
  let x_1523 = tint_symbol_75.inner.tint_symbol_64;
  let x_1520 = tint_symbol_61(tint_symbol_28_7, x_1523);
  tint_symbol_83 = x_1520;
  let x_1526 = tint_symbol_83;
  let x_1529 = tint_symbol_76.inner.tint_symbol_64;
  let x_1527 = tint_symbol_21(x_1529);
  let x_1530 = tint_symbol_61(x_1526, x_1527);
  tint_symbol_83 = x_1530;
  tint_symbol_83 = (tint_symbol_83 / tint_symbol_76.inner.tint_symbol_73.xyz);
  let x_1537 = tint_symbol_83;
  return x_1537;
}

fn tint_symbol_84(tint_symbol_85 : vec3f) -> vec3f {
  var tint_symbol_83_1 = vec3f();
  let x_1543 = tint_symbol_75.inner.tint_symbol_64;
  let x_1541 = tint_symbol_60(tint_symbol_85, x_1543);
  tint_symbol_83_1 = x_1541;
  let x_1545 = tint_symbol_83_1;
  let x_1548 = tint_symbol_76.inner.tint_symbol_64;
  let x_1546 = tint_symbol_21(x_1548);
  let x_1549 = tint_symbol_60(x_1545, x_1546);
  tint_symbol_83_1 = x_1549;
  tint_symbol_83_1 = (tint_symbol_83_1 / tint_symbol_76.inner.tint_symbol_73.xyz);
  let x_1555 = tint_symbol_83_1;
  return x_1555;
}

fn tint_symbol_86(tint_symbol_87 : vec3f, tint_symbol_33 : vec3f, tint_symbol_88 : vec3f, tint_symbol_89 : vec3f, tint_symbol_90 : vec3f) -> f32 {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = 0.0f;
  let x_1566 = (tint_symbol_89 - tint_symbol_88);
  let x_1567 = (tint_symbol_90 - tint_symbol_88);
  let x_1568 = cross(tint_symbol_33, x_1567);
  let x_1569 = dot(x_1566, x_1568);
  if ((abs(x_1569) < 0.00000000999999993923f)) {
    tint_return_flag_2 = true;
    tint_return_value_2 = 10000000000.0f;
  }
  var x_1586 : bool;
  var x_1587 : bool;
  if (!(tint_return_flag_2)) {
    let x_1579 = (1.0f / x_1569);
    let x_1580 = (tint_symbol_87 - tint_symbol_88);
    let x_1582 = (x_1579 * dot(x_1580, x_1568));
    let x_1583 = (x_1582 < 0.0f);
    x_1587 = x_1583;
    if (x_1583) {
    } else {
      x_1586 = (x_1582 > 1.0f);
      x_1587 = x_1586;
    }
    if (x_1587) {
      tint_return_flag_2 = true;
      tint_return_value_2 = 10000000000.0f;
    }
    var x_1601 : bool;
    var x_1602 : bool;
    if (!(tint_return_flag_2)) {
      let x_1594 = cross(x_1580, x_1566);
      let x_1596 = (x_1579 * dot(tint_symbol_33, x_1594));
      let x_1597 = (x_1596 < 0.0f);
      x_1602 = x_1597;
      if (x_1597) {
      } else {
        x_1601 = ((x_1582 + x_1596) > 1.0f);
        x_1602 = x_1601;
      }
      if (x_1602) {
        tint_return_flag_2 = true;
        tint_return_value_2 = 10000000000.0f;
      }
      if (!(tint_return_flag_2)) {
        let x_1610 = (x_1579 * dot(x_1567, x_1594));
        if ((x_1610 < 0.00000000999999993923f)) {
          tint_return_flag_2 = true;
          tint_return_value_2 = 10000000000.0f;
        }
        if (!(tint_return_flag_2)) {
          tint_return_flag_2 = true;
          tint_return_value_2 = x_1610;
        }
      }
    }
  }
  let x_1618 = tint_return_value_2;
  return x_1618;
}

const x_1626 = vec3f(0.0f, 0.40000000596046447754f, 0.0f);

const x_1629 = vec3f(0.34999999403953552246f, -0.34999999403953552246f, 0.34999999403953552246f);

const x_1630 = vec3f(-0.34999999403953552246f, -0.34999999403953552246f, 0.34999999403953552246f);

const x_1631 = vec3f(-0.34999999403953552246f);

const x_1632 = vec3f(0.34999999403953552246f, -0.34999999403953552246f, -0.34999999403953552246f);

const x_1762 = vec3f(0.0f, -1.0f, 0.0f);

fn tint_symbol_101(tint_symbol_87_1 : vec3f, tint_symbol_33_1 : vec3f) -> tint_symbol_98 {
  var tint_symbol_107 = tint_symbol_98(0.0f, vec3f(), false, false);
  var tint_symbol_108 = 0.0f;
  var tint_symbol_32_1 = vec3f();
  var x_1668 = vec3<bool>();
  var x_1696 = vec3<bool>();
  var x_1722 = vec3<bool>();
  var x_1748 = vec3<bool>();
  tint_symbol_107.tint_symbol_53 = false;
  tint_symbol_107.tint_symbol_97 = 10000000000.0f;
  tint_symbol_107.tint_symbol_100 = false;
  tint_symbol_107.tint_symbol_99 = vec3f(0.0f, 1.0f, 0.0f);
  let x_1643 = tint_symbol_86(tint_symbol_87_1, tint_symbol_33_1, x_1626, x_1629, x_1630);
  tint_symbol_108 = x_1643;
  if ((tint_symbol_108 < tint_symbol_107.tint_symbol_97)) {
    tint_symbol_32_1 = normalize(cross((x_1629 - x_1626), (x_1630 - x_1626)));
    tint_symbol_107.tint_symbol_97 = tint_symbol_108;
    tint_symbol_107.tint_symbol_53 = true;
    tint_symbol_107.tint_symbol_100 = false;
    tint_symbol_107.tint_symbol_99 = select(-(tint_symbol_32_1), tint_symbol_32_1, vec3<bool>((dot(tint_symbol_32_1, -(tint_symbol_33_1)) >= 0.0f)));
  }
  let x_1672 = tint_symbol_86(tint_symbol_87_1, tint_symbol_33_1, x_1626, x_1630, x_1631);
  tint_symbol_108 = x_1672;
  if ((tint_symbol_108 < tint_symbol_107.tint_symbol_97)) {
    tint_symbol_32_1 = normalize(cross((x_1630 - x_1626), (x_1631 - x_1626)));
    tint_symbol_107.tint_symbol_97 = tint_symbol_108;
    tint_symbol_107.tint_symbol_53 = true;
    tint_symbol_107.tint_symbol_100 = false;
    tint_symbol_107.tint_symbol_99 = select(-(tint_symbol_32_1), tint_symbol_32_1, vec3<bool>((dot(tint_symbol_32_1, -(tint_symbol_33_1)) >= 0.0f)));
  }
  let x_1698 = tint_symbol_86(tint_symbol_87_1, tint_symbol_33_1, x_1626, x_1631, x_1632);
  tint_symbol_108 = x_1698;
  if ((tint_symbol_108 < tint_symbol_107.tint_symbol_97)) {
    tint_symbol_32_1 = normalize(cross((x_1631 - x_1626), (x_1632 - x_1626)));
    tint_symbol_107.tint_symbol_97 = tint_symbol_108;
    tint_symbol_107.tint_symbol_53 = true;
    tint_symbol_107.tint_symbol_100 = false;
    tint_symbol_107.tint_symbol_99 = select(-(tint_symbol_32_1), tint_symbol_32_1, vec3<bool>((dot(tint_symbol_32_1, -(tint_symbol_33_1)) >= 0.0f)));
  }
  let x_1724 = tint_symbol_86(tint_symbol_87_1, tint_symbol_33_1, x_1626, x_1632, x_1629);
  tint_symbol_108 = x_1724;
  if ((tint_symbol_108 < tint_symbol_107.tint_symbol_97)) {
    tint_symbol_32_1 = normalize(cross((x_1632 - x_1626), (x_1629 - x_1626)));
    tint_symbol_107.tint_symbol_97 = tint_symbol_108;
    tint_symbol_107.tint_symbol_53 = true;
    tint_symbol_107.tint_symbol_100 = false;
    tint_symbol_107.tint_symbol_99 = select(-(tint_symbol_32_1), tint_symbol_32_1, vec3<bool>((dot(tint_symbol_32_1, -(tint_symbol_33_1)) >= 0.0f)));
  }
  let x_1750 = tint_symbol_86(tint_symbol_87_1, tint_symbol_33_1, x_1629, x_1630, x_1631);
  tint_symbol_108 = x_1750;
  if ((tint_symbol_108 < tint_symbol_107.tint_symbol_97)) {
    tint_symbol_107.tint_symbol_97 = tint_symbol_108;
    tint_symbol_107.tint_symbol_53 = true;
    tint_symbol_107.tint_symbol_100 = true;
    tint_symbol_107.tint_symbol_99 = x_1762;
  }
  let x_1763 = tint_symbol_86(tint_symbol_87_1, tint_symbol_33_1, x_1629, x_1631, x_1632);
  tint_symbol_108 = x_1763;
  if ((tint_symbol_108 < tint_symbol_107.tint_symbol_97)) {
    tint_symbol_107.tint_symbol_97 = tint_symbol_108;
    tint_symbol_107.tint_symbol_53 = true;
    tint_symbol_107.tint_symbol_100 = true;
    tint_symbol_107.tint_symbol_99 = x_1762;
  }
  if ((tint_symbol_107.tint_symbol_97 >= 1000000000.0f)) {
    tint_symbol_107.tint_symbol_53 = false;
  }
  let x_1782 = tint_symbol_107;
  return x_1782;
}

fn tint_symbol_109(tint_symbol_1_2 : vec3f, tint_symbol_28_8 : vec3f) -> vec2f {
  var tint_symbol_97 = 0.0f;
  var tint_symbol_110 = 0.0f;
  var tint_symbol_111 = 0i;
  tint_symbol_97 = -1.0f;
  tint_symbol_110 = -1.0f;
  tint_symbol_111 = 0i;
  loop {
    if (!((tint_symbol_111 < 6i))) {
      break;
    }
    let x_1806 = tint_symbol_76.inner.tint_symbol_74[tint_symbol_111];
    let x_1807 = tint_symbol_97;
    let x_1802 = tint_symbol_78(tint_symbol_1_2, tint_symbol_28_8, x_1806, x_1807);
    if ((x_1802.y > 0.0f)) {
      tint_symbol_97 = x_1802.x;
      tint_symbol_110 = f32(tint_symbol_111);
    }

    continuing {
      tint_symbol_111 = (tint_symbol_111 + 1i);
    }
  }
  let x_1817 = tint_symbol_97;
  let x_1818 = tint_symbol_110;
  return vec2f(x_1817, x_1818);
}

fn tint_symbol_113(tint_symbol_114 : vec2i, tint_symbol_97_1 : f32, tint_symbol_110_1 : i32) {
  var tint_symbol_115 = vec4f();
  if ((tint_symbol_97_1 > 0.0f)) {
    switch(tint_symbol_110_1) {
      case 5i: {
        tint_symbol_115 = vec4f(0.65490198135375976562f, 0.65882354974746704102f, 0.6666666865348815918f, 1.0f);
      }
      case 4i: {
        tint_symbol_115 = vec4f(0.85098040103912353516f, 0.85098040103912353516f, 0.83921569585800170898f, 1.0f);
      }
      case 3i: {
        tint_symbol_115 = vec4f(0.34901961684226989746f, 0.79607844352722167969f, 0.90980392694473266602f, 1.0f);
      }
      case 2i: {
        tint_symbol_115 = vec4f(0.0f, 0.50980395078659057617f, 0.72941178083419799805f, 1.0f);
      }
      case 1i: {
        tint_symbol_115 = vec4f(1.0f, 0.63921570777893066406f, 0.0f, 1.0f);
      }
      case 0i: {
        tint_symbol_115 = vec4f(0.90980392694473266602f, 0.46666666865348815918f, 0.13333334028720855713f, 1.0f);
      }
      default: {
        tint_symbol_115 = vec4f(0.0f, 0.0f, 0.0f, 1.0f);
      }
    }
  } else {
    tint_symbol_115 = vec4f(0.0f, 0.21960784494876861572f, 0.39607843756675720215f, 1.0f);
  }
  let x_1868 = tint_symbol_115;
  textureStore(tint_symbol_77, tint_symbol_114, x_1868);
  return;
}

fn tint_symbol_116(tint_symbol_114_1 : vec2i, tint_symbol_117 : tint_symbol_98) {
  var tint_symbol_115_1 = vec4f();
  if (tint_symbol_117.tint_symbol_100) {
    tint_symbol_115_1 = vec4f(0.60000002384185791016f, 0.40000000596046447754f, 0.10000000149011611938f, 1.0f);
  } else {
    let x_1895 = (vec3f(1.0f, 0.75f, 0.20000000298023223877f) * (0.30000001192092895508f + (0.69999998807907104492f * max(0.0f, dot(tint_symbol_117.tint_symbol_99, vec3f(0.4082482755184173584f, 0.8164965510368347168f, 0.4082482755184173584f))))));
    tint_symbol_115_1 = vec4f(x_1895.x, x_1895.y, x_1895.z, 1.0f);
  }
  let x_1902 = tint_symbol_115_1;
  textureStore(tint_symbol_77, tint_symbol_114_1, x_1902);
  return;
}

const x_1924 = vec2f(2.0f);

fn tint_symbol_120_inner(tint_symbol_121 : vec3u) {
  var tint_symbol_37_1 = vec3f();
  var tint_symbol_124 = vec3f();
  var tint_symbol_58_2 = vec2f();
  var tint_symbol_125 = tint_symbol_98(0.0f, vec3f(), false, false);
  var x_1920 : bool;
  var x_1921 : bool;
  let x_1907 = bitcast<vec2i>(tint_symbol_121.xy);
  let x_1910 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_77)));
  let x_1915 = (x_1907.x < x_1910.x);
  x_1921 = x_1915;
  if (x_1915) {
    x_1920 = (x_1907.y < x_1910.y);
    x_1921 = x_1920;
  }
  var x_1965 : bool;
  var x_1966 : bool;
  var x_1973 : bool;
  var x_1974 : bool;
  if (x_1921) {
    let x_1929 = (x_1924 / tint_symbol_75.inner.tint_symbol_66.xy);
    tint_symbol_37_1 = vec3f((((f32(x_1907.x) + 0.5f) * x_1929.x) - 1.0f), (((f32(x_1907.y) + 0.5f) * x_1929.y) - 1.0f), 0.0f);
    tint_symbol_124 = vec3f(0.0f, 0.0f, 1.0f);
    let x_1948 = tint_symbol_37_1;
    let x_1947 = tint_symbol_84(x_1948);
    tint_symbol_37_1 = x_1947;
    let x_1950 = tint_symbol_124;
    let x_1949 = tint_symbol_82(x_1950);
    tint_symbol_124 = x_1949;
    let x_1952 = tint_symbol_37_1;
    let x_1953 = tint_symbol_124;
    let x_1951 = tint_symbol_109(x_1952, x_1953);
    tint_symbol_58_2 = x_1951;
    let x_1956 = tint_symbol_37_1;
    let x_1957 = tint_symbol_124;
    let x_1955 = tint_symbol_101(x_1956, x_1957);
    tint_symbol_125 = x_1955;
    let x_1961 = (tint_symbol_58_2.x > 0.0f);
    x_1966 = x_1961;
    if (x_1961) {
      x_1965 = tint_symbol_125.tint_symbol_53;
      x_1966 = x_1965;
    }
    x_1974 = x_1966;
    if (x_1966) {
      x_1973 = (tint_symbol_125.tint_symbol_97 < tint_symbol_58_2.x);
      x_1974 = x_1973;
    }
    if (x_1974) {
      let x_1979 = tint_symbol_125;
      tint_symbol_116(x_1907, x_1979);
    } else {
      let x_1982 = tint_symbol_58_2.x;
      let x_1985 = tint_symbol_58_2.y;
      let x_1983 = tint_ftoi(x_1985);
      tint_symbol_113(x_1907, x_1982, x_1983);
    }
  }
  return;
}

fn tint_symbol_120_1() {
  let x_1990 = tint_symbol_121_1;
  tint_symbol_120_inner(x_1990);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMain(@builtin(global_invocation_id) tint_symbol_121_1_param : vec3u) {
  tint_symbol_121_1 = tint_symbol_121_1_param;
  tint_symbol_120_1();
}

fn tint_symbol_126_inner(tint_symbol_121_3 : vec3u) {
  var tint_symbol_37_2 = vec3f();
  var tint_symbol_124_1 = vec3f();
  var tint_symbol_58_3 = vec2f();
  var tint_symbol_125_1 = tint_symbol_98(0.0f, vec3f(), false, false);
  var x_2006 : bool;
  var x_2007 : bool;
  let x_1994 = bitcast<vec2i>(tint_symbol_121_3.xy);
  let x_1996 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_77)));
  let x_2001 = (x_1994.x < x_1996.x);
  x_2007 = x_2001;
  if (x_2001) {
    x_2006 = (x_1994.y < x_1996.y);
    x_2007 = x_2006;
  }
  var x_2058 : bool;
  var x_2059 : bool;
  var x_2066 : bool;
  var x_2067 : bool;
  if (x_2007) {
    let x_2016 = (x_1924 / (tint_symbol_75.inner.tint_symbol_66.xy * tint_symbol_75.inner.tint_symbol_65));
    tint_symbol_37_2 = vec3f();
    tint_symbol_124_1 = normalize(vec3f((((f32(x_1994.x) + 0.5f) * x_2016.x) - (1.0f / tint_symbol_75.inner.tint_symbol_65.x)), (((f32(x_1994.y) + 0.5f) * x_2016.y) - (1.0f / tint_symbol_75.inner.tint_symbol_65.y)), 1.0f));
    let x_2041 = tint_symbol_37_2;
    let x_2040 = tint_symbol_84(x_2041);
    tint_symbol_37_2 = x_2040;
    let x_2043 = tint_symbol_124_1;
    let x_2042 = tint_symbol_82(x_2043);
    tint_symbol_124_1 = x_2042;
    let x_2045 = tint_symbol_37_2;
    let x_2046 = tint_symbol_124_1;
    let x_2044 = tint_symbol_109(x_2045, x_2046);
    tint_symbol_58_3 = x_2044;
    let x_2049 = tint_symbol_37_2;
    let x_2050 = tint_symbol_124_1;
    let x_2048 = tint_symbol_101(x_2049, x_2050);
    tint_symbol_125_1 = x_2048;
    let x_2054 = (tint_symbol_58_3.x > 0.0f);
    x_2059 = x_2054;
    if (x_2054) {
      x_2058 = tint_symbol_125_1.tint_symbol_53;
      x_2059 = x_2058;
    }
    x_2067 = x_2059;
    if (x_2059) {
      x_2066 = (tint_symbol_125_1.tint_symbol_97 < tint_symbol_58_3.x);
      x_2067 = x_2066;
    }
    if (x_2067) {
      let x_2072 = tint_symbol_125_1;
      tint_symbol_116(x_1994, x_2072);
    } else {
      let x_2075 = tint_symbol_58_3.x;
      let x_2078 = tint_symbol_58_3.y;
      let x_2076 = tint_ftoi(x_2078);
      tint_symbol_113(x_1994, x_2075, x_2076);
    }
  }
  return;
}

fn tint_symbol_126_1() {
  let x_2082 = tint_symbol_121_2;
  tint_symbol_126_inner(x_2082);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMain(@builtin(global_invocation_id) tint_symbol_121_2_param : vec3u) {
  tint_symbol_121_2 = tint_symbol_121_2_param;
  tint_symbol_126_1();
}
