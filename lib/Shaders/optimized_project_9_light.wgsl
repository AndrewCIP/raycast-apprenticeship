/*
 * Project 9 — Shadows, Reflections & Refractions
 *
 * Shadow techniques
 *   SHADOW_HARD (0) – binary shadow-ray test
 *   SHADOW_AREA (1) – area-light sampling (8 samples, point light)
 *   SHADOW_PCF  (2) – Percentage-Closer Filtering (8 jittered rays, directional)
 *   SHADOW_DIST (3) – distance-based penumbra (spotlight)
 *   SHADOW_SDF  (4) – Signed Distance Field (Iñigo Quilez sphere-trace, any light)
 *
 * Reflection modes
 *   REFLECT_OFF    (0) – all reflective surfaces appear diffuse
 *   REFLECT_SINGLE (1) – exactly one mirror / floor bounce
 *   REFLECT_MULTI  (2) – up to maxBounces bounces
 *
 * Refraction modes
 *   REFRACT_OFF    (0) – glass sphere appears as an opaque tinted sphere
 *   REFRACT_SINGLE (1) – one Snell's Law refraction bounce
 *   REFRACT_MULTI  (2) – up to maxBounces refraction bounces
 *
 * Scene object IDs
 *   0–5 : box faces  (face 4 = ceiling, face 5 = floor)
 *   6   : glass sphere (IOR 1.5) — placed on the reflective floor
 *   7   : mirror sphere (perfect reflector)
 *   8   : opaque sphere (Phong diffuse, orange) — primary shadow caster
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

struct tint_symbol_53 {
  /* @offset(0) */
  tint_symbol_54 : tint_symbol,
  /* @offset(64) */
  tint_symbol_55 : vec2f,
  /* @offset(72) */
  tint_symbol_56 : vec2f,
}

struct tint_symbol_80_block {
  /* @offset(0) */
  inner : tint_symbol_53,
}

struct tint_symbol_57 {
  /* @offset(0) */
  tint_symbol_58 : vec4f,
  /* @offset(16) */
  tint_symbol_59 : vec4f,
  /* @offset(32) */
  tint_symbol_60 : vec4f,
  /* @offset(48) */
  tint_symbol_61 : vec4f,
}

alias Arr = array<tint_symbol_57, 6u>;

struct tint_symbol_62 {
  /* @offset(0) */
  tint_symbol_54 : tint_symbol,
  /* @offset(64) */
  tint_symbol_63 : vec4f,
  /* @offset(80) */
  tint_symbol_64 : Arr,
}

struct tint_symbol_81_block {
  /* @offset(0) */
  inner : tint_symbol_62,
}

struct tint_symbol_65 {
  /* @offset(0) */
  tint_symbol_66 : vec4f,
  /* @offset(16) */
  tint_symbol_67 : vec4f,
  /* @offset(32) */
  tint_symbol_68 : vec4f,
  /* @offset(48) */
  tint_symbol_69 : vec4f,
  /* @offset(64) */
  tint_symbol_70 : vec4f,
}

struct tint_symbol_83_block {
  /* @offset(0) */
  inner : tint_symbol_65,
}

struct tint_symbol_71 {
  /* @offset(0) */
  tint_symbol_72 : u32,
  /* @offset(4) */
  tint_symbol_73 : u32,
  /* @offset(8) */
  tint_symbol_74 : u32,
  /* @offset(12) */
  tint_symbol_75 : u32,
  /* @offset(16) */
  tint_symbol_76 : u32,
  /* @offset(20) */
  tint_symbol_77 : u32,
  /* @offset(24) */
  tint_symbol_78 : u32,
  /* @offset(28) */
  tint_symbol_79 : u32,
}

struct tint_symbol_84_block {
  /* @offset(0) */
  inner : tint_symbol_71,
}

struct tint_symbol_45 {
  /* @offset(0) */
  tint_symbol_23 : vec3f,
  /* @offset(12) */
  tint_symbol_46 : bool,
  /* @offset(16) */
  tint_symbol_47 : bool,
}

struct tint_symbol_101 {
  /* @offset(0) */
  tint_symbol_102 : f32,
  /* @offset(4) */
  tint_symbol_103 : i32,
  /* @offset(16) */
  tint_symbol_23 : vec3f,
  /* @offset(32) */
  tint_symbol_27 : vec3f,
}

struct tint_symbol_182 {
  /* @offset(0) */
  tint_symbol_66 : vec4f,
  /* @offset(16) */
  tint_symbol_183 : vec3f,
}

var<private> tint_symbol_236_1 : vec3u;

var<private> tint_symbol_236_2 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_80 : tint_symbol_80_block;

@group(0) @binding(1) var<uniform> tint_symbol_81 : tint_symbol_81_block;

@group(0) @binding(2) var tint_symbol_82 : texture_storage_2d<rgba8unorm, write>;

@group(0) @binding(3) var<uniform> tint_symbol_83 : tint_symbol_83_block;

@group(0) @binding(4) var<uniform> tint_symbol_84 : tint_symbol_84_block;

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
  let x_839 = tint_symbol_20;
  return x_839;
}

fn tint_symbol_21(tint_symbol_18_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_18_1.tint_symbol_1, -(tint_symbol_18_1.tint_symbol_2), -(tint_symbol_18_1.tint_symbol_3), -(tint_symbol_18_1.tint_symbol_4), -(tint_symbol_18_1.tint_symbol_5), -(tint_symbol_18_1.tint_symbol_6), -(tint_symbol_18_1.tint_symbol_7), -(tint_symbol_18_1.tint_symbol_8), -(tint_symbol_18_1.tint_symbol_9), -(tint_symbol_18_1.tint_symbol_10), -(tint_symbol_18_1.tint_symbol_11), tint_symbol_18_1.tint_symbol_12, tint_symbol_18_1.tint_symbol_13, tint_symbol_18_1.tint_symbol_14, tint_symbol_18_1.tint_symbol_15, tint_symbol_18_1.tint_symbol_16);
}

fn tint_symbol_22(tint_symbol_23 : tint_symbol, tint_symbol_24 : tint_symbol) -> tint_symbol {
  let x_875 = tint_symbol_21(tint_symbol_24);
  let x_876 = tint_symbol_17(tint_symbol_23, x_875);
  let x_877 = tint_symbol_17(tint_symbol_24, x_876);
  return x_877;
}

fn tint_symbol_25(tint_symbol_24_1 : tint_symbol) -> f32 {
  return sqrt(((((((((((((((((tint_symbol_24_1.tint_symbol_1 * tint_symbol_24_1.tint_symbol_1) + (tint_symbol_24_1.tint_symbol_2 * tint_symbol_24_1.tint_symbol_2)) + (tint_symbol_24_1.tint_symbol_3 * tint_symbol_24_1.tint_symbol_3)) + (tint_symbol_24_1.tint_symbol_4 * tint_symbol_24_1.tint_symbol_4)) + (tint_symbol_24_1.tint_symbol_5 * tint_symbol_24_1.tint_symbol_5)) + (tint_symbol_24_1.tint_symbol_6 * tint_symbol_24_1.tint_symbol_6)) + (tint_symbol_24_1.tint_symbol_7 * tint_symbol_24_1.tint_symbol_7)) + (tint_symbol_24_1.tint_symbol_8 * tint_symbol_24_1.tint_symbol_8)) + (tint_symbol_24_1.tint_symbol_9 * tint_symbol_24_1.tint_symbol_9)) + (tint_symbol_24_1.tint_symbol_10 * tint_symbol_24_1.tint_symbol_10)) + (tint_symbol_24_1.tint_symbol_11 * tint_symbol_24_1.tint_symbol_11)) + (tint_symbol_24_1.tint_symbol_12 * tint_symbol_24_1.tint_symbol_12)) + (tint_symbol_24_1.tint_symbol_13 * tint_symbol_24_1.tint_symbol_13)) + (tint_symbol_24_1.tint_symbol_14 * tint_symbol_24_1.tint_symbol_14)) + (tint_symbol_24_1.tint_symbol_15 * tint_symbol_24_1.tint_symbol_15)) + (tint_symbol_24_1.tint_symbol_16 * tint_symbol_24_1.tint_symbol_16)));
}

fn tint_symbol_26(tint_symbol_24_2 : tint_symbol) -> tint_symbol {
  var tint_return_flag = false;
  var tint_return_value = tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  let x_954 = tint_symbol_25(tint_symbol_24_2);
  if ((x_954 == 0.0f)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  }
  if (!(tint_return_flag)) {
    tint_return_flag = true;
    tint_return_value = tint_symbol((tint_symbol_24_2.tint_symbol_1 / x_954), (tint_symbol_24_2.tint_symbol_2 / x_954), (tint_symbol_24_2.tint_symbol_3 / x_954), (tint_symbol_24_2.tint_symbol_4 / x_954), (tint_symbol_24_2.tint_symbol_5 / x_954), (tint_symbol_24_2.tint_symbol_6 / x_954), (tint_symbol_24_2.tint_symbol_7 / x_954), (tint_symbol_24_2.tint_symbol_8 / x_954), (tint_symbol_24_2.tint_symbol_9 / x_954), (tint_symbol_24_2.tint_symbol_10 / x_954), (tint_symbol_24_2.tint_symbol_11 / x_954), (tint_symbol_24_2.tint_symbol_12 / x_954), (tint_symbol_24_2.tint_symbol_13 / x_954), (tint_symbol_24_2.tint_symbol_14 / x_954), (tint_symbol_24_2.tint_symbol_15 / x_954), (tint_symbol_24_2.tint_symbol_16 / x_954));
  }
  let x_999 = tint_return_value;
  return x_999;
}

