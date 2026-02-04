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
  tint_symbol_3 : f32,
  /* @offset(20) */
  tint_symbol_4 : f32,
}

alias RTArr = array<tint_symbol>;

struct tint_symbol_5_block {
  /* @offset(0) */
  inner : RTArr,
}

struct tint_symbol_7_block {
  /* @offset(0) */
  inner : f32,
}

struct tint_symbol_10 {
  /* @offset(0) */
  tint_symbol_11 : vec4f,
  /* @offset(16) */
  tint_symbol_12 : f32,
}

var<private> tint_symbol_14_1 : u32;

var<private> tint_symbol_15_1 : u32;

var<private> tint_symbol_11_1 = vec4f();

var<private> tint_symbol_12_1 = 0.0f;

var<private> tint_symbol_12_2 : f32;

var<private> value = vec4f();

var<private> tint_symbol_29_1 : vec3u;

@group(0) @binding(0) var<storage> tint_symbol_5 : tint_symbol_5_block;

@group(0) @binding(1) var<storage, read_write> tint_symbol_6 : tint_symbol_5_block;

@group(0) @binding(2) var<uniform> tint_symbol_7 : tint_symbol_7_block;

fn tint_symbol_8(tint_symbol_9 : f32) -> f32 {
  let x_40 = tint_symbol_7.inner;
  return fract((sin((x_40 + tint_symbol_9)) + 43758.546875f));
}

const x_54 = vec2f(0.0f, -0.80000001192092895508f);

fn tint_symbol_13_inner(tint_symbol_14 : u32, tint_symbol_15 : u32) -> tint_symbol_10 {
  var tint_symbol_12 = 0.0f;
  var tint_symbol_22 = tint_symbol_10(vec4f(), 0.0f);
  let x_52 = tint_symbol_5.inner[tint_symbol_14];
  tint_symbol_12 = (length((x_52.tint_symbol_1 - x_54)) * 1024.0f);
  if ((tint_symbol_12 > 255.0f)) {
    tint_symbol_12 = 255.0f;
  }
  let x_74 = (((0.10000000149011611938f * (255.0f - tint_symbol_12)) / 255.0f) * x_52.tint_symbol_4);
  let x_81 = (((2.0f * 3.14159274101257324219f) / 8.0f) * f32(tint_symbol_15));
  let x_97 = vec2f(((cos(x_81) * x_74) + x_52.tint_symbol_1.x), ((sin(x_81) * x_74) + x_52.tint_symbol_1.y));
  tint_symbol_22.tint_symbol_11 = vec4f(x_97.x, x_97.y, 0.0f, 1.0f);
  tint_symbol_22.tint_symbol_12 = tint_symbol_12;
  let x_105 = tint_symbol_22;
  return x_105;
}

fn tint_symbol_13_1() {
  let x_111 = tint_symbol_14_1;
  let x_112 = tint_symbol_15_1;
  let x_110 = tint_symbol_13_inner(x_111, x_112);
  tint_symbol_11_1 = x_110.tint_symbol_11;
  tint_symbol_12_1 = x_110.tint_symbol_12;
  return;
}

struct tint_symbol_13_out {
  @builtin(position)
  tint_symbol_11_1_1 : vec4f,
  @location(0)
  tint_symbol_12_1_1 : f32,
}

@vertex
fn vertexMain(@builtin(instance_index) tint_symbol_14_1_param : u32, @builtin(vertex_index) tint_symbol_15_1_param : u32) -> tint_symbol_13_out {
  tint_symbol_14_1 = tint_symbol_14_1_param;
  tint_symbol_15_1 = tint_symbol_15_1_param;
  tint_symbol_13_1();
  return tint_symbol_13_out(tint_symbol_11_1, tint_symbol_12_1);
}

const x_126 = vec4f(0.94901961088180541992f, 0.49019607901573181152f, 0.04705882444977760315f, 1.0f);

fn tint_symbol_23_inner(tint_symbol_12_3 : f32) -> vec4f {
  if ((tint_symbol_12_3 > 128.0f)) {
    let x_137 = ((tint_symbol_12_3 - 128.0f) / 127.0f);
    return ((vec4f(0.50196081399917602539f, 0.03529411926865577698f, 0.03529411926865577698f, 1.0f) * x_137) + (x_126 * (1.0f - x_137)));
  } else {
    let x_143 = ((128.0f - tint_symbol_12_3) / 128.0f);
    return ((vec4f(0.99215686321258544922f, 0.81176471710205078125f, 0.34509804844856262207f, 1.0f) * x_143) + (x_126 * (1.0f - x_143)));
  }
}

fn tint_symbol_23_1() {
  let x_151 = tint_symbol_12_2;
  let x_150 = tint_symbol_23_inner(x_151);
  value = x_150;
  return;
}

struct tint_symbol_23_out {
  @location(0)
  value_1 : vec4f,
}

@fragment
fn fragmentMain(@location(0) tint_symbol_12_2_param : f32) -> tint_symbol_23_out {
  tint_symbol_12_2 = tint_symbol_12_2_param;
  tint_symbol_23_1();
  return tint_symbol_23_out(value);
}

fn tint_symbol_28_inner(tint_symbol_29 : vec3u) {
  var tint_symbol_16 = tint_symbol(vec2f(), vec2f(), 0.0f, 0.0f);
  var x_205 : bool;
  var x_206 : bool;
  let x_156 = tint_symbol_29.x;
  tint_symbol_16 = tint_symbol_5.inner[x_156];
  let x_162 = tint_symbol_8(f32(x_156));
  tint_symbol_16.tint_symbol_2.x = (tint_symbol_16.tint_symbol_2.x + ((x_162 - 0.5f) * 0.00079999997979030013f));
  tint_symbol_16.tint_symbol_1.x = (tint_symbol_16.tint_symbol_1.x + ((0.0f - tint_symbol_16.tint_symbol_1.x) * 0.20000000298023223877f));
  tint_symbol_16.tint_symbol_2.x = (tint_symbol_16.tint_symbol_2.x * 0.98000001907348632812f);
  tint_symbol_16.tint_symbol_1 = (tint_symbol_16.tint_symbol_1 + tint_symbol_16.tint_symbol_2);
  tint_symbol_16.tint_symbol_3 = (tint_symbol_16.tint_symbol_3 - 1.0f);
  let x_200 = (tint_symbol_16.tint_symbol_3 <= 0.0f);
  x_206 = x_200;
  if (x_200) {
  } else {
    x_205 = (tint_symbol_16.tint_symbol_1.y > 1.0f);
    x_206 = x_205;
  }
  if (x_206) {
    tint_symbol_16.tint_symbol_1 = x_54;
    let x_210 = tint_symbol_8((f32(x_156) + 10.0f));
    let x_217 = tint_symbol_8((f32(x_156) + 20.0f));
    tint_symbol_16.tint_symbol_2 = vec2f(((x_210 - 0.5f) * 0.00200000009499490261f), (0.00999999977648258209f + (x_217 * 0.00999999977648258209f)));
    let x_226 = tint_symbol_8((f32(x_156) + 30.0f));
    tint_symbol_16.tint_symbol_3 = (128.0f + (x_226 * 127.0f));
  }
  tint_symbol_6.inner[x_156] = tint_symbol_16;
  return;
}

fn tint_symbol_28_1() {
  let x_238 = tint_symbol_29_1;
  tint_symbol_28_inner(x_238);
  return;
}

@compute @workgroup_size(256i, 1i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_29_1_param : vec3u) {
  tint_symbol_29_1 = tint_symbol_29_1_param;
  tint_symbol_28_1();
}
