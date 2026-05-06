/*
 * Copyright (c) 2026 Andrew Cip @ University of the Pacific.
 *
 * Built on course framework copyright (c) 2026 Sing Chun LEE @ Bucknell University.
 * Licensed under CC BY-NC 4.0 — https://creativecommons.org/licenses/by-nc/4.0/
 *
 * Project 7 — Comprehensive Volume Rendering Demo
 *
 * Features implemented:
 *   ✓ Ray marching with orthogonal and projective (pinhole) camera models
 *   ✓ Basic MIP (Maximum Intensity Projection) volume rendering
 *   ✓ Custom volume data loader  (Brain PD instead of T1)
 *   ✓ Procedural volume generation (sphere + torus density field)
 *   ✓ Linear transfer function
 *   ✓ Piecewise linear transfer function
 *   ✓ Gradient TF (edge detection) — new TF #1
 *   ✓ Spectral / rainbow TF        — new TF #2
 *   ✓ Warm-Cool cinematic TF       — new TF #3
 *   ✓ 4 Perlin-noise terrain biomes: Grass, Snow, Water, Dirt/Rock
 *   ✓ 3 Perlin-noise special effects: Cloud, Fire, Smoke
 *   ✓ Composed 3-D scene (terrain + cloud layer)
 *
 * Controls:
 *   Tab / Shift+Tab  — next / previous scene
 *   1-9, 0          — jump to scene 1-10 (1-indexed)
 *   P               — toggle orthographic ↔ projective camera
 *   + / -           — increase / decrease focal length (projective only)
 *   W/S             — move forward / backward
 *   A/D             — move left / right
 *   Q/E             — move up / down
 *   ↑/↓             — pitch camera up / down
 *   ←/→             — yaw camera left / right
 *   Z/X             — roll camera
 *   R               — reset camera to scene default
 */

import RayTracer             from '/lib/Viz/RayTracer.js';
import VolumeRenderingObject from '/lib/Scene/VolumeRenderingObject.js';
import Camera                from '/lib/Viz/3DCamera.js';
import VolumeData            from '/lib/DS/VolumeData.js';
import PerlinNoise           from '/lib/Scene/Noises.js';

// ── Rendering mode index constants ────────────────────────────────────────────
const MODE_MIP      = 0;
const MODE_DRR      = 1;
const MODE_LINEAR   = 2;
const MODE_PIECEWISE= 3;
const MODE_GRADIENT = 4;
const MODE_SPECTRAL = 5;
const MODE_WARMCOOL = 6;
const MODE_TERRAIN  = 7;
const MODE_CLOUD    = 8;
const MODE_FIRE     = 9;
const MODE_SMOKE    = 10;
const MODE_COMPOSED = 11;

// ── Procedural volume generators ──────────────────────────────────────────────

/**
 * Procedural sphere + torus density field.
 * Values in [0, 4095] (12-bit intensity range, same as the brain datasets).
 */
class ProceduralSphereData {
  constructor() {
    this._dims  = [64, 64, 64];
    this._sizes = [1.0, 1.0, 1.0];
  }
  async init() {
    const [W, H, D] = this._dims;
    this._data = new Array(W * H * D).fill(0);
    for (let z = 0; z < D; z++) {
      for (let y = 0; y < H; y++) {
        for (let x = 0; x < W; x++) {
          const nx = (x / W) * 2 - 1;
          const ny = (y / H) * 2 - 1;
          const nz = (z / D) * 2 - 1;
          // Central sphere
          const r      = Math.sqrt(nx*nx + ny*ny + nz*nz);
          const sphere = Math.max(0, 1 - r / 0.70);
          // Torus around Y-axis:  (sqrt(x²+z²) - R)² + y² < r²
          const torusR = 0.50;
          const torusr = 0.22;
          const dxz    = Math.sqrt(nx*nx + nz*nz) - torusR;
          const torus  = Math.max(0, 1 - Math.sqrt(dxz*dxz + ny*ny) / torusr);
          const density = Math.max(sphere, torus);
          this._data[z * W * H + y * W + x] = density * 4095;
        }
      }
    }
  }
}

/**
 * Perlin-noise terrain with a configurable height bias that shifts the
 * dominant biome (negative = more ocean, positive = more mountains/snow).
 *
 * Voxel codes: 0=air, 1=water, 2=sand, 3=grass, 4=dirt, 5=stone, 6=snow.
 */
