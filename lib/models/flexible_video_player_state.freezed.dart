// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flexible_video_player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoPlayerState {

 Duration get duration; Duration get position; bool get isInitialized; int? get textureId; bool get isPlaying; bool get isLooping; bool get isBuffering; double get volume; double get playbackSpeed; int get rotationCorrection; bool get isCompleted; bool get isFullscreen; bool get isPictureInPicture; String? get errorDescription; List<VideoPlayerTrack> get videoTrack; List<VideoPlayerTrack> get audioTrack; List<VideoPlayerTrack> get subtitleTracks; VideoPlayerTrack? get selectedVideoTrack; VideoPlayerTrack? get selectedAudioTrack; VideoPlayerTrack? get selectedSubtitleTrack; bool get isTracksLoaded;
/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoPlayerStateCopyWith<VideoPlayerState> get copyWith => _$VideoPlayerStateCopyWithImpl<VideoPlayerState>(this as VideoPlayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoPlayerState&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isLooping, isLooping) || other.isLooping == isLooping)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.rotationCorrection, rotationCorrection) || other.rotationCorrection == rotationCorrection)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isFullscreen, isFullscreen) || other.isFullscreen == isFullscreen)&&(identical(other.isPictureInPicture, isPictureInPicture) || other.isPictureInPicture == isPictureInPicture)&&(identical(other.errorDescription, errorDescription) || other.errorDescription == errorDescription)&&const DeepCollectionEquality().equals(other.videoTrack, videoTrack)&&const DeepCollectionEquality().equals(other.audioTrack, audioTrack)&&const DeepCollectionEquality().equals(other.subtitleTracks, subtitleTracks)&&(identical(other.selectedVideoTrack, selectedVideoTrack) || other.selectedVideoTrack == selectedVideoTrack)&&(identical(other.selectedAudioTrack, selectedAudioTrack) || other.selectedAudioTrack == selectedAudioTrack)&&(identical(other.selectedSubtitleTrack, selectedSubtitleTrack) || other.selectedSubtitleTrack == selectedSubtitleTrack)&&(identical(other.isTracksLoaded, isTracksLoaded) || other.isTracksLoaded == isTracksLoaded));
}


@override
int get hashCode => Object.hashAll([runtimeType,duration,position,isInitialized,textureId,isPlaying,isLooping,isBuffering,volume,playbackSpeed,rotationCorrection,isCompleted,isFullscreen,isPictureInPicture,errorDescription,const DeepCollectionEquality().hash(videoTrack),const DeepCollectionEquality().hash(audioTrack),const DeepCollectionEquality().hash(subtitleTracks),selectedVideoTrack,selectedAudioTrack,selectedSubtitleTrack,isTracksLoaded]);

@override
String toString() {
  return 'VideoPlayerState(duration: $duration, position: $position, isInitialized: $isInitialized, textureId: $textureId, isPlaying: $isPlaying, isLooping: $isLooping, isBuffering: $isBuffering, volume: $volume, playbackSpeed: $playbackSpeed, rotationCorrection: $rotationCorrection, isCompleted: $isCompleted, isFullscreen: $isFullscreen, isPictureInPicture: $isPictureInPicture, errorDescription: $errorDescription, videoTrack: $videoTrack, audioTrack: $audioTrack, subtitleTracks: $subtitleTracks, selectedVideoTrack: $selectedVideoTrack, selectedAudioTrack: $selectedAudioTrack, selectedSubtitleTrack: $selectedSubtitleTrack, isTracksLoaded: $isTracksLoaded)';
}


}

