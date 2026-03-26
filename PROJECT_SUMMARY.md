# Stroke Mitra (stroke_c) — Complete Project Summary

## Overview

**Stroke Mitra** is an AI-powered stroke screening Flutter application that helps users detect early warning signs of stroke using their smartphone's built-in sensors — camera, microphone, and accelerometer. It follows the clinically recognized **F.A.S.T. (Face, Arms, Speech, Time)** protocol. The app is positioned as a prototype screening tool (not a diagnostic device) and prominently displays medical disclaimers throughout.

**App Name:** `stroke_mitra`
**Version:** 1.0.0+1
**Dart SDK:** >=3.2.0 <4.0.0
**Flutter SDK:** >=3.16.0
**Backend:** Supabase (Auth + Database + Storage)
**State Management:** Riverpod (`flutter_riverpod`)
**Routing:** GoRouter (`go_router`)
**Target Platforms:** Web, Windows (mobile via camera/sensors)

---

## Directory Structure

```
stroke_c/
├── pubspec.yaml                          # Root-level pubspec (earlier/simpler version)
├── lib/
│   └── core/
│       ├── app_router.dart               # Older/simpler router (no auth, no shell)
│       └── theme.dart                    # Older/simpler theme definition
├── flutter/                              # Empty directory (placeholder)
└── flutter_app/                          # ★ Main application directory
    ├── pubspec.yaml                      # Full dependency list
    ├── .env                              # Environment variables (Supabase URL + key)
    ├── lib/
    │   ├── main.dart                     # Entry point
    │   ├── app/
    │   │   ├── router.dart               # GoRouter config with auth guards
    │   │   └── theme.dart                # Full design system (colors, typography, spacing)
    │   ├── core/
    │   │   ├── constants.dart            # App-wide constants, table names, disclaimers
    │   │   └── supabase_client.dart      # Supabase singleton initialization
    │   ├── features/
    │   │   ├── auth/                     # Authentication feature
    │   │   │   ├── providers/auth_provider.dart
    │   │   │   ├── repositories/auth_repository.dart
    │   │   │   ├── services/auth_service.dart
    │   │   │   └── screens/
    │   │   │       ├── login_screen.dart
    │   │   │       ├── signup_screen.dart
    │   │   │       ├── forgot_password_screen.dart
    │   │   │       └── profile_screen.dart
    │   │   ├── dashboard/
    │   │   │   └── dashboard_screen.dart  # Home screen with 4 test action cards
    │   │   ├── face_analysis/
    │   │   │   ├── face_analysis_screen.dart
    │   │   │   └── data/face_repository.dart
    │   │   ├── voice_check/
    │   │   │   ├── voice_check_screen.dart
    │   │   │   └── data/voice_repository.dart
    │   │   ├── motion_test/
    │   │   │   ├── motion_test_screen.dart
    │   │   │   ├── motion_provider.dart
    │   │   │   ├── motion_service.dart
    │   │   │   └── data/motion_repository.dart
    │   │   ├── tap_test/
    │   │   │   ├── tap_test_screen.dart
    │   │   │   ├── tap_test_provider.dart
    │   │   │   ├── tap_test_service.dart
    │   │   │   └── tap_scoring.dart
    │   │   └── landing/
    │   │       ├── landing_screen.dart
    │   │       └── widgets/
    │   │           ├── hero_section.dart
    │   │           ├── what_is_section.dart
    │   │           ├── how_it_works_section.dart
    │   │           ├── features_section.dart
    │   │           ├── stats_section.dart
    │   │           ├── cta_section.dart
    │   │           ├── landing_footer.dart
    │   │           └── landing_nav.dart
    │   └── shared/
    │       ├── utils/session_service.dart  # Session management (Supabase CRUD)
    │       └── widgets/
    │           ├── app_shell.dart          # Layout wrapper with bottom nav
    │           └── disclaimer_widget.dart  # Medical disclaimer banner
    ├── supabase/
    │   ├── config.toml                    # Supabase local config
    │   └── migrations/
    │       ├── 20260314000000_initial_schema.sql  # sessions + session_data tables
    │       └── 20260314000001_auth_schema.sql     # profiles table + trigger
    ├── test/
    │   ├── tap_test_service_test.dart
    │   └── widget_test.dart
    └── web/                               # Web platform assets (index.html, icons, manifest)
```

---

## Architecture & Patterns

### State Management
- **Riverpod** is used throughout for dependency injection and reactive state.
- `StateNotifier` + `StateNotifierProvider` pattern for complex features (Motion Test, Tap Test, Auth).
- `StreamProvider` for auth state changes from Supabase.
- `FutureProvider` for user profile data.
- Providers are `autoDispose` where appropriate to avoid memory leaks.

### Navigation
- **GoRouter** with named routes and a redirect-based auth guard.
- Protected routes redirect unauthenticated users to `/login`.
- Authenticated users on auth/landing pages are redirected to `/app`.
- A `ShellRoute` wraps the main app screens with `AppShell` (top bar + bottom nav).

