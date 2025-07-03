// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageData {

 int get imageWidth; int get imageHeight; List<YoloEntityOutput> get components;// @Default(0.3) double componentDetectionThreshold,
 double get benchmarkOverlapThreshold; List<YoloEntityOutput> get trackDefects; double get trackDefectDetectionThreshold; bool get tracksOnly;
/// Create a copy of ImageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageDataCopyWith<ImageData> get copyWith => _$ImageDataCopyWithImpl<ImageData>(this as ImageData, _$identity);

  /// Serializes this ImageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageData&&(identical(other.imageWidth, imageWidth) || other.imageWidth == imageWidth)&&(identical(other.imageHeight, imageHeight) || other.imageHeight == imageHeight)&&const DeepCollectionEquality().equals(other.components, components)&&(identical(other.benchmarkOverlapThreshold, benchmarkOverlapThreshold) || other.benchmarkOverlapThreshold == benchmarkOverlapThreshold)&&const DeepCollectionEquality().equals(other.trackDefects, trackDefects)&&(identical(other.trackDefectDetectionThreshold, trackDefectDetectionThreshold) || other.trackDefectDetectionThreshold == trackDefectDetectionThreshold)&&(identical(other.tracksOnly, tracksOnly) || other.tracksOnly == tracksOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageWidth,imageHeight,const DeepCollectionEquality().hash(components),benchmarkOverlapThreshold,const DeepCollectionEquality().hash(trackDefects),trackDefectDetectionThreshold,tracksOnly);



}

