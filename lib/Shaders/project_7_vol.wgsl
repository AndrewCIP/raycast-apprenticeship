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

// ── 3-D Projective Geometric Algebra (PGA) ────────────────────────────────────

struct MultiVector {
  s: f32, exey: f32, exez: f32, eyez: f32,
  eoex: f32, eoey: f32, eoez: f32, exeyez: f32,
  eoexey: f32, eoexez: f32, eoeyez: f32,
  ex: f32, ey: f32, ez: f32, eo: f32, eoexeyez: f32
}

fn geometricProduct(a: MultiVector, b: MultiVector) -> MultiVector {
  var r: MultiVector;
  r.s        = a.s*b.s - a.exey*b.exey - a.exez*b.exez - a.eyez*b.eyez - a.exeyez*b.exeyez + a.ex*b.ex + a.ey*b.ey + a.ez*b.ez;
  r.exey     = a.s*b.exey + a.exey*b.s - a.exez*b.eyez + a.eyez*b.exez + a.exeyez*b.ez + a.ex*b.ey - a.ey*b.ex + a.ez*b.exeyez;
  r.exez     = a.s*b.exez + a.exey*b.eyez + a.exez*b.s - a.eyez*b.exey - a.exeyez*b.ey + a.ex*b.ez - a.ey*b.exeyez - a.ez*b.ex;
  r.eyez     = a.s*b.eyez - a.exey*b.exez + a.exez*b.exey + a.eyez*b.s + a.exeyez*b.ex + a.ex*b.exeyez + a.ey*b.ez - a.ez*b.ey;
  r.eoex     = a.s*b.eoex + a.exey*b.eoey + a.exez*b.eoez - a.eyez*b.eoexeyez + a.eoex*b.s - a.eoey*b.exey - a.eoez*b.exez + a.exeyez*b.eoeyez + a.eoexey*b.ey + a.eoexez*b.ez - a.eoeyez*b.exeyez - a.ex*b.eo + a.ey*b.eoexey + a.ez*b.eoexez + a.eo*b.ex - a.eoexeyez*b.eyez;
  r.eoey     = a.s*b.eoey - a.exey*b.eoex + a.exez*b.eoexeyez + a.eyez*b.eoez + a.eoex*b.exey + a.eoey*b.s - a.eoez*b.eyez - a.exeyez*b.eoexez - a.eoexey*b.ex + a.eoexez*b.exeyez + a.eoeyez*b.ey - a.ex*b.eoexey - a.ey*b.eo + a.ez*b.eoeyez + a.eo*b.ey + a.eoexeyez*b.exez;
  r.eoez     = a.s*b.eoez - a.exey*b.eoexeyez - a.exez*b.eoex - a.eyez*b.eoey + a.eoex*b.exez + a.eoey*b.eyez + a.eoez*b.s + a.exeyez*b.eoexey - a.eoexey*b.exeyez - a.eoexez*b.ex - a.eoeyez*b.ey - a.ex*b.eoexez - a.ey*b.eoeyez - a.ez*b.eo + a.eo*b.ez - a.eoexeyez*b.exey;
  r.exeyez   = a.s*b.exeyez + a.exey*b.ez - a.exez*b.ey + a.eyez*b.ex + a.exeyez*b.s + a.ex*b.eyez - a.ey*b.exez + a.ez*b.exey;
  r.eoexey   = a.s*b.eoexey + a.exey*b.eo - a.exez*b.eoeyez + a.eyez*b.eoexez + a.eoex*b.ey - a.eoey*b.ex + a.eoez*b.exeyez - a.exeyez*b.eoez + a.eoexey*b.s - a.eoexez*b.eyez + a.eoeyez*b.exez - a.ex*b.eoey + a.ey*b.eoex - a.ez*b.eoexeyez + a.eo*b.exey + a.eoexeyez*b.ez;
  r.eoexez   = a.s*b.eoexez + a.exey*b.eoeyez + a.exez*b.eo - a.eyez*b.eoexey + a.eoex*b.ez - a.eoey*b.exeyez - a.eoez*b.ex + a.exeyez*b.eoey + a.eoexey*b.eyez + a.eoexez*b.s - a.eoeyez*b.exey - a.ex*b.eoez + a.ey*b.eoexeyez + a.ez*b.eoex + a.eo*b.exez - a.eoexeyez*b.ey;
  r.eoeyez   = a.s*b.eoeyez - a.exey*b.eoexez + a.exez*b.eoexey + a.eyez*b.eo + a.eoex*b.exeyez + a.eoey*b.ez - a.eoez*b.ey - a.exeyez*b.eoex - a.eoexey*b.exez + a.eoexez*b.exey + a.eoeyez*b.s - a.ex*b.eoexeyez - a.ey*b.eoez + a.ez*b.eoey + a.eo*b.eyez + a.eoexeyez*b.ex;
  r.ex       = a.s*b.ex + a.exey*b.ey + a.exez*b.ez - a.eyez*b.exeyez - a.exeyez*b.eyez + a.ex*b.s - a.ey*b.exey - a.ez*b.exez;
  r.ey       = a.s*b.ey - a.exey*b.ex + a.exez*b.exeyez + a.eyez*b.ez + a.exeyez*b.exez + a.ex*b.exey + a.ey*b.s - a.ez*b.eyez;
  r.ez       = a.s*b.ez - a.exey*b.exeyez - a.exez*b.ex - a.eyez*b.ey - a.exeyez*b.exey + a.ex*b.exez + a.ey*b.eyez + a.ez*b.s;
  r.eo       = a.s*b.eo - a.exey*b.eoexey - a.exez*b.eoexez - a.eyez*b.eoeyez + a.eoex*b.ex + a.eoey*b.ey + a.eoez*b.ez + a.exeyez*b.eoexeyez - a.eoexey*b.exey - a.eoexez*b.exez - a.eoeyez*b.eyez - a.ex*b.eoex - a.ey*b.eoey - a.ez*b.eoez + a.eo*b.s - a.eoexeyez*b.exeyez;
  r.eoexeyez = a.s*b.eoexeyez + a.exey*b.eoez - a.exez*b.eoey + a.eyez*b.eoex + a.eoex*b.eyez - a.eoey*b.exez + a.eoez*b.exey - a.exeyez*b.eo + a.eoexey*b.ez - a.eoexez*b.ey + a.eoeyez*b.ex - a.ex*b.eoeyez + a.ey*b.eoexez - a.ez*b.eoexey + a.eo*b.exeyez + a.eoexeyez*b.s;
  return r;
}

