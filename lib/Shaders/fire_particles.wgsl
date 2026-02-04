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

// TODO 3: Define a struct to store a particle
struct Particle {
  position: vec2f,
  velocity: vec2f,
  lifespan: f32,
  size: f32
}

// TODO 4: Write the bind group spells here using array<Particle>
// name the binded variables particlesIn and particlesOut
 @group(0) @binding(0) var<storage> particlesIn: array<Particle>;
 @group(0) @binding(1) var<storage, read_write> particlesOut: array<Particle>;
 @group(0) @binding(2) var<uniform> time: f32;

fn rand(offset: f32) -> f32 {
    return fract(sin(time + offset) + 43758.5453);
}

struct VertexOutput {
  @builtin(position) pos: vec4f,
  @location(0) dist: f32
};

@vertex
fn vertexMain(@builtin(instance_index) idx: u32,
              @builtin(vertex_index) vIdx: u32) -> VertexOutput {
  let p = particlesIn[idx];

  let base = vec2f(0.0, -0.8);
  var dist = length(p.position - base) * 1024.0;
  if (dist > 255.0) {
    dist = 255.0;
  }

  //let size = 0.0125 * (255.0 - dist) / 255.0 * p.size;
  let size = 0.1 * (255.0 - dist) / 255.0 * p.size;

  let pi = 3.14159265;
  let theta = 2.0 * pi / 8.0 * f32(vIdx);
  let x = cos(theta) * size;
  let y = sin(theta) * size;

  var out: VertexOutput;
  out.pos = vec4f(vec2f(x + p.position.x, y + p.position.y), 0.0, 1.0);
  out.dist = dist;
  return out;
}

@fragment
fn fragmentMain(@location(0) dist: f32) -> @location(0) vec4f {
  let center = vec4f(253.0/255.0, 207.0/255.0, 88.0/255.0, 1.0);
  let mid    = vec4f(242.0/255.0, 125.0/255.0, 12.0/255.0, 1.0);
  let edge   = vec4f(128.0/255.0,   9.0/255.0,  9.0/255.0, 1.0);

  if (dist > 128.0) {
    let t = (dist - 128.0) / (255.0 - 128.0);
    return edge * t + mid * (1.0 - t);
  } else {
    let t = (128.0 - dist) / 128.0;
    return center * t + mid * (1.0 - t);
  }
}

@compute @workgroup_size(256)
fn computeMain(@builtin(global_invocation_id) global_id: vec3u) {
  let idx = global_id.x;
  var p = particlesIn[idx];

  // upward motion + gravity (optional)
  //let gravity = vec2f(0.0, -0.0005);
  //p.velocity = p.velocity + gravity;

  // horizontal flicker using rand()
  let flicker = (rand(f32(idx)) - 0.5) * 0.0008;
  p.velocity.x = p.velocity.x + flicker;

  // centering + damping (x only)
  p.position.x = p.position.x + (0.0 - p.position.x) * 0.2;
  p.velocity.x = p.velocity.x * 0.98;

  // update position
  p.position = p.position + p.velocity;

  // decrease lifespan
  p.lifespan = p.lifespan - 1.0;

  // respawn when dead or too high
  if (p.lifespan <= 0.0 || p.position.y > 1.0) {
    let base = vec2f(0.0, -0.8);
    p.position = base;

    let vx = (rand(f32(idx) + 10.0) - 0.5) * 0.002;
    let vy = 0.01 + rand(f32(idx) + 20.0) * 0.01;
    p.velocity = vec2f(vx, vy);

    p.lifespan = 128.0 + rand(f32(idx) + 30.0) * 127.0;
  }

  particlesOut[idx] = p;
}
