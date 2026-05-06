/*
 * Project 8 — Materials Studio
 *
 * Extends the Scroll-14 ray-box tracer with additional shading models,
 * procedural textures, and per-face material simulations.
 *
 * Shading models — selected via light.params[3]:
 *   0 – Lambertian  (flat / diffuse only)
 *   1 – Phong       (diffuse + specular + ambient)
 *   2 – Toon / Cel  (quantised Phong)
 *   3 – Blinn-Phong (half-vector specular — smoother highlight than Phong)
 *   4 – Cook-Torrance (physically-based: GGX NDF + Smith G + Schlick F)
 *
 * Light types — selected via light.params[2]:
 *   0 – Point light
 *   1 – Directional light
 *   2 – Spotlight
 *
 * Texture features — controlled by texFlags uniform:
 *   showTexture – stone tile 2-D texture on the floor face
 *   showBump    – bump-mapped normals derived from the stone tile luminance
 *   showCubeMap – Yokohama environment cube map on all non-floor faces
 *   showProc    – procedural checkerboard pattern on the back wall
 *
 * Interesting scene — "Materials Studio" room:
 *   Face 0 (front wall)  – Rough stone         (rough dielectric, Cook-Torrance)
 *   Face 1 (back wall)   – Teal stone / checker (medium dielectric, toggleable procedural)
 *   Face 2 (left wall)   – Wood panelling       (warm procedural grain, Cook-Torrance)
 *   Face 3 (right wall)  – Red plastic          (smooth dielectric, Cook-Torrance)
 *   Face 4 (ceiling)     – Brushed steel        (metallic, Cook-Torrance)
 *   Face 5 (floor)       – Stone tile           (textured + bump-mapped, Cook-Torrance)
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

struct tint_symbol_203 {
  /* @offset(0) */
  tint_symbol_68 : vec4f,
  /* @offset(16) */
  tint_symbol_204 : vec3f,
}

var<private> tint_symbol_254_1 : vec3u;

var<private> tint_symbol_254_2 : vec3u;

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

fn tint_symbol_101() -> vec4f {
  return vec4f(0.0f, 0.0f, 0.0f, 1.0f);
}

const x_1620 = vec4f(0.5f, 0.5f, 0.5f, 1.0f);

fn tint_symbol_102(tint_symbol_98_1 : i32) -> vec4f {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = vec4f();
  switch(tint_symbol_98_1) {
    case 5i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.55000001192092895508f, 0.51999998092651367188f, 0.5f, 1.0f);
    }
    case 4i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.75f, 0.75f, 0.77999997138977050781f, 1.0f);
    }
    case 3i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.69999998807907104492f, 0.10000000149011611938f, 0.10000000149011611938f, 1.0f);
    }
    case 2i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.55000001192092895508f, 0.30000001192092895508f, 0.10000000149011611938f, 1.0f);
    }
    case 1i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.20000000298023223877f, 0.44999998807907104492f, 0.55000001192092895508f, 1.0f);
    }
    case 0i: {
      tint_return_flag_2 = true;
      tint_return_value_2 = vec4f(0.5f, 0.46999999880790710449f, 0.43999999761581420898f, 1.0f);
    }
    default: {
      tint_return_flag_2 = true;
      tint_return_value_2 = x_1620;
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

fn tint_symbol_123(tint_symbol_124 : i32) -> vec4f {
  var tint_return_flag_4 = false;
  var tint_return_value_4 = vec4f();
  switch(tint_symbol_124) {
    case 9i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec4f(0.80000001192092895508f, 0.20000000298023223877f, 0.10000000149011611938f, 1.0f);
    }
    case 8i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec4f(0.10000000149011611938f, 0.69999998807907104492f, 0.20000000298023223877f, 1.0f);
    }
    case 7i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec4f(0.10000000149011611938f, 0.25f, 0.80000001192092895508f, 1.0f);
    }
    case 6i: {
      tint_return_flag_4 = true;
      tint_return_value_4 = vec4f(0.80000001192092895508f, 0.60000002384185791016f, 0.10000000149011611938f, 1.0f);
    }
    default: {
      tint_return_flag_4 = true;
      tint_return_value_4 = x_1620;
    }
  }
  let x_1658 = tint_return_value_4;
  return x_1658;
}

const x_1672 = vec3f(0.0f, 1.0f, 0.0f);

fn tint_symbol_125(tint_symbol_126 : vec3f) -> vec3f {
  var tint_return_flag_5 = false;
  var tint_return_value_5 = vec3f();
  if ((abs((tint_symbol_126.y - -0.21999999880790710449f)) < 0.00300000002607703209f)) {
    tint_return_flag_5 = true;
    tint_return_value_5 = x_1672;
  }
  if (!(tint_return_flag_5)) {
    if ((abs((tint_symbol_126.y - -0.5f)) < 0.00300000002607703209f)) {
      tint_return_flag_5 = true;
      tint_return_value_5 = x_1638;
    }
    if (!(tint_return_flag_5)) {
      tint_return_flag_5 = true;
      tint_return_value_5 = normalize(vec3f((tint_symbol_126.x - -0.34999999403953552246f), 0.0f, (tint_symbol_126.z - 0.34999999403953552246f)));
    }
  }
  let x_1696 = tint_return_value_5;
  return x_1696;
}

fn tint_symbol_128(tint_symbol_126_1 : vec3f) -> vec3f {
  var tint_return_flag_6 = false;
  var tint_return_value_6 = vec3f();
  if ((abs((tint_symbol_126_1.y - -0.5f)) < 0.00300000002607703209f)) {
    tint_return_flag_6 = true;
    tint_return_value_6 = x_1638;
  }
  if (!(tint_return_flag_6)) {
    tint_return_flag_6 = true;
    tint_return_value_6 = normalize(vec3f((tint_symbol_126_1.x - 0.34999999403953552246f), ((0.39285713434219360352f * 0.39285713434219360352f) * (-0.21999999880790710449f - tint_symbol_126_1.y)), (tint_symbol_126_1.z - -0.34999999403953552246f)));
  }
  let x_1723 = tint_return_value_6;
  return x_1723;
}

const x_1782 = vec3f(0.0f, 0.0f, 1.0f);

fn tint_symbol_132(tint_symbol_126_2 : vec3f) -> vec3f {
  var tint_return_flag_7 = false;
  var tint_return_value_7 = vec3f();
  if ((abs((tint_symbol_126_2.x - 0.23999999463558197021f)) < 0.00300000002607703209f)) {
    tint_return_flag_7 = true;
    tint_return_value_7 = x_1637;
  }
  if (!(tint_return_flag_7)) {
    if ((abs((tint_symbol_126_2.x - 0.46000000834465026855f)) < 0.00300000002607703209f)) {
      tint_return_flag_7 = true;
      tint_return_value_7 = vec3f(1.0f, 0.0f, 0.0f);
    }
    if (!(tint_return_flag_7)) {
      if ((abs((tint_symbol_126_2.y - -0.5f)) < 0.00300000002607703209f)) {
        tint_return_flag_7 = true;
        tint_return_value_7 = x_1638;
      }
      if (!(tint_return_flag_7)) {
        if ((abs((tint_symbol_126_2.y - -0.21999999880790710449f)) < 0.00300000002607703209f)) {
          tint_return_flag_7 = true;
          tint_return_value_7 = x_1672;
        }
        if (!(tint_return_flag_7)) {
          if ((abs((tint_symbol_126_2.z - 0.23999999463558197021f)) < 0.00300000002607703209f)) {
            tint_return_flag_7 = true;
            tint_return_value_7 = x_1636;
          }
          if (!(tint_return_flag_7)) {
            tint_return_flag_7 = true;
            tint_return_value_7 = x_1782;
          }
        }
      }
    }
  }
  let x_1783 = tint_return_value_7;
  return x_1783;
}

