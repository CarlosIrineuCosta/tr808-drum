# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Development Server
```bash
npm run dev              # Start live development server on port 3000
```

### Build & Deployment
```bash
npm run build            # Build for production (copies to dist/)
npm run format           # Format code with Prettier
npm run lint             # Lint code (placeholder - to be implemented)
npm run test             # Run tests (placeholder - to be implemented)
```

### Docker Operations
```bash
npm run docker:build    # Build Docker image
npm run docker:run      # Run container on port 3000
npm run docker:stop     # Stop and remove container
npm run compose:up      # Start with docker-compose
npm run compose:down    # Stop docker-compose services
npm run compose:logs    # View container logs
```

### Deployment
```bash
npm run deploy:staging      # Deploy to staging environment
npm run deploy:production   # Deploy to production environment
```

## Project Architecture

### Core Structure
This is a single-page web application built as a TR-808 drum machine with AI pattern generation. The main application file is `tr808-mvp.html` which contains all HTML, CSS, and JavaScript in a single file for simplicity.

### Technology Stack
- **Audio Engine**: Tone.js v14.8.49 for Web Audio API abstraction
- **AI Integration**: Claude API for pattern generation
- **Frontend**: Vanilla JavaScript (single-file approach)
- **Styling**: CSS3 with custom properties for theming
- **Development**: live-server for local development

### Key Components (within tr808-mvp.html)
1. **Drum Engine**: Manages 8 drum tracks with velocity and accent control
2. **Sequencer**: 16-step pattern sequencer with visual feedback
3. **AI Pattern Generator**: Natural language pattern generation via Claude API
4. **Preset System**: 8 built-in genre presets (Classic 808, Trap, Techno, etc.)
5. **Transport Controls**: Play/stop, tempo control, tap tempo
6. **Per-track Controls**: Volume, mute, solo for each drum sound

### Audio Architecture
The application uses synthetic drum sounds generated with Tone.js oscillators and filters rather than samples. Each drum sound is carefully crafted to emulate classic TR-808 characteristics:
- Kick: Sub-bass oscillator with pitch envelope
- Snare: Noise generator with bandpass filtering
- Hi-hats: High-frequency noise with quick decay
- Clap: Multiple noise bursts with reverb

### State Management
All application state is managed in vanilla JavaScript with global objects:
- `patterns`: Current step patterns for all tracks
- `accents`: Accent patterns for velocity control
- `trackStates`: Mute/solo states per track
- `tempoManager`: BPM and timing control

### Development Notes

#### Current Architecture Constraints
- **Single-file approach**: All HTML, CSS, and JavaScript in `tr808-mvp.html` for simplicity
- **No build process**: Direct development without transpilation or bundling
- **CDN dependencies**: Tone.js loaded from external CDN, no local package management
- **Synthetic audio**: Uses Tone.js oscillators/filters instead of audio samples
- **Local-only storage**: Patterns saved to browser localStorage, no cloud sync yet

#### Code Organization (within tr808-mvp.html)
- **CSS Variables**: Extensive use of CSS custom properties for theming (lines ~10-26)
- **Modular JS**: Functional approach with clear separation of concerns:
  - Audio engine initialization and drum sound definitions
  - Pattern management and step sequencer logic
  - UI event handlers and visual feedback
  - AI integration for pattern generation
  - Transport controls and tempo management

#### Key Development Patterns
- **Event-driven architecture**: Heavy use of event listeners for UI interactions
- **State management**: Global objects for patterns, accents, trackStates
- **Audio scheduling**: Tone.js Transport for precise timing and scheduling
- **Responsive design**: CSS Grid and Flexbox for drum machine layout
- **Local persistence**: JSON serialization to localStorage for pattern saving

#### Testing Considerations
- Audio testing requires user interaction (browser autoplay policies)
- Visual feedback testing needs timing validation
- Pattern generation requires API key for Claude integration
- Cross-browser audio compatibility (Web Audio API support)

### Future Architecture & Development Phases

