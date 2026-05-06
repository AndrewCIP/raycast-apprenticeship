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

import PerlinNoise from '/lib/Scene/Noises.js'

/*
 * TerrainData
 *
 * Generates a Minecraft-like 3-D voxel terrain using Perlin noise.
 *
 * Voxel types (stored as f32 in the data array):
 *   0 = air
 *   1 = water
 *   2 = sand / beach
 *   3 = grass
 *   4 = dirt
 *   5 = stone
 *   6 = snow
 *
 * Layout: index = z * (dimX * dimY) + y * dimX + x
 *   x — east/west  (width)
 *   y — up/down    (height)
 *   z — north/south (depth)
 */
export default class TerrainData {
  constructor() {
    this._dims  = [128, 64, 128]; // [W, H, D]
    this._sizes = [1.0, 1.0, 1.0];
  }

  async init() {
    const pn = new PerlinNoise(); // noise2D for heightmap, noise3D for caves

    const [W, H, D] = this._dims;
    this._data = new Array(W * H * D).fill(0);

    // Water level: voxel row index corresponding to sea level (≈ 38 % of height)
    const waterY = Math.floor(0.38 * H);

    for (let z = 0; z < D; ++z) {
      for (let x = 0; x < W; ++x) {
        // ── noise2D heightmap (fBm / octave Perlin noise) ──────────────────
        // octaveNoise2d normalizes by the sum of amplitudes (maxValue), giving
        // a result approximately in [-1, 1].  We then apply a contrast stretch
        // (multiply by 2.5) so that the full height range spans all biome types.
        const raw = pn.octaveNoise2d(x, z, 0.015, 1.0, 0.5, 6, 2.0);
        const h   = Math.max(0, Math.min(1, (raw * 2.5 + 1) * 0.5));

        // Number of solid voxels from the bottom of the volume
        const heightY = Math.max(1, Math.floor(h * H));

        // Surface terrain type based on normalised height
        let surfaceType;
        if      (h < 0.35) surfaceType = 2; // sand  (underwater / ocean floor)
        else if (h < 0.42) surfaceType = 2; // sand  (beach)
        else if (h < 0.65) surfaceType = 3; // grass (plains)
        else if (h < 0.78) surfaceType = 4; // dirt  (highlands)
        else if (h < 0.90) surfaceType = 5; // stone (mountains)
        else               surfaceType = 6; // snow  (peaks)

        // ── Fill solid terrain from y = 0 to heightY - 1 ──────────────────
        for (let y = 0; y < heightY && y < H; ++y) {
          const idx = z * (W * H) + y * W + x;

          if (y === heightY - 1) {
            // Top voxel: biome surface type
            this._data[idx] = surfaceType;
          } else if (y >= heightY - 3) {
            // Sub-surface: dirt below grass, stone below snow, same type elsewhere
            this._data[idx] = (surfaceType === 3) ? 4 : (surfaceType === 6 ? 5 : surfaceType);
          } else {
            // ── noise3D cave carving in deep stone ─────────────────────────
            // Zero-crossings of 3-D Perlin noise form worm-like cave tunnels.
            // Only carve caves in land biomes (not under ocean basins).
            const caveNoise = pn.noise3d(x * 0.09, y * 0.07, z * 0.09);
            if (Math.abs(caveNoise) < 0.10 && h >= 0.42) {
              // Leave as 0 (air) — cave interior
            } else {
              this._data[idx] = 5; // stone
            }
          }
        }

        // ── Fill water above terrain up to the water level ─────────────────
        // Applies wherever the terrain surface is below sea level.
        for (let y = heightY; y < waterY && y < H; ++y) {
          const idx = z * (W * H) + y * W + x;
          this._data[idx] = 1; // water
        }
      }
    }
  }
}