fn reverse(a: MultiVector) -> MultiVector {
  return MultiVector(a.s, -a.exey, -a.exez, -a.eyez, -a.eoex, -a.eoey, -a.eoez, -a.exeyez,
                     -a.eoexey, -a.eoexez, -a.eoeyez, a.ex, a.ey, a.ez, a.eo, a.eoexeyez);
}

fn applyMotor(p: MultiVector, m: MultiVector) -> MultiVector {
  return geometricProduct(m, geometricProduct(p, reverse(m)));
}

fn motorNorm(m: MultiVector) -> f32 {
  var s = m.s*m.s + m.exey*m.exey + m.exez*m.exez + m.eyez*m.eyez
        + m.eoex*m.eoex + m.eoey*m.eoey + m.eoez*m.eoez + m.exeyez*m.exeyez
        + m.eoexey*m.eoexey + m.eoexez*m.eoexez + m.eoeyez*m.eoeyez
        + m.ex*m.ex + m.ey*m.ey + m.ez*m.ez + m.eo*m.eo + m.eoexeyez*m.eoexeyez;
  return sqrt(s);
}

fn normalizeMotor(m: MultiVector) -> MultiVector {
  let n = motorNorm(m);
  if (n == 0.0) { return MultiVector(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); }
  return MultiVector(m.s/n, m.exey/n, m.exez/n, m.eyez/n, m.eoex/n, m.eoey/n, m.eoez/n,
                     m.exeyez/n, m.eoexey/n, m.eoexez/n, m.eoeyez/n,
                     m.ex/n, m.ey/n, m.ez/n, m.eo/n, m.eoexeyez/n);
}

