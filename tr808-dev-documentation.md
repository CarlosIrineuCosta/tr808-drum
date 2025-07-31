# TR-808 AI Drum Machine Documentation

## Architecture Overview

This drum machine is built with a modular architecture that separates the pattern grid functionality from track controls. This separation is critical for maintaining stability and preventing layout corruption.

## Core Components

### Pattern Grid System (Protected)
The pattern grid handles the 16-step sequencer interface and must remain isolated from other systems.

**Critical Functions:**
- `createPatternGrid()` - Creates only the 16 step buttons
- `toggleStep()` - Manages step state transitions (off → on → accent → off)
- `updatePattern()` - Updates visual state of pattern steps

**Warning:** These functions are marked as "VITAL PATTERN GRID FUNCTIONS" and should not be modified unless specifically requested. Any changes risk breaking the core sequencer functionality.

### Track Controls System (Modifiable)
Handles instrument labels, volume controls, and mute/solo functionality.

**Functions:**
- `createTrackControls()` - Creates labels, volume sliders, M/S buttons
- `updateTrackVolume()` - Manages audio routing based on mute/solo state
- `toggleMute()` / `toggleSolo()` - Handles track isolation

### Audio Engine
Uses Tone.js for sound synthesis with dedicated instruments for each drum type:
- BD (Bass Drum) - MembraneSynth
- SD (Snare Drum) - NoiseSynth  
- LT/MT/HT (Toms) - MembraneSynth with different pitches
- RS (Rim Shot) - NoiseSynth
- CH/OH (Hi-hats) - NoiseSynth with highpass filtering

## Data Structures

### Pattern Storage
```javascript
pattern[instrument_id][step_index] = 0 | 1
accents[instrument_id][step_index] = true | false
```

### Audio State
```javascript
volumes[instrument_id] = 0.0 to 1.0
muted[instrument_id] = true | false
soloed[instrument_id] = true | false
```

## Grid Layout Constraints

The track layout uses CSS Grid with specific column structure:
```css
grid-template-columns: 60px 40px 30px repeat(16, 1fr);
```

- Column 1: Track label (60px)
- Column 2: Volume slider (40px)
- Column 3: Mute/Solo buttons (30px)
- Columns 4-19: Step buttons (flexible, 16 total)

## Pattern Database

Preset patterns are stored in `patternDatabase` object with keys:
- classic808, trap, techno, house, breakbeat, latin, funk, dnb

Each pattern contains arrays of 16 binary values for each instrument.

## AI Integration

The system integrates with Claude API for pattern generation:
- Accepts natural language descriptions
- Returns JSON pattern objects
- Maintains 16-step constraint
- Preserves instrument mapping

## Sequencer Timing

- Uses `setInterval` for step advancement
- Timing calculation: `(60 / tempo / 4) * 1000` milliseconds
- Supports tempo range: 60-200 BPM
- Step counter cycles 0-15

## Mute/Solo Logic

Solo state overrides mute state:
- If any track is soloed, only soloed tracks play
- Muted tracks remain muted regardless of solo state
- Volume sliders work in conjunction with mute/solo

## Critical Separation Requirements

1. **Pattern grid functions must remain isolated** - Any mixing with control creation causes layout corruption
2. **CSS Grid structure must be maintained** - Column count changes break step button positioning  
3. **Step button event handlers must only handle pattern logic** - No control-related code in pattern functions
4. **Track creation must happen before pattern grid creation** - DOM elements must exist before step buttons are added

## Code Modification Guidelines

### Safe to Modify:
- Track control styling and layout
- Audio synthesis parameters
- Transport controls
- AI integration
- Preset database
- Volume/mute/solo logic

### Dangerous to Modify:
- Pattern grid creation functions
- Step button click handlers
- CSS Grid column structure
- DOM query selectors for steps
- Pattern data structure format

## Testing Requirements

After any modification, verify:
1. All 8 tracks display with correct layout
2. 16 step buttons per track are clickable
3. Round-robin clicking works (off → on → accent → off)
4. Mute/solo buttons function correctly
5. No visual artifacts or layout corruption
6. Audio playback operates correctly

## Future Extensibility

The modular architecture supports:
- Additional track controls (swing, effects, etc.)
- Visual theme systems
- Extended pattern lengths
- Additional instruments
- Save/load functionality

All extensions should maintain the core separation between pattern grid and control systems.