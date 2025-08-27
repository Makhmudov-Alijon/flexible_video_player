import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flexible_video_player_platform_interface.dart';

/// An implementation of [FlexibleVideoPlayerPlatform] that uses method channels.
class MethodChannelFlexibleVideoPlayer implements FlexibleVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.

  late MethodChannel methodChannel;
  final EventChannel _eventChannel = const EventChannel('flexible_video_player_event');
  final Map<String, Stream<dynamic>> _eventStreamCache = {};

  Stream<dynamic>? _broadcastEventStream;
  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Stream<dynamic> _globalEventStream(int? textureId) {
    final key = textureId?.toString() ?? 'null';
    return _eventStreamCache.putIfAbsent(key, () {
      return _eventChannel.receiveBroadcastStream({'id': textureId}).asBroadcastStream();
    });
  }

  @override
  Future<void> setUrl(String url) {
    return methodChannel.invokeMethod('setUrl', {'url': url});
  }

  @override
  Future<void> play() => methodChannel.invokeMethod('play');
  @override
  Future<void> pause() => methodChannel.invokeMethod('pause');
  @override
  Future<void> seekTo(int millis) => methodChannel.invokeMethod('seekTo', {'position': millis});
  @override
  Future<void> setVolume(double volume) => methodChannel.invokeMethod('setVolume', {'volume': volume});

  @override
  Future<Map<String, List<dynamic>>> getTracks() async {
    final res = await methodChannel.invokeMapMethod<String, List<dynamic>>('getTracks');
    return res ?? {};
  }

  @override
  Stream<dynamic> events(int? textureId) {
    final stream = _globalEventStream(textureId)
        .where((dynamic raw) {
      if (raw is Map) {
        // normalize key types and compare
        final map = Map<dynamic, dynamic>.from(raw);
        final incomingId = map['id'];
        if (textureId == null) {
          // if caller asked for null, accept events that have null id
          return incomingId == null;
        }
        // accept numeric (int/double), or string ids that parse to int
        if (incomingId is num) {
          return incomingId.toInt() == textureId;
        } else if (incomingId is String) {
          final parsed = int.tryParse(incomingId);
          return parsed == textureId;
        } else {
          return false;
        }
      }
      return false;
    })
        .map((dynamic raw) {
      // ensure we return Map<String, dynamic>
      return Map<String, dynamic>.from(raw as Map);
    });

    return stream;
  }

  @override
  Future<void> dispose() => methodChannel.invokeMethod('dispose',);
  @override
  Future<bool> isFullscreen() async {
    final b = await methodChannel.invokeMethod<bool>('isFullscreen');
    return b ?? false;
  }
  @override
  Future<bool> checkPlaying() async {
    final b = await methodChannel.invokeMethod<bool>('checkPlaying',);
    return b ?? false;
  }

  @override
  Future<int?> initialize() async{
    methodChannel =  MethodChannel('flexible_video_player');
    final textureId = await methodChannel.invokeMethod<int>('create',);
    return textureId;
  }

  void clearEventStreamCacheFor(int? textureId) {
    final key = textureId?.toString() ?? 'null';
    _eventStreamCache.remove(key);
  }

  @override
  Future<void> selectAndroidTrack({required int rendererIndex, required int groupIndex, required int trackIndex}) async{
    methodChannel.invokeMethod('selectTrack', {
      'rendererIndex': rendererIndex,
      'groupIndex': groupIndex,
      'trackIndex': trackIndex,
    });
  }

  Future<void> enterPictureInPicture() => methodChannel.invokeMethod('enterPictureInPicture');
  Future<void> exitPictureInPicture() => methodChannel.invokeMethod('exitPictureInPicture');

  Future<void> enterFullscreen() => methodChannel.invokeMethod('enterFullscreen');
  Future<void> exitFullscreen() => methodChannel.invokeMethod('exitFullscreen');
}