fn createDir(d: vec3f) -> MultiVector {
  return MultiVector(0, d.z, -d.y, d.x, 0,0,0,0,0,0,0,0,0,0,0,0);
}

fn createPoint(p: vec3f) -> MultiVector {
  return MultiVector(0,0,0,0,0,0,0, 1, -p.z, p.y, -p.x, 0,0,0,0,0);
}

fn extractPoint(p: MultiVector) -> vec3f {
  return vec3f(-p.eoeyez / p.exeyez, p.eoexez / p.exeyez, -p.eoexey / p.exeyez);
}

fn extractRotor(m: MultiVector) -> MultiVector {
  return MultiVector(m.s, m.exey, m.exez, m.eyez, 0,0,0,0,0,0,0,0,0,0,0,0);
}

fn applyMotorToPoint(p: vec3f, m: MultiVector) -> vec3f {
  return extractPoint(applyMotor(createPoint(p), m));
}

fn applyMotorToDir(d: vec3f, m: MultiVector) -> vec3f {
  let r = extractRotor(m);
  return extractPoint(applyMotor(createPoint(d), r));
}

// ── Structs & bindings ────────────────────────────────────────────────────────

struct Camera { motor: MultiVector, focal: vec2f, res: vec2f }
struct VolInfo { dims: vec4f, sizes: vec4f }

@group(0) @binding(0) var<uniform> cameraPose: Camera;
@group(0) @binding(1) var<uniform> volInfo:    VolInfo;
@group(0) @binding(2) var<storage> volData:    array<f32>;
@group(0) @binding(3) var          outTexture: texture_storage_2d<rgba8unorm, write>;

// ── Camera helpers ────────────────────────────────────────────────────────────

fn transformPt(pt: vec3f)  -> vec3f { return applyMotorToPoint(pt, cameraPose.motor); }
fn transformDir(d: vec3f)  -> vec3f { return applyMotorToDir(d,  cameraPose.motor); }

// ── Constants ─────────────────────────────────────────────────────────────────

const EPSILON:    f32    = 1e-8;
const NUM_STEPS:  i32    = 256;
const MISS_COLOR: vec4f  = vec4f(0.02, 0.02, 0.08, 1.0); // dark space-blue
const SKY_COLOR:  vec4f  = vec4f(0.52, 0.73, 0.90, 1.0); // daytime sky

// ── AABB intersection ─────────────────────────────────────────────────────────

fn compareVolumeHitValues(cur: vec2f, t: f32) -> vec2f {
  var r = cur;
  if (cur.x < 0.0) { r.x = t; }
  else {
    if (t < cur.x) { r.y = cur.x; r.x = t; }
    else if (cur.y < 0.0 || t < cur.y) { r.y = t; }
  }
  return r;
}

fn getVolumeHitValues(cv: f32, hs: vec2f, pv: f32, dv: f32, p: vec2f, d: vec2f, cur: vec2f) -> vec2f {
  var r = cur;
  if (abs(dv) > EPSILON) {
    let t = (cv - pv) / dv;
    if (t > 0.0) {
      let h = p + t * d;
      if (-hs.x < h.x && h.x < hs.x && -hs.y < h.y && h.y < hs.y) {
        r = compareVolumeHitValues(r, t);
      }
    }
  }
  return r;
}

fn rayVolumeIntersection(p: vec3f, d: vec3f) -> vec2f {
  var h = vec2f(-1.0, -1.0);
  let hs = volInfo.dims * volInfo.sizes * 0.5 / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
  h = getVolumeHitValues( hs.z, hs.xy, p.z, d.z, p.xy, d.xy, h);
  h = getVolumeHitValues(-hs.z, hs.xy, p.z, d.z, p.xy, d.xy, h);
  h = getVolumeHitValues(-hs.x, hs.yz, p.x, d.x, p.yz, d.yz, h);
  h = getVolumeHitValues( hs.x, hs.yz, p.x, d.x, p.yz, d.yz, h);
  h = getVolumeHitValues( hs.y, hs.xz, p.y, d.y, p.xz, d.xz, h);
  h = getVolumeHitValues(-hs.y, hs.xz, p.y, d.y, p.xz, d.xz, h);
  return h;
}

