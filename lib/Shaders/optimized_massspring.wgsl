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
  tint_symbol_4 : f32,
  /* @offset(28) */
  tint_symbol_5 : f32,
}

alias RTArr = array<tint_symbol>;

struct tint_symbol_10_block {
  /* @offset(0) */
  inner : RTArr,
}

struct tint_symbol_6 {
  /* @offset(0) */
  tint_symbol_7 : vec2f,
  /* @offset(8) */
  tint_symbol_8 : f32,
  /* @offset(12) */
  tint_symbol_9 : f32,
}

alias RTArr_1 = array<tint_symbol_6>;

struct tint_symbol_12_block {
  /* @offset(0) */
  inner : RTArr_1,
}

var<private> tint_symbol_14_1 : u32;

var<private> tint_symbol_15_1 : u32;

var<private> value = vec4f();

var<private> value_1 = vec4f();

var<private> tint_symbol_14_2 : u32;

var<private> tint_symbol_15_2 : u32;

var<private> value_2 = vec4f();

var<private> value_3 = vec4f();

var<private> tint_symbol_26_1 : vec3u;

var<private> tint_symbol_26_2 : vec3u;

@group(0) @binding(0) var<storage> tint_symbol_10 : tint_symbol_10_block;

@group(0) @binding(1) var<storage, read_write> tint_symbol_11 : tint_symbol_10_block;

@group(0) @binding(2) var<storage> tint_symbol_12 : tint_symbol_12_block;

fn tint_ftou(v : f32) -> u32 {
  return select(4294967295u, select(u32(v), 0u, (v < 0.0f)), (v < 4294967040.0f));
}

fn tint_symbol_13_inner(tint_symbol_14 : u32, tint_symbol_15 : u32) -> vec4f {
  let x_56 = tint_symbol_10.inner[tint_symbol_14];
  let x_57 = x_56.tint_symbol_4;
  let x_64 = (((2.0f * 3.14159274101257324219f) / 8.0f) * f32(tint_symbol_15));
  let x_79 = vec2f(((cos(x_64) * x_57) + x_56.tint_symbol_1.x), ((sin(x_64) * x_57) + x_56.tint_symbol_1.y));
  return vec4f(x_79.x, x_79.y, 0.0f, 1.0f);
}

fn tint_symbol_13_1() {
  let x_89 = tint_symbol_14_1;
  let x_90 = tint_symbol_15_1;
  let x_88 = tint_symbol_13_inner(x_89, x_90);
  value = x_88;
  return;
}

struct tint_symbol_13_out {
  @builtin(position)
  value_4 : vec4f,
}

@vertex
fn vertexMain(@builtin(instance_index) tint_symbol_14_1_param : u32, @builtin(vertex_index) tint_symbol_15_1_param : u32) -> tint_symbol_13_out {
  tint_symbol_14_1 = tint_symbol_14_1_param;
  tint_symbol_15_1 = tint_symbol_15_1_param;
  tint_symbol_13_1();
  return tint_symbol_13_out(value);
}

fn tint_symbol_22_inner() -> vec4f {
  return vec4f(0.93333333730697631836f, 0.46274510025978088379f, 0.13725490868091583252f, 1.0f);
}

fn tint_symbol_22_1() {
  let x_100 = tint_symbol_22_inner();
  value_1 = x_100;
  return;
}

struct tint_symbol_22_out {
  @location(0)
  value_1_1 : vec4f,
}

@fragment
fn fragmentMain() -> tint_symbol_22_out {
  tint_symbol_22_1();
  return tint_symbol_22_out(value_1);
}

fn tint_mod(lhs : u32, rhs : u32) -> u32 {
  return (lhs % select(rhs, 1u, (rhs == 0u)));
}

fn tint_div(lhs_1 : u32, rhs_1 : u32) -> u32 {
  return (lhs_1 / select(rhs_1, 1u, (rhs_1 == 0u)));
}

fn tint_symbol_23_inner(tint_symbol_14_3 : u32, tint_symbol_15_3 : u32) -> vec4f {
  var x_135 = vec2f();
  let x_122 = tint_mod(tint_symbol_15_3, 2u);
  let x_126 = tint_symbol_12.inner[tint_symbol_14_3].tint_symbol_7[x_122];
  let x_121 = tint_ftou(x_126);
  let x_129 = tint_symbol_10.inner[x_121].tint_symbol_1;
  let x_132 = tint_div(tint_symbol_15_3, 2u);
  let x_134 = (x_129 + vec2f((0.00100000004749745131f * f32(x_132))));
  return vec4f(x_134.x, x_134.y, 0.0f, 1.0f);
}

fn tint_symbol_23_1() {
  let x_145 = tint_symbol_14_2;
  let x_146 = tint_symbol_15_2;
  let x_144 = tint_symbol_23_inner(x_145, x_146);
  value_2 = x_144;
  return;
}

struct tint_symbol_23_out {
  @builtin(position)
  value_2_1 : vec4f,
}

