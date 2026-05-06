/*
 * Scroll 15 — Shadows
 *
 * Extends the Scroll-14 shader (texture/bump/env mapping) with shadow rendering:
 *   Part 1 – Hard shadows       : binary occlusion via a single shadow ray
 *   Part 2 – Soft shadows
 *     Point light   → Area light sampling  (jitter the light position, 8 samples)
 *     Directional   → PCF / jittered directions  (8 jittered shadow rays)
 *     Spotlight     → Distance-based  (shadow fades with occluder distance)
 *
 * Additional GPU binding:
 *   @binding(8) shadowFlags – struct { enabled, mode, pad0, pad1 }
 *                             mode: 0 = hard shadow, 1 = soft shadow
 *
 * Keys (JS side):
 *   O / o  – toggle shadows on / off
 *   K / k  – cycle hard ↔ soft shadow mode
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

struct tint_symbol_80 {
  /* @offset(0) */
  tint_symbol_81 : u32,
  /* @offset(4) */
  tint_symbol_82 : u32,
  /* @offset(8) */
  tint_symbol_83 : u32,
  /* @offset(12) */
  tint_symbol_84 : u32,
}

struct tint_symbol_85_block {
  /* @offset(0) */
  inner : tint_symbol_80,
}

struct tint_symbol_86 {
  /* @offset(0) */
  tint_symbol_87 : u32,
  /* @offset(4) */
  tint_symbol_88 : u32,
  /* @offset(8) */
  tint_symbol_89 : u32,
  /* @offset(12) */
  tint_symbol_90 : u32,
}

struct tint_symbol_91_block {
  /* @offset(0) */
  inner : tint_symbol_86,
}

struct tint_symbol_47 {
  /* @offset(0) */
  tint_symbol_23 : vec3f,
  /* @offset(12) */
  tint_symbol_48 : bool,
  /* @offset(16) */
  tint_symbol_49 : bool,
}

struct tint_symbol_125 {
  /* @offset(0) */
  tint_symbol_68 : vec4f,
  /* @offset(16) */
  tint_symbol_126 : vec3f,
}

var<private> tint_symbol_219_1 : vec3u;

var<private> tint_symbol_219_2 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_73 : tint_symbol_73_block;

@group(0) @binding(1) var<uniform> tint_symbol_74 : tint_symbol_74_block;

@group(0) @binding(2) var tint_symbol_75 : texture_storage_2d<rgba8unorm, write>;

@group(0) @binding(3) var<uniform> tint_symbol_76 : tint_symbol_76_block;

@group(0) @binding(4) var tint_symbol_77 : sampler;

@group(0) @binding(5) var tint_symbol_78 : texture_2d<f32>;

@group(0) @binding(6) var tint_symbol_79 : texture_cube<f32>;

@group(0) @binding(7) var<uniform> tint_symbol_85 : tint_symbol_85_block;

@group(0) @binding(8) var<uniform> tint_symbol_91 : tint_symbol_91_block;

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
  let x_852 = tint_symbol_20;
  return x_852;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_888 = tint_symbol_21(tint_symbol_24);
  let x_889 = tint_symbol_17(tint_symbol_23, x_888);
  let x_890 = tint_symbol_17(tint_symbol_24, x_889);
  return x_890;
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
  let x_979 = tint_symbol_26;
  return sqrt(x_979);
}

fn tint_symbol_27(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_987 = tint_symbol_25(tint_symbol_24_2);
  if ((x_987 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_2.tint_symbol_1 / x_987), (tint_symbol_24_2.tint_symbol_2 / x_987), (tint_symbol_24_2.tint_symbol_3 / x_987), (tint_symbol_24_2.tint_symbol_4 / x_987), (tint_symbol_24_2.tint_symbol_5 / x_987), (tint_symbol_24_2.tint_symbol_6 / x_987), (tint_symbol_24_2.tint_symbol_7 / x_987), (tint_symbol_24_2.tint_symbol_8 / x_987), (tint_symbol_24_2.tint_symbol_9 / x_987), (tint_symbol_24_2.tint_symbol_10 / x_987), (tint_symbol_24_2.tint_symbol_11 / x_987), (tint_symbol_24_2.tint_symbol_12 / x_987), (tint_symbol_24_2.tint_symbol_13 / x_987), (tint_symbol_24_2.tint_symbol_14 / x_987), (tint_symbol_24_2.tint_symbol_15 / x_987), (tint_symbol_24_2.tint_symbol_16 / x_987));
  }
  let x_1031 = tint_return_value;
  return x_1031;
}

