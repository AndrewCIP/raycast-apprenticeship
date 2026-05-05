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
 
export default class PerlinNoise {
  constructor() {
    // ref: https://en.wikipedia.org/wiki/Perlin_noise
    // implementation ref: // ref: https://mrl.cs.nyu.edu/~perlin/noise/
    // Perlin Noise depends on a gradient permutation table
    this.gradientPermutation();
  }
  
  // a function to generate the gradient permutation table
  gradientPermutation() {
    // ref: https://en.wikipedia.org/wiki/Perlin_noise
    // instead of a hard-coded table, we generate one
    // we can regenerate it if needed
    // first, we start with an array of [0, 1, 2, ..., 255]
    this._permutation = Array.from( {length: 256}, (_, i) => i ); 
    // then, we shuffle the array using the Fisher-Yates shuffle algorithm
    for (let i = this._permutation.length - 1; i > 0; --i) { // it starts from the end of the array
      const j = Math.floor(Math.random() * (i + 1)); // it randomly pick one that is not shuffled yet
      [this._permutation[i], this._permutation[j]] = [this._permutation[j], this._permutation[i]]; // this is how JS can swap elements using references
    }
  }
  
  // a function to return a graident based on the hashed value
  gradient(hashvalue, x, y = 0, z = 0) {
    // ref: https://mrl.cs.nyu.edu/~perlin/noise/
    switch (hashvalue & 15) { // only use the lower 4 bits   
      // convert to the 12 gradient directions
      case 0: case 12: return  x + y; // the last four are repeated
      case 1: case 13: return -x + y;
      case 2: case 14: return  x - y;
      case 3: case 15: return -x - y;
      case 4:  return  x + z;
      case 5:  return -x + z;
      case 6:  return  x - z;
      case 7:  return -x - z;
      case 8:  return  y + z;
      case 9:  return -y + z;
      case 10: return  y - z;
      case 11: return -y - z;
    }
  }
  
  // 1D Perlin Noise
  noise1d(x) {
    // implementation ref: // ref: https://mrl.cs.nyu.edu/~perlin/noise/
    // a fade function for smoother interpolation - you can pick any cubic function
    const fade = (t) => { return t * t * t * (t * (t * 6 - 15) + 10)} ;
    // a linear interpolation function
    const interpolate = (src, dst, t) => { return src * t + dst * (1 - t) };
    // noise generation
    const ix = Math.floor(x) & 255; // for an input x, compute an index within [0, 255]
    const ixx = (ix + 1) & 255; // get the next index
    x -= Math.floor(x); // clamp the coordiantes to the cell
    let t = fade(x); // comptue the fade curve for weighted sum
    let src = this._permutation[ix]; // get the src hash value
    let dst = this._permutation[ixx]; // get the dst hash value
    let srcGrad = this.gradient(src, x); // get the src gradient value
    let dstGrad = this.gradient(dst, x - 1); // get the dst gradient value, note here, shift the value by 1
    return interpolate(srcGrad, dstGrad, t); // intepolate using the fade value
  }
  
  // 2D Perlin Noise
  noise2d(x, y) {
    // implementation ref: // ref: https://mrl.cs.nyu.edu/~perlin/noise/
    const fade = (t) => { return t * t * t * (t * (t * 6 - 15) + 10) };
    const interpolate = (src, dst, t) => { return src * t + dst * (1 - t) };
    // for an input (x, y), compute integer coordinates within [0, 255]
    const ix = Math.floor(x) & 255;
    const iy = Math.floor(y) & 255;
    const ixx = (ix + 1) & 255;
    const iyy = (iy + 1) & 255;
    // clamp the coordinates to the unit cell
    x -= Math.floor(x);
    y -= Math.floor(y);
    // compute fade curves for weighted sum
    const u = fade(x);
    const v = fade(y);
    // hash coordinates of the 4 cell corners
    const aa = this._permutation[(this._permutation[ix]  + iy)  & 255];
    const ba = this._permutation[(this._permutation[ixx] + iy)  & 255];
    const ab = this._permutation[(this._permutation[ix]  + iyy) & 255];
    const bb = this._permutation[(this._permutation[ixx] + iyy) & 255];
    // gradient contributions from each corner
    const aaGrad = this.gradient(aa, x,     y    );
    const baGrad = this.gradient(ba, x - 1, y    );
    const abGrad = this.gradient(ab, x,     y - 1);
    const bbGrad = this.gradient(bb, x - 1, y - 1);
    // bilinear interpolation
    return interpolate(
      interpolate(aaGrad, baGrad, u),
      interpolate(abGrad, bbGrad, u),
      v
    );
  }
  