class BiasedTerrainData {
  constructor(heightBias = 0) {
    this._dims       = [128, 64, 128];
    this._sizes      = [1.0, 1.0, 1.0];
    this._heightBias = heightBias;
  }
  async init() {
    const pn = new PerlinNoise();
    const [W, H, D] = this._dims;
    this._data = new Array(W * H * D).fill(0);
    const waterY = Math.floor(0.38 * H);
    for (let z = 0; z < D; z++) {
      for (let x = 0; x < W; x++) {
        const raw = pn.octaveNoise2d(x, z, 0.015, 1.0, 0.5, 6, 2.0);
        const hRaw = Math.max(0, Math.min(1, (raw * 2.5 + 1) * 0.5));
        const h    = Math.max(0, Math.min(1, hRaw + this._heightBias));
        const heightY = Math.max(1, Math.floor(h * H));
        let surfaceType;
        if      (h < 0.35) surfaceType = 2; // sand (ocean floor / beach)
        else if (h < 0.42) surfaceType = 2; // sand (beach)
        else if (h < 0.65) surfaceType = 3; // grass
        else if (h < 0.78) surfaceType = 4; // dirt / highland
        else if (h < 0.90) surfaceType = 5; // stone
        else               surfaceType = 6; // snow
        for (let y = 0; y < heightY && y < H; y++) {
          const idx = z * W * H + y * W + x;
          if (y === heightY - 1) {
            this._data[idx] = surfaceType;
          } else if (y >= heightY - 3) {
            this._data[idx] = (surfaceType === 3) ? 4 : (surfaceType === 6 ? 5 : surfaceType);
          } else {
            const cv = pn.noise3d(x * 0.09, y * 0.07, z * 0.09);
            this._data[idx] = (Math.abs(cv) < 0.10 && h >= 0.42) ? 0 : 5;
          }
        }
        for (let y = heightY; y < waterY && y < H; y++) {
          this._data[z * W * H + y * W + x] = 1; // water
        }
      }
    }
  }
}

/**
 * Layered Perlin-noise cloud density field.
 * Values in [0, 4095]; clouds occupy the upper 70% of the volume.
 */
class CloudData {
  constructor() {
    this._dims  = [64, 64, 64];
    this._sizes = [1.0, 1.0, 1.0];
  }
  async init() {
    const pn = new PerlinNoise();
    const [W, H, D] = this._dims;
    this._data = new Array(W * H * D).fill(0);
    for (let z = 0; z < D; z++) {
      for (let y = 0; y < H; y++) {
        const heightFactor = y / H;
        if (heightFactor < 0.30) continue; // no clouds in the lower 30%
        for (let x = 0; x < W; x++) {
          const n1 = pn.octaveNoise2d(x, z, 0.08, 1.0, 0.5, 5, 2.0) * 0.5 + 0.5;
          const n2 = pn.octaveNoise2d(x + 100, z + 100, 0.15, 0.5, 0.5, 4, 2.0) * 0.5 + 0.5;
          const vertFade   = Math.sin(((heightFactor - 0.30) / 0.70) * Math.PI);
          const density    = Math.max(0, (n1 * 0.7 + n2 * 0.3) - 0.40) * vertFade;
          this._data[z * W * H + y * W + x] = Math.min(4095, density * 5500);
        }
      }
    }
  }
}

/**
 * Turbulent Perlin-noise fire density field.
 * Denser at the base, dissipating upward with a radial column shape.
 */
class FireData {
  constructor() {
    this._dims  = [64, 64, 64];
    this._sizes = [1.0, 1.0, 1.0];
  }
  async init() {
    const pn = new PerlinNoise();
    const [W, H, D] = this._dims;
    this._data = new Array(W * H * D).fill(0);
    for (let z = 0; z < D; z++) {
      for (let y = 0; y < H; y++) {
        for (let x = 0; x < W; x++) {
          const nx = x / W, ny = y / H, nz = z / D;
          const heightFade = Math.pow(Math.max(0, 1 - ny), 1.6);
          const cx = nx - 0.5, cz = nz - 0.5;
          const radial     = Math.max(0, 1 - Math.sqrt(cx*cx + cz*cz) / 0.40);
          const n1 = Math.abs(pn.noise3d(x * 0.15, y * 0.12, z * 0.15));
          const n2 = Math.abs(pn.noise3d(x * 0.30, y * 0.25, z * 0.30)) * 0.5;
          const density = (n1 + n2) * radial * heightFade;
          this._data[z * W * H + y * W + x] = Math.min(4095, density * 6500);
        }
      }
    }
  }
}