fn tint_symbol_29(tint_symbol_30 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_30.z, -(tint_symbol_30.y), tint_symbol_30.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_31(tint_symbol_1 : vec3f, tint_symbol_30_1 : vec3f) -> tint_symbol {
  let x_1047 = tint_symbol_29(tint_symbol_30_1);
  let x_1048 = tint_symbol_27(x_1047);
  return tint_symbol(0.0f, x_1048.tint_symbol_2, x_1048.tint_symbol_3, x_1048.tint_symbol_4, -(((-(x_1048.tint_symbol_3) * tint_symbol_1.z) - (x_1048.tint_symbol_2 * tint_symbol_1.y))), -(((x_1048.tint_symbol_2 * tint_symbol_1.x) - (x_1048.tint_symbol_4 * tint_symbol_1.z))), -(((x_1048.tint_symbol_4 * tint_symbol_1.y) + (x_1048.tint_symbol_3 * tint_symbol_1.x))), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
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
  let x_1226 = tint_symbol_35(tint_symbol_23_3);
  let x_1227 = tint_symbol_22(x_1226, tint_symbol_24_4);
  let x_1228 = tint_symbol_36(x_1227);
  return x_1228;
}

fn tint_symbol_45(tint_symbol_30_2 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1233 = tint_symbol_34(tint_symbol_24_5);
  let x_1234 = tint_symbol_35(tint_symbol_30_2);
  let x_1235 = tint_symbol_22(x_1234, x_1233);
  let x_1236 = tint_symbol_36(x_1235);
  return x_1236;
}

fn tint_symbol_50(tint_symbol_51 : tint_symbol, tint_symbol_52 : tint_symbol) -> tint_symbol_47 {
  var tint_symbol_54 = tint_symbol_47(vec3f(), false, false);
  var x_1263 : bool;
  var x_1264 : bool;
  var x_1269 : bool;
  var x_1270 : bool;
  var x_1275 : bool;
  var x_1276 : bool;
  let x_1243 = tint_symbol_17(tint_symbol_51, tint_symbol_52);
  let x_1249 = tint_symbol_36(x_1243);
  tint_symbol_54.tint_symbol_23 = x_1249;
  tint_symbol_54.tint_symbol_48 = !((abs(x_1243.tint_symbol_8) <= 0.00000000999999993923f));
  let x_1258 = tint_symbol_54.tint_symbol_48;
  x_1264 = x_1258;
  if (x_1258) {
    x_1263 = (abs(x_1243.tint_symbol_9) <= 0.00000000999999993923f);
    x_1264 = x_1263;
  }
  x_1270 = x_1264;
  if (x_1264) {
    x_1269 = (abs(x_1243.tint_symbol_10) <= 0.00000000999999993923f);
    x_1270 = x_1269;
  }
  x_1276 = x_1270;
  if (x_1270) {
    x_1275 = (abs(x_1243.tint_symbol_11) <= 0.00000000999999993923f);
    x_1276 = x_1275;
  }
  tint_symbol_54.tint_symbol_49 = x_1276;
  let x_1277 = tint_symbol_54;
  return x_1277;
}

fn tint_symbol_92(tint_symbol_30_3 : vec3f) -> vec3f {
  var tint_symbol_93 = vec3f();
  let x_1285 = tint_symbol_73.inner.tint_symbol_56;
  let x_1282 = tint_symbol_45(tint_symbol_30_3, x_1285);
  tint_symbol_93 = x_1282;
  let x_1288 = tint_symbol_93;
  let x_1291 = tint_symbol_74.inner.tint_symbol_56;
  let x_1289 = tint_symbol_21(x_1291);
  let x_1292 = tint_symbol_45(x_1288, x_1289);
  tint_symbol_93 = x_1292;
  tint_symbol_93 = (tint_symbol_93 / tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1299 = tint_symbol_93;
  return x_1299;
}

fn tint_symbol_94(tint_symbol_95 : vec3f) -> vec3f {
  var tint_symbol_93_1 = vec3f();
  let x_1305 = tint_symbol_73.inner.tint_symbol_56;
  let x_1303 = tint_symbol_44(tint_symbol_95, x_1305);
  tint_symbol_93_1 = x_1303;
  let x_1307 = tint_symbol_93_1;
  let x_1310 = tint_symbol_74.inner.tint_symbol_56;
  let x_1308 = tint_symbol_21(x_1310);
  let x_1311 = tint_symbol_44(x_1307, x_1308);
  tint_symbol_93_1 = x_1311;
  tint_symbol_93_1 = (tint_symbol_93_1 / tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1317 = tint_symbol_93_1;
  return x_1317;
}

fn tint_symbol_96(tint_symbol_32 : vec3f) -> vec3f {
  var tint_symbol_93_2 = vec3f();
  tint_symbol_93_2 = (tint_symbol_32 * tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1327 = tint_symbol_93_2;
  let x_1329 = tint_symbol_74.inner.tint_symbol_56;
  let x_1326 = tint_symbol_45(x_1327, x_1329);
  tint_symbol_93_2 = x_1326;
  let x_1331 = tint_symbol_93_2;
  return normalize(x_1331);
}

fn tint_symbol_97(tint_symbol_95_1 : vec3f) -> vec3f {
  var tint_symbol_93_3 = vec3f();
  tint_symbol_93_3 = (tint_symbol_95_1 * tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1341 = tint_symbol_93_3;
  let x_1343 = tint_symbol_74.inner.tint_symbol_56;
  let x_1340 = tint_symbol_44(x_1341, x_1343);
  tint_symbol_93_3 = x_1340;
  let x_1344 = tint_symbol_93_3;
  return x_1344;
}

fn tint_symbol_98(tint_symbol_1_1 : vec3f, tint_symbol_30_4 : vec3f, tint_symbol_99 : tint_symbol_59, tint_symbol_100 : f32) -> vec2f {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = vec2f();
  var tint_symbol_54_1 = tint_symbol_47(vec3f(), false, false);
  var tint_symbol_101 = 0.0f;
  let x_1356 = tint_symbol_31(tint_symbol_1_1, tint_symbol_30_4);
  let x_1358 = tint_symbol_99.tint_symbol_60;
  let x_1360 = tint_symbol_99.tint_symbol_61;
  let x_1362 = tint_symbol_99.tint_symbol_62;
  let x_1357 = tint_symbol_37(x_1358.xyz, x_1360.xyz, x_1362.xyz);
  let x_1364 = tint_symbol_50(x_1356, x_1357);
  tint_symbol_54_1 = x_1364;
  if (tint_symbol_54_1.tint_symbol_48) {
    var x_1392 : bool;
    var x_1393 : bool;
    var x_1408 : bool;
    var x_1409 : bool;
    if ((abs((tint_symbol_99.tint_symbol_60.z - tint_symbol_99.tint_symbol_62.z)) <= 0.00000000999999993923f)) {
      let x_1385 = (tint_symbol_99.tint_symbol_60.x <= tint_symbol_54_1.tint_symbol_23.x);
      x_1393 = x_1385;
      if (x_1385) {
        x_1392 = (tint_symbol_54_1.tint_symbol_23.x <= tint_symbol_99.tint_symbol_62.x);
        x_1393 = x_1392;
      }
      var x_1407 : bool;
      x_1409 = x_1393;
      if (x_1393) {
        let x_1400 = (tint_symbol_99.tint_symbol_60.y <= tint_symbol_54_1.tint_symbol_23.y);
        x_1408 = x_1400;
        if (x_1400) {
          x_1407 = (tint_symbol_54_1.tint_symbol_23.y <= tint_symbol_99.tint_symbol_62.y);
          x_1408 = x_1407;
        }
        x_1409 = x_1408;
      }
      tint_symbol_54_1.tint_symbol_48 = x_1409;
    } else {
      var x_1432 : bool;
      var x_1433 : bool;
      var x_1448 : bool;
      var x_1449 : bool;
      if ((abs((tint_symbol_99.tint_symbol_60.y - tint_symbol_99.tint_symbol_62.y)) <= 0.00000000999999993923f)) {
        let x_1425 = (tint_symbol_99.tint_symbol_60.x <= tint_symbol_54_1.tint_symbol_23.x);
        x_1433 = x_1425;
        if (x_1425) {
          x_1432 = (tint_symbol_54_1.tint_symbol_23.x <= tint_symbol_99.tint_symbol_62.x);
          x_1433 = x_1432;
        }
        var x_1447 : bool;
        x_1449 = x_1433;
        if (x_1433) {
          let x_1440 = (tint_symbol_99.tint_symbol_60.z <= tint_symbol_54_1.tint_symbol_23.z);
          x_1448 = x_1440;
          if (x_1440) {
            x_1447 = (tint_symbol_54_1.tint_symbol_23.z <= tint_symbol_99.tint_symbol_62.z);
            x_1448 = x_1447;
          }
          x_1449 = x_1448;
        }
        tint_symbol_54_1.tint_symbol_48 = x_1449;
      } else {
        var x_1471 : bool;
        var x_1472 : bool;
        var x_1487 : bool;
        var x_1488 : bool;
        if ((abs((tint_symbol_99.tint_symbol_60.x - tint_symbol_99.tint_symbol_62.x)) <= 0.00000000999999993923f)) {
          let x_1464 = (tint_symbol_99.tint_symbol_60.y <= tint_symbol_54_1.tint_symbol_23.y);
          x_1472 = x_1464;
          if (x_1464) {
            x_1471 = (tint_symbol_54_1.tint_symbol_23.y <= tint_symbol_99.tint_symbol_62.y);
            x_1472 = x_1471;
          }
          var x_1486 : bool;
          x_1488 = x_1472;
          if (x_1472) {
            let x_1479 = (tint_symbol_99.tint_symbol_60.z <= tint_symbol_54_1.tint_symbol_23.z);
            x_1487 = x_1479;
            if (x_1479) {
              x_1486 = (tint_symbol_54_1.tint_symbol_23.z <= tint_symbol_99.tint_symbol_62.z);
              x_1487 = x_1486;
            }
            x_1488 = x_1487;
          }
          tint_symbol_54_1.tint_symbol_48 = x_1488;
        }
      }
    }
    if (tint_symbol_54_1.tint_symbol_48) {
      tint_symbol_101 = -1.0f;
      if ((tint_symbol_30_4.x > 0.00000000999999993923f)) {
        tint_symbol_101 = ((tint_symbol_54_1.tint_symbol_23.x - tint_symbol_1_1.x) / tint_symbol_30_4.x);
      } else {
        if ((tint_symbol_30_4.y > 0.00000000999999993923f)) {
          tint_symbol_101 = ((tint_symbol_54_1.tint_symbol_23.y - tint_symbol_1_1.y) / tint_symbol_30_4.y);
        } else {
          tint_symbol_101 = ((tint_symbol_54_1.tint_symbol_23.z - tint_symbol_1_1.z) / tint_symbol_30_4.z);
        }
      }
      if ((tint_symbol_101 < 0.0f)) {
        tint_return_flag_1 = true;
        tint_return_value_1 = vec2f(tint_symbol_100, -1.0f);
      } else {
        if ((tint_symbol_100 < 0.0f)) {
          tint_return_flag_1 = true;
          tint_return_value_1 = vec2f(tint_symbol_101, 1.0f);
        } else {
          if ((tint_symbol_101 < tint_symbol_100)) {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_101, 1.0f);
          } else {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_100, -1.0f);
          }
        }
      }
    }
  }
  if (!(tint_return_flag_1)) {
    tint_return_flag_1 = true;
    tint_return_value_1 = vec2f(tint_symbol_100, -1.0f);
  }
  let x_1548 = tint_return_value_1;
  return x_1548;
}

fn tint_symbol_102(tint_symbol_1_2 : vec3f, tint_symbol_30_5 : vec3f) -> vec2f {
  var tint_symbol_103 = 0.0f;
  var tint_symbol_104 = 0.0f;
  var tint_symbol_105 = 0i;
  tint_symbol_103 = -1.0f;
  tint_symbol_104 = -1.0f;
  tint_symbol_105 = 0i;
  loop {
    if (!((tint_symbol_105 < 6i))) {
      break;
    }
    let x_1572 = tint_symbol_74.inner.tint_symbol_66[tint_symbol_105];
    let x_1573 = tint_symbol_103;
    let x_1568 = tint_symbol_98(tint_symbol_1_2, tint_symbol_30_5, x_1572, x_1573);
    if ((x_1568.y > 0.0f)) {
      tint_symbol_103 = x_1568.x;
      tint_symbol_104 = f32(tint_symbol_105);
    }

    continuing {
      tint_symbol_105 = (tint_symbol_105 + 1i);
    }
  }
  let x_1583 = tint_symbol_103;
  let x_1584 = tint_symbol_104;
  return vec2f(x_1583, x_1584);
}

const x_1589 = vec4f(0.0f, 0.0f, 0.0f, 1.0f);

fn tint_symbol_107() -> vec4f {
  return x_1589;
}

fn tint_symbol_108(tint_symbol_104_1 : i32) -> vec4f {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = vec4f();
  switch(tint_symbol_104_1) {
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
      tint_return_value_2 = x_1589;
    }
  }
  let x_1625 = tint_return_value_2;
  return x_1625;
}

const x_1642 = vec3f(0.0f, -1.0f, 0.0f);

const x_1641 = vec3f(-1.0f, 0.0f, 0.0f);

const x_1640 = vec3f(0.0f, 0.0f, -1.0f);

fn tint_symbol_109(tint_symbol_104_2 : i32) -> vec3f {
  var tint_return_flag_3 = false;
  var tint_return_value_3 = vec3f();
  switch(tint_symbol_104_2) {
    case 5i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1642;
    }
    case 4i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1642;
    }
    case 3i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1641;
    }
    case 2i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1641;
    }
    case 1i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1640;
    }
    case 0i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1640;
    }
    default: {
      tint_return_flag_3 = true;
      tint_return_value_3 = vec3f();
    }
  }
  let x_1643 = tint_return_value_3;
  return x_1643;
}

