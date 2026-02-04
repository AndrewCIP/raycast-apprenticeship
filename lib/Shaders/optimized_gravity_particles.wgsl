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
  tint_symbol_1 : vec2f,
  /* @offset(8) */
  tint_symbol_2 : vec2f,
  /* @offset(16) */
  tint_symbol_3 : vec2f,
  /* @offset(24) */
  tint_symbol_4 : vec2f,
  /* @offset(32) */
  tint_symbol_5 : f32,
  /* @offset(36) */
  tint_symbol_6 : f32,
}

alias RTArr = array<tint_symbol>;

struct tint_symbol_7_block {
  /* @offset(0) */
  inner : RTArr,
}

var<private> tint_symbol_10_1 : u32;

var<private> tint_symbol_11_1 : u32;

var<private> value = vec4f();

var<private> value_1 = vec4f();

var<private> tint_symbol_21_1 : vec3u;

@group(0) @binding(0) var<storage> tint_symbol_7 : tint_symbol_7_block;

@group(0) @binding(1) var<storage, read_write> tint_symbol_8 : tint_symbol_7_block;

fn tint_symbol_9_inner(tint_symbol_10 : u32, tint_symbol_11 : u32) -> vec4f {
  let x_32 = tint_symbol_7.inner[tint_symbol_10];
  let x_38 = (0.01250000018626451492f * (x_32.tint_symbol_5 / 255.0f));
  let x_45 = (((2.0f * 3.14159274101257324219f) / 8.0f) * f32(tint_symbol_11));
  let x_57 = vec2f(((cos(x_45) * x_38) + x_32.tint_symbol_1.x), ((sin(x_45) * x_38) + x_32.tint_symbol_1.y));
  return vec4f(x_57.x, x_57.y, 0.0f, 1.0f);
}

fn tint_symbol_9_1() {
  let x_67 = tint_symbol_10_1;
  let x_68 = tint_symbol_11_1;
  let x_66 = tint_symbol_9_inner(x_67, x_68);
  value = x_66;
  return;
}

struct tint_symbol_9_out {
  @builtin(position)
  value_2 : vec4f,
}

@vertex
fn vertexMain(@builtin(instance_index) tint_symbol_10_1_param : u32, @builtin(vertex_index) tint_symbol_11_1_param : u32) -> tint_symbol_9_out {
  tint_symbol_10_1 = tint_symbol_10_1_param;
  tint_symbol_11_1 = tint_symbol_11_1_param;
  tint_symbol_9_1();
  return tint_symbol_9_out(value);
}

fn tint_symbol_19_inner() -> vec4f {
  return vec4f(0.93333333730697631836f, 0.46274510025978088379f, 0.13725490868091583252f, 1.0f);
}

fn tint_symbol_19_1() {
  let x_78 = tint_symbol_19_inner();
  value_1 = x_78;
  return;
}

struct tint_symbol_19_out {
  @location(0)
  value_1_1 : vec4f,
}

@fragment
fn fragmentMain() -> tint_symbol_19_out {
  tint_symbol_19_1();
  return tint_symbol_19_out(value_1);
}

fn tint_symbol_20_inner(tint_symbol_21 : vec3u) {
  var tint_symbol_12 = tint_symbol(vec2f(), vec2f(), vec2f(), vec2f(), 0.0f, 0.0f);
  var x_83 : u32;
  var x_122 : bool;
  var x_123 : bool;
  var x_129 : bool;
  var x_130 : bool;
  var x_135 : bool;
  var x_136 : bool;
  var x_141 : bool;
  var x_142 : bool;
  x_83 = tint_symbol_21.x;
  if ((x_83 < arrayLength(&(tint_symbol_7.inner)))) {
    tint_symbol_12 = tint_symbol_7.inner[x_83];
    tint_symbol_12.tint_symbol_3 = (tint_symbol_12.tint_symbol_3 + vec2f(0.0f, -0.00009999999747378752f));
    tint_symbol_12.tint_symbol_1 = (tint_symbol_12.tint_symbol_1 + tint_symbol_12.tint_symbol_3);
    tint_symbol_12.tint_symbol_5 = (tint_symbol_12.tint_symbol_5 - 1.0f);
    let x_117 = (tint_symbol_12.tint_symbol_1.x < -1.0f);
    x_123 = x_117;
    if (x_117) {
    } else {
      x_122 = (tint_symbol_12.tint_symbol_1.x > 1.0f);
      x_123 = x_122;
    }
    x_130 = x_123;
    if (x_123) {
    } else {
      x_129 = (tint_symbol_12.tint_symbol_1.y < -1.0f);
      x_130 = x_129;
    }
    x_136 = x_130;
    if (x_130) {
    } else {
      x_135 = (tint_symbol_12.tint_symbol_1.y > 1.0f);
      x_136 = x_135;
    }
    x_142 = x_136;
    if (x_136) {
    } else {
      x_141 = (tint_symbol_12.tint_symbol_5 <= 0.0f);
      x_142 = x_141;
    }
    if (x_142) {
      tint_symbol_12.tint_symbol_1 = tint_symbol_12.tint_symbol_2;
      tint_symbol_12.tint_symbol_3 = tint_symbol_12.tint_symbol_4;
      tint_symbol_12.tint_symbol_5 = tint_symbol_12.tint_symbol_6;
    }
    tint_symbol_8.inner[x_83] = tint_symbol_12;
  }
  return;
}

fn tint_symbol_20_1() {
  let x_161 = tint_symbol_21_1;
  tint_symbol_20_inner(x_161);
  return;
}

@compute @workgroup_size(256i, 1i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_21_1_param : vec3u) {
  tint_symbol_21_1 = tint_symbol_21_1_param;
  tint_symbol_20_1();
}