/**
 * Rising-column smoke density field with widening spread and soft turbulence.
 */
class SmokeData {
  constructor() {
    this._dims  = [64, 64, 64];
    this._sizes = [1.0, 1.0, 1.0];
  }
  async init() {
    const pn = new PerlinNoise();
    const [W, H, D] = this._dims;
    this._data = new Array(W * H * D).fill(0);
    for (let z = 0; z < D; z++) {
      for (let y = 0; y < H; y++) {
        for (let x = 0; x < W; x++) {
          const nx = x / W, ny = y / H, nz = z / D;
          const heightFade = Math.sin(Math.min(ny * 2.5, Math.PI));
          const spread     = 0.15 + ny * 0.35;
          const cx = nx - 0.5, cz = nz - 0.5;
          const radial = Math.max(0, 1 - Math.sqrt(cx*cx + cz*cz) / spread);
          const n1 = pn.noise3d(x * 0.10, y * 0.08, z * 0.10) * 0.5 + 0.5;
          const n2 = pn.noise3d(x * 0.22, y * 0.18, z * 0.22) * 0.25 + 0.25;
          const density = ((n1 + n2) / 1.5) * radial * heightFade;
          this._data[z * W * H + y * W + x] = Math.min(4095, density * 4095);
        }
      }
    }
  }
}

/**
 * Composed scene data: Perlin-noise terrain in the lower 55% of the volume,
 * cloud density field (encoded as 100 + density*100) in the upper portion.
 *
 * Voxel encoding in the composed volume:
 *   0          — transparent air
 *   [1 , 6]    — solid terrain biome code (integer)
 *   [100, 200] — cloud: 100 + cloud_density * 100
 */
class ComposedSceneData {
  constructor() {
    this._dims  = [128, 64, 128];
    this._sizes = [1.0, 1.0, 1.0];
  }
  async init() {
    const pn = new PerlinNoise();
    const [W, H, D] = this._dims;
    this._data = new Array(W * H * D).fill(0);
    const waterY = Math.floor(0.38 * H * 0.55); // sea level at 55% height cap

    // ── Terrain layer (lower 55 %) ────────────────────────────────────────
    for (let z = 0; z < D; z++) {
      for (let x = 0; x < W; x++) {
        const raw = pn.octaveNoise2d(x, z, 0.015, 1.0, 0.5, 6, 2.0);
        const h   = Math.max(0, Math.min(1, (raw * 2.5 + 1) * 0.5));
        const heightY = Math.max(1, Math.floor(h * H * 0.55));
        let surfaceType;
        if      (h < 0.35) surfaceType = 2;
        else if (h < 0.42) surfaceType = 2;
        else if (h < 0.65) surfaceType = 3;
        else if (h < 0.78) surfaceType = 4;
        else if (h < 0.90) surfaceType = 5;
        else               surfaceType = 6;
        for (let y = 0; y < heightY && y < H; y++) {
          const idx = z * W * H + y * W + x;
          this._data[idx] = (y === heightY - 1) ? surfaceType : 5;
        }
        for (let y = heightY; y < waterY && y < H; y++) {
          this._data[z * W * H + y * W + x] = 1; // water
        }
      }
    }

    // ── Cloud layer (upper 55%–90%) ───────────────────────────────────────
    const cloudBase = Math.floor(H * 0.55);
    const cloudTop  = Math.floor(H * 0.90);
    for (let z = 0; z < D; z++) {
      for (let y = cloudBase; y < cloudTop; y++) {
        const t = (y - cloudBase) / (cloudTop - cloudBase);
        const vertFade = Math.sin(t * Math.PI);
        for (let x = 0; x < W; x++) {
          const n = pn.octaveNoise2d(x, z, 0.08, 1.0, 0.5, 4, 2.0) * 0.5 + 0.5;
          const density = Math.max(0, n - 0.40) * vertFade;
          if (density > 0.04) {
            this._data[z * W * H + y * W + x] = 100 + density * 100;
          }
        }
      }
    }
  }
}