fn tint_symbol_112(tint_symbol_113 : i32, tint_symbol_114 : vec3f) -> vec2f {
  var tint_return_flag_4 = false;
  var tint_return_value_4 = vec2f();
  switch(tint_symbol_113) {
    case 5i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_114.x + 0.5f), (tint_symbol_114.z + 0.5f));
    }
    case 4i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_114.x + 0.5f), (0.5f - tint_symbol_114.z));
    }
    case 3i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((0.5f - tint_symbol_114.z), (tint_symbol_114.y + 0.5f));
    }
    case 2i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_114.z + 0.5f), (tint_symbol_114.y + 0.5f));
    }
    case 1i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((0.5f - tint_symbol_114.x), (tint_symbol_114.y + 0.5f));
    }
    case 0i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_114.x + 0.5f), (tint_symbol_114.y + 0.5f));
    }
    default: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f();
    }
  }
  let x_1690 = tint_return_value_4;
  return x_1690;
}

const x_1702 = vec3f(0.29899999499320983887f, 0.58700001239776611328f, 0.11400000005960464478f);

fn tint_symbol_115(tint_symbol_113_1 : i32, tint_symbol_116 : vec2f) -> vec3f {
  var tint_return_flag_5 = false;
  var tint_return_value_5 = vec3f();
  let x_1704 = dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, tint_symbol_116, 0.0f).xyz, x_1702);
  let x_1728 = ((dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, (tint_symbol_116 + vec2f(0.001953125f, 0.0f)), 0.0f).xyz, x_1702) - x_1704) * 4.0f);
  let x_1730 = ((dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, (tint_symbol_116 + vec2f(0.0f, 0.001953125f)), 0.0f).xyz, x_1702) - x_1704) * 4.0f);
  switch(tint_symbol_113_1) {
    case 5i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-(x_1728), -1.0f, -(x_1730)));
    }
    case 4i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-(x_1728), -1.0f, x_1730));
    }
    case 3i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-1.0f, -(x_1730), x_1728));
    }
    case 2i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-1.0f, -(x_1730), -(x_1728)));
    }
    case 1i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(x_1728, -(x_1730), -1.0f));
    }
    case 0i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-(x_1728), -(x_1730), -1.0f));
    }
    default: {
      tint_return_flag_5 = true;
      tint_return_value_5 = x_1640;
    }
  }
  let x_1760 = tint_return_value_5;
  return x_1760;
}

