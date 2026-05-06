/*
 * Scroll 14 — Material Mapping, Bump Mapping & Environment Mapping
 *
 * Extends the Scroll-13 lighting shader with three texture-based techniques:
 *   Part 1 – Material mapping   : t/T key – stone tile texture on box faces
 *   Part 2 – Bump mapping       : b/B key – normal perturbation via height map
 *   Part 3 – Environment mapping: c/C key – Yokohama cube map on box walls
 *
 * New GPU bindings (appended after the scroll-13 set):
 *   @binding(4) texSampler  – filtering sampler with repeat wrap
 *   @binding(5) floorTex    – stone tile 2-D texture (T_Tile_Stone_01_4096_D)
 *   @binding(6) envMap      – Yokohama cube-map texture
 *   @binding(7) texFlags    – struct { showTexture, showBump, showCubeMap, pad }
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

struct tint_symbol_47 {
  /* @offset(0) */
  tint_symbol_23 : vec3f,
  /* @offset(12) */
  tint_symbol_48 : bool,
  /* @offset(16) */
  tint_symbol_49 : bool,
}

struct tint_symbol_118 {
  /* @offset(0) */
  tint_symbol_68 : vec4f,
  /* @offset(16) */
  tint_symbol_119 : vec3f,
}

var<private> tint_symbol_159_1 : vec3u;

var<private> tint_symbol_159_2 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_73 : tint_symbol_73_block;

@group(0) @binding(1) var<uniform> tint_symbol_74 : tint_symbol_74_block;

@group(0) @binding(2) var tint_symbol_75 : texture_storage_2d<rgba8unorm, write>;

@group(0) @binding(3) var<uniform> tint_symbol_76 : tint_symbol_76_block;

@group(0) @binding(4) var tint_symbol_77 : sampler;

@group(0) @binding(5) var tint_symbol_78 : texture_2d<f32>;

@group(0) @binding(6) var tint_symbol_79 : texture_cube<f32>;

@group(0) @binding(7) var<uniform> tint_symbol_85 : tint_symbol_85_block;

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
  let x_848 = tint_symbol_20;
  return x_848;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_884 = tint_symbol_21(tint_symbol_24);
  let x_885 = tint_symbol_17(tint_symbol_23, x_884);
  let x_886 = tint_symbol_17(tint_symbol_24, x_885);
  return x_886;
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
  let x_975 = tint_symbol_26;
  return sqrt(x_975);
}

fn tint_symbol_27(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_983 = tint_symbol_25(tint_symbol_24_2);
  if ((x_983 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_2.tint_symbol_1 / x_983), (tint_symbol_24_2.tint_symbol_2 / x_983), (tint_symbol_24_2.tint_symbol_3 / x_983), (tint_symbol_24_2.tint_symbol_4 / x_983), (tint_symbol_24_2.tint_symbol_5 / x_983), (tint_symbol_24_2.tint_symbol_6 / x_983), (tint_symbol_24_2.tint_symbol_7 / x_983), (tint_symbol_24_2.tint_symbol_8 / x_983), (tint_symbol_24_2.tint_symbol_9 / x_983), (tint_symbol_24_2.tint_symbol_10 / x_983), (tint_symbol_24_2.tint_symbol_11 / x_983), (tint_symbol_24_2.tint_symbol_12 / x_983), (tint_symbol_24_2.tint_symbol_13 / x_983), (tint_symbol_24_2.tint_symbol_14 / x_983), (tint_symbol_24_2.tint_symbol_15 / x_983), (tint_symbol_24_2.tint_symbol_16 / x_983));
  }
  let x_1027 = tint_return_value;
  return x_1027;
}

