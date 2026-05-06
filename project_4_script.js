/*
 * project_4_script.js
 *
 * Particle system — Scroll 6 & 7 features implemented.
 *
 * Two effects rendered in the same scene (>= 20,000 particles total):
 *
 *  Effect 1 – Fireworks (FireworksSystemObject)
 *    • 10,000 coloured sparks burst outward from an emitter.
 *    • Gravity pulls sparks downward each frame.
 *    • Particles fade over their lifespan and respawn at the emitter.
 *    • Circular (torus) wrap-around at screen edges.
 *    • MOUSE CLICK moves the emitter → new burst origin.
 *    • Sprite texture: soft-circle glow (procedural, uploaded as GPU texture).
 *
 *  Effect 2 – Space Nebula (NebulaSystemObject)
 *    • 10,000 blue/purple/teal drifting dust particles.
 *    • ARROW KEYS apply a wind force in the chosen direction.
 *    • HOLD MOUSE BUTTON attracts all particles toward the cursor.
 *    • Particles wrap toroidally; stale ones respawn at random positions.
 *    • Sprite texture: same soft-circle glow.
 *
 * 10 required features:
 *   1.  Particle-system physics in compute shaders (ping-pong storage buffers).
 *   2.  Forces: gravity (fireworks), wind + central attraction (nebula).
 *   3.  Lifespan with respawn; max particle count = numParticles (enforced).
 *   4.  Position updated from velocity + acceleration (forces) each step.
 *   5.  Circular (torus) boundary condition — wrap-around on all four edges.
 *   6.  Mouse: click → move emitter (fireworks); hold → attract (nebula).
 *       Keyboard: arrow keys → wind direction (nebula).
 *   7.  Sprite texture mapping: procedural 64×64 RGBA glow texture, sampled
 *       in the fragment shader for each particle quad.
 *   8.  Recognisable effects: fireworks explosion + space nebula.
 *   9.  Real-time with 20,000 particles (10 k per system).
 *  10.  Two distinct effects sharing the same scene.
 */

import Renderer               from '/lib/Viz/2DRenderer.js'
import FireworksSystemObject  from '/lib/Scene/FireworksSystemObject.js'
import NebulaSystemObject     from '/lib/Scene/NebulaSystemObject.js'

async function init() {
  // ----------------------------------------------------------------
  // Canvas + renderer
  // ----------------------------------------------------------------
  const canvasTag = document.createElement('canvas');
  canvasTag.id = 'renderCanvas';
  document.body.appendChild(canvasTag);

  const renderer = new Renderer(canvasTag);
  await renderer.init();

  // Dark starfield background suits both effects.
  renderer._clearColor = { r: 0.0, g: 0.0, b: 0.05, a: 1.0 };

  // ----------------------------------------------------------------
  // Scene objects  (nebula drawn first — behind fireworks)
  // ----------------------------------------------------------------
  const nebula    = new NebulaSystemObject(
    renderer._device, renderer._canvasFormat,
    '/lib/Shaders/nebula_particles.wgsl', 10000,
  );
  const fireworks = new FireworksSystemObject(
    renderer._device, renderer._canvasFormat,
    '/lib/Shaders/fireworks_particles.wgsl', 10000,
  );

  await renderer.appendSceneObject(nebula);
  await renderer.appendSceneObject(fireworks);

  // ----------------------------------------------------------------
  // Helper: convert a MouseEvent to NDC [-1, 1]²
  // ----------------------------------------------------------------
  function toNDC(event) {
    const rect = canvasTag.getBoundingClientRect();
    const x =  ((event.clientX - rect.left) / rect.width)  * 2 - 1;
    const y = -((event.clientY - rect.top)  / rect.height) * 2 + 1;
    return { x, y };
  }

  // ----------------------------------------------------------------
  // Mouse interaction
  // ----------------------------------------------------------------
  // Left-click → move the fireworks emitter to the clicked position.
  canvasTag.addEventListener('click', (e) => {
    const { x, y } = toNDC(e);
    fireworks.setEmitter(x, y);
  });

  // Hold mouse button → attract nebula particles toward the cursor.
  canvasTag.addEventListener('mousedown', () => nebula.setAttract(1.0));
  canvasTag.addEventListener('mouseup',   () => nebula.setAttract(0.0));

  // Track cursor position for the nebula attraction force.
  canvasTag.addEventListener('mousemove', (e) => {
    const { x, y } = toNDC(e);
    nebula.setMousePos(x, y);
  });

  // ----------------------------------------------------------------
  // Keyboard interaction — arrow keys control nebula wind direction
  // ----------------------------------------------------------------
  const keysDown = new Set();

  function updateWind() {
    let wx = 0, wy = 0;
    if (keysDown.has('ArrowLeft'))  wx -= 1;
    if (keysDown.has('ArrowRight')) wx += 1;
    if (keysDown.has('ArrowUp'))    wy += 1;
    if (keysDown.has('ArrowDown'))  wy -= 1;
    nebula.setWind(wx, wy);
  }

  window.addEventListener('keydown', (e) => {
    if (['ArrowLeft','ArrowRight','ArrowUp','ArrowDown'].includes(e.key)) {
      e.preventDefault(); // prevent page scroll
    }
    keysDown.add(e.key);
    updateWind();
  });
  window.addEventListener('keyup', (e) => {
    keysDown.delete(e.key);
    updateWind();
  });

  // ----------------------------------------------------------------
  // On-screen help overlay
  // ----------------------------------------------------------------
  const helpEl = document.createElement('div');
  helpEl.style.cssText = [
    'position:fixed', 'bottom:16px', 'left:16px',
    'color:rgba(255,255,255,0.65)', 'font:13px/1.6 monospace',
    'pointer-events:none', 'user-select:none',
    'text-shadow:0 0 6px #000',
  ].join(';');
  helpEl.innerHTML = [
    '<b>Fireworks</b>: click anywhere to move burst origin',
    '<b>Nebula</b>: hold mouse to attract dust · arrow keys = wind',
  ].join('<br>');
  document.body.appendChild(helpEl);

  // ----------------------------------------------------------------
  // Animation loop
  // ----------------------------------------------------------------
  function renderFrame() {
    renderer.render();
    requestAnimationFrame(renderFrame);
  }
  renderFrame();

  return renderer;
}

init().then(ret => {
  console.log(ret);
}).catch(error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + '<br/>' + error.message;
  document.body.appendChild(pTag);
  document.getElementById('renderCanvas').remove();
});