fn tint_symbol_28(tint_symbol_29 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, tint_symbol_29.z, -(tint_symbol_29.y), tint_symbol_29.x, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_30(tint_symbol_1 : vec3f, tint_symbol_29_1 : vec3f) -> tint_symbol {
  let x_1015 = tint_symbol_28(tint_symbol_29_1);
  let x_1016 = tint_symbol_26(x_1015);
  return tint_symbol(0.0f, x_1016.tint_symbol_2, x_1016.tint_symbol_3, x_1016.tint_symbol_4, -(((-(x_1016.tint_symbol_3) * tint_symbol_1.z) - (x_1016.tint_symbol_2 * tint_symbol_1.y))), -(((x_1016.tint_symbol_2 * tint_symbol_1.x) - (x_1016.tint_symbol_4 * tint_symbol_1.z))), -(((x_1016.tint_symbol_4 * tint_symbol_1.y) + (x_1016.tint_symbol_3 * tint_symbol_1.x))), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_32(tint_symbol_24_3 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_24_3.tint_symbol_1, tint_symbol_24_3.tint_symbol_2, tint_symbol_24_3.tint_symbol_3, tint_symbol_24_3.tint_symbol_4, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_33(tint_symbol_23_1 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, -(tint_symbol_23_1.z), tint_symbol_23_1.y, -(tint_symbol_23_1.x), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

fn tint_symbol_34(tint_symbol_23_2 : tint_symbol) -> vec3f {
  return vec3f((-(tint_symbol_23_2.tint_symbol_11) / tint_symbol_23_2.tint_symbol_8), (tint_symbol_23_2.tint_symbol_10 / tint_symbol_23_2.tint_symbol_8), (-(tint_symbol_23_2.tint_symbol_9) / tint_symbol_23_2.tint_symbol_8));
}

fn tint_symbol_35(tint_symbol_36 : vec3f, tint_symbol_37 : vec3f, tint_symbol_38 : vec3f) -> tint_symbol {
  return tint_symbol(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, ((((tint_symbol_37.y * tint_symbol_38.z) - (tint_symbol_38.y * tint_symbol_37.z)) - ((tint_symbol_36.y * tint_symbol_38.z) - (tint_symbol_38.y * tint_symbol_36.z))) + ((tint_symbol_36.y * tint_symbol_37.z) - (tint_symbol_37.y * tint_symbol_36.z))), -(((((tint_symbol_37.x * tint_symbol_38.z) - (tint_symbol_38.x * tint_symbol_37.z)) - ((tint_symbol_36.x * tint_symbol_38.z) - (tint_symbol_38.x * tint_symbol_36.z))) + ((tint_symbol_36.x * tint_symbol_37.z) - (tint_symbol_37.x * tint_symbol_36.z)))), ((((tint_symbol_37.x * tint_symbol_38.y) - (tint_symbol_38.x * tint_symbol_37.y)) - ((tint_symbol_36.x * tint_symbol_38.y) - (tint_symbol_38.x * tint_symbol_36.y))) + ((tint_symbol_36.x * tint_symbol_37.y) - (tint_symbol_37.x * tint_symbol_36.y))), -((((tint_symbol_36.x * ((tint_symbol_37.y * tint_symbol_38.z) - (tint_symbol_38.y * tint_symbol_37.z))) - (tint_symbol_37.x * ((tint_symbol_36.y * tint_symbol_38.z) - (tint_symbol_38.y * tint_symbol_36.z)))) + (tint_symbol_38.x * ((tint_symbol_36.y * tint_symbol_37.z) - (tint_symbol_37.y * tint_symbol_36.z))))), 0.0f);
}

fn tint_symbol_42(tint_symbol_23_3 : vec3f, tint_symbol_24_4 : tint_symbol) -> vec3f {
  let x_1191 = tint_symbol_33(tint_symbol_23_3);
  let x_1192 = tint_symbol_22(x_1191, tint_symbol_24_4);
  let x_1193 = tint_symbol_34(x_1192);
  return x_1193;
}

fn tint_symbol_43(tint_symbol_29_2 : vec3f, tint_symbol_24_5 : tint_symbol) -> vec3f {
  let x_1198 = tint_symbol_33(tint_symbol_29_2);
  let x_1199 = tint_symbol_32(tint_symbol_24_5);
  let x_1200 = tint_symbol_22(x_1198, x_1199);
  let x_1201 = tint_symbol_34(x_1200);
  return x_1201;
}

fn tint_symbol_48(tint_symbol_49 : tint_symbol, tint_symbol_50 : tint_symbol) -> tint_symbol_45 {
  var tint_symbol_52 = tint_symbol_45(vec3f(), false, false);
  var x_1228 : bool;
  var x_1229 : bool;
  var x_1234 : bool;
  var x_1235 : bool;
  var x_1240 : bool;
  var x_1241 : bool;
  let x_1208 = tint_symbol_17(tint_symbol_49, tint_symbol_50);
  let x_1214 = tint_symbol_34(x_1208);
  tint_symbol_52.tint_symbol_23 = x_1214;
  tint_symbol_52.tint_symbol_46 = !((abs(x_1208.tint_symbol_8) <= 0.00000099999999747524f));
  let x_1223 = tint_symbol_52.tint_symbol_46;
  x_1229 = x_1223;
  if (x_1223) {
    x_1228 = (abs(x_1208.tint_symbol_9) <= 0.00000099999999747524f);
    x_1229 = x_1228;
  }
  x_1235 = x_1229;
  if (x_1229) {
    x_1234 = (abs(x_1208.tint_symbol_10) <= 0.00000099999999747524f);
    x_1235 = x_1234;
  }
  x_1241 = x_1235;
  if (x_1235) {
    x_1240 = (abs(x_1208.tint_symbol_11) <= 0.00000099999999747524f);
    x_1241 = x_1240;
  }
  tint_symbol_52.tint_symbol_47 = x_1241;
  let x_1242 = tint_symbol_52;
  return x_1242;
}

fn tint_symbol_104(tint_symbol_29_3 : vec3f) -> vec3f {
  var tint_symbol_105 = vec3f();
  let x_1250 = tint_symbol_80.inner.tint_symbol_54;
  let x_1247 = tint_symbol_43(tint_symbol_29_3, x_1250);
  tint_symbol_105 = x_1247;
  let x_1253 = tint_symbol_105;
  let x_1256 = tint_symbol_81.inner.tint_symbol_54;
  let x_1254 = tint_symbol_21(x_1256);
  let x_1257 = tint_symbol_43(x_1253, x_1254);
  tint_symbol_105 = x_1257;
  let x_1258 = tint_symbol_105;
  let x_1261 = tint_symbol_81.inner.tint_symbol_63;
  return (x_1258 / x_1261.xyz);
}

fn tint_symbol_106(tint_symbol_107 : vec3f) -> vec3f {
  var tint_symbol_105_1 = vec3f();
  let x_1269 = tint_symbol_80.inner.tint_symbol_54;
  let x_1267 = tint_symbol_42(tint_symbol_107, x_1269);
  tint_symbol_105_1 = x_1267;
  let x_1271 = tint_symbol_105_1;
  let x_1274 = tint_symbol_81.inner.tint_symbol_54;
  let x_1272 = tint_symbol_21(x_1274);
  let x_1275 = tint_symbol_42(x_1271, x_1272);
  tint_symbol_105_1 = x_1275;
  let x_1276 = tint_symbol_105_1;
  let x_1278 = tint_symbol_81.inner.tint_symbol_63;
  return (x_1276 / x_1278.xyz);
}

fn tint_symbol_108(tint_symbol_27 : vec3f) -> vec3f {
  var tint_symbol_105_2 = vec3f();
  tint_symbol_105_2 = (tint_symbol_27 * tint_symbol_81.inner.tint_symbol_63.xyz);
  let x_1290 = tint_symbol_105_2;
  let x_1292 = tint_symbol_81.inner.tint_symbol_54;
  let x_1289 = tint_symbol_43(x_1290, x_1292);
  tint_symbol_105_2 = x_1289;
  let x_1294 = tint_symbol_105_2;
  return normalize(x_1294);
}

fn tint_symbol_109(tint_symbol_107_1 : vec3f) -> vec3f {
  var tint_symbol_105_3 = vec3f();
  tint_symbol_105_3 = (tint_symbol_107_1 * tint_symbol_81.inner.tint_symbol_63.xyz);
  let x_1304 = tint_symbol_105_3;
  let x_1306 = tint_symbol_81.inner.tint_symbol_54;
  let x_1303 = tint_symbol_42(x_1304, x_1306);
  tint_symbol_105_3 = x_1303;
  let x_1307 = tint_symbol_105_3;
  return x_1307;
}

fn tint_symbol_110(tint_symbol_1_1 : vec3f, tint_symbol_29_4 : vec3f, tint_symbol_111 : tint_symbol_57, tint_symbol_112 : f32) -> vec2f {
  var tint_return_flag_1 = false;
  var tint_return_value_1 = vec2f();
  var tint_symbol_52_1 = tint_symbol_45(vec3f(), false, false);
  var tint_symbol_113 = 0.0f;
  let x_1319 = tint_symbol_30(tint_symbol_1_1, tint_symbol_29_4);
  let x_1321 = tint_symbol_111.tint_symbol_58;
  let x_1323 = tint_symbol_111.tint_symbol_59;
  let x_1325 = tint_symbol_111.tint_symbol_60;
  let x_1320 = tint_symbol_35(x_1321.xyz, x_1323.xyz, x_1325.xyz);
  let x_1327 = tint_symbol_48(x_1319, x_1320);
  tint_symbol_52_1 = x_1327;
  if (tint_symbol_52_1.tint_symbol_46) {
    var x_1355 : bool;
    var x_1356 : bool;
    var x_1371 : bool;
    var x_1372 : bool;
    if ((abs((tint_symbol_111.tint_symbol_58.z - tint_symbol_111.tint_symbol_60.z)) <= 0.00000099999999747524f)) {
      let x_1348 = (tint_symbol_111.tint_symbol_58.x <= tint_symbol_52_1.tint_symbol_23.x);
      x_1356 = x_1348;
      if (x_1348) {
        x_1355 = (tint_symbol_52_1.tint_symbol_23.x <= tint_symbol_111.tint_symbol_60.x);
        x_1356 = x_1355;
      }
      var x_1370 : bool;
      x_1372 = x_1356;
      if (x_1356) {
        let x_1363 = (tint_symbol_111.tint_symbol_58.y <= tint_symbol_52_1.tint_symbol_23.y);
        x_1371 = x_1363;
        if (x_1363) {
          x_1370 = (tint_symbol_52_1.tint_symbol_23.y <= tint_symbol_111.tint_symbol_60.y);
          x_1371 = x_1370;
        }
        x_1372 = x_1371;
      }
      tint_symbol_52_1.tint_symbol_46 = x_1372;
    } else {
      var x_1395 : bool;
      var x_1396 : bool;
      var x_1411 : bool;
      var x_1412 : bool;
      if ((abs((tint_symbol_111.tint_symbol_58.y - tint_symbol_111.tint_symbol_60.y)) <= 0.00000099999999747524f)) {
        let x_1388 = (tint_symbol_111.tint_symbol_58.x <= tint_symbol_52_1.tint_symbol_23.x);
        x_1396 = x_1388;
        if (x_1388) {
          x_1395 = (tint_symbol_52_1.tint_symbol_23.x <= tint_symbol_111.tint_symbol_60.x);
          x_1396 = x_1395;
        }
        var x_1410 : bool;
        x_1412 = x_1396;
        if (x_1396) {
          let x_1403 = (tint_symbol_111.tint_symbol_58.z <= tint_symbol_52_1.tint_symbol_23.z);
          x_1411 = x_1403;
          if (x_1403) {
            x_1410 = (tint_symbol_52_1.tint_symbol_23.z <= tint_symbol_111.tint_symbol_60.z);
            x_1411 = x_1410;
          }
          x_1412 = x_1411;
        }
        tint_symbol_52_1.tint_symbol_46 = x_1412;
      } else {
        var x_1434 : bool;
        var x_1435 : bool;
        var x_1450 : bool;
        var x_1451 : bool;
        if ((abs((tint_symbol_111.tint_symbol_58.x - tint_symbol_111.tint_symbol_60.x)) <= 0.00000099999999747524f)) {
          let x_1427 = (tint_symbol_111.tint_symbol_58.y <= tint_symbol_52_1.tint_symbol_23.y);
          x_1435 = x_1427;
          if (x_1427) {
            x_1434 = (tint_symbol_52_1.tint_symbol_23.y <= tint_symbol_111.tint_symbol_60.y);
            x_1435 = x_1434;
          }
          var x_1449 : bool;
          x_1451 = x_1435;
          if (x_1435) {
            let x_1442 = (tint_symbol_111.tint_symbol_58.z <= tint_symbol_52_1.tint_symbol_23.z);
            x_1450 = x_1442;
            if (x_1442) {
              x_1449 = (tint_symbol_52_1.tint_symbol_23.z <= tint_symbol_111.tint_symbol_60.z);
              x_1450 = x_1449;
            }
            x_1451 = x_1450;
          }
          tint_symbol_52_1.tint_symbol_46 = x_1451;
        }
      }
    }
    if (tint_symbol_52_1.tint_symbol_46) {
      tint_symbol_113 = -1.0f;
      if ((tint_symbol_29_4.x > 0.00000099999999747524f)) {
        tint_symbol_113 = ((tint_symbol_52_1.tint_symbol_23.x - tint_symbol_1_1.x) / tint_symbol_29_4.x);
      } else {
        if ((tint_symbol_29_4.y > 0.00000099999999747524f)) {
          tint_symbol_113 = ((tint_symbol_52_1.tint_symbol_23.y - tint_symbol_1_1.y) / tint_symbol_29_4.y);
        } else {
          tint_symbol_113 = ((tint_symbol_52_1.tint_symbol_23.z - tint_symbol_1_1.z) / tint_symbol_29_4.z);
        }
      }
      if ((tint_symbol_113 < 0.0f)) {
        tint_return_flag_1 = true;
        tint_return_value_1 = vec2f(tint_symbol_112, -1.0f);
      } else {
        if ((tint_symbol_112 < 0.0f)) {
          tint_return_flag_1 = true;
          tint_return_value_1 = vec2f(tint_symbol_113, 1.0f);
        } else {
          if ((tint_symbol_113 < tint_symbol_112)) {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_113, 1.0f);
          } else {
            tint_return_flag_1 = true;
            tint_return_value_1 = vec2f(tint_symbol_112, -1.0f);
          }
        }
      }
    }
  }
  if (!(tint_return_flag_1)) {
    tint_return_flag_1 = true;
    tint_return_value_1 = vec2f(tint_symbol_112, -1.0f);
  }
  let x_1511 = tint_return_value_1;
  return x_1511;
}

fn tint_symbol_114(tint_symbol_1_2 : vec3f, tint_symbol_29_5 : vec3f) -> vec2f {
  var tint_symbol_102 = 0.0f;
  var tint_symbol_115 = 0.0f;
  var tint_symbol_116 = 0i;
  tint_symbol_102 = -1.0f;
  tint_symbol_115 = -1.0f;
  tint_symbol_116 = 0i;
  loop {
    if (!((tint_symbol_116 < 6i))) {
      break;
    }
    let x_1536 = tint_symbol_81.inner.tint_symbol_64[tint_symbol_116];
    let x_1537 = tint_symbol_102;
    let x_1532 = tint_symbol_110(tint_symbol_1_2, tint_symbol_29_5, x_1536, x_1537);
    if ((x_1532.y > 0.0f)) {
      tint_symbol_102 = x_1532.x;
      tint_symbol_115 = f32(tint_symbol_116);
    }

    continuing {
      tint_symbol_116 = (tint_symbol_116 + 1i);
    }
  }
  let x_1548 = tint_symbol_102;
  let x_1549 = tint_symbol_115;
  return vec2f(x_1548, x_1549);
}

fn tint_symbol_118(tint_symbol_119 : vec3f, tint_symbol_31 : vec3f, tint_symbol_120 : vec3f, tint_symbol_121 : f32) -> f32 {
  var tint_return_flag_2 = false;
  var tint_return_value_2 = 0.0f;
  let x_1560 = (tint_symbol_119 - tint_symbol_120);
  let x_1561 = dot(x_1560, tint_symbol_31);
  let x_1566 = ((x_1561 * x_1561) - (dot(x_1560, x_1560) - (tint_symbol_121 * tint_symbol_121)));
  if ((x_1566 < 0.0f)) {
    tint_return_flag_2 = true;
    tint_return_value_2 = -1.0f;
  }
  if (!(tint_return_flag_2)) {
    let x_1574 = sqrt(x_1566);
    let x_1576 = (-(x_1561) - x_1574);
    if ((x_1576 > 0.0f)) {
      tint_return_flag_2 = true;
      tint_return_value_2 = x_1576;
    }
    if (!(tint_return_flag_2)) {
      let x_1585 = (-(x_1561) + x_1574);
      if ((x_1585 > 0.0f)) {
        tint_return_flag_2 = true;
        tint_return_value_2 = x_1585;
      }
      if (!(tint_return_flag_2)) {
        tint_return_flag_2 = true;
        tint_return_value_2 = -1.0f;
      }
    }
  }
  let x_1593 = tint_return_value_2;
  return x_1593;
}

const x_1613 = vec3f(0.0f, 1.0f, 0.0f);

const x_1610 = vec3f(1.0f, 0.0f, 0.0f);

const x_1609 = vec3f(0.0f, 0.0f, 1.0f);

fn tint_symbol_128(tint_symbol_115_1 : i32) -> vec3f {
  var tint_return_flag_3 = false;
  var tint_return_value_3 = vec3f();
  switch(tint_symbol_115_1) {
    case 5i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1613;
    }
    case 4i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = vec3f(0.0f, -1.0f, 0.0f);
    }
    case 3i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = vec3f(-1.0f, 0.0f, 0.0f);
    }
    case 2i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1610;
    }
    case 1i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = x_1609;
    }
    case 0i: {
      tint_return_flag_3 = true;
      tint_return_value_3 = vec3f(0.0f, 0.0f, -1.0f);
    }
    default: {
      tint_return_flag_3 = true;
      tint_return_value_3 = vec3f();
    }
  }
  let x_1614 = tint_return_value_3;
  return x_1614;
}