fn tint_symbol_29(tint_symbol_30 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_30.z, -(tint_symbol_30.y), tint_symbol_30.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_31(tint_symbol_1 : vec3f, tint_symbol_30_1 : vec3f) -> tint_symbol {
  let x_1043 = tint_symbol_29(tint_symbol_30_1);
  let x_1044 = tint_symbol_27(x_1043);
  return tint_symbol(0.0f, x_1044.tint_symbol_2, x_1044.tint_symbol_3, x_1044.tint_symbol_4, -(((-(x_1044.tint_symbol_3) * tint_symbol_1.z) - (x_1044.tint_symbol_2 * tint_symbol_1.y))), -(((x_1044.tint_symbol_2 * tint_symbol_1.x) - (x_1044.tint_symbol_4 * tint_symbol_1.z))), -(((x_1044.tint_symbol_4 * tint_symbol_1.y) + (x_1044.tint_symbol_3 * tint_symbol_1.x))), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
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
  let x_1222 = tint_symbol_35(tint_symbol_23_3);
  let x_1223 = tint_symbol_22(x_1222, tint_symbol_24_4);
  let x_1224 = tint_symbol_36(x_1223);
  return x_1224;
}

fn tint_symbol_45(tint_symbol_30_2 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1229 = tint_symbol_34(tint_symbol_24_5);
  let x_1230 = tint_symbol_35(tint_symbol_30_2);
  let x_1231 = tint_symbol_22(x_1230, x_1229);
  let x_1232 = tint_symbol_36(x_1231);
  return x_1232;
}

fn tint_symbol_50(tint_symbol_51 : tint_symbol, tint_symbol_52 : tint_symbol) -> tint_symbol_47 {
  var tint_symbol_54 = tint_symbol_47(vec3f(), false, false);
  var x_1259 : bool;
  var x_1260 : bool;
  var x_1265 : bool;
  var x_1266 : bool;
  var x_1271 : bool;
  var x_1272 : bool;
  let x_1239 = tint_symbol_17(tint_symbol_51, tint_symbol_52);
  let x_1245 = tint_symbol_36(x_1239);
  tint_symbol_54.tint_symbol_23 = x_1245;
  tint_symbol_54.tint_symbol_48 = !((abs(x_1239.tint_symbol_8) <= 0.00000000999999993923f));
  let x_1254 = tint_symbol_54.tint_symbol_48;
  x_1260 = x_1254;
  if (x_1254) {
    x_1259 = (abs(x_1239.tint_symbol_9) <= 0.00000000999999993923f);
    x_1260 = x_1259;
  }
  x_1266 = x_1260;
  if (x_1260) {
    x_1265 = (abs(x_1239.tint_symbol_10) <= 0.00000000999999993923f);
    x_1266 = x_1265;
  }
  x_1272 = x_1266;
  if (x_1266) {
    x_1271 = (abs(x_1239.tint_symbol_11) <= 0.00000000999999993923f);
    x_1272 = x_1271;
  }
  tint_symbol_54.tint_symbol_49 = x_1272;
  let x_1273 = tint_symbol_54;
  return x_1273;
}

fn tint_symbol_86(tint_symbol_30_3 : vec3f) -> vec3f {
  var tint_symbol_87 = vec3f();
  let x_1281 = tint_symbol_73.inner.tint_symbol_56;
  let x_1278 = tint_symbol_45(tint_symbol_30_3, x_1281);
  tint_symbol_87 = x_1278;
  let x_1284 = tint_symbol_87;
  let x_1287 = tint_symbol_74.inner.tint_symbol_56;
  let x_1285 = tint_symbol_21(x_1287);
  let x_1288 = tint_symbol_45(x_1284, x_1285);
  tint_symbol_87 = x_1288;
  tint_symbol_87 = (tint_symbol_87 / tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1295 = tint_symbol_87;
  return x_1295;
}

fn tint_symbol_88(tint_symbol_89 : vec3f) -> vec3f {
  var tint_symbol_87_1 = vec3f();
  let x_1301 = tint_symbol_73.inner.tint_symbol_56;
  let x_1299 = tint_symbol_44(tint_symbol_89, x_1301);
  tint_symbol_87_1 = x_1299;
  let x_1303 = tint_symbol_87_1;
  let x_1306 = tint_symbol_74.inner.tint_symbol_56;
  let x_1304 = tint_symbol_21(x_1306);
  let x_1307 = tint_symbol_44(x_1303, x_1304);
  tint_symbol_87_1 = x_1307;
  tint_symbol_87_1 = (tint_symbol_87_1 / tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1313 = tint_symbol_87_1;
  return x_1313;
}

fn tint_symbol_90(tint_symbol_32 : vec3f) -> vec3f {
  var tint_symbol_87_2 = vec3f();
  tint_symbol_87_2 = (tint_symbol_32 * tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1323 = tint_symbol_87_2;
  let x_1325 = tint_symbol_74.inner.tint_symbol_56;
  let x_1322 = tint_symbol_45(x_1323, x_1325);
  tint_symbol_87_2 = x_1322;
  let x_1327 = tint_symbol_87_2;
  return normalize(x_1327);
}

fn tint_symbol_91(tint_symbol_89_1 : vec3f) -> vec3f {
  var tint_symbol_87_3 = vec3f();
  tint_symbol_87_3 = (tint_symbol_89_1 * tint_symbol_74.inner.tint_symbol_65.xyz);
  let x_1337 = tint_symbol_87_3;
  let x_1339 = tint_symbol_74.inner.tint_symbol_56;
  let x_1336 = tint_symbol_44(x_1337, x_1339);
  tint_symbol_87_3 = x_1336;
  let x_1340 = tint_symbol_87_3;
  return x_1340;
}

fn tint_symbol_92(tint_symbol_1_1 : vec3f, tint_symbol_30_4 : vec3f, tint_symbol_93 : tint_symbol_59, tint_symbol_94 : f32) -> vec2f {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = vec2f();
  var tint_symbol_54_1 = tint_symbol_47(vec3f(), false, false);
  var tint_symbol_95 = 0.0f;
  let x_1352 = tint_symbol_31(tint_symbol_1_1, tint_symbol_30_4);
  let x_1354 = tint_symbol_93.tint_symbol_60;
  let x_1356 = tint_symbol_93.tint_symbol_61;
  let x_1358 = tint_symbol_93.tint_symbol_62;
  let x_1353 = tint_symbol_37(x_1354.xyz, x_1356.xyz, x_1358.xyz);
  let x_1360 = tint_symbol_50(x_1352, x_1353);
  tint_symbol_54_1 = x_1360;
  if (tint_symbol_54_1.tint_symbol_48) {
    var x_1388 : bool;
    var x_1389 : bool;
    var x_1404 : bool;
    var x_1405 : bool;
    if ((abs((tint_symbol_93.tint_symbol_60.z - tint_symbol_93.tint_symbol_62.z)) <= 0.00000000999999993923f)) {
      let x_1381 = (tint_symbol_93.tint_symbol_60.x <= tint_symbol_54_1.tint_symbol_23.x);
      x_1389 = x_1381;
      if (x_1381) {
        x_1388 = (tint_symbol_54_1.tint_symbol_23.x <= tint_symbol_93.tint_symbol_62.x);
        x_1389 = x_1388;
      }
      var x_1403 : bool;
      x_1405 = x_1389;
      if (x_1389) {
        let x_1396 = (tint_symbol_93.tint_symbol_60.y <= tint_symbol_54_1.tint_symbol_23.y);
        x_1404 = x_1396;
        if (x_1396) {
          x_1403 = (tint_symbol_54_1.tint_symbol_23.y <= tint_symbol_93.tint_symbol_62.y);
          x_1404 = x_1403;
        }
        x_1405 = x_1404;
      }
      tint_symbol_54_1.tint_symbol_48 = x_1405;
    } else {
      var x_1428 : bool;
      var x_1429 : bool;
      var x_1444 : bool;
      var x_1445 : bool;
      if ((abs((tint_symbol_93.tint_symbol_60.y - tint_symbol_93.tint_symbol_62.y)) <= 0.00000000999999993923f)) {
        let x_1421 = (tint_symbol_93.tint_symbol_60.x <= tint_symbol_54_1.tint_symbol_23.x);
        x_1429 = x_1421;
        if (x_1421) {
          x_1428 = (tint_symbol_54_1.tint_symbol_23.x <= tint_symbol_93.tint_symbol_62.x);
          x_1429 = x_1428;
        }
        var x_1443 : bool;
        x_1445 = x_1429;
        if (x_1429) {
          let x_1436 = (tint_symbol_93.tint_symbol_60.z <= tint_symbol_54_1.tint_symbol_23.z);
          x_1444 = x_1436;
          if (x_1436) {
            x_1443 = (tint_symbol_54_1.tint_symbol_23.z <= tint_symbol_93.tint_symbol_62.z);
            x_1444 = x_1443;
          }
          x_1445 = x_1444;
        }
        tint_symbol_54_1.tint_symbol_48 = x_1445;
      } else {
        var x_1467 : bool;
        var x_1468 : bool;
        var x_1483 : bool;
        var x_1484 : bool;
        if ((abs((tint_symbol_93.tint_symbol_60.x - tint_symbol_93.tint_symbol_62.x)) <= 0.00000000999999993923f)) {
          let x_1460 = (tint_symbol_93.tint_symbol_60.y <= tint_symbol_54_1.tint_symbol_23.y);
          x_1468 = x_1460;
          if (x_1460) {
            x_1467 = (tint_symbol_54_1.tint_symbol_23.y <= tint_symbol_93.tint_symbol_62.y);
            x_1468 = x_1467;
          }
          var x_1482 : bool;
          x_1484 = x_1468;
          if (x_1468) {
            let x_1475 = (tint_symbol_93.tint_symbol_60.z <= tint_symbol_54_1.tint_symbol_23.z);
            x_1483 = x_1475;
            if (x_1475) {
              x_1482 = (tint_symbol_54_1.tint_symbol_23.z <= tint_symbol_93.tint_symbol_62.z);
              x_1483 = x_1482;
            }
            x_1484 = x_1483;
          }
          tint_symbol_54_1.tint_symbol_48 = x_1484;
        }
      }
    }
    if (tint_symbol_54_1.tint_symbol_48) {
      tint_symbol_95 = -1.0f;
      if ((tint_symbol_30_4.x > 0.00000000999999993923f)) {
        tint_symbol_95 = ((tint_symbol_54_1.tint_symbol_23.x - tint_symbol_1_1.x) / tint_symbol_30_4.x);
      } else {
        if ((tint_symbol_30_4.y > 0.00000000999999993923f)) {
          tint_symbol_95 = ((tint_symbol_54_1.tint_symbol_23.y - tint_symbol_1_1.y) / tint_symbol_30_4.y);
        } else {
          tint_symbol_95 = ((tint_symbol_54_1.tint_symbol_23.z - tint_symbol_1_1.z) / tint_symbol_30_4.z);
        }
      }
      if ((tint_symbol_95 < 0.0f)) {
        tint_return_flag_1 = true;
        tint_return_value_1 = vec2f(tint_symbol_94, -1.0f);
      } else {
        if ((tint_symbol_94 < 0.0f)) {
          tint_return_flag_1 = true;
          tint_return_value_1 = vec2f(tint_symbol_95, 1.0f);
        } else {
          if ((tint_symbol_95 < tint_symbol_94)) {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_95, 1.0f);
          } else {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_94, -1.0f);
          }
        }
      }
    }
  }
  if (!(tint_return_flag_1)) {
    tint_return_flag_1 = true;
    tint_return_value_1 = vec2f(tint_symbol_94, -1.0f);
  }
  let x_1544 = tint_return_value_1;
  return x_1544;
}

fn tint_symbol_96(tint_symbol_1_2 : vec3f, tint_symbol_30_5 : vec3f) -> vec2f {
  var tint_symbol_97 = 0.0f;
  var tint_symbol_98 = 0.0f;
  var tint_symbol_99 = 0i;
  tint_symbol_97 = -1.0f;
  tint_symbol_98 = -1.0f;
  tint_symbol_99 = 0i;
  loop {
    if (!((tint_symbol_99 < 6i))) {
      break;
    }
    let x_1568 = tint_symbol_74.inner.tint_symbol_66[tint_symbol_99];
    let x_1569 = tint_symbol_97;
    let x_1564 = tint_symbol_92(tint_symbol_1_2, tint_symbol_30_5, x_1568, x_1569);
    if ((x_1564.y > 0.0f)) {
      tint_symbol_97 = x_1564.x;
      tint_symbol_98 = f32(tint_symbol_99);
    }

    continuing {
      tint_symbol_99 = (tint_symbol_99 + 1i);
    }
  }
  let x_1579 = tint_symbol_97;
  let x_1580 = tint_symbol_98;
  return vec2f(x_1579, x_1580);
}

const x_1585 = vec4f(0.0f, 0.0f, 0.0f, 1.0f);

fn tint_symbol_101() -> vec4f {
  return x_1585;
}

fn tint_symbol_102(tint_symbol_98_1 : i32) -> vec4f {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = vec4f();
  switch(tint_symbol_98_1) {
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
      tint_return_value_2 = x_1585;
    }
  }
  let x_1621 = tint_return_value_2;
  return x_1621;
}

const x_1638 = vec3f(0.0f, -1.0f, 0.0f);

const x_1637 = vec3f(-1.0f, 0.0f, 0.0f);

const x_1636 = vec3f(0.0f, 0.0f, -1.0f);

fn tint_symbol_103(tint_symbol_98_2 : i32) -> vec3f {
  var tint_return_flag_3 = false;
  var tint_return_value_3 = vec3f();
  switch(tint_symbol_98_2) {
    case 5i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1638;
    }
    case 4i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1638;
    }
    case 3i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1637;
    }
    case 2i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1637;
    }
    case 1i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1636;
    }
    case 0i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1636;
    }
    default: {
      tint_return_flag_3 = true;
      tint_return_value_3 = vec3f();
    }
  }
  let x_1639 = tint_return_value_3;
  return x_1639;
}