const x_1799 = vec3f(-0.34999999403953552246f, -0.40000000596046447754f, -0.34999999403953552246f);

fn tint_symbol_133(tint_symbol_124_1 : i32, tint_symbol_126_3 : vec3f) -> vec3f {
  var tint_return_flag_8 = false;
  var tint_return_value_8 = vec3f();
  switch(tint_symbol_124_1) {
    case 9i: {
      tint_return_flag_8 = true;
      let x_1803 = tint_symbol_132(tint_symbol_126_3);
      tint_return_value_8 = x_1803;
    }
    case 8i: {
      tint_return_flag_8 = true;
      let x_1802 = tint_symbol_128(tint_symbol_126_3);
      tint_return_value_8 = x_1802;
    }
    case 7i: {
      tint_return_flag_8 = true;
      let x_1801 = tint_symbol_125(tint_symbol_126_3);
      tint_return_value_8 = x_1801;
    }
    case 6i: {
      tint_return_flag_8 = true;
      tint_return_value_8 = normalize((tint_symbol_126_3 - x_1799));
    }
    default: {
      tint_return_flag_8 = true;
      tint_return_value_8 = x_1672;
    }
  }
  let x_1804 = tint_return_value_8;
  return x_1804;
}

fn tint_symbol_134(tint_symbol_1_3 : vec3f, tint_symbol_30_6 : vec3f, tint_symbol_135 : f32) -> f32 {
  var tint_return_flag_9 = false;
  var tint_return_value_9 = 0.0f;
  var tint_symbol_97_1 = 0.0f;
  let x_1813 = (tint_symbol_1_3 - x_1799);
  let x_1814 = dot(tint_symbol_30_6, tint_symbol_30_6);
  let x_1817 = (2.0f * dot(x_1813, tint_symbol_30_6));
  let x_1825 = ((x_1817 * x_1817) - ((4.0f * x_1814) * (dot(x_1813, x_1813) - 0.01000000070780515671f)));
  if ((x_1825 < 0.0f)) {
    tint_return_flag_9 = true;
    tint_return_value_9 = -1.0f;
  }
  if (!(tint_return_flag_9)) {
    let x_1833 = sqrt(x_1825);
    tint_symbol_97_1 = ((-(x_1817) - x_1833) / (2.0f * x_1814));
    if ((tint_symbol_97_1 < 0.00000000999999993923f)) {
      tint_symbol_97_1 = ((-(x_1817) + x_1833) / (2.0f * x_1814));
    }
    if ((tint_symbol_97_1 < 0.00000000999999993923f)) {
      tint_return_flag_9 = true;
      tint_return_value_9 = -1.0f;
    }
    var x_1859 : bool;
    var x_1860 : bool;
    if (!(tint_return_flag_9)) {
      let x_1855 = (tint_symbol_135 >= 0.0f);
      x_1860 = x_1855;
      if (x_1855) {
        x_1859 = (tint_symbol_97_1 >= tint_symbol_135);
        x_1860 = x_1859;
      }
      if (x_1860) {
        tint_return_flag_9 = true;
        tint_return_value_9 = -1.0f;
      }
      if (!(tint_return_flag_9)) {
        tint_return_flag_9 = true;
        tint_return_value_9 = tint_symbol_97_1;
      }
    }
  }
  let x_1868 = tint_return_value_9;
  return x_1868;
}