const x_1640 = vec3f(0.0f, -0.28000000119209289551f, 0.05000000074505805969f);

const x_1658 = vec3f(-0.28000000119209289551f, -0.37999999523162841797f, -0.05000000074505805969f);

const x_1678 = vec3f(0.28000000119209289551f, -0.40000000596046447754f, 0.07999999821186065674f);

fn tint_symbol_129(tint_symbol_119_1 : vec3f, tint_symbol_31_1 : vec3f, tint_symbol_130 : f32) -> tint_symbol_101 {
  var tint_return_flag_4 = false;
  var tint_return_value_4 = tint_symbol_101(0.0f, 0i, vec3f(), vec3f());
  var tint_symbol_131 = 0.0f;
  var tint_symbol_132 = 0i;
  var tint_symbol_27_1 = vec3f();
  var x_1651 : bool;
  var x_1652 : bool;
  var x_1669 : bool;
  var x_1670 : bool;
  var x_1688 : bool;
  var x_1689 : bool;
  tint_symbol_131 = -1.0f;
  tint_symbol_132 = -1i;
  let x_1629 = tint_symbol_114(tint_symbol_119_1, tint_symbol_31_1);
  if ((x_1629.x > tint_symbol_130)) {
    tint_symbol_131 = x_1629.x;
    let x_1635 = tint_ftoi(x_1629.y);
    tint_symbol_132 = x_1635;
  }
  var x_1650 : bool;
  let x_1637 = tint_symbol_118(tint_symbol_119_1, tint_symbol_31_1, x_1640, 0.20000000298023223877f);
  let x_1642 = (x_1637 > tint_symbol_130);
  x_1652 = x_1642;
  if (x_1642) {
    let x_1646 = (tint_symbol_131 < 0.0f);
    x_1651 = x_1646;
    if (x_1646) {
    } else {
      x_1650 = (x_1637 < tint_symbol_131);
      x_1651 = x_1650;
    }
    x_1652 = x_1651;
  }
  if (x_1652) {
    tint_symbol_131 = x_1637;
    tint_symbol_132 = 6i;
  }
  var x_1668 : bool;
  let x_1655 = tint_symbol_118(tint_symbol_119_1, tint_symbol_31_1, x_1658, 0.10000000149011611938f);
  let x_1660 = (x_1655 > tint_symbol_130);
  x_1670 = x_1660;
  if (x_1660) {
    let x_1664 = (tint_symbol_131 < 0.0f);
    x_1669 = x_1664;
    if (x_1664) {
    } else {
      x_1668 = (x_1655 < tint_symbol_131);
      x_1669 = x_1668;
    }
    x_1670 = x_1669;
  }
  if (x_1670) {
    tint_symbol_131 = x_1655;
    tint_symbol_132 = 7i;
  }
  var x_1687 : bool;
  let x_1674 = tint_symbol_118(tint_symbol_119_1, tint_symbol_31_1, x_1678, 0.07999999821186065674f);
  let x_1679 = (x_1674 > tint_symbol_130);
  x_1689 = x_1679;
  if (x_1679) {
    let x_1683 = (tint_symbol_131 < 0.0f);
    x_1688 = x_1683;
    if (x_1683) {
    } else {
      x_1687 = (x_1674 < tint_symbol_131);
      x_1688 = x_1687;
    }
    x_1689 = x_1688;
  }
  if (x_1689) {
    tint_symbol_131 = x_1674;
    tint_symbol_132 = 8i;
  }
  if ((tint_symbol_131 < 0.0f)) {
    tint_return_flag_4 = true;
    tint_return_value_4 = tint_symbol_101(-1.0f, -1i, vec3f(), vec3f());
  }
  if (!(tint_return_flag_4)) {
    let x_1704 = (tint_symbol_119_1 + (tint_symbol_31_1 * tint_symbol_131));
    let x_1707 = tint_symbol_132;
    switch(x_1707) {
      case 8i: {
        tint_symbol_27_1 = normalize((x_1704 - x_1678));
      }
      case 7i: {
        tint_symbol_27_1 = normalize((x_1704 - x_1658));
      }
      case 6i: {
        tint_symbol_27_1 = normalize((x_1704 - x_1640));
      }
      default: {
        let x_1719 = tint_symbol_132;
        let x_1718 = tint_symbol_128(x_1719);
        tint_symbol_27_1 = x_1718;
      }
    }
    if ((dot(tint_symbol_27_1, tint_symbol_31_1) > 0.0f)) {
      tint_symbol_27_1 = -(tint_symbol_27_1);
    }
    tint_return_flag_4 = true;
    tint_return_value_4 = tint_symbol_101(tint_symbol_131, tint_symbol_132, x_1704, tint_symbol_27_1);
  }
  let x_1731 = tint_return_value_4;
  return x_1731;
}

