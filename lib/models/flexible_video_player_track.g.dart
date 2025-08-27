// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexible_video_player_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoPlayerTrack _$VideoPlayerTrackFromJson(Map<String, dynamic> json) =>
    _VideoPlayerTrack(
      label: json['label'] as String?,
      language: json['language'] as String?,
      title: json['title'] as String?,
      rendererIndex: (json['rendererIndex'] as num?)?.toInt(),
      groupIndex: (json['groupIndex'] as num?)?.toInt(),
      trackIndex: (json['trackIndex'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      peakBitrate: (json['peakBitrate'] as num?)?.toInt(),
    );