  // 3D Perlin Noise
  noise3d(x, y, z) {
    // implementation ref: // ref: https://mrl.cs.nyu.edu/~perlin/noise/
    const fade = (t) => { return t * t * t * (t * (t * 6 - 15) + 10) };
    const interpolate = (src, dst, t) => { return src * t + dst * (1 - t) };
    // for an input (x, y, z), compute integer coordinates within [0, 255]
    const ix  = Math.floor(x) & 255;
    const iy  = Math.floor(y) & 255;
    const iz  = Math.floor(z) & 255;
    const ixx = (ix + 1) & 255;
    const iyy = (iy + 1) & 255;
    const izz = (iz + 1) & 255;
    // clamp the coordinates to the unit cell
    x -= Math.floor(x);
    y -= Math.floor(y);
    z -= Math.floor(z);
    // compute fade curves for weighted sum
    const u = fade(x);
    const v = fade(y);
    const w = fade(z);
    // hash coordinates of the 8 cell corners
    const aaa = this._permutation[(this._permutation[(this._permutation[ix]  + iy)  & 255] + iz)  & 255];
    const baa = this._permutation[(this._permutation[(this._permutation[ixx] + iy)  & 255] + iz)  & 255];
    const aba = this._permutation[(this._permutation[(this._permutation[ix]  + iyy) & 255] + iz)  & 255];
    const bba = this._permutation[(this._permutation[(this._permutation[ixx] + iyy) & 255] + iz)  & 255];
    const aab = this._permutation[(this._permutation[(this._permutation[ix]  + iy)  & 255] + izz) & 255];
    const bab = this._permutation[(this._permutation[(this._permutation[ixx] + iy)  & 255] + izz) & 255];
    const abb = this._permutation[(this._permutation[(this._permutation[ix]  + iyy) & 255] + izz) & 255];
    const bbb = this._permutation[(this._permutation[(this._permutation[ixx] + iyy) & 255] + izz) & 255];
    // gradient contributions from each corner
    const aaaGrad = this.gradient(aaa, x,     y,     z    );
    const baaGrad = this.gradient(baa, x - 1, y,     z    );
    const abaGrad = this.gradient(aba, x,     y - 1, z    );
    const bbaGrad = this.gradient(bba, x - 1, y - 1, z    );
    const aabGrad = this.gradient(aab, x,     y,     z - 1);
    const babGrad = this.gradient(bab, x - 1, y,     z - 1);
    const abbGrad = this.gradient(abb, x,     y - 1, z - 1);
    const bbbGrad = this.gradient(bbb, x - 1, y - 1, z - 1);
    // trilinear interpolation
    return interpolate(
      interpolate(
        interpolate(aaaGrad, baaGrad, u),
        interpolate(abaGrad, bbaGrad, u),
        v
      ),
      interpolate(
        interpolate(aabGrad, babGrad, u),
        interpolate(abbGrad, bbbGrad, u),
        v
      ),
      w
    );
  }
  
  // 2D Octave Perlin Noise
  octaveNoise2d(x, y, freq = 0.005, A = 1, H = 0.99, octaves = 4, lacunarity = 2) {
    // ref: https://miquelvir.medium.com/procedural-fractal-terrains-how-does-minecraft-generate-infinite-maps-776103e180ee
    let total = 0;
    let amplitude = A;
    let frequency = freq;
    for (let i = 0; i < octaves; i++) {
      total += amplitude * this.noise2d(x * frequency, y * frequency);
      frequency *= lacunarity;
      amplitude *= H;
    }
    return total;
  }
}
