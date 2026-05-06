/*
 * Project 7 — Comprehensive Volume Rendering Shader (WebGPU / WGSL)
 *
 * Rendering modes (orthogonal + projective camera for each):
 *   0. MIP        – Maximum Intensity Projection
 *   1. DRR        – Beer-Lambert absorption (X-ray simulation)
 *   2. LinearTF   – Linear transfer function (alpha compositing)
 *   3. Piecewise  – Piecewise-linear transfer function (multi-colour stops)
 *   4. Gradient   – Gradient (edge-detection) transfer function
 *   5. Spectral   – Spectral / rainbow transfer function
 *   6. WarmCool   – Warm-cool cinematic transfer function
 *   7. Terrain    – DDA voxel traversal (grass / snow / water / dirt biomes)
 *   8. Cloud      – Perlin-noise volumetric clouds (alpha compositing)
 *   9. Fire       – Turbulent-noise volumetric fire (alpha compositing)
 *  10. Smoke      – Rising-column smoke (alpha compositing)
 *  11. Composed   – Terrain DDA + cloud-layer alpha compositing
 *
 * Voxel data encoding:
 *   • Volume / procedural datasets : f32 in [0, 4095]  (12-bit intensity)
 *   • Terrain datasets             : f32 in {0,1,2,3,4,5,6}  (biome code)
 *   • Effect datasets              : f32 in [0, 4095]  (density × 4095)
 *   • Composed dataset             : {0} = air  |  [1,6] = terrain type
 *                                    [100,200]  = 100 + cloud_density×100
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

struct tint_symbol_35 {
  /* @offset(0) */
  tint_symbol_36 : tint_symbol,
  /* @offset(64) */
  tint_symbol_37 : vec2f,
  /* @offset(72) */
  tint_symbol_38 : vec2f,
}

struct tint_symbol_42_block {
  /* @offset(0) */
  inner : tint_symbol_35,
}

struct tint_symbol_39 {
  /* @offset(0) */
  tint_symbol_40 : vec4f,
  /* @offset(16) */
  tint_symbol_41 : vec4f,
}

struct tint_symbol_43_block {
  /* @offset(0) */
  inner : tint_symbol_39,
}

alias RTArr = array<f32>;

struct tint_symbol_44_block {
  /* @offset(0) */
  inner : RTArr,
}

alias Arr = array<vec3f, 2u>;

var<private> tint_symbol_158_1 : vec3u;

var<private> tint_symbol_158_2 : vec3u;

var<private> tint_symbol_158_3 : vec3u;

var<private> tint_symbol_158_4 : vec3u;

var<private> tint_symbol_158_5 : vec3u;

var<private> tint_symbol_158_6 : vec3u;

var<private> tint_symbol_158_7 : vec3u;

var<private> tint_symbol_158_8 : vec3u;

var<private> tint_symbol_158_9 : vec3u;

var<private> tint_symbol_158_10 : vec3u;

var<private> tint_symbol_158_11 : vec3u;

var<private> tint_symbol_158_12 : vec3u;

var<private> tint_symbol_158_13 : vec3u;

var<private> tint_symbol_158_14 : vec3u;

var<private> tint_symbol_158_15 : vec3u;

var<private> tint_symbol_158_16 : vec3u;

var<private> tint_symbol_158_17 : vec3u;

var<private> tint_symbol_158_18 : vec3u;

var<private> tint_symbol_158_19 : vec3u;

var<private> tint_symbol_158_20 : vec3u;

var<private> tint_symbol_158_21 : vec3u;

var<private> tint_symbol_158_22 : vec3u;

var<private> tint_symbol_158_23 : vec3u;

var<private> tint_symbol_158_24 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_42 : tint_symbol_42_block;

@group(0) @binding(1) var<uniform> tint_symbol_43 : tint_symbol_43_block;

@group(0) @binding(2) var<storage> tint_symbol_44 : tint_symbol_44_block;

@group(0) @binding(3) var tint_symbol_45 : texture_storage_2d<rgba8unorm, write>;

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
  let x_871 = tint_symbol_20;
  return x_871;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_907 = tint_symbol_21(tint_symbol_24);
  let x_908 = tint_symbol_17(tint_symbol_23, x_907);
  let x_909 = tint_symbol_17(tint_symbol_24, x_908);
  return x_909;
}

fn tint_symbol_25(tint_symbol_24_1 : tint_symbol) -> f32 {
  var tint_symbol_1 = 0.0f;
  tint_symbol_1 = ((((((((((((((((tint_symbol_24_1.tint_symbol_1 * tint_symbol_24_1.tint_symbol_1) + (tint_symbol_24_1.tint_symbol_2 * tint_symbol_24_1.tint_symbol_2)) + (tint_symbol_24_1.tint_symbol_3 * tint_symbol_24_1.tint_symbol_3)) + (tint_symbol_24_1.tint_symbol_4 * tint_symbol_24_1.tint_symbol_4)) + (tint_symbol_24_1.tint_symbol_5 * tint_symbol_24_1.tint_symbol_5)) + (tint_symbol_24_1.tint_symbol_6 * tint_symbol_24_1.tint_symbol_6)) + (tint_symbol_24_1.tint_symbol_7 * tint_symbol_24_1.tint_symbol_7)) + (tint_symbol_24_1.tint_symbol_8 * tint_symbol_24_1.tint_symbol_8)) + (tint_symbol_24_1.tint_symbol_9 * tint_symbol_24_1.tint_symbol_9)) + (tint_symbol_24_1.tint_symbol_10 * tint_symbol_24_1.tint_symbol_10)) + (tint_symbol_24_1.tint_symbol_11 * tint_symbol_24_1.tint_symbol_11)) + (tint_symbol_24_1.tint_symbol_12 * tint_symbol_24_1.tint_symbol_12)) + (tint_symbol_24_1.tint_symbol_13 * tint_symbol_24_1.tint_symbol_13)) + (tint_symbol_24_1.tint_symbol_14 * tint_symbol_24_1.tint_symbol_14)) + (tint_symbol_24_1.tint_symbol_15 * tint_symbol_24_1.tint_symbol_15)) + (tint_symbol_24_1.tint_symbol_16 * tint_symbol_24_1.tint_symbol_16));
  let x_981 = tint_symbol_1;
  return sqrt(x_981);
}

fn tint_symbol_26(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_989 = tint_symbol_25(tint_symbol_24_2);
  if ((x_989 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_2.tint_symbol_1 / x_989), (tint_symbol_24_2.tint_symbol_2 / x_989), (tint_symbol_24_2.tint_symbol_3 / x_989), (tint_symbol_24_2.tint_symbol_4 / x_989), (tint_symbol_24_2.tint_symbol_5 / x_989), (tint_symbol_24_2.tint_symbol_6 / x_989), (tint_symbol_24_2.tint_symbol_7 / x_989), (tint_symbol_24_2.tint_symbol_8 / x_989), (tint_symbol_24_2.tint_symbol_9 / x_989), (tint_symbol_24_2.tint_symbol_10 / x_989), (tint_symbol_24_2.tint_symbol_11 / x_989), (tint_symbol_24_2.tint_symbol_12 / x_989), (tint_symbol_24_2.tint_symbol_13 / x_989), (tint_symbol_24_2.tint_symbol_14 / x_989), (tint_symbol_24_2.tint_symbol_15 / x_989), (tint_symbol_24_2.tint_symbol_16 / x_989));
  }
  let x_1033 = tint_return_value;
  return x_1033;
}

