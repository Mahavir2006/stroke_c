# Stroke Mitra — Complete UI/UX Overhaul Plan

## Vision

Transform Stroke Mitra from a functional prototype into a visually stunning, premium healthtech product that feels as polished as Apple Health meets Headspace — clean, warm, animated, and delightful for every age group.

---

## 1. NEW COLOR SYSTEM & THEME

### Light Mode Palette
| Token | Hex | Usage |
|-------|-----|-------|
| **Primary** | `#0B6B5D` | Deep emerald teal — trust, health, calm |
| **Primary Light** | `#14B8A6` | Teal 400 — buttons, active states |
| **Primary Surface** | `#F0FDFA` | Teal 50 — card tints, subtle backgrounds |
| **Accent** | `#6366F1` | Indigo — secondary actions, charts |
| **Accent Surface** | `#EEF2FF` | Indigo 50 — accent card tints |
| **Success** | `#22C55E` | Green — normal results, baseline done |
| **Warning** | `#F59E0B` | Amber — moderate risk, caution |
| **Danger** | `#EF4444` | Red — critical, emergency, severe |
| **Background** | `#FAFBFC` | Near-white with warmth |
| **Card** | `#FFFFFF` | Pure white cards |
| **Text Primary** | `#0F172A` | Slate 900 — headings |
| **Text Secondary** | `#64748B` | Slate 500 — body, captions |
| **Text Muted** | `#94A3B8` | Slate 400 — placeholders, hints |
| **Border** | `#E2E8F0` | Slate 200 — card borders, dividers |
| **Gradient Hero** | `#0B6B5D → #0EA5E9` | Emerald to sky — hero sections |
| **Gradient CTA** | `#6366F1 → #14B8A6` | Indigo to teal — CTA buttons |

### Dark Mode Palette
| Token | Hex | Usage |
|-------|-----|-------|
| **Background** | `#0B1120` | Deep navy — no pure black |
| **Card** | `#1E293B` | Slate 800 — elevated surfaces |
| **Card Elevated** | `#273548` | Slightly lighter for modals/sheets |
| **Text Primary** | `#F1F5F9` | Slate 100 |
| **Text Secondary** | `#94A3B8` | Slate 400 |
| **Border** | `#334155` | Slate 700 |
| **Primary** | `#2DD4BF` | Brighter teal for dark backgrounds |
| **Primary Surface** | `#0B6B5D20` | Teal with 12% alpha |
| **Accent** | `#818CF8` | Lighter indigo for dark bg |

### Why This Palette?
- **Emerald teal** is the #1 color in healthcare branding — signals trust, wellness, and calm
- **Indigo accent** adds modernity and visual depth without clashing
- **Warm neutrals** (not cold grays) make the app feel approachable for elderly users
- **Dark mode** uses navy (not pure black) for reduced eye strain — critical for a health app

---

## 2. TYPOGRAPHY UPGRADE

| Style | Font | Weight | Size | Tracking |
|-------|------|--------|------|----------|
| Display | Outfit | 800 | 36px | -0.5px |
| Heading LG | Outfit | 700 | 28px | -0.3px |
| Heading MD | Outfit | 700 | 22px | 0 |
| Heading SM | Outfit | 600 | 18px | 0 |
| Body LG | Inter | 400 | 16px | 0.1px |
| Body MD | Inter | 400 | 14px | 0.1px |
| Body SM | Inter | 400 | 12px | 0.2px |
| Label | Inter | 600 | 12px | 0.8px |
| Mono/Metric | JetBrains Mono | 500 | 20px | 0 |

**Key change:** Add `JetBrains Mono` for all numeric metrics/scores — gives data a clinical, premium feel.

---

## 3. DARK/LIGHT MODE TOGGLE

