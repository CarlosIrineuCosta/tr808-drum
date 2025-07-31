# TR-808 AI Drum Machine - Project Architecture

## Overview
A web-based TR-808 drum machine with AI pattern generation, authentic drum samples, pattern sharing, and professional audio effects.

## Core Features
- 🥁 Multiple classic drum machine emulations (808, 909, 707, LinnDrum)
- 🤖 AI-powered pattern generation using Claude API
- 💾 Cloud-based pattern storage and sharing
- 🎛️ Professional effects (delay, reverb, chorus)
- 🎨 Customizable themes and skins
- 🎵 MIDI support and DAW integration
- 👤 User accounts for pattern management

## Technology Stack

### Frontend
- **Core**: Vanilla JavaScript (migrating to React/Vue in Phase 2)
- **Audio Engine**: Tone.js v14.8.49
- **Styling**: CSS3 with custom properties for theming
- **Build Tool**: Vite (planned)
- **State Management**: Redux/Zustand (planned)

### Backend Services
- **Authentication**: Firebase Auth / Auth0
- **Database**: Firebase Firestore
- **Storage**: Firebase Storage (user samples)
- **API**: REST API for pattern CRUD
- **CDN**: Cloudflare for sample hosting

### Infrastructure
- **Hosting**: Vercel/Netlify
- **Domain**: Custom domain with SSL
- **Analytics**: Google Analytics 4
- **Monitoring**: Sentry for error tracking

## Authentication Architecture

### User Authentication Flow
```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Client    │────▶│ Auth Service │────▶│   Backend   │
│  (Browser)  │◀────│  (Firebase)  │◀────│   (API)     │
└─────────────┘     └──────────────┘     └─────────────┘
```

### Auth Implementation (Firebase)
```javascript
// Authentication module
const auth = {
  // Initialize Firebase
  init: async () => {
    const firebaseConfig = {
      apiKey: process.env.FIREBASE_API_KEY,
      authDomain: "tr808-drum.firebaseapp.com",
      projectId: "tr808-drum",
      storageBucket: "tr808-drum.appspot.com"
    };
    firebase.initializeApp(firebaseConfig);
  },

  // Sign up with email
  signUp: async (email, password) => {
    const userCredential = await firebase.auth()
      .createUserWithEmailAndPassword(email, password);
    await auth.createUserProfile(userCredential.user);
    return userCredential.user;
  },

  // Sign in
  signIn: async (email, password) => {
    const userCredential = await firebase.auth()
      .signInWithEmailAndPassword(email, password);
    return userCredential.user;
  },

  // OAuth providers
  signInWithGoogle: async () => {
    const provider = new firebase.auth.GoogleAuthProvider();
    const result = await firebase.auth().signInWithPopup(provider);
    return result.user;
  },

  // Create user profile in Firestore
  createUserProfile: async (user) => {
    const profile = {
      uid: user.uid,
      email: user.email,
      displayName: user.displayName || user.email.split('@')[0],
      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
      subscription: 'free',
      storage: {
        patterns: 0,
        maxPatterns: 100,
        samples: 0,
        maxSamplesMB: 50
      }
    };
    
    await firebase.firestore()
      .collection('users')
      .doc(user.uid)
      .set(profile);
  }
};
```

### User Data Structure
```javascript
// Firestore Collections
{
  // users/{userId}
  users: {
    uid: "string",
    email: "string",
    displayName: "string",
    avatar: "string",
    createdAt: "timestamp",
    subscription: "free|pro|premium",
    storage: {
      patterns: "number",
      maxPatterns: "number",
      samples: "number",
      maxSamplesMB: "number"
    },
    preferences: {
      theme: "classic|modern|minimal",
      defaultKit: "808|909|707|linn",
      defaultTempo: "number"
    }
  },

  // patterns/{patternId}
  patterns: {
    id: "string",
    userId: "string",
    name: "string",
    description: "string",
    genre: ["string"],
    tempo: "number",
    swing: "number",
    kit: "string",
    pattern: {}, // Pattern data
    accents: {}, // Accent data
    velocities: {}, // Velocity data
    effects: {}, // Effect settings
    public: "boolean",
    likes: "number",
    plays: "number",
    createdAt: "timestamp",
    updatedAt: "timestamp"
  },

  // samples/{sampleId}
  samples: {
    id: "string",
    userId: "string",
    name: "string",
    instrument: "string",
    kit: "string",
    url: "string",
    size: "number",
    duration: "number",
    createdAt: "timestamp"
  }
}
```