fn tint_symbol_105(tint_symbol_106 : i32, tint_symbol_107 : vec3f) -> vec2f {
  var tint_return_flag_4 = false;
  var tint_return_value_4 = vec2f();
  switch(tint_symbol_106) {
    case 5i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_107.x + 0.5f), (tint_symbol_107.z + 0.5f));
    }
    case 4i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_107.x + 0.5f), (0.5f - tint_symbol_107.z));
    }
    case 3i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((0.5f - tint_symbol_107.z), (tint_symbol_107.y + 0.5f));
    }
    case 2i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_107.z + 0.5f), (tint_symbol_107.y + 0.5f));
    }
    case 1i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((0.5f - tint_symbol_107.x), (tint_symbol_107.y + 0.5f));
    }
    case 0i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f((tint_symbol_107.x + 0.5f), (tint_symbol_107.y + 0.5f));
    }
    default: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec2f();
    }
  }
  let x_1686 = tint_return_value_4;
  return x_1686;
}

const x_1698 = vec3f(0.29899999499320983887f, 0.58700001239776611328f, 0.11400000005960464478f);

fn tint_symbol_108(tint_symbol_106_1 : i32, tint_symbol_109 : vec2f) -> vec3f {
  var tint_return_flag_5 = false;
  var tint_return_value_5 = vec3f();
  let x_1700 = dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, tint_symbol_109, 0.0f).xyz, x_1698);
  let x_1724 = ((dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, (tint_symbol_109 + vec2f(0.001953125f, 0.0f)), 0.0f).xyz, x_1698) - x_1700) * 4.0f);
  let x_1726 = ((dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, (tint_symbol_109 + vec2f(0.0f, 0.001953125f)), 0.0f).xyz, x_1698) - x_1700) * 4.0f);
  switch(tint_symbol_106_1) {
    case 5i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-(x_1724), -1.0f, -(x_1726)));
    }
    case 4i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-(x_1724), -1.0f, x_1726));
    }
    case 3i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-1.0f, -(x_1726), x_1724));
    }
    case 2i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-1.0f, -(x_1726), -(x_1724)));
    }
    case 1i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(x_1724, -(x_1726), -1.0f));
    }
    case 0i: {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f(-(x_1724), -(x_1726), -1.0f));
    }
    default: {
      tint_return_flag_5 = true;
      tint_return_value_5 = x_1636;
    }
  }
  let x_1756 = tint_return_value_5;
  return x_1756;
}