fn tint_symbol_140(tint_symbol_1_4 : vec3f, tint_symbol_30_7 : vec3f, tint_symbol_135_1 : f32) -> f32 {
  var tint_symbol_48 = 0.0f;
  var tint_symbol_145 = 0.0f;
  var tint_symbol_146 = 0.0f;
  var x_1885 : f32;
  var x_1891 : f32;
  var x_1896 : f32;
  tint_symbol_48 = -1.0f;
  let x_1876 = (tint_symbol_1_4.x - -0.34999999403953552246f);
  let x_1878 = (tint_symbol_1_4.z - 0.34999999403953552246f);
  x_1885 = ((tint_symbol_30_7.x * tint_symbol_30_7.x) + (tint_symbol_30_7.z * tint_symbol_30_7.z));
  x_1891 = (2.0f * ((x_1876 * tint_symbol_30_7.x) + (x_1878 * tint_symbol_30_7.z)));
  x_1896 = (((x_1876 * x_1876) + (x_1878 * x_1878)) - 0.00810000021010637283f);
  if ((x_1885 > 0.00000000999999993923f)) {
    var x_1903 : f32;
    var x_1928 : bool;
    var x_1929 : bool;
    var x_1933 : bool;
    var x_1934 : bool;
    var x_1947 : bool;
    var x_1948 : bool;
    var x_1952 : bool;
    var x_1953 : bool;
    x_1903 = ((x_1891 * x_1891) - ((4.0f * x_1885) * x_1896));
    if ((x_1903 >= 0.0f)) {
      let x_1907 = sqrt(x_1903);
      let x_1915 = ((-(x_1891) + x_1907) / (2.0f * x_1885));
      tint_symbol_145 = ((-(x_1891) - x_1907) / (2.0f * x_1885));
      tint_symbol_146 = (tint_symbol_1_4.y + (tint_symbol_145 * tint_symbol_30_7.y));
      let x_1924 = (tint_symbol_145 < 0.00000000999999993923f);
      x_1929 = x_1924;
      if (x_1924) {
      } else {
        x_1928 = (tint_symbol_146 < -0.5f);
        x_1929 = x_1928;
      }
      x_1934 = x_1929;
      if (x_1929) {
      } else {
        x_1933 = (tint_symbol_146 > -0.21999999880790710449f);
        x_1934 = x_1933;
      }
      if (x_1934) {
        tint_symbol_145 = x_1915;
        tint_symbol_146 = (tint_symbol_1_4.y + (tint_symbol_145 * tint_symbol_30_7.y));
      }
      let x_1943 = (tint_symbol_145 > 0.00000000999999993923f);
      x_1948 = x_1943;
      if (x_1943) {
        x_1947 = (tint_symbol_146 >= -0.5f);
        x_1948 = x_1947;
      }
      x_1953 = x_1948;
      if (x_1948) {
        x_1952 = (tint_symbol_146 <= -0.21999999880790710449f);
        x_1953 = x_1952;
      }
      var x_1960 : bool;
      var x_1961 : bool;
      if (x_1953) {
        let x_1956 = (tint_symbol_135_1 < 0.0f);
        x_1961 = x_1956;
        if (x_1956) {
        } else {
          x_1960 = (tint_symbol_145 < tint_symbol_135_1);
          x_1961 = x_1960;
        }
        if (x_1961) {
          tint_symbol_48 = tint_symbol_145;
        }
      }
    }
  }
  var x_1981 : bool;
  var x_1982 : bool;
  var x_1991 : bool;
  var x_1992 : bool;
  var x_2022 : bool;
  var x_2023 : bool;
  var x_2032 : bool;
  var x_2033 : bool;
  if ((abs(tint_symbol_30_7.y) > 0.00000000999999993923f)) {
    var x_1980 : bool;
    let x_1973 = ((-0.21999999880790710449f - tint_symbol_1_4.y) / tint_symbol_30_7.y);
    let x_1974 = (x_1973 > 0.00000000999999993923f);
    x_1982 = x_1974;
    if (x_1974) {
      let x_1977 = (tint_symbol_135_1 < 0.0f);
      x_1981 = x_1977;
      if (x_1977) {
      } else {
        x_1980 = (x_1973 < tint_symbol_135_1);
        x_1981 = x_1980;
      }
      x_1982 = x_1981;
    }
    var x_1990 : bool;
    x_1992 = x_1982;
    if (x_1982) {
      let x_1986 = (tint_symbol_48 < 0.0f);
      x_1991 = x_1986;
      if (x_1986) {
      } else {
        x_1990 = (x_1973 < tint_symbol_48);
        x_1991 = x_1990;
      }
      x_1992 = x_1991;
    }
    if (x_1992) {
      let x_1999 = ((tint_symbol_1_4.x + (x_1973 * tint_symbol_30_7.x)) - -0.34999999403953552246f);
      let x_2004 = ((tint_symbol_1_4.z + (x_1973 * tint_symbol_30_7.z)) - 0.34999999403953552246f);
      if ((((x_1999 * x_1999) + (x_2004 * x_2004)) <= 0.00810000021010637283f)) {
        tint_symbol_48 = x_1973;
      }
    }
    var x_2021 : bool;
    let x_2014 = ((-0.5f - tint_symbol_1_4.y) / tint_symbol_30_7.y);
    let x_2015 = (x_2014 > 0.00000000999999993923f);
    x_2023 = x_2015;
    if (x_2015) {
      let x_2018 = (tint_symbol_135_1 < 0.0f);
      x_2022 = x_2018;
      if (x_2018) {
      } else {
        x_2021 = (x_2014 < tint_symbol_135_1);
        x_2022 = x_2021;
      }
      x_2023 = x_2022;
    }
    var x_2031 : bool;
    x_2033 = x_2023;
    if (x_2023) {
      let x_2027 = (tint_symbol_48 < 0.0f);
      x_2032 = x_2027;
      if (x_2027) {
      } else {
        x_2031 = (x_2014 < tint_symbol_48);
        x_2032 = x_2031;
      }
      x_2033 = x_2032;
    }
    if (x_2033) {
      let x_2040 = ((tint_symbol_1_4.x + (x_2014 * tint_symbol_30_7.x)) - -0.34999999403953552246f);
      let x_2045 = ((tint_symbol_1_4.z + (x_2014 * tint_symbol_30_7.z)) - 0.34999999403953552246f);
      if ((((x_2040 * x_2040) + (x_2045 * x_2045)) <= 0.00810000021010637283f)) {
        tint_symbol_48 = x_2014;
      }
    }
  }
  let x_2052 = tint_symbol_48;
  return x_2052;
}

fn tint_symbol_150(tint_symbol_1_5 : vec3f, tint_symbol_30_8 : vec3f, tint_symbol_135_2 : f32) -> f32 {
  var tint_symbol_48_1 = 0.0f;
  var tint_symbol_145_1 = 0.0f;
  var tint_symbol_146_1 = 0.0f;
  var x_2076 : f32;
  var x_2086 : f32;
  var x_2092 : f32;
  let x_2059 = (tint_symbol_1_5.x - 0.34999999403953552246f);
  let x_2061 = (tint_symbol_1_5.z - -0.34999999403953552246f);
  let x_2063 = (tint_symbol_1_5.y - -0.21999999880790710449f);
  let x_2064 = (0.39285713434219360352f * 0.39285713434219360352f);
  x_2076 = (((tint_symbol_30_8.x * tint_symbol_30_8.x) + (tint_symbol_30_8.z * tint_symbol_30_8.z)) - ((x_2064 * tint_symbol_30_8.y) * tint_symbol_30_8.y));
  x_2086 = (2.0f * (((x_2059 * tint_symbol_30_8.x) + (x_2061 * tint_symbol_30_8.z)) - ((x_2064 * x_2063) * tint_symbol_30_8.y)));
  x_2092 = (((x_2059 * x_2059) + (x_2061 * x_2061)) - ((x_2064 * x_2063) * x_2063));
  tint_symbol_48_1 = -1.0f;
  if ((abs(x_2076) > 0.00000000999999993923f)) {
    var x_2101 : f32;
    var x_2126 : bool;
    var x_2127 : bool;
    var x_2131 : bool;
    var x_2132 : bool;
    var x_2145 : bool;
    var x_2146 : bool;
    var x_2150 : bool;
    var x_2151 : bool;
    x_2101 = ((x_2086 * x_2086) - ((4.0f * x_2076) * x_2092));
    if ((x_2101 >= 0.0f)) {
      let x_2105 = sqrt(x_2101);
      let x_2113 = ((-(x_2086) + x_2105) / (2.0f * x_2076));
      tint_symbol_145_1 = ((-(x_2086) - x_2105) / (2.0f * x_2076));
      tint_symbol_146_1 = (tint_symbol_1_5.y + (tint_symbol_145_1 * tint_symbol_30_8.y));
      let x_2122 = (tint_symbol_145_1 < 0.00000000999999993923f);
      x_2127 = x_2122;
      if (x_2122) {
      } else {
        x_2126 = (tint_symbol_146_1 < -0.5f);
        x_2127 = x_2126;
      }
      x_2132 = x_2127;
      if (x_2127) {
      } else {
        x_2131 = (tint_symbol_146_1 > -0.21999999880790710449f);
        x_2132 = x_2131;
      }
      if (x_2132) {
        tint_symbol_145_1 = x_2113;
        tint_symbol_146_1 = (tint_symbol_1_5.y + (tint_symbol_145_1 * tint_symbol_30_8.y));
      }
      let x_2141 = (tint_symbol_145_1 > 0.00000000999999993923f);
      x_2146 = x_2141;
      if (x_2141) {
        x_2145 = (tint_symbol_146_1 >= -0.5f);
        x_2146 = x_2145;
      }
      x_2151 = x_2146;
      if (x_2146) {
        x_2150 = (tint_symbol_146_1 <= -0.21999999880790710449f);
        x_2151 = x_2150;
      }
      var x_2158 : bool;
      var x_2159 : bool;
      if (x_2151) {
        let x_2154 = (tint_symbol_135_2 < 0.0f);
        x_2159 = x_2154;
        if (x_2154) {
        } else {
          x_2158 = (tint_symbol_145_1 < tint_symbol_135_2);
          x_2159 = x_2158;
        }
        if (x_2159) {
          tint_symbol_48_1 = tint_symbol_145_1;
        }
      }
    }
  }
  var x_2179 : bool;
  var x_2180 : bool;
  var x_2189 : bool;
  var x_2190 : bool;
  if ((abs(tint_symbol_30_8.y) > 0.00000000999999993923f)) {
    var x_2178 : bool;
    let x_2171 = ((-0.5f - tint_symbol_1_5.y) / tint_symbol_30_8.y);
    let x_2172 = (x_2171 > 0.00000000999999993923f);
    x_2180 = x_2172;
    if (x_2172) {
      let x_2175 = (tint_symbol_135_2 < 0.0f);
      x_2179 = x_2175;
      if (x_2175) {
      } else {
        x_2178 = (x_2171 < tint_symbol_135_2);
        x_2179 = x_2178;
      }
      x_2180 = x_2179;
    }
    var x_2188 : bool;
    x_2190 = x_2180;
    if (x_2180) {
      let x_2184 = (tint_symbol_48_1 < 0.0f);
      x_2189 = x_2184;
      if (x_2184) {
      } else {
        x_2188 = (x_2171 < tint_symbol_48_1);
        x_2189 = x_2188;
      }
      x_2190 = x_2189;
    }
    if (x_2190) {
      let x_2197 = ((tint_symbol_1_5.x + (x_2171 * tint_symbol_30_8.x)) - 0.34999999403953552246f);
      let x_2202 = ((tint_symbol_1_5.z + (x_2171 * tint_symbol_30_8.z)) - -0.34999999403953552246f);
      if ((((x_2197 * x_2197) + (x_2202 * x_2202)) <= 0.01209999993443489075f)) {
        tint_symbol_48_1 = x_2171;
      }
    }
  }
  let x_2210 = tint_symbol_48_1;
  return x_2210;
}