#### Phase 1: Core Enhancements (Next 2-4 weeks)
- **Sample-based audio**: Replace synthetic sounds with authentic TR-808 samples
- **Multiple drum kits**: 808, 909, 707, LinnDrum sample sets
- **Local sample upload**: Allow users to import custom drum samples
- **Enhanced effects**: Basic delay, reverb, and filtering
- **Pattern chaining**: Link patterns for song-like structures

#### Phase 2: Cloud Integration (Weeks 3-6)
- **Firebase Authentication**: Google, email/password, anonymous auth
- **User profiles**: Settings, preferences, subscription tiers
- **Pattern cloud storage**: Sync patterns across devices via Firestore
- **Public pattern sharing**: Community patterns with likes/plays tracking
- **Subscription system**: Free/Pro/Premium tiers with usage limits

#### Phase 3: Modern Frontend (Weeks 5-8)
- **Framework migration**: React or Vue.js with component architecture
- **Build system**: Vite for development and production builds
- **State management**: Redux/Zustand for complex state handling
- **TypeScript**: Type safety for larger codebase
- **Component library**: Reusable UI components with Storybook
- **Mobile PWA**: Service worker, offline capability, install prompts

#### Phase 4: Advanced Features (Weeks 7-10)
- **MIDI integration**: Web MIDI API for hardware controller support
- **Real-time collaboration**: WebRTC for shared pattern editing
- **Advanced AI**: Context-aware pattern generation, style transfer
- **DAW integration**: MIDI export, project file formats
- **Effects chain**: Professional audio processing with visual feedback
- **Performance optimization**: Web Workers, audio worklets

#### Phase 5: Platform Expansion (Future)
- **Native apps**: Electron desktop app, React Native mobile
- **VST plugin**: Desktop audio plugin version
- **Hardware integration**: Direct TR-808 hardware communication
- **Social platform**: User following, pattern remixing, competitions
- **Monetization**: Premium samples, advanced AI features, collaboration tools

### API Architecture (Planned)
```
Authentication: Firebase Auth + custom JWT
Database: Firestore for patterns, user data
Storage: Firebase Storage for samples, exports
CDN: Cloudflare for sample delivery
Search: Algolia for pattern discovery
Analytics: Google Analytics 4 + custom events
```

## Current Status (Updated 2025-08-02)

### **Recently Implemented (Session 2025-08-02):**
- ✅ **Fixed Kit Switching During Playback** - Now uses pause/resume instead of stopping completely
- ✅ **4 TR-808 Kit Variations** - Created separate kits using different TR-808 sample variations
- ✅ **Pattern Variations System** - Added 6 new patterns based on StudioBrootle hip hop patterns
- ✅ **Pattern Selector UI** - Dropdown with pattern selection and intelligent randomization
- ✅ **Transport Control Revamp** - Complete UI reorganization with 3-section layout
- ✅ **Organized MIDI Patterns** - Cleaned up user's MIDI pattern collection in `/patterns/drums/`

### **Previously Implemented (Session 2025-08-01):**
- ✅ **Sample Loading System** - Complete kit switching with real samples
- ✅ **IndexedDB Storage** - Local caching of audio samples
- ✅ **Pan Controls** - Per-track panning with visual sliders
- ✅ **Hybrid Audio Engine** - Supports both synthetic and sample-based drums

### **Available Kits (7 Total):**
- **Classic 808** - Original synthetic Tone.js sounds (default)
- **TR-808 Vintage** - TR-808 samples using 0000/00 variants (classic sound)  
- **TR-808 Punch** - TR-808 samples using 2500/25 variants (mid-punch)
- **TR-808 Deep** - TR-808 samples using 5000/50 variants (deeper, warmer)
- **TR-808 Bright** - TR-808 samples using 7500/75 variants (brighter, more attack)
- **TR-909** - TR-909 drum machine samples from `samples/tr909/`
- **LinnDrum** - LinnDrum samples from `samples/linndrm/` (needs quality upgrade)

### **Available Patterns (14 Total):**
- **Original 8 Genre Presets:** Classic 808, Trap, Techno, House, Breakbeat, Latin, Funk, D&B
- **New 6 Pattern Variations:** Hip Hop Basic, Hip Hop Swing, Trap Rolling, Trap Triplets, Old School, Boom Bap

### **New UI Layout (Session 2025-08-02):**