fn tint_symbol_28(tint_symbol_29 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_29.z, -(tint_symbol_29.y), tint_symbol_29.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_30(tint_symbol_23_1 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, -(tint_symbol_23_1.z), tint_symbol_23_1.y, -(tint_symbol_23_1.x), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_31(tint_symbol_23_2 : tint_symbol) -> vec3f {
  return vec3f((-(tint_symbol_23_2.tint_symbol_11) / tint_symbol_23_2.tint_symbol_8), (tint_symbol_23_2.tint_symbol_10 / tint_symbol_23_2.tint_symbol_8), (-(tint_symbol_23_2.tint_symbol_9) / tint_symbol_23_2.tint_symbol_8));
}

fn tint_symbol_32(tint_symbol_24_3 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_24_3.tint_symbol_1, tint_symbol_24_3.tint_symbol_2, tint_symbol_24_3.tint_symbol_3, tint_symbol_24_3.tint_symbol_4, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_33(tint_symbol_23_3 : vec3f, tint_symbol_24_4 : tint_symbol) -> vec3f {
  let x_1081 = tint_symbol_30(tint_symbol_23_3);
  let x_1082 = tint_symbol_22(x_1081, tint_symbol_24_4);
  let x_1083 = tint_symbol_31(x_1082);
  return x_1083;
}

fn tint_symbol_34(tint_symbol_29_1 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1088 = tint_symbol_32(tint_symbol_24_5);
  let x_1089 = tint_symbol_30(tint_symbol_29_1);
  let x_1090 = tint_symbol_22(x_1089, x_1088);
  let x_1091 = tint_symbol_31(x_1090);
  return x_1091;
}

fn tint_symbol_46(tint_symbol_47 : vec3f) -> vec3f {
  let x_1099 = tint_symbol_42.inner.tint_symbol_36;
  let x_1096 = tint_symbol_33(tint_symbol_47, x_1099);
  return x_1096;
}

fn tint_symbol_48(tint_symbol_29_2 : vec3f) -> vec3f {
  let x_1105 = tint_symbol_42.inner.tint_symbol_36;
  let x_1103 = tint_symbol_34(tint_symbol_29_2, x_1105);
  return x_1103;
}

fn tint_symbol_53(tint_symbol_54 : vec2f, tint_symbol_55 : f32) -> vec2f {
  var tint_symbol_20_1 = vec2f();
  tint_symbol_20_1 = tint_symbol_54;
  if ((tint_symbol_54.x < 0.0f)) {
    tint_symbol_20_1.x = tint_symbol_55;
  } else {
    var x_1133 : bool;
    var x_1134 : bool;
    if ((tint_symbol_55 < tint_symbol_54.x)) {
      tint_symbol_20_1.y = tint_symbol_54.x;
      tint_symbol_20_1.x = tint_symbol_55;
    } else {
      let x_1129 = (tint_symbol_54.y < 0.0f);
      x_1134 = x_1129;
      if (x_1129) {
      } else {
        x_1133 = (tint_symbol_55 < tint_symbol_54.y);
        x_1134 = x_1133;
      }
      if (x_1134) {
        tint_symbol_20_1.y = tint_symbol_55;
      }
    }
  }
  let x_1138 = tint_symbol_20_1;
  return x_1138;
}

fn tint_symbol_56(tint_symbol_57 : f32, tint_symbol_58 : vec2f, tint_symbol_59 : f32, tint_symbol_60 : f32, tint_symbol_23_4 : vec2f, tint_symbol_29_3 : vec2f, tint_symbol_54_1 : vec2f) -> vec2f {
  var tint_symbol_20_2 = vec2f();
  tint_symbol_20_2 = tint_symbol_54_1;
  if ((abs(tint_symbol_60) > 0.00000000999999993923f)) {
    var x_1156 : f32;
    var x_1170 : bool;
    var x_1171 : bool;
    var x_1177 : bool;
    var x_1178 : bool;
    var x_1183 : bool;
    var x_1184 : bool;
    x_1156 = ((tint_symbol_57 - tint_symbol_59) / tint_symbol_60);
    if ((x_1156 > 0.0f)) {
      let x_1161 = (tint_symbol_23_4 + (tint_symbol_29_3 * x_1156));
      let x_1165 = (-(tint_symbol_58.x) < x_1161.x);
      x_1171 = x_1165;
      if (x_1165) {
        x_1170 = (x_1161.x < tint_symbol_58.x);
        x_1171 = x_1170;
      }
      x_1178 = x_1171;
      if (x_1171) {
        x_1177 = (-(tint_symbol_58.y) < x_1161.y);
        x_1178 = x_1177;
      }
      x_1184 = x_1178;
      if (x_1178) {
        x_1183 = (x_1161.y < tint_symbol_58.y);
        x_1184 = x_1183;
      }
      if (x_1184) {
        let x_1188 = tint_symbol_20_2;
        let x_1187 = tint_symbol_53(x_1188, x_1156);
        tint_symbol_20_2 = x_1187;
      }
    }
  }
  let x_1189 = tint_symbol_20_2;
  return x_1189;
}

fn tint_symbol_62(tint_symbol_23_5 : vec3f, tint_symbol_29_4 : vec3f) -> vec2f {
  var tint_symbol_61 = vec2f();
  var x_1216 = vec4f();
  tint_symbol_61 = vec2f(-1.0f);
  let x_1215 = (((tint_symbol_43.inner.tint_symbol_40 * tint_symbol_43.inner.tint_symbol_41) * 0.5f) / vec4f(max(max(tint_symbol_43.inner.tint_symbol_40.x, tint_symbol_43.inner.tint_symbol_40.y), tint_symbol_43.inner.tint_symbol_40.z)));
  let x_1227 = tint_symbol_61;
  let x_1220 = tint_symbol_56(x_1215.z, x_1215.xy, tint_symbol_23_5.z, tint_symbol_29_4.z, tint_symbol_23_5.xy, tint_symbol_29_4.xy, x_1227);
  tint_symbol_61 = x_1220;
  let x_1236 = tint_symbol_61;
  let x_1228 = tint_symbol_56(-(x_1215.z), x_1215.xy, tint_symbol_23_5.z, tint_symbol_29_4.z, tint_symbol_23_5.xy, tint_symbol_29_4.xy, x_1236);
  tint_symbol_61 = x_1228;
  let x_1245 = tint_symbol_61;
  let x_1237 = tint_symbol_56(-(x_1215.x), x_1215.yz, tint_symbol_23_5.x, tint_symbol_29_4.x, tint_symbol_23_5.yz, tint_symbol_29_4.yz, x_1245);
  tint_symbol_61 = x_1237;
  let x_1253 = tint_symbol_61;
  let x_1246 = tint_symbol_56(x_1215.x, x_1215.yz, tint_symbol_23_5.x, tint_symbol_29_4.x, tint_symbol_23_5.yz, tint_symbol_29_4.yz, x_1253);
  tint_symbol_61 = x_1246;
  let x_1261 = tint_symbol_61;
  let x_1254 = tint_symbol_56(x_1215.y, x_1215.xz, tint_symbol_23_5.y, tint_symbol_29_4.y, tint_symbol_23_5.xz, tint_symbol_29_4.xz, x_1261);
  tint_symbol_61 = x_1254;
  let x_1270 = tint_symbol_61;
  let x_1262 = tint_symbol_56(-(x_1215.y), x_1215.xz, tint_symbol_23_5.y, tint_symbol_29_4.y, tint_symbol_23_5.xz, tint_symbol_29_4.xz, x_1270);
  tint_symbol_61 = x_1262;
  let x_1271 = tint_symbol_61;
  return x_1271;
}

fn tint_symbol_63(tint_symbol_64 : vec2f) -> vec2f {
  var tint_symbol_61_1 = vec2f();
  var x_1284 : bool;
  var x_1285 : bool;
  tint_symbol_61_1 = tint_symbol_64;
  let x_1279 = (tint_symbol_61_1.y < 0.0f);
  x_1285 = x_1279;
  if (x_1279) {
    x_1284 = (tint_symbol_61_1.x > 0.0f);
    x_1285 = x_1284;
  }
  if (x_1285) {
    tint_symbol_61_1.y = tint_symbol_61_1.x;
    tint_symbol_61_1.x = 0.0f;
  }
  let x_1292 = tint_symbol_61_1;
  return x_1292;
}

const x_1329 = vec3f(1.0f);

fn tint_symbol_65(tint_symbol_66 : vec3f) -> f32 {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = 0.0f;
  var x_1316 = vec3f();
  var x_1328 : bool;
  var x_1331 : bool;
  let x_1315 = (((tint_symbol_43.inner.tint_symbol_40.xyz * tint_symbol_43.inner.tint_symbol_41.xyz) * 0.5f) / vec3f(max(max(tint_symbol_43.inner.tint_symbol_40.x, tint_symbol_43.inner.tint_symbol_40.y), tint_symbol_43.inner.tint_symbol_40.z)));
  let x_1323 = ((tint_symbol_66 + x_1315) / (x_1315 * 2.0f));
  let x_1324 = any((x_1323 < vec3f()));
  x_1331 = x_1324;
  if (x_1324) {
  } else {
    x_1328 = any((x_1323 >= x_1329));
    x_1331 = x_1328;
  }
  if (x_1331) {
    tint_return_flag_1 = true;
    tint_return_value_1 = 0.0f;
  }
  if (!(tint_return_flag_1)) {
    let x_1340 = tint_symbol_43.inner.tint_symbol_40;
    let x_1338 = tint_ftoi((x_1323 * x_1340.xyz));
    let x_1346 = tint_symbol_43.inner.tint_symbol_40.x;
    let x_1344 = tint_ftoi_1(x_1346);
    let x_1350 = tint_symbol_43.inner.tint_symbol_40.y;
    let x_1348 = tint_ftoi_1(x_1350);
    let x_1355 = tint_symbol_43.inner.tint_symbol_40.x;
    let x_1353 = tint_ftoi_1(x_1355);
    tint_return_flag_1 = true;
    tint_return_value_1 = tint_symbol_44.inner[((((x_1338.z * x_1344) * x_1348) + (x_1338.y * x_1353)) + x_1338.x)];
  }
  let x_1363 = tint_return_value_1;
  return x_1363;
}

fn tint_symbol_71(tint_symbol_66_1 : vec3f) -> f32 {
  var x_1384 = vec3f();
  let x_1390 = (((((tint_symbol_43.inner.tint_symbol_40.xyz * tint_symbol_43.inner.tint_symbol_41.xyz) * 0.5f) / vec3f(max(max(tint_symbol_43.inner.tint_symbol_40.x, tint_symbol_43.inner.tint_symbol_40.y), tint_symbol_43.inner.tint_symbol_40.z))) * 2.0f) / tint_symbol_43.inner.tint_symbol_40.xyz);
  let x_1391 = tint_symbol_65((tint_symbol_66_1 + vec3f(x_1390.x, 0.0f, 0.0f)));
  let x_1395 = tint_symbol_65((tint_symbol_66_1 - vec3f(x_1390.x, 0.0f, 0.0f)));
  let x_1400 = tint_symbol_65((tint_symbol_66_1 + vec3f(0.0f, x_1390.y, 0.0f)));
  let x_1404 = tint_symbol_65((tint_symbol_66_1 - vec3f(0.0f, x_1390.y, 0.0f)));
  let x_1409 = tint_symbol_65((tint_symbol_66_1 + vec3f(0.0f, 0.0f, x_1390.z)));
  let x_1413 = tint_symbol_65((tint_symbol_66_1 - vec3f(0.0f, 0.0f, x_1390.z)));
  return (length(vec3f((x_1391 - x_1395), (x_1400 - x_1404), (x_1409 - x_1413))) / 8190.0f);
}

fn tint_symbol_76(tint_symbol_55_1 : f32) -> vec3f {
  var tint_symbol_20_3 = 0.0f;
  var tint_symbol_78 = 0.0f;
  var tint_symbol_19_1 = 0.0f;
  var x_1426 : f32;
  x_1426 = clamp(tint_symbol_55_1, 0.0f, 1.0f);
  if ((x_1426 < 0.25f)) {
    tint_symbol_20_3 = 0.0f;
    tint_symbol_78 = (x_1426 / 0.25f);
    tint_symbol_19_1 = 1.0f;
  } else {
    if ((x_1426 < 0.5f)) {
      tint_symbol_20_3 = 0.0f;
      tint_symbol_78 = 1.0f;
      tint_symbol_19_1 = (1.0f - ((x_1426 - 0.25f) / 0.25f));
    } else {
      if ((x_1426 < 0.75f)) {
        tint_symbol_20_3 = ((x_1426 - 0.5f) / 0.25f);
        tint_symbol_78 = 1.0f;
        tint_symbol_19_1 = 0.0f;
      } else {
        tint_symbol_20_3 = 1.0f;
        tint_symbol_78 = (1.0f - ((x_1426 - 0.75f) / 0.25f));
        tint_symbol_19_1 = 0.0f;
      }
    }
  }
  let x_1453 = tint_symbol_20_3;
  let x_1454 = tint_symbol_78;
  let x_1455 = tint_symbol_19_1;
  return vec3f(x_1453, x_1454, x_1455);
}

fn tint_mod(lhs : i32, rhs : i32) -> i32 {
  let x_1462 = select(rhs, 1i, ((rhs == 0i) | ((lhs == i32(-2147483648)) & (rhs == -1i))));
  if (((bitcast<u32>((lhs | x_1462)) & 2147483648u) != 0u)) {
    return (lhs - ((lhs / x_1462) * x_1462));
  } else {
    return (lhs % x_1462);
  }
}

fn tint_symbol_79(tint_symbol_55_2 : f32) -> vec3f {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = vec3f();
  let x_1495 = (((1.0f - clamp(tint_symbol_55_2, 0.0f, 1.0f)) * 240.0f) / 60.0f);
  let x_1497 = tint_ftoi_1(x_1495);
  let x_1496 = tint_mod(x_1497, 6i);
  let x_1500 = (x_1495 - floor(x_1495));
  let x_1502 = (1.0f * (1.0f - 1.0f));
  let x_1505 = (1.0f * (1.0f - (1.0f * x_1500)));
  let x_1509 = (1.0f * (1.0f - (1.0f * (1.0f - x_1500))));
  switch(x_1496) {
    case 4i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(x_1509, x_1502, 1.0f);
    }
    case 3i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(x_1502, x_1505, 1.0f);
    }
    case 2i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(x_1502, 1.0f, x_1509);
    }
    case 1i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(x_1505, 1.0f, x_1502);
    }
    case 0i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(1.0f, x_1509, x_1502);
    }
    default: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec3f(1.0f, x_1502, x_1505);
    }
  }
  let x_1523 = tint_return_value_2;
  return x_1523;
}