fn tint_symbol_153(tint_symbol_1_6 : vec3f, tint_symbol_30_9 : vec3f, tint_symbol_135_3 : f32) -> f32 {
  var tint_return_flag_10 = false;
  var tint_return_value_10 = 0.0f;
  var x_2269 : bool;
  var x_2270 : bool;
  let x_2237 = vec3f(select((1.0f / tint_symbol_30_9.x), 1000000015047466219876688855040.0f, (abs(tint_symbol_30_9.x) < 0.00000000999999993923f)), select((1.0f / tint_symbol_30_9.y), 1000000015047466219876688855040.0f, (abs(tint_symbol_30_9.y) < 0.00000000999999993923f)), select((1.0f / tint_symbol_30_9.z), 1000000015047466219876688855040.0f, (abs(tint_symbol_30_9.z) < 0.00000000999999993923f)));
  let x_2240 = ((vec3f(0.23999999463558197021f, -0.5f, 0.23999999463558197021f) - tint_symbol_1_6) * x_2237);
  let x_2243 = ((vec3f(0.46000000834465026855f, -0.21999999880790710449f, 0.46000000834465026855f) - tint_symbol_1_6) * x_2237);
  let x_2244 = max(max(min(x_2240.x, x_2243.x), min(x_2240.y, x_2243.y)), min(x_2240.z, x_2243.z));
  let x_2255 = min(min(max(x_2240.x, x_2243.x), max(x_2240.y, x_2243.y)), max(x_2240.z, x_2243.z));
  let x_2266 = (x_2255 < 0.00000000999999993923f);
  x_2270 = x_2266;
  if (x_2266) {
  } else {
    x_2269 = (x_2244 > x_2255);
    x_2270 = x_2269;
  }
  if (x_2270) {
    tint_return_flag_10 = true;
    tint_return_value_10 = -1.0f;
  }
  if (!(tint_return_flag_10)) {
    let x_2277 = select(x_2255, x_2244, (x_2244 > 0.00000000999999993923f));
    if ((x_2277 < 0.00000000999999993923f)) {
      tint_return_flag_10 = true;
      tint_return_value_10 = -1.0f;
    }
    var x_2289 : bool;
    var x_2290 : bool;
    if (!(tint_return_flag_10)) {
      let x_2286 = (tint_symbol_135_3 >= 0.0f);
      x_2290 = x_2286;
      if (x_2286) {
        x_2289 = (x_2277 >= tint_symbol_135_3);
        x_2290 = x_2289;
      }
      if (x_2290) {
        tint_return_flag_10 = true;
        tint_return_value_10 = -1.0f;
      }
      if (!(tint_return_flag_10)) {
        tint_return_flag_10 = true;
        tint_return_value_10 = x_2277;
      }
    }
  }
  let x_2297 = tint_return_value_10;
  return x_2297;
}

fn tint_symbol_157(tint_symbol_1_7 : vec3f, tint_symbol_30_10 : vec3f, tint_symbol_135_4 : f32) -> vec2f {
  var tint_return_flag_11 = false;
  var tint_return_value_11 = vec2f();
  var tint_symbol_97_2 = 0.0f;
  var tint_symbol_98_3 = 0.0f;
  tint_symbol_97_2 = tint_symbol_135_4;
  tint_symbol_98_3 = -1.0f;
  let x_2309 = tint_symbol_97_2;
  let x_2308 = tint_symbol_134(tint_symbol_1_7, tint_symbol_30_10, x_2309);
  if ((x_2308 > 0.0f)) {
    tint_symbol_97_2 = x_2308;
    tint_symbol_98_3 = 6.0f;
  }
  let x_2315 = tint_symbol_97_2;
  let x_2314 = tint_symbol_140(tint_symbol_1_7, tint_symbol_30_10, x_2315);
  if ((x_2314 > 0.0f)) {
    tint_symbol_97_2 = x_2314;
    tint_symbol_98_3 = 7.0f;
  }
  let x_2321 = tint_symbol_97_2;
  let x_2320 = tint_symbol_150(tint_symbol_1_7, tint_symbol_30_10, x_2321);
  if ((x_2320 > 0.0f)) {
    tint_symbol_97_2 = x_2320;
    tint_symbol_98_3 = 8.0f;
  }
  let x_2327 = tint_symbol_97_2;
  let x_2326 = tint_symbol_153(tint_symbol_1_7, tint_symbol_30_10, x_2327);
  if ((x_2326 > 0.0f)) {
    tint_symbol_97_2 = x_2326;
    tint_symbol_98_3 = 9.0f;
  }
  if ((tint_symbol_98_3 < 0.0f)) {
    tint_return_flag_11 = true;
    tint_return_value_11 = vec2f(-1.0f);
  }
  if (!(tint_return_flag_11)) {
    tint_return_flag_11 = true;
    tint_return_value_11 = vec2f(tint_symbol_97_2, tint_symbol_98_3);
  }
  let x_2344 = tint_return_value_11;
  return x_2344;
}

