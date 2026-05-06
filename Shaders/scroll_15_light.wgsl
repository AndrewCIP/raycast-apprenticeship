/*
 * Scroll 15 — Shadows
 *
 * Extends the Scroll-14 shader (texture/bump/env mapping) with shadow rendering:
 *   Part 1 – Hard shadows       : binary occlusion via a single shadow ray
 *   Part 2 – Soft shadows
 *     Point light   → Area light sampling  (jitter the light position, 8 samples)
 *     Directional   → PCF / jittered directions  (8 jittered shadow rays)
 *     Spotlight     → Distance-based  (shadow fades with occluder distance)
 *
 * Additional GPU binding:
 *   @binding(8) shadowFlags – struct { enabled, mode, pad0, pad1 }
 *                             mode: 0 = hard shadow, 1 = soft shadow
 *
 * Keys (JS side):
 *   O / o  – toggle shadows on / off
 *   K / k  – cycle hard ↔ soft shadow mode
 */

// ── 3-D PGA multivector ──────────────────────────────────────────────────────
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
  r.s = a.s * b.s - a.exey * b.exey - a.exez * b.exez - a.eyez * b.eyez - a.exeyez * b.exeyez + a.ex * b.ex + a.ey * b.ey + a.ez * b.ez;
  r.exey = a.s * b.exey + a.exey * b.s - a.exez * b.eyez + a.eyez * b.exez + a.exeyez * b.ez + a.ex * b.ey - a.ey * b.ex + a.ez * b.exeyez;
  r.exez = a.s * b.exez + a.exey * b.eyez + a.exez * b.s - a.eyez * b.exey - a.exeyez * b.ey + a.ex * b.ez - a.ey * b.exeyez - a.ez * b.ex;
  r.eyez = a.s * b.eyez - a.exey * b.exez + a.exez * b.exey + a.eyez * b.s + a.exeyez * b.ex + a.ex * b.exeyez + a.ey * b.ez - a.ez * b.ey;
  r.eoex = a.s * b.eoex + a.exey * b.eoey + a.exez * b.eoez - a.eyez * b.eoexeyez + a.eoex * b.s - a.eoey * b.exey - a.eoez * b.exez + a.exeyez * b.eoeyez + a.eoexey * b.ey + a.eoexez * b.ez - a.eoeyez * b.exeyez - a.ex * b.eo + a.ey * b.eoexey + a.ez * b.eoexez + a.eo * b.ex - a.eoexeyez * b.eyez;
  r.eoey = a.s * b.eoey - a.exey * b.eoex + a.exez * b.eoexeyez + a.eyez * b.eoez + a.eoex * b.exey + a.eoey * b.s - a.eoez * b.eyez - a.exeyez * b.eoexez - a.eoexey * b.ex + a.eoexez * b.exeyez + a.eoeyez * b.ey - a.ex * b.eoexey - a.ey * b.eo + a.ez * b.eoeyez + a.eo * b.ey + a.eoexeyez * b.exez;
  r.eoez = a.s * b.eoez - a.exey * b.eoexeyez - a.exez * b.eoex - a.eyez * b.eoey + a.eoex * b.exez + a.eoey * b.eyez + a.eoez * b.s + a.exeyez * b.eoexey - a.eoexey * b.exeyez - a.eoexez * b.ex - a.eoeyez * b.ey - a.ex * b.eoexez - a.ey * b.eoeyez - a.ez * b.eo + a.eo * b.ez - a.eoexeyez * b.exey;
  r.exeyez = a.s * b.exeyez + a.exey * b.ez - a.exez * b.ey + a.eyez * b.ex + a.exeyez * b.s + a.ex * b.eyez - a.ey * b.exez + a.ez * b.exey;
  r.eoexey = a.s * b.eoexey + a.exey * b.eo - a.exez * b.eoeyez + a.eyez * b.eoexez + a.eoex * b.ey - a.eoey * b.ex + a.eoez * b.exeyez - a.exeyez * b.eoez + a.eoexey * b.s - a.eoexez * b.eyez + a.eoeyez * b.exez - a.ex * b.eoey + a.ey * b.eoex - a.ez * b.eoexeyez + a.eo * b.exey + a.eoexeyez * b.ez;
  r.eoexez = a.s * b.eoexez + a.exey * b.eoeyez + a.exez * b.eo - a.eyez * b.eoexey + a.eoex * b.ez - a.eoey * b.exeyez - a.eoez * b.ex + a.exeyez * b.eoey + a.eoexey * b.eyez + a.eoexez * b.s - a.eoeyez * b.exey - a.ex * b.eoez + a.ey * b.eoexeyez + a.ez * b.eoex + a.eo * b.exez - a.eoexeyez * b.ey;
  r.eoeyez = a.s * b.eoeyez - a.exey * b.eoexez + a.exez * b.eoexey + a.eyez * b.eo + a.eoex * b.exeyez + a.eoey * b.ez - a.eoez * b.ey - a.exeyez * b.eoex - a.eoexey * b.exez + a.eoexez * b.exey + a.eoeyez * b.s - a.ex * b.eoexeyez - a.ey * b.eoez + a.ez * b.eoey + a.eo * b.eyez + a.eoexeyez * b.ex;
  r.ex = a.s * b.ex + a.exey * b.ey + a.exez * b.ez - a.eyez * b.exeyez - a.exeyez * b.eyez + a.ex * b.s - a.ey * b.exey - a.ez * b.exez;
  r.ey = a.s * b.ey - a.exey * b.ex + a.exez * b.exeyez + a.eyez * b.ez + a.exeyez * b.exez + a.ex * b.exey + a.ey * b.s - a.ez * b.eyez;
  r.ez = a.s * b.ez - a.exey * b.exeyez - a.exez * b.ex - a.eyez * b.ey - a.exeyez * b.exey + a.ex * b.exez + a.ey * b.eyez + a.ez * b.s;
  r.eo = a.s * b.eo - a.exey * b.eoexey - a.exez * b.eoexez - a.eyez * b.eoeyez + a.eoex * b.ex + a.eoey * b.ey + a.eoez * b.ez + a.exeyez * b.eoexeyez - a.eoexey * b.exey - a.eoexez * b.exez - a.eoeyez * b.eyez - a.ex * b.eoex - a.ey * b.eoey - a.ez * b.eoez + a.eo * b.s - a.eoexeyez * b.exeyez;
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
  var sum = 0.;
  sum += m.s * m.s; sum += m.exey * m.exey; sum += m.exez * m.exez; sum += m.eyez * m.eyez;
  sum += m.eoex * m.eoex; sum += m.eoey * m.eoey; sum += m.eoez * m.eoez; sum += m.exeyez * m.exeyez;
  sum += m.eoexey * m.eoexey; sum += m.eoexez * m.eoexez; sum += m.eoeyez * m.eoeyez;
  sum += m.ex * m.ex; sum += m.ey * m.ey; sum += m.ez * m.ez; sum += m.eo * m.eo; sum += m.eoexeyez * m.eoexeyez;
  return sqrt(sum);
}