/// @nodoc
abstract mixin class $ImageDataCopyWith<$Res>  {
  factory $ImageDataCopyWith(ImageData value, $Res Function(ImageData) _then) = _$ImageDataCopyWithImpl;
@useResult
$Res call({
 int imageWidth, int imageHeight, List<YoloEntityOutput> components, double benchmarkOverlapThreshold, List<YoloEntityOutput> trackDefects, double trackDefectDetectionThreshold, bool tracksOnly
});




}
/// @nodoc
class _$ImageDataCopyWithImpl<$Res>
    implements $ImageDataCopyWith<$Res> {
  _$ImageDataCopyWithImpl(this._self, this._then);

  final ImageData _self;
  final $Res Function(ImageData) _then;

/// Create a copy of ImageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageWidth = null,Object? imageHeight = null,Object? components = null,Object? benchmarkOverlapThreshold = null,Object? trackDefects = null,Object? trackDefectDetectionThreshold = null,Object? tracksOnly = null,}) {
  return _then(_self.copyWith(
imageWidth: null == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int,imageHeight: null == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as List<YoloEntityOutput>,benchmarkOverlapThreshold: null == benchmarkOverlapThreshold ? _self.benchmarkOverlapThreshold : benchmarkOverlapThreshold // ignore: cast_nullable_to_non_nullable
as double,trackDefects: null == trackDefects ? _self.trackDefects : trackDefects // ignore: cast_nullable_to_non_nullable
as List<YoloEntityOutput>,trackDefectDetectionThreshold: null == trackDefectDetectionThreshold ? _self.trackDefectDetectionThreshold : trackDefectDetectionThreshold // ignore: cast_nullable_to_non_nullable
as double,tracksOnly: null == tracksOnly ? _self.tracksOnly : tracksOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ImageData extends ImageData {
   _ImageData({required this.imageWidth, required this.imageHeight, final  List<YoloEntityOutput> components = const [], this.benchmarkOverlapThreshold = 0.4, final  List<YoloEntityOutput> trackDefects = const [], this.trackDefectDetectionThreshold = 0.25, this.tracksOnly = false}): _components = components,_trackDefects = trackDefects,super._();
  factory _ImageData.fromJson(Map<String, dynamic> json) => _$ImageDataFromJson(json);

@override final  int imageWidth;
@override final  int imageHeight;
 final  List<YoloEntityOutput> _components;
@override@JsonKey() List<YoloEntityOutput> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}

// @Default(0.3) double componentDetectionThreshold,
@override@JsonKey() final  double benchmarkOverlapThreshold;
 final  List<YoloEntityOutput> _trackDefects;
@override@JsonKey() List<YoloEntityOutput> get trackDefects {
  if (_trackDefects is EqualUnmodifiableListView) return _trackDefects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trackDefects);
}

@override@JsonKey() final  double trackDefectDetectionThreshold;
@override@JsonKey() final  bool tracksOnly;

/// Create a copy of ImageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageDataCopyWith<_ImageData> get copyWith => __$ImageDataCopyWithImpl<_ImageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageData&&(identical(other.imageWidth, imageWidth) || other.imageWidth == imageWidth)&&(identical(other.imageHeight, imageHeight) || other.imageHeight == imageHeight)&&const DeepCollectionEquality().equals(other._components, _components)&&(identical(other.benchmarkOverlapThreshold, benchmarkOverlapThreshold) || other.benchmarkOverlapThreshold == benchmarkOverlapThreshold)&&const DeepCollectionEquality().equals(other._trackDefects, _trackDefects)&&(identical(other.trackDefectDetectionThreshold, trackDefectDetectionThreshold) || other.trackDefectDetectionThreshold == trackDefectDetectionThreshold)&&(identical(other.tracksOnly, tracksOnly) || other.tracksOnly == tracksOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageWidth,imageHeight,const DeepCollectionEquality().hash(_components),benchmarkOverlapThreshold,const DeepCollectionEquality().hash(_trackDefects),trackDefectDetectionThreshold,tracksOnly);



}

/// @nodoc
abstract mixin class _$ImageDataCopyWith<$Res> implements $ImageDataCopyWith<$Res> {
  factory _$ImageDataCopyWith(_ImageData value, $Res Function(_ImageData) _then) = __$ImageDataCopyWithImpl;
@override @useResult
$Res call({
 int imageWidth, int imageHeight, List<YoloEntityOutput> components, double benchmarkOverlapThreshold, List<YoloEntityOutput> trackDefects, double trackDefectDetectionThreshold, bool tracksOnly
});




}
/// @nodoc
class __$ImageDataCopyWithImpl<$Res>
    implements _$ImageDataCopyWith<$Res> {
  __$ImageDataCopyWithImpl(this._self, this._then);

  final _ImageData _self;
  final $Res Function(_ImageData) _then;

/// Create a copy of ImageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageWidth = null,Object? imageHeight = null,Object? components = null,Object? benchmarkOverlapThreshold = null,Object? trackDefects = null,Object? trackDefectDetectionThreshold = null,Object? tracksOnly = null,}) {
  return _then(_ImageData(
imageWidth: null == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int,imageHeight: null == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<YoloEntityOutput>,benchmarkOverlapThreshold: null == benchmarkOverlapThreshold ? _self.benchmarkOverlapThreshold : benchmarkOverlapThreshold // ignore: cast_nullable_to_non_nullable
as double,trackDefects: null == trackDefects ? _self._trackDefects : trackDefects // ignore: cast_nullable_to_non_nullable
as List<YoloEntityOutput>,trackDefectDetectionThreshold: null == trackDefectDetectionThreshold ? _self.trackDefectDetectionThreshold : trackDefectDetectionThreshold // ignore: cast_nullable_to_non_nullable
as double,tracksOnly: null == tracksOnly ? _self.tracksOnly : tracksOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BenchmarkImageData {

 int get imageWidth; int get imageHeight; List<YoloEntityOutput> get components; double get componentDetectionThreshold;
/// Create a copy of BenchmarkImageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BenchmarkImageDataCopyWith<BenchmarkImageData> get copyWith => _$BenchmarkImageDataCopyWithImpl<BenchmarkImageData>(this as BenchmarkImageData, _$identity);

  /// Serializes this BenchmarkImageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BenchmarkImageData&&(identical(other.imageWidth, imageWidth) || other.imageWidth == imageWidth)&&(identical(other.imageHeight, imageHeight) || other.imageHeight == imageHeight)&&const DeepCollectionEquality().equals(other.components, components)&&(identical(other.componentDetectionThreshold, componentDetectionThreshold) || other.componentDetectionThreshold == componentDetectionThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageWidth,imageHeight,const DeepCollectionEquality().hash(components),componentDetectionThreshold);



}

/// @nodoc
abstract mixin class $BenchmarkImageDataCopyWith<$Res>  {
  factory $BenchmarkImageDataCopyWith(BenchmarkImageData value, $Res Function(BenchmarkImageData) _then) = _$BenchmarkImageDataCopyWithImpl;
@useResult
$Res call({
 int imageWidth, int imageHeight, List<YoloEntityOutput> components, double componentDetectionThreshold
});




}
/// @nodoc
class _$BenchmarkImageDataCopyWithImpl<$Res>
    implements $BenchmarkImageDataCopyWith<$Res> {
  _$BenchmarkImageDataCopyWithImpl(this._self, this._then);

  final BenchmarkImageData _self;
  final $Res Function(BenchmarkImageData) _then;

/// Create a copy of BenchmarkImageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageWidth = null,Object? imageHeight = null,Object? components = null,Object? componentDetectionThreshold = null,}) {
  return _then(_self.copyWith(
imageWidth: null == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int,imageHeight: null == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as List<YoloEntityOutput>,componentDetectionThreshold: null == componentDetectionThreshold ? _self.componentDetectionThreshold : componentDetectionThreshold // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BenchmarkImageData extends BenchmarkImageData {
   _BenchmarkImageData({required this.imageWidth, required this.imageHeight, final  List<YoloEntityOutput> components = const [], this.componentDetectionThreshold = 0.3}): _components = components,super._();
  factory _BenchmarkImageData.fromJson(Map<String, dynamic> json) => _$BenchmarkImageDataFromJson(json);

@override final  int imageWidth;
@override final  int imageHeight;
 final  List<YoloEntityOutput> _components;
@override@JsonKey() List<YoloEntityOutput> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}

@override@JsonKey() final  double componentDetectionThreshold;

/// Create a copy of BenchmarkImageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BenchmarkImageDataCopyWith<_BenchmarkImageData> get copyWith => __$BenchmarkImageDataCopyWithImpl<_BenchmarkImageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BenchmarkImageDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BenchmarkImageData&&(identical(other.imageWidth, imageWidth) || other.imageWidth == imageWidth)&&(identical(other.imageHeight, imageHeight) || other.imageHeight == imageHeight)&&const DeepCollectionEquality().equals(other._components, _components)&&(identical(other.componentDetectionThreshold, componentDetectionThreshold) || other.componentDetectionThreshold == componentDetectionThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageWidth,imageHeight,const DeepCollectionEquality().hash(_components),componentDetectionThreshold);



}

/// @nodoc
abstract mixin class _$BenchmarkImageDataCopyWith<$Res> implements $BenchmarkImageDataCopyWith<$Res> {
  factory _$BenchmarkImageDataCopyWith(_BenchmarkImageData value, $Res Function(_BenchmarkImageData) _then) = __$BenchmarkImageDataCopyWithImpl;
@override @useResult
$Res call({
 int imageWidth, int imageHeight, List<YoloEntityOutput> components, double componentDetectionThreshold
});




}
/// @nodoc
class __$BenchmarkImageDataCopyWithImpl<$Res>
    implements _$BenchmarkImageDataCopyWith<$Res> {
  __$BenchmarkImageDataCopyWithImpl(this._self, this._then);

  final _BenchmarkImageData _self;
  final $Res Function(_BenchmarkImageData) _then;

/// Create a copy of BenchmarkImageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageWidth = null,Object? imageHeight = null,Object? components = null,Object? componentDetectionThreshold = null,}) {
  return _then(_BenchmarkImageData(
imageWidth: null == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int,imageHeight: null == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<YoloEntityOutput>,componentDetectionThreshold: null == componentDetectionThreshold ? _self.componentDetectionThreshold : componentDetectionThreshold // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