fn tint_symbol_127(tint_symbol_128 : vec3f, tint_symbol_129 : vec3f, tint_symbol_130 : vec3f) -> tint_symbol_125 {
  var tint_symbol_93_4 = tint_symbol_125(vec4f(), vec3f());
  var x_1820 = vec4f();
  var x_1843 = vec4f();
  var x_1771 : i32;
  let x_1774 = tint_symbol_76.inner.tint_symbol_72.z;
  x_1771 = tint_ftoi(x_1774);
  if ((x_1771 == 1i)) {
    tint_symbol_93_4.tint_symbol_68 = tint_symbol_76.inner.tint_symbol_68;
    tint_symbol_93_4.tint_symbol_126 = normalize(tint_symbol_129);
  } else {
    if ((x_1771 == 2i)) {
      let x_1788 = normalize((tint_symbol_130 - tint_symbol_128));
      let x_1790 = dot(normalize(tint_symbol_129), x_1788);
      let x_1795 = tint_symbol_76.inner.tint_symbol_72.y;
      if ((x_1790 > cos(tint_symbol_76.inner.tint_symbol_72[0i]))) {
        let x_1802 = length((tint_symbol_130 - tint_symbol_128));
        tint_symbol_93_4.tint_symbol_68 = ((tint_symbol_76.inner.tint_symbol_68 * pow(x_1790, x_1795)) / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_1802 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_1802 * x_1802) * tint_symbol_76.inner.tint_symbol_71.z))));
      } else {
        tint_symbol_93_4.tint_symbol_68 = vec4f();
      }
      tint_symbol_93_4.tint_symbol_126 = x_1788;
    } else {
      let x_1826 = length((tint_symbol_130 - tint_symbol_128));
      tint_symbol_93_4.tint_symbol_68 = (tint_symbol_76.inner.tint_symbol_68 / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_1826 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_1826 * x_1826) * tint_symbol_76.inner.tint_symbol_71.z))));
      tint_symbol_93_4.tint_symbol_126 = normalize((tint_symbol_130 - tint_symbol_128));
    }
  }
  let x_1846 = tint_symbol_93_4;
  return x_1846;
}

fn tint_symbol_139(tint_symbol_140 : f32) -> f32 {
  var tint_return_flag_6 = false;
  var tint_return_value_6 = 0.0f;
  if ((tint_symbol_140 < 0.10000000149011611938f)) {
    tint_return_flag_6 = true;
    tint_return_value_6 = 0.0f;
  } else {
    if ((tint_symbol_140 < 0.34999999403953552246f)) {
      tint_return_flag_6 = true;
      tint_return_value_6 = 0.20000000298023223877f;
    } else {
      if ((tint_symbol_140 < 0.64999997615814208984f)) {
        tint_return_flag_6 = true;
        tint_return_value_6 = 0.5f;
      } else {
        if ((tint_symbol_140 < 0.89999997615814208984f)) {
          tint_return_flag_6 = true;
          tint_return_value_6 = 0.80000001192092895508f;
        } else {
          tint_return_flag_6 = true;
          tint_return_value_6 = 1.0f;
        }
      }
    }
  }
  let x_1875 = tint_return_value_6;
  return x_1875;
}

const x_1908 = vec4f(0.5f, 0.5f, 0.5f, 0.0f);

const x_1909 = vec4f(0.10000000149011611938f, 0.10000000149011611938f, 0.10000000149011611938f, 0.0f);

fn tint_symbol_141(tint_symbol_142 : vec4f, tint_symbol_143 : vec4f, tint_symbol_144 : vec3f, tint_symbol_145 : tint_symbol_125, tint_symbol_146 : vec3f, tint_symbol_147 : vec3f) -> vec4f {
  var tint_return_flag_7 = false;
  var tint_return_value_7 = vec4f();
  var x_1887 : vec3f;
  var x_1888 : vec4f;
  var x_1889 : i32;
  var x_1893 : f32;
  x_1887 = tint_symbol_145.tint_symbol_126;
  x_1888 = tint_symbol_145.tint_symbol_68;
  let x_1892 = tint_symbol_76.inner.tint_symbol_72.w;
  x_1889 = tint_ftoi(x_1892);
  x_1893 = max(dot(tint_symbol_144, -(x_1887)), 0.0f);
  if ((x_1889 == 1i)) {
    tint_return_flag_7 = true;
    tint_return_value_7 = (((tint_symbol_142 + ((tint_symbol_143 * x_1888) * x_1893)) + ((x_1908 * x_1888) * pow(max(dot(normalize((tint_symbol_146 - tint_symbol_147)), -(reflect(x_1887, tint_symbol_144))), 0.0f), 64.0f))) + (x_1909 * x_1888));
  } else {
    if ((x_1889 == 2i)) {
      let x_1929 = tint_symbol_139(x_1893);
      let x_1930 = tint_symbol_139(pow(max(dot(normalize((tint_symbol_146 - tint_symbol_147)), -(reflect(x_1887, tint_symbol_144))), 0.0f), 64.0f));
      tint_return_flag_7 = true;
      tint_return_value_7 = (((tint_symbol_142 + ((tint_symbol_143 * x_1888) * x_1929)) + ((x_1908 * x_1888) * x_1930)) + (x_1909 * x_1888));
    } else {
      tint_return_flag_7 = true;
      tint_return_value_7 = (tint_symbol_142 + ((tint_symbol_143 * x_1888) * x_1893));
    }
  }
  let x_1942 = tint_return_value_7;
  return x_1942;
}

fn tint_symbol_159(tint_symbol_140_1 : u32) -> u32 {
  let x_1950 = ((tint_symbol_140_1 * 747796405u) + 2891336453u);
  let x_1959 = (((x_1950 >> (((x_1950 >> 28u) + 4u) & 31u)) ^ x_1950) * 277803737u);
  return ((x_1959 >> 22u) ^ x_1959);
}

fn tint_symbol_162(tint_symbol_116_1 : vec2i, tint_symbol_163 : u32) -> f32 {
  let x_1981 = tint_symbol_159((((bitcast<u32>(tint_symbol_116_1.x) * 1973u) + (bitcast<u32>(tint_symbol_116_1.y) * 9277u)) + (tint_symbol_163 * 26699u)));
  return (f32(x_1981) / 4294967296.0f);
}

fn tint_symbol_169(tint_symbol_170 : vec3f, tint_symbol_33 : vec3f, tint_symbol_171 : vec3f, tint_symbol_172 : f32) -> f32 {
  var tint_return_flag_8 = false;
  var tint_return_value_8 = 0.0f;
  let x_1994 = (tint_symbol_170 - tint_symbol_171);
  let x_1995 = dot(x_1994, tint_symbol_33);
  let x_2000 = ((x_1995 * x_1995) - (dot(x_1994, x_1994) - (tint_symbol_172 * tint_symbol_172)));
  if ((x_2000 < 0.0f)) {
    tint_return_flag_8 = true;
    tint_return_value_8 = -1.0f;
  }
  if (!(tint_return_flag_8)) {
    let x_2008 = sqrt(x_2000);
    let x_2010 = (-(x_1995) - x_2008);
    if ((x_2010 > 0.0f)) {
      tint_return_flag_8 = true;
      tint_return_value_8 = x_2010;
    }
    if (!(tint_return_flag_8)) {
      let x_2019 = (-(x_1995) + x_2008);
      if ((x_2019 > 0.0f)) {
        tint_return_flag_8 = true;
        tint_return_value_8 = x_2019;
      }
      if (!(tint_return_flag_8)) {
        tint_return_flag_8 = true;
        tint_return_value_8 = -1.0f;
      }
    }
  }
  let x_2027 = tint_return_value_8;
  return x_2027;
}

const x_2037 = vec3f(0.0f, -0.21999999880790710449f, 0.05000000074505805969f);