fn tint_symbol_137(tint_symbol_103 : i32) -> i32 {
  var tint_return_flag_5 = false;
  var tint_return_value_5 = 0i;
  if ((tint_symbol_103 == 6i)) {
    tint_return_flag_5 = true;
    tint_return_value_5 = 2i;
  }
  if (!(tint_return_flag_5)) {
    if ((tint_symbol_103 == 7i)) {
      tint_return_flag_5 = true;
      tint_return_value_5 = 1i;
    }
    if (!(tint_return_flag_5)) {
      if ((tint_symbol_103 == 5i)) {
        tint_return_flag_5 = true;
        tint_return_value_5 = 3i;
      }
      if (!(tint_return_flag_5)) {
        tint_return_flag_5 = true;
        tint_return_value_5 = 0i;
      }
    }
  }
  let x_1762 = tint_return_value_5;
  return x_1762;
}

const x_1782 = vec4f(0.80000001192092895508f, 0.80000001192092895508f, 0.85000002384185791016f, 1.0f);

fn tint_symbol_138(tint_symbol_103_1 : i32) -> vec4f {
  var tint_return_flag_6 = false;
  var tint_return_value_6 = vec4f();
  switch(tint_symbol_103_1) {
    case 8i: {
      tint_return_flag_6 = true;
      tint_return_value_6 = vec4f(0.92000001668930053711f, 0.51999998092651367188f, 0.10000000149011611938f, 1.0f);
    }
    case 5i: {
      tint_return_flag_6 = true;
      tint_return_value_6 = vec4f(0.75f, 0.75f, 0.75f, 1.0f);
    }
    case 4i: {
      tint_return_flag_6 = true;
      tint_return_value_6 = vec4f(0.87999999523162841797f, 0.87999999523162841797f, 0.87999999523162841797f, 1.0f);
    }
    case 3i: {
      tint_return_flag_6 = true;
      tint_return_value_6 = vec4f(0.64999997615814208984f, 0.15000000596046447754f, 0.15000000596046447754f, 1.0f);
    }
    case 2i: {
      tint_return_flag_6 = true;
      tint_return_value_6 = vec4f(0.18000000715255737305f, 0.62000000476837158203f, 0.21999999880790710449f, 1.0f);
    }
    case 1i: {
      tint_return_flag_6 = true;
      tint_return_value_6 = x_1782;
    }
    case 0i: {
      tint_return_flag_6 = true;
      tint_return_value_6 = x_1782;
    }
    default: {
      tint_return_flag_6 = true;
      tint_return_value_6 = vec4f(0.69999998807907104492f, 0.69999998807907104492f, 0.69999998807907104492f, 1.0f);
    }
  }
  let x_1799 = tint_return_value_6;
  return x_1799;
}

fn tint_symbol_139(tint_symbol_140 : u32) -> u32 {
  let x_1807 = ((tint_symbol_140 * 747796405u) + 2891336453u);
  let x_1816 = (((x_1807 >> (((x_1807 >> 28u) + 4u) & 31u)) ^ x_1807) * 277803737u);
  return ((x_1816 >> 22u) ^ x_1816);
}

fn tint_symbol_143(tint_symbol_144 : vec2i, tint_symbol_145 : u32) -> f32 {
  let x_1838 = tint_symbol_139((((bitcast<u32>(tint_symbol_144.x) * 1973u) + (bitcast<u32>(tint_symbol_144.y) * 9277u)) + (tint_symbol_145 * 26699u)));
  return (f32(x_1838) / 4294967296.0f);
}