### Implementation
- Add `ThemeMode` state to a `themeProvider` (Riverpod `StateProvider<ThemeMode>`)
- Persist preference in `SharedPreferences` (key: `theme_mode`)
- `MaterialApp.router` reads from `themeProvider` for `themeMode` property
- Build both `ThemeData.light()` and `ThemeData.dark()` in `theme.dart` using the palettes above
- All hardcoded colors throughout the app replaced with `Theme.of(context).colorScheme` tokens or custom extension

### Toggle Location
- **App Shell header:** Sun/moon icon button in the AppBar (left of profile icon)
- **Profile page:** Theme preference row with segmented control (System / Light / Dark)
- Smooth `AnimatedTheme` transition when toggling (300ms ease)

### Color Extension
```dart
// Custom ThemeExtension for app-specific colors not in Material colorScheme
class AppColors extends ThemeExtension<AppColors> {
  final Color cardBorder;
  final Color successSurface;
  final Color dangerSurface;
  final Color warningSurface;
  final Gradient heroGradient;
  final Gradient ctaGradient;
  // ... etc
}
```

---

## 4. COMPONENT-BY-COMPONENT OVERHAUL

### 4.1 App Shell & Navigation

**Current:** Plain white AppBar + basic BottomNavigationBar
**New:**

- **AppBar:**
  - Frosted glass background (semi-transparent + blur) like iOS
  - Logo: Custom SVG or styled icon + "Stroke Mitra" with gradient text effect
  - Right side: Theme toggle (sun/moon) + Profile avatar (circular, with user initial or image)
  - No hard elevation — use subtle border-bottom only

- **Bottom Navigation:**
  - Replace with custom `NavigationBar` (Material 3 style)
  - Active item: Filled icon with teal pill-shaped indicator behind it
  - Labels: Only show on active item (animated fade)
  - Subtle top border (1px, border color)
  - Active icon has gentle scale animation (1.0 → 1.1)

- **Page Transitions:**
  - Replace `AnimatedSwitcher` with `FadeTransition` + subtle slide (20px vertical offset)
  - 250ms duration, `Curves.easeOutCubic`

### 4.2 Dashboard (Home Screen)

**Current:** Flat vertical list of 4 identical cards
**New:**