fn resolveHits(raw: vec2f) -> vec2f {
  var h = raw;
  if (h.y < 0.0 && h.x > 0.0) { h.y = h.x; h.x = 0.0; }
  return h;
}

// ── Volume sampling ───────────────────────────────────────────────────────────

fn sampleVolume(worldPos: vec3f) -> f32 {
  let nf  = max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
  let hs  = volInfo.dims.xyz * volInfo.sizes.xyz * 0.5 / nf;
  let uvw = (worldPos + hs) / (2.0 * hs);
  if (any(uvw < vec3f(0.0)) || any(uvw >= vec3f(1.0))) { return 0.0; }
  let vox = vec3i(uvw * volInfo.dims.xyz);
  let idx = vox.z * i32(volInfo.dims.x) * i32(volInfo.dims.y)
          + vox.y * i32(volInfo.dims.x)
          + vox.x;
  return volData[idx];
}

// Central-difference gradient magnitude (normalised to [0,1] for 12-bit data).
fn computeGradientMag(worldPos: vec3f) -> f32 {
  let nf  = max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
  let hs  = volInfo.dims.xyz * volInfo.sizes.xyz * 0.5 / nf;
  let vs  = 2.0 * hs / volInfo.dims.xyz; // one voxel in world-space
  let gx = sampleVolume(worldPos + vec3f(vs.x, 0.0, 0.0))
         - sampleVolume(worldPos - vec3f(vs.x, 0.0, 0.0));
  let gy = sampleVolume(worldPos + vec3f(0.0, vs.y, 0.0))
         - sampleVolume(worldPos - vec3f(0.0, vs.y, 0.0));
  let gz = sampleVolume(worldPos + vec3f(0.0, 0.0, vs.z))
         - sampleVolume(worldPos - vec3f(0.0, 0.0, vs.z));
  return length(vec3f(gx, gy, gz)) / (2.0 * 4095.0);
}

// ── Colour helper functions ───────────────────────────────────────────────────

// Blue → cyan → green → yellow → red heat-map.
fn falseColor(t: f32) -> vec3f {
  let c = clamp(t, 0.0, 1.0);
  var r: f32; var g: f32; var b: f32;
  if      (c < 0.25) { r = 0.0;                  g = c / 0.25;              b = 1.0;                  }
  else if (c < 0.50) { r = 0.0;                  g = 1.0;                   b = 1.0-(c-0.25)/0.25;    }
  else if (c < 0.75) { r = (c-0.50) / 0.25;      g = 1.0;                   b = 0.0;                  }
  else               { r = 1.0;                  g = 1.0-(c-0.75)/0.25;     b = 0.0;                  }
  return vec3f(r, g, b);
}

// Rainbow (violet → blue → cyan → green → yellow → red) for spectral TF.
fn rainbowColor(t: f32) -> vec3f {
  let c = clamp(t, 0.0, 1.0);
  // HSV with H mapped [240°→0°] (blue-to-red) as t goes 0→1
  let h = (1.0 - c) * 240.0 / 60.0; // hue sector 0-4
  let s = 1.0; let v = 1.0;
  let hi = i32(h) % 6;
  let f  = h - floor(h);
  let p  = v * (1.0 - s);
  let q  = v * (1.0 - s*f);
  let r2 = v * (1.0 - s*(1.0-f));
  switch (hi) {
    case 0:  { return vec3f(v,  r2, p ); }
    case 1:  { return vec3f(q,  v,  p ); }
    case 2:  { return vec3f(p,  v,  r2); }
    case 3:  { return vec3f(p,  q,  v ); }
    case 4:  { return vec3f(r2, p,  v ); }
    default: { return vec3f(v,  p,  q ); }
  }
}

