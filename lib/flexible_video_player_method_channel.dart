import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flexible_video_player_platform_interface.dart';

/// An implementation of [FlexibleVideoPlayerPlatform] that uses method channels.
class MethodChannelFlexibleVideoPlayer implements FlexibleVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.

  late MethodChannel methodChannel;
  final EventChannel _eventChannel = const EventChannel('flexible_video_player_event');

  Stream<dynamic>? _broadcastEventStream;
  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Stream<dynamic> _globalEventStream() {
    _broadcastEventStream ??= _eventChannel.receiveBroadcastStream().asBroadcastStream();
    return _broadcastEventStream!;
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
  Future<Map<String, dynamic>> getTracks(int id) async {
    final res = await methodChannel.invokeMapMethod<String, dynamic>('getTracks', {'id': id});
    return res ?? {};
  }
  @override
  Stream<dynamic> events() {
    return _globalEventStream().where((dynamic raw) {
      if (raw is Map) {
        // raw may be Map<dynamic,dynamic>, convert to Map<String,dynamic>
        final map = Map<String, dynamic>.from(raw);
        final incomingId = map['id'];
        return incomingId;
      }
      return false;
    }).map((dynamic raw) {
      // normalize to Map<String,dynamic>
      return Map<String, dynamic>.from(raw as Map);
    });
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

}