fn normalizeMotor(m: MultiVector) -> MultiVector {
  let mnorm = motorNorm(m);
  if (mnorm == 0.0) { return MultiVector(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); }
  return MultiVector(m.s/mnorm, m.exey/mnorm, m.exez/mnorm, m.eyez/mnorm, m.eoex/mnorm, m.eoey/mnorm, m.eoez/mnorm, m.exeyez/mnorm, m.eoexey/mnorm, m.eoexez/mnorm, m.eoeyez/mnorm, m.ex/mnorm, m.ey/mnorm, m.ez/mnorm, m.eo/mnorm, m.eoexeyez/mnorm);
}

fn createDir(d: vec3f) -> MultiVector {
  return MultiVector(0, d.z, -d.y, d.x, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn createLine(s: vec3f, d: vec3f) -> MultiVector {
  let n = createDir(d);
  let dir = normalizeMotor(n);
  return MultiVector(0, dir.exey, dir.exez, dir.eyez, -(-dir.exez * s.z - dir.exey * s.y), -(dir.exey * s.x - dir.eyez * s.z), -(dir.eyez * s.y + dir.exez * s.x), 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn extractRotor(m: MultiVector) -> MultiVector {
  return MultiVector(m.s, m.exey, m.exez, m.eyez, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn createPoint(p: vec3f) -> MultiVector {
  return MultiVector(0, 0, 0, 0, 0, 0, 0, 1, -p.z, p.y, -p.x, 0, 0, 0, 0, 0);
}

fn extractPoint(p: MultiVector) -> vec3f {
  return vec3f(-p.eoeyez / p.exeyez, p.eoexez / p.exeyez, -p.eoexey / p.exeyez);
}

fn createPlaneFromPoints(p1: vec3f, p2: vec3f, p3: vec3f) -> MultiVector {
  let nx = (p2[1]*p3[2] - p3[1]*p2[2]) - (p1[1]*p3[2] - p3[1]*p1[2]) + (p1[1]*p2[2] - p2[1]*p1[2]);
  let ny = (p2[0]*p3[2] - p3[0]*p2[2]) - (p1[0]*p3[2] - p3[0]*p1[2]) + (p1[0]*p2[2] - p2[0]*p1[2]);
  let nz = (p2[0]*p3[1] - p3[0]*p2[1]) - (p1[0]*p3[1] - p3[0]*p1[1]) + (p1[0]*p2[1] - p2[0]*p1[1]);
  let d  = (p1[0]*(p2[1]*p3[2] - p3[1]*p2[2]) - p2[0]*(p1[1]*p3[2] - p3[1]*p1[2]) + p3[0]*(p1[1]*p2[2] - p2[1]*p1[2]));
  return MultiVector(0,0,0,0,0,0,0,0,0,0,0, nx, -ny, nz, -d, 0);
}

fn applyMotorToPoint(p: vec3f, m: MultiVector) -> vec3f {
  return extractPoint(applyMotor(createPoint(p), m));
}

fn applyMotorToDir(d: vec3f, m: MultiVector) -> vec3f {
  let r = extractRotor(m);
  return extractPoint(applyMotor(createPoint(d), r));
}

const EPSILON : f32 = 0.00000001;

struct HitInfo {
  p: vec3f,
  hit: bool,
  inPlane: bool,
}

fn linePlaneIntersection(L: MultiVector, P: MultiVector) -> HitInfo {
  let new_p = geometricProduct(L, P);
  var hitInfo: HitInfo;
  hitInfo.p = extractPoint(new_p);
  hitInfo.hit = !(abs(new_p.exeyez) <= EPSILON);
  hitInfo.inPlane = hitInfo.hit && abs(new_p.eoexey) <= EPSILON && abs(new_p.eoexez) <= EPSILON && abs(new_p.eoeyez) <= EPSILON;
  return hitInfo;
}

// ── GPU structs & bindings ───────────────────────────────────────────────────
struct Camera {
  motor: MultiVector,
  focal: vec2f,
  res: vec2f,
}

struct Quad {
  ll: vec4f,
  lr: vec4f,
  ur: vec4f,
  rl: vec4f,
}

struct Box {
  motor: MultiVector,
  scale: vec4f,
  faces: array<Quad, 6>,
}

// light.params layout:
//   [0] = spotlight cutoff angle (radians)
//   [1] = spotlight drop-off exponent
//   [2] = light type  — 0:point  1:directional  2:spotlight
//   [3] = shading model — 0:Lambertian  1:Phong  2:Toon
struct Light {
  intensity:   vec4f,
  position:    vec4f,
  direction:   vec4f,
  attenuation: vec4f,
  params:      vec4f,
}

@group(0) @binding(0) var<uniform> cameraPose: Camera;
@group(0) @binding(1) var<uniform> box:        Box;
@group(0) @binding(2) var outTexture: texture_storage_2d<rgba8unorm, write>;
@group(0) @binding(3) var<uniform> light:      Light;

// ── Scroll-14 texture bindings ───────────────────────────────────────────────
@group(0) @binding(4) var texSampler: sampler;
@group(0) @binding(5) var floorTex:  texture_2d<f32>;
@group(0) @binding(6) var envMap:    texture_cube<f32>;

struct TexFlags {
  showTexture: u32,  // 1 = stone texture on box faces
  showBump:    u32,  // 1 = bump-mapped normals
  showCubeMap: u32,  // 1 = Yokohama environment on walls
  pad:         u32,
}
@group(0) @binding(7) var<uniform> texFlags: TexFlags;

// ── Scroll-15 shadow binding ──────────────────────────────────────────────────
struct ShadowFlags {
  enabled: u32,  // 0 = shadows off, 1 = shadows on
  mode:    u32,  // 0 = hard shadow, 1 = soft shadow
  pad0:    u32,
  pad1:    u32,
}
@group(0) @binding(8) var<uniform> shadowFlags: ShadowFlags;

// ── Geometry helpers ─────────────────────────────────────────────────────────
fn transformDir(d: vec3f) -> vec3f {
  var out = applyMotorToDir(d, cameraPose.motor);
  out = applyMotorToDir(out, reverse(box.motor));
  out /= box.scale.xyz;
  return out;
}

fn transformPt(pt: vec3f) -> vec3f {
  var out = applyMotorToPoint(pt, cameraPose.motor);
  out = applyMotorToPoint(out, reverse(box.motor));
  out /= box.scale.xyz;
  return out;
}

fn transformNormal(n: vec3f) -> vec3f {
  var out = n * box.scale.xyz;
  out = applyMotorToDir(out, box.motor);
  return normalize(out);
}

fn transformHitPoint(pt: vec3f) -> vec3f {
  var out = pt * box.scale.xyz;
  out = applyMotorToPoint(out, box.motor);
  return out;
}

fn quadRayHitCheck(s: vec3f, d: vec3f, q: Quad, ct: f32) -> vec2f {
  let L = createLine(s, d);
  let P = createPlaneFromPoints(q.ll.xyz, q.lr.xyz, q.ur.xyz);
  var hitInfo = linePlaneIntersection(L, P);
  if (hitInfo.hit) {
    if (abs(q.ll.z - q.ur.z) <= EPSILON) {
      hitInfo.hit = (q.ll.x <= hitInfo.p.x && hitInfo.p.x <= q.ur.x) && (q.ll.y <= hitInfo.p.y && hitInfo.p.y <= q.ur.y);
    } else if (abs(q.ll.y - q.ur.y) <= EPSILON) {
      hitInfo.hit = (q.ll.x <= hitInfo.p.x && hitInfo.p.x <= q.ur.x) && (q.ll.z <= hitInfo.p.z && hitInfo.p.z <= q.ur.z);
    } else if (abs(q.ll.x - q.ur.x) <= EPSILON) {
      hitInfo.hit = (q.ll.y <= hitInfo.p.y && hitInfo.p.y <= q.ur.y) && (q.ll.z <= hitInfo.p.z && hitInfo.p.z <= q.ur.z);
    }
    if (hitInfo.hit) {
      var nt: f32 = -1.;
      if      (d.x > EPSILON) { nt = (hitInfo.p.x - s.x) / d.x; }
      else if (d.y > EPSILON) { nt = (hitInfo.p.y - s.y) / d.y; }
      else                    { nt = (hitInfo.p.z - s.z) / d.z; }
      if      (nt < 0)  { return vec2f(ct, -1); }
      else if (ct < 0)  { return vec2f(nt,  1); }
      else if (nt < ct) { return vec2f(nt,  1); }
      else              { return vec2f(ct, -1); }
    }
  }
  return vec2f(ct, -1.);
}

fn rayBoxIntersection(s: vec3f, d: vec3f) -> vec2f {
  var t = -1.; var idx = -1.;
  for (var i = 0; i < 6; i++) {
    let info = quadRayHitCheck(s, d, box.faces[i], t);
    if (info.y > 0) { t = info.x; idx = f32(i); }
  }
  return vec2f(t, idx);
}

// ── Surface material helpers ─────────────────────────────────────────────────
fn boxEmitColor() -> vec4f {
  return vec4f(0, 0, 0, 1);
}

fn boxDiffuseColor(idx: i32) -> vec4f {
  switch(idx) {
    case 0:  { return vec4f(232./255, 119./255,  34./255, 1.); } // Bucknell Orange 1
    case 1:  { return vec4f(255./255, 163./255,   0./255, 1.); } // Bucknell Orange 2
    case 2:  { return vec4f(  0./255, 130./255, 186./255, 1.); } // Bucknell Blue 2
    case 3:  { return vec4f( 89./255, 203./255, 232./255, 1.); } // Bucknell Blue 3
    case 4:  { return vec4f(217./255, 217./255, 214./255, 1.); } // Bucknell Gray 1
    case 5:  { return vec4f(167./255, 168./255, 170./255, 1.); } // Bucknell Gray 2
    default: { return vec4f(0., 0., 0., 1.); }
  }
}

fn boxNormal(idx: i32) -> vec3f {
  // Inward-facing normals — the camera lives inside the box, so all normals
  // point toward the interior.  Opposite faces intentionally share the same
  // sign because the winding order already encodes which surface is "front".
  switch(idx) {
    case 0:  { return vec3f( 0,  0, -1); } // front
    case 1:  { return vec3f( 0,  0, -1); } // back
    case 2:  { return vec3f(-1,  0,  0); } // left
    case 3:  { return vec3f(-1,  0,  0); } // right
    case 4:  { return vec3f( 0, -1,  0); } // top
    case 5:  { return vec3f( 0, -1,  0); } // down
    default: { return vec3f( 0,  0,  0); }
  }
}

// Indices of the bottom (floor) and top (ceiling) faces in the UnitCube array.
const FACE_FLOOR: i32 = 5;
const FACE_TOP:   i32 = 4;

// ── Part 1 & 2: UV mapping and bump helpers ───────────────────────────────────
//
// UV coordinates for each box face in local space, tiled by the caller.
// Tangent frame assumed:
//   Face 0 (front,  z=+0.5): u→+x, v→+y
//   Face 1 (back,   z=-0.5): u→-x, v→+y
//   Face 2 (left,   x=-0.5): u→+z, v→+y
//   Face 3 (right,  x=+0.5): u→-z, v→+y
//   Face 4 (top,    y=+0.5): u→+x, v→-z
//   Face 5 (down,   y=-0.5): u→+x, v→+z
fn computeUV(faceIdx: i32, localHit: vec3f) -> vec2f {
  switch(faceIdx) {
    case 0:  { return vec2f(localHit.x + 0.5, localHit.y + 0.5); }
    case 1:  { return vec2f(0.5 - localHit.x, localHit.y + 0.5); }
    case 2:  { return vec2f(localHit.z + 0.5, localHit.y + 0.5); }
    case 3:  { return vec2f(0.5 - localHit.z, localHit.y + 0.5); }
    case 4:  { return vec2f(localHit.x + 0.5, 0.5 - localHit.z); }
    case 5:  { return vec2f(localHit.x + 0.5, localHit.z + 0.5); }
    default: { return vec2f(0.0, 0.0); }
  }
}

// Bump-mapped normal derived from the stone texture luminance as a height map.
// Uses finite differences: N_bump = normalize(N - T*dh/du - B*dh/dv).
// Per-face tangent frames (see UV convention above).
fn computeBumpNormal(faceIdx: i32, uv: vec2f) -> vec3f {
  let eps      = 1.0 / 512.0;
  let luma     = vec3f(0.299, 0.587, 0.114);
  let strength = 4.0;
  let h00 = dot(textureSampleLevel(floorTex, texSampler, uv,                    0.0).rgb, luma);
  let h10 = dot(textureSampleLevel(floorTex, texSampler, uv + vec2f(eps, 0.0), 0.0).rgb, luma);
  let h01 = dot(textureSampleLevel(floorTex, texSampler, uv + vec2f(0.0, eps), 0.0).rgb, luma);
  let dhdu = (h10 - h00) * strength;
  let dhdv = (h01 - h00) * strength;
  // Derive N_bump = normalize(N - T*dhdu - B*dhdv) per face
  switch(faceIdx) {
    case 0:  { return normalize(vec3f(-dhdu, -dhdv, -1.0)); } // front
    case 1:  { return normalize(vec3f( dhdu, -dhdv, -1.0)); } // back
    case 2:  { return normalize(vec3f(-1.0,  -dhdv, -dhdu)); } // left
    case 3:  { return normalize(vec3f(-1.0,  -dhdv,  dhdu)); } // right
    case 4:  { return normalize(vec3f(-dhdu, -1.0,   dhdv)); } // top
    case 5:  { return normalize(vec3f(-dhdu, -1.0,  -dhdv)); } // down
    default: { return vec3f(0.0, 0.0, -1.0); }
  }
}

// ── Light computation ─────────────────────────────────────────────────────────
struct LightInfo {
  intensity: vec4f,
  lightdir:  vec3f,
}

fn getLightInfo(lightPos: vec3f, lightDir: vec3f, hitPoint: vec3f) -> LightInfo {
  var out: LightInfo;
  let lightType = i32(light.params[2]);

  if (lightType == 1) {
    out.intensity = light.intensity;
    out.lightdir  = normalize(lightDir);

  } else if (lightType == 2) {
    let toSurface = normalize(hitPoint - lightPos);
    let cosAngle  = dot(normalize(lightDir), toSurface);
    let cutoff    = light.params[0];
    let dropoff   = light.params[1];

    if (cosAngle > cos(cutoff)) {
      let spotFactor = pow(cosAngle, dropoff);
      let dist       = length(hitPoint - lightPos);
      let atten      = light.attenuation[0]
                     + dist * light.attenuation[1]
                     + dist * dist * light.attenuation[2];
      out.intensity = light.intensity * spotFactor / atten;
    } else {
      out.intensity = vec4f(0., 0., 0., 0.);
    }
    out.lightdir = toSurface;

  } else {
    let toSurface = normalize(hitPoint - lightPos);
    let dist      = length(hitPoint - lightPos);
    let atten     = light.attenuation[0]
                  + dist * light.attenuation[1]
                  + dist * dist * light.attenuation[2];
    out.intensity = light.intensity / atten;
    out.lightdir  = toSurface;
  }

  return out;
}

// ── Toon shading quantisation ─────────────────────────────────────────────────
fn toonQuantize(v: f32) -> f32 {
  if      (v < 0.10) { return 0.0; }
  else if (v < 0.35) { return 0.2; }
  else if (v < 0.65) { return 0.5; }
  else if (v < 0.90) { return 0.8; }
  else               { return 1.0; }
}

// ── Shading dispatch ──────────────────────────────────────────────────────────
fn shadeSurface(
  emit:        vec4f,
  diffuseCol:  vec4f,
  normal:      vec3f,
  lightInfo:   LightInfo,
  camPos:      vec3f,
  hitPt:       vec3f
) -> vec4f {
  let l = lightInfo.lightdir;
  let I = lightInfo.intensity;
  let shadingModel = i32(light.params[3]);

  let diffuseTerm = max(dot(normal, -l), 0.0);

  if (shadingModel == 1) {
    let R            = reflect(l, normal);
    let viewDir      = normalize(camPos - hitPt);
    let specularTerm = pow(max(dot(viewDir, -R), 0.0), 64.0);
    let ks           = vec4f(0.5, 0.5, 0.5, 0.0);
    let ka           = vec4f(0.1, 0.1, 0.1, 0.0);
    return emit + diffuseCol * I * diffuseTerm
                + ks * I * specularTerm
                + ka * I;

  } else if (shadingModel == 2) {
    let R            = reflect(l, normal);
    let viewDir      = normalize(camPos - hitPt);
    let specularTerm = pow(max(dot(viewDir, -R), 0.0), 64.0);
    let ks           = vec4f(0.5, 0.5, 0.5, 0.0);
    let ka           = vec4f(0.1, 0.1, 0.1, 0.0);
    let qDiff        = toonQuantize(diffuseTerm);
    let qSpec        = toonQuantize(specularTerm);
    return emit + diffuseCol * I * qDiff
                + ks * I * qSpec
                + ka * I;

  } else {
    return emit + diffuseCol * I * diffuseTerm;
  }
}

// ── Shadow helpers ────────────────────────────────────────────────────────────

// PCG hash: deterministic pseudo-random u32 from a seed.
fn pcg(v: u32) -> u32 {
  let state = v * 747796405u + 2891336453u;
  let word  = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
  return (word >> 22u) ^ word;
}

// rand: pixel UV + sample index → value in [0, 1).
fn rand(uv: vec2i, sampleIdx: u32) -> f32 {
  let seed = u32(uv.x) * 1973u + u32(uv.y) * 9277u + sampleIdx * 26699u;
  return f32(pcg(seed)) / 4294967295.0;
}

// ── Floating spheres ─────────────────────────────────────────────────────────
// Two spheres suspended inside the box (box-local coordinates, range ±0.5).
// Their shadows fall on the floor, making hard vs. soft shadow differences
// clearly visible to the viewer.
//   Sphere 0: larger, near-centre — main shadow caster
//   Sphere 1: smaller, off-centre — secondary caster for variety
const SPHERE0_CENTER: vec3f = vec3f( 0.00, -0.22,  0.05);
const SPHERE0_RADIUS: f32   = 0.14;
const SPHERE1_CENTER: vec3f = vec3f( 0.22, -0.35, -0.08);
const SPHERE1_RADIUS: f32   = 0.09;

// Ray–sphere intersection.  Returns the nearest positive t, or −1 if no hit.
fn raySphereIntersect(orig: vec3f, dir: vec3f, center: vec3f, radius: f32) -> f32 {
  let oc   = orig - center;
  let b    = dot(oc, dir);
  let c    = dot(oc, oc) - radius * radius;
  let disc = b * b - c;
  if (disc < 0.0) { return -1.0; }
  let sq = sqrt(disc);
  let t0 = -b - sq;
  if (t0 > 0.0) { return t0; }
  let t1 = -b + sq;
  if (t1 > 0.0) { return t1; }
  return -1.0;
}

// Test all scene spheres; return vec2f(t, sphereIdx) – t < 0 means no hit.
fn closestSphereHit(orig: vec3f, dir: vec3f) -> vec2f {
  var best = vec2f(-1.0, -1.0);
  let t0   = raySphereIntersect(orig, dir, SPHERE0_CENTER, SPHERE0_RADIUS);
  if (t0 > 0.0 && (best.x < 0.0 || t0 < best.x)) { best = vec2f(t0, 0.0); }
  let t1   = raySphereIntersect(orig, dir, SPHERE1_CENTER, SPHERE1_RADIUS);
  if (t1 > 0.0 && (best.x < 0.0 || t1 < best.x)) { best = vec2f(t1, 1.0); }
  return best;
}

// castShadowRay: returns true when any scene object (box or sphere) is hit
// before maxDist (box-local units).  A small epsilon offset avoids
// self-intersection at the ray origin.
fn castShadowRay(localOrig: vec3f, shadowDir: vec3f, maxDist: f32) -> bool {
  let orig   = localOrig + shadowDir * 0.001;
  let boxHit = rayBoxIntersection(orig, shadowDir);
  if (boxHit.x > 0.0 && boxHit.x < maxDist) { return true; }
  let sphHit = closestSphereHit(orig, shadowDir);
  if (sphHit.x > 0.0 && sphHit.x < maxDist) { return true; }
  return false;
}

// computeHardShadow: single shadow ray — returns 0.1 (occluded) or 1.0 (lit).
fn computeHardShadow(
  localHit:      vec3f,
  lightPosLocal: vec3f,
  lightDirLocal: vec3f,  // normalised world→local light direction (for directional)
  lightType:     i32
) -> f32 {
  if (lightType == 1) {
    // Directional light — infinite distance, cast in -lightDir direction.
    if (castShadowRay(localHit, -lightDirLocal, 1e10)) { return 0.1; }
  } else {
    // Point or spotlight — cast toward the light position.
    let toLight = lightPosLocal - localHit;
    let dist    = length(toLight);
    if (dist > 0.001 && castShadowRay(localHit, toLight / dist, dist)) { return 0.1; }
  }
  return 1.0;
}

// Number of jittered samples used for soft shadows.
const SHADOW_SAMPLES: i32 = 8;

// computeSoftShadow: technique varies per light type.
//   Point light  → Area light sampling   (jitter light position, 8 samples)
//   Directional  → PCF / jittered dirs   (8 jittered shadow rays)
//   Spotlight    → Distance-based        (modulate by occluder distance)
fn computeSoftShadow(
  localHit:      vec3f,
  lightPosLocal: vec3f,
  lightDirLocal: vec3f,
  lightType:     i32,
  uv:            vec2i
) -> f32 {
  if (lightType == 0) {
    // ── Point light: area-light sampling ─────────────────────────────────────
    // Cast 8 shadow rays toward randomly jittered positions around the light.
    let areaRadius = 0.15;
    var acc = 0.0;
    for (var i: i32 = 0; i < SHADOW_SAMPLES; i++) {
      let rx = (rand(uv, u32(i * 3 + 0)) - 0.5) * 2.0 * areaRadius;
      let ry = (rand(uv, u32(i * 3 + 1)) - 0.5) * 2.0 * areaRadius;
      let rz = (rand(uv, u32(i * 3 + 2)) - 0.5) * 2.0 * areaRadius;
      let samplePos = lightPosLocal + vec3f(rx, ry, rz);
      let toSample  = samplePos - localHit;
      let dist      = length(toSample);
      if (dist > 0.001 && castShadowRay(localHit, toSample / dist, dist)) {
        acc += 0.1;
      } else {
        acc += 1.0;
      }
    }
    return acc / f32(SHADOW_SAMPLES);

  } else if (lightType == 1) {
    // ── Directional light: PCF (jitter shadow direction) ─────────────────────
    // Build a tangent frame perpendicular to lightDirLocal for perturbation.
    let pcfRadius = 0.05;
    var tangent: vec3f;
    if (abs(lightDirLocal.x) < 0.9) {
      tangent = normalize(cross(lightDirLocal, vec3f(1, 0, 0)));
    } else {
      tangent = normalize(cross(lightDirLocal, vec3f(0, 1, 0)));
    }
    let bitangent = cross(lightDirLocal, tangent);
    var acc = 0.0;
    for (var i: i32 = 0; i < SHADOW_SAMPLES; i++) {
      let ox = (rand(uv, u32(i * 2 + 100)) - 0.5) * 2.0 * pcfRadius;
      let oy = (rand(uv, u32(i * 2 + 101)) - 0.5) * 2.0 * pcfRadius;
      let shadowDir = normalize(-lightDirLocal + tangent * ox + bitangent * oy);
      if (castShadowRay(localHit, shadowDir, 1e10)) {
        acc += 0.1;
      } else {
        acc += 1.0;
      }
    }
    return acc / f32(SHADOW_SAMPLES);

  } else {
    // ── Spotlight: distance-based soft shadow ─────────────────────────────────
    // Darkness is proportional to how close the occluder is to the hit point:
    // closer occluder → smaller t → darker shadow.
    let toLight   = lightPosLocal - localHit;
    let dist      = length(toLight);
    if (dist < 0.001) { return 1.0; }
    let shadowDir = toLight / dist;
    let orig   = localHit + shadowDir * 0.001;
    let boxOcc = rayBoxIntersection(orig, shadowDir);
    let sphOcc = closestSphereHit(orig, shadowDir);
    var occT   = -1.0;
    if (boxOcc.x > 0.0 && boxOcc.x < dist) { occT = boxOcc.x; }
    if (sphOcc.x > 0.0 && sphOcc.x < dist && (occT < 0.0 || sphOcc.x < occT)) { occT = sphOcc.x; }
    if (occT > 0.0) {
      return max(pow(min(occT, 1.0), 0.85), 0.1);
    }
    return 1.0;
  }
}

// ── Shared per-hit texture logic ──────────────────────────────────────────────
//
// Called by both orthographic and projective entry points after a box hit is
// confirmed.  Returns the final colour for this pixel.
//
// Parameters:
//   spt      – ray origin in box-local space
//   rdir     – ray direction in box-local space
//   hitInfo  – (t, faceIndex) from rayBoxIntersection
//   uv       – pixel coordinates, used as a random seed for soft shadows
fn shadeHit(spt: vec3f, rdir: vec3f, hitInfo: vec2f, uv: vec2i) -> vec4f {
  let faceIdx  = i32(hitInfo.y);
  let localHit = spt + rdir * hitInfo.x;

  // World-space ray direction — reverse box transform on the local direction.
  // Used for cube-map sampling (skybox direction = viewing direction).
  let worldRdir = normalize(applyMotorToDir(rdir * box.scale.xyz, box.motor));

  // ── Part 3: Environment mapping ─────────────────────────────────────────────
  // When the cube map is on, colour all faces that are NOT covered by the stone
  // texture (i.e., non-floor faces, or the floor when texture is also off).
  if (texFlags.showCubeMap != 0u && (texFlags.showTexture == 0u || faceIdx != FACE_FLOOR)) {
    return textureSampleLevel(envMap, texSampler, worldRdir, 0.0);
  }

  // Tiled UV for this face (×4 repeats across each face)
  let tileScale = 4.0;
  let faceUV    = computeUV(faceIdx, localHit) * tileScale;

  // ── Part 1: Material mapping ─────────────────────────────────────────────────
  // Modulate diffuse colour with the stone texture on the floor face.
  // Other faces retain their Phong material colour.
  var diffuseCol = boxDiffuseColor(faceIdx);
  if (texFlags.showTexture != 0u && faceIdx == FACE_FLOOR) {
    diffuseCol = textureSampleLevel(floorTex, texSampler, faceUV, 0.0);
  }

  // ── Part 2: Bump mapping ──────────────────────────────────────────────────────
  // Perturb the surface normal using finite differences on the stone texture
  // luminance, making the surface appear to have micro-relief geometry.
  var normal = boxNormal(faceIdx);
  if (texFlags.showBump != 0u) {
    normal = computeBumpNormal(faceIdx, faceUV);
  }
  normal = transformNormal(normal);

  let emit = boxEmitColor();

  let lightPos  = applyMotorToPoint(light.position.xyz,  reverse(cameraPose.motor));
  let lightDir  = applyMotorToDir(light.direction.xyz,   reverse(cameraPose.motor));
  var hitPt     = localHit;
  hitPt         = transformHitPoint(hitPt);
  var lightInfo = getLightInfo(lightPos, lightDir, hitPt);

  // ── Part 1: Shadow computation ────────────────────────────────────────────────
  // Skip the ceiling face to avoid self-shadowing artefacts — the light is
  // positioned near the ceiling, so any floating-point offset can cause the
  // ceiling to incorrectly shadow itself.
  if (shadowFlags.enabled != 0u && faceIdx != FACE_TOP) {
    // Transform light position and direction into box-local space so the shadow
    // ray can be tested with rayBoxIntersection (which works in local coords).
    let lightPosLocal = applyMotorToPoint(lightPos, reverse(box.motor)) / box.scale.xyz;
    let lightDirLocal = normalize(applyMotorToDir(lightDir, reverse(box.motor)) / box.scale.xyz);
    let lightType     = i32(light.params[2]);
    var shadowFactor: f32;
    if (shadowFlags.mode == 0u) {
      shadowFactor = computeHardShadow(localHit, lightPosLocal, lightDirLocal, lightType);
    } else {
      shadowFactor = computeSoftShadow(localHit, lightPosLocal, lightDirLocal, lightType, uv);
    }
    lightInfo.intensity *= shadowFactor;
  }

  let camPos = applyMotorToPoint(vec3f(0, 0, 0), cameraPose.motor);

  return shadeSurface(emit, diffuseCol, normal, lightInfo, camPos, hitPt);
}

// ── Sphere shading ────────────────────────────────────────────────────────────
// Applies Phong lighting and shadows to a sphere hit.  Spheres are defined in
// box-local space so they can cast shadows on the floor and walls.
fn shadeSphereHit(spt: vec3f, rdir: vec3f, t: f32, sphereIdx: i32, uv: vec2i) -> vec4f {
  let localHit = spt + rdir * t;

  // Per-sphere material
  var center:     vec3f;
  var radius:     f32;
  var diffuseCol: vec4f;
  if (sphereIdx == 0) {
    center     = SPHERE0_CENTER;
    radius     = SPHERE0_RADIUS;
    diffuseCol = vec4f(0.90, 0.40, 0.10, 1.0); // warm orange
  } else {
    center     = SPHERE1_CENTER;
    radius     = SPHERE1_RADIUS;
    diffuseCol = vec4f(0.20, 0.55, 0.90, 1.0); // cool blue
  }

  // Outward surface normal: local-space → world-space
  let localNormal = normalize(localHit - center);
  let normal      = transformNormal(localNormal);

  let hitPt     = transformHitPoint(localHit);
  let lightPos  = applyMotorToPoint(light.position.xyz, reverse(cameraPose.motor));
  let lightDir  = applyMotorToDir(light.direction.xyz,  reverse(cameraPose.motor));
  var lightInfo = getLightInfo(lightPos, lightDir, hitPt);

  // Shadow computation (same pipeline as the box, but originating on the sphere)
  if (shadowFlags.enabled != 0u) {
    let lightPosLocal = applyMotorToPoint(lightPos, reverse(box.motor)) / box.scale.xyz;
    let lightDirLocal = normalize(applyMotorToDir(lightDir, reverse(box.motor)) / box.scale.xyz);
    let lightType     = i32(light.params[2]);
    var shadowFactor: f32;
    if (shadowFlags.mode == 0u) {
      shadowFactor = computeHardShadow(localHit, lightPosLocal, lightDirLocal, lightType);
    } else {
      shadowFactor = computeSoftShadow(localHit, lightPosLocal, lightDirLocal, lightType, uv);
    }
    lightInfo.intensity *= shadowFactor;
  }

  let camPos = applyMotorToPoint(vec3f(0, 0, 0), cameraPose.motor);
  return shadeSurface(vec4f(0, 0, 0, 1), diffuseCol, normal, lightInfo, camPos, hitPt);
}

// ── Orthographic camera entry point ──────────────────────────────────────────
@compute @workgroup_size(16, 16)
fn computeOrthogonalMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x >= texDim.x || uv.y >= texDim.y) { return; }

  let psize = vec2f(2, 2) / cameraPose.res.xy;
  var spt   = vec3f((f32(uv.x) + 0.5) * psize.x - 1,
                    (f32(uv.y) + 0.5) * psize.y - 1, 0);
  var rdir  = vec3f(0, 0, 1);
  spt  = transformPt(spt);
  rdir = transformDir(rdir);

  let boxHit = rayBoxIntersection(spt, rdir);
  let sphHit = closestSphereHit(spt, rdir);
  var color  = vec4f(0./255, 56./255, 101./255, 1.); // Bucknell Blue background

  if (sphHit.x > 0.0 && (boxHit.x < 0.0 || sphHit.x < boxHit.x)) {
    color = shadeSphereHit(spt, rdir, sphHit.x, i32(sphHit.y), uv);
  } else if (boxHit.x > 0.0) {
    color = shadeHit(spt, rdir, boxHit, uv);
  }

  textureStore(outTexture, uv, color);
}

// ── Projective (pinhole) camera entry point ───────────────────────────────────
@compute @workgroup_size(16, 16)
fn computeProjectiveMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x >= texDim.x || uv.y >= texDim.y) { return; }

  let psize = vec2f(2, 2) / (cameraPose.res.xy * cameraPose.focal);
  var spt   = vec3f(0, 0, 0);
  var rdir  = normalize(vec3f(
    (f32(uv.x) + 0.5) * psize.x - 1.0 / cameraPose.focal.x,
    (f32(uv.y) + 0.5) * psize.y - 1.0 / cameraPose.focal.y,
    1.0
  ));
  spt  = transformPt(spt);
  rdir = transformDir(rdir);

  let boxHit = rayBoxIntersection(spt, rdir);
  let sphHit = closestSphereHit(spt, rdir);
  var color  = vec4f(0./255, 56./255, 101./255, 1.); // Bucknell Blue background

  if (sphHit.x > 0.0 && (boxHit.x < 0.0 || sphHit.x < boxHit.x)) {
    color = shadeSphereHit(spt, rdir, sphHit.x, i32(sphHit.y), uv);
  } else if (boxHit.x > 0.0) {
    color = shadeHit(spt, rdir, boxHit, uv);
  }

  textureStore(outTexture, uv, color);
}
