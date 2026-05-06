/*
 * Scroll 12 — Perlin Noise Terrain Renderer (WebGPU / WGSL)
 *
 * Renders a procedurally generated Minecraft-like terrain volume built from
 * Perlin noise (2-D heightmap + 3-D cave carving) on the CPU side.
 *
 * Voxel types stored in volData:
 *   0 = air  (transparent — ray continues)
 *   1 = water
 *   2 = sand / beach
 *   3 = grass
 *   4 = dirt
 *   5 = stone
 *   6 = snow
 *
 * Traversal: DDA (Digital Differential Analyzer) — exact voxel stepping,
 * one voxel at a time, no over-sampling or under-sampling.
 *
 * Shading: Lambertian approximation using the hit face normal.
 *   top face    (y+) → full brightness (sun from above)
 *   east/west   (x)  → 0.75 ×
 *   north/south (z)  → 0.70 ×
 *   bottom face (y−) → 0.55 ×
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

var<private> tint_symbol_102_1 : vec3u;

var<private> tint_symbol_102_2 : vec3u;

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
  let x_849 = tint_symbol_20;
  return x_849;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_885 = tint_symbol_21(tint_symbol_24);
  let x_886 = tint_symbol_17(tint_symbol_23, x_885);
  let x_887 = tint_symbol_17(tint_symbol_24, x_886);
  return x_887;
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
  let x_976 = tint_symbol_26;
  return sqrt(x_976);
}

fn tint_symbol_27(tint_symbol_28 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_28.z, -(tint_symbol_28.y), tint_symbol_28.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_32(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_993 = tint_symbol_25(tint_symbol_24_2);
  if ((x_993 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_2.tint_symbol_1 / x_993), (tint_symbol_24_2.tint_symbol_2 / x_993), (tint_symbol_24_2.tint_symbol_3 / x_993), (tint_symbol_24_2.tint_symbol_4 / x_993), (tint_symbol_24_2.tint_symbol_5 / x_993), (tint_symbol_24_2.tint_symbol_6 / x_993), (tint_symbol_24_2.tint_symbol_7 / x_993), (tint_symbol_24_2.tint_symbol_8 / x_993), (tint_symbol_24_2.tint_symbol_9 / x_993), (tint_symbol_24_2.tint_symbol_10 / x_993), (tint_symbol_24_2.tint_symbol_11 / x_993), (tint_symbol_24_2.tint_symbol_12 / x_993), (tint_symbol_24_2.tint_symbol_13 / x_993), (tint_symbol_24_2.tint_symbol_14 / x_993), (tint_symbol_24_2.tint_symbol_15 / x_993), (tint_symbol_24_2.tint_symbol_16 / x_993));
  }
  let x_1037 = tint_return_value;
  return x_1037;
}

fn tint_symbol_29(tint_symbol_1 : vec3f, tint_symbol_28_1 : vec3f) -> tint_symbol {
  let x_1043 = tint_symbol_27(tint_symbol_28_1);
  let x_1044 = tint_symbol_32(x_1043);
  return tint_symbol(0.0f, x_1044.tint_symbol_2, x_1044.tint_symbol_3, x_1044.tint_symbol_4, -(((-(x_1044.tint_symbol_3) * tint_symbol_1.z) - (x_1044.tint_symbol_2 * tint_symbol_1.y))), -(((x_1044.tint_symbol_2 * tint_symbol_1.x) - (x_1044.tint_symbol_4 * tint_symbol_1.z))), -(((x_1044.tint_symbol_4 * tint_symbol_1.y) + (x_1044.tint_symbol_3 * tint_symbol_1.x))), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
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
  let x_1112 = tint_symbol_34(tint_symbol_23_3);
  let x_1113 = tint_symbol_22(x_1112, tint_symbol_24_4);
  let x_1114 = tint_symbol_35(x_1113);
  return x_1114;
}

fn tint_symbol_38(tint_symbol_28_2 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1119 = tint_symbol_36(tint_symbol_24_5);
  let x_1120 = tint_symbol_34(tint_symbol_28_2);
  let x_1121 = tint_symbol_22(x_1120, x_1119);
  let x_1122 = tint_symbol_35(x_1121);
  return x_1122;
}

fn tint_symbol_51(tint_symbol_52 : vec3f) -> vec3f {
  let x_1130 = tint_symbol_47.inner.tint_symbol_41;
  let x_1127 = tint_symbol_37(tint_symbol_52, x_1130);
  return x_1127;
}

fn tint_symbol_53(tint_symbol_28_3 : vec3f) -> vec3f {
  let x_1136 = tint_symbol_47.inner.tint_symbol_41;
  let x_1134 = tint_symbol_38(tint_symbol_28_3, x_1136);
  return x_1134;
}

fn tint_symbol_55(tint_symbol_56 : vec2f, tint_symbol_57 : f32) -> vec2f {
  var tint_symbol_58 = vec2f();
  tint_symbol_58 = tint_symbol_56;
  if ((tint_symbol_56.x < 0.0f)) {
    tint_symbol_58.x = tint_symbol_57;
  } else {
    var x_1164 : bool;
    var x_1165 : bool;
    if ((tint_symbol_57 < tint_symbol_56.x)) {
      tint_symbol_58.y = tint_symbol_56.x;
      tint_symbol_58.x = tint_symbol_57;
    } else {
      let x_1160 = (tint_symbol_56.y < 0.0f);
      x_1165 = x_1160;
      if (x_1160) {
      } else {
        x_1164 = (tint_symbol_57 < tint_symbol_56.y);
        x_1165 = x_1164;
      }
      if (x_1165) {
        tint_symbol_58.y = tint_symbol_57;
      }
    }
  }
  let x_1169 = tint_symbol_58;
  return x_1169;
}

fn tint_symbol_59(tint_symbol_60 : f32, tint_symbol_61 : vec2f, tint_symbol_62 : f32, tint_symbol_63 : f32, tint_symbol_23_4 : vec2f, tint_symbol_28_4 : vec2f, tint_symbol_64 : vec2f) -> vec2f {
  var tint_symbol_65 = vec2f();
  tint_symbol_65 = tint_symbol_64;
  if ((abs(tint_symbol_63) > 0.00000000999999993923f)) {
    var x_1187 : f32;
    var x_1201 : bool;
    var x_1202 : bool;
    var x_1208 : bool;
    var x_1209 : bool;
    var x_1214 : bool;
    var x_1215 : bool;
    x_1187 = ((tint_symbol_60 - tint_symbol_62) / tint_symbol_63);
    if ((x_1187 > 0.0f)) {
      let x_1192 = (tint_symbol_23_4 + (tint_symbol_28_4 * x_1187));
      let x_1196 = (-(tint_symbol_61.x) < x_1192.x);
      x_1202 = x_1196;
      if (x_1196) {
        x_1201 = (x_1192.x < tint_symbol_61.x);
        x_1202 = x_1201;
      }
      x_1209 = x_1202;
      if (x_1202) {
        x_1208 = (-(tint_symbol_61.y) < x_1192.y);
        x_1209 = x_1208;
      }
      x_1215 = x_1209;
      if (x_1209) {
        x_1214 = (x_1192.y < tint_symbol_61.y);
        x_1215 = x_1214;
      }
      if (x_1215) {
        let x_1219 = tint_symbol_65;
        let x_1218 = tint_symbol_55(x_1219, x_1187);
        tint_symbol_65 = x_1218;
      }
    }
  }
  let x_1220 = tint_symbol_65;
  return x_1220;
}

fn tint_symbol_67(tint_symbol_23_5 : vec3f, tint_symbol_28_5 : vec3f) -> vec2f {
  var tint_symbol_68 = vec2f();
  var x_1247 = vec4f();
  tint_symbol_68 = vec2f(-1.0f);
  let x_1246 = (((tint_symbol_48.inner.tint_symbol_45 * tint_symbol_48.inner.tint_symbol_46) * 0.5f) / vec4f(max(max(tint_symbol_48.inner.tint_symbol_45.x, tint_symbol_48.inner.tint_symbol_45.y), tint_symbol_48.inner.tint_symbol_45.z)));
  let x_1258 = tint_symbol_68;
  let x_1251 = tint_symbol_59(x_1246.z, x_1246.xy, tint_symbol_23_5.z, tint_symbol_28_5.z, tint_symbol_23_5.xy, tint_symbol_28_5.xy, x_1258);
  tint_symbol_68 = x_1251;
  let x_1267 = tint_symbol_68;
  let x_1259 = tint_symbol_59(-(x_1246.z), x_1246.xy, tint_symbol_23_5.z, tint_symbol_28_5.z, tint_symbol_23_5.xy, tint_symbol_28_5.xy, x_1267);
  tint_symbol_68 = x_1259;
  let x_1276 = tint_symbol_68;
  let x_1268 = tint_symbol_59(-(x_1246.x), x_1246.yz, tint_symbol_23_5.x, tint_symbol_28_5.x, tint_symbol_23_5.yz, tint_symbol_28_5.yz, x_1276);
  tint_symbol_68 = x_1268;
  let x_1284 = tint_symbol_68;
  let x_1277 = tint_symbol_59(x_1246.x, x_1246.yz, tint_symbol_23_5.x, tint_symbol_28_5.x, tint_symbol_23_5.yz, tint_symbol_28_5.yz, x_1284);
  tint_symbol_68 = x_1277;
  let x_1292 = tint_symbol_68;
  let x_1285 = tint_symbol_59(x_1246.y, x_1246.xz, tint_symbol_23_5.y, tint_symbol_28_5.y, tint_symbol_23_5.xz, tint_symbol_28_5.xz, x_1292);
  tint_symbol_68 = x_1285;
  let x_1301 = tint_symbol_68;
  let x_1293 = tint_symbol_59(-(x_1246.y), x_1246.xz, tint_symbol_23_5.y, tint_symbol_28_5.y, tint_symbol_23_5.xz, tint_symbol_28_5.xz, x_1301);
  tint_symbol_68 = x_1293;
  let x_1302 = tint_symbol_68;
  return x_1302;
}

fn tint_symbol_69(tint_symbol_70 : vec2f) -> vec2f {
  var tint_symbol_71 = vec2f();
  var x_1315 : bool;
  var x_1316 : bool;
  tint_symbol_71 = tint_symbol_70;
  let x_1310 = (tint_symbol_71.y < 0.0f);
  x_1316 = x_1310;
  if (x_1310) {
    x_1315 = (tint_symbol_71.x > 0.0f);
    x_1316 = x_1315;
  }
  if (x_1316) {
    tint_symbol_71.y = tint_symbol_71.x;
    tint_symbol_71.x = 0.0f;
  }
  let x_1323 = tint_symbol_71;
  return x_1323;
}

fn tint_symbol_73(tint_symbol_74 : i32, tint_symbol_75 : i32, tint_symbol_76 : i32) -> vec3f {
  var tint_symbol_77 = vec3f();
  var tint_symbol_78 = 0.0f;
  switch(tint_symbol_74) {
    case 6i: {
      tint_symbol_77 = vec3f(0.93999999761581420898f, 0.93999999761581420898f, 1.0f);
    }
    case 5i: {
      tint_symbol_77 = vec3f(0.50999999046325683594f, 0.50999999046325683594f, 0.49000000953674316406f);
    }
    case 4i: {
      tint_symbol_77 = vec3f(0.46999999880790710449f, 0.33000001311302185059f, 0.21999999880790710449f);
    }
    case 3i: {
      tint_symbol_77 = vec3f(0.33000001311302185059f, 0.58999997377395629883f, 0.27000001072883605957f);
    }
    case 2i: {
      tint_symbol_77 = vec3f(0.81999999284744262695f, 0.76999998092651367188f, 0.54000002145767211914f);
    }
    case 1i: {
      tint_symbol_77 = vec3f(0.11999999731779098511f, 0.38999998569488525391f, 0.77999997138977050781f);
    }
    default: {
      tint_symbol_77 = vec3f(1.0f, 0.0f, 1.0f);
    }
  }
  if ((tint_symbol_75 == 1i)) {
    tint_symbol_78 = select(0.55000001192092895508f, 1.0f, (tint_symbol_76 < 0i));
  } else {
    if ((tint_symbol_75 == 0i)) {
      tint_symbol_78 = 0.75f;
    } else {
      tint_symbol_78 = 0.69999998807907104492f;
    }
  }
  let x_1378 = tint_symbol_77;
  let x_1379 = tint_symbol_78;
  return (x_1378 * x_1379);
}

const x_1401 = vec4f(0.51999998092651367188f, 0.73000001907348632812f, 0.89999997615814208984f, 1.0f);

fn tint_symbol_79(tint_symbol_80 : vec2i, tint_symbol_23_6 : vec3f, tint_symbol_28_6 : vec3f) {
  var tint_return_flag_1 = false;
  var x_1423 = vec3f();
  var tint_symbol_87 = vec3i();
  var tint_symbol_89 = vec3f();
  var tint_symbol_92 = vec3f();
  var tint_symbol_75_1 = 0i;
  var tint_symbol_93 = 0i;
  let x_1390 = tint_symbol_67(tint_symbol_23_6, tint_symbol_28_6);
  let x_1391 = tint_symbol_69(x_1390);
  if ((x_1391.x < 0.0f)) {
    textureStore(tint_symbol_50, tint_symbol_80, x_1401);
    tint_return_flag_1 = true;
  }
  if (!(tint_return_flag_1)) {
    let x_1422 = (((tint_symbol_48.inner.tint_symbol_45.xyz * tint_symbol_48.inner.tint_symbol_46.xyz) * 0.5f) / vec3f(max(max(tint_symbol_48.inner.tint_symbol_45.x, tint_symbol_48.inner.tint_symbol_45.y), tint_symbol_48.inner.tint_symbol_45.z)));
    let x_1430 = ((x_1422 * 2.0f) / tint_symbol_48.inner.tint_symbol_45.xyz);
    let x_1439 = clamp(((((tint_symbol_23_6 + (tint_symbol_28_6 * (x_1391.x + 0.00000999999974737875f))) + x_1422) / (x_1422 * 2.0f)) * tint_symbol_48.inner.tint_symbol_45.xyz), vec3f(), (tint_symbol_48.inner.tint_symbol_45.xyz - vec3f(0.00009999999747378752f)));
    let x_1450 = tint_ftoi(floor(x_1439));
    tint_symbol_87 = x_1450;
    let x_1455 = tint_ftoi(sign(tint_symbol_28_6));
    let x_1457 = tint_ftoi_1(sign(tint_symbol_28_6.y));
    tint_symbol_89.x = select(1000000015047466219876688855040.0f, (x_1430.x / abs(tint_symbol_28_6.x)), (abs(tint_symbol_28_6.x) > 0.00000000999999993923f));
    tint_symbol_89.y = select(1000000015047466219876688855040.0f, (x_1430.y / abs(tint_symbol_28_6.y)), (abs(tint_symbol_28_6.y) > 0.00000000999999993923f));
    tint_symbol_89.z = select(1000000015047466219876688855040.0f, (x_1430.z / abs(tint_symbol_28_6.z)), (abs(tint_symbol_28_6.z) > 0.00000000999999993923f));
    let x_1520 = ((((vec3f(select(floor(x_1439.x), (floor(x_1439.x) + 1.0f), (tint_symbol_28_6.x > 0.0f)), select(floor(x_1439.y), (floor(x_1439.y) + 1.0f), (tint_symbol_28_6.y > 0.0f)), select(floor(x_1439.z), (floor(x_1439.z) + 1.0f), (tint_symbol_28_6.z > 0.0f))) / tint_symbol_48.inner.tint_symbol_45.xyz) * 2.0f) * x_1422) - x_1422);
    tint_symbol_92.x = select(1000000015047466219876688855040.0f, ((x_1520.x - tint_symbol_23_6.x) / tint_symbol_28_6.x), (abs(tint_symbol_28_6.x) > 0.00000000999999993923f));
    tint_symbol_92.y = select(1000000015047466219876688855040.0f, ((x_1520.y - tint_symbol_23_6.y) / tint_symbol_28_6.y), (abs(tint_symbol_28_6.y) > 0.00000000999999993923f));
    tint_symbol_92.z = select(1000000015047466219876688855040.0f, ((x_1520.z - tint_symbol_23_6.z) / tint_symbol_28_6.z), (abs(tint_symbol_28_6.z) > 0.00000000999999993923f));
    tint_symbol_75_1 = 1i;
    tint_symbol_93 = 0i;
    loop {
      var x_1570 : bool;
      var x_1577 : bool;
      var x_1627 : bool;
      var x_1628 : bool;
      if (!((tint_symbol_93 < 400i))) {
        break;
      }
      let x_1565 = any((tint_symbol_87 < vec3i()));
      x_1577 = x_1565;
      if (x_1565) {
      } else {
        let x_1571 = tint_symbol_87;
        let x_1574 = tint_symbol_48.inner.tint_symbol_45;
        let x_1572 = tint_ftoi(x_1574.xyz);
        x_1570 = any((x_1571 >= x_1572));
        x_1577 = x_1570;
      }
      if (x_1577) {
        break;
      }
      let x_1581 = tint_symbol_87.z;
      let x_1584 = tint_symbol_48.inner.tint_symbol_45.x;
      let x_1582 = tint_ftoi_1(x_1584);
      let x_1588 = tint_symbol_48.inner.tint_symbol_45.y;
      let x_1586 = tint_ftoi_1(x_1588);
      let x_1591 = tint_symbol_87.y;
      let x_1594 = tint_symbol_48.inner.tint_symbol_45.x;
      let x_1592 = tint_ftoi_1(x_1594);
      let x_1604 = tint_symbol_49.inner[((((x_1581 * x_1582) * x_1586) + (x_1591 * x_1592)) + tint_symbol_87.x)];
      let x_1600 = tint_ftoi_1(round(x_1604));
      if ((x_1600 > 0i)) {
        let x_1609 = tint_symbol_75_1;
        let x_1608 = tint_symbol_73(x_1600, x_1609, x_1457);
        textureStore(tint_symbol_50, tint_symbol_80, vec4f(x_1608.x, x_1608.y, x_1608.z, 1.0f));
        tint_return_flag_1 = true;
        break;
      }
      let x_1620 = (tint_symbol_92.x < tint_symbol_92.y);
      x_1628 = x_1620;
      if (x_1620) {
        x_1627 = (tint_symbol_92.x < tint_symbol_92.z);
        x_1628 = x_1627;
      }
      if (x_1628) {
        if ((tint_symbol_92.x > x_1391.y)) {
          break;
        }
        tint_symbol_92.x = (tint_symbol_92.x + tint_symbol_89.x);
        tint_symbol_87.x = (tint_symbol_87.x + x_1455.x);
        tint_symbol_75_1 = 0i;
      } else {
        if ((tint_symbol_92.y < tint_symbol_92.z)) {
          if ((tint_symbol_92.y > x_1391.y)) {
            break;
          }
          tint_symbol_92.y = (tint_symbol_92.y + tint_symbol_89.y);
          tint_symbol_87.y = (tint_symbol_87.y + x_1455.y);
          tint_symbol_75_1 = 1i;
        } else {
          if ((tint_symbol_92.z > x_1391.y)) {
            break;
          }
          tint_symbol_92.z = (tint_symbol_92.z + tint_symbol_89.z);
          tint_symbol_87.z = (tint_symbol_87.z + x_1455.z);
          tint_symbol_75_1 = 2i;
        }
      }

      continuing {
        tint_symbol_93 = (tint_symbol_93 + 1i);
      }
    }
    if (!(tint_return_flag_1)) {
      textureStore(tint_symbol_50, tint_symbol_80, x_1401);
    }
  }
  return;
}

const x_1705 = vec2f(2.0f);

fn tint_symbol_96(tint_symbol_80_1 : vec2i) -> Arr {
  var tint_symbol_98 = vec3f();
  var tint_symbol_99 = vec3f();
  let x_1710 = (x_1705 / tint_symbol_47.inner.tint_symbol_43.xy);
  tint_symbol_98 = vec3f((((f32(tint_symbol_80_1.x) + 0.5f) * x_1710.x) - 1.0f), (((f32(tint_symbol_80_1.y) + 0.5f) * x_1710.y) - 1.0f), 0.0f);
  tint_symbol_99 = vec3f(0.0f, 0.0f, 1.0f);
  let x_1728 = tint_symbol_98;
  let x_1727 = tint_symbol_51(x_1728);
  tint_symbol_98 = x_1727;
  let x_1730 = tint_symbol_99;
  let x_1729 = tint_symbol_53(x_1730);
  tint_symbol_99 = x_1729;
  let x_1731 = tint_symbol_98;
  let x_1732 = tint_symbol_99;
  return Arr(x_1731, x_1732);
}

fn tint_symbol_100(tint_symbol_80_2 : vec2i) -> Arr {
  var tint_symbol_98_1 = vec3f();
  var tint_symbol_99_1 = vec3f();
  let x_1743 = (x_1705 / (tint_symbol_47.inner.tint_symbol_43.xy * tint_symbol_47.inner.tint_symbol_42));
  tint_symbol_98_1 = vec3f();
  tint_symbol_99_1 = normalize(vec3f((((f32(tint_symbol_80_2.x) + 0.5f) * x_1743.x) - (1.0f / tint_symbol_47.inner.tint_symbol_42.x)), (((f32(tint_symbol_80_2.y) + 0.5f) * x_1743.y) - (1.0f / tint_symbol_47.inner.tint_symbol_42.y)), 1.0f));
  let x_1767 = tint_symbol_98_1;
  let x_1766 = tint_symbol_51(x_1767);
  tint_symbol_98_1 = x_1766;
  let x_1769 = tint_symbol_99_1;
  let x_1768 = tint_symbol_53(x_1769);
  tint_symbol_99_1 = x_1768;
  let x_1770 = tint_symbol_98_1;
  let x_1771 = tint_symbol_99_1;
  return Arr(x_1770, x_1771);
}

fn tint_symbol_101_inner(tint_symbol_102 : vec3u) {
  var x_1790 : bool;
  var x_1791 : bool;
  let x_1777 = bitcast<vec2i>(tint_symbol_102.xy);
  let x_1780 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1785 = (x_1777.x < x_1780.x);
  x_1791 = x_1785;
  if (x_1785) {
    x_1790 = (x_1777.y < x_1780.y);
    x_1791 = x_1790;
  }
  if (x_1791) {
    let x_1794 = tint_symbol_96(x_1777);
    tint_symbol_79(x_1777, x_1794[0u], x_1794[1u]);
  }
  return;
}

fn tint_symbol_101_1() {
  let x_1802 = tint_symbol_102_1;
  tint_symbol_101_inner(x_1802);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalTerrainMain(@builtin(global_invocation_id) tint_symbol_102_1_param : vec3u) {
  tint_symbol_102_1 = tint_symbol_102_1_param;
  tint_symbol_101_1();
}

fn tint_symbol_105_inner(tint_symbol_102_3 : vec3u) {
  var x_1818 : bool;
  var x_1819 : bool;
  let x_1806 = bitcast<vec2i>(tint_symbol_102_3.xy);
  let x_1808 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_50)));
  let x_1813 = (x_1806.x < x_1808.x);
  x_1819 = x_1813;
  if (x_1813) {
    x_1818 = (x_1806.y < x_1808.y);
    x_1819 = x_1818;
  }
  if (x_1819) {
    let x_1822 = tint_symbol_100(x_1806);
    tint_symbol_79(x_1806, x_1822[0u], x_1822[1u]);
  }
  return;
}

fn tint_symbol_105_1() {
  let x_1829 = tint_symbol_102_2;
  tint_symbol_105_inner(x_1829);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveTerrainMain(@builtin(global_invocation_id) tint_symbol_102_2_param : vec3u) {
  tint_symbol_102_2 = tint_symbol_102_2_param;
  tint_symbol_105_1();
}