/// @nodoc
abstract mixin class $VideoPlayerStateCopyWith<$Res>  {
  factory $VideoPlayerStateCopyWith(VideoPlayerState value, $Res Function(VideoPlayerState) _then) = _$VideoPlayerStateCopyWithImpl;
@useResult
$Res call({
 Duration duration, Duration position, bool isInitialized, int? textureId, bool isPlaying, bool isLooping, bool isBuffering, double volume, double playbackSpeed, int rotationCorrection, bool isCompleted, bool isFullscreen, bool isPictureInPicture, String? errorDescription, List<VideoPlayerTrack> videoTrack, List<VideoPlayerTrack> audioTrack, List<VideoPlayerTrack> subtitleTracks, VideoPlayerTrack? selectedVideoTrack, VideoPlayerTrack? selectedAudioTrack, VideoPlayerTrack? selectedSubtitleTrack, bool isTracksLoaded
});


$VideoPlayerTrackCopyWith<$Res>? get selectedVideoTrack;$VideoPlayerTrackCopyWith<$Res>? get selectedAudioTrack;$VideoPlayerTrackCopyWith<$Res>? get selectedSubtitleTrack;

}
/// @nodoc
class _$VideoPlayerStateCopyWithImpl<$Res>
    implements $VideoPlayerStateCopyWith<$Res> {
  _$VideoPlayerStateCopyWithImpl(this._self, this._then);

  final VideoPlayerState _self;
  final $Res Function(VideoPlayerState) _then;

/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? position = null,Object? isInitialized = null,Object? textureId = freezed,Object? isPlaying = null,Object? isLooping = null,Object? isBuffering = null,Object? volume = null,Object? playbackSpeed = null,Object? rotationCorrection = null,Object? isCompleted = null,Object? isFullscreen = null,Object? isPictureInPicture = null,Object? errorDescription = freezed,Object? videoTrack = null,Object? audioTrack = null,Object? subtitleTracks = null,Object? selectedVideoTrack = freezed,Object? selectedAudioTrack = freezed,Object? selectedSubtitleTrack = freezed,Object? isTracksLoaded = null,}) {
  return _then(_self.copyWith(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,textureId: freezed == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isLooping: null == isLooping ? _self.isLooping : isLooping // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as double,rotationCorrection: null == rotationCorrection ? _self.rotationCorrection : rotationCorrection // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isFullscreen: null == isFullscreen ? _self.isFullscreen : isFullscreen // ignore: cast_nullable_to_non_nullable
as bool,isPictureInPicture: null == isPictureInPicture ? _self.isPictureInPicture : isPictureInPicture // ignore: cast_nullable_to_non_nullable
as bool,errorDescription: freezed == errorDescription ? _self.errorDescription : errorDescription // ignore: cast_nullable_to_non_nullable
as String?,videoTrack: null == videoTrack ? _self.videoTrack : videoTrack // ignore: cast_nullable_to_non_nullable
as List<VideoPlayerTrack>,audioTrack: null == audioTrack ? _self.audioTrack : audioTrack // ignore: cast_nullable_to_non_nullable
as List<VideoPlayerTrack>,subtitleTracks: null == subtitleTracks ? _self.subtitleTracks : subtitleTracks // ignore: cast_nullable_to_non_nullable
as List<VideoPlayerTrack>,selectedVideoTrack: freezed == selectedVideoTrack ? _self.selectedVideoTrack : selectedVideoTrack // ignore: cast_nullable_to_non_nullable
as VideoPlayerTrack?,selectedAudioTrack: freezed == selectedAudioTrack ? _self.selectedAudioTrack : selectedAudioTrack // ignore: cast_nullable_to_non_nullable
as VideoPlayerTrack?,selectedSubtitleTrack: freezed == selectedSubtitleTrack ? _self.selectedSubtitleTrack : selectedSubtitleTrack // ignore: cast_nullable_to_non_nullable
as VideoPlayerTrack?,isTracksLoaded: null == isTracksLoaded ? _self.isTracksLoaded : isTracksLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoPlayerTrackCopyWith<$Res>? get selectedVideoTrack {
    if (_self.selectedVideoTrack == null) {
    return null;
  }

  return $VideoPlayerTrackCopyWith<$Res>(_self.selectedVideoTrack!, (value) {
    return _then(_self.copyWith(selectedVideoTrack: value));
  });
}/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoPlayerTrackCopyWith<$Res>? get selectedAudioTrack {
    if (_self.selectedAudioTrack == null) {
    return null;
  }

  return $VideoPlayerTrackCopyWith<$Res>(_self.selectedAudioTrack!, (value) {
    return _then(_self.copyWith(selectedAudioTrack: value));
  });
}/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoPlayerTrackCopyWith<$Res>? get selectedSubtitleTrack {
    if (_self.selectedSubtitleTrack == null) {
    return null;
  }

  return $VideoPlayerTrackCopyWith<$Res>(_self.selectedSubtitleTrack!, (value) {
    return _then(_self.copyWith(selectedSubtitleTrack: value));
  });
}
}


/// Adds pattern-matching-related methods to [VideoPlayerState].
extension VideoPlayerStatePatterns on VideoPlayerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoPlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoPlayerState value)  $default,){
final _that = this;
switch (_that) {
case _VideoPlayerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoPlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration duration,  Duration position,  bool isInitialized,  int? textureId,  bool isPlaying,  bool isLooping,  bool isBuffering,  double volume,  double playbackSpeed,  int rotationCorrection,  bool isCompleted,  bool isFullscreen,  bool isPictureInPicture,  String? errorDescription,  List<VideoPlayerTrack> videoTrack,  List<VideoPlayerTrack> audioTrack,  List<VideoPlayerTrack> subtitleTracks,  VideoPlayerTrack? selectedVideoTrack,  VideoPlayerTrack? selectedAudioTrack,  VideoPlayerTrack? selectedSubtitleTrack,  bool isTracksLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that.duration,_that.position,_that.isInitialized,_that.textureId,_that.isPlaying,_that.isLooping,_that.isBuffering,_that.volume,_that.playbackSpeed,_that.rotationCorrection,_that.isCompleted,_that.isFullscreen,_that.isPictureInPicture,_that.errorDescription,_that.videoTrack,_that.audioTrack,_that.subtitleTracks,_that.selectedVideoTrack,_that.selectedAudioTrack,_that.selectedSubtitleTrack,_that.isTracksLoaded);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration duration,  Duration position,  bool isInitialized,  int? textureId,  bool isPlaying,  bool isLooping,  bool isBuffering,  double volume,  double playbackSpeed,  int rotationCorrection,  bool isCompleted,  bool isFullscreen,  bool isPictureInPicture,  String? errorDescription,  List<VideoPlayerTrack> videoTrack,  List<VideoPlayerTrack> audioTrack,  List<VideoPlayerTrack> subtitleTracks,  VideoPlayerTrack? selectedVideoTrack,  VideoPlayerTrack? selectedAudioTrack,  VideoPlayerTrack? selectedSubtitleTrack,  bool isTracksLoaded)  $default,) {final _that = this;
switch (_that) {
case _VideoPlayerState():
return $default(_that.duration,_that.position,_that.isInitialized,_that.textureId,_that.isPlaying,_that.isLooping,_that.isBuffering,_that.volume,_that.playbackSpeed,_that.rotationCorrection,_that.isCompleted,_that.isFullscreen,_that.isPictureInPicture,_that.errorDescription,_that.videoTrack,_that.audioTrack,_that.subtitleTracks,_that.selectedVideoTrack,_that.selectedAudioTrack,_that.selectedSubtitleTrack,_that.isTracksLoaded);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration duration,  Duration position,  bool isInitialized,  int? textureId,  bool isPlaying,  bool isLooping,  bool isBuffering,  double volume,  double playbackSpeed,  int rotationCorrection,  bool isCompleted,  bool isFullscreen,  bool isPictureInPicture,  String? errorDescription,  List<VideoPlayerTrack> videoTrack,  List<VideoPlayerTrack> audioTrack,  List<VideoPlayerTrack> subtitleTracks,  VideoPlayerTrack? selectedVideoTrack,  VideoPlayerTrack? selectedAudioTrack,  VideoPlayerTrack? selectedSubtitleTrack,  bool isTracksLoaded)?  $default,) {final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that.duration,_that.position,_that.isInitialized,_that.textureId,_that.isPlaying,_that.isLooping,_that.isBuffering,_that.volume,_that.playbackSpeed,_that.rotationCorrection,_that.isCompleted,_that.isFullscreen,_that.isPictureInPicture,_that.errorDescription,_that.videoTrack,_that.audioTrack,_that.subtitleTracks,_that.selectedVideoTrack,_that.selectedAudioTrack,_that.selectedSubtitleTrack,_that.isTracksLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _VideoPlayerState extends VideoPlayerState {
  const _VideoPlayerState({this.duration = Duration.zero, this.position = Duration.zero, this.isInitialized = false, this.textureId = null, this.isPlaying = false, this.isLooping = false, this.isBuffering = false, this.volume = 1.0, this.playbackSpeed = 1.0, this.rotationCorrection = 0, this.isCompleted = false, this.isFullscreen = false, this.isPictureInPicture = false, this.errorDescription, final  List<VideoPlayerTrack> videoTrack = const [], final  List<VideoPlayerTrack> audioTrack = const [], final  List<VideoPlayerTrack> subtitleTracks = const [], this.selectedVideoTrack, this.selectedAudioTrack = null, this.selectedSubtitleTrack = null, this.isTracksLoaded = false}): _videoTrack = videoTrack,_audioTrack = audioTrack,_subtitleTracks = subtitleTracks,super._();
  

@override@JsonKey() final  Duration duration;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  bool isInitialized;
@override@JsonKey() final  int? textureId;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isLooping;
@override@JsonKey() final  bool isBuffering;
@override@JsonKey() final  double volume;
@override@JsonKey() final  double playbackSpeed;
@override@JsonKey() final  int rotationCorrection;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  bool isFullscreen;
@override@JsonKey() final  bool isPictureInPicture;
@override final  String? errorDescription;
 final  List<VideoPlayerTrack> _videoTrack;
@override@JsonKey() List<VideoPlayerTrack> get videoTrack {
  if (_videoTrack is EqualUnmodifiableListView) return _videoTrack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videoTrack);
}

 final  List<VideoPlayerTrack> _audioTrack;
@override@JsonKey() List<VideoPlayerTrack> get audioTrack {
  if (_audioTrack is EqualUnmodifiableListView) return _audioTrack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audioTrack);
}

 final  List<VideoPlayerTrack> _subtitleTracks;