@vertex
fn vertexSpringMain(@builtin(instance_index) tint_symbol_14_2_param : u32, @builtin(vertex_index) tint_symbol_15_2_param : u32) -> tint_symbol_23_out {
  tint_symbol_14_2 = tint_symbol_14_2_param;
  tint_symbol_15_2 = tint_symbol_15_2_param;
  tint_symbol_23_1();
  return tint_symbol_23_out(value_2);
}

fn tint_symbol_24_inner() -> vec4f {
  return vec4f(1.0f, 0.63921570777893066406f, 0.0f, 1.0f);
}

fn tint_symbol_24_1() {
  let x_153 = tint_symbol_24_inner();
  value_3 = x_153;
  return;
}

struct tint_symbol_24_out {
  @location(0)
  value_3_1 : vec4f,
}

@fragment
fn fragmentSpringMain() -> tint_symbol_24_out {
  tint_symbol_24_1();
  return tint_symbol_24_out(value_3);
}

fn tint_symbol_25_inner(tint_symbol_26 : vec3u) {
  var tint_symbol_27 = tint_symbol_6(vec2f(), 0.0f, 0.0f);
  var x_204 = vec2f();
  var x_216 = vec2f();
  var x_158 : u32;
  x_158 = tint_symbol_26.x;
  if ((x_158 < arrayLength(&(tint_symbol_12.inner)))) {
    tint_symbol_27 = tint_symbol_12.inner[x_158];
    let x_172 = tint_symbol_27.tint_symbol_7[0i];
    let x_169 = tint_ftou(x_172);
    let x_175 = tint_symbol_27.tint_symbol_7.y;
    let x_173 = tint_ftou(x_175);
    let x_182 = tint_symbol_10.inner[x_169].tint_symbol_4;
    let x_184 = tint_symbol_10.inner[x_173].tint_symbol_4;
    let x_185 = (tint_symbol_10.inner[x_173].tint_symbol_1 - tint_symbol_10.inner[x_169].tint_symbol_1);
    let x_192 = (tint_symbol_27.tint_symbol_9 * (length(x_185) - tint_symbol_27.tint_symbol_8));
    let x_193 = normalize(x_185);
    if ((x_182 != 0.0f)) {
      tint_symbol_11.inner[x_169].tint_symbol_3 = (tint_symbol_11.inner[x_169].tint_symbol_3 + ((x_193 * x_192) / vec2f((x_182 * 1000.0f))));
    }
    if ((x_184 != 0.0f)) {
      tint_symbol_11.inner[x_173].tint_symbol_3 = (tint_symbol_11.inner[x_173].tint_symbol_3 - ((x_193 * x_192) / vec2f((x_184 * 1000.0f))));
    }
  }
  return;
}

fn tint_symbol_25_1() {
  let x_222 = tint_symbol_26_1;
  tint_symbol_25_inner(x_222);
  return;
}

@compute @workgroup_size(256i, 1i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_26_1_param : vec3u) {
  tint_symbol_26_1 = tint_symbol_26_1_param;
  tint_symbol_25_1();
}

fn tint_symbol_38_inner(tint_symbol_26_3 : vec3u) {
  var tint_symbol_16 = tint_symbol(vec2f(), vec2f(), vec2f(), 0.0f, 0.0f);
  var x_226 : u32;
  x_226 = tint_symbol_26_3.x;
  if ((x_226 < arrayLength(&(tint_symbol_10.inner)))) {
    tint_symbol_16 = tint_symbol_10.inner[x_226];
    if ((tint_symbol_16.tint_symbol_5 != 1.0f)) {
      tint_symbol_11.inner[x_226].tint_symbol_1 = ((tint_symbol_16.tint_symbol_1 + tint_symbol_16.tint_symbol_2) + tint_symbol_11.inner[x_226].tint_symbol_3);
      tint_symbol_11.inner[x_226].tint_symbol_2 = ((tint_symbol_16.tint_symbol_2 + tint_symbol_11.inner[x_226].tint_symbol_3) * 0.94999998807907104492f);
    } else {
      tint_symbol_11.inner[x_226] = tint_symbol_16;
    }
    tint_symbol_11.inner[x_226].tint_symbol_3 = vec2f();
    tint_symbol_11.inner[x_226].tint_symbol_4 = tint_symbol_16.tint_symbol_4;
    tint_symbol_11.inner[x_226].tint_symbol_5 = tint_symbol_16.tint_symbol_5;
    if ((x_226 == 255u)) {
      tint_symbol_11.inner[x_226].tint_symbol_2 = (tint_symbol_11.inner[x_226].tint_symbol_2 + vec2f(0.0f, -0.00100000004749745131f));
    }
  }
  return;
}

fn tint_symbol_38_1() {
  let x_282 = tint_symbol_26_2;
  tint_symbol_38_inner(x_282);
  return;
}

@compute @workgroup_size(256i, 1i, 1i)
fn updateMain(@builtin(global_invocation_id) tint_symbol_26_2_param : vec3u) {
  tint_symbol_26_2 = tint_symbol_26_2_param;
  tint_symbol_38_1();
}
