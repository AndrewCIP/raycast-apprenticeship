// Fireworks particle system shader
// Effect 1: Explosive bursts of colored sparks from a mouse-clicked emitter.
//
// Features covered:
//   - Compute shader particle physics (ping-pong storage buffers)
//   - Gravity force applied every step
//   - Per-particle lifespan with respawn at emitter; max count = numParticles
//   - Position updated from velocity + acceleration (gravity) each step
//   - Circular (torus) wrap-around boundary
//   - Emitter position driven by mouse click (set via CPU uniform)
//   - Soft-circle sprite texture sampled per particle quad
//   - Recognizable fireworks effect (random hue sparks, radial burst)

// -------------------------------------------------------------------
// Structs
// -------------------------------------------------------------------

// 48 bytes per particle (12 × f32), matching JS Float32Array layout:
//   [x, y, vx, vy, r, g, b, a, lifespan, maxLifespan, _pad1, _pad2]
struct Particle {
  position:    vec2f,   // offset  0
  velocity:    vec2f,   // offset  8
  color:       vec4f,   // offset 16
  lifespan:    f32,     // offset 32
  maxLifespan: f32,     // offset 36
  _pad1:       f32,     // offset 40
  _pad2:       f32,     // offset 44
}

// 16 bytes (4 × f32): [emitterX, emitterY, time, _pad]
struct Uniforms {
  emitterX: f32,
  emitterY: f32,
  time:     f32,
  _pad:     f32,
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

// -------------------------------------------------------------------
// Vertex shader – renders each particle as a textured triangle-list quad
// (6 vertices per instance: two triangles covering a billboard square)
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

  // Unit quad – two CCW triangles
  let quadPos = array<vec2f, 6>(
    vec2f(-1.0, -1.0),
    vec2f( 1.0, -1.0),
    vec2f( 1.0,  1.0),
    vec2f(-1.0, -1.0),
    vec2f( 1.0,  1.0),
    vec2f(-1.0,  1.0),
  );
  // Corresponding UV coords (V flipped so top-left = (0,0))
  let quadUV = array<vec2f, 6>(
    vec2f(0.0, 1.0),
    vec2f(1.0, 1.0),
    vec2f(1.0, 0.0),
    vec2f(0.0, 1.0),
    vec2f(1.0, 0.0),
    vec2f(0.0, 0.0),
  );

  // Scale particle size proportionally to remaining lifespan
  let lifeRatio = clamp(p.lifespan / p.maxLifespan, 0.0, 1.0);
  let size = 0.015 * lifeRatio;

  var out: VertexOutput;
  out.pos = vec4f(p.position + quadPos[vIdx] * size, 0.0, 1.0);
  out.uv  = quadUV[vIdx];
  // Fade alpha as particle ages
  out.col = vec4f(p.color.rgb, p.color.a * lifeRatio);
  return out;
}

// -------------------------------------------------------------------
// Fragment shader – samples sprite texture for soft circular glow
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
// Compute shader – updates particle physics at 256 threads / workgroup
// -------------------------------------------------------------------

@compute @workgroup_size(256)
fn computeMain(@builtin(global_invocation_id) global_id: vec3u) {
  let idx = global_id.x;
  if (idx >= arrayLength(&particlesIn)) { return; }

  var p = particlesIn[idx];

  // --- Force 1: gravity pulls sparks downward ---
  let gravity = vec2f(0.0, -0.0015);
  p.velocity += gravity;

  // --- Integrate position ---
  p.position += p.velocity;

  // --- Decrement lifespan ---
  p.lifespan -= 1.0;

  // --- Circular (torus) wrap-around boundary ---
  // Particles that exit one edge reappear on the opposite edge.
  if (p.position.x >  1.0) { p.position.x -= 2.0; }
  if (p.position.x < -1.0) { p.position.x += 2.0; }
  if (p.position.y >  1.0) { p.position.y -= 2.0; }
  if (p.position.y < -1.0) { p.position.y += 2.0; }

  // --- Respawn dead particles at the emitter (mouse click position) ---
  if (p.lifespan <= 0.0) {
    let seed = uniforms.time + f32(idx) * 0.3183;

    p.position = vec2f(uniforms.emitterX, uniforms.emitterY);

    // Random radial burst velocity
    let angle = hash(seed)          * 6.28318;
    let speed = 0.004 + hash(seed + 1.0) * 0.018;
    p.velocity = vec2f(cos(angle) * speed, sin(angle) * speed);

    // Random firework hue: red / orange / yellow / cyan-blue / violet
    let c = hash(seed + 2.0);
    if (c < 0.2) {
      p.color = vec4f(1.00, 0.15, 0.05, 1.0);
    } else if (c < 0.4) {
      p.color = vec4f(1.00, 0.55, 0.05, 1.0);
    } else if (c < 0.6) {
      p.color = vec4f(1.00, 1.00, 0.20, 1.0);
    } else if (c < 0.8) {
      p.color = vec4f(0.40, 0.80, 1.00, 1.0);
    } else {
      p.color = vec4f(0.90, 0.40, 1.00, 1.0);
    }

    let maxLife = 80.0 + hash(seed + 3.0) * 120.0;
    p.lifespan    = maxLife;
    p.maxLifespan = maxLife;
  }

  particlesOut[idx] = p;
}
