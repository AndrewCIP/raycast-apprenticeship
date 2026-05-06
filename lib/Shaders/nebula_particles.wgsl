// Nebula / space-dust particle system shader
// Effect 2: Thousands of drifting particles forming an ambient nebula cloud.
//
// Features covered:
//   - Compute shader particle physics (ping-pong storage buffers)
//   - Wind force (arrow keys) + central attraction force (mouse held)
//   - Per-particle lifespan; dead particles respawn randomly; max count = numParticles
//   - Position updated from velocity + wind/attraction acceleration each step
//   - Circular (torus) wrap-around boundary
//   - Mouse position drives attraction force; keyboard drives wind direction
//   - Soft-circle sprite texture sampled per particle quad
//   - Recognizable nebula effect (blue / purple / teal colour palette)

// -------------------------------------------------------------------
// Structs
// -------------------------------------------------------------------

// 32 bytes per particle (8 × f32), matching JS Float32Array layout:
//   [x, y, vx, vy, lifespan, maxLifespan, colorSeed, _pad]
struct Particle {
  position:    vec2f,   // offset  0
  velocity:    vec2f,   // offset  8
  lifespan:    f32,     // offset 16
  maxLifespan: f32,     // offset 20
  colorSeed:   f32,     // offset 24
  _pad:        f32,     // offset 28
}

// 32 bytes (8 × f32): [windX, windY, mouseX, mouseY, attract, time, _pad1, _pad2]
struct Uniforms {
  windX:   f32,
  windY:   f32,
  mouseX:  f32,
  mouseY:  f32,
  attract: f32,
  time:    f32,
  _pad1:   f32,
  _pad2:   f32,
}

// -------------------------------------------------------------------
// Bindings
// -------------------------------------------------------------------

@group(0) @binding(0) var<storage>             particlesIn:  array<Particle>;
@group(0) @binding(1) var<storage, read_write> particlesOut: array<Particle>;
@group(0) @binding(2) var<uniform>             uniforms:     Uniforms;
@group(0) @binding(3) var spriteTexture: texture_2d<f32>;
@group(0) @binding(4) var spriteSampler: sampler;

// -------------------------------------------------------------------
// Utilities
// -------------------------------------------------------------------

fn hash(v: f32) -> f32 {
  return fract(sin(v * 127.1 + 311.7) * 43758.5453);
}

// Map colorSeed → nebula palette (blue / purple / teal)
fn nebulaColor(seed: f32, lifeRatio: f32) -> vec4f {
  let c = hash(seed * 0.7 + 0.3);
  var col: vec3f;
  if (c < 0.33) {
    col = vec3f(0.20, 0.50, 1.00);   // blue
  } else if (c < 0.66) {
    col = vec3f(0.55, 0.20, 1.00);   // purple
  } else {
    col = vec3f(0.10, 0.85, 0.80);   // teal
  }
  return vec4f(col, lifeRatio * 0.75);
}

// -------------------------------------------------------------------
// Vertex shader – textured triangle-list quad (6 vertices per particle)
// -------------------------------------------------------------------

struct VertexOutput {
  @builtin(position) pos: vec4f,
  @location(0)       uv:  vec2f,
  @location(1)       col: vec4f,
}

@vertex
fn vertexMain(
  @builtin(instance_index) idx:  u32,
  @builtin(vertex_index)   vIdx: u32,
) -> VertexOutput {
  let p = particlesIn[idx];

  let quadPos = array<vec2f, 6>(
    vec2f(-1.0, -1.0),
    vec2f( 1.0, -1.0),
    vec2f( 1.0,  1.0),
    vec2f(-1.0, -1.0),
    vec2f( 1.0,  1.0),
    vec2f(-1.0,  1.0),
  );
  let quadUV = array<vec2f, 6>(
    vec2f(0.0, 1.0),
    vec2f(1.0, 1.0),
    vec2f(1.0, 0.0),
    vec2f(0.0, 1.0),
    vec2f(1.0, 0.0),
    vec2f(0.0, 0.0),
  );

  let lifeRatio = clamp(p.lifespan / p.maxLifespan, 0.0, 1.0);
  // Nebula particles are smaller than fireworks sparks
  let size = 0.006 + 0.004 * lifeRatio;

  var out: VertexOutput;
  out.pos = vec4f(p.position + quadPos[vIdx] * size, 0.0, 1.0);
  out.uv  = quadUV[vIdx];
  out.col = nebulaColor(p.colorSeed, lifeRatio);
  return out;
}

// -------------------------------------------------------------------
// Fragment shader – soft circular glow from sprite texture
// -------------------------------------------------------------------

@fragment
fn fragmentMain(
  @location(0) uv:  vec2f,
  @location(1) col: vec4f,
) -> @location(0) vec4f {
  let alpha = textureSample(spriteTexture, spriteSampler, uv).a;
  return vec4f(col.rgb, col.a * alpha);
}

// -------------------------------------------------------------------
// Compute shader
// -------------------------------------------------------------------

@compute @workgroup_size(256)
fn computeMain(@builtin(global_invocation_id) global_id: vec3u) {
  let idx = global_id.x;
  if (idx >= arrayLength(&particlesIn)) { return; }

  var p = particlesIn[idx];

  // --- Force 1: wind (keyboard arrow keys) ---
  let windForce = vec2f(uniforms.windX, uniforms.windY) * 0.00005;
  p.velocity += windForce;

  // --- Force 2: mouse attraction (held mouse button) ---
  let toMouse = vec2f(uniforms.mouseX, uniforms.mouseY) - p.position;
  let distToMouse = length(toMouse) + 0.001;
  let attractForce = (toMouse / distToMouse) * 0.00010 * uniforms.attract;
  p.velocity += attractForce;

  // --- Gentle drift toward centre when not attracted ---
  let centreDrift = -p.position * 0.00002 * (1.0 - uniforms.attract);
  p.velocity += centreDrift;

  // --- Velocity damping keeps speed bounded ---
  p.velocity *= 0.995;

  // --- Integrate position ---
  p.position += p.velocity;

  // --- Decrement lifespan ---
  p.lifespan -= 1.0;

  // --- Circular (torus) wrap-around boundary ---
  if (p.position.x >  1.0) { p.position.x -= 2.0; }
  if (p.position.x < -1.0) { p.position.x += 2.0; }
  if (p.position.y >  1.0) { p.position.y -= 2.0; }
  if (p.position.y < -1.0) { p.position.y += 2.0; }

  // --- Respawn dead particles at random screen positions ---
  if (p.lifespan <= 0.0) {
    let seed = uniforms.time * 0.01 + f32(idx) * 0.3183;
    p.position  = vec2f(hash(seed) * 2.0 - 1.0, hash(seed + 0.5) * 2.0 - 1.0);
    let angle   = hash(seed + 1.0) * 6.28318;
    let speed   = 0.0005 + hash(seed + 2.0) * 0.002;
    p.velocity  = vec2f(cos(angle) * speed, sin(angle) * speed);
    p.colorSeed = hash(seed + 3.0);
    let maxLife = 200.0 + hash(seed + 4.0) * 200.0;
    p.lifespan    = maxLife;
    p.maxLifespan = maxLife;
  }

  particlesOut[idx] = p;
}
