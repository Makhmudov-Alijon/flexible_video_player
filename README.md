# flexible_video_player

# flexible\_video\_player

**FlexibleVideoPlayer** — A Flutter plugin for native texture-based video playback. This README explains installation, core API, and usage examples.

---

## Overview

`flexible_video_player` provides a lightweight way to play videos using native platform textures. It exposes two main components: `FlexibleVideoPlayerController` and `FlexibleVideoView`. Features include track selection, Picture-in-Picture, fullscreen, and standard playback controls.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flexible_video_player:
    path: ../path_to_your_package # or from pub.dev if published, e.g. ^0.0.1
```

then run:

```bash
flutter pub get
```

---

## Quick Start

Example of how to use `FlexibleVideoPlayerController` and `FlexibleVideoView`:

```dart
import 'package:flutter/material.dart';
import 'package:flexible_video_player/flexible_video_player_controller.dart';
import 'package:flexible_video_player/flexible_video_view.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final FlexibleVideoPlayerController controller;
  final sampleUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    controller = FlexibleVideoPlayerController();
    _prepareAndLoad();
  }

  Future<void> _prepareAndLoad() async {
    await controller.initialize();
    await controller.setUrl(sampleUrl);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlexibleVideo Demo')),
      body: Column(
        children: [
          FlexibleVideoView(controller: controller),
          // additional controls here
        ],
      ),
    );
  }
}
```

> Note: Calling `setUrl` automatically initializes the texture if `textureId` is null.

---

## API (Controller)

`FlexibleVideoPlayerController` exposes the following key methods:

* `initialize()` — creates a native texture and sets `textureId`.
* `setUrl(String url)` — loads the video URL and subscribes to event streams.
* `play()` — resume playback.
* `pause()` — pause playback.
* `seekTo(int millis)` — seek to a specific position.
* `setVolume(double v)` — adjust audio volume.
* `getTracks()` — retrieves available video/audio/subtitle tracks and updates state.
* `selectAndroidTrack({rendererIndex, groupIndex, trackIndex})` — select track on Android.
* `enterPictureInPicture()` / `exitPictureInPicture()` — toggle PiP mode.
* `enterFullscreen()` / `exitFullscreen()` — toggle fullscreen.
* `checkPlaying()` — check if playback is active.
* `dispose()` — releases resources and cancels event subscriptions.

### Listening to State Changes

The controller extends `ValueNotifier<VideoPlayerState>`. Use `ValueListenableBuilder` or `controller.addListener()` to update your UI.

`VideoPlayerState` typically includes:

* `textureId` — native texture identifier (int|null)
* `isInitialized` — bool
* `isPlaying` — bool
* `position` — `Duration`
* `duration` — `Duration`
* `isPictureInPicture` — bool
* `isFullscreen` — bool
* `videoTrack`, `audioTrack`, `subtitleTracks` — lists of `VideoPlayerTrack`
* `selectedVideoTrack`, `selectedAudioTrack`, `selectedSubtitleTrack` — selected track info
* `isTracksLoaded` — bool
* `errorDescription` — String?

Example:

```dart
ValueListenableBuilder(
  valueListenable: controller,
  builder: (context, state, child) {
    return Text('Playing: ${state.isPlaying}');
  },
);
```

---

## Track Management

`getTracks()` queries native layers and updates:

* `videoTrack`
* `audioTrack`
* `subtitleTracks`
* selected track fields

On Android, ExoPlayer returns track groups. On iOS, AVPlayer returns track data differently.

---

## Platform Setup

### Android

1. Add internet permission to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

2. Ensure required dependencies (ExoPlayer, MediaRouter, etc.) are declared in `build.gradle`.

3. Verify that the plugin registers and texture initialization is correctly implemented in the native code.

### iOS

1. Add ATS exception if needed to `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

2. Ensure `AVKit`/`AVPlayerLayer` setup in native plugin implementation.

---

## Troubleshooting

* **Video not showing (just loading spinner):** Check that `controller.value.textureId` is not null. Call `initialize()` if needed.
* **No events (position/state):** Confirm that the native event stream is properly registered.
* **Empty track list:** Log native `getTracks()` response to verify format.
* **Memory leaks or texture leaks:** Always call `controller.dispose()` inside `State.dispose()`.

---

## Contributing

Pull requests are welcome.

1. Open an issue or link to an existing one.
2. Submit a PR from a feature/fix branch.
3. Add tests and update the README where needed.

---

## License

MIT License — see `LICENSE` file.

---

## Changelog

* `0.1.0` — Initial release: initialize, setUrl, play/pause/seek, getTracks, PiP, fullscreen.

---