// 5-stop piecewise linear colour + alpha for rich tissue visualisation.
fn piecewiseColor(t: f32) -> vec4f {
  let c = clamp(t, 0.0, 1.0);
  // stops: (colour, alpha) at t = 0, 0.25, 0.50, 0.75, 1.0
  let c0 = vec4f(0.08, 0.10, 0.35, 0.0 ); // dark blue,  transparent
  let c1 = vec4f(0.20, 0.50, 0.80, 0.15); // mid blue,   mostly transparent
  let c2 = vec4f(0.30, 0.80, 0.40, 0.35); // teal-green
  let c3 = vec4f(0.90, 0.80, 0.10, 0.60); // gold
  let c4 = vec4f(1.00, 0.20, 0.10, 1.00); // bright red, opaque
  if      (c < 0.25) { return mix(c0, c1, c / 0.25); }
  else if (c < 0.50) { return mix(c1, c2, (c-0.25)/0.25); }
  else if (c < 0.75) { return mix(c2, c3, (c-0.50)/0.25); }
  else               { return mix(c3, c4, (c-0.75)/0.25); }
}

// Warm (orange-red) → cool (blue) over density.
fn warmCoolColor(t: f32) -> vec3f {
  let c    = clamp(t, 0.0, 1.0);
  let cool = vec3f(0.30, 0.55, 0.90);
  let warm = vec3f(1.00, 0.35, 0.10);
  return mix(cool * 0.12, warm, c * c); // squared for contrast
}

// Emissive fire palette: black → deep red → orange → yellow → near-white.
fn fireColor(t: f32) -> vec4f {
  let c = clamp(t, 0.0, 1.0);
  var col: vec3f;
  if      (c < 0.33) { col = mix(vec3f(0.10,0.00,0.00), vec3f(0.70,0.12,0.00), c/0.33);        }
  else if (c < 0.66) { col = mix(vec3f(0.70,0.12,0.00), vec3f(1.00,0.65,0.00), (c-0.33)/0.33); }
  else               { col = mix(vec3f(1.00,0.65,0.00), vec3f(1.00,0.95,0.80), (c-0.66)/0.34); }
  return vec4f(col, c * 0.85);
}

// Terrain biome colour + Lambertian face shading (from scroll_12).
// hitFace: 0=x, 1=y (top/bottom), 2=z.  stepY: sign(d.y).
fn terrainColor(terrainType: i32, hitFace: i32, stepY: i32) -> vec3f {
  var base: vec3f;
  switch (terrainType) {
    case 1:  { base = vec3f(0.12, 0.39, 0.78); } // water  — blue
    case 2:  { base = vec3f(0.82, 0.77, 0.54); } // sand   — tan
    case 3:  { base = vec3f(0.33, 0.59, 0.27); } // grass  — green
    case 4:  { base = vec3f(0.47, 0.33, 0.22); } // dirt   — brown
    case 5:  { base = vec3f(0.51, 0.51, 0.49); } // stone  — grey
    case 6:  { base = vec3f(0.94, 0.94, 1.00); } // snow   — white-blue
    default: { base = vec3f(1.0,  0.0,  1.0 ); } // magenta (debug)
  }
  var shade: f32;
  if (hitFace == 1)      { shade = select(0.55, 1.0, stepY < 0); } // top face full sun
  else if (hitFace == 0) { shade = 0.75; }                          // east/west
  else                   { shade = 0.70; }                          // north/south
  return base * shade;
}

// ── DDA terrain traversal helper (shared by terrain + composed modes) ─────────

