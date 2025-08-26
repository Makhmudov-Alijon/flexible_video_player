import 'package:freezed_annotation/freezed_annotation.dart';

part 'flexible_video_player_state.freezed.dart';

@Freezed(fromJson: false, toJson: false,copyWith: true)
abstract class VideoPlayerState with _$VideoPlayerState {
  const factory VideoPlayerState({
    @Default(Duration.zero) Duration duration,
    @Default(Duration.zero) Duration position,
    @Default(false) bool isInitialized,
    @Default(null) int? textureId,
    @Default(false) bool isPlaying,
    @Default(false) bool isLooping,
    @Default(false) bool isBuffering,
    @Default(1.0) double volume,
    @Default(1.0) double playbackSpeed,
    @Default(0) int rotationCorrection,
    @Default(false) bool isCompleted,
    String? errorDescription,
  }) = _VideoPlayerState;

  const VideoPlayerState._();


}