const x_1538 = vec4f(0.20000000298023223877f, 0.5f, 0.80000001192092895508f, 0.15000000596046447754f);

const x_1541 = vec4f(0.30000001192092895508f, 0.80000001192092895508f, 0.40000000596046447754f, 0.34999999403953552246f);

const x_1544 = vec4f(0.89999997615814208984f, 0.80000001192092895508f, 0.10000000149011611938f, 0.60000002384185791016f);

fn tint_symbol_85(tint_symbol_55_3 : f32) -> vec4f {
  var tint_return_flag_3 = false;
  var tint_return_value_3 = vec4f();
  var x_1552 = vec4f();
  var x_1561 = vec4f();
  var x_1570 = vec4f();
  var x_1575 = vec4f();
  var x_1530 : f32;
  x_1530 = clamp(tint_symbol_55_3, 0.0f, 1.0f);
  if ((x_1530 < 0.25f)) {
    tint_return_flag_3 = true;
    tint_return_value_3 = mix(vec4f(0.07999999821186065674f, 0.10000000149011611938f, 0.34999999403953552246f, 0.0f), x_1538, vec4f((x_1530 / 0.25f)));
  } else {
    if ((x_1530 < 0.5f)) {
      tint_return_flag_3 = true;
      tint_return_value_3 = mix(x_1538, x_1541, vec4f(((x_1530 - 0.25f) / 0.25f)));
    } else {
      if ((x_1530 < 0.75f)) {
        tint_return_flag_3 = true;
        tint_return_value_3 = mix(x_1541, x_1544, vec4f(((x_1530 - 0.5f) / 0.25f)));
      } else {
        tint_return_flag_3 = true;
        tint_return_value_3 = mix(x_1544, vec4f(1.0f, 0.20000000298023223877f, 0.10000000149011611938f, 1.0f), vec4f(((x_1530 - 0.75f) / 0.25f)));
      }
    }
  }
  let x_1577 = tint_return_value_3;
  return x_1577;
}

fn tint_symbol_91(tint_symbol_55_4 : f32) -> vec3f {
  var x_1589 = vec3f();
  let x_1581 = clamp(tint_symbol_55_4, 0.0f, 1.0f);
  let x_1588 = (x_1581 * x_1581);
  return mix((vec3f(0.30000001192092895508f, 0.55000001192092895508f, 0.89999997615814208984f) * 0.11999999731779098511f), vec3f(1.0f, 0.34999999403953552246f, 0.10000000149011611938f), vec3f(x_1588));
}

const x_1604 = vec3f(0.69999998807907104492f, 0.11999999731779098511f, 0.0f);

const x_1615 = vec3f(1.0f, 0.64999997615814208984f, 0.0f);

fn tint_symbol_94(tint_symbol_55_5 : f32) -> vec4f {
  var tint_symbol_95 = vec3f();
  var x_1606 = vec3f();
  var x_1618 = vec3f();
  var x_1626 = vec3f();
  let x_1594 = clamp(tint_symbol_55_5, 0.0f, 1.0f);
  if ((x_1594 < 0.33000001311302185059f)) {
    tint_symbol_95 = mix(vec3f(0.10000000149011611938f, 0.0f, 0.0f), x_1604, vec3f((x_1594 / 0.33000001311302185059f)));
  } else {
    if ((x_1594 < 0.66000002622604370117f)) {
      tint_symbol_95 = mix(x_1604, x_1615, vec3f(((x_1594 - 0.33000001311302185059f) / 0.33000001311302185059f)));
    } else {
      tint_symbol_95 = mix(x_1615, vec3f(1.0f, 0.94999998807907104492f, 0.80000001192092895508f), vec3f(((x_1594 - 0.66000002622604370117f) / 0.34000000357627868652f)));
    }
  }
  let x_1628 = tint_symbol_95;
  return vec4f(x_1628.x, x_1628.y, x_1628.z, (x_1594 * 0.85000002384185791016f));
}

fn tint_symbol_96(tint_symbol_97 : i32, tint_symbol_98 : i32, tint_symbol_99 : i32) -> vec3f {
  var tint_symbol_100 = vec3f();
  var tint_symbol_101 = 0.0f;
  switch(tint_symbol_97) {
    case 6i: {
      tint_symbol_100 = vec3f(0.93999999761581420898f, 0.93999999761581420898f, 1.0f);
    }
    case 5i: {
      tint_symbol_100 = vec3f(0.50999999046325683594f, 0.50999999046325683594f, 0.49000000953674316406f);
    }
    case 4i: {
      tint_symbol_100 = vec3f(0.46999999880790710449f, 0.33000001311302185059f, 0.21999999880790710449f);
    }
    case 3i: {
      tint_symbol_100 = vec3f(0.33000001311302185059f, 0.58999997377395629883f, 0.27000001072883605957f);
    }
    case 2i: {
      tint_symbol_100 = vec3f(0.81999999284744262695f, 0.76999998092651367188f, 0.54000002145767211914f);
    }
    case 1i: {
      tint_symbol_100 = vec3f(0.11999999731779098511f, 0.38999998569488525391f, 0.77999997138977050781f);
    }
    default: {
      tint_symbol_100 = vec3f(1.0f, 0.0f, 1.0f);
    }
  }
  if ((tint_symbol_98 == 1i)) {
    tint_symbol_101 = select(0.55000001192092895508f, 1.0f, (tint_symbol_99 < 0i));
  } else {
    if ((tint_symbol_98 == 0i)) {
      tint_symbol_101 = 0.75f;
    } else {
      tint_symbol_101 = 0.69999998807907104492f;
    }
  }
  let x_1680 = tint_symbol_100;
  let x_1681 = tint_symbol_101;
  return (x_1680 * x_1681);
}

const x_1703 = vec4f(0.51999998092651367188f, 0.73000001907348632812f, 0.89999997615814208984f, 1.0f);

const x_2042 = vec3f(0.51999998092651367188f, 0.73000001907348632812f, 0.89999997615814208984f);