const x_2059 = vec3f(0.21999999880790710449f, -0.34999999403953552246f, -0.07999999821186065674f);

fn tint_symbol_179(tint_symbol_170_1 : vec3f, tint_symbol_33_1 : vec3f) -> vec2f {
  var tint_symbol_180 = vec2f();
  var x_2049 : bool;
  var x_2050 : bool;
  var x_2051 : bool;
  var x_2072 : bool;
  var x_2073 : bool;
  tint_symbol_180 = vec2f(-1.0f);
  let x_2034 = tint_symbol_169(tint_symbol_170_1, tint_symbol_33_1, x_2037, 0.14000000059604644775f);
  let x_2039 = (x_2034 > 0.0f);
  x_2051 = x_2039;
  if (x_2039) {
    let x_2044 = (tint_symbol_180.x < 0.0f);
    x_2050 = x_2044;
    if (x_2044) {
    } else {
      x_2049 = (x_2034 < tint_symbol_180.x);
      x_2050 = x_2049;
    }
    x_2051 = x_2050;
  }
  if (x_2051) {
    tint_symbol_180 = vec2f(x_2034, 0.0f);
  }
  var x_2071 : bool;
  let x_2055 = tint_symbol_169(tint_symbol_170_1, tint_symbol_33_1, x_2059, 0.09000000357627868652f);
  let x_2061 = (x_2055 > 0.0f);
  x_2073 = x_2061;
  if (x_2061) {
    let x_2066 = (tint_symbol_180.x < 0.0f);
    x_2072 = x_2066;
    if (x_2066) {
    } else {
      x_2071 = (x_2055 < tint_symbol_180.x);
      x_2072 = x_2071;
    }
    x_2073 = x_2072;
  }
  if (x_2073) {
    tint_symbol_180 = vec2f(x_2055, 1.0f);
  }
  let x_2077 = tint_symbol_180;
  return x_2077;
}

fn tint_symbol_181(tint_symbol_182 : vec3f, tint_symbol_183 : vec3f, tint_symbol_184 : f32) -> bool {
  var tint_return_flag_9 = false;
  var tint_return_value_9 = false;
  var x_2095 : bool;
  var x_2096 : bool;
  let x_2088 = (tint_symbol_182 + (tint_symbol_183 * 0.00100000004749745131f));
  let x_2089 = tint_symbol_102(x_2088, tint_symbol_183);
  let x_2091 = (x_2089.x > 0.0f);
  x_2096 = x_2091;
  if (x_2091) {
    x_2095 = (x_2089.x < tint_symbol_184);
    x_2096 = x_2095;
  }
  if (x_2096) {
    tint_return_flag_9 = true;
    tint_return_value_9 = true;
  }
  var x_2109 : bool;
  var x_2110 : bool;
  if (!(tint_return_flag_9)) {
    let x_2103 = tint_symbol_179(x_2088, tint_symbol_183);
    let x_2105 = (x_2103.x > 0.0f);
    x_2110 = x_2105;
    if (x_2105) {
      x_2109 = (x_2103.x < tint_symbol_184);
      x_2110 = x_2109;
    }
    if (x_2110) {
      tint_return_flag_9 = true;
      tint_return_value_9 = true;
    }
    if (!(tint_return_flag_9)) {
      tint_return_flag_9 = true;
      tint_return_value_9 = false;
    }
  }
  let x_2117 = tint_return_value_9;
  return x_2117;
}

fn tint_symbol_187(tint_symbol_114_1 : vec3f, tint_symbol_188 : vec3f, tint_symbol_189 : vec3f, tint_symbol_131 : i32) -> f32 {
  var tint_return_flag_10 = false;
  var tint_return_value_10 = 0.0f;
  var tint_symbol_238 = false;
  var x_2145 = vec3f();
  if ((tint_symbol_131 == 1i)) {
    let x_2131 = tint_symbol_181(tint_symbol_114_1, -(tint_symbol_189), 10000000000.0f);
    if (x_2131) {
      tint_return_flag_10 = true;
      tint_return_value_10 = 0.10000000149011611938f;
    }
  } else {
    let x_2136 = (tint_symbol_188 - tint_symbol_114_1);
    let x_2137 = length(x_2136);
    tint_symbol_238 = (x_2137 > 0.00100000004749745131f);
    if (tint_symbol_238) {
      let x_2143 = tint_symbol_181(tint_symbol_114_1, (x_2136 / vec3f(x_2137)), x_2137);
      tint_symbol_238 = x_2143;
    }
    if (tint_symbol_238) {
      tint_return_flag_10 = true;
      tint_return_value_10 = 0.10000000149011611938f;
    }
  }
  if (!(tint_return_flag_10)) {
    tint_return_flag_10 = true;
    tint_return_value_10 = 1.0f;
  }
  let x_2154 = tint_return_value_10;
  return x_2154;
}

