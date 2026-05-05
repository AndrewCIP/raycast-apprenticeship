/*
 * Copyright (c) 2026 Sing Chun LEE @ Bucknell University. CC BY-NC 4.0.
 *
 * This code is provided mainly for educational purposes at University of the Pacific.
 *
 * This code is licensed under the Creative Commons Attribution-NonCommercial 4.0
 * International License. To view a copy of the license, visit
 *   https://creativecommons.org/licenses/by-nc/4.0/
 *
 * Scroll 11 — Volume Rendering Worksheet
 *
 * This shader implements three volume-rendering modes via ray marching:
 *   1. Maximum Intensity Projection (MIP)
 *   2. Digitally Reconstructed Radiograph (DRR) — Beer–Lambert absorption
 *   3. Depth-based false-color encoding
 *
 * For each mode, both orthogonal and projective (pinhole) cameras are provided,
 * giving six compute entry points in total.
 */

// ── 3-D Projective Geometric Algebra (PGA) ─────────────────────────────────

struct MultiVector {
  s: f32,
  exey: f32,
  exez: f32,
  eyez: f32,
  eoex: f32,
  eoey: f32,
  eoez: f32,
  exeyez: f32,
  eoexey: f32,
  eoexez: f32,
  eoeyez: f32,
  ex: f32,
  ey: f32,
  ez: f32,
  eo: f32,
  eoexeyez: f32
}

fn geometricProduct(a: MultiVector, b: MultiVector) -> MultiVector {
  var r: MultiVector;
  r.s        = a.s * b.s - a.exey * b.exey - a.exez * b.exez - a.eyez * b.eyez - a.exeyez * b.exeyez + a.ex * b.ex + a.ey * b.ey + a.ez * b.ez;
  r.exey     = a.s * b.exey + a.exey * b.s - a.exez * b.eyez + a.eyez * b.exez + a.exeyez * b.ez + a.ex * b.ey - a.ey * b.ex + a.ez * b.exeyez;
  r.exez     = a.s * b.exez + a.exey * b.eyez + a.exez * b.s - a.eyez * b.exey - a.exeyez * b.ey + a.ex * b.ez - a.ey * b.exeyez - a.ez * b.ex;
  r.eyez     = a.s * b.eyez - a.exey * b.exez + a.exez * b.exey + a.eyez * b.s + a.exeyez * b.ex + a.ex * b.exeyez + a.ey * b.ez - a.ez * b.ey;
  r.eoex     = a.s * b.eoex + a.exey * b.eoey + a.exez * b.eoez - a.eyez * b.eoexeyez + a.eoex * b.s - a.eoey * b.exey - a.eoez * b.exez + a.exeyez * b.eoeyez + a.eoexey * b.ey + a.eoexez * b.ez - a.eoeyez * b.exeyez - a.ex * b.eo + a.ey * b.eoexey + a.ez * b.eoexez + a.eo * b.ex - a.eoexeyez * b.eyez;
  r.eoey     = a.s * b.eoey - a.exey * b.eoex + a.exez * b.eoexeyez + a.eyez * b.eoez + a.eoex * b.exey + a.eoey * b.s - a.eoez * b.eyez - a.exeyez * b.eoexez - a.eoexey * b.ex + a.eoexez * b.exeyez + a.eoeyez * b.ey - a.ex * b.eoexey - a.ey * b.eo + a.ez * b.eoeyez + a.eo * b.ey + a.eoexeyez * b.exez;
  r.eoez     = a.s * b.eoez - a.exey * b.eoexeyez - a.exez * b.eoex - a.eyez * b.eoey + a.eoex * b.exez + a.eoey * b.eyez + a.eoez * b.s + a.exeyez * b.eoexey - a.eoexey * b.exeyez - a.eoexez * b.ex - a.eoeyez * b.ey - a.ex * b.eoexez - a.ey * b.eoeyez - a.ez * b.eo + a.eo * b.ez - a.eoexeyez * b.exey;
  r.exeyez   = a.s * b.exeyez + a.exey * b.ez - a.exez * b.ey + a.eyez * b.ex + a.exeyez * b.s + a.ex * b.eyez - a.ey * b.exez + a.ez * b.exey;
  r.eoexey   = a.s * b.eoexey + a.exey * b.eo - a.exez * b.eoeyez + a.eyez * b.eoexez + a.eoex * b.ey - a.eoey * b.ex + a.eoez * b.exeyez - a.exeyez * b.eoez + a.eoexey * b.s - a.eoexez * b.eyez + a.eoeyez * b.exez - a.ex * b.eoey + a.ey * b.eoex - a.ez * b.eoexeyez + a.eo * b.exey + a.eoexeyez * b.ez;
  r.eoexez   = a.s * b.eoexez + a.exey * b.eoeyez + a.exez * b.eo - a.eyez * b.eoexey + a.eoex * b.ez - a.eoey * b.exeyez - a.eoez * b.ex + a.exeyez * b.eoey + a.eoexey * b.eyez + a.eoexez * b.s - a.eoeyez * b.exey - a.ex * b.eoez + a.ey * b.eoexeyez + a.ez * b.eoex + a.eo * b.exez - a.eoexeyez * b.ey;
  r.eoeyez   = a.s * b.eoeyez - a.exey * b.eoexez + a.exez * b.eoexey + a.eyez * b.eo + a.eoex * b.exeyez + a.eoey * b.ez - a.eoez * b.ey - a.exeyez * b.eoex - a.eoexey * b.exez + a.eoexez * b.exey + a.eoeyez * b.s - a.ex * b.eoexeyez - a.ey * b.eoez + a.ez * b.eoey + a.eo * b.eyez + a.eoexeyez * b.ex;
  r.ex       = a.s * b.ex + a.exey * b.ey + a.exez * b.ez - a.eyez * b.exeyez - a.exeyez * b.eyez + a.ex * b.s - a.ey * b.exey - a.ez * b.exez;
  r.ey       = a.s * b.ey - a.exey * b.ex + a.exez * b.exeyez + a.eyez * b.ez + a.exeyez * b.exez + a.ex * b.exey + a.ey * b.s - a.ez * b.eyez;
  r.ez       = a.s * b.ez - a.exey * b.exeyez - a.exez * b.ex - a.eyez * b.ey - a.exeyez * b.exey + a.ex * b.exez + a.ey * b.eyez + a.ez * b.s;
  r.eo       = a.s * b.eo - a.exey * b.eoexey - a.exez * b.eoexez - a.eyez * b.eoeyez + a.eoex * b.ex + a.eoey * b.ey + a.eoez * b.ez + a.exeyez * b.eoexeyez - a.eoexey * b.exey - a.eoexez * b.exez - a.eoeyez * b.eyez - a.ex * b.eoex - a.ey * b.eoey - a.ez * b.eoez + a.eo * b.s - a.eoexeyez * b.exeyez;
  r.eoexeyez = a.s * b.eoexeyez + a.exey * b.eoez - a.exez * b.eoey + a.eyez * b.eoex + a.eoex * b.eyez - a.eoey * b.exez + a.eoez * b.exey - a.exeyez * b.eo + a.eoexey * b.ez - a.eoexez * b.ey + a.eoeyez * b.ex - a.ex * b.eoeyez + a.ey * b.eoexez - a.ez * b.eoexey + a.eo * b.exeyez + a.eoexeyez * b.s;
  return r;
}