fn tint_symbol_102(tint_symbol_103 : vec2i, tint_symbol_23_6 : vec3f, tint_symbol_29_5 : vec3f, tint_symbol_104 : bool) {
  var tint_return_flag_4 = false;
  var x_1725 = vec3f();
  var tint_symbol_110 = vec3i();
  var tint_symbol_112 = vec3f();
  var tint_symbol_115 = vec3f();
  var tint_symbol_98_1 = 0i;
  var tint_symbol_116 = vec3f();
  var tint_symbol_117 = 0.0f;
  var tint_symbol_118 = 0i;
  var tint_symbol_121 = vec3f();
  var x_1946 = vec3f();
  var tint_symbol_125 = vec3f();
  let x_1693 = tint_symbol_62(tint_symbol_23_6, tint_symbol_29_5);
  let x_1694 = tint_symbol_63(x_1693);
  if ((x_1694.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103, x_1703);
    tint_return_flag_4 = true;
  }
  if (!(tint_return_flag_4)) {
    let x_1724 = (((tint_symbol_43.inner.tint_symbol_40.xyz * tint_symbol_43.inner.tint_symbol_41.xyz) * 0.5f) / vec3f(max(max(tint_symbol_43.inner.tint_symbol_40.x, tint_symbol_43.inner.tint_symbol_40.y), tint_symbol_43.inner.tint_symbol_40.z)));
    let x_1731 = ((x_1724 * 2.0f) / tint_symbol_43.inner.tint_symbol_40.xyz);
    let x_1740 = clamp(((((tint_symbol_23_6 + (tint_symbol_29_5 * (x_1694.x + 0.00000999999974737875f))) + x_1724) / (x_1724 * 2.0f)) * tint_symbol_43.inner.tint_symbol_40.xyz), vec3f(), (tint_symbol_43.inner.tint_symbol_40.xyz - vec3f(0.00009999999747378752f)));
    let x_1751 = tint_ftoi(floor(x_1740));
    tint_symbol_110 = x_1751;
    let x_1756 = tint_ftoi(sign(tint_symbol_29_5));
    let x_1758 = tint_ftoi_1(sign(tint_symbol_29_5.y));
    tint_symbol_112.x = select(1000000015047466219876688855040.0f, (x_1731.x / abs(tint_symbol_29_5.x)), (abs(tint_symbol_29_5.x) > 0.00000000999999993923f));
    tint_symbol_112.y = select(1000000015047466219876688855040.0f, (x_1731.y / abs(tint_symbol_29_5.y)), (abs(tint_symbol_29_5.y) > 0.00000000999999993923f));
    tint_symbol_112.z = select(1000000015047466219876688855040.0f, (x_1731.z / abs(tint_symbol_29_5.z)), (abs(tint_symbol_29_5.z) > 0.00000000999999993923f));
    let x_1821 = ((((vec3f(select(floor(x_1740.x), (floor(x_1740.x) + 1.0f), (tint_symbol_29_5.x > 0.0f)), select(floor(x_1740.y), (floor(x_1740.y) + 1.0f), (tint_symbol_29_5.y > 0.0f)), select(floor(x_1740.z), (floor(x_1740.z) + 1.0f), (tint_symbol_29_5.z > 0.0f))) / tint_symbol_43.inner.tint_symbol_40.xyz) * 2.0f) * x_1724) - x_1724);
    tint_symbol_115.x = select(1000000015047466219876688855040.0f, ((x_1821.x - tint_symbol_23_6.x) / tint_symbol_29_5.x), (abs(tint_symbol_29_5.x) > 0.00000000999999993923f));
    tint_symbol_115.y = select(1000000015047466219876688855040.0f, ((x_1821.y - tint_symbol_23_6.y) / tint_symbol_29_5.y), (abs(tint_symbol_29_5.y) > 0.00000000999999993923f));
    tint_symbol_115.z = select(1000000015047466219876688855040.0f, ((x_1821.z - tint_symbol_23_6.z) / tint_symbol_29_5.z), (abs(tint_symbol_29_5.z) > 0.00000000999999993923f));
    tint_symbol_98_1 = 1i;
    tint_symbol_116 = vec3f();
    tint_symbol_117 = 0.0f;
    tint_symbol_118 = 0i;
    loop {
      var x_1873 : bool;
      var x_1880 : bool;
      var x_1909 : bool;
      var x_1910 : bool;
      var x_1936 : bool;
      var x_1937 : bool;
      var x_1971 : bool;
      var x_1972 : bool;
      if (!((tint_symbol_118 < 400i))) {
        break;
      }
      let x_1868 = any((tint_symbol_110 < vec3i()));
      x_1880 = x_1868;
      if (x_1868) {
      } else {
        let x_1874 = tint_symbol_110;
        let x_1877 = tint_symbol_43.inner.tint_symbol_40;
        let x_1875 = tint_ftoi(x_1877.xyz);
        x_1873 = any((x_1874 >= x_1875));
        x_1880 = x_1873;
      }
      if (x_1880) {
        break;
      }
      let x_1884 = tint_symbol_110.z;
      let x_1887 = tint_symbol_43.inner.tint_symbol_40.x;
      let x_1885 = tint_ftoi_1(x_1887);
      let x_1891 = tint_symbol_43.inner.tint_symbol_40.y;
      let x_1889 = tint_ftoi_1(x_1891);
      let x_1894 = tint_symbol_110.y;
      let x_1897 = tint_symbol_43.inner.tint_symbol_40.x;
      let x_1895 = tint_ftoi_1(x_1897);
      let x_1904 = tint_symbol_44.inner[((((x_1884 * x_1885) * x_1889) + (x_1894 * x_1895)) + tint_symbol_110.x)];
      let x_1905 = (x_1904 >= 0.5f);
      x_1910 = x_1905;
      if (x_1905) {
        x_1909 = (x_1904 <= 6.5f);
        x_1910 = x_1909;
      }
      if (x_1910) {
        let x_1913 = tint_ftoi_1(round(x_1904));
        let x_1916 = tint_symbol_98_1;
        let x_1915 = tint_symbol_96(x_1913, x_1916, x_1758);
        tint_symbol_121 = x_1915;
        if (tint_symbol_104) {
          tint_symbol_121 = (tint_symbol_116 + (tint_symbol_121 * (1.0f - tint_symbol_117)));
        }
        let x_1928 = tint_symbol_121;
        textureStore(tint_symbol_45, tint_symbol_103, vec4f(x_1928.x, x_1928.y, x_1928.z, 1.0f));
        tint_return_flag_4 = true;
        break;
      }
      x_1937 = tint_symbol_104;
      if (tint_symbol_104) {
        x_1936 = (x_1904 >= 99.5f);
        x_1937 = x_1936;
      }
      if (x_1937) {
        let x_1940 = clamp(((x_1904 - 100.0f) / 100.0f), 0.0f, 1.0f);
        let x_1948 = (x_1940 * 0.30000001192092895508f);
        tint_symbol_116 = (tint_symbol_116 + (mix(vec3f(0.80000001192092895508f, 0.89999997615814208984f, 1.0f), x_1329, vec3f(x_1940)) * ((1.0f - tint_symbol_117) * x_1948)));
        tint_symbol_117 = (tint_symbol_117 + ((1.0f - tint_symbol_117) * x_1948));
      }
      let x_1964 = (tint_symbol_115.x < tint_symbol_115.y);
      x_1972 = x_1964;
      if (x_1964) {
        x_1971 = (tint_symbol_115.x < tint_symbol_115.z);
        x_1972 = x_1971;
      }
      if (x_1972) {
        if ((tint_symbol_115.x > x_1694.y)) {
          break;
        }
        tint_symbol_115.x = (tint_symbol_115.x + tint_symbol_112.x);
        tint_symbol_110.x = (tint_symbol_110.x + x_1756.x);
        tint_symbol_98_1 = 0i;
      } else {
        if ((tint_symbol_115.y < tint_symbol_115.z)) {
          if ((tint_symbol_115.y > x_1694.y)) {
            break;
          }
          tint_symbol_115.y = (tint_symbol_115.y + tint_symbol_112.y);
          tint_symbol_110.y = (tint_symbol_110.y + x_1756.y);
          tint_symbol_98_1 = 1i;
        } else {
          if ((tint_symbol_115.z > x_1694.y)) {
            break;
          }
          tint_symbol_115.z = (tint_symbol_115.z + tint_symbol_112.z);
          tint_symbol_110.z = (tint_symbol_110.z + x_1756.z);
          tint_symbol_98_1 = 2i;
        }
      }

      continuing {
        tint_symbol_118 = (tint_symbol_118 + 1i);
      }
    }
    if (!(tint_return_flag_4)) {
      tint_symbol_125 = x_2042;
      if (tint_symbol_104) {
        tint_symbol_125 = (tint_symbol_116 + (tint_symbol_125 * (1.0f - tint_symbol_117)));
      }
      let x_2054 = tint_symbol_125;
      textureStore(tint_symbol_45, tint_symbol_103, vec4f(x_2054.x, x_2054.y, x_2054.z, 1.0f));
    }
  }
  return;
}

const x_2075 = vec4f(0.01999999955296516418f, 0.01999999955296516418f, 0.07999999821186065674f, 1.0f);

const x_2118 = vec3f(0.01200000010430812836f, 0.02999999932944774628f, 0.06599999964237213135f);

const x_2119 = vec3f(0.94999998807907104492f, 0.30000001192092895508f, 0.40000000596046447754f);

fn tint_symbol_126(tint_symbol_103_1 : vec2i, tint_symbol_23_7 : vec3f, tint_symbol_29_6 : vec3f) {
  var tint_return_flag_5 = false;
  var tint_symbol_127 = 0.0f;
  var tint_symbol_129 = 0i;
  var x_2120 = vec3f();
  let x_2066 = tint_symbol_62(tint_symbol_23_7, tint_symbol_29_6);
  let x_2067 = tint_symbol_63(x_2066);
  if ((x_2067.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_1, x_2075);
    tint_return_flag_5 = true;
  }
  if (!(tint_return_flag_5)) {
    tint_symbol_127 = 0.0f;
    let x_2085 = ((x_2067.y - x_2067.x) / 256.0f);
    tint_symbol_129 = 0i;
    loop {
      if (!((tint_symbol_129 < 256i))) {
        break;
      }
      let x_2097 = tint_symbol_127;
      let x_2101 = tint_symbol_129;
      let x_2098 = tint_symbol_65((tint_symbol_23_7 + (tint_symbol_29_6 * (x_2067.x + ((f32(x_2101) + 0.5f) * x_2085)))));
      tint_symbol_127 = max(x_2097, x_2098);

      continuing {
        tint_symbol_129 = (tint_symbol_129 + 1i);
      }
    }
    let x_2114 = mix(x_2118, x_2119, vec3f(clamp((tint_symbol_127 / 4095.0f), 0.0f, 1.0f)));
    textureStore(tint_symbol_45, tint_symbol_103_1, vec4f(x_2114.x, x_2114.y, x_2114.z, 1.0f));
  }
  return;
}

fn tint_symbol_130(tint_symbol_103_2 : vec2i, tint_symbol_23_8 : vec3f, tint_symbol_29_7 : vec3f) {
  var tint_return_flag_6 = false;
  var tint_symbol_131 = 0.0f;
  var tint_symbol_129_1 = 0i;
  var x_2182 = vec3f();
  let x_2134 = tint_symbol_62(tint_symbol_23_8, tint_symbol_29_7);
  let x_2135 = tint_symbol_63(x_2134);
  if ((x_2135.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_2, x_2075);
    tint_return_flag_6 = true;
  }
  if (!(tint_return_flag_6)) {
    tint_symbol_131 = 1.0f;
    let x_2150 = ((x_2135.y - x_2135.x) / 256.0f);
    tint_symbol_129_1 = 0i;
    loop {
      if (!((tint_symbol_129_1 < 256i))) {
        break;
      }
      let x_2165 = tint_symbol_129_1;
      let x_2162 = tint_symbol_65((tint_symbol_23_8 + (tint_symbol_29_7 * (x_2135.x + ((f32(x_2165) + 0.5f) * x_2150)))));
      tint_symbol_131 = (tint_symbol_131 * exp((-((x_2162 / 4095.0f)) * 0.03999999910593032837f)));

      continuing {
        tint_symbol_129_1 = (tint_symbol_129_1 + 1i);
      }
    }
    let x_2181 = mix(x_2118, x_2119, vec3f((1.0f - tint_symbol_131)));
    textureStore(tint_symbol_45, tint_symbol_103_2, vec4f(x_2181.x, x_2181.y, x_2181.z, 1.0f));
  }
  return;
}

const x_2266 = vec3f(0.01999999955296516418f, 0.01999999955296516418f, 0.07999999821186065674f);

fn tint_symbol_134(tint_symbol_103_3 : vec2i, tint_symbol_23_9 : vec3f, tint_symbol_29_8 : vec3f) {
  var tint_return_flag_7 = false;
  var tint_symbol_135 = vec3f();
  var tint_symbol_136 = 0.0f;
  var tint_symbol_129_2 = 0i;
  var x_2238 = vec3f();
  let x_2196 = tint_symbol_62(tint_symbol_23_9, tint_symbol_29_8);
  let x_2197 = tint_symbol_63(x_2196);
  if ((x_2197.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_3, x_2075);
    tint_return_flag_7 = true;
  }
  if (!(tint_return_flag_7)) {
    tint_symbol_135 = vec3f();
    tint_symbol_136 = 0.0f;
    let x_2213 = ((x_2197.y - x_2197.x) / 256.0f);
    tint_symbol_129_2 = 0i;
    loop {
      if (!((tint_symbol_129_2 < 256i))) {
        break;
      }
      let x_2227 = tint_symbol_129_2;
      let x_2224 = tint_symbol_65((tint_symbol_23_9 + (tint_symbol_29_8 * (x_2197.x + ((f32(x_2227) + 0.5f) * x_2213)))));
      let x_2233 = clamp((x_2224 / 4095.0f), 0.0f, 1.0f);
      let x_2242 = ((x_2233 * x_2213) * 18.0f);
      tint_symbol_135 = (tint_symbol_135 + (mix(vec3f(0.05000000074505805969f, 0.05000000074505805969f, 0.10000000149011611938f), x_1329, vec3f(x_2233)) * ((1.0f - tint_symbol_136) * x_2242)));
      tint_symbol_136 = (tint_symbol_136 + ((1.0f - tint_symbol_136) * x_2242));
      if ((tint_symbol_136 >= 0.99000000953674316406f)) {
        break;
      }

      continuing {
        tint_symbol_129_2 = (tint_symbol_129_2 + 1i);
      }
    }
    let x_2268 = (tint_symbol_135 + (x_2266 * (1.0f - tint_symbol_136)));
    textureStore(tint_symbol_45, tint_symbol_103_3, vec4f(x_2268.x, x_2268.y, x_2268.z, 1.0f));
  }
  return;
}