- **Welcome Header:**
  - "Good morning, Raj" (time-based greeting using user's name)
  - Subtitle: "Ready for your daily check?"
  - Small teal accent line below

- **Quick Status Bar:**
  - Horizontal scrollable row of 3 mini-cards:
    - "Last Check: 2 days ago" (or "No checks yet")
    - "Streak: 3 days" (or gamification element)
    - "Status: All Clear" (with green dot)
  - Cards: Rounded, subtle gradient background, icon + text

- **Test Cards (completely redesigned):**
  - **Layout:** 2×2 grid (not vertical list)
  - **Each card:**
    - Top: Large icon in a gradient circle (each test gets its own gradient)
      - Face: Emerald → Teal gradient
      - Voice: Indigo → Purple gradient
      - Motion: Amber → Orange gradient
      - Tap: Sky → Blue gradient
    - Title (16px, bold)
    - One-line description (12px, muted)
    - Bottom-right: Arrow icon in circle
    - On tap: Scale down (0.97) + haptic feedback
    - Subtle colored left border (matching gradient)
  - **Staggered entrance animation:** Cards fade in + slide up with 100ms delays using `flutter_animate`

- **Disclaimer:** Restyle as a collapsible card (tap to expand) instead of always-visible wall of text

### 4.3 Face Analysis Screen

**Current:** Functional but clinical-looking step wizard
**New:**

- **Step Indicator (redesigned):**
  - Horizontal stepper with connected circles (not just underlines)
  - Each step: Numbered circle (filled when complete, outlined when upcoming, primary when active)
  - Connecting line animates fill as you progress
  - Step labels below circles

- **Camera View:**
  - Rounded camera container with animated gradient border (rotating colors, subtle)
  - Oval overlay: Replace dashed lines with smooth gradient stroke (teal → indigo)
  - Crosshair lines: Thinner, more subtle (0.3 alpha)
  - 4 parameter dots redesigned as a horizontal chip row:
    - Each chip: Icon + label + colored dot
    - Animate background fill when check passes (empty → success green surface)
    - Gentle checkmark icon appears when satisfied

- **Processing State:**
  - Replace plain spinner with animated concentric rings (CustomPaint)
  - Pulsing text opacity
  - "Analyzing..." with animated dots (...→ .. → .)

- **Result View:**
  - **Hero verdict:** Full-width gradient banner (green or red) with large icon + verdict
  - **Score ring:** Circular progress indicator showing symmetry score (like Apple Watch rings)
  - **Metrics:** Card grid (2 columns) instead of plain rows — each metric in its own mini-card with icon
  - **Emergency section:** Pulsing red border animation if abnormal

### 4.4 Voice Check Screen

**Current:** Basic recording UI with 5-bar visualizer
**New:**

- **Prompt Card:**
  - Subtle gradient background (primary surface → white)
  - Large quotation mark icon (decorative, 20% alpha)
  - Text in slightly larger font with line-height for readability

- **Audio Visualizer (complete redesign):**
  - **30+ bars** (not 5) with smooth Perlin-noise-like heights
  - Gradient coloring per bar (teal → indigo across the spectrum)
  - Smooth sinusoidal animation (not just oscillation)
  - Mirrored vertically (bars go up AND down from center line)
  - Fades to flat lines when idle

- **Recording Button:**
  - Large circular button (80px) with pulsing ring animation when recording
  - Icon transitions: Mic → Stop (animated morph)
  - Recording state: Red glow ring pulsing outward

- **Timer:**
  - Circular countdown timer (ring) instead of linear bar
  - Large time display in center of ring

- **Result Card:**
  - **Severity gauge:** Semi-circular gauge (like a speedometer) with needle pointing to score
  - Green zone (0-30) → Yellow zone (30-60) → Red zone (60-100)
  - Animated needle sweep on load
  - Acoustic metrics in expandable accordion sections (collapsed by default for cleanliness)

### 4.5 Motion Test Screen

**Current:** Box with ball, basic readout
**New:**

- **Arena (redesigned):**
  - Circular arena with subtle concentric ring guides (like a target)
  - Center: Glowing crosshair with pulse effect
  - Ball: Gradient fill + trail effect (last 10 positions drawn as fading dots)
  - Background: Dark with subtle grid pattern
  - Ring zones: Inner (green), middle (yellow), outer (red) — gives visual feedback on drift

- **Live Metrics:**
  - Overlay on top of arena (semi-transparent cards at corners)
  - Real-time tilt shown as tilting horizon line animation

- **Result:**
  - Heatmap visualization of ball movement (where did the ball spend most time?)
  - Drift path drawn as a line on the arena
  - Score ring (like face analysis)

### 4.6 Tap Test Screen

**Current:** Dark arena with moving green button
**New:**

- **Arena:**
  - Gradient background (dark navy → dark teal) instead of flat dark
  - Subtle grid pattern overlay
  - Tap button: Larger (56px), with ripple burst effect on each tap
  - Each tap spawns a "+" particle that floats upward and fades
  - Tap counter: Large, centered top, with scale-pop animation on each increment

- **Hand Transition:**
  - Animated hand illustration flip (right → left) with card flip animation
  - Countdown: Animated ring filling up (not just a number)

- **Result:**
  - **Dual bar chart** (side by side) for left vs right hand — animated bar growth
  - Asymmetry shown as a tug-of-war bar (one side pulls harder)
  - Color-coded hand silhouettes

### 4.7 Profile Screen

**Current:** Letter avatar + three text rows + baseline photo
**New:**

- **Profile Header:**
  - Gradient background banner (teal → indigo, 120px height)
  - Avatar overlapping the banner edge (circular, 80px, with border)
  - If baseline photo exists: Use it as avatar (circular crop)
  - Name + email below avatar
  - Edit profile button (outline, small)

- **Stats Row:**
  - Horizontal row of mini-stat cards:
    - "Tests Taken: 12"
    - "Last Check: Today"
    - "Member Since: Mar 2026"

- **Baseline Section:**
  - Full-width rounded image with gradient overlay at bottom
  - "Captured on: Mar 21, 2026" text overlaid
  - Subtle play button icon overlay (for potential video baseline in future)

- **Settings Section:**
  - Theme toggle (Light / Dark / System) — segmented control
  - Notification preferences (future)
  - Account actions (sign out, delete account)

### 4.8 Auth Screens (Login / Signup / Forgot Password)

**Current:** Plain card forms
**New:**

- **Background:** Subtle animated gradient mesh (very slow-moving, nearly static)
- **Card:** Glassmorphism effect (semi-transparent, backdrop blur, subtle border)
- **Logo:** Animated on mount — scale + fade in
- **Input fields:**
  - On focus: Border color transition to primary + subtle glow shadow
  - Floating labels (Material 3 style)
  - Prefix icons animate color on focus
- **Buttons:** Gradient fill with shimmer effect on hover/press
- **Transitions between auth screens:** Shared element transitions (logo stays, form slides)

### 4.9 Landing Page

**Current:** Functional but text-heavy
**New:**

- **Hero:**
  - Animated background: Floating gradient orbs (2-3 large blurred circles slowly moving)
  - Stats badges with count-up animation on scroll-into-view
  - CTA button with shimmer/glow effect

- **Features Section:**
  - Cards reveal on scroll (staggered fade-in + slide-up using scroll controller)
  - Each card gets its own accent color (not all blue)

- **Stats Section:**
  - Numbers count up only when scrolled into view (intersection observer)
  - Add subtle particle effect in background

- **How It Works:**
  - Connected timeline layout (vertical line connecting steps)
  - Each step animates in on scroll

---

## 5. GLOBAL ANIMATION SYSTEM

### Entrance Animations (every screen)
- All content uses staggered entrance: `flutter_animate`
  - Fade in (0 → 1 alpha)
  - Slide up (20px → 0)
  - Duration: 400ms per element
  - Stagger: 80ms between elements
  - Curve: `Curves.easeOutCubic`

### Micro-interactions
| Element | Interaction | Animation |
|---------|-------------|-----------|
| Buttons | Press | Scale 1.0 → 0.96, 100ms |
| Cards | Tap | Scale 1.0 → 0.98, subtle shadow increase |
| Toggle | Switch | Smooth slide + color morph, 200ms |
| Checkmarks | Appear | Scale 0 → 1 with bounce, 300ms |
| Error shake | Error | Horizontal shake (3 oscillations, 400ms) |
| Success | Complete | Checkmark draws itself (stroke animation) |
| Loading | Wait | Skeleton shimmer (gradient sweep) |
| Numbers | Update | Count-up animation (500ms) |

### Page Transitions
- Forward navigation: Fade + slide left (content slides out left, new slides in from right)
- Back navigation: Reverse of above
- Modal/sheet: Slide up from bottom with fade backdrop
- Duration: 300ms, `Curves.easeOutCubic`

### Loading States
- Replace ALL `CircularProgressIndicator` with:
  - Skeleton shimmer loaders for content areas
  - Custom animated logo spinner for full-screen loads
  - Pulsing placeholder cards for data loading

---

## 6. NEW DEPENDENCIES NEEDED

```yaml
# Animation
lottie: ^3.0.0              # For complex medical animations (heartbeat, scanning)
shimmer: ^3.0.0              # Skeleton loading effects

# Visual
glassmorphism: ^3.0.0        # Frosted glass card effects
fl_chart: ^0.68.0            # Already present — for gauge charts, bar charts
flutter_animate: ^4.3.0      # Already present — staggered animations

# Icons
iconsax: ^0.0.8              # Modern icon set (cleaner than Material icons)
```

---

## 7. SHARED COMPONENT LIBRARY (New Widgets)

| Widget | Purpose |
|--------|---------|
| `GradientCard` | Card with optional gradient border/background |
| `ScoreRing` | Circular progress ring for displaying scores (0-100) |
| `SemiGauge` | Semicircular gauge for severity (voice, motion) |
| `AnimatedMetricCard` | Mini card that counts up its value on mount |
| `ShimmerLoader` | Skeleton placeholder while loading |
| `GlassCard` | Frosted glass card for auth screens |
| `StatusChip` | Colored chip with dot + label (Normal / Warning / Critical) |
| `AnimatedStepIndicator` | Connected circle stepper with fill animation |
| `PulseButton` | Button with pulsing ring effect (for recording) |
| `GradientIconCircle` | Icon inside a gradient circle (for dashboard cards) |
| `HeatmapPainter` | Custom painter for motion test heatmap |
| `WaveVisualizer` | 30+ bar audio visualizer with gradient |

---

## 8. IMPLEMENTATION ORDER

### Phase 1 — Foundation (Theme + Dark Mode)
1. Rewrite `theme.dart` with new color system + dark mode `ThemeData`
2. Create `AppColors` ThemeExtension
3. Add `themeProvider` with `SharedPreferences` persistence
4. Update `main.dart` to use theme provider
5. Update `app_shell.dart` with theme toggle + new nav design
6. Replace all hardcoded colors across screens with theme tokens

### Phase 2 — Shared Components
7. Build the shared widget library (GradientCard, ScoreRing, etc.)
8. Add new dependencies to pubspec

### Phase 3 — Screen Rewrites (one at a time)
9. Dashboard — Grid layout, greeting, status bar, animated cards
10. Face Analysis — New stepper, gradient camera border, result rings
11. Voice Check — Wave visualizer, gauge result, circular timer
12. Motion Test — Arena rings, trail effect, heatmap result
13. Tap Test — Particle effects, dual bar chart result
14. Profile — Gradient banner, stats row, settings section
15. Auth Screens — Glass cards, animated gradient background, focus effects

### Phase 4 — Landing Page Polish
16. Hero animated orbs, scroll-triggered reveals, particle stats

### Phase 5 — Final Polish
17. Page transitions throughout
18. Skeleton loaders for all async states
19. Haptic feedback on taps (mobile)
20. Accessibility pass (contrast ratios, font scaling, screen reader labels)

---

## 9. DESIGN PRINCIPLES

1. **Clarity over cleverness** — Every animation serves a purpose (feedback, hierarchy, delight). No animation for animation's sake.
2. **60+ friendly** — Large touch targets (48px min), readable fonts (14px min body), high contrast ratios (4.5:1 minimum).
3. **Speed matters** — Animations are snappy (200-400ms). No slow fades that make the app feel sluggish.
4. **Trust through design** — Healthcare apps need to feel credible. No playful cartoon aesthetics — clean, confident, professional with warmth.
5. **Dark mode is first-class** — Not an afterthought. Every component tested in both modes.
6. **Progressive disclosure** — Show the verdict first, details on demand. Don't overwhelm with metrics.

---

## 10. RESULT: BEFORE → AFTER

| Screen | Before | After |
|--------|--------|-------|
| Dashboard | Flat list of 4 identical white cards | 2×2 gradient-accented grid with greeting + status bar |
| Face Analysis | Plain camera + text steps | Gradient-bordered camera + connected stepper + score ring |
| Voice Check | 5-bar visualizer + text metrics | 30-bar gradient wave + semicircular gauge + accordion |
| Motion Test | Ball in white box + text | Zoned arena with trail + heatmap + score ring |
| Tap Test | Dark box with green button | Gradient arena with particles + dual bar chart |
| Profile | Letter avatar + 3 rows | Gradient banner + photo avatar + stats + settings |
| Auth | Plain white card form | Glassmorphism card + animated gradient background |
| Theme | Light only | Light + Dark with smooth toggle |