fn tint_symbol_120(tint_symbol_121 : vec3f, tint_symbol_122 : vec3f, tint_symbol_123 : vec3f) -> tint_symbol_118 {
  var tint_symbol_87_4 = tint_symbol_118(vec4f(), vec3f());
  var x_1816 = vec4f();
  var x_1839 = vec4f();
  var x_1767 : i32;
  let x_1770 = tint_symbol_76.inner.tint_symbol_72.z;
  x_1767 = tint_ftoi(x_1770);
  if ((x_1767 == 1i)) {
    tint_symbol_87_4.tint_symbol_68 = tint_symbol_76.inner.tint_symbol_68;
    tint_symbol_87_4.tint_symbol_119 = normalize(tint_symbol_122);
  } else {
    if ((x_1767 == 2i)) {
      let x_1784 = normalize((tint_symbol_123 - tint_symbol_121));
      let x_1786 = dot(normalize(tint_symbol_122), x_1784);
      let x_1791 = tint_symbol_76.inner.tint_symbol_72.y;
      if ((x_1786 > cos(tint_symbol_76.inner.tint_symbol_72[0i]))) {
        let x_1798 = length((tint_symbol_123 - tint_symbol_121));
        tint_symbol_87_4.tint_symbol_68 = ((tint_symbol_76.inner.tint_symbol_68 * pow(x_1786, x_1791)) / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_1798 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_1798 * x_1798) * tint_symbol_76.inner.tint_symbol_71.z))));
      } else {
        tint_symbol_87_4.tint_symbol_68 = vec4f();
      }
      tint_symbol_87_4.tint_symbol_119 = x_1784;
    } else {
      let x_1822 = length((tint_symbol_123 - tint_symbol_121));
      tint_symbol_87_4.tint_symbol_68 = (tint_symbol_76.inner.tint_symbol_68 / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_1822 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_1822 * x_1822) * tint_symbol_76.inner.tint_symbol_71.z))));
      tint_symbol_87_4.tint_symbol_119 = normalize((tint_symbol_123 - tint_symbol_121));
    }
  }
  let x_1842 = tint_symbol_87_4;
  return x_1842;
}

