import 'package:flutter/services.dart';

import 'flexible_video_player_platform_interface.dart';

/// An implementation of [FlexibleVideoPlayerPlatform] that uses method channels.
class MethodChannelFlexibleVideoPlayer implements FlexibleVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.

  late MethodChannel methodChannel;
  final EventChannel _eventChannel = const EventChannel('flexible_video_player_event');
  final Map<String, Stream<dynamic>> _eventStreamCache = {};

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
  Future<void> setUrl(String url,int textureId) {
    return methodChannel.invokeMethod('setUrl', {'url': url,'textureId': textureId});
  }

  @override
  Future<void> play(int textureId) => methodChannel.invokeMethod('play',{"textureId": textureId});
  @override
  Future<void> pause(int textureId) => methodChannel.invokeMethod('pause',{"textureId": textureId});
  @override
  Future<void> seekTo(int millis,int textureId) => methodChannel.invokeMethod('seekTo', {'position': millis,"textureId": textureId});
  @override
  Future<void> setVolume(double volume,int textureId) => methodChannel.invokeMethod('setVolume', {'volume': volume,"textureId": textureId});

  @override
  Future<Map<String, List<dynamic>>> getTracks(int textureId) async {
    final res = await methodChannel.invokeMapMethod<String, List<dynamic>>('getTracks',{"textureId": textureId});
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
  Future<void> dispose(int textureId) => methodChannel.invokeMethod('dispose',{"textureId": textureId});
  @override
  Future<bool> isFullscreen(int textureId) async {
    final b = await methodChannel.invokeMethod<bool>('isFullscreen',{"textureId": textureId});
    return b ?? false;
  }
  @override
  Future<bool> checkPlaying(int textureId) async {
    final b = await methodChannel.invokeMethod<bool>('checkPlaying',{"textureId": textureId});
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
  @override
  Future<void> enterPictureInPicture(int textureId) => methodChannel.invokeMethod('enterPictureInPicture',{"textureId": textureId});
  @override
  Future<void> exitPictureInPicture(int textureId) => methodChannel.invokeMethod('exitPictureInPicture',{"textureId": textureId});
  @override
  Future<void> enterFullscreen(int textureId) => methodChannel.invokeMethod('enterFullscreen',{"textureId": textureId});
  @override
  Future<void> exitFullscreen(int textureId) => methodChannel.invokeMethod('exitFullscreen',{"textureId": textureId});
}