fn tint_symbol_138(tint_symbol_103_4 : vec2i, tint_symbol_23_10 : vec3f, tint_symbol_29_9 : vec3f) {
  var tint_return_flag_8 = false;
  var tint_symbol_135_1 = vec3f();
  var tint_symbol_136_1 = 0.0f;
  var tint_symbol_129_3 = 0i;
  let x_2279 = tint_symbol_62(tint_symbol_23_10, tint_symbol_29_9);
  let x_2280 = tint_symbol_63(x_2279);
  if ((x_2280.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_4, x_2075);
    tint_return_flag_8 = true;
  }
  if (!(tint_return_flag_8)) {
    tint_symbol_135_1 = vec3f();
    tint_symbol_136_1 = 0.0f;
    let x_2296 = ((x_2280.y - x_2280.x) / 256.0f);
    tint_symbol_129_3 = 0i;
    loop {
      if (!((tint_symbol_129_3 < 256i))) {
        break;
      }
      let x_2310 = tint_symbol_129_3;
      let x_2307 = tint_symbol_65((tint_symbol_23_10 + (tint_symbol_29_9 * (x_2280.x + ((f32(x_2310) + 0.5f) * x_2296)))));
      let x_2318 = tint_symbol_85(clamp((x_2307 / 4095.0f), 0.0f, 1.0f));
      let x_2322 = ((x_2318.w * x_2296) * 14.0f);
      tint_symbol_135_1 = (tint_symbol_135_1 + (x_2318.xyz * ((1.0f - tint_symbol_136_1) * x_2322)));
      tint_symbol_136_1 = (tint_symbol_136_1 + ((1.0f - tint_symbol_136_1) * x_2322));
      if ((tint_symbol_136_1 >= 0.99000000953674316406f)) {
        break;
      }

      continuing {
        tint_symbol_129_3 = (tint_symbol_129_3 + 1i);
      }
    }
    let x_2347 = (tint_symbol_135_1 + (x_2266 * (1.0f - tint_symbol_136_1)));
    textureStore(tint_symbol_45, tint_symbol_103_4, vec4f(x_2347.x, x_2347.y, x_2347.z, 1.0f));
  }
  return;
}

fn tint_symbol_140(tint_symbol_103_5 : vec2i, tint_symbol_23_11 : vec3f, tint_symbol_29_10 : vec3f) {
  var tint_return_flag_9 = false;
  var tint_symbol_135_2 = vec3f();
  var tint_symbol_136_2 = 0.0f;
  var tint_symbol_129_4 = 0i;
  var x_2406 = vec3f();
  let x_2358 = tint_symbol_62(tint_symbol_23_11, tint_symbol_29_10);
  let x_2359 = tint_symbol_63(x_2358);
  if ((x_2359.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_5, x_2075);
    tint_return_flag_9 = true;
  }
  if (!(tint_return_flag_9)) {
    tint_symbol_135_2 = vec3f();
    tint_symbol_136_2 = 0.0f;
    let x_2375 = ((x_2359.y - x_2359.x) / 256.0f);
    tint_symbol_129_4 = 0i;
    loop {
      if (!((tint_symbol_129_4 < 256i))) {
        break;
      }
      var x_2393 : vec3f;
      var x_2395 : f32;
      x_2393 = (tint_symbol_23_11 + (tint_symbol_29_10 * (x_2359.x + ((f32(tint_symbol_129_4) + 0.5f) * x_2375))));
      let x_2394 = tint_symbol_65(x_2393);
      x_2395 = (x_2394 / 4095.0f);
      if ((x_2395 > 0.03999999910593032837f)) {
        let x_2399 = tint_symbol_71(x_2393);
        let x_2400 = clamp((x_2399 * 3.5f), 0.0f, 1.0f);
        let x_2411 = (((x_2400 * x_2395) * x_2375) * 28.0f);
        tint_symbol_135_2 = (tint_symbol_135_2 + (mix(vec3f(0.01999999955296516418f, 0.05000000074505805969f, 0.15000000596046447754f), vec3f(1.0f, 0.89999997615814208984f, 0.20000000298023223877f), vec3f(x_2400)) * ((1.0f - tint_symbol_136_2) * x_2411)));
        tint_symbol_136_2 = (tint_symbol_136_2 + ((1.0f - tint_symbol_136_2) * x_2411));
        if ((tint_symbol_136_2 >= 0.99000000953674316406f)) {
          break;
        }
      }

      continuing {
        tint_symbol_129_4 = (tint_symbol_129_4 + 1i);
      }
    }
    let x_2435 = (tint_symbol_135_2 + (x_2266 * (1.0f - tint_symbol_136_2)));
    textureStore(tint_symbol_45, tint_symbol_103_5, vec4f(x_2435.x, x_2435.y, x_2435.z, 1.0f));
  }
  return;
}

fn tint_symbol_143(tint_symbol_103_6 : vec2i, tint_symbol_23_12 : vec3f, tint_symbol_29_11 : vec3f) {
  var tint_return_flag_10 = false;
  var tint_symbol_135_3 = vec3f();
  var tint_symbol_136_3 = 0.0f;
  var tint_symbol_129_5 = 0i;
  let x_2446 = tint_symbol_62(tint_symbol_23_12, tint_symbol_29_11);
  let x_2447 = tint_symbol_63(x_2446);
  if ((x_2447.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_6, x_2075);
    tint_return_flag_10 = true;
  }
  if (!(tint_return_flag_10)) {
    tint_symbol_135_3 = vec3f();
    tint_symbol_136_3 = 0.0f;
    let x_2463 = ((x_2447.y - x_2447.x) / 256.0f);
    tint_symbol_129_5 = 0i;
    loop {
      if (!((tint_symbol_129_5 < 256i))) {
        break;
      }
      let x_2477 = tint_symbol_129_5;
      let x_2474 = tint_symbol_65((tint_symbol_23_12 + (tint_symbol_29_11 * (x_2447.x + ((f32(x_2477) + 0.5f) * x_2463)))));
      let x_2483 = clamp((x_2474 / 4095.0f), 0.0f, 1.0f);
      let x_2485 = tint_symbol_79(x_2483);
      let x_2487 = ((x_2483 * x_2463) * 18.0f);
      tint_symbol_135_3 = (tint_symbol_135_3 + (x_2485 * ((1.0f - tint_symbol_136_3) * x_2487)));
      tint_symbol_136_3 = (tint_symbol_136_3 + ((1.0f - tint_symbol_136_3) * x_2487));
      if ((tint_symbol_136_3 >= 0.99000000953674316406f)) {
        break;
      }

      continuing {
        tint_symbol_129_5 = (tint_symbol_129_5 + 1i);
      }
    }
    let x_2511 = (tint_symbol_135_3 + (x_2266 * (1.0f - tint_symbol_136_3)));
    textureStore(tint_symbol_45, tint_symbol_103_6, vec4f(x_2511.x, x_2511.y, x_2511.z, 1.0f));
  }
  return;
}

fn tint_symbol_144(tint_symbol_103_7 : vec2i, tint_symbol_23_13 : vec3f, tint_symbol_29_12 : vec3f) {
  var tint_return_flag_11 = false;
  var tint_symbol_135_4 = vec3f();
  var tint_symbol_136_4 = 0.0f;
  var tint_symbol_129_6 = 0i;
  let x_2522 = tint_symbol_62(tint_symbol_23_13, tint_symbol_29_12);
  let x_2523 = tint_symbol_63(x_2522);
  if ((x_2523.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_7, x_2075);
    tint_return_flag_11 = true;
  }
  if (!(tint_return_flag_11)) {
    tint_symbol_135_4 = vec3f();
    tint_symbol_136_4 = 0.0f;
    let x_2539 = ((x_2523.y - x_2523.x) / 256.0f);
    tint_symbol_129_6 = 0i;
    loop {
      if (!((tint_symbol_129_6 < 256i))) {
        break;
      }
      let x_2553 = tint_symbol_129_6;
      let x_2550 = tint_symbol_65((tint_symbol_23_13 + (tint_symbol_29_12 * (x_2523.x + ((f32(x_2553) + 0.5f) * x_2539)))));
      let x_2559 = clamp((x_2550 / 4095.0f), 0.0f, 1.0f);
      let x_2561 = tint_symbol_91(x_2559);
      let x_2563 = ((x_2559 * x_2539) * 18.0f);
      tint_symbol_135_4 = (tint_symbol_135_4 + (x_2561 * ((1.0f - tint_symbol_136_4) * x_2563)));
      tint_symbol_136_4 = (tint_symbol_136_4 + ((1.0f - tint_symbol_136_4) * x_2563));
      if ((tint_symbol_136_4 >= 0.99000000953674316406f)) {
        break;
      }

      continuing {
        tint_symbol_129_6 = (tint_symbol_129_6 + 1i);
      }
    }
    let x_2587 = (tint_symbol_135_4 + (x_2266 * (1.0f - tint_symbol_136_4)));
    textureStore(tint_symbol_45, tint_symbol_103_7, vec4f(x_2587.x, x_2587.y, x_2587.z, 1.0f));
  }
  return;
}

fn tint_symbol_145(tint_symbol_103_8 : vec2i, tint_symbol_23_14 : vec3f, tint_symbol_29_13 : vec3f) {
  tint_symbol_102(tint_symbol_103_8, tint_symbol_23_14, tint_symbol_29_13, false);
  return;
}