fn tint_symbol_162(tint_symbol_163 : i32, tint_symbol_126_4 : vec3f) -> vec2f {
  var tint_return_flag_12 = false;
  var tint_return_value_12 = vec2f();
  switch(tint_symbol_163) {
    case 5i: {
      tint_return_flag_12 = true;
      tint_return_value_12 = vec2f((tint_symbol_126_4.x + 0.5f), (tint_symbol_126_4.z + 0.5f));
    }
    case 4i: {
      tint_return_flag_12 = true;
      tint_return_value_12 = vec2f((tint_symbol_126_4.x + 0.5f), (0.5f - tint_symbol_126_4.z));
    }
    case 3i: {
      tint_return_flag_12 = true;
      tint_return_value_12 = vec2f((0.5f - tint_symbol_126_4.z), (tint_symbol_126_4.y + 0.5f));
    }
    case 2i: {
      tint_return_flag_12 = true;
      tint_return_value_12 = vec2f((tint_symbol_126_4.z + 0.5f), (tint_symbol_126_4.y + 0.5f));
    }
    case 1i: {
      tint_return_flag_12 = true;
      tint_return_value_12 = vec2f((0.5f - tint_symbol_126_4.x), (tint_symbol_126_4.y + 0.5f));
    }
    case 0i: {
      tint_return_flag_12 = true;
      tint_return_value_12 = vec2f((tint_symbol_126_4.x + 0.5f), (tint_symbol_126_4.y + 0.5f));
    }
    default: {
      tint_return_flag_12 = true;
      tint_return_value_12 = vec2f();
    }
  }
  let x_2390 = tint_return_value_12;
  return x_2390;
}

const x_2402 = vec3f(0.29899999499320983887f, 0.58700001239776611328f, 0.11400000005960464478f);

fn tint_symbol_164(tint_symbol_163_1 : i32, tint_symbol_165 : vec2f) -> vec3f {
  var tint_return_flag_13 = false;
  var tint_return_value_13 = vec3f();
  let x_2403 = dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, tint_symbol_165, 0.0f).xyz, x_2402);
  let x_2427 = ((dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, (tint_symbol_165 + vec2f(0.001953125f, 0.0f)), 0.0f).xyz, x_2402) - x_2403) * 4.0f);
  let x_2429 = ((dot(textureSampleLevel(tint_symbol_78, tint_symbol_77, (tint_symbol_165 + vec2f(0.0f, 0.001953125f)), 0.0f).xyz, x_2402) - x_2403) * 4.0f);
  switch(tint_symbol_163_1) {
    case 5i: {
      tint_return_flag_13 = true;
      tint_return_value_13 = normalize(vec3f(-(x_2427), -1.0f, -(x_2429)));
    }
    case 4i: {
      tint_return_flag_13 = true;
      tint_return_value_13 = normalize(vec3f(-(x_2427), -1.0f, x_2429));
    }
    case 3i: {
      tint_return_flag_13 = true;
      tint_return_value_13 = normalize(vec3f(-1.0f, -(x_2429), x_2427));
    }
    case 2i: {
      tint_return_flag_13 = true;
      tint_return_value_13 = normalize(vec3f(-1.0f, -(x_2429), -(x_2427)));
    }
    case 1i: {
      tint_return_flag_13 = true;
      tint_return_value_13 = normalize(vec3f(x_2427, -(x_2429), -1.0f));
    }
    case 0i: {
      tint_return_flag_13 = true;
      tint_return_value_13 = normalize(vec3f(-(x_2427), -(x_2429), -1.0f));
    }
    default: {
      tint_return_flag_13 = true;
      tint_return_value_13 = x_1636;
    }
  }
  let x_2459 = tint_return_value_13;
  return x_2459;
}

fn tint_symbol_173(tint_symbol_165_1 : vec2f, tint_symbol_65 : f32) -> vec4f {
  var tint_return_flag_14 = false;
  var tint_return_value_14 = vec4f();
  let x_2467 = floor((tint_symbol_165_1 * tint_symbol_65));
  if ((((x_2467.x + x_2467.y) % 2.0f) < 0.5f)) {
    tint_return_flag_14 = true;
    tint_return_value_14 = vec4f(0.05999999865889549255f, 0.05999999865889549255f, 0.05999999865889549255f, 1.0f);
  }
  if (!(tint_return_flag_14)) {
    tint_return_flag_14 = true;
    tint_return_value_14 = vec4f(0.93999999761581420898f, 0.93999999761581420898f, 0.93999999761581420898f, 1.0f);
  }
  let x_2484 = tint_return_value_14;
  return x_2484;
}

fn tint_symbol_176(tint_symbol_165_2 : vec2f) -> vec4f {
  var x_2517 = vec3f();
  let x_2516 = mix(vec3f(0.25999999046325683594f, 0.12999999523162841797f, 0.03999999910593032837f), vec3f(0.62000000476837158203f, 0.37999999523162841797f, 0.14000000059604644775f), vec3f(((sin((((tint_symbol_165_2.y * 28.0f) + (sin((tint_symbol_165_2.x * 9.0f)) * 1.79999995231628417969f)) + (cos((tint_symbol_165_2.x * 3.0f)) * 0.89999997615814208984f))) * 0.5f) + 0.5f)));
  return vec4f(x_2516.x, x_2516.y, x_2516.z, 1.0f);
}

fn tint_symbol_182(tint_symbol_183 : vec3f, tint_symbol_184 : vec3f, tint_symbol_185 : f32) -> f32 {
  let x_2528 = (tint_symbol_185 * tint_symbol_185);
  let x_2529 = (x_2528 * x_2528);
  let x_2530 = max(dot(tint_symbol_183, tint_symbol_184), 0.0f);
  let x_2535 = (((x_2530 * x_2530) * (x_2529 - 1.0f)) + 1.0f);
  return (x_2529 / ((3.14159274101257324219f * x_2535) * x_2535));
}

fn tint_symbol_190(tint_symbol_191 : f32, tint_symbol_185_1 : f32) -> f32 {
  let x_2548 = (((tint_symbol_185_1 + 1.0f) * (tint_symbol_185_1 + 1.0f)) / 8.0f);
  return (tint_symbol_191 / ((tint_symbol_191 * (1.0f - x_2548)) + x_2548));
}

fn tint_symbol_193(tint_symbol_183_1 : vec3f, tint_symbol_194 : vec3f, tint_symbol_51_1 : vec3f, tint_symbol_185_2 : f32) -> f32 {
  let x_2564 = tint_symbol_190(max(dot(tint_symbol_183_1, tint_symbol_194), 0.0f), tint_symbol_185_2);
  let x_2565 = tint_symbol_190(max(dot(tint_symbol_183_1, tint_symbol_51_1), 0.0f), tint_symbol_185_2);
  return (x_2564 * x_2565);
}

fn tint_symbol_197(tint_symbol_198 : f32, tint_symbol_199 : vec3f) -> vec3f {
  var x_2573 = vec3f();
  return (tint_symbol_199 + ((vec3f(1.0f) - tint_symbol_199) * pow(clamp((1.0f - tint_symbol_198), 0.0f, 1.0f), 5.0f)));
}

