# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

Open `StopWatch.xcodeproj` in Xcode 15+ and build for iOS 17.0+. No external dependencies.

**Targets:**
- `StopWatch` - Main app (One-Tap Stopwatch.app)
- `StopWatchWidgetExtension` - Lock Screen Live Activity and Dynamic Island widget

## Architecture

Simple gym stopwatch app with Lock Screen Live Activity support.

### Key Components

- `StopwatchStore` - Singleton (@MainActor) managing timer state, persists to UserDefaults via app group
- `LiveActivityManager` - Manages ActivityKit lifecycle for Lock Screen activities
- `ContentView` - Main SwiftUI view with timer display and controls
- `StopWatchLiveActivity` - Lock Screen and Dynamic Island widget configuration

### Data Flow

```
User Action → StopwatchStore → UserDefaults (app group) → LiveActivityManager → Lock Screen
                    ↓
              ContentView (Combine @Published)
```

### Shared Models (duplicated between app and widget targets)

- `StopwatchState.swift` - State enum (running/stopped)
- `StopwatchAttributes.swift` - ActivityKit attributes
- `StopwatchIntents.swift` - App intents (implementations differ per target)

### App Group

`group.com.mattepozz.StopWatch` - Enables data sharing between main app and widget extension.

## Timer Implementation

Uses start date approach (not elapsed counter) for background resilience. Updates at 30ms intervals via `Timer.scheduledTimer`.
