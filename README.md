# TR-808 AI Drum Machine

A web-based TR-808 drum machine with AI-powered pattern generation, authentic drum samples, and professional audio effects.

![TR-808 AI Demo](https://img.shields.io/badge/Demo-Live-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)
![Version](https://img.shields.io/badge/Version-1.0.0-orange)

## Features

- **Authentic TR-808 Interface** - Classic design with modern enhancements
- **AI Pattern Generation** - Describe your beat and let AI create it
- **Multiple Drum Kits** - 808, 909, 707, LinnDrum (coming soon)
- **16-Step Sequencer** - With velocity and accent support
- **Per-Track Controls** - Volume, mute, solo for each instrument
- **8 Genre Presets** - Classic 808, Trap, Techno, House, and more
- **Pattern Save/Load** - Store your beats locally (cloud sync coming soon)
- **Professional Effects** - Delay, reverb, chorus (coming soon)

## Live Demo

Try it now: [TR-808 AI Demo](#) *(deployment link coming soon)*

## Quick Start

### Online Version
Simply open `tr808-mvp.html` in a modern web browser. No installation required!

### Local Development
```bash
# Clone the repository
git clone https://github.com/yourusername/tr808-drum.git
cd tr808-drum

# Install dependencies (once build system is set up)
npm install

# Start development server
npm run dev
```

## Usage

1. **Play/Stop**: Click the Play button to start the sequencer
2. **Program Beats**: Click on the step buttons to create patterns
   - First click: Normal hit (orange)
   - Second click: Accented hit (red)
   - Third click: Off
3. **AI Generation**: Type a description and click "Generate"
4. **Presets**: Click any preset button to load a pattern
5. **Tempo**: Adjust the BPM slider or use TAP tempo

## Keyboard Shortcuts

- `Space`: Play/Stop
- `C`: Clear pattern
- `1-8`: Mute/unmute tracks
- `Shift + 1-8`: Solo tracks

## Technical Stack

- **Audio Engine**: Tone.js v14.8.49
- **AI Integration**: Claude API (Anthropic)
- **Frontend**: Vanilla JavaScript (React migration planned)
- **Styling**: CSS3 with custom properties
- **Future**: Firebase Auth, Firestore, Cloud Functions

## Roadmap

- [x] Basic drum machine functionality
- [x] AI pattern generation
- [x] Genre presets
- [ ] Sample-based drum kits
- [ ] User authentication
- [ ] Cloud pattern storage
- [ ] Effects chain (delay, reverb, chorus)
- [ ] MIDI support
- [ ] Pattern sharing community
- [ ] Mobile app

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the legendary Roland TR-808
- Built with [Tone.js](https://tonejs.github.io/)
- AI powered by [Anthropic's Claude](https://www.anthropic.com/)

## Support

- Email: your.email@example.com
- Issues: [GitHub Issues](https://github.com/yourusername/tr808-drum/issues)
- Discussions: [GitHub Discussions](https://github.com/yourusername/tr808-drum/discussions)

---

Made with love by [Your Name]