# REQUIREMENTS & RESEARCH DOSSIER
## Space Invaders - Pixel-Perfect Web Implementation

---

## 1. GOALS

Deliver a pixel-perfect, modernized web implementation of Space Invaders that:
- Recreates the original 1978 arcade game's visual fidelity and core mechanics
- Renders at authentic 224×256 resolution with modern full-color sprites
- Scales gracefully to fit any browser window while maintaining aspect ratio
- Runs at the original 60 Hz frame rate
- Provides keyboard-based controls
- Focuses on core single-player gameplay without extended features

---

## 2. USER SCENARIOS

### Primary Scenario: Play Session
1. User opens web application in browser
2. Game renders centered in viewport with letterboxing
3. User uses keyboard (Left/Right arrows, Space to fire) to control cannon
4. User destroys alien waves, avoids enemy fire, uses shields strategically
5. Game ends when all lives are lost or aliens reach bottom
6. User can restart to play again

### Out of Scope for MVP
- Two-player alternating mode
- High score persistence between sessions
- Sound effects and music (deferred post-MVP)
- Pause/resume functionality
- Settings or configuration screens

---

## 3. FEATURES

### Core Gameplay (MVP)
- Single-player mode with 3 starting lives
- Player cannon movement (horizontal only, bottom of screen)
- Player shooting with single-bullet-on-screen limitation
- 5 rows × 11 columns of aliens (3 types: Squid, Crab, Octopus)
- Alien horizontal movement with directional reversal and vertical descent
- **Intentional speed increases:** Aliens speed up as they are destroyed (designed difficulty progression)
- Three types of alien shots (Rolling, Plunger, Squiggly) with distinct visual patterns, all firing straight down
- Four destructible shields with pre-defined damage states
- UFO/mystery ship appearances based on shot counter timing (original logic without bug)
- Lives system with game-over conditions
- Score tracking (displayed, not persisted)
- Wave progression (new wave spawns after clearing all aliens)

### Deferred Post-MVP
- Sound effects (10 effects documented)
- Background music tempo
- High score persistence
- Two-player mode
- Pause/menu system

---

## 4. KNOWN CONSIDERATIONS

### UX Considerations
- **Responsive Scaling:** Game must scale smoothly across different browser window sizes while maintaining 224×256 aspect ratio
- **Letterboxing:** Black bars on sides/top/bottom to preserve aspect ratio
- **Keyboard Controls:** Clear, responsive input handling (Left, Right, Fire)
- **Visual Clarity:** Modern full-color sprites with custom color palette should be crisp when scaled
- **Restart Flow:** Simple way to restart after game over

### Technical Considerations
- **Fixed Resolution Rendering:** Render game at exact 224×256, then scale canvas to fit viewport
- **60 Hz Game Loop:** Fixed timestep at 60 Hz to match original timing
- **Pixel-Perfect Sprites:** All sprite dimensions must match original specifications
- **Collision Detection:** Sprite bounding-box collision (simpler than bit-level)
- **Shield Damage:** Pre-defined damage states (simpler than true pixel destruction)
- **Frame-Independent Timing:** Movement speeds defined in pixels-per-frame at 60 Hz
- **State Management:** Game state machine for start, playing, game-over, wave-clear
- **Canvas Rendering:** Flutter web canvas rendering performance at 60 FPS
- **Difficulty Progression:** Intentional speed increase algorithm as aliens are destroyed
- **UFO Timing:** Shot-counter-based appearance logic (original algorithm, corrected)
- **Alien Shots:** Simplified straight-down firing patterns

### QA Considerations
- **Gameplay Accuracy:** Movement speeds, bullet speeds, alien behavior must feel authentic
- **Edge Cases:**
  - Last alien behavior
  - Bottom-row alien shooting behavior (should work correctly)
  - UFO scoring (correct shot-counter pattern)
  - Collision detection at boundaries
  - Shield damage state transitions
  - Alien speed progression curve feels balanced
- **Performance:** Maintain 60 FPS across different browsers and devices
- **Input Responsiveness:** No dropped inputs or lag
- **Browser Compatibility:** Chrome, Firefox, Safari, Edge