fn tint_symbol_132(tint_symbol_133 : f32) -> f32 {
  var tint_return_flag_6 = false;
  var tint_return_value_6 = 0.0f;
  if ((tint_symbol_133 < 0.10000000149011611938f)) {
    tint_return_flag_6 = true;
    tint_return_value_6 = 0.0f;
  } else {
    if ((tint_symbol_133 < 0.34999999403953552246f)) {
      tint_return_flag_6 = true;
      tint_return_value_6 = 0.20000000298023223877f;
    } else {
      if ((tint_symbol_133 < 0.64999997615814208984f)) {
        tint_return_flag_6 = true;
        tint_return_value_6 = 0.5f;
      } else {
        if ((tint_symbol_133 < 0.89999997615814208984f)) {
          tint_return_flag_6 = true;
          tint_return_value_6 = 0.80000001192092895508f;
        } else {
          tint_return_flag_6 = true;
          tint_return_value_6 = 1.0f;
        }
      }
    }
  }
  let x_1871 = tint_return_value_6;
  return x_1871;
}

const x_1904 = vec4f(0.5f, 0.5f, 0.5f, 0.0f);

const x_1905 = vec4f(0.10000000149011611938f, 0.10000000149011611938f, 0.10000000149011611938f, 0.0f);

fn tint_symbol_134(tint_symbol_135 : vec4f, tint_symbol_136 : vec4f, tint_symbol_137 : vec3f, tint_symbol_138 : tint_symbol_118, tint_symbol_139 : vec3f, tint_symbol_140 : vec3f) -> vec4f {
  var tint_return_flag_7 = false;
  var tint_return_value_7 = vec4f();
  var x_1883 : vec3f;
  var x_1884 : vec4f;
  var x_1885 : i32;
  var x_1889 : f32;
  x_1883 = tint_symbol_138.tint_symbol_119;
  x_1884 = tint_symbol_138.tint_symbol_68;
  let x_1888 = tint_symbol_76.inner.tint_symbol_72.w;
  x_1885 = tint_ftoi(x_1888);
  x_1889 = max(dot(tint_symbol_137, -(x_1883)), 0.0f);
  if ((x_1885 == 1i)) {
    tint_return_flag_7 = true;
    tint_return_value_7 = (((tint_symbol_135 + ((tint_symbol_136 * x_1884) * x_1889)) + ((x_1904 * x_1884) * pow(max(dot(normalize((tint_symbol_139 - tint_symbol_140)), -(reflect(x_1883, tint_symbol_137))), 0.0f), 64.0f))) + (x_1905 * x_1884));
  } else {
    if ((x_1885 == 2i)) {
      let x_1925 = tint_symbol_132(x_1889);
      let x_1926 = tint_symbol_132(pow(max(dot(normalize((tint_symbol_139 - tint_symbol_140)), -(reflect(x_1883, tint_symbol_137))), 0.0f), 64.0f));
      tint_return_flag_7 = true;
      tint_return_value_7 = (((tint_symbol_135 + ((tint_symbol_136 * x_1884) * x_1925)) + ((x_1904 * x_1884) * x_1926)) + (x_1905 * x_1884));
    } else {
      tint_return_flag_7 = true;
      tint_return_value_7 = (tint_symbol_135 + ((tint_symbol_136 * x_1884) * x_1889));
    }
  }
  let x_1938 = tint_return_value_7;
  return x_1938;
}