#### **Pattern Activity Section (Top):**
- **Generate Line**: Compact AI input with "Generate" button (requires API key)
- **8 Preset Buttons**: Classic 808, Trap, Techno, House, Breakbeat, Latin, Funk, D&B
- **Pattern Controls**: Pattern dropdown + 🎲 RANDOM (red) + ⌫ CLEAR buttons

#### **Transport Controls (3 Rows):**
- **Row 1**: `[▶ PLAY] [⏹ STOP]` + compact status display `[120] [READY]`
- **Row 2**: `[TEMPO ——●——] [TAP]` (centered, compact slider)
- **Row 3**: `[KIT: TR-909 ▼] [📁 LOAD]` (kit selection only)

#### **Pattern System Features:**
- **Intelligent Randomization**: Different probabilities per instrument (kick 70% on beats 1&3, snare 80% on 2&4, etc.)
- **Pattern Variations**: Based on StudioBrootle hip hop patterns with authentic drum programming
- **Seamless Kit Switching**: Maintains playback timing when switching between kits

### **Next Development Priorities:**

#### **Priority 1: API Integration & Content**
1. **Create API key configuration system** - Support for Claude + Gemini APIs
2. **Download better LinnDrum samples** - From Goldbaby, Drumkito, J5 Music, BVKER
3. Import MIDI patterns from downloaded packs (organized in `/patterns/drums/`)
4. Add swing/groove timing control
5. Create more pattern variations per genre

#### **Priority 2: User Experience**
6. File upload interface for custom samples
7. Pattern save/load functionality  
8. Export patterns (MIDI/audio)
9. Complete keyboard shortcuts

#### **Priority 3: Audio Enhancements**
10. Basic effects chain (delay, reverb, filter)
11. Velocity layers for samples
12. Sample variation system
13. Master volume/EQ controls

### **Sample Directory Structure:**
```
samples/
├── tr808/          # TR-808 samples (organized by instrument)
│   ├── BD/         # Bass drums (BD0000.WAV, etc.)
│   ├── SD/         # Snares (SD0000.WAV, etc.)
│   └── ...
├── tr909/          # TR-909 samples (filename format: BT0A0A7.WAV, etc.)
└── linndrm/        # LinnDrum samples (kick.wav, sd.wav, etc.)
```

### **Recommended Downloads (Session 2025-08-02):**

#### **Better LinnDrum Samples:**
1. **Goldbaby.co.nz/freestuff.html** - Free vintage drum samples (high quality, recommended)
2. **Drumkito.com/sample-packs/linndrum-sample-pack/** - Free LinnDrum pack
3. **J5music.com/products/linn-drum-kit** - Free 24bit wav + MIDI loops
4. **BVKER.com/retouched-linn-drum-samples/** - 49 modernized samples
5. **samples.kb6.de/machines/kawai-korg-linn.htm** - Vintage archive

#### **Additional MIDI Patterns:**
1. **StudioBrootle.com/hip-hop-drum-patterns/** - Free visual patterns (9 patterns extracted)
2. **StudioBrootle.com/trap-drum-patterns/** - More trap patterns  
3. **EssentialMIDI.com/products/free-hip-hop-midi-pack** - 130+ free MIDI files

#### **Current MIDI Pattern Collection:**
- **Location**: `/patterns/drums/` (organized from user's `midi_patterns/` folder)
- **Hip Hop**: 10 loops at 90 BPM (HipHop_01.mid - HipHop_10.mid)
- **Chart Trap**: 6 patterns at 134 BPM (Trap_Kick.mid, Trap_Snare.mid, etc.)
- **UK Drill**: 6 patterns at 142 BPM (Drill patterns)

### **Security & Performance Roadmap**
- **Environment variables**: API keys via build-time injection (Claude + Gemini)
- **Rate limiting**: Pattern generation, sample uploads per user tier
- **Input validation**: XSS protection, audio file validation  
- **Performance**: Lazy loading, Web Workers, IndexedDB caching
- **PWA features**: Service worker, offline pattern editing

### **Deployment Infrastructure**
- Docker containerization with nginx serving
- CI/CD pipeline via GitHub Actions
- Multi-environment deployment (staging/production)
- Container registry integration