// ── Camera defaults per scene type ────────────────────────────────────────────
const SCENE_CAMERA_DEFAULTS = {
  volume:  { isProjective: false, focal: 1.0, actions: [] },
  terrain: {
    isProjective: true,
    focal: 2.0,
    actions: [
      { type: 'rotateX', angle: -Math.PI / 5 },
      { type: 'moveZ',   dist: -1.4 },
      { type: 'moveY',   dist:  0.3 },
    ]
  },
  effect: {
    isProjective: true,
    focal: 1.5,
    actions: [
      { type: 'rotateX', angle: -Math.PI / 8 },
      { type: 'moveZ',   dist: -1.2 },
    ]
  },
  composed: {
    isProjective: true,
    focal: 2.0,
    actions: [
      { type: 'rotateX', angle: -Math.PI / 5 },
      { type: 'moveZ',   dist: -1.6 },
      { type: 'moveY',   dist:  0.4 },
    ]
  },
};

// ── Scene definitions ─────────────────────────────────────────────────────────
const SCENES = [
  // Scene 1: Ray marching + basic MIP (orthographic)
  { name: 'Brain T1 — MIP (Orthographic)',            datasetIdx:  0, modeIdx: MODE_MIP,       camType: 'volume'   },
  // Scene 2: Same brain MIP but projective (pinhole) camera
  { name: 'Brain T1 — MIP (Projective/Pinhole)',      datasetIdx:  0, modeIdx: MODE_MIP,       camType: 'volume'   },
  // Scene 3: Custom volume data loader — Brain PD (proton density)
  { name: 'Brain PD — DRR  [Custom Loader]',          datasetIdx:  1, modeIdx: MODE_DRR,       camType: 'volume'   },
  // Scene 4: Procedural volume generation — sphere + torus
  { name: 'Procedural Sphere+Torus — Linear TF',      datasetIdx:  2, modeIdx: MODE_LINEAR,    camType: 'volume'   },
  // Scene 5: Linear transfer function on brain T1
  { name: 'Brain T1 — Linear Transfer Function',      datasetIdx:  0, modeIdx: MODE_LINEAR,    camType: 'volume'   },
  // Scene 6: Piecewise linear transfer function
  { name: 'Brain T1 — Piecewise Linear TF',           datasetIdx:  0, modeIdx: MODE_PIECEWISE, camType: 'volume'   },
  // Scenes 7–9: Three additional custom transfer functions
  { name: 'Brain T1 — Gradient (Edge) TF',            datasetIdx:  0, modeIdx: MODE_GRADIENT,  camType: 'volume'   },
  { name: 'Brain T1 — Spectral (Rainbow) TF',         datasetIdx:  0, modeIdx: MODE_SPECTRAL,  camType: 'volume'   },
  { name: 'Brain T1 — Warm-Cool Cinematic TF',        datasetIdx:  0, modeIdx: MODE_WARMCOOL,  camType: 'volume'   },
  // Scenes 10–13: Perlin-noise terrain biomes
  { name: 'Terrain — Grass Plains',                   datasetIdx:  3, modeIdx: MODE_TERRAIN,   camType: 'terrain'  },
  { name: 'Terrain — Snow Peaks (Arctic)',             datasetIdx:  4, modeIdx: MODE_TERRAIN,   camType: 'terrain'  },
  { name: 'Terrain — Ocean World (Water)',             datasetIdx:  5, modeIdx: MODE_TERRAIN,   camType: 'terrain'  },
  { name: 'Terrain — Dirt/Rock Highlands',             datasetIdx:  6, modeIdx: MODE_TERRAIN,   camType: 'terrain'  },
  // Scenes 14–16: Perlin-noise special effects
  { name: 'Effect — Volumetric Clouds',               datasetIdx:  7, modeIdx: MODE_CLOUD,     camType: 'effect'   },
  { name: 'Effect — Volumetric Fire',                  datasetIdx:  8, modeIdx: MODE_FIRE,      camType: 'effect'   },
  { name: 'Effect — Volumetric Smoke',                 datasetIdx:  9, modeIdx: MODE_SMOKE,     camType: 'effect'   },
  // Scene 17: Composed 3-D scene
  { name: '3D Scene — Terrain + Cloud Layer',          datasetIdx: 10, modeIdx: MODE_COMPOSED,  camType: 'composed' },
];

// ── Project7Object ────────────────────────────────────────────────────────────

class Project7Object extends VolumeRenderingObject {
  /**
   * @param {GPUDevice}  device
   * @param {string}     canvasFormat
   * @param {Camera}     camera
   * @param {string}     shaderFile
   */
  constructor(device, canvasFormat, camera, shaderFile) {
    // Pass null for volumeFile — we manage all data ourselves in createGeometry.
    super(device, canvasFormat, camera, null, shaderFile);
    this._activeScene = 0;
    this._bindGroups  = [];
  }