fn tint_symbol_152(tint_symbol_153 : vec3f, tint_symbol_154 : vec3f, tint_symbol_54_2 : vec2f) -> vec4f {
  var tint_return_flag_8 = false;
  var tint_return_value_8 = vec4f();
  var tint_symbol_136_1 = vec4f();
  var tint_symbol_137_1 = vec3f();
  var tint_symbol_140_1 = vec3f();
  var x_1973 : bool;
  var x_1974 : bool;
  var x_1975 : bool;
  let x_1947 = tint_ftoi(tint_symbol_54_2.y);
  let x_1951 = (tint_symbol_153 + (tint_symbol_154 * tint_symbol_54_2.x));
  let x_1954 = tint_symbol_74.inner.tint_symbol_65;
  let x_1958 = tint_symbol_74.inner.tint_symbol_56;
  let x_1952 = tint_symbol_45((tint_symbol_154 * x_1954.xyz), x_1958);
  let x_1959 = normalize(x_1952);
  let x_1964 = (tint_symbol_85.inner.tint_symbol_83 != 0u);
  x_1975 = x_1964;
  if (x_1964) {
    let x_1969 = (tint_symbol_85.inner.tint_symbol_81 == 0u);
    x_1974 = x_1969;
    if (x_1969) {
    } else {
      x_1973 = (x_1947 != 5i);
      x_1974 = x_1973;
    }
    x_1975 = x_1974;
  }
  if (x_1975) {
    tint_return_flag_8 = true;
    tint_return_value_8 = textureSampleLevel(tint_symbol_79, tint_symbol_77, x_1959, 0.0f);
  }
  var x_1996 : bool;
  var x_1997 : bool;
  if (!(tint_return_flag_8)) {
    let x_1987 = tint_symbol_105(x_1947, x_1951);
    let x_1988 = (x_1987 * 4.0f);
    let x_1989 = tint_symbol_102(x_1947);
    tint_symbol_136_1 = x_1989;
    let x_1993 = (tint_symbol_85.inner.tint_symbol_81 != 0u);
    x_1997 = x_1993;
    if (x_1993) {
      x_1996 = (x_1947 == 5i);
      x_1997 = x_1996;
    }
    if (x_1997) {
      tint_symbol_136_1 = textureSampleLevel(tint_symbol_78, tint_symbol_77, x_1988, 0.0f);
    }
    let x_2004 = tint_symbol_103(x_1947);
    tint_symbol_137_1 = x_2004;
    if ((tint_symbol_85.inner.tint_symbol_82 != 0u)) {
      let x_2011 = tint_symbol_108(x_1947, x_1988);
      tint_symbol_137_1 = x_2011;
    }
    let x_2013 = tint_symbol_137_1;
    let x_2012 = tint_symbol_90(x_2013);
    tint_symbol_137_1 = x_2012;
    let x_2014 = tint_symbol_101();
    let x_2017 = tint_symbol_73.inner.tint_symbol_56;
    let x_2015 = tint_symbol_21(x_2017);
    let x_2020 = tint_symbol_76.inner.tint_symbol_69;
    let x_2018 = tint_symbol_44(x_2020.xyz, x_2015);
    let x_2024 = tint_symbol_73.inner.tint_symbol_56;
    let x_2022 = tint_symbol_21(x_2024);
    let x_2027 = tint_symbol_76.inner.tint_symbol_70;
    let x_2025 = tint_symbol_45(x_2027.xyz, x_2022);
    tint_symbol_140_1 = x_1951;
    let x_2031 = tint_symbol_140_1;
    let x_2030 = tint_symbol_91(x_2031);
    tint_symbol_140_1 = x_2030;
    let x_2033 = tint_symbol_140_1;
    let x_2032 = tint_symbol_120(x_2018, x_2025, x_2033);
    let x_2036 = tint_symbol_73.inner.tint_symbol_56;
    let x_2034 = tint_symbol_44(vec3f(), x_2036);
    tint_return_flag_8 = true;
    let x_2038 = tint_symbol_136_1;
    let x_2039 = tint_symbol_137_1;
    let x_2040 = tint_symbol_140_1;
    let x_2037 = tint_symbol_134(x_2014, x_2038, x_2039, x_2032, x_2034, x_2040);
    tint_return_value_8 = x_2037;
  }
  let x_2041 = tint_return_value_8;
  return x_2041;
}