@override@JsonKey() List<VideoPlayerTrack> get subtitleTracks {
  if (_subtitleTracks is EqualUnmodifiableListView) return _subtitleTracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtitleTracks);
}

@override final  VideoPlayerTrack? selectedVideoTrack;
@override@JsonKey() final  VideoPlayerTrack? selectedAudioTrack;
@override@JsonKey() final  VideoPlayerTrack? selectedSubtitleTrack;
@override@JsonKey() final  bool isTracksLoaded;

/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoPlayerStateCopyWith<_VideoPlayerState> get copyWith => __$VideoPlayerStateCopyWithImpl<_VideoPlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoPlayerState&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isLooping, isLooping) || other.isLooping == isLooping)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.rotationCorrection, rotationCorrection) || other.rotationCorrection == rotationCorrection)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isFullscreen, isFullscreen) || other.isFullscreen == isFullscreen)&&(identical(other.isPictureInPicture, isPictureInPicture) || other.isPictureInPicture == isPictureInPicture)&&(identical(other.errorDescription, errorDescription) || other.errorDescription == errorDescription)&&const DeepCollectionEquality().equals(other._videoTrack, _videoTrack)&&const DeepCollectionEquality().equals(other._audioTrack, _audioTrack)&&const DeepCollectionEquality().equals(other._subtitleTracks, _subtitleTracks)&&(identical(other.selectedVideoTrack, selectedVideoTrack) || other.selectedVideoTrack == selectedVideoTrack)&&(identical(other.selectedAudioTrack, selectedAudioTrack) || other.selectedAudioTrack == selectedAudioTrack)&&(identical(other.selectedSubtitleTrack, selectedSubtitleTrack) || other.selectedSubtitleTrack == selectedSubtitleTrack)&&(identical(other.isTracksLoaded, isTracksLoaded) || other.isTracksLoaded == isTracksLoaded));
}


