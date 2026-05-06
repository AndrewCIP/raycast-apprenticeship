/*
 * Project 9 — Shadows, Reflections & Refractions
 *
 * Shadow techniques
 *   SHADOW_HARD (0) – binary shadow-ray test
 *   SHADOW_AREA (1) – area-light sampling (8 samples, point light)
 *   SHADOW_PCF  (2) – Percentage-Closer Filtering (8 jittered rays, directional)
 *   SHADOW_DIST (3) – distance-based penumbra (spotlight)
 *   SHADOW_SDF  (4) – Signed Distance Field (Iñigo Quilez sphere-trace, any light)
 *
 * Reflection modes
 *   REFLECT_OFF    (0) – all reflective surfaces appear diffuse
 *   REFLECT_SINGLE (1) – exactly one mirror / floor bounce
 *   REFLECT_MULTI  (2) – up to maxBounces bounces
 *
 * Refraction modes
 *   REFRACT_OFF    (0) – glass sphere appears as an opaque tinted sphere
 *   REFRACT_SINGLE (1) – one Snell's Law refraction bounce
 *   REFRACT_MULTI  (2) – up to maxBounces refraction bounces
 *
 * Scene object IDs
 *   0–5 : box faces  (face 4 = ceiling, face 5 = floor)
 *   6   : glass sphere (IOR 1.5) — placed on the reflective floor
 *   7   : mirror sphere (perfect reflector)
 *   8   : opaque sphere (Phong diffuse, orange) — primary shadow caster
 */

// ── 3-D PGA multivector ────────────────────────────────────────────────────────
struct MultiVector {
  s: f32, exey: f32, exez: f32, eyez: f32,
  eoex: f32, eoey: f32, eoez: f32, exeyez: f32,
  eoexey: f32, eoexez: f32, eoeyez: f32,
  ex: f32, ey: f32, ez: f32, eo: f32, eoexeyez: f32,
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
  return sqrt(m.s*m.s + m.exey*m.exey + m.exez*m.exez + m.eyez*m.eyez
            + m.eoex*m.eoex + m.eoey*m.eoey + m.eoez*m.eoez + m.exeyez*m.exeyez
            + m.eoexey*m.eoexey + m.eoexez*m.eoexez + m.eoeyez*m.eoeyez
            + m.ex*m.ex + m.ey*m.ey + m.ez*m.ez + m.eo*m.eo + m.eoexeyez*m.eoexeyez);
}

fn normalizeMotor(m: MultiVector) -> MultiVector {
  let n = motorNorm(m);
  if (n == 0.0) { return MultiVector(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); }
  return MultiVector(m.s/n, m.exey/n, m.exez/n, m.eyez/n, m.eoex/n, m.eoey/n, m.eoez/n,
                     m.exeyez/n, m.eoexey/n, m.eoexez/n, m.eoeyez/n,
                     m.ex/n, m.ey/n, m.ez/n, m.eo/n, m.eoexeyez/n);
}

fn createDir(d: vec3f) -> MultiVector {
  return MultiVector(0., d.z, -d.y, d.x, 0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.);
}

fn createLine(s: vec3f, d: vec3f) -> MultiVector {
  let dir = normalizeMotor(createDir(d));
  return MultiVector(0., dir.exey, dir.exez, dir.eyez,
                     -(-dir.exez*s.z - dir.exey*s.y),
                     -(dir.exey*s.x - dir.eyez*s.z),
                     -(dir.eyez*s.y + dir.exez*s.x),
                     0., 0., 0., 0., 0., 0., 0., 0., 0.);
}

fn extractRotor(m: MultiVector) -> MultiVector {
  return MultiVector(m.s, m.exey, m.exez, m.eyez, 0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.);
}

fn createPoint(p: vec3f) -> MultiVector {
  return MultiVector(0.,0.,0.,0.,0.,0.,0.,1., -p.z, p.y, -p.x, 0.,0.,0.,0.,0.);
}

fn extractPoint(p: MultiVector) -> vec3f {
  return vec3f(-p.eoeyez / p.exeyez, p.eoexez / p.exeyez, -p.eoexey / p.exeyez);
}

fn createPlaneFromPoints(p1: vec3f, p2: vec3f, p3: vec3f) -> MultiVector {
  let nx = (p2.y*p3.z - p3.y*p2.z) - (p1.y*p3.z - p3.y*p1.z) + (p1.y*p2.z - p2.y*p1.z);
  let ny = (p2.x*p3.z - p3.x*p2.z) - (p1.x*p3.z - p3.x*p1.z) + (p1.x*p2.z - p2.x*p1.z);
  let nz = (p2.x*p3.y - p3.x*p2.y) - (p1.x*p3.y - p3.x*p1.y) + (p1.x*p2.y - p2.x*p1.y);
  let d  = p1.x*(p2.y*p3.z - p3.y*p2.z) - p2.x*(p1.y*p3.z - p3.y*p1.z) + p3.x*(p1.y*p2.z - p2.y*p1.z);
  return MultiVector(0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0., nx, -ny, nz, -d, 0.);
}