### Data Layer
- **3-tier architecture**: Service → Repository → Provider
  - `AuthService` — raw Supabase auth calls
  - `AuthRepository` — combines auth methods with profile queries (mockable)
  - `AuthProvider` — Riverpod providers exposing state to UI
- Feature repositories (`FaceRepository`, `VoiceRepository`, `MotionRepository`) handle Supabase inserts.
- `SessionService` — manages screening session lifecycle (start, submit data, complete).
- All data submissions have **offline fallback** — silently succeed if Supabase is unreachable.

### Design System
- Medical-grade, calm color palette (Deep Ocean Teal primary, Sage Green secondary).
- **Fonts:** Outfit (headings) + Inter (body) via `google_fonts`.
- Comprehensive color tokens (blue, teal, orange, green, red, slate palettes).
- Predefined gradients, spacing constants, border radii.
- Full `ThemeData` configuration with Material 3.

---

## Feature Breakdown

### 1. Landing Page (`/`)
A full marketing page with 7 sections:

| Section | Description |
|---------|-------------|
| **LandingNav** | Fixed top navbar with brand logo + "Check Symptoms" CTA |
| **HeroSection** | Animated gradient hero with title, subtitle, trust badges |
| **WhatIsSection** | 3 info cards (Clinically Informed, Device-Native AI, For Everyone) + medical disclaimer |
| **HowItWorksSection** | 4-step process cards (Face Detection, Voice Analysis, Motion, Instant Results) |
| **FeaturesSection** | 6 feature cards with hover effects and technology tags |
| **StatsSection** | Animated counters (15M strokes/year, 80% preventable, etc.) + F.A.S.T. banner |
| **CTASection** | "Don't Wait. Act Now." CTA with emergency 112 call button |
| **LandingFooter** | Brand, screening links, emergency numbers, copyright |

All sections are responsive with breakpoints at 500px, 600px, 700px, 800px, and 900px.

### 2. Authentication
- **Supabase Auth** with email/password.
- Sign Up with full name (stored in `user_metadata` and `profiles` table via trigger).
- Sign In with `last_login` timestamp update.
- Forgot Password via Supabase's `resetPasswordForEmail`.
- Profile screen shows user info (name, email, account creation date).
- Auth state changes are streamed reactively and drive router redirects.

### 3. Dashboard (`/app`)
- Hero banner: "Early Detection Saves Lives"
- 4 animated action cards linking to screening tests:
  - Face Analysis — Check for facial drooping
  - Speech Check — Analyze speech clarity
  - Motion Test — Assess arm stability
  - Tap Test — Finger coordination check
- Medical disclaimer widget at bottom.

### 4. Face Analysis (`/face`)
- Uses device **front camera** via the `camera` package.
- Displays a **face oval guide overlay** for alignment.
- **Scanning line animation** during analysis.
- Currently runs **mock analysis** (2-second delay → returns fixed symmetry score of 98%).
- Results card shows: Symmetry Score, Status (Normal), Confidence, and message.
- Submits results to Supabase via `SessionService.submitData`.
- Has retake functionality.

### 5. Voice Check (`/voice`)
- Records audio using the `record` package (AAC-LC, mono, 44.1kHz).
- Displays a prompt sentence: *"The quick brown fox jumps over the lazy dog."*
- **Audio visualizer** (5 animated bars) during recording.
- Playback via `audioplayers`.
- Currently shows **hardcoded mock analysis**: "Clarity 96% (Normal)".
- Recording saved to temp directory as `.m4a`.

### 6. Motion Test (`/motion`)
- Uses device **accelerometer** via `sensors_plus`.
- **15-second recording window** at 50ms sampling interval (~20Hz).
- **Ball Visualizer**: a ball in a circular arena moves based on real-time accelerometer data.
- Live readout of X/Y tilt values and countdown timer.
- Progress bar showing elapsed time.
- **Analysis algorithm** computes:
  - **Tilt Variance**: Average of X and Y variance from mean.
  - **Drift Magnitude**: Euclidean distance of mean X/Y from origin.
  - **Risk Classification**:
    - Normal: variance < 0.08 AND drift < 0.3
    - Borderline: variance < 0.5 AND drift < 0.7
    - Abnormal: otherwise
- Results card with color-coded risk badge, metrics, and clinical interpretation.
- Submits results to Supabase on "Test Again".

### 7. Tap Test (`/tap`)
The most complex test — a **dual-hand finger coordination assessment**:

**Flow:**
1. **Instruction (Right Hand)** → Start button
2. **Testing (Right Hand)** — 20-second test with bouncing button
3. **Rest (5 seconds)** — Non-skippable countdown, prompts switch to left hand
4. **Instruction (Left Hand)** → Start button
5. **Testing (Left Hand)** — 20-second test
6. **Combined Results** — Dual-hand analysis