const x_2066 = vec2f(2.0f);

const x_2098 = vec4f(0.0f, 0.21960784494876861572f, 0.39607843756675720215f, 1.0f);

fn tint_symbol_158_inner(tint_symbol_159 : vec3u) {
  var tint_symbol_153_1 = vec3f();
  var tint_symbol_154_1 = vec3f();
  var tint_symbol_54_3 = vec2f();
  var tint_symbol_162 = vec4f();
  var x_2061 : bool;
  var x_2062 : bool;
  let x_2047 = bitcast<vec2i>(tint_symbol_159.xy);
  let x_2051 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_2056 = (x_2047.x >= x_2051.x);
  x_2062 = x_2056;
  if (x_2056) {
  } else {
    x_2061 = (x_2047.y >= x_2051.y);
    x_2062 = x_2061;
  }
  if (x_2062) {
    return;
  }
  let x_2071 = (x_2066 / tint_symbol_73.inner.tint_symbol_58.xy);
  tint_symbol_153_1 = vec3f((((f32(x_2047.x) + 0.5f) * x_2071.x) - 1.0f), (((f32(x_2047.y) + 0.5f) * x_2071.y) - 1.0f), 0.0f);
  tint_symbol_154_1 = vec3f(0.0f, 0.0f, 1.0f);
  let x_2089 = tint_symbol_153_1;
  let x_2088 = tint_symbol_88(x_2089);
  tint_symbol_153_1 = x_2088;
  let x_2091 = tint_symbol_154_1;
  let x_2090 = tint_symbol_86(x_2091);
  tint_symbol_154_1 = x_2090;
  let x_2093 = tint_symbol_153_1;
  let x_2094 = tint_symbol_154_1;
  let x_2092 = tint_symbol_96(x_2093, x_2094);
  tint_symbol_54_3 = x_2092;
  tint_symbol_162 = x_2098;
  if ((tint_symbol_54_3.x > 0.0f)) {
    let x_2106 = tint_symbol_153_1;
    let x_2107 = tint_symbol_154_1;
    let x_2108 = tint_symbol_54_3;
    let x_2105 = tint_symbol_152(x_2106, x_2107, x_2108);
    tint_symbol_162 = x_2105;
  }
  let x_2111 = tint_symbol_162;
  textureStore(tint_symbol_75, x_2047, x_2111);
  return;
}