fn tint_symbol_147(tint_symbol_23_4 : vec3f, tint_symbol_148 : bool) -> f32 {
  var tint_symbol_29_6 = 0.0f;
  tint_symbol_29_6 = (length((tint_symbol_23_4 - x_1658)) - 0.10000000149011611938f);
  tint_symbol_29_6 = min(tint_symbol_29_6, (length((tint_symbol_23_4 - x_1678)) - 0.07999999821186065674f));
  if (tint_symbol_148) {
    tint_symbol_29_6 = min(tint_symbol_29_6, (length((tint_symbol_23_4 - x_1640)) - 0.20000000298023223877f));
  }
  let x_1863 = tint_symbol_29_6;
  return x_1863;
}

fn tint_symbol_149(tint_symbol_150 : vec3f, tint_symbol_31_2 : vec3f, tint_symbol_151 : f32) -> f32 {
  var tint_return_flag_7 = false;
  var tint_return_value_7 = 0.0f;
  var x_1879 : bool;
  var x_1880 : bool;
  let x_1874 = (tint_symbol_150 + (tint_symbol_31_2 * 0.00400000018998980522f));
  let x_1875 = tint_symbol_118(x_1874, tint_symbol_31_2, x_1658, 0.10000000149011611938f);
  let x_1876 = (x_1875 > 0.0f);
  x_1880 = x_1876;
  if (x_1876) {
    x_1879 = (x_1875 < tint_symbol_151);
    x_1880 = x_1879;
  }
  if (x_1880) {
    tint_return_flag_7 = true;
    tint_return_value_7 = 0.10000000149011611938f;
  }
  var x_1891 : bool;
  var x_1892 : bool;
  if (!(tint_return_flag_7)) {
    let x_1887 = tint_symbol_118(x_1874, tint_symbol_31_2, x_1678, 0.07999999821186065674f);
    let x_1888 = (x_1887 > 0.0f);
    x_1892 = x_1888;
    if (x_1888) {
      x_1891 = (x_1887 < tint_symbol_151);
      x_1892 = x_1891;
    }
    if (x_1892) {
      tint_return_flag_7 = true;
      tint_return_value_7 = 0.10000000149011611938f;
    }
    var x_1905 : bool;
    var x_1906 : bool;
    if (!(tint_return_flag_7)) {
      let x_1899 = tint_symbol_114(x_1874, tint_symbol_31_2);
      let x_1901 = (x_1899.x > 0.0f);
      x_1906 = x_1901;
      if (x_1901) {
        x_1905 = (x_1899.x < tint_symbol_151);
        x_1906 = x_1905;
      }
      if (x_1906) {
        tint_return_flag_7 = true;
        tint_return_value_7 = 0.10000000149011611938f;
      }
      var x_1917 : bool;
      var x_1918 : bool;
      if (!(tint_return_flag_7)) {
        let x_1913 = tint_symbol_118(x_1874, tint_symbol_31_2, x_1640, 0.20000000298023223877f);
        let x_1914 = (x_1913 > 0.0f);
        x_1918 = x_1914;
        if (x_1914) {
          x_1917 = (x_1913 < tint_symbol_151);
          x_1918 = x_1917;
        }
        if (x_1918) {
          tint_return_flag_7 = true;
          tint_return_value_7 = select(0.10000000149011611938f, 0.5f, (tint_symbol_84.inner.tint_symbol_76 != 0u));
        }
        if (!(tint_return_flag_7)) {
          tint_return_flag_7 = true;
          tint_return_value_7 = 1.0f;
        }
      }
    }
  }
  let x_1932 = tint_return_value_7;
  return x_1932;
}

fn tint_symbol_153(tint_symbol_154 : vec3f, tint_symbol_155 : vec3f, tint_symbol_156 : vec3f, tint_symbol_157 : i32) -> f32 {
  var tint_return_flag_8 = false;
  var tint_return_value_8 = 0.0f;
  var x_1964 = vec3f();
  if ((tint_symbol_157 == 1i)) {
    tint_return_flag_8 = true;
    let x_1945 = tint_symbol_149(tint_symbol_154, -(tint_symbol_156), 1000000.0f);
    tint_return_value_8 = x_1945;
  }
  if (!(tint_return_flag_8)) {
    let x_1952 = (tint_symbol_155 - tint_symbol_154);
    let x_1953 = length(x_1952);
    if ((x_1953 < 0.00100000004749745131f)) {
      tint_return_flag_8 = true;
      tint_return_value_8 = 1.0f;
    }
    if (!(tint_return_flag_8)) {
      tint_return_flag_8 = true;
      let x_1962 = tint_symbol_149(tint_symbol_154, (x_1952 / vec3f(x_1953)), x_1953);
      tint_return_value_8 = x_1962;
    }
  }
  let x_1966 = tint_return_value_8;
  return x_1966;
}

fn tint_symbol_160(tint_symbol_154_1 : vec3f, tint_symbol_155_1 : vec3f, tint_symbol_156_1 : vec3f, tint_symbol_157_1 : i32, tint_symbol_144_1 : vec2i) -> f32 {
  var tint_return_flag_9 = false;
  var tint_return_value_9 = 0.0f;
  var tint_symbol_162 = 0.0f;
  var tint_symbol_116_1 = 0i;
  var x_2032 = vec3f();
  if ((tint_symbol_157_1 != 0i)) {
    tint_return_flag_9 = true;
    let x_1980 = tint_symbol_153(tint_symbol_154_1, tint_symbol_155_1, tint_symbol_156_1, tint_symbol_157_1);
    tint_return_value_9 = x_1980;
  }
  if (!(tint_return_flag_9)) {
    tint_symbol_162 = 0.0f;
    tint_symbol_116_1 = 0i;
    loop {
      if (!((tint_symbol_116_1 < 8i))) {
        break;
      }
      let x_1998 = tint_symbol_116_1;
      let x_1996 = tint_symbol_143(tint_symbol_144_1, bitcast<u32>((x_1998 * 3i)));
      let x_2006 = tint_symbol_116_1;
      let x_2004 = tint_symbol_143(tint_symbol_144_1, bitcast<u32>(((x_2006 * 3i) + 1i)));
      let x_2014 = tint_symbol_116_1;
      let x_2012 = tint_symbol_143(tint_symbol_144_1, bitcast<u32>(((x_2014 * 3i) + 2i)));
      let x_2022 = ((tint_symbol_155_1 + vec3f((((x_1996 - 0.5f) * 2.0f) * 0.10000000149011611938f), (((x_2004 - 0.5f) * 2.0f) * 0.10000000149011611938f), (((x_2012 - 0.5f) * 2.0f) * 0.10000000149011611938f))) - tint_symbol_154_1);
      let x_2023 = length(x_2022);
      if ((x_2023 < 0.00100000004749745131f)) {
        tint_symbol_162 = (tint_symbol_162 + 1.0f);
        continue;
      }
      let x_2029 = tint_symbol_162;
      let x_2030 = tint_symbol_149(tint_symbol_154_1, (x_2022 / vec3f(x_2023)), x_2023);
      tint_symbol_162 = (x_2029 + x_2030);

      continuing {
        tint_symbol_116_1 = (tint_symbol_116_1 + 1i);
      }
    }
    tint_return_flag_9 = true;
    tint_return_value_9 = (tint_symbol_162 / 8.0f);
  }
  let x_2040 = tint_return_value_9;
  return x_2040;
}

fn tint_symbol_168(tint_symbol_154_2 : vec3f, tint_symbol_155_2 : vec3f, tint_symbol_156_2 : vec3f, tint_symbol_157_2 : i32, tint_symbol_144_2 : vec2i) -> f32 {
  var tint_return_flag_10 = false;
  var tint_return_value_10 = 0.0f;
  var tint_symbol_170 = vec3f();
  var tint_symbol_162_1 = 0.0f;
  var tint_symbol_116_2 = 0i;
  if ((tint_symbol_157_2 != 1i)) {
    tint_return_flag_10 = true;
    let x_2053 = tint_symbol_153(tint_symbol_154_2, tint_symbol_155_2, tint_symbol_156_2, tint_symbol_157_2);
    tint_return_value_10 = x_2053;
  }
  if (!(tint_return_flag_10)) {
    if ((abs(tint_symbol_156_2.x) < 0.89999997615814208984f)) {
      tint_symbol_170 = normalize(cross(tint_symbol_156_2, x_1610));
    } else {
      tint_symbol_170 = normalize(cross(tint_symbol_156_2, x_1613));
    }
    let x_2070 = cross(tint_symbol_156_2, tint_symbol_170);
    tint_symbol_162_1 = 0.0f;
    tint_symbol_116_2 = 0i;
    loop {
      if (!((tint_symbol_116_2 < 8i))) {
        break;
      }
      let x_2085 = tint_symbol_116_2;
      let x_2083 = tint_symbol_143(tint_symbol_144_2, bitcast<u32>(((x_2085 * 2i) + 200i)));
      let x_2094 = tint_symbol_116_2;
      let x_2092 = tint_symbol_143(tint_symbol_144_2, bitcast<u32>(((x_2094 * 2i) + 201i)));
      let x_2103 = tint_symbol_170;
      let x_2108 = tint_symbol_162_1;
      let x_2109 = tint_symbol_149(tint_symbol_154_2, normalize(((-(tint_symbol_156_2) + (x_2103 * (((x_2083 - 0.5f) * 2.0f) * 0.05000000074505805969f))) + (x_2070 * (((x_2092 - 0.5f) * 2.0f) * 0.05000000074505805969f)))), 1000000.0f);
      tint_symbol_162_1 = (x_2108 + x_2109);

      continuing {
        tint_symbol_116_2 = (tint_symbol_116_2 + 1i);
      }
    }
    tint_return_flag_10 = true;
    tint_return_value_10 = (tint_symbol_162_1 / 8.0f);
  }
  let x_2115 = tint_return_value_10;
  return x_2115;
}