**Mechanics:**
- A glowing green button bounces around a dark arena at ~60fps.
- User taps the moving button; hit detection uses distance-from-center calculation.
- Flash animation on successful hits.

**Scoring (TapScoring class):**
- **Per-hand risk**: Normal (>=6 taps), Borderline (3-5 taps), Abnormal (<3 taps)
- **Asymmetry Index**: `|right - left| / max * 100%`
- **Asymmetry Labels**: Symmetric (<=15%), Mild (15-30%), Significant (>30%)
- **Overall Risk** via 5-rule priority logic:
  1. Any hand abnormal → Abnormal (+ lateralised deficit flag if one-sided)
  2. Significant asymmetry → Abnormal
  3. Any borderline or mild asymmetry → Borderline
  4. Otherwise → Normal
- Clinical interpretation text based on risk level.
- Results show per-hand scores, asymmetry bar chart, and interpretation.
- Save & Continue or Try Again options.

---

## Database Schema (Supabase)

### `public.sessions`
| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID (PK) | Auto-generated |
| `created_at` | TIMESTAMPTZ | Auto-set |
| `completed_at` | TIMESTAMPTZ | Set on completion |
| `is_completed` | BOOLEAN | Defaults to false |
| `device_info` | JSONB | Optional device metadata |

### `public.session_data`
| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID (PK) | Auto-generated |
| `session_id` | UUID (FK → sessions) | Parent session |
| `data_type` | TEXT | `'face'`, `'voice'`, `'motion'` (CHECK constraint) |
| `payload` | JSONB | Test result data |
| `created_at` | TIMESTAMPTZ | Auto-set |

### `public.profiles`
| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID (PK, FK → auth.users) | User ID |
| `user_id` | UUID (FK → auth.users) | Duplicate ref |
| `full_name` | TEXT | User's name |
| `email` | TEXT | User's email |
| `risk_history_reference` | JSONB | Historical risk data |
| `last_login` | TIMESTAMPTZ | Updated on sign in |
| `created_at` | TIMESTAMPTZ | Auto-set |

**RLS Policies:**
- `sessions` and `session_data`: Public read/insert/update (no auth required for screening data).
- `profiles`: Users can only view/update their own profile (`auth.uid() = id`).

**Trigger:** `handle_new_user()` auto-creates a profile row when a new user signs up.

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `supabase_flutter` | Backend (auth, database, storage) |
| `go_router` | Declarative routing with auth guards |
| `flutter_riverpod` | State management & DI |
| `flutter_animate` | Micro-animations |
| `camera` | Device camera access |
| `google_mlkit_face_detection` | Face detection (declared but not actively used — mock analysis) |
| `sensors_plus` | Accelerometer/gyroscope access |
| `record` | Audio recording |
| `audioplayers` | Audio playback |
| `fl_chart` | Charts (declared, not actively used in current screens) |
| `google_fonts` | Outfit + Inter fonts |
| `flutter_dotenv` | Environment variable loading |
| `shared_preferences` | Local storage |
| `url_launcher` | Emergency phone number dialing |
| `cached_network_image` | Image caching |
| `path_provider` | Temp directory for recordings |

---

## Dual Codebase Note

The repository contains **two versions** of the app structure:

1. **`/lib/`** (root level) — An older, simpler version with:
   - Basic `GoRouter` without auth guards or shell routes
   - Simpler `ThemeData` without Google Fonts
   - References a `SpeechCheckScreen` (not `VoiceCheckScreen`)
   - No auth, no Supabase integration

2. **`/flutter_app/`** — The **complete, current version** with:
   - Full Supabase integration (auth + data persistence)
   - GoRouter with auth guards and ShellRoute
   - Comprehensive design system
   - All 4 screening tests implemented
   - Full landing page
   - Auth flow (login, signup, forgot password, profile)

The `/flutter/` directory is empty. The `/flutter_app/` directory is the canonical source.

---

## Current Limitations & Mock Implementations

1. **Face Analysis** — Uses mock data (98% symmetry hardcoded). The `google_mlkit_face_detection` package is declared but not integrated into the analysis pipeline.
2. **Voice Check** — Shows hardcoded "Clarity 96%" result. No actual speech analysis model is integrated.
3. **Session Management** — Uses a hardcoded `'temp-session'` ID instead of calling `SessionService.startSession()` to create proper sessions.
4. **Data Type Constraint** — The SQL schema only allows `'face'`, `'voice'`, `'motion'` in `data_type` CHECK constraint, but the app also submits `'tap'` data — this would fail at the database level.
5. **Offline Mode** — All data submissions silently succeed on failure (return `true`), providing graceful degradation but no retry or sync mechanism.

---

## Emergency Features

- Emergency number **112** (general) and **108** (ambulance) are configured as constants.
- The CTA section and footer include direct `tel:112` and `tel:108` links via `url_launcher`.
- Abnormal motion/tap test results include urgent clinical messaging: *"Seek medical attention immediately."*