fn tint_symbol_192(tint_symbol_114_2 : vec3f, tint_symbol_188_1 : vec3f, tint_symbol_189_1 : vec3f, tint_symbol_131_1 : i32, tint_symbol_116_2 : vec2i) -> f32 {
  var tint_return_flag_11 = false;
  var tint_return_value_11 = 0.0f;
  var tint_symbol_194 = 0.0f;
  var tint_symbol_105_1 = 0i;
  var tint_symbol_242 = false;
  var x_2218 = vec3f();
  var tint_symbol_201 = vec3f();
  var tint_symbol_194_1 = 0.0f;
  var tint_symbol_105_2 = 0i;
  var x_2310 = vec3f();
  var tint_symbol_207 = 0.0f;
  if ((tint_symbol_131_1 == 0i)) {
    tint_symbol_194 = 0.0f;
    tint_symbol_105_1 = 0i;
    loop {
      if (!((tint_symbol_105_1 < 8i))) {
        break;
      }
      let x_2184 = tint_symbol_105_1;
      let x_2182 = tint_symbol_162(tint_symbol_116_2, bitcast<u32>(((x_2184 * 3i) + 0i)));
      let x_2193 = tint_symbol_105_1;
      let x_2191 = tint_symbol_162(tint_symbol_116_2, bitcast<u32>(((x_2193 * 3i) + 1i)));
      let x_2201 = tint_symbol_105_1;
      let x_2199 = tint_symbol_162(tint_symbol_116_2, bitcast<u32>(((x_2201 * 3i) + 2i)));
      let x_2209 = ((tint_symbol_188_1 + vec3f((((x_2182 - 0.5f) * 2.0f) * 0.15000000596046447754f), (((x_2191 - 0.5f) * 2.0f) * 0.15000000596046447754f), (((x_2199 - 0.5f) * 2.0f) * 0.15000000596046447754f))) - tint_symbol_114_2);
      let x_2210 = length(x_2209);
      tint_symbol_242 = (x_2210 > 0.00100000004749745131f);
      if (tint_symbol_242) {
        let x_2216 = tint_symbol_181(tint_symbol_114_2, (x_2209 / vec3f(x_2210)), x_2210);
        tint_symbol_242 = x_2216;
      }
      if (tint_symbol_242) {
        tint_symbol_194 = (tint_symbol_194 + 0.10000000149011611938f);
      } else {
        tint_symbol_194 = (tint_symbol_194 + 1.0f);
      }

      continuing {
        tint_symbol_105_1 = (tint_symbol_105_1 + 1i);
      }
    }
    tint_return_flag_11 = true;
    tint_return_value_11 = (tint_symbol_194 / 8.0f);
  } else {
    if ((tint_symbol_131_1 == 1i)) {
      if ((abs(tint_symbol_189_1.x) < 0.89999997615814208984f)) {
        tint_symbol_201 = normalize(cross(tint_symbol_189_1, vec3f(1.0f, 0.0f, 0.0f)));
      } else {
        tint_symbol_201 = normalize(cross(tint_symbol_189_1, vec3f(0.0f, 1.0f, 0.0f)));
      }
      let x_2250 = cross(tint_symbol_189_1, tint_symbol_201);
      tint_symbol_194_1 = 0.0f;
      tint_symbol_105_2 = 0i;
      loop {
        if (!((tint_symbol_105_2 < 8i))) {
          break;
        }
        let x_2265 = tint_symbol_105_2;
        let x_2263 = tint_symbol_162(tint_symbol_116_2, bitcast<u32>(((x_2265 * 2i) + 100i)));
        let x_2274 = tint_symbol_105_2;
        let x_2272 = tint_symbol_162(tint_symbol_116_2, bitcast<u32>(((x_2274 * 2i) + 101i)));
        let x_2283 = tint_symbol_201;
        let x_2288 = tint_symbol_181(tint_symbol_114_2, normalize(((-(tint_symbol_189_1) + (x_2283 * (((x_2263 - 0.5f) * 2.0f) * 0.05000000074505805969f))) + (x_2250 * (((x_2272 - 0.5f) * 2.0f) * 0.05000000074505805969f)))), 10000000000.0f);
        if (x_2288) {
          tint_symbol_194_1 = (tint_symbol_194_1 + 0.10000000149011611938f);
        } else {
          tint_symbol_194_1 = (tint_symbol_194_1 + 1.0f);
        }

        continuing {
          tint_symbol_105_2 = (tint_symbol_105_2 + 1i);
        }
      }
      tint_return_flag_11 = true;
      tint_return_value_11 = (tint_symbol_194_1 / 8.0f);
    } else {
      let x_2300 = (tint_symbol_188_1 - tint_symbol_114_2);
      let x_2301 = length(x_2300);
      if ((x_2301 < 0.00100000004749745131f)) {
        tint_return_flag_11 = true;
        tint_return_value_11 = 1.0f;
      }
      var x_2322 : bool;
      var x_2323 : bool;
      var x_2332 : bool;
      var x_2333 : bool;
      var x_2343 : bool;
      var x_2344 : bool;
      if (!(tint_return_flag_11)) {
        let x_2309 = (x_2300 / vec3f(x_2301));
        let x_2313 = (tint_symbol_114_2 + (x_2309 * 0.00100000004749745131f));
        let x_2314 = tint_symbol_102(x_2313, x_2309);
        let x_2315 = tint_symbol_179(x_2313, x_2309);
        tint_symbol_207 = -1.0f;
        let x_2318 = (x_2314.x > 0.0f);
        x_2323 = x_2318;
        if (x_2318) {
          x_2322 = (x_2314.x < x_2301);
          x_2323 = x_2322;
        }
        if (x_2323) {
          tint_symbol_207 = x_2314.x;
        }
        let x_2328 = (x_2315.x > 0.0f);
        x_2333 = x_2328;
        if (x_2328) {
          x_2332 = (x_2315.x < x_2301);
          x_2333 = x_2332;
        }
        var x_2342 : bool;
        x_2344 = x_2333;
        if (x_2333) {
          let x_2337 = (tint_symbol_207 < 0.0f);
          x_2343 = x_2337;
          if (x_2337) {
          } else {
            x_2342 = (x_2315.x < tint_symbol_207);
            x_2343 = x_2342;
          }
          x_2344 = x_2343;
        }
        if (x_2344) {
          tint_symbol_207 = x_2315.x;
        }
        if ((tint_symbol_207 > 0.0f)) {
          tint_return_flag_11 = true;
          tint_return_value_11 = max(pow(min(tint_symbol_207, 1.0f), 0.85000002384185791016f), 0.10000000149011611938f);
        }
        if (!(tint_return_flag_11)) {
          tint_return_flag_11 = true;
          tint_return_value_11 = 1.0f;
        }
      }
    }
  }
  let x_2361 = tint_return_value_11;
  return x_2361;
}