@override
int get hashCode => Object.hashAll([runtimeType,duration,position,isInitialized,textureId,isPlaying,isLooping,isBuffering,volume,playbackSpeed,rotationCorrection,isCompleted,isFullscreen,isPictureInPicture,errorDescription,const DeepCollectionEquality().hash(_videoTrack),const DeepCollectionEquality().hash(_audioTrack),const DeepCollectionEquality().hash(_subtitleTracks),selectedVideoTrack,selectedAudioTrack,selectedSubtitleTrack,isTracksLoaded]);

@override
String toString() {
  return 'VideoPlayerState(duration: $duration, position: $position, isInitialized: $isInitialized, textureId: $textureId, isPlaying: $isPlaying, isLooping: $isLooping, isBuffering: $isBuffering, volume: $volume, playbackSpeed: $playbackSpeed, rotationCorrection: $rotationCorrection, isCompleted: $isCompleted, isFullscreen: $isFullscreen, isPictureInPicture: $isPictureInPicture, errorDescription: $errorDescription, videoTrack: $videoTrack, audioTrack: $audioTrack, subtitleTracks: $subtitleTracks, selectedVideoTrack: $selectedVideoTrack, selectedAudioTrack: $selectedAudioTrack, selectedSubtitleTrack: $selectedSubtitleTrack, isTracksLoaded: $isTracksLoaded)';
}


}