fn tint_symbol_175(tint_symbol_154_3 : vec3f, tint_symbol_155_3 : vec3f, tint_symbol_156_3 : vec3f, tint_symbol_157_3 : i32) -> f32 {
  var tint_return_flag_11 = false;
  var tint_return_value_11 = 0.0f;
  var x_2142 = vec3f();
  var tint_symbol_176 = 0.0f;
  if ((tint_symbol_157_3 != 2i)) {
    tint_return_flag_11 = true;
    let x_2127 = tint_symbol_153(tint_symbol_154_3, tint_symbol_155_3, tint_symbol_156_3, tint_symbol_157_3);
    tint_return_value_11 = x_2127;
  }
  if (!(tint_return_flag_11)) {
    let x_2132 = (tint_symbol_155_3 - tint_symbol_154_3);
    let x_2133 = length(x_2132);
    if ((x_2133 < 0.00100000004749745131f)) {
      tint_return_flag_11 = true;
      tint_return_value_11 = 1.0f;
    }
    var x_2153 : bool;
    var x_2154 : bool;
    var x_2160 : bool;
    var x_2161 : bool;
    var x_2170 : bool;
    var x_2171 : bool;
    var x_2177 : bool;
    var x_2178 : bool;
    var x_2187 : bool;
    var x_2188 : bool;
    if (!(tint_return_flag_11)) {
      let x_2141 = (x_2132 / vec3f(x_2133));
      let x_2145 = (tint_symbol_154_3 + (x_2141 * 0.00400000018998980522f));
      tint_symbol_176 = -1.0f;
      let x_2147 = tint_symbol_118(x_2145, x_2141, x_1640, 0.20000000298023223877f);
      let x_2148 = tint_symbol_118(x_2145, x_2141, x_1658, 0.10000000149011611938f);
      let x_2149 = tint_symbol_118(x_2145, x_2141, x_1678, 0.07999999821186065674f);
      let x_2150 = (x_2147 > 0.0f);
      x_2154 = x_2150;
      if (x_2150) {
        x_2153 = (x_2147 < x_2133);
        x_2154 = x_2153;
      }
      if (x_2154) {
        tint_symbol_176 = x_2147;
      }
      let x_2157 = (x_2148 > 0.0f);
      x_2161 = x_2157;
      if (x_2157) {
        x_2160 = (x_2148 < x_2133);
        x_2161 = x_2160;
      }
      var x_2169 : bool;
      x_2171 = x_2161;
      if (x_2161) {
        let x_2165 = (tint_symbol_176 < 0.0f);
        x_2170 = x_2165;
        if (x_2165) {
        } else {
          x_2169 = (x_2148 < tint_symbol_176);
          x_2170 = x_2169;
        }
        x_2171 = x_2170;
      }
      if (x_2171) {
        tint_symbol_176 = x_2148;
      }
      let x_2174 = (x_2149 > 0.0f);
      x_2178 = x_2174;
      if (x_2174) {
        x_2177 = (x_2149 < x_2133);
        x_2178 = x_2177;
      }
      var x_2186 : bool;
      x_2188 = x_2178;
      if (x_2178) {
        let x_2182 = (tint_symbol_176 < 0.0f);
        x_2187 = x_2182;
        if (x_2182) {
        } else {
          x_2186 = (x_2149 < tint_symbol_176);
          x_2187 = x_2186;
        }
        x_2188 = x_2187;
      }
      if (x_2188) {
        tint_symbol_176 = x_2149;
      }
      if ((tint_symbol_176 > 0.0f)) {
        tint_return_flag_11 = true;
        tint_return_value_11 = max(pow(min((tint_symbol_176 / x_2133), 1.0f), 0.60000002384185791016f), 0.10000000149011611938f);
      }
      if (!(tint_return_flag_11)) {
        tint_return_flag_11 = true;
        tint_return_value_11 = 1.0f;
      }
    }
  }
  let x_2205 = tint_return_value_11;
  return x_2205;
}

fn tint_symbol_177(tint_symbol_154_4 : vec3f, tint_symbol_155_4 : vec3f, tint_symbol_156_4 : vec3f, tint_symbol_157_4 : i32) -> f32 {
  var tint_return_flag_12 = false;
  var tint_return_value_12 = 0.0f;
  var tint_symbol_158 = vec3f();
  var tint_symbol_178 = 0.0f;
  var x_2233 = vec3f();
  var tint_symbol_180 = 0.0f;
  var tint_symbol_102_1 = 0.0f;
  var tint_symbol_116_3 = 0i;
  if ((tint_symbol_157_4 == 1i)) {
    tint_symbol_158 = -(tint_symbol_156_4);
    tint_symbol_178 = 1000000.0f;
  } else {
    let x_2221 = (tint_symbol_155_4 - tint_symbol_154_4);
    tint_symbol_178 = length(x_2221);
    if ((tint_symbol_178 < 0.00100000004749745131f)) {
      tint_return_flag_12 = true;
      tint_return_value_12 = 1.0f;
    }
    if (!(tint_return_flag_12)) {
      tint_symbol_158 = (x_2221 / vec3f(tint_symbol_178));
    }
  }
  if (!(tint_return_flag_12)) {
    let x_2242 = (tint_symbol_84.inner.tint_symbol_76 == 0u);
    tint_symbol_180 = 1.0f;
    tint_symbol_102_1 = 0.01999999955296516418f;
    tint_symbol_116_3 = 0i;
    loop {
      if (!((tint_symbol_116_3 < 64i))) {
        break;
      }
      let x_2258 = tint_symbol_102_1;
      let x_2259 = tint_symbol_158;
      let x_2257 = tint_symbol_147((tint_symbol_154_4 + (x_2259 * x_2258)), x_2242);
      if ((x_2257 < 0.00019999999494757503f)) {
        tint_return_flag_12 = true;
        tint_return_value_12 = 0.10000000149011611938f;
        break;
      }
      tint_symbol_180 = min(tint_symbol_180, ((16.0f * x_2257) / tint_symbol_102_1));
      tint_symbol_102_1 = (tint_symbol_102_1 + max(x_2257, 0.00499999988824129105f));
      if ((tint_symbol_102_1 >= tint_symbol_178)) {
        break;
      }

      continuing {
        tint_symbol_116_3 = (tint_symbol_116_3 + 1i);
      }
    }
    if (!(tint_return_flag_12)) {
      tint_return_flag_12 = true;
      tint_return_value_12 = clamp(tint_symbol_180, 0.10000000149011611938f, 1.0f);
    }
  }
  let x_2288 = tint_return_value_12;
  return x_2288;
}

fn tint_symbol_181(tint_symbol_154_5 : vec3f, tint_symbol_155_5 : vec3f, tint_symbol_156_5 : vec3f, tint_symbol_157_5 : i32, tint_symbol_144_3 : vec2i) -> f32 {
  var tint_return_flag_13 = false;
  var tint_return_value_13 = 0.0f;
  if ((tint_symbol_84.inner.tint_symbol_72 == 0u)) {
    tint_return_flag_13 = true;
    tint_return_value_13 = 1.0f;
  }
  if (!(tint_return_flag_13)) {
    let x_2310 = tint_symbol_84.inner.tint_symbol_73;
    switch(bitcast<i32>(x_2310)) {
      case 4i: {
        tint_return_flag_13 = true;
        let x_2319 = tint_symbol_177(tint_symbol_154_5, tint_symbol_155_5, tint_symbol_156_5, tint_symbol_157_5);
        tint_return_value_13 = x_2319;
      }
      case 3i: {
        tint_return_flag_13 = true;
        let x_2318 = tint_symbol_175(tint_symbol_154_5, tint_symbol_155_5, tint_symbol_156_5, tint_symbol_157_5);
        tint_return_value_13 = x_2318;
      }
      case 2i: {
        tint_return_flag_13 = true;
        let x_2317 = tint_symbol_168(tint_symbol_154_5, tint_symbol_155_5, tint_symbol_156_5, tint_symbol_157_5, tint_symbol_144_3);
        tint_return_value_13 = x_2317;
      }
      case 1i: {
        tint_return_flag_13 = true;
        let x_2316 = tint_symbol_160(tint_symbol_154_5, tint_symbol_155_5, tint_symbol_156_5, tint_symbol_157_5, tint_symbol_144_3);
        tint_return_value_13 = x_2316;
      }
      default: {
        tint_return_flag_13 = true;
        let x_2320 = tint_symbol_153(tint_symbol_154_5, tint_symbol_155_5, tint_symbol_156_5, tint_symbol_157_5);
        tint_return_value_13 = x_2320;
      }
    }
  }
  let x_2321 = tint_return_value_13;
  return x_2321;
}

