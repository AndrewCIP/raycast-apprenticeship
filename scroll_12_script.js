import PerlinNoise from '/lib/Scene/Noises.js'

// ── Rendering modes ───────────────────────────────────────────────────────────
const MODE_GRAYSCALE  = 0;
const MODE_COLOR      = 1;
const MODE_OCTAVE     = 2;
const MODE_NAMES = [
  'Grayscale (noise2d)',
  'Color terrain (noise2d)',
  'Octave terrain (octaveNoise2d)',
];

// ── Map a noise value in [-1, 1] to a grayscale byte ─────────────────────────
function toGray(n) {
  return Math.max(0, Math.min(255, Math.floor((n + 1) * 0.5 * 255)));
}

// ── Map a noise value in [-1, 1] to an RGBA terrain color ───────────────────
function toTerrain(n, data, i) {
  const h = (n + 1) * 0.5; // normalise to [0, 1]
  let r, g, b;
  if      (h < 0.30) { r = 30;  g = 80;  b = 180; } // deep water
  else if (h < 0.40) { r = 65;  g = 120; b = 210; } // shallow water
  else if (h < 0.45) { r = 210; g = 195; b = 140; } // sand / beach
  else if (h < 0.65) { r = 85;  g = 150; b = 70;  } // grass
  else if (h < 0.78) { r = 100; g = 100; b = 80;  } // dirt / rock
  else if (h < 0.90) { r = 130; g = 130; b = 125; } // stone
  else               { r = 240; g = 240; b = 255; } // snow
  data[i    ] = r;
  data[i + 1] = g;
  data[i + 2] = b;
  data[i + 3] = 255;
}

// ── Draw the noise into the canvas ───────────────────────────────────────────
function drawNoise(ctx, noise, mode, freq, octaves) {
  const W = ctx.canvas.width;
  const H = ctx.canvas.height;
  const img = ctx.createImageData(W, H);
  const d = img.data;

  for (let y = 0; y < H; y++) {
    for (let x = 0; x < W; x++) {
      const i = (y * W + x) * 4;
      let n;
      if (mode === MODE_OCTAVE) {
        n = noise.octaveNoise2d(x, y, freq, 1, 0.5, octaves, 2);
        // octave sum can exceed [-1,1]; clamp before mapping
        n = Math.max(-1, Math.min(1, n));
      } else {
        n = noise.noise2d(x * freq * 200, y * freq * 200);
      }

      if (mode === MODE_COLOR || mode === MODE_OCTAVE) {
        toTerrain(n, d, i);
      } else {
        const v = toGray(n);
        d[i    ] = v;
        d[i + 1] = v;
        d[i + 2] = v;
        d[i + 3] = 255;
      }
    }
  }

  ctx.putImageData(img, 0, 0);
}