---

## 5. TECH NOTES FROM RESEARCH

### Original Hardware Specifications
- **Display:** 224×256 pixels, portrait orientation
- **Frame Rate:** 60 Hz with two interrupts (mid-screen and vertical blank)
- **CPU:** Intel 8080 at ~2.0 MHz
- **Color System:** Monochrome CRT with colored gel overlays (green bottom, red/orange top) - we'll use custom modern color palette instead
- **Sound Chip:** TI SN76477 for UFO sound; discrete analog circuits for other 9 effects (deferred post-MVP)

### Critical Mechanics
- **Single Bullet Limit:** Player can only have ONE bullet on-screen at a time
- **Alien Movement:** 2 pixels horizontal per step, 8 pixels vertical drop on reversal
- **Bullet Speeds:**
  - Player: 4 pixels/frame (240 px/sec)
  - Alien: 4 pixels/frame normally
- **Scoring:**
  - Squid (top row): 30 points
  - Crab (middle rows): 20 points
  - Octopus (bottom rows): 10 points
  - UFO: 50, 100, 150, 200, or 300 points (pattern-based on shot counter)
- **Shield Dimensions:** 22×16 pixels, pre-defined damage states
- **Sprite Dimensions:**
  - Squid: 8×8 pixels
  - Crab: 11×8 pixels
  - Octopus: 12×8 pixels
  - Player cannon: ~13-16×8 pixels
  - UFO: ~16×7-8 pixels
  - Player bullet: 2×4 pixels
  - Alien bullets: ~3-8 pixels wide, varying heights

### Modernization Decisions
1. **No Speed Bug:** Implement intentional difficulty progression instead of accidental CPU bottleneck
2. **Correct Bottom-Row Shooting:** Aliens can hit player from all rows
3. **Corrected UFO Pattern:** Use original 16-shot logic (not buggy 15-shot)
4. **Clean Rendering:** No visual trail artifacts
5. **Proper Collision Boundaries:** Bounding-box collision with correct detection
6. **Simplified Mechanics:** Straight-down alien shots, pre-defined shield damage states

### Technology Choices
- **Platform:** Flutter Web
- **Rendering:** Canvas with scaled pixel-perfect sprites
- **Game Loop:** Custom game loop at 60 Hz fixed timestep
- **Assets:** Full-color sprite images with custom modern palette matching original dimensions
- **Input:** Keyboard event handling
- **Collision:** Sprite bounding-box detection
- **Shield System:** State machine with pre-rendered damage sprites

### Compatibility & Constraints
- Must run in modern web browsers (Chrome, Firefox, Safari, Edge)
- No mobile/touch support required
- No sound implementation in MVP
- No persistent storage required

---

## 6. DESIGN DECISIONS (From Open Questions)

1. **Alien Speed Progression:** Implement intentional speed increases as designed difficulty (e.g., every N aliens destroyed, speed increases by X%)

2. **Collision Detection:** Sprite bounding-box collision (simpler, performant, slightly less granular than bit-level)

3. **Shield Destruction:** Pre-defined damage states (e.g., pristine → damaged1 → damaged2 → destroyed) with corresponding sprite assets

4. **UFO Appearance:** Following original timing logic based on shot counter (corrected version without the 15-shot bug)

5. **Alien Shot Patterns:** Simpler straight-down firing patterns for all three shot types (visual distinction only)

6. **Color Palette:** Fully custom modern color palette for sprites and UI

---

## 7. ASSUMPTIONS

1. **Sprite Assets:** We will create or source full-color sprite images matching original dimensions
2. **Restart Mechanism:** Simple "press key to restart" after game over
3. **Browser Performance:** Modern browsers can handle 60 FPS canvas rendering at scale
4. **No Mobile:** Web-only means desktop browsers; mobile browser support not required
5. **Damage States:** 3-4 damage states per shield will provide sufficient visual feedback
6. **Speed Curve:** Will design a progressive speed increase curve that feels balanced (exact formula TBD in architecture phase)
7. **UFO Values:** Will implement correct pattern from original research (not purely random)
8. **Color Design:** Team will select appropriate modern color palette during design phase