/// @nodoc
abstract mixin class _$VideoPlayerStateCopyWith<$Res> implements $VideoPlayerStateCopyWith<$Res> {
  factory _$VideoPlayerStateCopyWith(_VideoPlayerState value, $Res Function(_VideoPlayerState) _then) = __$VideoPlayerStateCopyWithImpl;
@override @useResult
$Res call({
 Duration duration, Duration position, bool isInitialized, int? textureId, bool isPlaying, bool isLooping, bool isBuffering, double volume, double playbackSpeed, int rotationCorrection, bool isCompleted, bool isFullscreen, bool isPictureInPicture, String? errorDescription, List<VideoPlayerTrack> videoTrack, List<VideoPlayerTrack> audioTrack, List<VideoPlayerTrack> subtitleTracks, VideoPlayerTrack? selectedVideoTrack, VideoPlayerTrack? selectedAudioTrack, VideoPlayerTrack? selectedSubtitleTrack, bool isTracksLoaded
});


@override $VideoPlayerTrackCopyWith<$Res>? get selectedVideoTrack;@override $VideoPlayerTrackCopyWith<$Res>? get selectedAudioTrack;@override $VideoPlayerTrackCopyWith<$Res>? get selectedSubtitleTrack;

}
/// @nodoc
class __$VideoPlayerStateCopyWithImpl<$Res>
    implements _$VideoPlayerStateCopyWith<$Res> {
  __$VideoPlayerStateCopyWithImpl(this._self, this._then);

  final _VideoPlayerState _self;
  final $Res Function(_VideoPlayerState) _then;

/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? duration = null,Object? position = null,Object? isInitialized = null,Object? textureId = freezed,Object? isPlaying = null,Object? isLooping = null,Object? isBuffering = null,Object? volume = null,Object? playbackSpeed = null,Object? rotationCorrection = null,Object? isCompleted = null,Object? isFullscreen = null,Object? isPictureInPicture = null,Object? errorDescription = freezed,Object? videoTrack = null,Object? audioTrack = null,Object? subtitleTracks = null,Object? selectedVideoTrack = freezed,Object? selectedAudioTrack = freezed,Object? selectedSubtitleTrack = freezed,Object? isTracksLoaded = null,}) {
  return _then(_VideoPlayerState(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,textureId: freezed == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isLooping: null == isLooping ? _self.isLooping : isLooping // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as double,rotationCorrection: null == rotationCorrection ? _self.rotationCorrection : rotationCorrection // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isFullscreen: null == isFullscreen ? _self.isFullscreen : isFullscreen // ignore: cast_nullable_to_non_nullable
as bool,isPictureInPicture: null == isPictureInPicture ? _self.isPictureInPicture : isPictureInPicture // ignore: cast_nullable_to_non_nullable
as bool,errorDescription: freezed == errorDescription ? _self.errorDescription : errorDescription // ignore: cast_nullable_to_non_nullable
as String?,videoTrack: null == videoTrack ? _self._videoTrack : videoTrack // ignore: cast_nullable_to_non_nullable
as List<VideoPlayerTrack>,audioTrack: null == audioTrack ? _self._audioTrack : audioTrack // ignore: cast_nullable_to_non_nullable
as List<VideoPlayerTrack>,subtitleTracks: null == subtitleTracks ? _self._subtitleTracks : subtitleTracks // ignore: cast_nullable_to_non_nullable
as List<VideoPlayerTrack>,selectedVideoTrack: freezed == selectedVideoTrack ? _self.selectedVideoTrack : selectedVideoTrack // ignore: cast_nullable_to_non_nullable
as VideoPlayerTrack?,selectedAudioTrack: freezed == selectedAudioTrack ? _self.selectedAudioTrack : selectedAudioTrack // ignore: cast_nullable_to_non_nullable
as VideoPlayerTrack?,selectedSubtitleTrack: freezed == selectedSubtitleTrack ? _self.selectedSubtitleTrack : selectedSubtitleTrack // ignore: cast_nullable_to_non_nullable
as VideoPlayerTrack?,isTracksLoaded: null == isTracksLoaded ? _self.isTracksLoaded : isTracksLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoPlayerTrackCopyWith<$Res>? get selectedVideoTrack {
    if (_self.selectedVideoTrack == null) {
    return null;
  }

  return $VideoPlayerTrackCopyWith<$Res>(_self.selectedVideoTrack!, (value) {
    return _then(_self.copyWith(selectedVideoTrack: value));
  });
}/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoPlayerTrackCopyWith<$Res>? get selectedAudioTrack {
    if (_self.selectedAudioTrack == null) {
    return null;
  }

  return $VideoPlayerTrackCopyWith<$Res>(_self.selectedAudioTrack!, (value) {
    return _then(_self.copyWith(selectedAudioTrack: value));
  });
}/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoPlayerTrackCopyWith<$Res>? get selectedSubtitleTrack {
    if (_self.selectedSubtitleTrack == null) {
    return null;
  }

  return $VideoPlayerTrackCopyWith<$Res>(_self.selectedSubtitleTrack!, (value) {
    return _then(_self.copyWith(selectedSubtitleTrack: value));
  });
}
}

// dart format on