fn tint_symbol_158_1() {
  let x_2116 = tint_symbol_159_1;
  tint_symbol_158_inner(x_2116);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMain(@builtin(global_invocation_id) tint_symbol_159_1_param : vec3u) {
  tint_symbol_159_1 = tint_symbol_159_1_param;
  tint_symbol_158_1();
}

fn tint_symbol_163_inner(tint_symbol_159_3 : vec3u) {
  var tint_symbol_153_2 = vec3f();
  var tint_symbol_154_2 = vec3f();
  var tint_symbol_54_4 = vec2f();
  var tint_symbol_162_1 = vec4f();
  var x_2132 : bool;
  var x_2133 : bool;
  let x_2120 = bitcast<vec2i>(tint_symbol_159_3.xy);
  let x_2122 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_2127 = (x_2120.x >= x_2122.x);
  x_2133 = x_2127;
  if (x_2127) {
  } else {
    x_2132 = (x_2120.y >= x_2122.y);
    x_2133 = x_2132;
  }
  if (x_2133) {
    return;
  }
  let x_2142 = (x_2066 / (tint_symbol_73.inner.tint_symbol_58.xy * tint_symbol_73.inner.tint_symbol_57));
  tint_symbol_153_2 = vec3f();
  tint_symbol_154_2 = normalize(vec3f((((f32(x_2120.x) + 0.5f) * x_2142.x) - (1.0f / tint_symbol_73.inner.tint_symbol_57.x)), (((f32(x_2120.y) + 0.5f) * x_2142.y) - (1.0f / tint_symbol_73.inner.tint_symbol_57.y)), 1.0f));
  let x_2166 = tint_symbol_153_2;
  let x_2165 = tint_symbol_88(x_2166);
  tint_symbol_153_2 = x_2165;
  let x_2168 = tint_symbol_154_2;
  let x_2167 = tint_symbol_86(x_2168);
  tint_symbol_154_2 = x_2167;
  let x_2170 = tint_symbol_153_2;
  let x_2171 = tint_symbol_154_2;
  let x_2169 = tint_symbol_96(x_2170, x_2171);
  tint_symbol_54_4 = x_2169;
  tint_symbol_162_1 = x_2098;
  if ((tint_symbol_54_4.x > 0.0f)) {
    let x_2180 = tint_symbol_153_2;
    let x_2181 = tint_symbol_154_2;
    let x_2182 = tint_symbol_54_4;
    let x_2179 = tint_symbol_152(x_2180, x_2181, x_2182);
    tint_symbol_162_1 = x_2179;
  }
  let x_2185 = tint_symbol_162_1;
  textureStore(tint_symbol_75, x_2120, x_2185);
  return;
}

fn tint_symbol_163_1() {
  let x_2189 = tint_symbol_159_2;
  tint_symbol_163_inner(x_2189);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMain(@builtin(global_invocation_id) tint_symbol_159_2_param : vec3u) {
  tint_symbol_159_2 = tint_symbol_159_2_param;
  tint_symbol_163_1();
}