fn tint_symbol_146(tint_symbol_103_9 : vec2i, tint_symbol_23_15 : vec3f, tint_symbol_29_14 : vec3f) {
  var tint_return_flag_12 = false;
  var tint_symbol_135_5 = vec3f();
  var tint_symbol_136_5 = 0.0f;
  var tint_symbol_129_7 = 0i;
  var x_2648 = vec3f();
  let x_2604 = tint_symbol_62(tint_symbol_23_15, tint_symbol_29_14);
  let x_2605 = tint_symbol_63(x_2604);
  if ((x_2605.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_9, x_1703);
    tint_return_flag_12 = true;
  }
  if (!(tint_return_flag_12)) {
    tint_symbol_135_5 = vec3f();
    tint_symbol_136_5 = 0.0f;
    let x_2621 = ((x_2605.y - x_2605.x) / 256.0f);
    tint_symbol_129_7 = 0i;
    loop {
      if (!((tint_symbol_129_7 < 256i))) {
        break;
      }
      var x_2641 : f32;
      let x_2635 = tint_symbol_129_7;
      let x_2632 = tint_symbol_65((tint_symbol_23_15 + (tint_symbol_29_14 * (x_2605.x + ((f32(x_2635) + 0.5f) * x_2621)))));
      x_2641 = (x_2632 / 4095.0f);
      if ((x_2641 > 0.01999999955296516418f)) {
        let x_2652 = ((x_2641 * x_2621) * 12.0f);
        tint_symbol_135_5 = (tint_symbol_135_5 + (mix(vec3f(0.85000002384185791016f, 0.92000001668930053711f, 1.0f), x_1329, vec3f(x_2641)) * ((1.0f - tint_symbol_136_5) * x_2652)));
        tint_symbol_136_5 = (tint_symbol_136_5 + ((1.0f - tint_symbol_136_5) * x_2652));
        if ((tint_symbol_136_5 >= 0.99000000953674316406f)) {
          break;
        }
      }

      continuing {
        tint_symbol_129_7 = (tint_symbol_129_7 + 1i);
      }
    }
    let x_2676 = (tint_symbol_135_5 + (x_2042 * (1.0f - tint_symbol_136_5)));
    textureStore(tint_symbol_45, tint_symbol_103_9, vec4f(x_2676.x, x_2676.y, x_2676.z, 1.0f));
  }
  return;
}

fn tint_symbol_148(tint_symbol_103_10 : vec2i, tint_symbol_23_16 : vec3f, tint_symbol_29_15 : vec3f) {
  var tint_return_flag_13 = false;
  var tint_symbol_135_6 = vec3f();
  var tint_symbol_136_6 = 0.0f;
  var tint_symbol_129_8 = 0i;
  let x_2687 = tint_symbol_62(tint_symbol_23_16, tint_symbol_29_15);
  let x_2688 = tint_symbol_63(x_2687);
  if ((x_2688.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_10, x_2075);
    tint_return_flag_13 = true;
  }
  if (!(tint_return_flag_13)) {
    tint_symbol_135_6 = vec3f();
    tint_symbol_136_6 = 0.0f;
    let x_2704 = ((x_2688.y - x_2688.x) / 256.0f);
    tint_symbol_129_8 = 0i;
    loop {
      if (!((tint_symbol_129_8 < 256i))) {
        break;
      }
      var x_2724 : f32;
      let x_2718 = tint_symbol_129_8;
      let x_2715 = tint_symbol_65((tint_symbol_23_16 + (tint_symbol_29_15 * (x_2688.x + ((f32(x_2718) + 0.5f) * x_2704)))));
      x_2724 = (x_2715 / 4095.0f);
      if ((x_2724 > 0.01999999955296516418f)) {
        let x_2728 = tint_symbol_94(x_2724);
        let x_2732 = ((x_2728.w * x_2704) * 16.0f);
        tint_symbol_135_6 = (tint_symbol_135_6 + (x_2728.xyz * ((1.0f - tint_symbol_136_6) * x_2732)));
        tint_symbol_136_6 = (tint_symbol_136_6 + ((1.0f - tint_symbol_136_6) * x_2732));
        if ((tint_symbol_136_6 >= 0.99000000953674316406f)) {
          break;
        }
      }

      continuing {
        tint_symbol_129_8 = (tint_symbol_129_8 + 1i);
      }
    }
    let x_2759 = (tint_symbol_135_6 + (vec3f(0.03999999910593032837f, 0.00999999977648258209f, 0.00999999977648258209f) * (1.0f - tint_symbol_136_6)));
    textureStore(tint_symbol_45, tint_symbol_103_10, vec4f(x_2759.x, x_2759.y, x_2759.z, 1.0f));
  }
  return;
}

fn tint_symbol_150(tint_symbol_103_11 : vec2i, tint_symbol_23_17 : vec3f, tint_symbol_29_16 : vec3f) {
  var tint_return_flag_14 = false;
  var tint_symbol_135_7 = vec3f();
  var tint_symbol_136_7 = 0.0f;
  var tint_symbol_129_9 = 0i;
  var x_2814 = vec3f();
  let x_2770 = tint_symbol_62(tint_symbol_23_17, tint_symbol_29_16);
  let x_2771 = tint_symbol_63(x_2770);
  if ((x_2771.x < 0.0f)) {
    textureStore(tint_symbol_45, tint_symbol_103_11, x_1703);
    tint_return_flag_14 = true;
  }
  if (!(tint_return_flag_14)) {
    tint_symbol_135_7 = vec3f();
    tint_symbol_136_7 = 0.0f;
    let x_2787 = ((x_2771.y - x_2771.x) / 256.0f);
    tint_symbol_129_9 = 0i;
    loop {
      if (!((tint_symbol_129_9 < 256i))) {
        break;
      }
      var x_2807 : f32;
      let x_2801 = tint_symbol_129_9;
      let x_2798 = tint_symbol_65((tint_symbol_23_17 + (tint_symbol_29_16 * (x_2771.x + ((f32(x_2801) + 0.5f) * x_2787)))));
      x_2807 = (x_2798 / 4095.0f);
      if ((x_2807 > 0.01999999955296516418f)) {
        let x_2817 = ((x_2807 * x_2787) * 14.0f);
        tint_symbol_135_7 = (tint_symbol_135_7 + (mix(vec3f(0.20000000298023223877f, 0.21999999880790710449f, 0.25f), vec3f(0.75f, 0.77999997138977050781f, 0.80000001192092895508f), vec3f(x_2807)) * ((1.0f - tint_symbol_136_7) * x_2817)));
        tint_symbol_136_7 = (tint_symbol_136_7 + ((1.0f - tint_symbol_136_7) * x_2817));
        if ((tint_symbol_136_7 >= 0.99000000953674316406f)) {
          break;
        }
      }

      continuing {
        tint_symbol_129_9 = (tint_symbol_129_9 + 1i);
      }
    }
    let x_2841 = (tint_symbol_135_7 + (x_2042 * (1.0f - tint_symbol_136_7)));
    textureStore(tint_symbol_45, tint_symbol_103_11, vec4f(x_2841.x, x_2841.y, x_2841.z, 1.0f));
  }
  return;
}

fn tint_symbol_151(tint_symbol_103_12 : vec2i, tint_symbol_23_18 : vec3f, tint_symbol_29_17 : vec3f) {
  tint_symbol_102(tint_symbol_103_12, tint_symbol_23_18, tint_symbol_29_17, true);
  return;
}

const x_2857 = vec2f(2.0f);

fn tint_symbol_152(tint_symbol_103_13 : vec2i) -> Arr {
  var tint_symbol_154 = vec3f();
  var tint_symbol_155 = vec3f();
  let x_2862 = (x_2857 / tint_symbol_42.inner.tint_symbol_38.xy);
  tint_symbol_154 = vec3f((((f32(tint_symbol_103_13.x) + 0.5f) * x_2862.x) - 1.0f), (((f32(tint_symbol_103_13.y) + 0.5f) * x_2862.y) - 1.0f), 0.0f);
  tint_symbol_155 = vec3f(0.0f, 0.0f, 1.0f);
  let x_2880 = tint_symbol_154;
  let x_2879 = tint_symbol_46(x_2880);
  tint_symbol_154 = x_2879;
  let x_2882 = tint_symbol_155;
  let x_2881 = tint_symbol_48(x_2882);
  tint_symbol_155 = x_2881;
  let x_2883 = tint_symbol_154;
  let x_2884 = tint_symbol_155;
  return Arr(x_2883, x_2884);
}

fn tint_symbol_156(tint_symbol_103_14 : vec2i) -> Arr {
  var tint_symbol_154_1 = vec3f();
  var tint_symbol_155_1 = vec3f();
  let x_2895 = (x_2857 / (tint_symbol_42.inner.tint_symbol_38.xy * tint_symbol_42.inner.tint_symbol_37));
  tint_symbol_154_1 = vec3f();
  tint_symbol_155_1 = normalize(vec3f((((f32(tint_symbol_103_14.x) + 0.5f) * x_2895.x) - (1.0f / tint_symbol_42.inner.tint_symbol_37.x)), (((f32(tint_symbol_103_14.y) + 0.5f) * x_2895.y) - (1.0f / tint_symbol_42.inner.tint_symbol_37.y)), 1.0f));
  let x_2919 = tint_symbol_154_1;
  let x_2918 = tint_symbol_46(x_2919);
  tint_symbol_154_1 = x_2918;
  let x_2921 = tint_symbol_155_1;
  let x_2920 = tint_symbol_48(x_2921);
  tint_symbol_155_1 = x_2920;
  let x_2922 = tint_symbol_154_1;
  let x_2923 = tint_symbol_155_1;
  return Arr(x_2922, x_2923);
}

fn tint_symbol_157_inner(tint_symbol_158 : vec3u) {
  var x_2942 : bool;
  var x_2943 : bool;
  let x_2929 = bitcast<vec2i>(tint_symbol_158.xy);
  let x_2932 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_2937 = (x_2929.x < x_2932.x);
  x_2943 = x_2937;
  if (x_2937) {
    x_2942 = (x_2929.y < x_2932.y);
    x_2943 = x_2942;
  }
  if (x_2943) {
    let x_2946 = tint_symbol_152(x_2929);
    tint_symbol_126(x_2929, x_2946[0u], x_2946[1u]);
  }
  return;
}