fn ddaTerrain(uv: vec2i, p: vec3f, d: vec3f, allowCloud: bool) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, SKY_COLOR); return; }

  let nf        = max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
  let hs        = volInfo.dims.xyz * volInfo.sizes.xyz * 0.5 / nf;
  let voxelSize = 2.0 * hs / volInfo.dims.xyz;

  let entryPt = p + (hits.x + 1e-5) * d;
  let uvw0    = (entryPt + hs) / (2.0 * hs);
  let voxelF  = clamp(uvw0 * volInfo.dims.xyz, vec3f(0.0), volInfo.dims.xyz - vec3f(1e-4));
  var voxel   = vec3i(floor(voxelF));

  let stepI   = vec3i(sign(d));
  let stepY   = i32(sign(d.y));

  var tDelta: vec3f;
  tDelta.x = select(1e30, voxelSize.x / abs(d.x), abs(d.x) > EPSILON);
  tDelta.y = select(1e30, voxelSize.y / abs(d.y), abs(d.y) > EPSILON);
  tDelta.z = select(1e30, voxelSize.z / abs(d.z), abs(d.z) > EPSILON);

  let nextBVF   = vec3f(
    select(floor(voxelF.x), floor(voxelF.x)+1.0, d.x > 0.0),
    select(floor(voxelF.y), floor(voxelF.y)+1.0, d.y > 0.0),
    select(floor(voxelF.z), floor(voxelF.z)+1.0, d.z > 0.0)
  );
  let nextBWorld = nextBVF / volInfo.dims.xyz * 2.0 * hs - hs;
  var tMax: vec3f;
  tMax.x = select(1e30, (nextBWorld.x - p.x) / d.x, abs(d.x) > EPSILON);
  tMax.y = select(1e30, (nextBWorld.y - p.y) / d.y, abs(d.y) > EPSILON);
  tMax.z = select(1e30, (nextBWorld.z - p.z) / d.z, abs(d.z) > EPSILON);

  var hitFace = 1;

  // Accumulated cloud colour (for composed mode only).
  var cloudAccCol   = vec3f(0.0);
  var cloudAccAlpha = 0.0;

  for (var iter = 0; iter < 400; iter++) {
    if (any(voxel < vec3i(0)) || any(voxel >= vec3i(volInfo.dims.xyz))) { break; }

    let idx = voxel.z * i32(volInfo.dims.x) * i32(volInfo.dims.y)
            + voxel.y * i32(volInfo.dims.x)
            + voxel.x;
    let val = volData[idx];

    if (val >= 0.5 && val <= 6.5) {
      // Solid terrain voxel
      let ttype = i32(round(val));
      var surfColor = terrainColor(ttype, hitFace, stepY);
      if (allowCloud) {
        // Composite cloud in front of the terrain surface.
        surfColor = cloudAccCol + (1.0 - cloudAccAlpha) * surfColor;
      }
      textureStore(outTexture, uv, vec4f(surfColor, 1.0));
      return;
    }

    if (allowCloud && val >= 99.5) {
      // Cloud voxel: val = 100 + density*100  →  density in [0,1]
      let density   = clamp((val - 100.0) / 100.0, 0.0, 1.0);
      let cCol      = mix(vec3f(0.80, 0.90, 1.00), vec3f(1.00, 1.00, 1.00), density);
      let cAlpha    = density * 0.30;
      cloudAccCol  += (1.0 - cloudAccAlpha) * cAlpha * cCol;
      cloudAccAlpha += (1.0 - cloudAccAlpha) * cAlpha;
    }

    // DDA step
    if (tMax.x < tMax.y && tMax.x < tMax.z) {
      if (tMax.x > hits.y) { break; }
      tMax.x += tDelta.x; voxel.x += stepI.x; hitFace = 0;
    } else if (tMax.y < tMax.z) {
      if (tMax.y > hits.y) { break; }
      tMax.y += tDelta.y; voxel.y += stepI.y; hitFace = 1;
    } else {
      if (tMax.z > hits.y) { break; }
      tMax.z += tDelta.z; voxel.z += stepI.z; hitFace = 2;
    }
  }

  // Sky (with possible cloud tint)
  var sky = SKY_COLOR.rgb;
  if (allowCloud) { sky = cloudAccCol + (1.0 - cloudAccAlpha) * sky; }
  textureStore(outTexture, uv, vec4f(sky, 1.0));
}

// ── Volume-rendering transfer function helpers ────────────────────────────────
//
// All alpha-compositing renderers share the same front-to-back loop template;
// they differ only in the transfer function applied at each sample.

// MIP — maximum intensity projection.
fn traceSceneMIP(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var maxVal = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    maxVal = max(maxVal, sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d));
  }
  let t = clamp(maxVal / 4095.0, 0.0, 1.0);
  let col = mix(vec3f(0.10, 0.25, 0.55) * 0.12, vec3f(0.95, 0.30, 0.40), t);
  textureStore(outTexture, uv, vec4f(col, 1.0));
}

