// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flexible_video_player_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoPlayerTrack {

 String? get label; String? get language; String? get title; int? get rendererIndex; int? get groupIndex; int? get trackIndex; int? get height; int? get width; int? get peakBitrate;
/// Create a copy of VideoPlayerTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoPlayerTrackCopyWith<VideoPlayerTrack> get copyWith => _$VideoPlayerTrackCopyWithImpl<VideoPlayerTrack>(this as VideoPlayerTrack, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoPlayerTrack&&(identical(other.label, label) || other.label == label)&&(identical(other.language, language) || other.language == language)&&(identical(other.title, title) || other.title == title)&&(identical(other.rendererIndex, rendererIndex) || other.rendererIndex == rendererIndex)&&(identical(other.groupIndex, groupIndex) || other.groupIndex == groupIndex)&&(identical(other.trackIndex, trackIndex) || other.trackIndex == trackIndex)&&(identical(other.height, height) || other.height == height)&&(identical(other.width, width) || other.width == width)&&(identical(other.peakBitrate, peakBitrate) || other.peakBitrate == peakBitrate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,language,title,rendererIndex,groupIndex,trackIndex,height,width,peakBitrate);

@override
String toString() {
  return 'VideoPlayerTrack(label: $label, language: $language, title: $title, rendererIndex: $rendererIndex, groupIndex: $groupIndex, trackIndex: $trackIndex, height: $height, width: $width, peakBitrate: $peakBitrate)';
}


}