  // ── Data creation ──────────────────────────────────────────────────────────

  async createGeometry() {
    // ── 1. Loaded volume datasets (two brain scans, different contrasts) ──
    const brainT1 = new VolumeData('/assets/brainweb-t1-1mm-pn0-rf0.raws');
    const brainPD = new VolumeData('/assets/brainweb-pd-1mm-pn0-rf0.raws');
    await Promise.all([brainT1.init(), brainPD.init()]);

    // ── 2. Procedural datasets ────────────────────────────────────────────
    const sphere   = new ProceduralSphereData();
    const grass    = new BiasedTerrainData( 0.00); // neutral — mostly grass
    const snow     = new BiasedTerrainData( 0.28); // shifted up   — snow/stone
    const water    = new BiasedTerrainData(-0.28); // shifted down — ocean
    const dirt     = new BiasedTerrainData( 0.15); // slightly high — dirt/rock
    const cloud    = new CloudData();
    const fire     = new FireData();
    const smoke    = new SmokeData();
    const composed = new ComposedSceneData();

    await Promise.all([
      sphere.init(), grass.init(), snow.init(), water.init(),
      dirt.init(), cloud.init(), fire.init(), smoke.init(), composed.init()
    ]);

    // Master array — indices must match SCENES[].datasetIdx above.
    // 0=T1, 1=PD, 2=sphere, 3=grass, 4=snow, 5=water, 6=dirt,
    // 7=cloud, 8=fire, 9=smoke, 10=composed
    this._datasets = [brainT1, brainPD, sphere, grass, snow, water, dirt,
                      cloud, fire, smoke, composed];

    // ── 3. Camera uniform buffer ──────────────────────────────────────────
    this._cameraBuffer = this._device.createBuffer({
      label: 'Project7 Camera',
      size:  this._camera._pose.byteLength
           + this._camera._focal.byteLength
           + this._camera._resolutions.byteLength,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
    });
    this._device.queue.writeBuffer(this._cameraBuffer, 0, this._camera._pose);
    this._device.queue.writeBuffer(this._cameraBuffer,
      this._camera._pose.byteLength, this._camera._focal);
    this._device.queue.writeBuffer(this._cameraBuffer,
      this._camera._pose.byteLength + this._camera._focal.byteLength,
      this._camera._resolutions);

    // ── 4. Per-dataset GPU buffers ────────────────────────────────────────
    this._volInfoBuffers = [];
    this._dataBuffers    = [];
    for (const ds of this._datasets) {
      const vib = this._device.createBuffer({
        size:  8 * Float32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
      });
      this._device.queue.writeBuffer(vib, 0,
        new Float32Array([...ds._dims, 0, ...ds._sizes, 0]));

      const dBuf = this._device.createBuffer({
        size:  ds._data.length * Float32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
      });
      this._device.queue.writeBuffer(dBuf, 0, new Float32Array(ds._data));

      this._volInfoBuffers.push(vib);
      this._dataBuffers.push(dBuf);
    }

    // Point base-class fields at dataset 0 for compatibility.
    this._volumeBuffer = this._volInfoBuffers[0];
    this._dataBuffer   = this._dataBuffers[0];
  }

  // ── Pipeline creation ──────────────────────────────────────────────────────

  async createComputePipeline() {
    const make = (entry) => this._device.createComputePipeline({
      label:   `P7 ${entry}`,
      layout:  this._pipelineLayout,
      compute: { module: this._shaderModule, entryPoint: entry },
    });

    // _pipelines[modeIdx] = [orthoPipeline, projectivePipeline]
    this._pipelines = [
      [make('computeOrthogonalMIPMain'),       make('computeProjectiveMIPMain')      ], // 0  MIP
      [make('computeOrthogonalDRRMain'),       make('computeProjectiveDRRMain')      ], // 1  DRR
      [make('computeOrthogonalLinearTFMain'),  make('computeProjectiveLinearTFMain') ], // 2  Linear TF
      [make('computeOrthogonalPiecewiseMain'), make('computeProjectivePiecewiseMain')], // 3  Piecewise
      [make('computeOrthogonalGradientMain'),  make('computeProjectiveGradientMain') ], // 4  Gradient TF
      [make('computeOrthogonalSpectralMain'),  make('computeProjectiveSpectralMain') ], // 5  Spectral TF
      [make('computeOrthogonalWarmCoolMain'),  make('computeProjectiveWarmCoolMain') ], // 6  Warm-Cool TF
      [make('computeOrthogonalTerrainMain'),   make('computeProjectiveTerrainMain')  ], // 7  Terrain DDA
      [make('computeOrthogonalCloudMain'),     make('computeProjectiveCloudMain')    ], // 8  Cloud
      [make('computeOrthogonalFireMain'),      make('computeProjectiveFireMain')     ], // 9  Fire
      [make('computeOrthogonalSmokeMain'),     make('computeProjectiveSmokeMain')    ], // 10 Smoke
      [make('computeOrthogonalComposedMain'),  make('computeProjectiveComposedMain') ], // 11 Composed
    ];

    // Base-class compatibility fields.
    this._computePipeline           = this._pipelines[0][0];
    this._computeProjectivePipeline = this._pipelines[0][1];
  }