// DRR — Beer-Lambert absorption (simulated X-ray).
fn traceSceneDRR(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var transmittance = 1.0;
  let dt    = (hits.y - hits.x) / f32(NUM_STEPS);
  let muMax = 0.04;
  for (var i = 0; i < NUM_STEPS; i++) {
    let val = sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0;
    transmittance *= exp(-val * muMax);
  }
  let intensity = 1.0 - transmittance;
  let col = mix(vec3f(0.10, 0.25, 0.55) * 0.12, vec3f(0.95, 0.30, 0.40), intensity);
  textureStore(outTexture, uv, vec4f(col, 1.0));
}

// Linear TF — grayscale alpha compositing with linear intensity mapping.
fn traceSceneLinearTF(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let t    = clamp(sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0, 0.0, 1.0);
    let col  = mix(vec3f(0.05, 0.05, 0.10), vec3f(1.00, 1.00, 1.00), t);
    let sa   = t * dt * 18.0;
    accCol  += (1.0 - accA) * sa * col;
    accA    += (1.0 - accA) * sa;
    if (accA >= 0.99) { break; }
  }
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*MISS_COLOR.rgb, 1.0));
}

// Piecewise linear TF — 5-stop colour transfer function.
fn traceScenePiecewise(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let intensity = clamp(sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0, 0.0, 1.0);
    let tfSample  = piecewiseColor(intensity);
    let sa        = tfSample.a * dt * 14.0;
    accCol       += (1.0 - accA) * sa * tfSample.rgb;
    accA         += (1.0 - accA) * sa;
    if (accA >= 0.99) { break; }
  }
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*MISS_COLOR.rgb, 1.0));
}

// Gradient TF — highlights tissue boundaries (edges).
fn traceSceneGradient(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let wp  = p + (hits.x + (f32(i)+0.5)*dt) * d;
    let val = sampleVolume(wp) / 4095.0;
    if (val > 0.04) {
      let gm   = clamp(computeGradientMag(wp) * 3.5, 0.0, 1.0);
      let col  = mix(vec3f(0.02, 0.05, 0.15), vec3f(1.00, 0.90, 0.20), gm);
      let sa   = gm * val * dt * 28.0;
      accCol  += (1.0 - accA) * sa * col;
      accA    += (1.0 - accA) * sa;
      if (accA >= 0.99) { break; }
    }
  }
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*MISS_COLOR.rgb, 1.0));
}

// Spectral TF — rainbow colour map (scientific visualisation).
fn traceSceneSpectral(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let t   = clamp(sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0, 0.0, 1.0);
    let col = rainbowColor(t);
    let sa  = t * dt * 18.0;
    accCol += (1.0 - accA) * sa * col;
    accA   += (1.0 - accA) * sa;
    if (accA >= 0.99) { break; }
  }
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*MISS_COLOR.rgb, 1.0));
}

// Warm-Cool TF — cinematic tissue shading.
fn traceSceneWarmCool(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let t   = clamp(sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0, 0.0, 1.0);
    let col = warmCoolColor(t);
    let sa  = t * dt * 18.0;
    accCol += (1.0 - accA) * sa * col;
    accA   += (1.0 - accA) * sa;
    if (accA >= 0.99) { break; }
  }
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*MISS_COLOR.rgb, 1.0));
}

// ── Terrain DDA ───────────────────────────────────────────────────────────────

fn traceSceneTerrain(uv: vec2i, p: vec3f, d: vec3f) {
  ddaTerrain(uv, p, d, false);
}

// ── Volumetric cloud ──────────────────────────────────────────────────────────

fn traceSceneCloud(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, SKY_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let val = sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0;
    if (val > 0.02) {
      let col = mix(vec3f(0.85, 0.92, 1.00), vec3f(1.00, 1.00, 1.00), val);
      let sa  = val * dt * 12.0;
      accCol += (1.0 - accA) * sa * col;
      accA   += (1.0 - accA) * sa;
      if (accA >= 0.99) { break; }
    }
  }
  let bg = SKY_COLOR.rgb;
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*bg, 1.0));
}

// ── Volumetric fire ───────────────────────────────────────────────────────────

