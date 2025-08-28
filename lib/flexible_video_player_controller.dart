import 'dart:async';

import 'package:flexible_video_player/models/flexible_video_player_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'flexible_video_player_platform_interface.dart';
import 'models/flexible_video_player_track.dart';

class FlexibleVideoPlayerController extends ValueNotifier<VideoPlayerState> {
  StreamSubscription<dynamic>? _eventSub;

  FlexibleVideoPlayerController() : super(VideoPlayerState());

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    final parsed = int.tryParse(v.toString());
    return parsed ?? 0;
  }

  // Helper to robustly convert to bool
  bool _toBool(dynamic v, {bool fallback = false}) {
    if (v == null) return fallback;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v.toString().toLowerCase();
    if (s == 'true') return true;
    if (s == 'false') return false;
    return fallback;
  }

  void _subscribe() {
    if (_eventSub != null) return;

    final stream = FlexibleVideoPlayerPlatform.instance.events(value.textureId);
    _eventSub = stream.listen(
      _handleEvent,
      onError: (e) {
        // if (kDebugMode)
        //   debugPrint('FlexibleVideoPlayerController event error: $e');
        value = value.copyWith(errorDescription: e?.toString());
      },
      onDone: () {
        if (kDebugMode) debugPrint('FlexibleVideoPlayerController events done');
        _eventSub = null;
      },
      cancelOnError: false,
    );
  }

  void _handleEvent(dynamic raw) {
    if (raw is! Map) return;
    final Map<String, dynamic> event = Map<String, dynamic>.from(raw);
    final String? type = event['event'] as String?;
    if (type == null) return;

    switch (type) {
      case 'position':
        final pos = _toInt(event['position']);
        final dur = _toInt(event['duration']);
        value = value.copyWith(
          position: Duration(milliseconds: pos),
          duration: Duration(milliseconds: dur),
        );
        if(pos > 0 && !value.isTracksLoaded) {
          getTracks();
        }
        break;
      case 'state':
        final playing = _toBool(event['playing'], fallback: value.isPlaying);
        value = value.copyWith(isPlaying: playing);
        break;
      case 'pipState':
        final playing = _toBool(event['inPip'], fallback: value.isPictureInPicture);
        value = value.copyWith(isPictureInPicture: playing);
        break;
      default:
        // ignore unknown events but optionally log
        // if (kDebugMode)
        //   debugPrint('FlexibleVideoPlayerController unknown event: $event');
        break;
    }
  }

  // initialize and set textureId
  Future<void> initialize() async {
    try {
      final result = await FlexibleVideoPlayerPlatform.instance.initialize();
      if (result != null) {
        value = value.copyWith(isInitialized: true, textureId: result);
      }
    } catch (e) {
      value = value.copyWith(errorDescription: e.toString());
    }
  }

  Future<void> setUrl(String url) async {
    try {
      // ensure we have a texture
      if (value.textureId == null) {
        await initialize();
      }

      FlexibleVideoPlayerPlatform.instance.setUrl(url).then((value) {
        _subscribe();
      });

      value = value.copyWith(isPlaying: true);
    } catch (e) {
      value = value.copyWith(errorDescription: e.toString());
    }
  }

  Future<void> getTracks() async {
    try {
      final result = await FlexibleVideoPlayerPlatform.instance.getTracks();
      value = value.copyWith(isTracksLoaded: true);

      if(defaultTargetPlatform == TargetPlatform.iOS){

      }else{
        value = value.copyWith(
            videoTrack: (result['video'] ?? []).toList()
                .map((e) => VideoPlayerTrack.fromJson(e as Map<String, dynamic>))
                .toList(),
            audioTrack: (result['audio'] ?? []).toList()
                .map((e) => VideoPlayerTrack.fromJson(e as Map<String, dynamic>))
                .toList(),
            subtitleTracks: (result['text'] ?? []).toList()
                .map((e) => VideoPlayerTrack.fromJson(e as Map<String, dynamic>))
                .toList(),
          selectedVideoTrack: _parseFirst(result['current_video']),
          selectedAudioTrack: _parseFirst(result['current_audio']),
          selectedSubtitleTrack: _parseFirst(result['current_text']),
        );
      }
    } catch (e) {
      value = value.copyWith(errorDescription: e.toString());
    }
  }

  VideoPlayerTrack? _parseFirst(dynamic raw) {
    final first = (raw as List? ?? []).firstOrNull;
    if (first is Map) {
      return VideoPlayerTrack.fromJson(first.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> selectAndroidTrack({required int rendererIndex, required int groupIndex, required int trackIndex}) async{
    FlexibleVideoPlayerPlatform.instance.selectAndroidTrack(rendererIndex: rendererIndex, groupIndex: groupIndex, trackIndex: trackIndex);
  }

  Future<void> play() => FlexibleVideoPlayerPlatform.instance.play();

  Future<void> pause() => FlexibleVideoPlayerPlatform.instance.pause();

  Future<void> seekTo(int millis) =>
      FlexibleVideoPlayerPlatform.instance.seekTo(millis);

  Future<void> setVolume(double v) =>
      FlexibleVideoPlayerPlatform.instance.setVolume(v);

  Future<bool> isFullscreen() =>
      FlexibleVideoPlayerPlatform.instance.isFullscreen();

  Future<bool> checkPlaying() =>
      FlexibleVideoPlayerPlatform.instance.checkPlaying();

  Future<void> enterPictureInPicture() async{
    FlexibleVideoPlayerPlatform.instance.enterPictureInPicture().then((_) {
      value = value.copyWith(isPictureInPicture: true);
    });
  }
  Future<void> exitPictureInPicture() async{
    FlexibleVideoPlayerPlatform.instance.exitPictureInPicture().then((_) {
      value = value.copyWith(isPictureInPicture: false);
    });
  }

  Future<void> enterFullscreen() async{
    FlexibleVideoPlayerPlatform.instance.enterFullscreen().then((_) {
      value = value.copyWith(isFullscreen: true);
    });
  }
  Future<void> exitFullscreen() async{
    FlexibleVideoPlayerPlatform.instance.exitFullscreen().then((_) {
      value = value.copyWith(isFullscreen: false);
    });
  }

  @override
  Future<void> dispose() async {
    await _eventSub?.cancel();
    _eventSub = null;
    try {
      await FlexibleVideoPlayerPlatform.instance.dispose();
    } catch (e) {
      if (kDebugMode) debugPrint('Error calling platform dispose: $e');
    }
    super.dispose();
  }
}