### Authorization & Permissions
```javascript
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Patterns: owners have full access, public patterns are readable
    match /patterns/{patternId} {
      allow read: if resource.data.public == true || 
                     (request.auth != null && request.auth.uid == resource.data.userId);
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Samples: only owners can access
    match /samples/{sampleId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

### Subscription Tiers (Future)
```javascript
const subscriptionTiers = {
  free: {
    maxPatterns: 100,
    maxSamplesMB: 50,
    cloudSync: true,
    customSamples: true,
    effects: ["delay", "reverb"],
    export: ["json"],
    support: "community"
  },
  pro: {
    maxPatterns: 1000,
    maxSamplesMB: 500,
    cloudSync: true,
    customSamples: true,
    effects: ["all"],
    export: ["json", "midi", "wav"],
    support: "email"
  },
  premium: {
    maxPatterns: "unlimited",
    maxSamplesMB: 5000,
    cloudSync: true,
    customSamples: true,
    effects: ["all"],
    export: ["json", "midi", "wav", "stems"],
    support: "priority",
    features: ["collaboration", "version-history", "advanced-ai"]
  }
};
```

## Project Structure
```
tr808-drum/
├── src/
│   ├── index.html
│   ├── styles/
│   │   ├── main.css
│   │   ├── themes/
│   │   │   ├── classic.css
│   │   │   ├── modern.css
│   │   │   └── minimal.css
│   │   └── components/
│   ├── js/
│   │   ├── app.js
│   │   ├── auth/
│   │   │   ├── firebase.js
│   │   │   └── authManager.js
│   │   ├── audio/
│   │   │   ├── drumEngine.js
│   │   │   ├── effects.js
│   │   │   └── sampler.js
│   │   ├── patterns/
│   │   │   ├── patternManager.js
│   │   │   ├── patternDatabase.js
│   │   │   └── presets.js
│   │   ├── ui/
│   │   │   ├── sequencer.js
│   │   │   ├── controls.js
│   │   │   └── themes.js
│   │   └── utils/
│   │       ├── storage.js
│   │       └── midi.js
│   ├── samples/
│   │   ├── 808/
│   │   ├── 909/
│   │   ├── 707/
│   │   └── linn/
│   └── assets/
│       ├── icons/
│       └── images/
├── public/
├── tests/
├── .env.example
├── .gitignore
├── package.json
├── vite.config.js
├── firebase.json
├── firestore.rules
├── README.md
├── LICENSE
└── project_architecture.md
```

## Development Phases

### Phase 1: Core Features (Weeks 1-2)
- [x] Basic drum machine functionality
- [ ] Sample-based sound engine
- [ ] Multiple drum kit support
- [ ] Local sample upload

### Phase 2: Cloud Features (Weeks 3-4)
- [ ] Firebase authentication setup
- [ ] User profile management
- [ ] Pattern save/load to cloud
- [ ] Public pattern sharing

### Phase 3: Effects & UI (Weeks 4-5)
- [ ] Effects chain implementation
- [ ] Modern UI redesign
- [ ] Theme system
- [ ] Mobile responsive design

### Phase 4: Advanced Features (Weeks 5-6)
- [ ] MIDI integration
- [ ] Pattern chaining (song mode)
- [ ] Collaboration features
- [ ] Export functionality

### Phase 5: Monetization (Future)
- [ ] Subscription system
- [ ] Payment integration (Stripe)
- [ ] Premium features
- [ ] Usage analytics

## API Endpoints
```
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/logout
GET    /api/auth/me

GET    /api/patterns          # List user patterns
GET    /api/patterns/:id      # Get specific pattern
POST   /api/patterns          # Create pattern
PUT    /api/patterns/:id      # Update pattern
DELETE /api/patterns/:id      # Delete pattern

GET    /api/patterns/public   # Browse public patterns
POST   /api/patterns/:id/like # Like a pattern
GET    /api/patterns/search   # Search patterns

POST   /api/samples/upload    # Upload custom sample
GET    /api/samples           # List user samples
DELETE /api/samples/:id       # Delete sample
```

## Security Considerations
- Environment variables for API keys
- Firebase security rules for data access
- Rate limiting on API endpoints
- Input validation and sanitization
- XSS protection
- CORS configuration
- Regular security audits

## Performance Optimization
- Lazy loading for drum samples
- Web Workers for audio processing
- IndexedDB for offline pattern storage
- Service Worker for PWA functionality
- CDN for static assets
- Code splitting with dynamic imports

## Future Enhancements
- WebRTC for real-time collaboration
- AI-powered mixing suggestions
- Social features (follow, comments)
- VST plugin version
- Native mobile apps
- Integration with popular DAWs