// ── Verification: print expected noise properties to the console ──────────────
function runVerification(noise) {
  console.log('=== Perlin Noise Verification ===');

  // Property 1: noise2d and noise3d produce non-trivial, varying output
  const s1 = noise.noise2d(0.3, 0.7);
  const s2 = noise.noise2d(1.3, 2.7);
  const s3 = noise.noise2d(5.5, 3.2);
  console.log(`noise2d samples: ${s1.toFixed(4)}, ${s2.toFixed(4)}, ${s3.toFixed(4)}`);
  const vary2d = !(s1 === s2 && s2 === s3);
  console.log(`noise2d varies:  ${vary2d ? 'PASS' : 'FAIL'}`);

  // Property 2: output is bounded (gradient dot products are bounded by the gradient magnitudes)
  const samples2d = [noise.noise2d(0.5, 0.5), noise.noise2d(0.25, 0.75), noise.noise2d(0.1, 0.9)];
  const samples3d = [noise.noise3d(0.5, 0.5, 0.5), noise.noise3d(0.25, 0.75, 0.25)];
  const bounded2d = samples2d.every(v => v >= -2 && v <= 2);
  const bounded3d = samples3d.every(v => v >= -2 && v <= 2);
  console.log(`noise2d bounded [-2,2]: ${bounded2d ? 'PASS' : 'FAIL'}`);
  console.log(`noise3d bounded [-2,2]: ${bounded3d ? 'PASS' : 'FAIL'}`);

  // Property 3: octave noise sums multiple scales
  const single = noise.noise2d(100 * 0.005, 200 * 0.005);
  const octave = noise.octaveNoise2d(100, 200, 0.005, 1, 0.5, 4, 2);
  console.log(`noise2d (1 octave):    ${single.toFixed(6)}`);
  console.log(`octaveNoise2d (4 oct): ${octave.toFixed(6)}`);
  const octavesDiffer = Math.abs(single - octave) > 1e-9;
  console.log(`Octave accumulates:    ${octavesDiffer ? 'PASS' : 'FAIL'}`);

  console.log('=================================');
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function init() {
  const noise = new PerlinNoise();

  // Run console verification before drawing anything
  runVerification(noise);

  // ── Canvas ────────────────────────────────────────────────────────────────
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const ctx = canvasTag.getContext('2d');

  let mode    = MODE_GRAYSCALE;
  let freq    = 0.005;
  let octaves = 4;

  function resize() {
    const dpr = window.devicePixelRatio || 1;
    canvasTag.width  = Math.floor(window.innerWidth  * dpr);
    canvasTag.height = Math.floor(window.innerHeight * dpr);
    canvasTag.style.width  = `${window.innerWidth}px`;
    canvasTag.style.height = `${window.innerHeight}px`;
    draw();
  }

  function draw() {
    drawNoise(ctx, noise, mode, freq, octaves);
    updateHud();
  }

  // ── HUD ───────────────────────────────────────────────────────────────────
  const hud = document.createElement('div');
  hud.id = 'hud';

  const titleEl = document.createElement('div');
  titleEl.className   = 'hud-title';
  titleEl.textContent = 'Scroll 12 — Perlin Noise';
  hud.appendChild(titleEl);

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
    for (const k of keys) addKey(row, k);
    if (liveEl) row.appendChild(liveEl);
    parent.appendChild(row);
  }

  function addSection(parent, title) {
    const sec = document.createElement('div');
    sec.className = 'hud-section';
    const hdr = document.createElement('div');
    hdr.className   = 'hud-section-header';
    hdr.textContent = title;
    sec.appendChild(hdr);
    parent.appendChild(sec);
    return sec;
  }

  // RENDERING MODE
  const renderSec = addSection(hud, 'RENDERING MODE');
  addRow(renderSec, 'Grayscale (noise2d)',          ['1']);
  addRow(renderSec, 'Color terrain (noise2d)',       ['2']);
  addRow(renderSec, 'Octave terrain (octaveNoise2d)', ['3']);

  const modeEl = document.createElement('span');
  modeEl.className = 'hud-value';
  addRow(renderSec, 'Active mode', [], modeEl);

  // PARAMETERS
  const paramSec = addSection(hud, 'PARAMETERS');

  const freqEl = document.createElement('span');
  freqEl.className = 'hud-value';
  addRow(paramSec, 'Frequency', ['+', '-'], freqEl);

  const octEl = document.createElement('span');
  octEl.className = 'hud-value';
  addRow(paramSec, 'Octaves (octave mode)', ['[', ']'], octEl);

  addRow(paramSec, 'Regenerate permutation', ['R']);

  const info = document.createElement('div');
  info.className   = 'hud-info';
  info.textContent = 'H — Hide / Show HUD';
  hud.appendChild(info);

  document.body.appendChild(hud);

  const showBtn = document.createElement('button');
  showBtn.id          = 'show-hud-toggle';
  showBtn.textContent = 'Show HUD';
  showBtn.addEventListener('click', () => {
    hud.style.display     = '';
    showBtn.style.display = 'none';
  });
  document.body.appendChild(showBtn);

  function updateHud() {
    modeEl.textContent = MODE_NAMES[mode];
    freqEl.textContent = freq.toFixed(4);
    octEl.textContent  = octaves;
  }

  // ── Keyboard ──────────────────────────────────────────────────────────────
  window.addEventListener('keydown', (e) => {
    switch (e.key) {
      case '1': mode = MODE_GRAYSCALE; draw(); break;
      case '2': mode = MODE_COLOR;     draw(); break;
      case '3': mode = MODE_OCTAVE;    draw(); break;

      case '+': case '=':
        freq = Math.min(0.05, +(freq + 0.001).toFixed(4));
        draw(); break;
      case '-':
        freq = Math.max(0.001, +(freq - 0.001).toFixed(4));
        draw(); break;

      case ']':
        octaves = Math.min(8, octaves + 1);
        draw(); break;
      case '[':
        octaves = Math.max(1, octaves - 1);
        draw(); break;

      case 'r': case 'R':
        noise.gradientPermutation();
        draw(); break;

      case 'h': case 'H':
        if (hud.style.display === 'none') {
          hud.style.display     = '';
          showBtn.style.display = 'none';
        } else {
          hud.style.display     = 'none';
          showBtn.style.display = '';
        }
        return;

      default: return;
    }
  });

  window.addEventListener('resize', resize);
  resize();

  return ctx;
}

init().then(ret => {
  console.log(ret);
}).catch(error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + '<br>' + error.message;
  document.body.appendChild(pTag);
  const canvas = document.getElementById('renderCanvas');
  if (canvas) canvas.remove();
});
