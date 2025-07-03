// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slicing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SliceInputParams {

 int get sliceWidth; int get sliceHeight; double get overlapWidthRatio; double get overlapHeightRatio;
/// Create a copy of SliceInputParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SliceInputParamsCopyWith<SliceInputParams> get copyWith => _$SliceInputParamsCopyWithImpl<SliceInputParams>(this as SliceInputParams, _$identity);

  /// Serializes this SliceInputParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SliceInputParams&&(identical(other.sliceWidth, sliceWidth) || other.sliceWidth == sliceWidth)&&(identical(other.sliceHeight, sliceHeight) || other.sliceHeight == sliceHeight)&&(identical(other.overlapWidthRatio, overlapWidthRatio) || other.overlapWidthRatio == overlapWidthRatio)&&(identical(other.overlapHeightRatio, overlapHeightRatio) || other.overlapHeightRatio == overlapHeightRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sliceWidth,sliceHeight,overlapWidthRatio,overlapHeightRatio);

@override
String toString() {
  return 'SliceInputParams(sliceWidth: $sliceWidth, sliceHeight: $sliceHeight, overlapWidthRatio: $overlapWidthRatio, overlapHeightRatio: $overlapHeightRatio)';
}


}

/// @nodoc
abstract mixin class $SliceInputParamsCopyWith<$Res>  {
  factory $SliceInputParamsCopyWith(SliceInputParams value, $Res Function(SliceInputParams) _then) = _$SliceInputParamsCopyWithImpl;
@useResult
$Res call({
 int sliceWidth, int sliceHeight, double overlapWidthRatio, double overlapHeightRatio
});




}
/// @nodoc
class _$SliceInputParamsCopyWithImpl<$Res>
    implements $SliceInputParamsCopyWith<$Res> {
  _$SliceInputParamsCopyWithImpl(this._self, this._then);

  final SliceInputParams _self;
  final $Res Function(SliceInputParams) _then;

/// Create a copy of SliceInputParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sliceWidth = null,Object? sliceHeight = null,Object? overlapWidthRatio = null,Object? overlapHeightRatio = null,}) {
  return _then(_self.copyWith(
sliceWidth: null == sliceWidth ? _self.sliceWidth : sliceWidth // ignore: cast_nullable_to_non_nullable
as int,sliceHeight: null == sliceHeight ? _self.sliceHeight : sliceHeight // ignore: cast_nullable_to_non_nullable
as int,overlapWidthRatio: null == overlapWidthRatio ? _self.overlapWidthRatio : overlapWidthRatio // ignore: cast_nullable_to_non_nullable
as double,overlapHeightRatio: null == overlapHeightRatio ? _self.overlapHeightRatio : overlapHeightRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SliceInputParams implements SliceInputParams {
  const _SliceInputParams({required this.sliceWidth, required this.sliceHeight, required this.overlapWidthRatio, required this.overlapHeightRatio});
  factory _SliceInputParams.fromJson(Map<String, dynamic> json) => _$SliceInputParamsFromJson(json);

@override final  int sliceWidth;
@override final  int sliceHeight;
@override final  double overlapWidthRatio;
@override final  double overlapHeightRatio;

/// Create a copy of SliceInputParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SliceInputParamsCopyWith<_SliceInputParams> get copyWith => __$SliceInputParamsCopyWithImpl<_SliceInputParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SliceInputParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SliceInputParams&&(identical(other.sliceWidth, sliceWidth) || other.sliceWidth == sliceWidth)&&(identical(other.sliceHeight, sliceHeight) || other.sliceHeight == sliceHeight)&&(identical(other.overlapWidthRatio, overlapWidthRatio) || other.overlapWidthRatio == overlapWidthRatio)&&(identical(other.overlapHeightRatio, overlapHeightRatio) || other.overlapHeightRatio == overlapHeightRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sliceWidth,sliceHeight,overlapWidthRatio,overlapHeightRatio);

@override
String toString() {
  return 'SliceInputParams(sliceWidth: $sliceWidth, sliceHeight: $sliceHeight, overlapWidthRatio: $overlapWidthRatio, overlapHeightRatio: $overlapHeightRatio)';
}


}

/// @nodoc
abstract mixin class _$SliceInputParamsCopyWith<$Res> implements $SliceInputParamsCopyWith<$Res> {
  factory _$SliceInputParamsCopyWith(_SliceInputParams value, $Res Function(_SliceInputParams) _then) = __$SliceInputParamsCopyWithImpl;
@override @useResult
$Res call({
 int sliceWidth, int sliceHeight, double overlapWidthRatio, double overlapHeightRatio
});




}
/// @nodoc
class __$SliceInputParamsCopyWithImpl<$Res>
    implements _$SliceInputParamsCopyWith<$Res> {
  __$SliceInputParamsCopyWithImpl(this._self, this._then);

  final _SliceInputParams _self;
  final $Res Function(_SliceInputParams) _then;

/// Create a copy of SliceInputParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sliceWidth = null,Object? sliceHeight = null,Object? overlapWidthRatio = null,Object? overlapHeightRatio = null,}) {
  return _then(_SliceInputParams(
sliceWidth: null == sliceWidth ? _self.sliceWidth : sliceWidth // ignore: cast_nullable_to_non_nullable
as int,sliceHeight: null == sliceHeight ? _self.sliceHeight : sliceHeight // ignore: cast_nullable_to_non_nullable
as int,overlapWidthRatio: null == overlapWidthRatio ? _self.overlapWidthRatio : overlapWidthRatio // ignore: cast_nullable_to_non_nullable
as double,overlapHeightRatio: null == overlapHeightRatio ? _self.overlapHeightRatio : overlapHeightRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