/// @nodoc
abstract mixin class $VideoPlayerTrackCopyWith<$Res>  {
  factory $VideoPlayerTrackCopyWith(VideoPlayerTrack value, $Res Function(VideoPlayerTrack) _then) = _$VideoPlayerTrackCopyWithImpl;
@useResult
$Res call({
 String? label, String? language, String? title, int? rendererIndex, int? groupIndex, int? trackIndex, int? height, int? width, int? peakBitrate
});




}
/// @nodoc
class _$VideoPlayerTrackCopyWithImpl<$Res>
    implements $VideoPlayerTrackCopyWith<$Res> {
  _$VideoPlayerTrackCopyWithImpl(this._self, this._then);

  final VideoPlayerTrack _self;
  final $Res Function(VideoPlayerTrack) _then;

/// Create a copy of VideoPlayerTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = freezed,Object? language = freezed,Object? title = freezed,Object? rendererIndex = freezed,Object? groupIndex = freezed,Object? trackIndex = freezed,Object? height = freezed,Object? width = freezed,Object? peakBitrate = freezed,}) {
  return _then(_self.copyWith(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,rendererIndex: freezed == rendererIndex ? _self.rendererIndex : rendererIndex // ignore: cast_nullable_to_non_nullable
as int?,groupIndex: freezed == groupIndex ? _self.groupIndex : groupIndex // ignore: cast_nullable_to_non_nullable
as int?,trackIndex: freezed == trackIndex ? _self.trackIndex : trackIndex // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,peakBitrate: freezed == peakBitrate ? _self.peakBitrate : peakBitrate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoPlayerTrack].
extension VideoPlayerTrackPatterns on VideoPlayerTrack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoPlayerTrack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoPlayerTrack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoPlayerTrack value)  $default,){
final _that = this;
switch (_that) {
case _VideoPlayerTrack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoPlayerTrack value)?  $default,){
final _that = this;
switch (_that) {
case _VideoPlayerTrack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? label,  String? language,  String? title,  int? rendererIndex,  int? groupIndex,  int? trackIndex,  int? height,  int? width,  int? peakBitrate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoPlayerTrack() when $default != null:
return $default(_that.label,_that.language,_that.title,_that.rendererIndex,_that.groupIndex,_that.trackIndex,_that.height,_that.width,_that.peakBitrate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? label,  String? language,  String? title,  int? rendererIndex,  int? groupIndex,  int? trackIndex,  int? height,  int? width,  int? peakBitrate)  $default,) {final _that = this;
switch (_that) {
case _VideoPlayerTrack():
return $default(_that.label,_that.language,_that.title,_that.rendererIndex,_that.groupIndex,_that.trackIndex,_that.height,_that.width,_that.peakBitrate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? label,  String? language,  String? title,  int? rendererIndex,  int? groupIndex,  int? trackIndex,  int? height,  int? width,  int? peakBitrate)?  $default,) {final _that = this;
switch (_that) {
case _VideoPlayerTrack() when $default != null:
return $default(_that.label,_that.language,_that.title,_that.rendererIndex,_that.groupIndex,_that.trackIndex,_that.height,_that.width,_that.peakBitrate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _VideoPlayerTrack extends VideoPlayerTrack {
  const _VideoPlayerTrack({this.label, this.language, this.title, this.rendererIndex, this.groupIndex, this.trackIndex, this.height, this.width, this.peakBitrate}): super._();
  factory _VideoPlayerTrack.fromJson(Map<String, dynamic> json) => _$VideoPlayerTrackFromJson(json);

@override final  String? label;
@override final  String? language;
@override final  String? title;
@override final  int? rendererIndex;
@override final  int? groupIndex;
@override final  int? trackIndex;
@override final  int? height;
@override final  int? width;
@override final  int? peakBitrate;

/// Create a copy of VideoPlayerTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoPlayerTrackCopyWith<_VideoPlayerTrack> get copyWith => __$VideoPlayerTrackCopyWithImpl<_VideoPlayerTrack>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoPlayerTrack&&(identical(other.label, label) || other.label == label)&&(identical(other.language, language) || other.language == language)&&(identical(other.title, title) || other.title == title)&&(identical(other.rendererIndex, rendererIndex) || other.rendererIndex == rendererIndex)&&(identical(other.groupIndex, groupIndex) || other.groupIndex == groupIndex)&&(identical(other.trackIndex, trackIndex) || other.trackIndex == trackIndex)&&(identical(other.height, height) || other.height == height)&&(identical(other.width, width) || other.width == width)&&(identical(other.peakBitrate, peakBitrate) || other.peakBitrate == peakBitrate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,language,title,rendererIndex,groupIndex,trackIndex,height,width,peakBitrate);

@override
String toString() {
  return 'VideoPlayerTrack(label: $label, language: $language, title: $title, rendererIndex: $rendererIndex, groupIndex: $groupIndex, trackIndex: $trackIndex, height: $height, width: $width, peakBitrate: $peakBitrate)';
}


}

/// @nodoc
abstract mixin class _$VideoPlayerTrackCopyWith<$Res> implements $VideoPlayerTrackCopyWith<$Res> {
  factory _$VideoPlayerTrackCopyWith(_VideoPlayerTrack value, $Res Function(_VideoPlayerTrack) _then) = __$VideoPlayerTrackCopyWithImpl;
@override @useResult
$Res call({
 String? label, String? language, String? title, int? rendererIndex, int? groupIndex, int? trackIndex, int? height, int? width, int? peakBitrate
});




}
/// @nodoc
class __$VideoPlayerTrackCopyWithImpl<$Res>
    implements _$VideoPlayerTrackCopyWith<$Res> {
  __$VideoPlayerTrackCopyWithImpl(this._self, this._then);

  final _VideoPlayerTrack _self;
  final $Res Function(_VideoPlayerTrack) _then;

/// Create a copy of VideoPlayerTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = freezed,Object? language = freezed,Object? title = freezed,Object? rendererIndex = freezed,Object? groupIndex = freezed,Object? trackIndex = freezed,Object? height = freezed,Object? width = freezed,Object? peakBitrate = freezed,}) {
  return _then(_VideoPlayerTrack(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,rendererIndex: freezed == rendererIndex ? _self.rendererIndex : rendererIndex // ignore: cast_nullable_to_non_nullable
as int?,groupIndex: freezed == groupIndex ? _self.groupIndex : groupIndex // ignore: cast_nullable_to_non_nullable
as int?,trackIndex: freezed == trackIndex ? _self.trackIndex : trackIndex // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,peakBitrate: freezed == peakBitrate ? _self.peakBitrate : peakBitrate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