fn applyMotorToPoint(p: vec3f, m: MultiVector) -> vec3f {
  return extractPoint(applyMotor(createPoint(p), m));
}

fn applyMotorToDir(d: vec3f, m: MultiVector) -> vec3f {
  return extractPoint(applyMotor(createPoint(d), extractRotor(m)));
}

// ── Line-plane intersection helper ─────────────────────────────────────────────
const EPSILON: f32 = 0.000001;

struct HitInfo { p: vec3f, hit: bool, inPlane: bool, }

fn linePlaneIntersection(L: MultiVector, P: MultiVector) -> HitInfo {
  let new_p = geometricProduct(L, P);
  var hi: HitInfo;
  hi.p       = extractPoint(new_p);
  hi.hit     = !(abs(new_p.exeyez) <= EPSILON);
  hi.inPlane = hi.hit && abs(new_p.eoexey) <= EPSILON && abs(new_p.eoexez) <= EPSILON && abs(new_p.eoeyez) <= EPSILON;
  return hi;
}

// ── GPU bindings ───────────────────────────────────────────────────────────────
struct Camera { motor: MultiVector, focal: vec2f, res: vec2f, }
struct Quad   { ll: vec4f, lr: vec4f, ur: vec4f, rl: vec4f, }
struct Box    { motor: MultiVector, scale: vec4f, faces: array<Quad, 6>, }

struct GpuLight {
  intensity:   vec4f,
  position:    vec4f,   // camera-space  (w unused)
  direction:   vec4f,   // camera-space  (w unused)
  attenuation: vec4f,   // k0, k1, k2
  params:      vec4f,   // [0]=cutoff [1]=dropoff [2]=lightType [3]=shadingModel
}

struct RenderFlags {
  shadowEnabled: u32,  // 0=off  1=on
  shadowMode:    u32,  // 0=hard 1=area 2=PCF 3=dist 4=SDF
  reflectMode:   u32,  // 0=off  1=single 2=multi
  refractMode:   u32,  // 0=off  1=single 2=multi
  shadowTransp:  u32,  // 0=off  1=glass casts partial shadow
  maxBounces:    u32,  // 0–8   (total extra bounces allowed)
  pad0:          u32,
  pad1:          u32,
}

@group(0) @binding(0) var<uniform> cameraPose:  Camera;
@group(0) @binding(1) var<uniform> box:         Box;
@group(0) @binding(2) var outTexture: texture_storage_2d<rgba8unorm, write>;
@group(0) @binding(3) var<uniform> gpuLight:    GpuLight;
@group(0) @binding(4) var<uniform> renderFlags: RenderFlags;

// ── Scene sphere constants ──────────────────────────────────────────────────────
// All positions are in box-local space (box faces sit at ±0.5).
// Spheres are positioned so their bottoms graze the floor at y = −0.5.
const GLASS_CENTER:  vec3f = vec3f( 0.00, -0.28,  0.05);  // large glass sphere (r=0.20)
const GLASS_RADIUS:  f32   = 0.20;
const MIRROR_CENTER: vec3f = vec3f(-0.28, -0.38, -0.05);  // small mirror sphere (r=0.10)
const MIRROR_RADIUS: f32   = 0.10;
const OPAQUE_CENTER: vec3f = vec3f( 0.28, -0.40,  0.08);  // opaque orange sphere (r=0.08)
const OPAQUE_RADIUS: f32   = 0.08;

// Object-ID constants (0–5 reserved for box faces)
const GLASS_OBJ_ID:  i32 = 6;
const MIRROR_OBJ_ID: i32 = 7;
const OPAQUE_OBJ_ID: i32 = 8;

// Material-type constants
const MAT_DIFFUSE: i32 = 0;   // Lambertian / Phong diffuse (box walls, opaque sphere)
const MAT_MIRROR:  i32 = 1;   // perfect reflector
const MAT_GLASS:   i32 = 2;   // refractive glass, IOR = GLASS_IOR
const MAT_FLOOR:   i32 = 3;   // partially reflective floor (60 % reflectivity)

const FACE_CEIL:  i32 = 4;
const FACE_FLOOR: i32 = 5;
const GLASS_IOR:  f32 = 1.5;

