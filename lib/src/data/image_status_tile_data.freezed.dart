// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_status_tile_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageStatusTileData {

 ImageStatus get status; String get statusString;
/// Create a copy of ImageStatusTileData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageStatusTileDataCopyWith<ImageStatusTileData> get copyWith => _$ImageStatusTileDataCopyWithImpl<ImageStatusTileData>(this as ImageStatusTileData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageStatusTileData&&(identical(other.status, status) || other.status == status)&&(identical(other.statusString, statusString) || other.statusString == statusString));
}


@override
int get hashCode => Object.hash(runtimeType,status,statusString);

@override
String toString() {
  return 'ImageStatusTileData(status: $status, statusString: $statusString)';
}


}

/// @nodoc
abstract mixin class $ImageStatusTileDataCopyWith<$Res>  {
  factory $ImageStatusTileDataCopyWith(ImageStatusTileData value, $Res Function(ImageStatusTileData) _then) = _$ImageStatusTileDataCopyWithImpl;
@useResult
$Res call({
 ImageStatus status, String statusString
});




}
/// @nodoc
class _$ImageStatusTileDataCopyWithImpl<$Res>
    implements $ImageStatusTileDataCopyWith<$Res> {
  _$ImageStatusTileDataCopyWithImpl(this._self, this._then);

  final ImageStatusTileData _self;
  final $Res Function(ImageStatusTileData) _then;

/// Create a copy of ImageStatusTileData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? statusString = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImageStatus,statusString: null == statusString ? _self.statusString : statusString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _ImageStatusTileData extends ImageStatusTileData {
   _ImageStatusTileData({required this.status, required this.statusString}): super._();
  

@override final  ImageStatus status;
@override final  String statusString;

/// Create a copy of ImageStatusTileData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageStatusTileDataCopyWith<_ImageStatusTileData> get copyWith => __$ImageStatusTileDataCopyWithImpl<_ImageStatusTileData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageStatusTileData&&(identical(other.status, status) || other.status == status)&&(identical(other.statusString, statusString) || other.statusString == statusString));
}


@override
int get hashCode => Object.hash(runtimeType,status,statusString);

@override
String toString() {
  return 'ImageStatusTileData(status: $status, statusString: $statusString)';
}


}

/// @nodoc
abstract mixin class _$ImageStatusTileDataCopyWith<$Res> implements $ImageStatusTileDataCopyWith<$Res> {
  factory _$ImageStatusTileDataCopyWith(_ImageStatusTileData value, $Res Function(_ImageStatusTileData) _then) = __$ImageStatusTileDataCopyWithImpl;
@override @useResult
$Res call({
 ImageStatus status, String statusString
});




}
/// @nodoc
class __$ImageStatusTileDataCopyWithImpl<$Res>
    implements _$ImageStatusTileDataCopyWith<$Res> {
  __$ImageStatusTileDataCopyWithImpl(this._self, this._then);

  final _ImageStatusTileData _self;
  final $Res Function(_ImageStatusTileData) _then;

/// Create a copy of ImageStatusTileData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? statusString = null,}) {
  return _then(_ImageStatusTileData(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImageStatus,statusString: null == statusString ? _self.statusString : statusString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