fn tint_symbol_208(tint_symbol_209 : vec3f, tint_symbol_210 : vec3f, tint_symbol_54_2 : vec2f, tint_symbol_116_3 : vec2i) -> vec4f {
  var tint_return_flag_12 = false;
  var tint_return_value_12 = vec4f();
  var tint_symbol_143_1 = vec4f();
  var tint_symbol_144_1 = vec3f();
  var tint_symbol_147_1 = vec3f();
  var tint_symbol_145_1 = tint_symbol_125(vec4f(), vec3f());
  var tint_symbol_214 = 0.0f;
  var x_2397 : bool;
  var x_2398 : bool;
  var x_2399 : bool;
  let x_2371 = tint_ftoi(tint_symbol_54_2.y);
  let x_2375 = (tint_symbol_209 + (tint_symbol_210 * tint_symbol_54_2.x));
  let x_2378 = tint_symbol_74.inner.tint_symbol_65;
  let x_2382 = tint_symbol_74.inner.tint_symbol_56;
  let x_2376 = tint_symbol_45((tint_symbol_210 * x_2378.xyz), x_2382);
  let x_2383 = normalize(x_2376);
  let x_2388 = (tint_symbol_85.inner.tint_symbol_83 != 0u);
  x_2399 = x_2388;
  if (x_2388) {
    let x_2393 = (tint_symbol_85.inner.tint_symbol_81 == 0u);
    x_2398 = x_2393;
    if (x_2393) {
    } else {
      x_2397 = (x_2371 != 5i);
      x_2398 = x_2397;
    }
    x_2399 = x_2398;
  }
  if (x_2399) {
    tint_return_flag_12 = true;
    tint_return_value_12 = textureSampleLevel(tint_symbol_79, tint_symbol_77, x_2383, 0.0f);
  }
  var x_2420 : bool;
  var x_2421 : bool;
  var x_2465 : bool;
  var x_2466 : bool;
  if (!(tint_return_flag_12)) {
    let x_2411 = tint_symbol_112(x_2371, x_2375);
    let x_2412 = (x_2411 * 4.0f);
    let x_2413 = tint_symbol_108(x_2371);
    tint_symbol_143_1 = x_2413;
    let x_2417 = (tint_symbol_85.inner.tint_symbol_81 != 0u);
    x_2421 = x_2417;
    if (x_2417) {
      x_2420 = (x_2371 == 5i);
      x_2421 = x_2420;
    }
    if (x_2421) {
      tint_symbol_143_1 = textureSampleLevel(tint_symbol_78, tint_symbol_77, x_2412, 0.0f);
    }
    let x_2428 = tint_symbol_109(x_2371);
    tint_symbol_144_1 = x_2428;
    if ((tint_symbol_85.inner.tint_symbol_82 != 0u)) {
      let x_2435 = tint_symbol_115(x_2371, x_2412);
      tint_symbol_144_1 = x_2435;
    }
    let x_2437 = tint_symbol_144_1;
    let x_2436 = tint_symbol_96(x_2437);
    tint_symbol_144_1 = x_2436;
    let x_2438 = tint_symbol_107();
    let x_2441 = tint_symbol_73.inner.tint_symbol_56;
    let x_2439 = tint_symbol_21(x_2441);
    let x_2444 = tint_symbol_76.inner.tint_symbol_69;
    let x_2442 = tint_symbol_44(x_2444.xyz, x_2439);
    let x_2448 = tint_symbol_73.inner.tint_symbol_56;
    let x_2446 = tint_symbol_21(x_2448);
    let x_2451 = tint_symbol_76.inner.tint_symbol_70;
    let x_2449 = tint_symbol_45(x_2451.xyz, x_2446);
    tint_symbol_147_1 = x_2375;
    let x_2455 = tint_symbol_147_1;
    let x_2454 = tint_symbol_97(x_2455);
    tint_symbol_147_1 = x_2454;
    let x_2457 = tint_symbol_147_1;
    let x_2456 = tint_symbol_127(x_2442, x_2449, x_2457);
    tint_symbol_145_1 = x_2456;
    let x_2461 = (tint_symbol_91.inner.tint_symbol_87 != 0u);
    x_2466 = x_2461;
    if (x_2461) {
      x_2465 = (x_2371 != 4i);
      x_2466 = x_2465;
    }
    if (x_2466) {
      let x_2471 = tint_symbol_74.inner.tint_symbol_56;
      let x_2469 = tint_symbol_21(x_2471);
      let x_2472 = tint_symbol_44(x_2442, x_2469);
      let x_2476 = (x_2472 / tint_symbol_74.inner.tint_symbol_65.xyz);
      let x_2479 = tint_symbol_74.inner.tint_symbol_56;
      let x_2477 = tint_symbol_21(x_2479);
      let x_2480 = tint_symbol_45(x_2449, x_2477);
      let x_2481 = normalize((x_2480 / tint_symbol_74.inner.tint_symbol_65.xyz));
      let x_2488 = tint_symbol_76.inner.tint_symbol_72.z;
      let x_2486 = tint_ftoi(x_2488);
      if ((tint_symbol_91.inner.tint_symbol_88 == 0u)) {
        let x_2496 = tint_symbol_187(x_2375, x_2476, x_2481, x_2486);
        tint_symbol_214 = x_2496;
      } else {
        let x_2497 = tint_symbol_192(x_2375, x_2476, x_2481, x_2486, tint_symbol_116_3);
        tint_symbol_214 = x_2497;
      }
      tint_symbol_145_1.tint_symbol_68 = (tint_symbol_145_1.tint_symbol_68 * tint_symbol_214);
    }
    let x_2505 = tint_symbol_73.inner.tint_symbol_56;
    let x_2503 = tint_symbol_44(vec3f(), x_2505);
    tint_return_flag_12 = true;
    let x_2507 = tint_symbol_143_1;
    let x_2508 = tint_symbol_144_1;
    let x_2509 = tint_symbol_145_1;
    let x_2510 = tint_symbol_147_1;
    let x_2506 = tint_symbol_141(x_2438, x_2507, x_2508, x_2509, x_2503, x_2510);
    tint_return_value_12 = x_2506;
  }
  let x_2511 = tint_return_value_12;
  return x_2511;
}

fn tint_symbol_215(tint_symbol_209_1 : vec3f, tint_symbol_210_1 : vec3f, tint_symbol_103_1 : f32, tint_symbol_216 : i32, tint_symbol_116_4 : vec2i) -> vec4f {
  var tint_symbol_171_1 = vec3f();
  var tint_symbol_172_1 = 0.0f;
  var tint_symbol_143_2 = vec4f();
  var tint_symbol_145_2 = tint_symbol_125(vec4f(), vec3f());
  var tint_symbol_214_1 = 0.0f;
  let x_2521 = (tint_symbol_209_1 + (tint_symbol_210_1 * tint_symbol_103_1));
  if ((tint_symbol_216 == 0i)) {
    tint_symbol_171_1 = x_2037;
    tint_symbol_172_1 = 0.14000000059604644775f;
    tint_symbol_143_2 = vec4f(0.89999997615814208984f, 0.40000000596046447754f, 0.10000000149011611938f, 1.0f);
  } else {
    tint_symbol_171_1 = x_2059;
    tint_symbol_172_1 = 0.09000000357627868652f;
    tint_symbol_143_2 = vec4f(0.20000000298023223877f, 0.55000001192092895508f, 0.89999997615814208984f, 1.0f);
  }
  var x_2541 : vec3f;
  var x_2548 : vec3f;
  let x_2534 = tint_symbol_171_1;
  let x_2536 = tint_symbol_96(normalize((x_2521 - x_2534)));
  let x_2537 = tint_symbol_97(x_2521);
  let x_2540 = tint_symbol_73.inner.tint_symbol_56;
  let x_2538 = tint_symbol_21(x_2540);
  let x_2543 = tint_symbol_76.inner.tint_symbol_69;
  x_2541 = tint_symbol_44(x_2543.xyz, x_2538);
  let x_2547 = tint_symbol_73.inner.tint_symbol_56;
  let x_2545 = tint_symbol_21(x_2547);
  let x_2550 = tint_symbol_76.inner.tint_symbol_70;
  x_2548 = tint_symbol_45(x_2550.xyz, x_2545);
  let x_2552 = tint_symbol_127(x_2541, x_2548, x_2537);
  tint_symbol_145_2 = x_2552;
  if ((tint_symbol_91.inner.tint_symbol_87 != 0u)) {
    let x_2561 = tint_symbol_74.inner.tint_symbol_56;
    let x_2559 = tint_symbol_21(x_2561);
    let x_2562 = tint_symbol_44(x_2541, x_2559);
    let x_2566 = (x_2562 / tint_symbol_74.inner.tint_symbol_65.xyz);
    let x_2569 = tint_symbol_74.inner.tint_symbol_56;
    let x_2567 = tint_symbol_21(x_2569);
    let x_2570 = tint_symbol_45(x_2548, x_2567);
    let x_2571 = normalize((x_2570 / tint_symbol_74.inner.tint_symbol_65.xyz));
    let x_2578 = tint_symbol_76.inner.tint_symbol_72.z;
    let x_2576 = tint_ftoi(x_2578);
    if ((tint_symbol_91.inner.tint_symbol_88 == 0u)) {
      let x_2586 = tint_symbol_187(x_2521, x_2566, x_2571, x_2576);
      tint_symbol_214_1 = x_2586;
    } else {
      let x_2587 = tint_symbol_192(x_2521, x_2566, x_2571, x_2576, tint_symbol_116_4);
      tint_symbol_214_1 = x_2587;
    }
    tint_symbol_145_2.tint_symbol_68 = (tint_symbol_145_2.tint_symbol_68 * tint_symbol_214_1);
  }
  let x_2595 = tint_symbol_73.inner.tint_symbol_56;
  let x_2593 = tint_symbol_44(vec3f(), x_2595);
  let x_2597 = tint_symbol_143_2;
  let x_2598 = tint_symbol_145_2;
  let x_2596 = tint_symbol_141(x_1589, x_2597, x_2536, x_2598, x_2593, x_2537);
  return x_2596;
}