fn tint_symbol_184(tint_symbol_185 : vec3f, tint_symbol_186 : vec3f, tint_symbol_187 : vec3f) -> tint_symbol_182 {
  var tint_symbol_105_4 = tint_symbol_182(vec4f(), vec3f());
  var x_2381 = vec4f();
  var x_2404 = vec4f();
  var x_2332 : i32;
  let x_2335 = tint_symbol_83.inner.tint_symbol_70.z;
  x_2332 = tint_ftoi(x_2335);
  if ((x_2332 == 1i)) {
    tint_symbol_105_4.tint_symbol_66 = tint_symbol_83.inner.tint_symbol_66;
    tint_symbol_105_4.tint_symbol_183 = normalize(tint_symbol_186);
  } else {
    if ((x_2332 == 2i)) {
      let x_2349 = normalize((tint_symbol_187 - tint_symbol_185));
      let x_2351 = dot(normalize(tint_symbol_186), x_2349);
      let x_2356 = tint_symbol_83.inner.tint_symbol_70.y;
      if ((x_2351 > cos(tint_symbol_83.inner.tint_symbol_70[0i]))) {
        let x_2363 = length((tint_symbol_187 - tint_symbol_185));
        tint_symbol_105_4.tint_symbol_66 = ((tint_symbol_83.inner.tint_symbol_66 * pow(x_2351, x_2356)) / vec4f(((tint_symbol_83.inner.tint_symbol_69[0i] + (x_2363 * tint_symbol_83.inner.tint_symbol_69.y)) + ((x_2363 * x_2363) * tint_symbol_83.inner.tint_symbol_69.z))));
      } else {
        tint_symbol_105_4.tint_symbol_66 = vec4f();
      }
      tint_symbol_105_4.tint_symbol_183 = x_2349;
    } else {
      let x_2387 = length((tint_symbol_187 - tint_symbol_185));
      tint_symbol_105_4.tint_symbol_66 = (tint_symbol_83.inner.tint_symbol_66 / vec4f(((tint_symbol_83.inner.tint_symbol_69[0i] + (x_2387 * tint_symbol_83.inner.tint_symbol_69.y)) + ((x_2387 * x_2387) * tint_symbol_83.inner.tint_symbol_69.z))));
      tint_symbol_105_4.tint_symbol_183 = normalize((tint_symbol_187 - tint_symbol_185));
    }
  }
  let x_2407 = tint_symbol_105_4;
  return x_2407;
}

fn tint_symbol_194(tint_symbol_140_1 : f32) -> f32 {
  var tint_return_flag_14 = false;
  var tint_return_value_14 = 0.0f;
  if ((tint_symbol_140_1 < 0.10000000149011611938f)) {
    tint_return_flag_14 = true;
    tint_return_value_14 = 0.0f;
  } else {
    if ((tint_symbol_140_1 < 0.34999999403953552246f)) {
      tint_return_flag_14 = true;
      tint_return_value_14 = 0.20000000298023223877f;
    } else {
      if ((tint_symbol_140_1 < 0.64999997615814208984f)) {
        tint_return_flag_14 = true;
        tint_return_value_14 = 0.5f;
      } else {
        if ((tint_symbol_140_1 < 0.89999997615814208984f)) {
          tint_return_flag_14 = true;
          tint_return_value_14 = 0.80000001192092895508f;
        } else {
          tint_return_flag_14 = true;
          tint_return_value_14 = 1.0f;
        }
      }
    }
  }
  let x_2431 = tint_return_value_14;
  return x_2431;
}

const x_2465 = vec4f(0.40000000596046447754f, 0.40000000596046447754f, 0.40000000596046447754f, 0.0f);

const x_2451 = vec4f(0.07999999821186065674f, 0.07999999821186065674f, 0.07999999821186065674f, 0.0f);

fn tint_symbol_195(tint_symbol_196 : vec4f, tint_symbol_197 : vec4f, tint_symbol_198 : vec3f, tint_symbol_199 : tint_symbol_182, tint_symbol_200 : vec3f, tint_symbol_201 : vec3f) -> vec4f {
  var tint_return_flag_15 = false;
  var tint_return_value_15 = vec4f();
  var x_2443 : vec3f;
  var x_2444 : vec4f;
  var x_2445 : i32;
  var x_2448 : f32;
  x_2443 = tint_symbol_199.tint_symbol_183;
  x_2444 = tint_symbol_199.tint_symbol_66;
  let x_2447 = tint_symbol_83.inner.tint_symbol_70.w;
  x_2445 = tint_ftoi(x_2447);
  x_2448 = max(dot(tint_symbol_198, -(x_2443)), 0.0f);
  if ((x_2445 == 1i)) {
    tint_return_flag_15 = true;
    tint_return_value_15 = (((tint_symbol_196 + ((tint_symbol_197 * x_2444) * x_2448)) + ((x_2465 * x_2444) * pow(max(dot(normalize((tint_symbol_200 - tint_symbol_201)), -(reflect(x_2443, tint_symbol_198))), 0.0f), 64.0f))) + (x_2451 * x_2444));
  } else {
    if ((x_2445 == 2i)) {
      let x_2486 = tint_symbol_194(x_2448);
      let x_2488 = tint_symbol_194(pow(max(dot(normalize((tint_symbol_200 - tint_symbol_201)), -(reflect(x_2443, tint_symbol_198))), 0.0f), 64.0f));
      tint_return_flag_15 = true;
      tint_return_value_15 = (((tint_symbol_196 + ((tint_symbol_197 * x_2444) * x_2486)) + ((x_2465 * x_2444) * x_2488)) + (x_2451 * x_2444));
    } else {
      tint_return_flag_15 = true;
      tint_return_value_15 = ((tint_symbol_196 + ((tint_symbol_197 * x_2444) * x_2448)) + (x_2451 * x_2444));
    }
  }
  let x_2500 = tint_return_value_15;
  return x_2500;
}

fn tint_symbol_210(tint_symbol_46 : tint_symbol_101, tint_symbol_144_4 : vec2i) -> vec4f {
  var tint_symbol_197_1 = vec4f();
  var x_2522 = vec4<bool>();
  var x_2537 = vec4<bool>();
  var tint_symbol_213 = tint_symbol_182(vec4f(), vec3f());
  var x_2506 : i32;
  x_2506 = tint_symbol_137(tint_symbol_46.tint_symbol_103);
  if ((x_2506 == 2i)) {
    tint_symbol_197_1 = select(vec4f(0.20000000298023223877f, 0.55000001192092895508f, 0.80000001192092895508f, 1.0f), vec4f(0.87999999523162841797f, 0.94999998807907104492f, 1.0f, 1.0f), vec4<bool>((tint_symbol_84.inner.tint_symbol_75 != 0u)));
  } else {
    if ((x_2506 == 1i)) {
      tint_symbol_197_1 = select(vec4f(0.69999998807907104492f, 0.69999998807907104492f, 0.75f, 1.0f), vec4f(0.02999999932944774628f, 0.02999999932944774628f, 0.02999999932944774628f, 1.0f), vec4<bool>((tint_symbol_84.inner.tint_symbol_74 != 0u)));
    } else {
      let x_2539 = tint_symbol_138(tint_symbol_46.tint_symbol_103);
      tint_symbol_197_1 = x_2539;
    }
  }
  let x_2543 = tint_symbol_80.inner.tint_symbol_54;
  let x_2541 = tint_symbol_21(x_2543);
  let x_2546 = tint_symbol_83.inner.tint_symbol_67;
  let x_2544 = tint_symbol_42(x_2546.xyz, x_2541);
  let x_2550 = tint_symbol_80.inner.tint_symbol_54;
  let x_2548 = tint_symbol_21(x_2550);
  let x_2553 = tint_symbol_83.inner.tint_symbol_68;
  let x_2551 = tint_symbol_43(x_2553.xyz, x_2548);
  let x_2555 = tint_symbol_109(tint_symbol_46.tint_symbol_23);
  let x_2557 = tint_symbol_184(x_2544, x_2551, x_2555);
  tint_symbol_213 = x_2557;
  if ((tint_symbol_46.tint_symbol_103 != 4i)) {
    let x_2566 = tint_symbol_81.inner.tint_symbol_54;
    let x_2564 = tint_symbol_21(x_2566);
    let x_2567 = tint_symbol_42(x_2544, x_2564);
    let x_2569 = tint_symbol_81.inner.tint_symbol_63;
    let x_2574 = tint_symbol_81.inner.tint_symbol_54;
    let x_2572 = tint_symbol_21(x_2574);
    let x_2575 = tint_symbol_43(x_2551, x_2572);
    let x_2578 = tint_symbol_81.inner.tint_symbol_63;
    let x_2585 = tint_symbol_83.inner.tint_symbol_70.z;
    let x_2583 = tint_ftoi(x_2585);
    let x_2581 = tint_symbol_181(tint_symbol_46.tint_symbol_23, (x_2567 / x_2569.xyz), normalize((x_2575 / x_2578.xyz)), x_2583, tint_symbol_144_4);
    tint_symbol_213.tint_symbol_66 = (tint_symbol_213.tint_symbol_66 * x_2581);
  }
  let x_2590 = tint_symbol_108(tint_symbol_46.tint_symbol_27);
  let x_2594 = tint_symbol_80.inner.tint_symbol_54;
  let x_2592 = tint_symbol_42(vec3f(), x_2594);
  let x_2596 = tint_symbol_197_1;
  let x_2597 = tint_symbol_213;
  let x_2595 = tint_symbol_195(vec4f(), x_2596, x_2590, x_2597, x_2592, x_2555);
  return x_2595;
}

