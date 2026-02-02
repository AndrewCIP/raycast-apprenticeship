// struct to store a multi vector
 struct MultiVector {
   s: f32,
   exey: f32,
   eoex: f32,
   eoey: f32
 };

 // struct to store 2D PGA pose
 struct Pose {
   motor: MultiVector,
   scale: vec2f
 };

 struct GridInfo {
  width: u32,
  height: u32
};

 @group(0) @binding(0) var<uniform> pose: Pose; // a uniform buffer describing the object pose
 @group(0) @binding(1) var<storage> cellStatusIn: array<u32>;
@group(0) @binding(2) var<storage, read_write> cellStatusOut: array<u32>;
@group(0) @binding(3) var<uniform> grid: GridInfo;

 fn geometricProduct(a: MultiVector, b: MultiVector) -> MultiVector {
   // Note, both points and motors are using scalar (1), exey, eoex, eoey
   // We don't need a full geometric product (all other coefficients are zeros)
   // ref: https://geometricalgebratutorial.com/pga/
   // The geometric product rules are:
   //   1. eoeo = 0, exex = 1 and eyey = 1
   //   2. eoex + exeo = 0, eoey + eyeo = 0 exey + eyex = 0
   // Then, we have the below product table
   // ss    = scalar , sexey                        = exey    , seoex                                  = eoex  , seoey                        = eoey
   // exeys = exey   , exeyexey = -eyexexey = -eyey = -scalar , exeyeoex = -exeyexeo = eyexexeo = eyeo = -eoey , exeyeoey = -exeoeyey = -exeo = eoex
   // eoexs = eoex   , eoexexey                     = eoey    , eoexeoex = -exeoeoex                   = 0     , eoexeoey = -exeoeoey         = 0
   // eoeys = eoey   , eoeyexey = -eoexeyey         = -eoex   , eoeyeoex = -eyeoeoex                   = 0     , eoeyeoey = -eyeoeoey         = 0
   // i.e. group by terms, when we multiple two multivectors, the coefficients of each term are:
   // scalar term: a.s * b.s - a.exey * b.exey
   // exey term: a.s * b.exey + a.exey * b.s
   // eoex term: a.s * b.eoex + a.exey * b.eoey + a.eoex * b.s - a.eoey * b.exey
   // eoey term: a.s * b.eoey - a.exey * b.eoex + a.eoex * b.exey + a.eoey * b.s
   return MultiVector(
     a.s * b.s - a.exey * b.exey , // scalar
     a.s * b.exey + a.exey * b.s , // exey
     a.s * b.eoex + a.exey * b.eoey + a.eoex * b.s - a.eoey * b.exey, // eoex
     a.s * b.eoey - a.exey * b.eoex + a.eoex * b.exey + a.eoey * b.s  // eoey
   );
 }
 fn reverse(a: MultiVector) -> MultiVector {
   // The reverse is the reverse order of the basis elements
   // e.g. the reverse of exey is eyex = -exey
   //      the reverse of eoex is exeo = -exeo
   //      the reverse of eoey is eyeo = -eyeo
   //      the reverse of a scalar is the scalar
   // So, for an input a as an array storing the coefficients of [s, exey, eoex, eoey],
   // Its reverse is [s, -exey, -eoex, -eoey].
   return MultiVector( a.s, -a.exey, -a.eoex, -a.eoey );
 }

 fn applyMotor(p: MultiVector, m: MultiVector) -> MultiVector {
   // To apply a motor to a point, we use the sandwich operation
   // The formula is m * p * reverse of m
   return geometricProduct(m, geometricProduct(p, reverse(m)));
 }

 fn createPoint(p: vec2f) -> MultiVector {
   // A point is given by exey + x eyeo + y eoex
   return MultiVector(0, 1, p.y, -p.x);
 }

 fn extractPoint(p: MultiVector) -> vec2f {
   // to extract the 2d pont from a exey + b eyeo + c eoex
   // we have x = -b/a and y = c/a
   return vec2f(-p.eoey / p.exey, p.eoex / p.exey);
 }

 fn applyMotorToPoint(p: vec2f, m: MultiVector) -> vec2f {
   let new_p = applyMotor(createPoint(p), m);
   return extractPoint(new_p);
 }

struct VertexOutput {
  @builtin(position) pos: vec4f,
  @location(0) cellStatus: f32 // pass the cell status
};

@vertex // this compute the scene coordinate of each input vertex
fn vertexMain(@location(0) pos: vec2f, @builtin(instance_index) idx: u32) -> VertexOutput {
  let u = idx % grid.width;
  let v = idx / grid.width;
  let uv = vec2f(f32(u), f32(v)) / f32(grid.width); // normalize the coordinates to [0, 1]
  let halfLength = 1.f; // half cell length
  let cellLength = halfLength * 2.f; // full cell length
  let cell = pos / f32(grid.width);
  let offset = - halfLength + uv * cellLength + cellLength / f32(grid.width) * 0.5;
  // Apply motor
  let transformed = applyMotorToPoint(cell + offset, reverse(pose.motor));
  // Apply scale
  let scaled = transformed * pose.scale;
  var out: VertexOutput;
  out.pos = vec4f(scaled, 0, 1);
  out.cellStatus = f32(cellStatusIn[idx]);
  return out;
}

@fragment // this compute the color of each pixel
fn fragmentMain(@location(0) cellStatus: f32) -> @location(0) vec4f {
  return vec4f(238.f/255, 118.f/255, 35.f/255, 1) * cellStatus; // (R, G, B, A)
  // cellStatus is either 1 or 0, so it will be either orange or black
}

 @compute
@workgroup_size(4, 4)
fn computeMain(@builtin(global_invocation_id) cell: vec3u) {
  // First count how many neighbors are alive
  let x = cell.x;
  let y = cell.y;
  let neighborsAlive = cellStatusIn[(y) * grid.width + (x + 1)] + cellStatusIn[(y) * grid.width + (x - 1)] +
                       cellStatusIn[(y + 1) * grid.width + (x)] + cellStatusIn[(y - 1) * grid.width + (x)];
  let i = y * grid.width + x;
  // Compute new status  
  if ((i + neighborsAlive) % 2 == 1) { // if the cell index + number of alive neighbors is odd
    cellStatusOut[i] = 1; // alive
  }
  else {
    cellStatusOut[i] = 0; // dead
  }
}