fn tint_symbol_200(tint_symbol_163_2 : i32) -> f32 {
  var tint_return_flag_15 = false;
  var tint_return_value_15 = 0.0f;
  switch(tint_symbol_163_2) {
    case 0i: {
      tint_return_flag_15 = true;
      tint_return_value_15 = 0.87999999523162841797f;
    }
    case 5i: {
      tint_return_flag_15 = true;
      tint_return_value_15 = 0.80000001192092895508f;
    }
    case 2i: {
      tint_return_flag_15 = true;
      tint_return_value_15 = 0.64999997615814208984f;
    }
    case 1i: {
      tint_return_flag_15 = true;
      tint_return_value_15 = 0.40000000596046447754f;
    }
    case 3i: {
      tint_return_flag_15 = true;
      tint_return_value_15 = 0.25f;
    }
    case 4i: {
      tint_return_flag_15 = true;
      tint_return_value_15 = 0.15000000596046447754f;
    }
    default: {
      tint_return_flag_15 = true;
      tint_return_value_15 = 0.5f;
    }
  }
  let x_2599 = tint_return_value_15;
  return x_2599;
}

fn tint_symbol_201(tint_symbol_163_3 : i32) -> f32 {
  var tint_return_flag_16 = false;
  var tint_return_value_16 = 0.0f;
  switch(tint_symbol_163_3) {
    case 4i: {
      tint_return_flag_16 = true;
      tint_return_value_16 = 1.0f;
    }
    default: {
      tint_return_flag_16 = true;
      tint_return_value_16 = 0.0f;
    }
  }
  let x_2608 = tint_return_value_16;
  return x_2608;
}

fn tint_symbol_202(tint_symbol_163_4 : i32) -> vec3f {
  var tint_return_flag_17 = false;
  var tint_return_value_17 = vec3f();
  switch(tint_symbol_163_4) {
    case 3i: {
      tint_return_flag_17 = true;
      tint_return_value_17 = vec3f(0.05000000074505805969f);
    }
    case 4i: {
      tint_return_flag_17 = true;
      tint_return_value_17 = vec3f(0.56000000238418579102f, 0.56999999284744262695f, 0.57999998331069946289f);
    }
    default: {
      tint_return_flag_17 = true;
      tint_return_value_17 = vec3f(0.03999999910593032837f);
    }
  }
  let x_2625 = tint_return_value_17;
  return x_2625;
}

fn tint_symbol_205(tint_symbol_206 : vec3f, tint_symbol_207 : vec3f, tint_symbol_208 : vec3f) -> tint_symbol_203 {
  var tint_symbol_87_4 = tint_symbol_203(vec4f(), vec3f());
  var x_2685 = vec4f();
  var x_2708 = vec4f();
  var x_2636 : i32;
  let x_2639 = tint_symbol_76.inner.tint_symbol_72.z;
  x_2636 = tint_ftoi(x_2639);
  if ((x_2636 == 1i)) {
    tint_symbol_87_4.tint_symbol_68 = tint_symbol_76.inner.tint_symbol_68;
    tint_symbol_87_4.tint_symbol_204 = normalize(tint_symbol_207);
  } else {
    if ((x_2636 == 2i)) {
      let x_2653 = normalize((tint_symbol_208 - tint_symbol_206));
      let x_2655 = dot(normalize(tint_symbol_207), x_2653);
      let x_2660 = tint_symbol_76.inner.tint_symbol_72.y;
      if ((x_2655 > cos(tint_symbol_76.inner.tint_symbol_72[0i]))) {
        let x_2667 = length((tint_symbol_208 - tint_symbol_206));
        tint_symbol_87_4.tint_symbol_68 = ((tint_symbol_76.inner.tint_symbol_68 * pow(x_2655, x_2660)) / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_2667 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_2667 * x_2667) * tint_symbol_76.inner.tint_symbol_71.z))));
      } else {
        tint_symbol_87_4.tint_symbol_68 = vec4f();
      }
      tint_symbol_87_4.tint_symbol_204 = x_2653;
    } else {
      let x_2691 = length((tint_symbol_208 - tint_symbol_206));
      tint_symbol_87_4.tint_symbol_68 = (tint_symbol_76.inner.tint_symbol_68 / vec4f(((tint_symbol_76.inner.tint_symbol_71[0i] + (x_2691 * tint_symbol_76.inner.tint_symbol_71.y)) + ((x_2691 * x_2691) * tint_symbol_76.inner.tint_symbol_71.z))));
      tint_symbol_87_4.tint_symbol_204 = normalize((tint_symbol_208 - tint_symbol_206));
    }
  }
  let x_2711 = tint_symbol_87_4;
  return x_2711;
}

fn tint_symbol_217(tint_symbol_218 : f32) -> f32 {
  var tint_return_flag_18 = false;
  var tint_return_value_18 = 0.0f;
  if ((tint_symbol_218 < 0.10000000149011611938f)) {
    tint_return_flag_18 = true;
    tint_return_value_18 = 0.0f;
  } else {
    if ((tint_symbol_218 < 0.34999999403953552246f)) {
      tint_return_flag_18 = true;
      tint_return_value_18 = 0.20000000298023223877f;
    } else {
      if ((tint_symbol_218 < 0.64999997615814208984f)) {
        tint_return_flag_18 = true;
        tint_return_value_18 = 0.5f;
      } else {
        if ((tint_symbol_218 < 0.89999997615814208984f)) {
          tint_return_flag_18 = true;
          tint_return_value_18 = 0.80000001192092895508f;
        } else {
          tint_return_flag_18 = true;
          tint_return_value_18 = 1.0f;
        }
      }
    }
  }
  let x_2734 = tint_return_value_18;
  return x_2734;
}

const x_2775 = vec4f(0.5f, 0.5f, 0.5f, 0.0f);

const x_2776 = vec4f(0.10000000149011611938f, 0.10000000149011611938f, 0.10000000149011611938f, 0.0f);

