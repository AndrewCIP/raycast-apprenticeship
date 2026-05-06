/*
 * Scroll 12 — Perlin Noise Terrain Renderer (WebGPU / WGSL)
 *
 * Renders a procedurally generated Minecraft-like terrain volume built from
 * Perlin noise (2-D heightmap + 3-D cave carving) on the CPU side.
 *
 * Voxel types stored in volData:
 *   0 = air  (transparent — ray continues)
 *   1 = water
 *   2 = sand / beach
 *   3 = grass
 *   4 = dirt
 *   5 = stone
 *   6 = snow
 *
 * Traversal: DDA (Digital Differential Analyzer) — exact voxel stepping,
 * one voxel at a time, no over-sampling or under-sampling.
 *
 * Shading: Lambertian approximation using the hit face normal.
 *   top face    (y+) → full brightness (sun from above)
 *   east/west   (x)  → 0.75 ×
 *   north/south (z)  → 0.70 ×
 *   bottom face (y−) → 0.55 ×
 */

// ── 3-D Projective Geometric Algebra (PGA) ─────────────────────────────────
// (Identical to scroll_11_vol.wgsl — kept verbatim for self-contained shader)

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
  let r     = extractRotor(m);
  let new_d = applyMotor(createPoint(d), r);
  return extractPoint(new_d);
}

// ── GPU struct / binding declarations ────────────────────────────────────────

struct Camera {
  motor: MultiVector,
  focal: vec2f,
  res:   vec2f,
}

struct VolInfo {
  dims:  vec4f, // volume dimensions (W, H, D, padding)
  sizes: vec4f, // voxel sizes       (sx, sy, sz, padding)
}

@group(0) @binding(0) var<uniform>  cameraPose: Camera;
@group(0) @binding(1) var<uniform>  volInfo:    VolInfo;
@group(0) @binding(2) var<storage>  volData:    array<f32>;
@group(0) @binding(3) var           outTexture: texture_storage_2d<rgba8unorm, write>;

// ── Camera helpers ────────────────────────────────────────────────────────────

fn transformPt(pt: vec3f) -> vec3f {
  return applyMotorToPoint(pt, cameraPose.motor);
}

fn transformDir(d: vec3f) -> vec3f {
  return applyMotorToDir(d, cameraPose.motor);
}

// ── Volume helpers ────────────────────────────────────────────────────────────

const EPSILON: f32 = 0.00000001;

// ── Ray–volume AABB intersection ─────────────────────────────────────────────
// (Same as scroll_11_vol.wgsl)

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

// Resolve entry/exit t-values; handles camera-inside-volume.
fn resolveHits(rawHits: vec2f) -> vec2f {
  var hits = rawHits;
  if (hits.y < 0.0 && hits.x > 0.0) {
    hits.y = hits.x;
    hits.x = 0.0;
  }
  return hits;
}

// ── Sky / background color (daytime sky blue) ────────────────────────────────

const SKY_COLOR: vec4f = vec4f(0.52, 0.73, 0.90, 1.0);

// ── Terrain color transfer function ─────────────────────────────────────────
//
// Maps an integer voxel terrain type to a base RGB color, then applies
// Lambertian face shading so that the top face is brightest.
//
// hitFace: 0 = x-face (east/west), 1 = y-face (top/bottom), 2 = z-face (north/south)
// stepY  : sign of d.y  (+1 = ray going up, −1 = ray going down / hitting top face)

fn terrainColor(terrainType: i32, hitFace: i32, stepY: i32) -> vec3f {
  // Base color per terrain type
  var base: vec3f;
  switch (terrainType) {
    case 1:  { base = vec3f(0.12, 0.39, 0.78); } // water  — medium blue
    case 2:  { base = vec3f(0.82, 0.77, 0.54); } // sand   — sandy yellow
    case 3:  { base = vec3f(0.33, 0.59, 0.27); } // grass  — green
    case 4:  { base = vec3f(0.47, 0.33, 0.22); } // dirt   — brown
    case 5:  { base = vec3f(0.51, 0.51, 0.49); } // stone  — mid grey
    case 6:  { base = vec3f(0.94, 0.94, 1.00); } // snow   — near-white blue
    default: { base = vec3f(1.0,  0.0,  1.0 ); } // magenta — should never appear
  }

  // Lambertian face shading
  var shade: f32;
  if (hitFace == 1) {
    // y-face: top face (ray coming from above, stepY < 0) = full sun
    shade = select(0.55, 1.0, stepY < 0);
  } else if (hitFace == 0) {
    shade = 0.75; // east/west side
  } else {
    shade = 0.70; // north/south side
  }

  return base * shade;
}

// ── DDA terrain traversal ────────────────────────────────────────────────────
//
// Marches the ray through the voxel grid one cell at a time using the DDA
// algorithm.  Stops immediately when a non-air voxel is found (Minecraft-style
// surface rendering — no blending).

