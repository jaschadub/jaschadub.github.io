---
title: Introducing AAEQ - Adaptive Audio Equalizer
date: 2025-10-20
tags:
  - rust
  - audio
  - open-source
---

# Introducing AAEQ: Adaptive Audio Equalizer

*Posted on October 20, 2025*

<p align="center">
  <img src="https://raw.githubusercontent.com/jaschadub/AAEQ/main/docs/aaeq-logo-tranbg.png" alt="AAEQ Logo" width="300"/>
</p>

I'm excited to share [AAEQ](https://github.com/jaschadub/AAEQ), a cross-platform desktop application that brings intelligent EQ management and real-time DSP processing to your network audio devices.

## What is AAEQ?

AAEQ (Adaptive Audio Equalizer) automatically applies per-song, album, or genre EQ presets to your network audio devices. Set your favorite EQ once, and AAEQ remembers and applies it automatically whenever that music plays.

Built in Rust for performance and reliability, AAEQ offers two powerful modes:

### EQ Management Mode

Intelligent EQ switching for WiiM and DLNA devices:

- **Smart Priority System** - Automatically applies EQ based on song → album → genre → default
- **Now Playing Detection** - Tracks what's playing via WiiM API or MPRIS (Spotify, Strawberry, etc.)
- **Album Art Display** - Shows current track artwork
- **EQ Curve Visualization** - View exact frequency response for any preset

### DSP Streaming Mode

Real-time audio processing and streaming:

- **System Audio Capture** - Capture and process any audio from your computer
- **10-Band Parametric EQ** - Precise frequency control with custom presets
- **Multi-Format Streaming** - Stream to DLNA devices, local DAC, or AirPlay
- **Live Visualization** - Real-time waveform and spectrum analyzer
- **Professional Metering** - VU-style meters showing pre/post-EQ levels

## Key Features

**Multiple Profiles**
Create separate EQ mapping profiles for different scenarios - "Headphones", "Speakers", "Living Room". Switch instantly and the same songs apply different EQ settings.

**Custom Presets**
Build and save unlimited custom EQ presets with full parametric control over frequency, gain, and Q factor for each band.

**Theme System**
Choose from 5 color themes: Dark, Light, WinAmp, Vintage, and Studio.

**Local-First**
All data stored locally in SQLite. No cloud, no tracking, no subscriptions.

## Why I Built This

As someone who listens to a wide variety of music genres throughout the day, I was frustrated by constantly tweaking EQ settings on my WiiM devices. Different genres and albums sound better with different EQ curves, but manually changing presets dozens of times a day was tedious.

AAEQ solves this by remembering your preferences and applying them automatically. Once configured, it runs in the background and "just works" - exactly how software should behave.

The DSP streaming mode came from wanting to apply processing to audio sources that don't support EQ natively. Now I can capture system audio, apply custom EQ and effects, and stream the processed audio to any network device.

## Technical Highlights

Building AAEQ pushed me to explore several interesting technical areas:

- **Rust for Desktop** - Using egui for immediate-mode GUI with excellent performance
- **Real-Time DSP** - Implementing parametric EQ, compression, and FFT-based analysis
- **Network Protocols** - Working with DLNA/UPnP discovery and streaming
- **Audio Subsystems** - Cross-platform audio I/O with ALSA, CoreAudio, and WASAPI
- **Database Design** - Efficient SQLite schema for EQ mappings and profiles

The codebase is structured as a Cargo workspace with clearly separated concerns: core logic, device integration, persistence, streaming server, and UI.

## Get Started

AAEQ runs on Linux, macOS, and Windows. Pre-built binaries are available on the [releases page](https://github.com/jaschadub/AAEQ/releases), or you can build from source:

```bash
git clone https://github.com/jaschadub/AAEQ.git
cd AAEQ
cargo build --release
./target/release/aaeq
```

The project is open source under the MIT license. Contributions, feature requests, and bug reports are welcome!

## What's Next

I'm actively developing AAEQ with several features planned:

- Enhanced macOS and Windows audio capture support
- Additional DSP effects (reverb, stereo imaging)
- Cloud sync for EQ mappings (optional)
- Plugin system for custom audio processing

Check out the [GitHub repository](https://github.com/jaschadub/AAEQ) to learn more, try it out, or contribute to the project.