fn traceSceneFire(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let val = sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0;
    if (val > 0.02) {
      let fc  = fireColor(val);
      let sa  = fc.a * dt * 16.0;
      accCol += (1.0 - accA) * sa * fc.rgb;
      accA   += (1.0 - accA) * sa;
      if (accA >= 0.99) { break; }
    }
  }
  let bg = vec3f(0.04, 0.01, 0.01); // very dark red background
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*bg, 1.0));
}

// ── Volumetric smoke ──────────────────────────────────────────────────────────

fn traceSceneSmoke(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, SKY_COLOR); return; }
  var accCol = vec3f(0.0); var accA = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let val = sampleVolume(p + (hits.x + (f32(i)+0.5)*dt) * d) / 4095.0;
    if (val > 0.02) {
      let col = mix(vec3f(0.20, 0.22, 0.25), vec3f(0.75, 0.78, 0.80), val);
      let sa  = val * dt * 14.0;
      accCol += (1.0 - accA) * sa * col;
      accA   += (1.0 - accA) * sa;
      if (accA >= 0.99) { break; }
    }
  }
  let bg = SKY_COLOR.rgb;
  textureStore(outTexture, uv, vec4f(accCol + (1.0-accA)*bg, 1.0));
}

// ── Composed scene — terrain DDA + volumetric cloud layer ─────────────────────

fn traceSceneComposed(uv: vec2i, p: vec3f, d: vec3f) {
  ddaTerrain(uv, p, d, true);
}

// ── Ray generators ────────────────────────────────────────────────────────────

fn orthogonalRay(uv: vec2i) -> array<vec3f, 2> {
  let ps  = vec2f(2.0, 2.0) / cameraPose.res.xy;
  var spt = vec3f((f32(uv.x)+0.5)*ps.x - 1.0, (f32(uv.y)+0.5)*ps.y - 1.0, 0.0);
  var rd  = vec3f(0.0, 0.0, 1.0);
  spt = transformPt(spt);  rd = transformDir(rd);
  return array<vec3f, 2>(spt, rd);
}

fn projectiveRay(uv: vec2i) -> array<vec3f, 2> {
  let ps  = vec2f(2.0, 2.0) / (cameraPose.res.xy * cameraPose.focal);
  var spt = vec3f(0.0, 0.0, 0.0);
  var rd  = normalize(vec3f(
    (f32(uv.x)+0.5)*ps.x - 1.0/cameraPose.focal.x,
    (f32(uv.y)+0.5)*ps.y - 1.0/cameraPose.focal.y,
    1.0));
  spt = transformPt(spt);  rd = transformDir(rd);
  return array<vec3f, 2>(spt, rd);
}

// ── Compute entry points ──────────────────────────────────────────────────────
// Naming: compute{Camera}{Mode}Main

@compute @workgroup_size(16,16) fn computeOrthogonalMIPMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneMIP(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveMIPMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneMIP(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalDRRMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneDRR(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveDRRMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneDRR(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalLinearTFMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneLinearTF(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveLinearTFMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneLinearTF(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalPiecewiseMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceScenePiecewise(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectivePiecewiseMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceScenePiecewise(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalGradientMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneGradient(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveGradientMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneGradient(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalSpectralMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneSpectral(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveSpectralMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneSpectral(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalWarmCoolMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneWarmCool(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveWarmCoolMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneWarmCool(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalTerrainMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneTerrain(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveTerrainMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneTerrain(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalCloudMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneCloud(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveCloudMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneCloud(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalFireMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneFire(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveFireMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneFire(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalSmokeMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneSmoke(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveSmokeMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneSmoke(uv, r[0], r[1]); }
}

@compute @workgroup_size(16,16) fn computeOrthogonalComposedMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = orthogonalRay(uv); traceSceneComposed(uv, r[0], r[1]); }
}
@compute @workgroup_size(16,16) fn computeProjectiveComposedMain(@builtin(global_invocation_id) gid: vec3u) {
  let uv = vec2i(gid.xy); let dim = vec2i(textureDimensions(outTexture));
  if (uv.x < dim.x && uv.y < dim.y) { let r = projectiveRay(uv); traceSceneComposed(uv, r[0], r[1]); }
}