fn tint_symbol_219(tint_symbol_220 : vec4f, tint_symbol_221 : vec4f, tint_symbol_222 : vec3f, tint_symbol_223 : tint_symbol_203, tint_symbol_224 : vec3f, tint_symbol_225 : vec3f, tint_symbol_163_5 : i32) -> vec4f {
  var tint_return_flag_19 = false;
  var tint_return_value_19 = vec4f();
  var x_2834 = vec3f();
  var x_2847 = vec3f();
  var x_2857 = vec3f();
  var x_2747 : vec3f;
  var x_2749 : i32;
  var x_2753 : vec3f;
  var x_2755 : vec3f;
  x_2747 = tint_symbol_223.tint_symbol_204;
  let x_2748 = tint_symbol_223.tint_symbol_68;
  let x_2752 = tint_symbol_76.inner.tint_symbol_72.w;
  x_2749 = tint_ftoi(x_2752);
  x_2753 = normalize((tint_symbol_224 - tint_symbol_225));
  x_2755 = -(x_2747);
  let x_2756 = max(dot(tint_symbol_222, x_2755), 0.0f);
  if ((x_2749 == 0i)) {
    tint_return_flag_19 = true;
    tint_return_value_19 = (tint_symbol_220 + ((tint_symbol_221 * x_2748) * x_2756));
  } else {
    if ((x_2749 == 1i)) {
      tint_return_flag_19 = true;
      tint_return_value_19 = (((tint_symbol_220 + ((tint_symbol_221 * x_2748) * x_2756)) + ((x_2775 * x_2748) * pow(max(dot(x_2753, -(reflect(x_2747, tint_symbol_222))), 0.0f), 64.0f))) + ((x_2776 * tint_symbol_221) * x_2748));
    } else {
      if ((x_2749 == 2i)) {
        let x_2796 = tint_symbol_217(x_2756);
        let x_2798 = tint_symbol_217(pow(max(dot(x_2753, -(reflect(x_2747, tint_symbol_222))), 0.0f), 64.0f));
        tint_return_flag_19 = true;
        tint_return_value_19 = (((tint_symbol_220 + ((tint_symbol_221 * x_2748) * x_2796)) + ((x_2775 * x_2748) * x_2798)) + ((x_2776 * tint_symbol_221) * x_2748));
      } else {
        if ((x_2749 == 3i)) {
          tint_return_flag_19 = true;
          tint_return_value_19 = (((tint_symbol_220 + ((tint_symbol_221 * x_2748) * x_2756)) + ((x_2775 * x_2748) * pow(max(dot(tint_symbol_222, normalize((x_2753 + x_2755))), 0.0f), 128.0f))) + ((x_2776 * tint_symbol_221) * x_2748));
        } else {
          if ((x_2749 == 4i)) {
            let x_2829 = tint_symbol_221.xyz;
            let x_2830 = tint_symbol_200(tint_symbol_163_5);
            let x_2831 = tint_symbol_201(tint_symbol_163_5);
            let x_2832 = tint_symbol_202(tint_symbol_163_5);
            let x_2836 = normalize((x_2753 + x_2755));
            let x_2843 = tint_symbol_182(tint_symbol_222, x_2836, x_2830);
            let x_2844 = tint_symbol_197(max(dot(x_2753, x_2836), 0.0f), mix(x_2832, x_2829, vec3f(x_2831)));
            let x_2845 = tint_symbol_193(tint_symbol_222, x_2753, x_2755, x_2830);
            tint_return_flag_19 = true;
            let x_2867 = (((((((((vec3f(1.0f) - x_2844) * (1.0f - x_2831)) * x_2829) / vec3f(3.14159274101257324219f)) + (x_2844 * ((x_2843 * x_2845) / (4.0f * max(dot(tint_symbol_222, x_2753), 0.00100000004749745131f))))) * x_2748.xyz) * x_2756) + (x_2829 * 0.02999999932944774628f)) + tint_symbol_220.xyz);
            tint_return_value_19 = vec4f(x_2867.x, x_2867.y, x_2867.z, 1.0f);
          }
        }
      }
    }
  }
  if (!(tint_return_flag_19)) {
    tint_return_flag_19 = true;
    tint_return_value_19 = (tint_symbol_220 + ((tint_symbol_221 * x_2748) * x_2756));
  }
  let x_2879 = tint_return_value_19;
  return x_2879;
}

fn tint_symbol_247(tint_symbol_248 : vec3f, tint_symbol_249 : vec3f, tint_symbol_54_2 : vec2f) -> vec4f {
  var tint_return_flag_20 = false;
  var tint_return_value_20 = vec4f();
  var tint_symbol_221_1 = vec4f();
  var tint_symbol_222_1 = vec3f();
  var tint_symbol_32_1 = vec3f();
  var tint_symbol_225_1 = vec3f();
  var x_2924 : bool;
  var x_2925 : bool;
  let x_2888 = tint_ftoi(tint_symbol_54_2.y);
  let x_2892 = (tint_symbol_248 + (tint_symbol_249 * tint_symbol_54_2.x));
  if ((x_2888 >= 6i)) {
    let x_2899 = tint_symbol_123(x_2888);
    tint_symbol_221_1 = x_2899;
    let x_2900 = tint_symbol_133(x_2888, x_2892);
    let x_2901 = tint_symbol_90(x_2900);
    tint_symbol_222_1 = x_2901;
  } else {
    var x_2923 : bool;
    let x_2904 = tint_symbol_74.inner.tint_symbol_65;
    let x_2908 = tint_symbol_74.inner.tint_symbol_56;
    let x_2902 = tint_symbol_45((tint_symbol_249 * x_2904.xyz), x_2908);
    let x_2909 = normalize(x_2902);
    let x_2914 = (tint_symbol_85.inner.tint_symbol_83 != 0u);
    x_2925 = x_2914;
    if (x_2914) {
      let x_2919 = (tint_symbol_85.inner.tint_symbol_81 == 0u);
      x_2924 = x_2919;
      if (x_2919) {
      } else {
        x_2923 = (x_2888 != 5i);
        x_2924 = x_2923;
      }
      x_2925 = x_2924;
    }
    if (x_2925) {
      tint_return_flag_20 = true;
      tint_return_value_20 = textureSampleLevel(tint_symbol_79, tint_symbol_77, x_2909, 0.0f);
    }
    var x_2944 : bool;
    var x_2945 : bool;
    if (!(tint_return_flag_20)) {
      let x_2937 = tint_symbol_162(x_2888, x_2892);
      let x_2938 = (x_2937 * 4.0f);
      let x_2941 = (tint_symbol_85.inner.tint_symbol_81 != 0u);
      x_2945 = x_2941;
      if (x_2941) {
        x_2944 = (x_2888 == 5i);
        x_2945 = x_2944;
      }
      var x_2958 : bool;
      var x_2959 : bool;
      if (x_2945) {
        tint_symbol_221_1 = textureSampleLevel(tint_symbol_78, tint_symbol_77, x_2938, 0.0f);
      } else {
        let x_2955 = (tint_symbol_85.inner.tint_symbol_84 != 0u);
        x_2959 = x_2955;
        if (x_2955) {
          x_2958 = (x_2888 == 1i);
          x_2959 = x_2958;
        }
        if (x_2959) {
          let x_2963 = tint_symbol_173(x_2937, 8.0f);
          tint_symbol_221_1 = x_2963;
        } else {
          if ((x_2888 == 2i)) {
            let x_2968 = tint_symbol_176(x_2937);
            tint_symbol_221_1 = x_2968;
          } else {
            let x_2969 = tint_symbol_102(x_2888);
            tint_symbol_221_1 = x_2969;
          }
        }
      }
      let x_2970 = tint_symbol_103(x_2888);
      tint_symbol_32_1 = x_2970;
      if ((tint_symbol_85.inner.tint_symbol_82 != 0u)) {
        let x_2977 = tint_symbol_164(x_2888, x_2938);
        tint_symbol_32_1 = x_2977;
      }
      let x_2979 = tint_symbol_32_1;
      let x_2978 = tint_symbol_90(x_2979);
      tint_symbol_222_1 = x_2978;
    }
  }
  if (!(tint_return_flag_20)) {
    let x_2984 = tint_symbol_101();
    let x_2987 = tint_symbol_73.inner.tint_symbol_56;
    let x_2985 = tint_symbol_21(x_2987);
    let x_2990 = tint_symbol_76.inner.tint_symbol_69;
    let x_2988 = tint_symbol_44(x_2990.xyz, x_2985);
    let x_2994 = tint_symbol_73.inner.tint_symbol_56;
    let x_2992 = tint_symbol_21(x_2994);
    let x_2997 = tint_symbol_76.inner.tint_symbol_70;
    let x_2995 = tint_symbol_45(x_2997.xyz, x_2992);
    let x_2999 = tint_symbol_91(x_2892);
    tint_symbol_225_1 = x_2999;
    let x_3002 = tint_symbol_225_1;
    let x_3001 = tint_symbol_205(x_2988, x_2995, x_3002);
    let x_3005 = tint_symbol_73.inner.tint_symbol_56;
    let x_3003 = tint_symbol_44(vec3f(), x_3005);
    tint_return_flag_20 = true;
    let x_3007 = tint_symbol_221_1;
    let x_3008 = tint_symbol_222_1;
    let x_3009 = tint_symbol_225_1;
    let x_3006 = tint_symbol_219(x_2984, x_3007, x_3008, x_3001, x_3003, x_3009, x_2888);
    tint_return_value_20 = x_3006;
  }
  let x_3010 = tint_return_value_20;
  return x_3010;
}

