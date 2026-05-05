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

// ─── 3-D PGA multivector ────────────────────────────────────────────────────
struct MultiVector {
  s: f32,
  exey: f32, exez: f32, eyez: f32,
  eoex: f32, eoey: f32, eoez: f32,
  exeyez: f32,
  eoexey: f32, eoexez: f32, eoeyez: f32,
  ex: f32, ey: f32, ez: f32, eo: f32,
  eoexeyez: f32
}

// ─── Geometric product (full 3-D PGA) ───────────────────────────────────────
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

// ─── Reverse of a multivector ────────────────────────────────────────────────
fn reverse(a: MultiVector) -> MultiVector {
  return MultiVector(
    a.s,
    -a.exey, -a.exez, -a.eyez,
    -a.eoex, -a.eoey, -a.eoez,
    -a.exeyez,
    -a.eoexey, -a.eoexez, -a.eoeyez,
    a.ex, a.ey, a.ez, a.eo,
    a.eoexeyez
  );
}

// ─── Sandwich product: m * p * ~m ───────────────────────────────────────────
fn applyMotor(p: MultiVector, m: MultiVector) -> MultiVector {
  return geometricProduct(m, geometricProduct(p, reverse(m)));
}

// ─── Extract the rotor part of a motor ──────────────────────────────────────
fn extractRotor(m: MultiVector) -> MultiVector {
  return MultiVector(m.s, m.exey, m.exez, m.eyez, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

// ─── PGA point from 3-D coords ───────────────────────────────────────────────
fn createPoint(p: vec3f) -> MultiVector {
  return MultiVector(0, 0, 0, 0, 0, 0, 0, 1, -p.z, p.y, -p.x, 0, 0, 0, 0, 0);
}

// ─── Extract 3-D coords from a PGA point ─────────────────────────────────────
fn extractPoint(p: MultiVector) -> vec3f {
  return vec3f(-p.eoeyez / p.exeyez, p.eoexez / p.exeyez, -p.eoexey / p.exeyez);
}

// ─── Apply motor to a 3-D point ──────────────────────────────────────────────
fn applyMotorToPoint(p: vec3f, m: MultiVector) -> vec3f {
  return extractPoint(applyMotor(createPoint(p), m));
}

// ─── Apply motor to a 3-D direction (rotation only, no translation) ──────────
fn applyMotorToDir(d: vec3f, m: MultiVector) -> vec3f {
  let r = extractRotor(m);
  return extractPoint(applyMotor(createPoint(d), r));
}

// ─── Small positive epsilon for comparisons ──────────────────────────────────
const EPSILON: f32 = 0.00000001;

// ─── Camera: pinhole (projective) or orthographic ────────────────────────────
struct Camera {
  motor: MultiVector,  // pose motor   (64 bytes)
  focal: vec2f,        // focal lengths (8 bytes)
  res:   vec2f,        // image width/height (8 bytes)
}

// ─── Ellipsoid / shape: pose motor + semi-axes ───────────────────────────────
// radii.xyz doubles as: ellipsoid semi-axes, cube half-extents,
// cylinder (radius=x, half-height=y), cone (base-radius=x, half-height=y).
struct Sphere {
  motor: MultiVector,  // pose motor (64 bytes)
  radii: vec4f,        // x, y, z dimensions (w unused) (16 bytes)
}

// ─── Shape selector ───────────────────────────────────────────────────────────
// shapeIndex: 0 = sphere/ellipsoid, 1 = cube, 2 = cylinder, 3 = cone
struct ShapeConfig {
  shapeIndex: u32,
}

@group(0) @binding(0) var<uniform> cameraPose: Camera;
@group(0) @binding(1) var<uniform> sphere:     Sphere;
@group(0) @binding(2) var          outTexture: texture_storage_2d<rgba8unorm, write>;
@group(0) @binding(3) var<uniform> shapeConf:  ShapeConfig;

// ─── Sphere (ellipsoid) intersection & normal ─────────────────────────────────
// o, d: ray already transformed into object space.
fn intersectSphereObj(o: vec3f, d: vec3f) -> f32 {
  let r    = sphere.radii.xyz;
  let os   = o / r;
  let ds   = d / r;
  let a    = dot(ds, ds);
  let b    = 2.0 * dot(os, ds);
  let c    = dot(os, os) - 1.0;
  let disc = b * b - 4.0 * a * c;
  if (disc < 0.0) { return -1.0; }
  let sq = sqrt(disc);
  let t1 = (-b - sq) / (2.0 * a);
  let t2 = (-b + sq) / (2.0 * a);
  if (t1 > EPSILON) { return t1; }
  if (t2 > EPSILON) { return t2; }
  return -1.0;
}

// Outward normal on the ellipsoid surface in object space.
fn normalSphereObj(p: vec3f) -> vec3f {
  let r = sphere.radii.xyz;
  return normalize(p / (r * r));
}

// ─── Cube (AABB) intersection & normal ───────────────────────────────────────
// Uses sphere.radii.xyz as half-extents.
fn intersectCubeObj(o: vec3f, d: vec3f) -> f32 {
  let e = sphere.radii.xyz;
  var tNear = -1e30;
  var tFar  =  1e30;

  if (abs(d.x) > EPSILON) {
    let t1 = (-e.x - o.x) / d.x;
    let t2 = ( e.x - o.x) / d.x;
    tNear = max(tNear, min(t1, t2));
    tFar  = min(tFar,  max(t1, t2));
  } else if (abs(o.x) >= e.x) { return -1.0; }

  if (abs(d.y) > EPSILON) {
    let t1 = (-e.y - o.y) / d.y;
    let t2 = ( e.y - o.y) / d.y;
    tNear = max(tNear, min(t1, t2));
    tFar  = min(tFar,  max(t1, t2));
  } else if (abs(o.y) >= e.y) { return -1.0; }

  if (abs(d.z) > EPSILON) {
    let t1 = (-e.z - o.z) / d.z;
    let t2 = ( e.z - o.z) / d.z;
    tNear = max(tNear, min(t1, t2));
    tFar  = min(tFar,  max(t1, t2));
  } else if (abs(o.z) >= e.z) { return -1.0; }

  if (tFar < tNear || tFar < EPSILON) { return -1.0; }
  if (tNear > EPSILON) { return tNear; }
  return tFar;
}

fn normalCubeObj(p: vec3f) -> vec3f {
  let e = sphere.radii.xyz;
  let a = abs(p / e);
  if (a.x >= a.y && a.x >= a.z) { return vec3f(sign(p.x), 0.0, 0.0); }
  if (a.y >= a.z)                { return vec3f(0.0, sign(p.y), 0.0); }
  return vec3f(0.0, 0.0, sign(p.z));
}

// ─── Cylinder intersection & normal ──────────────────────────────────────────
// Aligned along Y axis: radius = radii.x, half-height = radii.y.
fn intersectCylinderObj(o: vec3f, d: vec3f) -> f32 {
  let r = sphere.radii.x;
  let h = sphere.radii.y;
  var tBest = -1.0;

  let a = d.x * d.x + d.z * d.z;
  if (a > EPSILON) {
    let b    = 2.0 * (o.x * d.x + o.z * d.z);
    let c    = o.x * o.x + o.z * o.z - r * r;
    let disc = b * b - 4.0 * a * c;
    if (disc >= 0.0) {
      let sq = sqrt(disc);
      let t1 = (-b - sq) / (2.0 * a);
      let t2 = (-b + sq) / (2.0 * a);
      if (t1 > EPSILON && abs(o.y + t1 * d.y) <= h) {
        tBest = t1;
      } else if (t2 > EPSILON && abs(o.y + t2 * d.y) <= h) {
        tBest = t2;
      }
    }
  }

  if (abs(d.y) > EPSILON) {
    let tTop = ( h - o.y) / d.y;
    if (tTop > EPSILON) {
      let px = o.x + tTop * d.x;
      let pz = o.z + tTop * d.z;
      if (px * px + pz * pz <= r * r && (tBest < 0.0 || tTop < tBest)) { tBest = tTop; }
    }
    let tBot = (-h - o.y) / d.y;
    if (tBot > EPSILON) {
      let px = o.x + tBot * d.x;
      let pz = o.z + tBot * d.z;
      if (px * px + pz * pz <= r * r && (tBest < 0.0 || tBot < tBest)) { tBest = tBot; }
    }
  }

  return tBest;
}

fn normalCylinderObj(p: vec3f) -> vec3f {
  let h = sphere.radii.y;
  if (abs(p.y - h) < 0.01) { return vec3f(0.0,  1.0, 0.0); }
  if (abs(p.y + h) < 0.01) { return vec3f(0.0, -1.0, 0.0); }
  return normalize(vec3f(p.x, 0.0, p.z));
}

// ─── Cone intersection & normal ───────────────────────────────────────────────
// Apex at y = +radii.y, base at y = -radii.y, base radius = radii.x.
fn intersectConeObj(o: vec3f, d: vec3f) -> f32 {
  let r  = sphere.radii.x;
  let h  = sphere.radii.y;
  let k  = r / (2.0 * h);    // tan(half-angle)
  let oy = o.y - h;           // shift so apex is at local origin
  var tBest = -1.0;

  let a    = d.x * d.x + d.z * d.z - k * k * d.y * d.y;
  let b    = 2.0 * (o.x * d.x + o.z * d.z - k * k * oy * d.y);
  let c    = o.x * o.x + o.z * o.z - k * k * oy * oy;

  if (abs(a) > EPSILON) {
    let disc = b * b - 4.0 * a * c;
    if (disc >= 0.0) {
      let sq = sqrt(disc);
      let t1 = (-b - sq) / (2.0 * a);
      let t2 = (-b + sq) / (2.0 * a);
      let y1 = o.y + t1 * d.y;
      let y2 = o.y + t2 * d.y;
      if (t1 > EPSILON && y1 >= -h && y1 <= h) {
        tBest = t1;
      } else if (t2 > EPSILON && y2 >= -h && y2 <= h) {
        tBest = t2;
      }
    }
  }

  // Base cap at y = -h
  if (abs(d.y) > EPSILON) {
    let tCap = (-h - o.y) / d.y;
    if (tCap > EPSILON) {
      let px = o.x + tCap * d.x;
      let pz = o.z + tCap * d.z;
      if (px * px + pz * pz <= r * r && (tBest < 0.0 || tCap < tBest)) { tBest = tCap; }
    }
  }

  return tBest;
}

fn normalConeObj(p: vec3f) -> vec3f {
  let h = sphere.radii.y;
  let k = sphere.radii.x / (2.0 * h);
  if (abs(p.y + h) < 0.01) { return vec3f(0.0, -1.0, 0.0); }
  // Gradient of x² + z² - k²*(y-h)² = 0
  return normalize(vec3f(p.x, -k * k * (p.y - h), p.z));
}

// ─── Trace result: world-space normal + ray parameter ─────────────────────────
struct TraceResult {
  normal: vec3f,  // world-space outward normal at the hit point
  t:      f32,    // ray parameter (-1.0 = miss)
}

// ─── Dispatch the correct intersection based on shapeConf.shapeIndex ─────────
fn traceRay(camOrig: vec3f, camDir: vec3f) -> TraceResult {
  var res: TraceResult;
  res.normal = vec3f(0.0, 1.0, 0.0);
  res.t      = -1.0;

  // Camera space → world space → object space
  var o = applyMotorToPoint(camOrig, cameraPose.motor);
  o     = applyMotorToPoint(o, reverse(sphere.motor));
  var d = applyMotorToDir(camDir, cameraPose.motor);
  d     = applyMotorToDir(d, reverse(sphere.motor));

  var t: f32;
  var n: vec3f;

  let shape = shapeConf.shapeIndex;
  if (shape == 0u) {
    t = intersectSphereObj(o, d);
    if (t > 0.0) { n = normalSphereObj(o + t * d); }
  } else if (shape == 1u) {
    t = intersectCubeObj(o, d);
    if (t > 0.0) { n = normalCubeObj(o + t * d); }
  } else if (shape == 2u) {
    t = intersectCylinderObj(o, d);
    if (t > 0.0) { n = normalCylinderObj(o + t * d); }
  } else {
    t = intersectConeObj(o, d);
    if (t > 0.0) { n = normalConeObj(o + t * d); }
  }

  if (t > 0.0) {
    // Rotate object-space normal into world space (rotation only, no translation)
    res.normal = normalize(applyMotorToDir(n, sphere.motor));
    res.t      = t;
  }
  return res;
}

// ─── Shaded coloring ──────────────────────────────────────────────────────────
// Depth-based purple gradient modulated by diffuse lighting for 3-D appearance.
// miss → black
fn shadedColor(uv: vec2i, res: TraceResult) {
  if (res.t <= 0.0) {
    textureStore(outTexture, uv, vec4f(0.0, 0.0, 0.0, 1.0));
    return;
  }
  let tn       = clamp(res.t / 10.0, 0.0, 1.0);
  let lavender = vec3f(0.87, 0.73, 1.0);
  let dpurple  = vec3f(0.29, 0.0,  0.51);
  let baseColor = mix(lavender, dpurple, tn);

  let lightDir = normalize(vec3f(1.0, 2.0, 1.0));
  let diffuse  = max(0.0, dot(res.normal, lightDir));
  let ambient  = 0.15;
  let lit      = (ambient + (1.0 - ambient) * diffuse) * baseColor;
  textureStore(outTexture, uv, vec4f(lit, 1.0));
}

// ─── Orthographic compute entry point ────────────────────────────────────────
@compute @workgroup_size(16, 16)
fn computeOrthogonalMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let psize = vec2f(2.0, 2.0) / cameraPose.res.xy;
    let spt   = vec3f(
      (f32(uv.x) + 0.5) * psize.x - 1.0,
      (f32(uv.y) + 0.5) * psize.y - 1.0,
      0.0
    );
    shadedColor(uv, traceRay(spt, vec3f(0.0, 0.0, 1.0)));
  }
}

// ─── Projective (pinhole) compute entry point ─────────────────────────────────
@compute @workgroup_size(16, 16)
fn computeProjectiveMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    let psize = vec2f(2.0, 2.0) / (cameraPose.res.xy * cameraPose.focal);
    let spt   = vec3f(0.0, 0.0, 0.0);
    let rdir  = normalize(vec3f(
      (f32(uv.x) + 0.5) * psize.x - 1.0 / cameraPose.focal.x,
      (f32(uv.y) + 0.5) * psize.y - 1.0 / cameraPose.focal.y,
      1.0
    ));
    shadedColor(uv, traceRay(spt, rdir));
  }
}
