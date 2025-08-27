import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flexible_video_player_method_channel.dart';

abstract class FlexibleVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a FlexibleVideoPlayerPlatform.
  FlexibleVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlexibleVideoPlayerPlatform _instance = MethodChannelFlexibleVideoPlayer();

  /// The default instance of [FlexibleVideoPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlexibleVideoPlayer].
  static FlexibleVideoPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlexibleVideoPlayerPlatform] when
  /// they register themselves.
  static set instance(FlexibleVideoPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setUrl(String url) => throw UnimplementedError();
  Stream<dynamic> events(int? textureId) => throw UnimplementedError();
  Future<void> play() => throw UnimplementedError();
  Future<void> pause() => throw UnimplementedError();
  Future<void> seekTo(int millis) => throw UnimplementedError();
  Future<void> setVolume(double volume) => throw UnimplementedError();
  Future<Map<String, List<dynamic>>> getTracks() => throw UnimplementedError();
  Future<void> dispose() => throw UnimplementedError();
  Future<bool> isFullscreen() => throw UnimplementedError();
  Future<bool> checkPlaying() => throw UnimplementedError();
  Future<int?> initialize() => throw UnimplementedError();
  Future<void> selectAndroidTrack({required int rendererIndex, required int groupIndex, required int trackIndex}) => throw UnimplementedError();
  Future<void> enterPictureInPicture() => throw UnimplementedError();
  Future<void> exitPictureInPicture() => throw UnimplementedError();
  Future<void> enterFullscreen() => throw UnimplementedError();
  Future<void> exitFullscreen() => throw UnimplementedError();
}