fn tint_symbol_157_1() {
  let x_2954 = tint_symbol_158_1;
  tint_symbol_157_inner(x_2954);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMIPMain(@builtin(global_invocation_id) tint_symbol_158_1_param : vec3u) {
  tint_symbol_158_1 = tint_symbol_158_1_param;
  tint_symbol_157_1();
}

fn tint_symbol_160_inner(tint_symbol_158_25 : vec3u) {
  var x_2970 : bool;
  var x_2971 : bool;
  let x_2958 = bitcast<vec2i>(tint_symbol_158_25.xy);
  let x_2960 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_2965 = (x_2958.x < x_2960.x);
  x_2971 = x_2965;
  if (x_2965) {
    x_2970 = (x_2958.y < x_2960.y);
    x_2971 = x_2970;
  }
  if (x_2971) {
    let x_2974 = tint_symbol_156(x_2958);
    tint_symbol_126(x_2958, x_2974[0u], x_2974[1u]);
  }
  return;
}

fn tint_symbol_160_1() {
  let x_2981 = tint_symbol_158_2;
  tint_symbol_160_inner(x_2981);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMIPMain(@builtin(global_invocation_id) tint_symbol_158_2_param : vec3u) {
  tint_symbol_158_2 = tint_symbol_158_2_param;
  tint_symbol_160_1();
}

fn tint_symbol_161_inner(tint_symbol_158_26 : vec3u) {
  var x_2997 : bool;
  var x_2998 : bool;
  let x_2985 = bitcast<vec2i>(tint_symbol_158_26.xy);
  let x_2987 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_2992 = (x_2985.x < x_2987.x);
  x_2998 = x_2992;
  if (x_2992) {
    x_2997 = (x_2985.y < x_2987.y);
    x_2998 = x_2997;
  }
  if (x_2998) {
    let x_3001 = tint_symbol_152(x_2985);
    tint_symbol_130(x_2985, x_3001[0u], x_3001[1u]);
  }
  return;
}

fn tint_symbol_161_1() {
  let x_3008 = tint_symbol_158_3;
  tint_symbol_161_inner(x_3008);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalDRRMain(@builtin(global_invocation_id) tint_symbol_158_3_param : vec3u) {
  tint_symbol_158_3 = tint_symbol_158_3_param;
  tint_symbol_161_1();
}

fn tint_symbol_162_inner(tint_symbol_158_27 : vec3u) {
  var x_3024 : bool;
  var x_3025 : bool;
  let x_3012 = bitcast<vec2i>(tint_symbol_158_27.xy);
  let x_3014 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3019 = (x_3012.x < x_3014.x);
  x_3025 = x_3019;
  if (x_3019) {
    x_3024 = (x_3012.y < x_3014.y);
    x_3025 = x_3024;
  }
  if (x_3025) {
    let x_3028 = tint_symbol_156(x_3012);
    tint_symbol_130(x_3012, x_3028[0u], x_3028[1u]);
  }
  return;
}

fn tint_symbol_162_1() {
  let x_3035 = tint_symbol_158_4;
  tint_symbol_162_inner(x_3035);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveDRRMain(@builtin(global_invocation_id) tint_symbol_158_4_param : vec3u) {
  tint_symbol_158_4 = tint_symbol_158_4_param;
  tint_symbol_162_1();
}

fn tint_symbol_163_inner(tint_symbol_158_28 : vec3u) {
  var x_3051 : bool;
  var x_3052 : bool;
  let x_3039 = bitcast<vec2i>(tint_symbol_158_28.xy);
  let x_3041 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3046 = (x_3039.x < x_3041.x);
  x_3052 = x_3046;
  if (x_3046) {
    x_3051 = (x_3039.y < x_3041.y);
    x_3052 = x_3051;
  }
  if (x_3052) {
    let x_3055 = tint_symbol_152(x_3039);
    tint_symbol_134(x_3039, x_3055[0u], x_3055[1u]);
  }
  return;
}

fn tint_symbol_163_1() {
  let x_3062 = tint_symbol_158_5;
  tint_symbol_163_inner(x_3062);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalLinearTFMain(@builtin(global_invocation_id) tint_symbol_158_5_param : vec3u) {
  tint_symbol_158_5 = tint_symbol_158_5_param;
  tint_symbol_163_1();
}

fn tint_symbol_164_inner(tint_symbol_158_29 : vec3u) {
  var x_3078 : bool;
  var x_3079 : bool;
  let x_3066 = bitcast<vec2i>(tint_symbol_158_29.xy);
  let x_3068 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3073 = (x_3066.x < x_3068.x);
  x_3079 = x_3073;
  if (x_3073) {
    x_3078 = (x_3066.y < x_3068.y);
    x_3079 = x_3078;
  }
  if (x_3079) {
    let x_3082 = tint_symbol_156(x_3066);
    tint_symbol_134(x_3066, x_3082[0u], x_3082[1u]);
  }
  return;
}

fn tint_symbol_164_1() {
  let x_3089 = tint_symbol_158_6;
  tint_symbol_164_inner(x_3089);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveLinearTFMain(@builtin(global_invocation_id) tint_symbol_158_6_param : vec3u) {
  tint_symbol_158_6 = tint_symbol_158_6_param;
  tint_symbol_164_1();
}

fn tint_symbol_165_inner(tint_symbol_158_30 : vec3u) {
  var x_3105 : bool;
  var x_3106 : bool;
  let x_3093 = bitcast<vec2i>(tint_symbol_158_30.xy);
  let x_3095 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3100 = (x_3093.x < x_3095.x);
  x_3106 = x_3100;
  if (x_3100) {
    x_3105 = (x_3093.y < x_3095.y);
    x_3106 = x_3105;
  }
  if (x_3106) {
    let x_3109 = tint_symbol_152(x_3093);
    tint_symbol_138(x_3093, x_3109[0u], x_3109[1u]);
  }
  return;
}

fn tint_symbol_165_1() {
  let x_3116 = tint_symbol_158_7;
  tint_symbol_165_inner(x_3116);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalPiecewiseMain(@builtin(global_invocation_id) tint_symbol_158_7_param : vec3u) {
  tint_symbol_158_7 = tint_symbol_158_7_param;
  tint_symbol_165_1();
}

fn tint_symbol_166_inner(tint_symbol_158_31 : vec3u) {
  var x_3132 : bool;
  var x_3133 : bool;
  let x_3120 = bitcast<vec2i>(tint_symbol_158_31.xy);
  let x_3122 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3127 = (x_3120.x < x_3122.x);
  x_3133 = x_3127;
  if (x_3127) {
    x_3132 = (x_3120.y < x_3122.y);
    x_3133 = x_3132;
  }
  if (x_3133) {
    let x_3136 = tint_symbol_156(x_3120);
    tint_symbol_138(x_3120, x_3136[0u], x_3136[1u]);
  }
  return;
}

fn tint_symbol_166_1() {
  let x_3143 = tint_symbol_158_8;
  tint_symbol_166_inner(x_3143);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectivePiecewiseMain(@builtin(global_invocation_id) tint_symbol_158_8_param : vec3u) {
  tint_symbol_158_8 = tint_symbol_158_8_param;
  tint_symbol_166_1();
}

fn tint_symbol_167_inner(tint_symbol_158_32 : vec3u) {
  var x_3159 : bool;
  var x_3160 : bool;
  let x_3147 = bitcast<vec2i>(tint_symbol_158_32.xy);
  let x_3149 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3154 = (x_3147.x < x_3149.x);
  x_3160 = x_3154;
  if (x_3154) {
    x_3159 = (x_3147.y < x_3149.y);
    x_3160 = x_3159;
  }
  if (x_3160) {
    let x_3163 = tint_symbol_152(x_3147);
    tint_symbol_140(x_3147, x_3163[0u], x_3163[1u]);
  }
  return;
}

fn tint_symbol_167_1() {
  let x_3170 = tint_symbol_158_9;
  tint_symbol_167_inner(x_3170);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalGradientMain(@builtin(global_invocation_id) tint_symbol_158_9_param : vec3u) {
  tint_symbol_158_9 = tint_symbol_158_9_param;
  tint_symbol_167_1();
}

fn tint_symbol_168_inner(tint_symbol_158_33 : vec3u) {
  var x_3186 : bool;
  var x_3187 : bool;
  let x_3174 = bitcast<vec2i>(tint_symbol_158_33.xy);
  let x_3176 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3181 = (x_3174.x < x_3176.x);
  x_3187 = x_3181;
  if (x_3181) {
    x_3186 = (x_3174.y < x_3176.y);
    x_3187 = x_3186;
  }
  if (x_3187) {
    let x_3190 = tint_symbol_156(x_3174);
    tint_symbol_140(x_3174, x_3190[0u], x_3190[1u]);
  }
  return;
}

fn tint_symbol_168_1() {
  let x_3197 = tint_symbol_158_10;
  tint_symbol_168_inner(x_3197);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveGradientMain(@builtin(global_invocation_id) tint_symbol_158_10_param : vec3u) {
  tint_symbol_158_10 = tint_symbol_158_10_param;
  tint_symbol_168_1();
}

fn tint_symbol_169_inner(tint_symbol_158_34 : vec3u) {
  var x_3213 : bool;
  var x_3214 : bool;
  let x_3201 = bitcast<vec2i>(tint_symbol_158_34.xy);
  let x_3203 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3208 = (x_3201.x < x_3203.x);
  x_3214 = x_3208;
  if (x_3208) {
    x_3213 = (x_3201.y < x_3203.y);
    x_3214 = x_3213;
  }
  if (x_3214) {
    let x_3217 = tint_symbol_152(x_3201);
    tint_symbol_143(x_3201, x_3217[0u], x_3217[1u]);
  }
  return;
}

fn tint_symbol_169_1() {
  let x_3224 = tint_symbol_158_11;
  tint_symbol_169_inner(x_3224);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalSpectralMain(@builtin(global_invocation_id) tint_symbol_158_11_param : vec3u) {
  tint_symbol_158_11 = tint_symbol_158_11_param;
  tint_symbol_169_1();
}

fn tint_symbol_170_inner(tint_symbol_158_35 : vec3u) {
  var x_3240 : bool;
  var x_3241 : bool;
  let x_3228 = bitcast<vec2i>(tint_symbol_158_35.xy);
  let x_3230 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3235 = (x_3228.x < x_3230.x);
  x_3241 = x_3235;
  if (x_3235) {
    x_3240 = (x_3228.y < x_3230.y);
    x_3241 = x_3240;
  }
  if (x_3241) {
    let x_3244 = tint_symbol_156(x_3228);
    tint_symbol_143(x_3228, x_3244[0u], x_3244[1u]);
  }
  return;
}

fn tint_symbol_170_1() {
  let x_3251 = tint_symbol_158_12;
  tint_symbol_170_inner(x_3251);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveSpectralMain(@builtin(global_invocation_id) tint_symbol_158_12_param : vec3u) {
  tint_symbol_158_12 = tint_symbol_158_12_param;
  tint_symbol_170_1();
}

fn tint_symbol_171_inner(tint_symbol_158_36 : vec3u) {
  var x_3267 : bool;
  var x_3268 : bool;
  let x_3255 = bitcast<vec2i>(tint_symbol_158_36.xy);
  let x_3257 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3262 = (x_3255.x < x_3257.x);
  x_3268 = x_3262;
  if (x_3262) {
    x_3267 = (x_3255.y < x_3257.y);
    x_3268 = x_3267;
  }
  if (x_3268) {
    let x_3271 = tint_symbol_152(x_3255);
    tint_symbol_144(x_3255, x_3271[0u], x_3271[1u]);
  }
  return;
}

fn tint_symbol_171_1() {
  let x_3278 = tint_symbol_158_13;
  tint_symbol_171_inner(x_3278);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalWarmCoolMain(@builtin(global_invocation_id) tint_symbol_158_13_param : vec3u) {
  tint_symbol_158_13 = tint_symbol_158_13_param;
  tint_symbol_171_1();
}

fn tint_symbol_172_inner(tint_symbol_158_37 : vec3u) {
  var x_3294 : bool;
  var x_3295 : bool;
  let x_3282 = bitcast<vec2i>(tint_symbol_158_37.xy);
  let x_3284 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3289 = (x_3282.x < x_3284.x);
  x_3295 = x_3289;
  if (x_3289) {
    x_3294 = (x_3282.y < x_3284.y);
    x_3295 = x_3294;
  }
  if (x_3295) {
    let x_3298 = tint_symbol_156(x_3282);
    tint_symbol_144(x_3282, x_3298[0u], x_3298[1u]);
  }
  return;
}

fn tint_symbol_172_1() {
  let x_3305 = tint_symbol_158_14;
  tint_symbol_172_inner(x_3305);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveWarmCoolMain(@builtin(global_invocation_id) tint_symbol_158_14_param : vec3u) {
  tint_symbol_158_14 = tint_symbol_158_14_param;
  tint_symbol_172_1();
}

fn tint_symbol_173_inner(tint_symbol_158_38 : vec3u) {
  var x_3321 : bool;
  var x_3322 : bool;
  let x_3309 = bitcast<vec2i>(tint_symbol_158_38.xy);
  let x_3311 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3316 = (x_3309.x < x_3311.x);
  x_3322 = x_3316;
  if (x_3316) {
    x_3321 = (x_3309.y < x_3311.y);
    x_3322 = x_3321;
  }
  if (x_3322) {
    let x_3325 = tint_symbol_152(x_3309);
    tint_symbol_145(x_3309, x_3325[0u], x_3325[1u]);
  }
  return;
}

fn tint_symbol_173_1() {
  let x_3332 = tint_symbol_158_15;
  tint_symbol_173_inner(x_3332);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalTerrainMain(@builtin(global_invocation_id) tint_symbol_158_15_param : vec3u) {
  tint_symbol_158_15 = tint_symbol_158_15_param;
  tint_symbol_173_1();
}

fn tint_symbol_174_inner(tint_symbol_158_39 : vec3u) {
  var x_3348 : bool;
  var x_3349 : bool;
  let x_3336 = bitcast<vec2i>(tint_symbol_158_39.xy);
  let x_3338 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3343 = (x_3336.x < x_3338.x);
  x_3349 = x_3343;
  if (x_3343) {
    x_3348 = (x_3336.y < x_3338.y);
    x_3349 = x_3348;
  }
  if (x_3349) {
    let x_3352 = tint_symbol_156(x_3336);
    tint_symbol_145(x_3336, x_3352[0u], x_3352[1u]);
  }
  return;
}

fn tint_symbol_174_1() {
  let x_3359 = tint_symbol_158_16;
  tint_symbol_174_inner(x_3359);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveTerrainMain(@builtin(global_invocation_id) tint_symbol_158_16_param : vec3u) {
  tint_symbol_158_16 = tint_symbol_158_16_param;
  tint_symbol_174_1();
}

fn tint_symbol_175_inner(tint_symbol_158_40 : vec3u) {
  var x_3375 : bool;
  var x_3376 : bool;
  let x_3363 = bitcast<vec2i>(tint_symbol_158_40.xy);
  let x_3365 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3370 = (x_3363.x < x_3365.x);
  x_3376 = x_3370;
  if (x_3370) {
    x_3375 = (x_3363.y < x_3365.y);
    x_3376 = x_3375;
  }
  if (x_3376) {
    let x_3379 = tint_symbol_152(x_3363);
    tint_symbol_146(x_3363, x_3379[0u], x_3379[1u]);
  }
  return;
}

fn tint_symbol_175_1() {
  let x_3386 = tint_symbol_158_17;
  tint_symbol_175_inner(x_3386);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalCloudMain(@builtin(global_invocation_id) tint_symbol_158_17_param : vec3u) {
  tint_symbol_158_17 = tint_symbol_158_17_param;
  tint_symbol_175_1();
}

fn tint_symbol_176_inner(tint_symbol_158_41 : vec3u) {
  var x_3402 : bool;
  var x_3403 : bool;
  let x_3390 = bitcast<vec2i>(tint_symbol_158_41.xy);
  let x_3392 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3397 = (x_3390.x < x_3392.x);
  x_3403 = x_3397;
  if (x_3397) {
    x_3402 = (x_3390.y < x_3392.y);
    x_3403 = x_3402;
  }
  if (x_3403) {
    let x_3406 = tint_symbol_156(x_3390);
    tint_symbol_146(x_3390, x_3406[0u], x_3406[1u]);
  }
  return;
}

fn tint_symbol_176_1() {
  let x_3413 = tint_symbol_158_18;
  tint_symbol_176_inner(x_3413);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveCloudMain(@builtin(global_invocation_id) tint_symbol_158_18_param : vec3u) {
  tint_symbol_158_18 = tint_symbol_158_18_param;
  tint_symbol_176_1();
}

fn tint_symbol_177_inner(tint_symbol_158_42 : vec3u) {
  var x_3429 : bool;
  var x_3430 : bool;
  let x_3417 = bitcast<vec2i>(tint_symbol_158_42.xy);
  let x_3419 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3424 = (x_3417.x < x_3419.x);
  x_3430 = x_3424;
  if (x_3424) {
    x_3429 = (x_3417.y < x_3419.y);
    x_3430 = x_3429;
  }
  if (x_3430) {
    let x_3433 = tint_symbol_152(x_3417);
    tint_symbol_148(x_3417, x_3433[0u], x_3433[1u]);
  }
  return;
}

fn tint_symbol_177_1() {
  let x_3440 = tint_symbol_158_19;
  tint_symbol_177_inner(x_3440);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalFireMain(@builtin(global_invocation_id) tint_symbol_158_19_param : vec3u) {
  tint_symbol_158_19 = tint_symbol_158_19_param;
  tint_symbol_177_1();
}

fn tint_symbol_178_inner(tint_symbol_158_43 : vec3u) {
  var x_3456 : bool;
  var x_3457 : bool;
  let x_3444 = bitcast<vec2i>(tint_symbol_158_43.xy);
  let x_3446 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3451 = (x_3444.x < x_3446.x);
  x_3457 = x_3451;
  if (x_3451) {
    x_3456 = (x_3444.y < x_3446.y);
    x_3457 = x_3456;
  }
  if (x_3457) {
    let x_3460 = tint_symbol_156(x_3444);
    tint_symbol_148(x_3444, x_3460[0u], x_3460[1u]);
  }
  return;
}

fn tint_symbol_178_1() {
  let x_3467 = tint_symbol_158_20;
  tint_symbol_178_inner(x_3467);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveFireMain(@builtin(global_invocation_id) tint_symbol_158_20_param : vec3u) {
  tint_symbol_158_20 = tint_symbol_158_20_param;
  tint_symbol_178_1();
}

fn tint_symbol_179_inner(tint_symbol_158_44 : vec3u) {
  var x_3483 : bool;
  var x_3484 : bool;
  let x_3471 = bitcast<vec2i>(tint_symbol_158_44.xy);
  let x_3473 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3478 = (x_3471.x < x_3473.x);
  x_3484 = x_3478;
  if (x_3478) {
    x_3483 = (x_3471.y < x_3473.y);
    x_3484 = x_3483;
  }
  if (x_3484) {
    let x_3487 = tint_symbol_152(x_3471);
    tint_symbol_150(x_3471, x_3487[0u], x_3487[1u]);
  }
  return;
}

fn tint_symbol_179_1() {
  let x_3494 = tint_symbol_158_21;
  tint_symbol_179_inner(x_3494);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalSmokeMain(@builtin(global_invocation_id) tint_symbol_158_21_param : vec3u) {
  tint_symbol_158_21 = tint_symbol_158_21_param;
  tint_symbol_179_1();
}

fn tint_symbol_180_inner(tint_symbol_158_45 : vec3u) {
  var x_3510 : bool;
  var x_3511 : bool;
  let x_3498 = bitcast<vec2i>(tint_symbol_158_45.xy);
  let x_3500 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3505 = (x_3498.x < x_3500.x);
  x_3511 = x_3505;
  if (x_3505) {
    x_3510 = (x_3498.y < x_3500.y);
    x_3511 = x_3510;
  }
  if (x_3511) {
    let x_3514 = tint_symbol_156(x_3498);
    tint_symbol_150(x_3498, x_3514[0u], x_3514[1u]);
  }
  return;
}

fn tint_symbol_180_1() {
  let x_3521 = tint_symbol_158_22;
  tint_symbol_180_inner(x_3521);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveSmokeMain(@builtin(global_invocation_id) tint_symbol_158_22_param : vec3u) {
  tint_symbol_158_22 = tint_symbol_158_22_param;
  tint_symbol_180_1();
}

fn tint_symbol_181_inner(tint_symbol_158_46 : vec3u) {
  var x_3537 : bool;
  var x_3538 : bool;
  let x_3525 = bitcast<vec2i>(tint_symbol_158_46.xy);
  let x_3527 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3532 = (x_3525.x < x_3527.x);
  x_3538 = x_3532;
  if (x_3532) {
    x_3537 = (x_3525.y < x_3527.y);
    x_3538 = x_3537;
  }
  if (x_3538) {
    let x_3541 = tint_symbol_152(x_3525);
    tint_symbol_151(x_3525, x_3541[0u], x_3541[1u]);
  }
  return;
}

fn tint_symbol_181_1() {
  let x_3548 = tint_symbol_158_23;
  tint_symbol_181_inner(x_3548);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalComposedMain(@builtin(global_invocation_id) tint_symbol_158_23_param : vec3u) {
  tint_symbol_158_23 = tint_symbol_158_23_param;
  tint_symbol_181_1();
}

fn tint_symbol_182_inner(tint_symbol_158_47 : vec3u) {
  var x_3564 : bool;
  var x_3565 : bool;
  let x_3552 = bitcast<vec2i>(tint_symbol_158_47.xy);
  let x_3554 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_45)));
  let x_3559 = (x_3552.x < x_3554.x);
  x_3565 = x_3559;
  if (x_3559) {
    x_3564 = (x_3552.y < x_3554.y);
    x_3565 = x_3564;
  }
  if (x_3565) {
    let x_3568 = tint_symbol_156(x_3552);
    tint_symbol_151(x_3552, x_3568[0u], x_3568[1u]);
  }
  return;
}

fn tint_symbol_182_1() {
  let x_3575 = tint_symbol_158_24;
  tint_symbol_182_inner(x_3575);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveComposedMain(@builtin(global_invocation_id) tint_symbol_158_24_param : vec3u) {
  tint_symbol_158_24 = tint_symbol_158_24_param;
  tint_symbol_182_1();
}