// ── Hit record ─────────────────────────────────────────────────────────────────
struct HitRec {
  t:     f32,
  objId: i32,   // −1 = miss;  0–5 = box face;  6/7/8 = sphere
  p:     vec3f, // box-local hit point
  n:     vec3f, // box-local normal, always pointing AGAINST the incoming ray
}

// ── Camera / box transforms ────────────────────────────────────────────────────
fn transformDir(d: vec3f) -> vec3f {
  var out = applyMotorToDir(d, cameraPose.motor);
  out = applyMotorToDir(out, reverse(box.motor));
  return out / box.scale.xyz;
}

fn transformPt(pt: vec3f) -> vec3f {
  var out = applyMotorToPoint(pt, cameraPose.motor);
  out = applyMotorToPoint(out, reverse(box.motor));
  return out / box.scale.xyz;
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

// ── Box-face intersection (identical to scroll-15) ─────────────────────────────
fn quadRayHitCheck(s: vec3f, d: vec3f, q: Quad, ct: f32) -> vec2f {
  let L  = createLine(s, d);
  let P  = createPlaneFromPoints(q.ll.xyz, q.lr.xyz, q.ur.xyz);
  var hi = linePlaneIntersection(L, P);
  if (hi.hit) {
    if      (abs(q.ll.z - q.ur.z) <= EPSILON) {
      hi.hit = (q.ll.x <= hi.p.x && hi.p.x <= q.ur.x) && (q.ll.y <= hi.p.y && hi.p.y <= q.ur.y);
    } else if (abs(q.ll.y - q.ur.y) <= EPSILON) {
      hi.hit = (q.ll.x <= hi.p.x && hi.p.x <= q.ur.x) && (q.ll.z <= hi.p.z && hi.p.z <= q.ur.z);
    } else if (abs(q.ll.x - q.ur.x) <= EPSILON) {
      hi.hit = (q.ll.y <= hi.p.y && hi.p.y <= q.ur.y) && (q.ll.z <= hi.p.z && hi.p.z <= q.ur.z);
    }
    if (hi.hit) {
      var nt: f32 = -1.;
      if      (d.x > EPSILON) { nt = (hi.p.x - s.x) / d.x; }
      else if (d.y > EPSILON) { nt = (hi.p.y - s.y) / d.y; }
      else                    { nt = (hi.p.z - s.z) / d.z; }
      if      (nt < 0.)  { return vec2f(ct, -1.); }
      else if (ct < 0.)  { return vec2f(nt,  1.); }
      else if (nt < ct)  { return vec2f(nt,  1.); }
      else               { return vec2f(ct, -1.); }
    }
  }
  return vec2f(ct, -1.);
}

fn rayBoxIntersection(s: vec3f, d: vec3f) -> vec2f {
  var t = -1.; var idx = -1.;
  for (var i = 0; i < 6; i++) {
    let info = quadRayHitCheck(s, d, box.faces[i], t);
    if (info.y > 0.) { t = info.x; idx = f32(i); }
  }
  return vec2f(t, idx);
}

// ── Sphere intersection ────────────────────────────────────────────────────────
// Returns the nearest positive t, or −1 if no hit.
fn raySphereIntersect(orig: vec3f, dir: vec3f, center: vec3f, radius: f32) -> f32 {
  let oc   = orig - center;
  let b    = dot(oc, dir);
  let c    = dot(oc, oc) - radius * radius;
  let disc = b * b - c;
  if (disc < 0.) { return -1.; }
  let sq = sqrt(disc);
  let t0 = -b - sq;
  if (t0 > 0.) { return t0; }
  let t1 = -b + sq;
  if (t1 > 0.) { return t1; }
  return -1.;
}

// ── Box-face inward normals (corrected for interior Cornell-box rendering) ──────
fn boxFaceNormal(idx: i32) -> vec3f {
  switch(idx) {
    case 0:  { return vec3f( 0.,  0., -1.); }  // front wall  (z = +0.5)
    case 1:  { return vec3f( 0.,  0.,  1.); }  // back wall   (z = −0.5)
    case 2:  { return vec3f( 1.,  0.,  0.); }  // left wall   (x = −0.5)
    case 3:  { return vec3f(-1.,  0.,  0.); }  // right wall  (x = +0.5)
    case 4:  { return vec3f( 0., -1.,  0.); }  // ceiling     (y = +0.5)
    case 5:  { return vec3f( 0.,  1.,  0.); }  // floor       (y = −0.5)
    default: { return vec3f( 0.,  0.,  0.); }
  }
}

// ── Full-scene intersection ────────────────────────────────────────────────────
fn intersectScene(orig: vec3f, dir: vec3f, tMin: f32) -> HitRec {
  var bestT   = -1.;
  var bestObj = -1;

  // Box faces
  let boxHit = rayBoxIntersection(orig, dir);
  if (boxHit.x > tMin) { bestT = boxHit.x; bestObj = i32(boxHit.y); }

  // Glass sphere
  let tG = raySphereIntersect(orig, dir, GLASS_CENTER,  GLASS_RADIUS);
  if (tG > tMin && (bestT < 0. || tG < bestT)) { bestT = tG; bestObj = GLASS_OBJ_ID; }

  // Mirror sphere
  let tM = raySphereIntersect(orig, dir, MIRROR_CENTER, MIRROR_RADIUS);
  if (tM > tMin && (bestT < 0. || tM < bestT)) { bestT = tM; bestObj = MIRROR_OBJ_ID; }

  // Opaque sphere
  let tO = raySphereIntersect(orig, dir, OPAQUE_CENTER, OPAQUE_RADIUS);
  if (tO > tMin && (bestT < 0. || tO < bestT)) { bestT = tO; bestObj = OPAQUE_OBJ_ID; }

  if (bestT < 0.) { return HitRec(-1., -1, vec3f(0.), vec3f(0.)); }

  let p = orig + dir * bestT;

  // Surface normal (geometric outward for spheres, corrected inward for box)
  var n: vec3f;
  switch(bestObj) {
    case 6:  { n = normalize(p - GLASS_CENTER);  }
    case 7:  { n = normalize(p - MIRROR_CENTER); }
    case 8:  { n = normalize(p - OPAQUE_CENTER); }
    default: { n = boxFaceNormal(bestObj); }
  }

  // Flip so the normal always points AGAINST the incoming ray direction
  if (dot(n, dir) > 0.) { n = -n; }

  return HitRec(bestT, bestObj, p, n);
}

// ── Material from object ID ────────────────────────────────────────────────────
fn getMaterial(objId: i32) -> i32 {
  if (objId == GLASS_OBJ_ID)  { return MAT_GLASS;  }
  if (objId == MIRROR_OBJ_ID) { return MAT_MIRROR; }
  if (objId == FACE_FLOOR)    { return MAT_FLOOR;  }
  return MAT_DIFFUSE;
}

// ── Surface diffuse colour ─────────────────────────────────────────────────────
fn getSurfaceColor(objId: i32) -> vec4f {
  switch(objId) {
    case 0:  { return vec4f(0.80, 0.80, 0.85, 1.); }  // front: cool grey-blue
    case 1:  { return vec4f(0.80, 0.80, 0.85, 1.); }  // back:  same
    case 2:  { return vec4f(0.18, 0.62, 0.22, 1.); }  // left:  green (Cornell)
    case 3:  { return vec4f(0.65, 0.15, 0.15, 1.); }  // right: red   (Cornell)
    case 4:  { return vec4f(0.88, 0.88, 0.88, 1.); }  // ceiling: light grey
    case 5:  { return vec4f(0.75, 0.75, 0.75, 1.); }  // floor: grey (reflective)
    case 8:  { return vec4f(0.92, 0.52, 0.10, 1.); }  // opaque sphere: orange
    default: { return vec4f(0.70, 0.70, 0.70, 1.); }
  }
}

// ── PCG random-number generator ────────────────────────────────────────────────
fn pcg(v: u32) -> u32 {
  let state = v * 747796405u + 2891336453u;
  let word  = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
  return (word >> 22u) ^ word;
}

fn rand(uv: vec2i, sampleIdx: u32) -> f32 {
  let seed = u32(uv.x) * 1973u + u32(uv.y) * 9277u + sampleIdx * 26699u;
  return f32(pcg(seed)) / 4294967295.0;
}

// ── SDF for scene spheres ──────────────────────────────────────────────────────
// includeGlass=true means the glass sphere is treated as a solid occluder.
fn sceneSDF(p: vec3f, includeGlass: bool) -> f32 {
  var d = length(p - MIRROR_CENTER) - MIRROR_RADIUS;
  d = min(d, length(p - OPAQUE_CENTER) - OPAQUE_RADIUS);
  if (includeGlass) { d = min(d, length(p - GLASS_CENTER) - GLASS_RADIUS); }
  return d;
}

// ── Core shadow-ray: returns a factor in [0.1, 1.0] ───────────────────────────
// 1.0 = fully lit   0.1 = fully blocked   0.5 = partially blocked (glass, if transparent)
fn shadowRayFactor(localOrig: vec3f, dir: vec3f, maxDist: f32) -> f32 {
  let o = localOrig + dir * 0.004;

  // Opaque objects block all light
  let tM = raySphereIntersect(o, dir, MIRROR_CENTER, MIRROR_RADIUS);
  if (tM > 0. && tM < maxDist) { return 0.1; }

  let tO = raySphereIntersect(o, dir, OPAQUE_CENTER, OPAQUE_RADIUS);
  if (tO > 0. && tO < maxDist) { return 0.1; }

  // Box face (only relevant when light is near a wall — keeps interior lit)
  let boxHit = rayBoxIntersection(o, dir);
  if (boxHit.x > 0. && boxHit.x < maxDist) { return 0.1; }

  // Glass sphere: partial or full block depending on the transparent-shadow flag
  let tG = raySphereIntersect(o, dir, GLASS_CENTER, GLASS_RADIUS);
  if (tG > 0. && tG < maxDist) {
    return select(0.1, 0.5, renderFlags.shadowTransp != 0u);
  }

  return 1.0;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shadow technique  0 – Hard shadows (binary shadow ray)
// ─────────────────────────────────────────────────────────────────────────────
fn computeHardShadow(localHit: vec3f, lightPosLocal: vec3f, lightDirLocal: vec3f, lightType: i32) -> f32 {
  if (lightType == 1) {
    // Directional light: ray goes toward −lightDir, effectively infinite distance
    return shadowRayFactor(localHit, -lightDirLocal, 1000000.0);
  }
  // Point light or spotlight
  let toLight = lightPosLocal - localHit;
  let dist    = length(toLight);
  if (dist < 0.001) { return 1.0; }
  return shadowRayFactor(localHit, toLight / dist, dist);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shadow technique  1 – Area-light soft shadows
//  Jitters the point-light position over a spherical area (8 samples).
//  Falls back to hard shadow for non-point lights.
// ─────────────────────────────────────────────────────────────────────────────
fn computeAreaShadow(localHit: vec3f, lightPosLocal: vec3f, lightDirLocal: vec3f,
                     lightType: i32, uv: vec2i) -> f32 {
  if (lightType != 0) {
    return computeHardShadow(localHit, lightPosLocal, lightDirLocal, lightType);
  }
  let areaRadius = 0.10;   // virtual source radius in box-local units
  var acc = 0.0;
  for (var i: i32 = 0; i < 8; i++) {
    let rx = (rand(uv, u32(i*3    )) - 0.5) * 2.0 * areaRadius;
    let ry = (rand(uv, u32(i*3 + 1)) - 0.5) * 2.0 * areaRadius;
    let rz = (rand(uv, u32(i*3 + 2)) - 0.5) * 2.0 * areaRadius;
    let sp = lightPosLocal + vec3f(rx, ry, rz);
    let ts = sp - localHit;
    let d  = length(ts);
    if (d < 0.001) { acc += 1.0; continue; }
    acc += shadowRayFactor(localHit, ts / d, d);
  }
  return acc / 8.0;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shadow technique  2 – Percentage-Closer Filtering (PCF)
//  Jitters the shadow-ray direction in a small cone (8 samples).
//  Designed for directional lights; falls back to hard shadow for others.
// ─────────────────────────────────────────────────────────────────────────────
fn computePCFShadow(localHit: vec3f, lightPosLocal: vec3f, lightDirLocal: vec3f,
                    lightType: i32, uv: vec2i) -> f32 {
  if (lightType != 1) {
    return computeHardShadow(localHit, lightPosLocal, lightDirLocal, lightType);
  }
  let pcfRadius = 0.05;   // angular spread (in local-space units)
  var tangent: vec3f;
  if (abs(lightDirLocal.x) < 0.9) { tangent = normalize(cross(lightDirLocal, vec3f(1., 0., 0.))); }
  else                             { tangent = normalize(cross(lightDirLocal, vec3f(0., 1., 0.))); }
  let bitan = cross(lightDirLocal, tangent);
  var acc = 0.0;
  for (var i: i32 = 0; i < 8; i++) {
    let ox = (rand(uv, u32(i*2 + 200)) - 0.5) * 2.0 * pcfRadius;
    let oy = (rand(uv, u32(i*2 + 201)) - 0.5) * 2.0 * pcfRadius;
    let sd = normalize(-lightDirLocal + tangent * ox + bitan * oy);
    acc += shadowRayFactor(localHit, sd, 1000000.0);
  }
  return acc / 8.0;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shadow technique  3 – Distance-based soft shadows
//  Penumbra darkens smoothly based on how close the nearest occluder is
//  relative to the total light distance (designed for spotlights).
// ─────────────────────────────────────────────────────────────────────────────
fn computeDistShadow(localHit: vec3f, lightPosLocal: vec3f, lightDirLocal: vec3f,
                     lightType: i32) -> f32 {
  if (lightType != 2) {
    return computeHardShadow(localHit, lightPosLocal, lightDirLocal, lightType);
  }
  let toLight = lightPosLocal - localHit;
  let dist    = length(toLight);
  if (dist < 0.001) { return 1.0; }
  let dir = toLight / dist;
  let o   = localHit + dir * 0.004;

  var occT = -1.0;
  let tG = raySphereIntersect(o, dir, GLASS_CENTER,  GLASS_RADIUS);
  let tM = raySphereIntersect(o, dir, MIRROR_CENTER, MIRROR_RADIUS);
  let tO = raySphereIntersect(o, dir, OPAQUE_CENTER, OPAQUE_RADIUS);

  if (tG > 0. && tG < dist)                        { occT = tG; }
  if (tM > 0. && tM < dist && (occT < 0. || tM < occT)) { occT = tM; }
  if (tO > 0. && tO < dist && (occT < 0. || tO < occT)) { occT = tO; }

  if (occT > 0.) {
    // Occluder at occT/dist of the way → smooth penumbra
    return max(pow(min(occT / dist, 1.0), 0.6), 0.1);
  }
  return 1.0;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shadow technique  4 – SDF soft shadows  (Iñigo Quilez sphere-trace method)
//  Sphere-traces toward the light, accumulating how close the ray passes to
//  any occluder.  k controls softness (higher = sharper penumbra).
// ─────────────────────────────────────────────────────────────────────────────
fn computeSDFShadow(localHit: vec3f, lightPosLocal: vec3f, lightDirLocal: vec3f,
                    lightType: i32) -> f32 {
  var toLight: vec3f;
  var tMax:    f32;
  if (lightType == 1) {
    toLight = -lightDirLocal;
    tMax    = 1000000.0;
  } else {
    let v = lightPosLocal - localHit;
    tMax = length(v);
    if (tMax < 0.001) { return 1.0; }
    toLight = v / tMax;
  }

  let k            = 16.0;   // softness — higher = sharper transitions
  let includeGlass = renderFlags.shadowTransp == 0u;
  var shadow       = 1.0;
  var t            = 0.02;
  for (var i: i32 = 0; i < 64; i++) {
    let d = sceneSDF(localHit + t * toLight, includeGlass);
    if (d < 0.0002) { return 0.1; }
    shadow = min(shadow, k * d / t);
    t += max(d, 0.005);
    if (t >= tMax) { break; }
  }
  return clamp(shadow, 0.1, 1.0);
}

// ── Unified shadow dispatch ────────────────────────────────────────────────────
fn computeShadow(localHit: vec3f, lightPosLocal: vec3f, lightDirLocal: vec3f,
                 lightType: i32, uv: vec2i) -> f32 {
  if (renderFlags.shadowEnabled == 0u) { return 1.0; }
  switch(i32(renderFlags.shadowMode)) {
    case 1:  { return computeAreaShadow(localHit, lightPosLocal, lightDirLocal, lightType, uv); }
    case 2:  { return computePCFShadow (localHit, lightPosLocal, lightDirLocal, lightType, uv); }
    case 3:  { return computeDistShadow(localHit, lightPosLocal, lightDirLocal, lightType); }
    case 4:  { return computeSDFShadow (localHit, lightPosLocal, lightDirLocal, lightType); }
    default: { return computeHardShadow(localHit, lightPosLocal, lightDirLocal, lightType); }
  }
}

// ── Light information (same layout as scroll-15) ───────────────────────────────
struct LightInfo { intensity: vec4f, lightdir: vec3f, }

fn getLightInfo(lightPos: vec3f, lightDir: vec3f, hitPoint: vec3f) -> LightInfo {
  var out: LightInfo;
  let lightType = i32(gpuLight.params[2]);

  if (lightType == 1) {
    // Directional
    out.intensity = gpuLight.intensity;
    out.lightdir  = normalize(lightDir);

  } else if (lightType == 2) {
    // Spotlight
    let toSurface = normalize(hitPoint - lightPos);
    let cosAngle  = dot(normalize(lightDir), toSurface);
    let cutoff    = gpuLight.params[0];
    let dropoff   = gpuLight.params[1];
    if (cosAngle > cos(cutoff)) {
      let spotFactor = pow(cosAngle, dropoff);
      let d     = length(hitPoint - lightPos);
      let atten = gpuLight.attenuation[0] + d*gpuLight.attenuation[1] + d*d*gpuLight.attenuation[2];
      out.intensity = gpuLight.intensity * spotFactor / atten;
    } else {
      out.intensity = vec4f(0.);
    }
    out.lightdir = toSurface;

  } else {
    // Point light (default)
    let toSurface = normalize(hitPoint - lightPos);
    let d     = length(hitPoint - lightPos);
    let atten = gpuLight.attenuation[0] + d*gpuLight.attenuation[1] + d*d*gpuLight.attenuation[2];
    out.intensity = gpuLight.intensity / atten;
    out.lightdir  = toSurface;
  }
  return out;
}

// ── Toon-shade quantiser ──────────────────────────────────────────────────────
fn toonQ(v: f32) -> f32 {
  if      (v < 0.10) { return 0.00; }
  else if (v < 0.35) { return 0.20; }
  else if (v < 0.65) { return 0.50; }
  else if (v < 0.90) { return 0.80; }
  else               { return 1.00; }
}

// ── Phong / Lambert / Toon shading ────────────────────────────────────────────
fn shadeSurface(emit: vec4f, diffCol: vec4f, normal: vec3f,
                li: LightInfo, camPos: vec3f, hitPt: vec3f) -> vec4f {
  let l  = li.lightdir;
  let I  = li.intensity;
  let sm = i32(gpuLight.params[3]);
  let dt = max(dot(normal, -l), 0.0);
  let ka = vec4f(0.08, 0.08, 0.08, 0.);

  if (sm == 1) {
    // Phong
    let R  = reflect(l, normal);
    let vd = normalize(camPos - hitPt);
    let sp = pow(max(dot(vd, -R), 0.0), 64.0);
    let ks = vec4f(0.4, 0.4, 0.4, 0.);
    return emit + diffCol * I * dt + ks * I * sp + ka * I;

  } else if (sm == 2) {
    // Toon
    let R  = reflect(l, normal);
    let vd = normalize(camPos - hitPt);
    let sp = pow(max(dot(vd, -R), 0.0), 64.0);
    let ks = vec4f(0.4, 0.4, 0.4, 0.);
    return emit + diffCol * I * toonQ(dt) + ks * I * toonQ(sp) + ka * I;

  } else {
    // Lambert
    return emit + diffCol * I * dt + ka * I;
  }
}

// ── Direct illumination at a hit point ────────────────────────────────────────
fn shadeHitDirect(hit: HitRec, uv: vec2i) -> vec4f {
  let matType = getMaterial(hit.objId);

  // Choose diffuse colour based on material and active modes
  var diffCol: vec4f;
  if (matType == MAT_GLASS) {
    // Refraction ON → nearly clear glass; OFF → opaque tinted blue
    diffCol = select(vec4f(0.20, 0.55, 0.80, 1.), vec4f(0.88, 0.95, 1.00, 1.),
                     renderFlags.refractMode != 0u);
  } else if (matType == MAT_MIRROR) {
    // Reflection ON → almost black base (scene reflected); OFF → silver grey
    diffCol = select(vec4f(0.70, 0.70, 0.75, 1.), vec4f(0.03, 0.03, 0.03, 1.),
                     renderFlags.reflectMode != 0u);
  } else {
    diffCol = getSurfaceColor(hit.objId);
  }

  // World-space light
  let lightPos   = applyMotorToPoint(gpuLight.position.xyz,  reverse(cameraPose.motor));
  let lightDir   = applyMotorToDir( gpuLight.direction.xyz,  reverse(cameraPose.motor));
  let hitPtWorld = transformHitPoint(hit.p);
  var lightInfo  = getLightInfo(lightPos, lightDir, hitPtWorld);

  // Shadow test (skip ceiling face to avoid self-shadowing near the interior light)
  if (hit.objId != FACE_CEIL) {
    let lpl = applyMotorToPoint(lightPos, reverse(box.motor)) / box.scale.xyz;
    let ldl = normalize(applyMotorToDir(lightDir, reverse(box.motor)) / box.scale.xyz);
    let sf  = computeShadow(hit.p, lpl, ldl, i32(gpuLight.params[2]), uv);
    lightInfo.intensity *= sf;
  }

  let normalWorld = transformNormal(hit.n);
  let camPosWorld = applyMotorToPoint(vec3f(0.), cameraPose.motor);
  return shadeSurface(vec4f(0.), diffCol, normalWorld, lightInfo, camPosWorld, hitPtWorld);
}

// ── Iterative ray tracer ───────────────────────────────────────────────────────
// Traces up to (renderFlags.maxBounces) additional bounces after the primary
// hit.  At each step the direct illumination is accumulated weighted by the
// current path throughput.  The ray continues for mirrors, refractive glass,
// and the partially reflective floor; diffuse surfaces terminate the path.
const MAX_BOUNCE_LIMIT: i32 = 8;

fn computeColor(rayOrig0: vec3f, rayDir0: vec3f, uv: vec2i) -> vec4f {
  let bgColor    = vec4f(0./255., 56./255., 101./255., 1.);  // Bucknell Blue
  var acc        = vec4f(0.);
  var throughput = vec4f(1.);
  var rayOrig    = rayOrig0;
  var rayDir     = rayDir0;
  let maxB       = min(i32(renderFlags.maxBounces), MAX_BOUNCE_LIMIT);

  for (var bounce = 0; bounce <= MAX_BOUNCE_LIMIT; bounce++) {
    let hit = intersectScene(rayOrig, rayDir, 0.003);

    if (hit.objId < 0) {
      // Ray escaped the scene — add background colour
      acc += throughput * bgColor;
      break;
    }

    // Direct illumination at this intersection
    acc += throughput * shadeHitDirect(hit, uv);

    // Stop if we've exhausted the allowed number of bounces
    if (bounce >= maxB) { break; }

    let matType = getMaterial(hit.objId);
    let refMode = i32(renderFlags.reflectMode);
    let rfrMode = i32(renderFlags.refractMode);

    if (matType == MAT_MIRROR && refMode > 0) {
      // ── Perfect mirror reflection ─────────────────────────────────────────
      rayDir  = reflect(rayDir, hit.n);
      rayOrig = hit.p + hit.n * 0.004;
      throughput *= 0.92;
      if (refMode == 1) { break; }  // SINGLE-bounce mode

    } else if (matType == MAT_GLASS && rfrMode > 0) {
      // ── Snell's Law refraction (with total-internal-reflection fallback) ──
      //
      // Determine entering/exiting by comparing the ray direction with the
      // geometric outward sphere normal.  hit.n always opposes rayDir.
      let outwardN = normalize(hit.p - GLASS_CENTER);
      let entering = dot(outwardN, rayDir) < 0.0;

      // eta = n_incident / n_transmitted
      let eta       = select(GLASS_IOR, 1.0 / GLASS_IOR, entering);
      // refract() requires the normal on the incident side, which is hit.n
      let refracted = refract(rayDir, hit.n, eta);

      if (dot(refracted, refracted) < 0.5) {
        // Total internal reflection
        rayDir  = reflect(rayDir, hit.n);
        rayOrig = hit.p + hit.n * 0.004;
      } else {
        rayDir  = normalize(refracted);
        // Move slightly across the surface into the new medium
        rayOrig = hit.p - hit.n * 0.004;
      }
      throughput *= 0.96;
      if (rfrMode == 1) { break; }  // SINGLE-bounce mode

    } else if (matType == MAT_FLOOR && refMode > 0) {
      // ── Partially reflective floor  (60 % reflectivity) ───────────────────
      rayDir  = reflect(rayDir, hit.n);
      rayOrig = hit.p + hit.n * 0.004;
      throughput *= 0.60;
      if (refMode == 1) { break; }  // SINGLE-bounce mode

    } else {
      // Diffuse surface — terminate the path
      break;
    }
  }

  return clamp(acc, vec4f(0.), vec4f(1.));
}

// ── Orthographic camera entry point ───────────────────────────────────────────
@compute @workgroup_size(16, 16)
fn computeOrthogonalMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x >= texDim.x || uv.y >= texDim.y) { return; }

  let psize = vec2f(2., 2.) / cameraPose.res.xy;
  var spt   = vec3f((f32(uv.x) + 0.5) * psize.x - 1.,
                    (f32(uv.y) + 0.5) * psize.y - 1., 0.);
  var rdir  = vec3f(0., 0., 1.);
  spt  = transformPt(spt);
  rdir = transformDir(rdir);
  textureStore(outTexture, uv, computeColor(spt, rdir, uv));
}

// ── Projective (pinhole) camera entry point ────────────────────────────────────
@compute @workgroup_size(16, 16)
fn computeProjectiveMain(@builtin(global_invocation_id) global_id: vec3u) {
  let uv     = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x >= texDim.x || uv.y >= texDim.y) { return; }

  let psize = vec2f(2., 2.) / (cameraPose.res.xy * cameraPose.focal);
  var spt   = vec3f(0., 0., 0.);
  var rdir  = normalize(vec3f(
    (f32(uv.x) + 0.5) * psize.x - 1.0 / cameraPose.focal.x,
    (f32(uv.y) + 0.5) * psize.y - 1.0 / cameraPose.focal.y,
    1.0
  ));
  spt  = transformPt(spt);
  rdir = transformDir(rdir);
  textureStore(outTexture, uv, computeColor(spt, rdir, uv));
}
