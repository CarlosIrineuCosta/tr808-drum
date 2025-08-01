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

## Current Status (Updated 2025-08-01)

### **Recently Implemented:**
- ✅ **Sample Loading System** - Complete kit switching with real samples
- ✅ **IndexedDB Storage** - Local caching of audio samples
- ✅ **Pan Controls** - Per-track panning with visual sliders
- ✅ **4 Drum Kits** - Classic 808 (synthetic), TR-808 Samples, TR-909, LinnDrum
- ✅ **Improved UI Layout** - Fixed grid alignment, stacked volume/pan controls
- ✅ **Hybrid Audio Engine** - Supports both synthetic and sample-based drums

### **Available Kits:**
- **Classic 808** - Original synthetic Tone.js sounds (default)
- **TR-808 Samples** - Real TR-808 samples from `samples/tr808/`
- **TR-909** - TR-909 drum machine samples from `samples/tr909/`
- **LinnDrum** - LinnDrum samples from `samples/linndrm/`

### **Next Development Priorities:**

#### **Priority 1: Content & Patterns**
1. **Fix kit switching during playback** - Pause/resume instead of stopping completely
2. **Create multiple 808 kit variations** - Use different 808 samples for variety
3. Add pattern variations (3-4 per genre)
4. Create pattern selector UI
5. Import MIDI patterns from downloaded packs
6. Add swing/groove timing control
7. **Replace poor quality LinnDrum samples** - Find better sample set

#### **Priority 2: User Experience**
5. File upload interface for custom samples
6. Pattern save/load functionality
7. Export patterns (MIDI/audio)
8. Complete keyboard shortcuts

#### **Priority 3: Audio Enhancements**
9. Basic effects chain (delay, reverb, filter)
10. Velocity layers for samples
11. Sample variation system
12. Master volume/EQ controls

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

### **Security & Performance Roadmap**
- **Environment variables**: API keys via build-time injection
- **Rate limiting**: Pattern generation, sample uploads per user tier
- **Input validation**: XSS protection, audio file validation
- **Performance**: Lazy loading, Web Workers, IndexedDB caching
- **PWA features**: Service worker, offline pattern editing

### **Deployment Infrastructure**
- Docker containerization with nginx serving
- CI/CD pipeline via GitHub Actions
- Multi-environment deployment (staging/production)
- Container registry integration