  // ── Bind group creation (one per dataset, rebuilt on resize) ───────────────

  createBindGroup(outTexture) {
    const layout = this._pipelines[0][0].getBindGroupLayout(0);
    this._bindGroups = this._datasets.map((_, i) =>
      this._device.createBindGroup({
        label:   `P7 BindGroup ds=${i}`,
        layout,
        entries: [
          { binding: 0, resource: { buffer: this._cameraBuffer      } },
          { binding: 1, resource: { buffer: this._volInfoBuffers[i]  } },
          { binding: 2, resource: { buffer: this._dataBuffers[i]     } },
          { binding: 3, resource: outTexture.createView()            },
        ],
      })
    );
    this._wgWidth  = outTexture.width;
    this._wgHeight = outTexture.height;
  }

  // ── Compute dispatch ───────────────────────────────────────────────────────

  compute(pass) {
    const scene    = SCENES[this._activeScene];
    const camIdx   = this._camera._isProjective ? 1 : 0;
    const pipeline = this._pipelines[scene.modeIdx][camIdx];
    pass.setPipeline(pipeline);
    pass.setBindGroup(0, this._bindGroups[scene.datasetIdx]);
    pass.dispatchWorkgroups(
      Math.ceil(this._wgWidth  / 16),
      Math.ceil(this._wgHeight / 16)
    );
  }

  // ── Camera update helpers (mirroring the base class) ──────────────────────

  updateCameraPose() {
    this._device.queue.writeBuffer(this._cameraBuffer, 0, this._camera._pose);
  }

  updateCameraFocal() {
    this._device.queue.writeBuffer(this._cameraBuffer,
      this._camera._pose.byteLength, this._camera._focal);
  }

  updateGeometry() {
    this._camera.updateSize(this._imgWidth, this._imgHeight);
    this._device.queue.writeBuffer(this._cameraBuffer,
      this._camera._pose.byteLength + this._camera._focal.byteLength,
      this._camera._resolutions);
  }
}

// ── HUD construction ──────────────────────────────────────────────────────────