fn reverse(a: MultiVector) -> MultiVector {
  return MultiVector(a.s, -a.exey, -a.exez, -a.eyez, -a.eoex, -a.eoey, -a.eoez, -a.exeyez, -a.eoexey, -a.eoexez, -a.eoeyez, a.ex, a.ey, a.ez, a.eo, a.eoexeyez);
}

fn applyMotor(p: MultiVector, m: MultiVector) -> MultiVector {
  return geometricProduct(m, geometricProduct(p, reverse(m)));
}

fn motorNorm(m: MultiVector) -> f32 {
  var sum = 0.0;
  sum += m.s * m.s; sum += m.exey * m.exey; sum += m.exez * m.exez; sum += m.eyez * m.eyez;
  sum += m.eoex * m.eoex; sum += m.eoey * m.eoey; sum += m.eoez * m.eoez; sum += m.exeyez * m.exeyez;
  sum += m.eoexey * m.eoexey; sum += m.eoexez * m.eoexez; sum += m.eoeyez * m.eoeyez;
  sum += m.ex * m.ex; sum += m.ey * m.ey; sum += m.ez * m.ez; sum += m.eo * m.eo; sum += m.eoexeyez * m.eoexeyez;
  return sqrt(sum);
}

fn createDir(d: vec3f) -> MultiVector {
  return MultiVector(0, d.z, -d.y, d.x, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn createLine(s: vec3f, d: vec3f) -> MultiVector {
  let n   = createDir(d);
  let dir = normalizeMotor(n);
  return MultiVector(0, dir.exey, dir.exez, dir.eyez, -(-dir.exez * s.z - dir.exey * s.y), -(dir.exey * s.x - dir.eyez * s.z), -(dir.eyez * s.y + dir.exez * s.x), 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn normalizeMotor(m: MultiVector) -> MultiVector {
  let mnorm = motorNorm(m);
  if (mnorm == 0.0) { return MultiVector(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); }
  return MultiVector(m.s / mnorm, m.exey / mnorm, m.exez / mnorm, m.eyez / mnorm, m.eoex / mnorm, m.eoey / mnorm, m.eoez / mnorm, m.exeyez / mnorm, m.eoexey / mnorm, m.eoexez / mnorm, m.eoeyez / mnorm, m.ex / mnorm, m.ey / mnorm, m.ez / mnorm, m.eo / mnorm, m.eoexeyez / mnorm);
}

fn createPoint(p: vec3f) -> MultiVector {
  return MultiVector(0, 0, 0, 0, 0, 0, 0, 1, -p.z, p.y, -p.x, 0, 0, 0, 0, 0);
}

fn extractPoint(p: MultiVector) -> vec3f {
  return vec3f(-p.eoeyez / p.exeyez, p.eoexez / p.exeyez, -p.eoexey / p.exeyez);
}

fn extractRotor(m: MultiVector) -> MultiVector {
  return MultiVector(m.s, m.exey, m.exez, m.eyez, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn applyMotorToPoint(p: vec3f, m: MultiVector) -> vec3f {
  return extractPoint(applyMotor(createPoint(p), m));
}

fn applyMotorToDir(d: vec3f, m: MultiVector) -> vec3f {
  let r    = extractRotor(m);
  let new_d = applyMotor(createPoint(d), r);
  return extractPoint(new_d);
}

// ── GPU struct / binding declarations ───────────────────────────────────────

struct Camera {
  motor: MultiVector,
  focal: vec2f,
  res:   vec2f,
}

struct VolInfo {
  dims:  vec4f,  // volume dimensions (X, Y, Z, padding)
  sizes: vec4f,  // voxel sizes       (sx, sy, sz, padding)
}

@group(0) @binding(0) var<uniform>  cameraPose: Camera;
@group(0) @binding(1) var<uniform>  volInfo:    VolInfo;
@group(0) @binding(2) var<storage>  volData:    array<f32>;
@group(0) @binding(3) var           outTexture: texture_storage_2d<rgba8unorm, write>;

// ── Camera helpers ───────────────────────────────────────────────────────────

fn transformPt(pt: vec3f) -> vec3f {
  return applyMotorToPoint(pt, cameraPose.motor);
}

fn transformDir(d: vec3f) -> vec3f {
  return applyMotorToDir(d, cameraPose.motor);
}

// ── Volume helpers ───────────────────────────────────────────────────────────

const EPSILON: f32 = 0.00000001;

// Fetch the raw voxel value (0–4095 for the brain dataset) at a world-space
// position.  Returns 0 if the position lies outside the volume.
fn sampleVolume(worldPos: vec3f) -> f32 {
  let normFactor = max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
  let halfsize   = volInfo.dims.xyz * volInfo.sizes.xyz * 0.5 / normFactor;

  // Normalize position to [0, 1] within the volume bounding box
  let uvw = (worldPos + halfsize) / (2.0 * halfsize);
  if (any(uvw < vec3f(0.0)) || any(uvw >= vec3f(1.0))) { return 0.0; }

  let voxel = vec3i(uvw * volInfo.dims.xyz);
  // Linearized index: z*(X*Y) + y*X + x
  let idx = voxel.z * i32(volInfo.dims.x) * i32(volInfo.dims.y)
          + voxel.y * i32(volInfo.dims.x)
          + voxel.x;
  return volData[idx];
}

// ── Ray–volume AABB intersection (same logic as tracevolume.wgsl) ───────────

fn compareVolumeHitValues(curValue: vec2f, t: f32) -> vec2f {
  var result = curValue;
  if (curValue.x < 0) {
    result.x = t;
  } else {
    if (t < curValue.x) { result.y = curValue.x; result.x = t; }
    else if (curValue.y < 0 || t < curValue.y) { result.y = t; }
  }
  return result;
}

fn getVolumeHitValues(checkval: f32, halfsize: vec2f, pval: f32, dval: f32, p: vec2f, d: vec2f, curT: vec2f) -> vec2f {
  var cur = curT;
  if (abs(dval) > EPSILON) {
    let t  = (checkval - pval) / dval;
    if (t > 0) {
      let hPt = p + t * d;
      if (-halfsize.x < hPt.x && hPt.x < halfsize.x && -halfsize.y < hPt.y && hPt.y < halfsize.y) {
        cur = compareVolumeHitValues(cur, t);
      }
    }
  }
  return cur;
}

fn rayVolumeIntersection(p: vec3f, d: vec3f) -> vec2f {
  var hitValues = vec2f(-1, -1);
  let halfsize  = volInfo.dims * volInfo.sizes * 0.5 / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
  hitValues = getVolumeHitValues( halfsize.z, halfsize.xy, p.z, d.z, p.xy, d.xy, hitValues);
  hitValues = getVolumeHitValues(-halfsize.z, halfsize.xy, p.z, d.z, p.xy, d.xy, hitValues);
  hitValues = getVolumeHitValues(-halfsize.x, halfsize.yz, p.x, d.x, p.yz, d.yz, hitValues);
  hitValues = getVolumeHitValues( halfsize.x, halfsize.yz, p.x, d.x, p.yz, d.yz, hitValues);
  hitValues = getVolumeHitValues( halfsize.y, halfsize.xz, p.y, d.y, p.xz, d.xz, hitValues);
  hitValues = getVolumeHitValues(-halfsize.y, halfsize.xz, p.y, d.y, p.xz, d.xz, hitValues);
  return hitValues;
}

// Background color (Bucknell Blue) used when the ray misses the volume
const MISS_COLOR: vec4f = vec4f(0.0 / 255.0, 56.0 / 255.0, 101.0 / 255.0, 1.0);

// Number of ray-march steps
const NUM_STEPS: i32 = 300;

// Helper: resolve entry/exit t-values, handling the camera-inside-volume case.
// Returns a valid (tEntry, tExit) pair, or a pair with tEntry < 0 on a miss.
fn resolveHits(rawHits: vec2f) -> vec2f {
  var hits = rawHits;
  if (hits.y < 0.0 && hits.x > 0.0) {
    // Camera is inside the volume: march from camera position to the exit.
    hits.y = hits.x;
    hits.x = 0.0;
  }
  return hits;
}

// ── False-color heat map (blue → cyan → green → yellow → red) ──────────────

fn falseColor(t: f32) -> vec3f {
  let c = clamp(t, 0.0, 1.0);
  var r: f32; var g: f32; var b: f32;
  if (c < 0.25) {
    // blue → cyan
    r = 0.0; g = c / 0.25; b = 1.0;
  } else if (c < 0.5) {
    // cyan → green
    r = 0.0; g = 1.0; b = 1.0 - (c - 0.25) / 0.25;
  } else if (c < 0.75) {
    // green → yellow
    r = (c - 0.5) / 0.25; g = 1.0; b = 0.0;
  } else {
    // yellow → red
    r = 1.0; g = 1.0 - (c - 0.75) / 0.25; b = 0.0;
  }
  return vec3f(r, g, b);
}

// ── Color transfer function ───────────────────────────────────────────────────
//
// Maps a normalised intensity [0, 1] to a pinkish-red hue for dense tissue,
// blending toward a dim light-blue for sparse regions to simulate cool ambient
// lighting.  Used by both the MIP and DRR renderers.

fn volumeColor(intensity: f32) -> vec3f {
  let t         = clamp(intensity, 0.0, 1.0);
  let coolColor = vec3f(0.45, 0.70, 1.00); // light blue  — ambient / shadow
  let warmColor = vec3f(1.00, 0.25, 0.38); // pinkish-red — dense tissue
  return mix(coolColor * 0.12, warmColor, t);
}

// ── Part 2: Maximum Intensity Projection (MIP) ──────────────────────────────
//
// Walk along the ray and record the highest voxel value encountered.  Map
// that maximum to a pinkish-red intensity using the volumeColor transfer
// function (light-blue ambient → pinkish-red for peak density).  The brain
// dataset stores values in a 12-bit range (0–4095), so we normalise by 4095.

fn traceSceneMIP(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }

  var maxVal: f32 = 0.0;
  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  for (var i = 0; i < NUM_STEPS; i++) {
    let t       = hits.x + (f32(i) + 0.5) * dt;
    let worldPt = p + t * d;
    maxVal = max(maxVal, sampleVolume(worldPt));
  }

  let intensity = maxVal / 4095.0;
  textureStore(outTexture, uv, vec4f(volumeColor(intensity), 1.0));
}

// ── Part 3: Digitally Reconstructed Radiograph (DRR) ───────────────────────
//
// Simulate X-ray absorption using the Beer–Lambert law:
//
//   T = exp( -∫ μ(x) dx )
//
// where μ(x) = (voxelValue / 4095) × μ_max is the local attenuation.
// The final pixel intensity is the absorbed fraction: 1 − T.
// Dense tissue (bone) absorbs heavily → appears bright.

fn traceSceneDRR(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }

  var transmittance: f32 = 1.0;
  let dt: f32 = (hits.y - hits.x) / f32(NUM_STEPS);
  // Per-step absorption constant.  A value of 0.04 gives good contrast for
  // the brain dataset without over-saturating soft tissue.
  let muMax: f32 = 0.04;

  for (var i = 0; i < NUM_STEPS; i++) {
    let t       = hits.x + (f32(i) + 0.5) * dt;
    let worldPt = p + t * d;
    let val     = sampleVolume(worldPt) / 4095.0; // normalised [0, 1]
    transmittance *= exp(-val * muMax);
  }

  let intensity = 1.0 - transmittance;
  textureStore(outTexture, uv, vec4f(volumeColor(intensity), 1.0));
}

// ── Part 4: Depth-based false-color encoding ─────────────────────────────────
//
// March the ray until the voxel value exceeds a tissue threshold (first-hit
// surface detection).  Map the normalised hit depth to a heat-map color
// (blue = near, red = far).  Pixels where no surface is found show the
// background color.

fn traceSceneDepth(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }

  // Threshold for "inside tissue" — calibrated for the T1 brain dataset.
  let threshold: f32 = 200.0;

  let dt = (hits.y - hits.x) / f32(NUM_STEPS);
  var depthT: f32 = -1.0;

  for (var i = 0; i < NUM_STEPS; i++) {
    let t       = hits.x + (f32(i) + 0.5) * dt;
    let worldPt = p + t * d;
    if (sampleVolume(worldPt) > threshold) {
      depthT = t;
      break;
    }
  }

  if (depthT < 0.0) { textureStore(outTexture, uv, MISS_COLOR); return; }

  // Normalise depth to [0, 1] relative to the ray's volume segment
  let normDepth = (depthT - hits.x) / max(hits.y - hits.x, EPSILON);
  textureStore(outTexture, uv, vec4f(falseColor(normDepth), 1.0));
}

// ── Shared ray-generation helpers ────────────────────────────────────────────

// Orthographic: parallel rays, one per pixel, starting on the image plane.
fn orthogonalRay(uv: vec2i) -> array<vec3f, 2> {
  let psize = vec2f(2.0, 2.0) / cameraPose.res.xy;
  var spt   = vec3f((f32(uv.x) + 0.5) * psize.x - 1.0,
                    (f32(uv.y) + 0.5) * psize.y - 1.0, 0.0);
  var rdir  = vec3f(0.0, 0.0, 1.0);
  spt  = transformPt(spt);
  rdir = transformDir(rdir);
  return array<vec3f, 2>(spt, rdir);
}

// Projective (pinhole): rays fan out from the camera origin through each pixel.
fn projectiveRay(uv: vec2i) -> array<vec3f, 2> {
  let psize = vec2f(2.0, 2.0) / (cameraPose.res.xy * cameraPose.focal);
  var spt   = vec3f(0.0, 0.0, 0.0);
  var rdir  = normalize(vec3f(
    (f32(uv.x) + 0.5) * psize.x - 1.0 / cameraPose.focal.x,
    (f32(uv.y) + 0.5) * psize.y - 1.0 / cameraPose.focal.y,
    1.0
  ));
  spt  = transformPt(spt);
  rdir = transformDir(rdir);
  return array<vec3f, 2>(spt, rdir);
}

// ── Compute entry points ─────────────────────────────────────────────────────
//   Naming scheme: compute{Camera}{Mode}Main
//     Camera: Orthogonal | Projective
//     Mode  : MIP | DRR | Depth

@compute @workgroup_size(16, 16)
fn computeOrthogonalMIPMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = orthogonalRay(uv);
    traceSceneMIP(uv, ray[0], ray[1]);
  }
}

@compute @workgroup_size(16, 16)
fn computeProjectiveMIPMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = projectiveRay(uv);
    traceSceneMIP(uv, ray[0], ray[1]);
  }
}

@compute @workgroup_size(16, 16)
fn computeOrthogonalDRRMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = orthogonalRay(uv);
    traceSceneDRR(uv, ray[0], ray[1]);
  }
}

@compute @workgroup_size(16, 16)
fn computeProjectiveDRRMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = projectiveRay(uv);
    traceSceneDRR(uv, ray[0], ray[1]);
  }
}

@compute @workgroup_size(16, 16)
fn computeOrthogonalDepthMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = orthogonalRay(uv);
    traceSceneDepth(uv, ray[0], ray[1]);
  }
}

@compute @workgroup_size(16, 16)
fn computeProjectiveDepthMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = projectiveRay(uv);
    traceSceneDepth(uv, ray[0], ray[1]);
  }
}