const x_2621 = vec2f(2.0f);

const x_2655 = vec4f(0.0f, 0.21960784494876861572f, 0.39607843756675720215f, 1.0f);

fn tint_symbol_218_inner(tint_symbol_219 : vec3u) {
  var tint_symbol_209_2 = vec3f();
  var tint_symbol_210_2 = vec3f();
  var tint_symbol_222 = vec4f();
  var x_2617 : bool;
  var x_2618 : bool;
  var x_2668 : bool;
  var x_2669 : bool;
  let x_2604 = bitcast<vec2i>(tint_symbol_219.xy);
  let x_2607 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_2612 = (x_2604.x >= x_2607.x);
  x_2618 = x_2612;
  if (x_2612) {
  } else {
    x_2617 = (x_2604.y >= x_2607.y);
    x_2618 = x_2617;
  }
  if (x_2618) {
    return;
  }
  var x_2667 : bool;
  let x_2626 = (x_2621 / tint_symbol_73.inner.tint_symbol_58.xy);
  tint_symbol_209_2 = vec3f((((f32(x_2604.x) + 0.5f) * x_2626.x) - 1.0f), (((f32(x_2604.y) + 0.5f) * x_2626.y) - 1.0f), 0.0f);
  tint_symbol_210_2 = vec3f(0.0f, 0.0f, 1.0f);
  let x_2644 = tint_symbol_209_2;
  let x_2643 = tint_symbol_94(x_2644);
  tint_symbol_209_2 = x_2643;
  let x_2646 = tint_symbol_210_2;
  let x_2645 = tint_symbol_92(x_2646);
  tint_symbol_210_2 = x_2645;
  let x_2648 = tint_symbol_209_2;
  let x_2649 = tint_symbol_210_2;
  let x_2647 = tint_symbol_102(x_2648, x_2649);
  let x_2651 = tint_symbol_209_2;
  let x_2652 = tint_symbol_210_2;
  let x_2650 = tint_symbol_179(x_2651, x_2652);
  tint_symbol_222 = x_2655;
  let x_2658 = (x_2650.x > 0.0f);
  x_2669 = x_2658;
  if (x_2658) {
    let x_2662 = (x_2647.x < 0.0f);
    x_2668 = x_2662;
    if (x_2662) {
    } else {
      x_2667 = (x_2650.x < x_2647.x);
      x_2668 = x_2667;
    }
    x_2669 = x_2668;
  }
  if (x_2669) {
    let x_2674 = tint_symbol_209_2;
    let x_2675 = tint_symbol_210_2;
    let x_2677 = tint_ftoi(x_2650.y);
    let x_2673 = tint_symbol_215(x_2674, x_2675, x_2650.x, x_2677, x_2604);
    tint_symbol_222 = x_2673;
  } else {
    if ((x_2647.x > 0.0f)) {
      let x_2684 = tint_symbol_209_2;
      let x_2685 = tint_symbol_210_2;
      let x_2683 = tint_symbol_208(x_2684, x_2685, x_2647, x_2604);
      tint_symbol_222 = x_2683;
    }
  }
  let x_2688 = tint_symbol_222;
  textureStore(tint_symbol_75, x_2604, x_2688);
  return;
}

fn tint_symbol_218_1() {
  let x_2693 = tint_symbol_219_1;
  tint_symbol_218_inner(x_2693);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMain(@builtin(global_invocation_id) tint_symbol_219_1_param : vec3u) {
  tint_symbol_219_1 = tint_symbol_219_1_param;
  tint_symbol_218_1();
}

fn tint_symbol_223_inner(tint_symbol_219_3 : vec3u) {
  var tint_symbol_209_3 = vec3f();
  var tint_symbol_210_3 = vec3f();
  var tint_symbol_222_1 = vec4f();
  var x_2709 : bool;
  var x_2710 : bool;
  var x_2764 : bool;
  var x_2765 : bool;
  let x_2697 = bitcast<vec2i>(tint_symbol_219_3.xy);
  let x_2699 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_2704 = (x_2697.x >= x_2699.x);
  x_2710 = x_2704;
  if (x_2704) {
  } else {
    x_2709 = (x_2697.y >= x_2699.y);
    x_2710 = x_2709;
  }
  if (x_2710) {
    return;
  }
  var x_2763 : bool;
  let x_2719 = (x_2621 / (tint_symbol_73.inner.tint_symbol_58.xy * tint_symbol_73.inner.tint_symbol_57));
  tint_symbol_209_3 = vec3f();
  tint_symbol_210_3 = normalize(vec3f((((f32(x_2697.x) + 0.5f) * x_2719.x) - (1.0f / tint_symbol_73.inner.tint_symbol_57.x)), (((f32(x_2697.y) + 0.5f) * x_2719.y) - (1.0f / tint_symbol_73.inner.tint_symbol_57.y)), 1.0f));
  let x_2743 = tint_symbol_209_3;
  let x_2742 = tint_symbol_94(x_2743);
  tint_symbol_209_3 = x_2742;
  let x_2745 = tint_symbol_210_3;
  let x_2744 = tint_symbol_92(x_2745);
  tint_symbol_210_3 = x_2744;
  let x_2747 = tint_symbol_209_3;
  let x_2748 = tint_symbol_210_3;
  let x_2746 = tint_symbol_102(x_2747, x_2748);
  let x_2750 = tint_symbol_209_3;
  let x_2751 = tint_symbol_210_3;
  let x_2749 = tint_symbol_179(x_2750, x_2751);
  tint_symbol_222_1 = x_2655;
  let x_2754 = (x_2749.x > 0.0f);
  x_2765 = x_2754;
  if (x_2754) {
    let x_2758 = (x_2746.x < 0.0f);
    x_2764 = x_2758;
    if (x_2758) {
    } else {
      x_2763 = (x_2749.x < x_2746.x);
      x_2764 = x_2763;
    }
    x_2765 = x_2764;
  }
  if (x_2765) {
    let x_2770 = tint_symbol_209_3;
    let x_2771 = tint_symbol_210_3;
    let x_2773 = tint_ftoi(x_2749.y);
    let x_2769 = tint_symbol_215(x_2770, x_2771, x_2749.x, x_2773, x_2697);
    tint_symbol_222_1 = x_2769;
  } else {
    if ((x_2746.x > 0.0f)) {
      let x_2780 = tint_symbol_209_3;
      let x_2781 = tint_symbol_210_3;
      let x_2779 = tint_symbol_208(x_2780, x_2781, x_2746, x_2697);
      tint_symbol_222_1 = x_2779;
    }
  }
  let x_2784 = tint_symbol_222_1;
  textureStore(tint_symbol_75, x_2697, x_2784);
  return;
}

fn tint_symbol_223_1() {
  let x_2788 = tint_symbol_219_2;
  tint_symbol_223_inner(x_2788);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMain(@builtin(global_invocation_id) tint_symbol_219_2_param : vec3u) {
  tint_symbol_219_2 = tint_symbol_219_2_param;
  tint_symbol_223_1();
}