function buildHUD() {
  // ── HUD helpers ──────────────────────────────────────────────────────────
  function addKey(parent, label) {
    const btn = document.createElement('span');
    btn.className   = 'hud-button';
    btn.textContent = label;
    parent.appendChild(btn);
  }

  function addRow(parent, labelText, keys, liveEl) {
    const row = document.createElement('div');
    row.className = 'hud-control-row';
    const lbl = document.createElement('span');
    lbl.className   = 'hud-label';
    lbl.textContent = labelText;
    row.appendChild(lbl);
    for (const k of keys) { addKey(row, k); }
    if (liveEl) { row.appendChild(liveEl); }
    parent.appendChild(row);
  }

  function addSection(hud, title) {
    const sec = document.createElement('div');
    sec.className = 'hud-section';
    const hdr = document.createElement('div');
    hdr.className   = 'hud-section-header';
    hdr.textContent = title;
    sec.appendChild(hdr);
    hud.appendChild(sec);
    return sec;
  }

  // ── Build the HUD panel ──────────────────────────────────────────────────
  const hud = document.createElement('div');
  hud.id = 'hud';

  const titleEl = document.createElement('div');
  titleEl.className   = 'hud-title';
  titleEl.textContent = 'Project 7 — Volume Rendering';
  hud.appendChild(titleEl);

  // SCENE NAVIGATION
  const sceneSec = addSection(hud, 'SCENE NAVIGATION');
  addRow(sceneSec, 'Next / Prev Scene', ['Tab', 'Shift+Tab']);
  addRow(sceneSec, 'Jump to Scene',     ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']);
  const hudSceneEl = document.createElement('span');
  hudSceneEl.id        = 'scene-name';
  hudSceneEl.className = 'hud-value hud-value--truncated';
  addRow(sceneSec, 'Active Scene', [], hudSceneEl);

  // CAMERA
  const camSec = addSection(hud, 'CAMERA');
  const hudCamModeEl = document.createElement('span');
  hudCamModeEl.id        = 'cam-mode';
  hudCamModeEl.className = 'hud-value';
  addRow(camSec, 'Toggle Ortho / Projective', ['P'], hudCamModeEl);
  const hudFocalEl = document.createElement('span');
  hudFocalEl.id        = 'focal-val';
  hudFocalEl.className = 'hud-value';
  addRow(camSec, 'Focal Length', ['+', '-'], hudFocalEl);
  addRow(camSec, 'Reset Camera', ['R']);

  // CAMERA MOVEMENT
  const movSec = addSection(hud, 'CAMERA MOVEMENT');
  addRow(movSec, 'Move Forward / Back', ['W', 'S']);
  addRow(movSec, 'Move Left / Right',   ['A', 'D']);
  addRow(movSec, 'Move Up / Down',      ['Q', 'E']);

  // CAMERA ROTATION
  const rotSec = addSection(hud, 'CAMERA ROTATION');
  addRow(rotSec, 'Pitch (X-axis)', ['↑', '↓']);
  addRow(rotSec, 'Yaw (Y-axis)',   ['←', '→']);
  addRow(rotSec, 'Roll (Z-axis)',  ['Z', 'X']);

  const info = document.createElement('div');
  info.className   = 'hud-info';
  info.textContent = 'H — Hide / Show HUD';
  hud.appendChild(info);

  document.body.appendChild(hud);

  // Show-HUD button (visible only when HUD is hidden)
  const showBtn = document.createElement('button');
  showBtn.id          = 'show-hud-toggle';
  showBtn.textContent = 'Show HUD';
  showBtn.addEventListener('click', () => {
    hud.style.display     = '';
    showBtn.style.display = 'none';
  });
  document.body.appendChild(showBtn);

  return { hud, showBtn };
}

function updateHUD(sceneIdx, camera) {
  const nameEl  = document.getElementById('scene-name');
  const camEl   = document.getElementById('cam-mode');
  const focalEl = document.getElementById('focal-val');

  if (nameEl)  nameEl.textContent  =
    `Scene ${sceneIdx + 1} / ${SCENES.length}: ${SCENES[sceneIdx].name}`;
  if (camEl)   camEl.textContent   = camera._isProjective ? 'Projective' : 'Orthographic';
  if (focalEl) focalEl.textContent = camera._isProjective
    ? camera._focal[0].toFixed(2) : '—';
}

// ── Camera reset helper ───────────────────────────────────────────────────────

function resetCamera(camera, sceneIdx) {
  const camType = SCENES[sceneIdx].camType;
  const cfg     = SCENE_CAMERA_DEFAULTS[camType] || SCENE_CAMERA_DEFAULTS.volume;
  camera.resetPose();
  camera._isProjective = cfg.isProjective;
  // Reset focal length
  const f = cfg.focal ?? 1.0;
  camera._focal[0] = f;
  camera._focal[1] = f;
  for (const act of (cfg.actions || [])) {
    if (act.type === 'rotateX') camera.rotateX(act.angle);
    if (act.type === 'moveZ')   camera.moveZ(act.dist);
    if (act.type === 'moveY')   camera.moveY(act.dist);
  }
}

// ── Main entry point ──────────────────────────────────────────────────────────

async function main() {
  // Canvas
  const canvas = document.createElement('canvas');
  canvas.id = 'renderCanvas';
  document.body.appendChild(canvas);

  const { hud, showBtn } = buildHUD();

  // Renderer + camera
  const renderer = new RayTracer(canvas);
  await renderer.init();

  const camera = new Camera();
  resetCamera(camera, 0);

  // Volume object
  const volObj = new Project7Object(
    renderer._device,
    renderer._canvasFormat,
    camera,
    '/lib/Shaders/project_7_vol.wgsl'
  );

  updateHUD(0, camera);

  // Initialise (loads brain data + generates all procedural volumes).
  await renderer.setTracerObject(volObj);
  volObj._activeScene = 0;

  // ── Scene switching ──────────────────────────────────────────────────────

  function switchScene(idx) {
    const n = SCENES.length;
    idx = ((idx % n) + n) % n;
    volObj._activeScene = idx;
    resetCamera(camera, idx);
    // Scene index 1 forces projective camera to demonstrate pinhole model
    if (idx === 1) camera._isProjective = true;
    volObj.updateCameraPose();
    volObj.updateCameraFocal();
    updateHUD(idx, camera);
  }

  // ── Camera movement constants ────────────────────────────────────────────
  const MOVE_STEP  = 0.04;
  const ROT_STEP   = 0.035;
  const FOCAL_STEP = 0.05;

  // ── Keyboard state ───────────────────────────────────────────────────────
  const keys = new Set();

  window.addEventListener('keydown', (e) => {
    keys.add(e.key);
    switch (e.key) {
      case 'Tab':
        e.preventDefault();
        switchScene(volObj._activeScene + (e.shiftKey ? -1 : 1));
        break;
      case '1': switchScene(0);  break;
      case '2': switchScene(1);  break;
      case '3': switchScene(2);  break;
      case '4': switchScene(3);  break;
      case '5': switchScene(4);  break;
      case '6': switchScene(5);  break;
      case '7': switchScene(6);  break;
      case '8': switchScene(7);  break;
      case '9': switchScene(8);  break;
      case '0': switchScene(9);  break;

      case 'p': case 'P':
        camera._isProjective = !camera._isProjective;
        updateHUD(volObj._activeScene, camera);
        break;

      case '+': case '=':
        camera._focal[0] = Math.min(10.0, camera._focal[0] + FOCAL_STEP);
        camera._focal[1] = Math.min(10.0, camera._focal[1] + FOCAL_STEP);
        volObj.updateCameraFocal();
        updateHUD(volObj._activeScene, camera);
        break;
      case '-': case '_':
        camera._focal[0] = Math.max(0.2, camera._focal[0] - FOCAL_STEP);
        camera._focal[1] = Math.max(0.2, camera._focal[1] - FOCAL_STEP);
        volObj.updateCameraFocal();
        updateHUD(volObj._activeScene, camera);
        break;

      case 'r': case 'R':
        resetCamera(camera, volObj._activeScene);
        if (volObj._activeScene === 1) camera._isProjective = true;
        volObj.updateCameraPose();
        volObj.updateCameraFocal();
        updateHUD(volObj._activeScene, camera);
        break;

      case 'h': case 'H':
        if (hud.style.display === 'none') {
          hud.style.display     = '';
          showBtn.style.display = 'none';
        } else {
          hud.style.display     = 'none';
          showBtn.style.display = '';
        }
        break;
    }
  });
  window.addEventListener('keyup', (e) => keys.delete(e.key));

  // ── Render loop ───────────────────────────────────────────────────────────

  function processKeys() {
    let moved = false;
    if (keys.has('w') || keys.has('W')) { camera.moveZ( MOVE_STEP); moved = true; }
    if (keys.has('s') || keys.has('S')) { camera.moveZ(-MOVE_STEP); moved = true; }
    if (keys.has('a') || keys.has('A')) { camera.moveX(-MOVE_STEP); moved = true; }
    if (keys.has('d') || keys.has('D')) { camera.moveX( MOVE_STEP); moved = true; }
    if (keys.has('q') || keys.has('Q')) { camera.moveY( MOVE_STEP); moved = true; }
    if (keys.has('e') || keys.has('E')) { camera.moveY(-MOVE_STEP); moved = true; }

    if (keys.has('ArrowUp'))    { camera.rotateX(-ROT_STEP); moved = true; }
    if (keys.has('ArrowDown'))  { camera.rotateX( ROT_STEP); moved = true; }
    if (keys.has('ArrowLeft'))  { camera.rotateY(-ROT_STEP); moved = true; }
    if (keys.has('ArrowRight')) { camera.rotateY( ROT_STEP); moved = true; }
    if (keys.has('z') || keys.has('Z')) { camera.rotateZ(-ROT_STEP); moved = true; }
    if (keys.has('x') || keys.has('X')) { camera.rotateZ( ROT_STEP); moved = true; }

    if (moved) volObj.updateCameraPose();
  }

  function frame() {
    processKeys();
    renderer.render();
    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
}

main().catch((err) => {
  const p = document.createElement('p');
  p.style.cssText = 'color:#f88;font:16px monospace;padding:20px;';
  p.innerHTML = `<b>Error:</b> ${err.message}<br>${navigator.userAgent}`;
  document.body.appendChild(p);
});
