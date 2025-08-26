import 'dart:async';

import 'package:flexible_video_player/models/flexible_video_player_state.dart';
import 'package:flutter/material.dart';

import 'flexible_video_player_platform_interface.dart';

class FlexibleVideoPlayerController extends ValueNotifier<VideoPlayerState> {
  StreamSubscription<dynamic>? _eventSub;
  FlexibleVideoPlayerController():super(VideoPlayerState()){
    _subscribe();
  }


  void _subscribe() {
    try {
      final stream = FlexibleVideoPlayerPlatform.instance.events();
      _eventSub = stream.listen(_handleEvent, onError: (e) {
        value = value.copyWith(errorDescription: e?.toString());
      });
    } catch (e) {
      value = value.copyWith(errorDescription: e.toString());
    }
  }

  void _handleEvent(dynamic raw) {
    if (raw is! Map) return;
    final Map<String, dynamic> event = Map<String, dynamic>.from(raw);
    final String? type = event['event'] as String?;
    if (type == null) return;

    switch (type) {
      case 'position':
        final pos = (event['position'] ?? 0) as int;
        final dur = (event['duration'] ?? 0) as int;
        value = value.copyWith(position: Duration(milliseconds: pos), duration: Duration(milliseconds: dur));
        break;
      case 'state':
        final bool playing = event['playing'] as bool? ?? value.isPlaying;
        value = value.copyWith(isPlaying: playing);
        break;
      default:
        break;
    }
  }

  Future<void> initialize() async{
    FlexibleVideoPlayerPlatform.instance.initialize().then((result){
      if (result != null) {
        value = value.copyWith(
          isInitialized: true,
          textureId:  result
        );
      }
    });
  }


  Future<void> setUrl(String url) async{
    FlexibleVideoPlayerPlatform.instance.setUrl( url).then((result) {
      value = value.copyWith(
        isPlaying: true
      );
    });
  }
  Future<void> play() => FlexibleVideoPlayerPlatform.instance.play();
  Future<void> pause() => FlexibleVideoPlayerPlatform.instance.pause();
  Future<void> seekTo(int millis) => FlexibleVideoPlayerPlatform.instance.seekTo( millis);
  Future<void> setVolume(double v) => FlexibleVideoPlayerPlatform.instance.setVolume( v);
  // Future<Map<String, dynamic>> getTracks() => FlexibleVideoPlayerPlatform.instance.getTracks(id);
  Future<bool> isFullscreen() => FlexibleVideoPlayerPlatform.instance.isFullscreen();
  Future<bool> checkPlaying() => FlexibleVideoPlayerPlatform.instance.checkPlaying();
  @override
  Future<void> dispose() async {
    await _eventSub?.cancel();
    _eventSub = null;
    await FlexibleVideoPlayerPlatform.instance.dispose();
    super.dispose();
  }
}