const x_3034 = vec2f(2.0f);

const x_3074 = vec4f(0.0f, 0.21960784494876861572f, 0.39607843756675720215f, 1.0f);

fn tint_symbol_253_inner(tint_symbol_254 : vec3u) {
  var tint_symbol_248_1 = vec3f();
  var tint_symbol_249_1 = vec3f();
  var tint_symbol_54_3 = vec2f();
  var tint_symbol_258 = vec4f();
  var x_3030 : bool;
  var x_3031 : bool;
  let x_3016 = bitcast<vec2i>(tint_symbol_254.xy);
  let x_3020 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_3025 = (x_3016.x >= x_3020.x);
  x_3031 = x_3025;
  if (x_3025) {
  } else {
    x_3030 = (x_3016.y >= x_3020.y);
    x_3031 = x_3030;
  }
  if (x_3031) {
    return;
  }
  let x_3039 = (x_3034 / tint_symbol_73.inner.tint_symbol_58.xy);
  tint_symbol_248_1 = vec3f((((f32(x_3016.x) + 0.5f) * x_3039.x) - 1.0f), (((f32(x_3016.y) + 0.5f) * x_3039.y) - 1.0f), 0.0f);
  tint_symbol_249_1 = x_1782;
  let x_3056 = tint_symbol_248_1;
  let x_3055 = tint_symbol_88(x_3056);
  tint_symbol_248_1 = x_3055;
  let x_3058 = tint_symbol_249_1;
  let x_3057 = tint_symbol_86(x_3058);
  tint_symbol_249_1 = x_3057;
  let x_3060 = tint_symbol_248_1;
  let x_3061 = tint_symbol_249_1;
  let x_3059 = tint_symbol_96(x_3060, x_3061);
  tint_symbol_54_3 = x_3059;
  let x_3064 = tint_symbol_248_1;
  let x_3065 = tint_symbol_249_1;
  let x_3067 = tint_symbol_54_3.x;
  let x_3063 = tint_symbol_157(x_3064, x_3065, x_3067);
  if ((x_3063.x > 0.0f)) {
    tint_symbol_54_3 = x_3063;
  }
  tint_symbol_258 = x_3074;
  if ((tint_symbol_54_3.x > 0.0f)) {
    let x_3082 = tint_symbol_248_1;
    let x_3083 = tint_symbol_249_1;
    let x_3084 = tint_symbol_54_3;
    let x_3081 = tint_symbol_247(x_3082, x_3083, x_3084);
    tint_symbol_258 = x_3081;
  }
  let x_3087 = tint_symbol_258;
  textureStore(tint_symbol_75, x_3016, x_3087);
  return;
}

fn tint_symbol_253_1() {
  let x_3092 = tint_symbol_254_1;
  tint_symbol_253_inner(x_3092);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMain(@builtin(global_invocation_id) tint_symbol_254_1_param : vec3u) {
  tint_symbol_254_1 = tint_symbol_254_1_param;
  tint_symbol_253_1();
}

fn tint_symbol_259_inner(tint_symbol_254_3 : vec3u) {
  var tint_symbol_248_2 = vec3f();
  var tint_symbol_249_2 = vec3f();
  var tint_symbol_54_4 = vec2f();
  var tint_symbol_258_1 = vec4f();
  var x_3108 : bool;
  var x_3109 : bool;
  let x_3096 = bitcast<vec2i>(tint_symbol_254_3.xy);
  let x_3098 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_75)));
  let x_3103 = (x_3096.x >= x_3098.x);
  x_3109 = x_3103;
  if (x_3103) {
  } else {
    x_3108 = (x_3096.y >= x_3098.y);
    x_3109 = x_3108;
  }
  if (x_3109) {
    return;
  }
  let x_3118 = (x_3034 / (tint_symbol_73.inner.tint_symbol_58.xy * tint_symbol_73.inner.tint_symbol_57));
  tint_symbol_248_2 = vec3f();
  tint_symbol_249_2 = normalize(vec3f((((f32(x_3096.x) + 0.5f) * x_3118.x) - (1.0f / tint_symbol_73.inner.tint_symbol_57.x)), (((f32(x_3096.y) + 0.5f) * x_3118.y) - (1.0f / tint_symbol_73.inner.tint_symbol_57.y)), 1.0f));
  let x_3142 = tint_symbol_248_2;
  let x_3141 = tint_symbol_88(x_3142);
  tint_symbol_248_2 = x_3141;
  let x_3144 = tint_symbol_249_2;
  let x_3143 = tint_symbol_86(x_3144);
  tint_symbol_249_2 = x_3143;
  let x_3146 = tint_symbol_248_2;
  let x_3147 = tint_symbol_249_2;
  let x_3145 = tint_symbol_96(x_3146, x_3147);
  tint_symbol_54_4 = x_3145;
  let x_3150 = tint_symbol_248_2;
  let x_3151 = tint_symbol_249_2;
  let x_3153 = tint_symbol_54_4.x;
  let x_3149 = tint_symbol_157(x_3150, x_3151, x_3153);
  if ((x_3149.x > 0.0f)) {
    tint_symbol_54_4 = x_3149;
  }
  tint_symbol_258_1 = x_3074;
  if ((tint_symbol_54_4.x > 0.0f)) {
    let x_3165 = tint_symbol_248_2;
    let x_3166 = tint_symbol_249_2;
    let x_3167 = tint_symbol_54_4;
    let x_3164 = tint_symbol_247(x_3165, x_3166, x_3167);
    tint_symbol_258_1 = x_3164;
  }
  let x_3170 = tint_symbol_258_1;
  textureStore(tint_symbol_75, x_3096, x_3170);
  return;
}

fn tint_symbol_259_1() {
  let x_3174 = tint_symbol_254_2;
  tint_symbol_259_inner(x_3174);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMain(@builtin(global_invocation_id) tint_symbol_254_2_param : vec3u) {
  tint_symbol_254_2 = tint_symbol_254_2_param;
  tint_symbol_259_1();
}