const x_2608 = vec4f(1.0f);

fn tint_symbol_220(tint_symbol_221 : vec3f, tint_symbol_222 : vec3f, tint_symbol_144_5 : vec2i) -> vec4f {
  var tint_symbol_162_2 = vec4f();
  var tint_symbol_224 = vec4f();
  var tint_symbol_225 = vec3f();
  var tint_symbol_226 = vec3f();
  var tint_symbol_228 = 0i;
  tint_symbol_162_2 = vec4f();
  tint_symbol_224 = x_2608;
  tint_symbol_225 = tint_symbol_221;
  tint_symbol_226 = tint_symbol_222;
  let x_2612 = min(bitcast<i32>(tint_symbol_84.inner.tint_symbol_77), 8i);
  tint_symbol_228 = 0i;
  loop {
    var x_2658 : bool;
    var x_2659 : bool;
    if (!((tint_symbol_228 <= 8i))) {
      break;
    }
    let x_2627 = tint_symbol_225;
    let x_2628 = tint_symbol_226;
    let x_2626 = tint_symbol_129(x_2627, x_2628, 0.00300000002607703209f);
    if ((x_2626.tint_symbol_103 < 0i)) {
      tint_symbol_162_2 = (tint_symbol_162_2 + (tint_symbol_224 * vec4f(0.0f, 0.21960784494876861572f, 0.39607843756675720215f, 1.0f)));
      break;
    }
    let x_2638 = tint_symbol_162_2;
    let x_2639 = tint_symbol_224;
    let x_2640 = tint_symbol_210(x_2626, tint_symbol_144_5);
    tint_symbol_162_2 = (x_2638 + (x_2639 * x_2640));
    if ((tint_symbol_228 >= x_2612)) {
      break;
    }
    let x_2647 = tint_symbol_137(x_2626.tint_symbol_103);
    let x_2649 = bitcast<i32>(tint_symbol_84.inner.tint_symbol_74);
    let x_2652 = bitcast<i32>(tint_symbol_84.inner.tint_symbol_75);
    let x_2655 = (x_2647 == 1i);
    x_2659 = x_2655;
    if (x_2655) {
      x_2658 = (x_2649 > 0i);
      x_2659 = x_2658;
    }
    var x_2678 : bool;
    var x_2679 : bool;
    if (x_2659) {
      tint_symbol_226 = reflect(tint_symbol_226, x_2626.tint_symbol_27);
      tint_symbol_225 = (x_2626.tint_symbol_23 + (x_2626.tint_symbol_27 * 0.00400000018998980522f));
      tint_symbol_224 = (tint_symbol_224 * 0.92000001668930053711f);
      if ((x_2649 == 1i)) {
        break;
      }
    } else {
      let x_2675 = (x_2647 == 2i);
      x_2679 = x_2675;
      if (x_2675) {
        x_2678 = (x_2652 > 0i);
        x_2679 = x_2678;
      }
      var x_2721 : bool;
      var x_2722 : bool;
      if (x_2679) {
        let x_2692 = refract(tint_symbol_226, x_2626.tint_symbol_27, select(1.5f, 0.6666666865348815918f, (dot(normalize((x_2626.tint_symbol_23 - x_1640)), tint_symbol_226) < 0.0f)));
        if ((dot(x_2692, x_2692) < 0.5f)) {
          tint_symbol_226 = reflect(tint_symbol_226, x_2626.tint_symbol_27);
          tint_symbol_225 = (x_2626.tint_symbol_23 + (x_2626.tint_symbol_27 * 0.00400000018998980522f));
        } else {
          tint_symbol_226 = normalize(x_2692);
          tint_symbol_225 = (x_2626.tint_symbol_23 - (x_2626.tint_symbol_27 * 0.00400000018998980522f));
        }
        tint_symbol_224 = (tint_symbol_224 * 0.95999997854232788086f);
        if ((x_2652 == 1i)) {
          break;
        }
      } else {
        let x_2718 = (x_2647 == 3i);
        x_2722 = x_2718;
        if (x_2718) {
          x_2721 = (x_2649 > 0i);
          x_2722 = x_2721;
        }
        if (x_2722) {
          tint_symbol_226 = reflect(tint_symbol_226, x_2626.tint_symbol_27);
          tint_symbol_225 = (x_2626.tint_symbol_23 + (x_2626.tint_symbol_27 * 0.00400000018998980522f));
          tint_symbol_224 = (tint_symbol_224 * 0.60000002384185791016f);
          if ((x_2649 == 1i)) {
            break;
          }
        } else {
          break;
        }
      }
    }

    continuing {
      tint_symbol_228 = (tint_symbol_228 + 1i);
    }
  }
  let x_2741 = tint_symbol_162_2;
  return clamp(x_2741, vec4f(), x_2608);
}

const x_2764 = vec2f(2.0f);

fn tint_symbol_235_inner(tint_symbol_236 : vec3u) {
  var tint_symbol_239 = vec3f();
  var tint_symbol_240 = vec3f();
  var x_2760 : bool;
  var x_2761 : bool;
  let x_2747 = bitcast<vec2i>(tint_symbol_236.xy);
  let x_2750 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_82)));
  let x_2755 = (x_2747.x >= x_2750.x);
  x_2761 = x_2755;
  if (x_2755) {
  } else {
    x_2760 = (x_2747.y >= x_2750.y);
    x_2761 = x_2760;
  }
  if (x_2761) {
    return;
  }
  let x_2769 = (x_2764 / tint_symbol_80.inner.tint_symbol_56.xy);
  tint_symbol_239 = vec3f((((f32(x_2747.x) + 0.5f) * x_2769.x) - 1.0f), (((f32(x_2747.y) + 0.5f) * x_2769.y) - 1.0f), 0.0f);
  tint_symbol_240 = x_1609;
  let x_2786 = tint_symbol_239;
  let x_2785 = tint_symbol_106(x_2786);
  tint_symbol_239 = x_2785;
  let x_2788 = tint_symbol_240;
  let x_2787 = tint_symbol_104(x_2788);
  tint_symbol_240 = x_2787;
  let x_2790 = tint_symbol_239;
  let x_2791 = tint_symbol_240;
  let x_2789 = tint_symbol_220(x_2790, x_2791, x_2747);
  textureStore(tint_symbol_82, x_2747, x_2789);
  return;
}

fn tint_symbol_235_1() {
  let x_2798 = tint_symbol_236_1;
  tint_symbol_235_inner(x_2798);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeOrthogonalMain(@builtin(global_invocation_id) tint_symbol_236_1_param : vec3u) {
  tint_symbol_236_1 = tint_symbol_236_1_param;
  tint_symbol_235_1();
}

fn tint_symbol_241_inner(tint_symbol_236_3 : vec3u) {
  var tint_symbol_239_1 = vec3f();
  var tint_symbol_240_1 = vec3f();
  var x_2814 : bool;
  var x_2815 : bool;
  let x_2802 = bitcast<vec2i>(tint_symbol_236_3.xy);
  let x_2804 = bitcast<vec2i>(vec2i(textureDimensions(tint_symbol_82)));
  let x_2809 = (x_2802.x >= x_2804.x);
  x_2815 = x_2809;
  if (x_2809) {
  } else {
    x_2814 = (x_2802.y >= x_2804.y);
    x_2815 = x_2814;
  }
  if (x_2815) {
    return;
  }
  let x_2824 = (x_2764 / (tint_symbol_80.inner.tint_symbol_56.xy * tint_symbol_80.inner.tint_symbol_55));
  tint_symbol_239_1 = vec3f();
  tint_symbol_240_1 = normalize(vec3f((((f32(x_2802.x) + 0.5f) * x_2824.x) - (1.0f / tint_symbol_80.inner.tint_symbol_55.x)), (((f32(x_2802.y) + 0.5f) * x_2824.y) - (1.0f / tint_symbol_80.inner.tint_symbol_55.y)), 1.0f));
  let x_2848 = tint_symbol_239_1;
  let x_2847 = tint_symbol_106(x_2848);
  tint_symbol_239_1 = x_2847;
  let x_2850 = tint_symbol_240_1;
  let x_2849 = tint_symbol_104(x_2850);
  tint_symbol_240_1 = x_2849;
  let x_2852 = tint_symbol_239_1;
  let x_2853 = tint_symbol_240_1;
  let x_2851 = tint_symbol_220(x_2852, x_2853, x_2802);
  textureStore(tint_symbol_82, x_2802, x_2851);
  return;
}

fn tint_symbol_241_1() {
  let x_2859 = tint_symbol_236_2;
  tint_symbol_241_inner(x_2859);
  return;
}

@compute @workgroup_size(16i, 16i, 1i)
fn computeProjectiveMain(@builtin(global_invocation_id) tint_symbol_236_2_param : vec3u) {
  tint_symbol_236_2 = tint_symbol_236_2_param;
  tint_symbol_241_1();
}