fn traceSceneTerrain(uv: vec2i, p: vec3f, d: vec3f) {
  let hits = resolveHits(rayVolumeIntersection(p, d));
  if (hits.x < 0.0) { textureStore(outTexture, uv, SKY_COLOR); return; }

  // Volume dimensions in world space
  let normFactor = max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
  let halfsize   = volInfo.dims.xyz * volInfo.sizes.xyz * 0.5 / normFactor;
  let voxelSize  = 2.0 * halfsize / volInfo.dims.xyz; // world-space extent per voxel

  // Entry point (nudged slightly inside to avoid landing exactly on a boundary)
  let entryT  = hits.x + 1e-5;
  let entryPt = p + entryT * d;

  // Fractional voxel coordinates at the entry point
  let uvw0   = (entryPt + halfsize) / (2.0 * halfsize);
  let voxelF = clamp(uvw0 * volInfo.dims.xyz, vec3f(0.0), volInfo.dims.xyz - vec3f(1e-4));

  // Initial integer voxel
  var voxel = vec3i(floor(voxelF));

  // DDA step direction per axis (−1 or +1)
  let stepI = vec3i(sign(d));
  let stepY = i32(sign(d.y)); // used for face-shading lookup

  // tDelta: how far along the ray between consecutive crossings on each axis
  var tDelta: vec3f;
  tDelta.x = select(1e30, voxelSize.x / abs(d.x), abs(d.x) > EPSILON);
  tDelta.y = select(1e30, voxelSize.y / abs(d.y), abs(d.y) > EPSILON);
  tDelta.z = select(1e30, voxelSize.z / abs(d.z), abs(d.z) > EPSILON);

  // Next voxel boundary in ray direction for each axis
  let nextBVF = vec3f(
    select(floor(voxelF.x),       floor(voxelF.x) + 1.0, d.x > 0.0),
    select(floor(voxelF.y),       floor(voxelF.y) + 1.0, d.y > 0.0),
    select(floor(voxelF.z),       floor(voxelF.z) + 1.0, d.z > 0.0)
  );
  // Convert boundary voxel indices to world-space coordinates
  let nextBWorld = nextBVF / volInfo.dims.xyz * 2.0 * halfsize - halfsize;
  // Absolute t-value (from ray origin p) for the first crossing on each axis
  var tMax: vec3f;
  tMax.x = select(1e30, (nextBWorld.x - p.x) / d.x, abs(d.x) > EPSILON);
  tMax.y = select(1e30, (nextBWorld.y - p.y) / d.y, abs(d.y) > EPSILON);
  tMax.z = select(1e30, (nextBWorld.z - p.z) / d.z, abs(d.z) > EPSILON);

  // hitFace tracks which axis face the ray last crossed (used for shading).
  // Initialise to 1 (y-face / top) as the camera is typically above the terrain.
  var hitFace = 1;

  for (var iter = 0; iter < 400; iter++) {
    // ── Bounds check ─────────────────────────────────────────────────────
    if (any(voxel < vec3i(0)) || any(voxel >= vec3i(volInfo.dims.xyz))) { break; }

    // ── Sample voxel ─────────────────────────────────────────────────────
    let idx = voxel.z * i32(volInfo.dims.x) * i32(volInfo.dims.y)
            + voxel.y * i32(volInfo.dims.x)
            + voxel.x;
    let terrainType = i32(round(volData[idx]));

    if (terrainType > 0) {
      let color = terrainColor(terrainType, hitFace, stepY);
      textureStore(outTexture, uv, vec4f(color, 1.0));
      return;
    }

    // ── DDA step: advance to the nearest next voxel boundary ─────────────
    if (tMax.x < tMax.y && tMax.x < tMax.z) {
      if (tMax.x > hits.y) { break; }
      tMax.x += tDelta.x;
      voxel.x += stepI.x;
      hitFace  = 0;
    } else if (tMax.y < tMax.z) {
      if (tMax.y > hits.y) { break; }
      tMax.y += tDelta.y;
      voxel.y += stepI.y;
      hitFace  = 1;
    } else {
      if (tMax.z > hits.y) { break; }
      tMax.z += tDelta.z;
      voxel.z += stepI.z;
      hitFace  = 2;
    }
  }

  // Ray exited the volume without hitting terrain — show the sky
  textureStore(outTexture, uv, SKY_COLOR);
}

// ── Shared ray-generation helpers (identical to scroll_11_vol.wgsl) ──────────

fn orthogonalRay(uv: vec2i) -> array<vec3f, 2> {
  let psize = vec2f(2.0, 2.0) / cameraPose.res.xy;
  var spt   = vec3f((f32(uv.x) + 0.5) * psize.x - 1.0,
                    (f32(uv.y) + 0.5) * psize.y - 1.0, 0.0);
  var rdir  = vec3f(0.0, 0.0, 1.0);
  spt  = transformPt(spt);
  rdir = transformDir(rdir);
  return array<vec3f, 2>(spt, rdir);
}

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

@compute @workgroup_size(16, 16)
fn computeOrthogonalTerrainMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = orthogonalRay(uv);
    traceSceneTerrain(uv, ray[0], ray[1]);
  }
}

@compute @workgroup_size(16, 16)
fn computeProjectiveTerrainMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let ray = projectiveRay(uv);
    traceSceneTerrain(uv, ray[0], ray[1]);
  }
}
