import 'package:freezed_annotation/freezed_annotation.dart';

part 'flexible_video_player_track.freezed.dart';
part 'flexible_video_player_track.g.dart';

@Freezed(fromJson: true, toJson: false,copyWith: true)
abstract class VideoPlayerTrack with _$VideoPlayerTrack {
  const factory VideoPlayerTrack({
    String? label,
    String? language,
    String? title,
    int? rendererIndex,
    int? groupIndex,
    int? trackIndex,
    int? height,
    int? width,
    int? peakBitrate,
  }) = _VideoPlayerTrack;

  const VideoPlayerTrack._();

  factory VideoPlayerTrack.fromJson(Map<String, dynamic> json) =>
      _$VideoPlayerTrackFromJson(json);
}