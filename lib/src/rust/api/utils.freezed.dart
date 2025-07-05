// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'utils.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoundingBox {

 double get x1; double get y1; double get x2; double get y2;
/// Create a copy of BoundingBox
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoundingBoxCopyWith<BoundingBox> get copyWith => _$BoundingBoxCopyWithImpl<BoundingBox>(this as BoundingBox, _$identity);

  /// Serializes this BoundingBox to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoundingBox&&(identical(other.x1, x1) || other.x1 == x1)&&(identical(other.y1, y1) || other.y1 == y1)&&(identical(other.x2, x2) || other.x2 == x2)&&(identical(other.y2, y2) || other.y2 == y2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x1,y1,x2,y2);

@override
String toString() {
  return 'BoundingBox(x1: $x1, y1: $y1, x2: $x2, y2: $y2)';
}


}

/// @nodoc
abstract mixin class $BoundingBoxCopyWith<$Res>  {
  factory $BoundingBoxCopyWith(BoundingBox value, $Res Function(BoundingBox) _then) = _$BoundingBoxCopyWithImpl;
@useResult
$Res call({
 double x1, double y1, double x2, double y2
});




}
/// @nodoc
class _$BoundingBoxCopyWithImpl<$Res>
    implements $BoundingBoxCopyWith<$Res> {
  _$BoundingBoxCopyWithImpl(this._self, this._then);

  final BoundingBox _self;
  final $Res Function(BoundingBox) _then;

/// Create a copy of BoundingBox
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x1 = null,Object? y1 = null,Object? x2 = null,Object? y2 = null,}) {
  return _then(_self.copyWith(
x1: null == x1 ? _self.x1 : x1 // ignore: cast_nullable_to_non_nullable
as double,y1: null == y1 ? _self.y1 : y1 // ignore: cast_nullable_to_non_nullable
as double,x2: null == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as double,y2: null == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BoundingBox extends BoundingBox {
  const _BoundingBox({required this.x1, required this.y1, required this.x2, required this.y2}): super._();
  factory _BoundingBox.fromJson(Map<String, dynamic> json) => _$BoundingBoxFromJson(json);

@override final  double x1;
@override final  double y1;
@override final  double x2;
@override final  double y2;

/// Create a copy of BoundingBox
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoundingBoxCopyWith<_BoundingBox> get copyWith => __$BoundingBoxCopyWithImpl<_BoundingBox>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoundingBoxToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoundingBox&&(identical(other.x1, x1) || other.x1 == x1)&&(identical(other.y1, y1) || other.y1 == y1)&&(identical(other.x2, x2) || other.x2 == x2)&&(identical(other.y2, y2) || other.y2 == y2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x1,y1,x2,y2);

@override
String toString() {
  return 'BoundingBox.raw(x1: $x1, y1: $y1, x2: $x2, y2: $y2)';
}


}

/// @nodoc
abstract mixin class _$BoundingBoxCopyWith<$Res> implements $BoundingBoxCopyWith<$Res> {
  factory _$BoundingBoxCopyWith(_BoundingBox value, $Res Function(_BoundingBox) _then) = __$BoundingBoxCopyWithImpl;
@override @useResult
$Res call({
 double x1, double y1, double x2, double y2
});




}
/// @nodoc
class __$BoundingBoxCopyWithImpl<$Res>
    implements _$BoundingBoxCopyWith<$Res> {
  __$BoundingBoxCopyWithImpl(this._self, this._then);

  final _BoundingBox _self;
  final $Res Function(_BoundingBox) _then;

/// Create a copy of BoundingBox
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x1 = null,Object? y1 = null,Object? x2 = null,Object? y2 = null,}) {
  return _then(_BoundingBox(
x1: null == x1 ? _self.x1 : x1 // ignore: cast_nullable_to_non_nullable
as double,y1: null == y1 ? _self.y1 : y1 // ignore: cast_nullable_to_non_nullable
as double,x2: null == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as double,y2: null == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$YoloEntityOutput {

 BoundingBox get boundingBox; int get classId; double get confidence;
/// Create a copy of YoloEntityOutput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YoloEntityOutputCopyWith<YoloEntityOutput> get copyWith => _$YoloEntityOutputCopyWithImpl<YoloEntityOutput>(this as YoloEntityOutput, _$identity);

  /// Serializes this YoloEntityOutput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoloEntityOutput&&(identical(other.boundingBox, boundingBox) || other.boundingBox == boundingBox)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boundingBox,classId,confidence);

@override
String toString() {
  return 'YoloEntityOutput(boundingBox: $boundingBox, classId: $classId, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $YoloEntityOutputCopyWith<$Res>  {
  factory $YoloEntityOutputCopyWith(YoloEntityOutput value, $Res Function(YoloEntityOutput) _then) = _$YoloEntityOutputCopyWithImpl;
@useResult
$Res call({
 BoundingBox boundingBox, int classId, double confidence
});


$BoundingBoxCopyWith<$Res> get boundingBox;

}
/// @nodoc
class _$YoloEntityOutputCopyWithImpl<$Res>
    implements $YoloEntityOutputCopyWith<$Res> {
  _$YoloEntityOutputCopyWithImpl(this._self, this._then);

  final YoloEntityOutput _self;
  final $Res Function(YoloEntityOutput) _then;

/// Create a copy of YoloEntityOutput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? boundingBox = null,Object? classId = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
boundingBox: null == boundingBox ? _self.boundingBox : boundingBox // ignore: cast_nullable_to_non_nullable
as BoundingBox,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of YoloEntityOutput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoundingBoxCopyWith<$Res> get boundingBox {
  
  return $BoundingBoxCopyWith<$Res>(_self.boundingBox, (value) {
    return _then(_self.copyWith(boundingBox: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _YoloEntityOutput implements YoloEntityOutput {
  const _YoloEntityOutput({required this.boundingBox, required this.classId, required this.confidence});
  factory _YoloEntityOutput.fromJson(Map<String, dynamic> json) => _$YoloEntityOutputFromJson(json);

@override final  BoundingBox boundingBox;
@override final  int classId;
@override final  double confidence;

/// Create a copy of YoloEntityOutput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YoloEntityOutputCopyWith<_YoloEntityOutput> get copyWith => __$YoloEntityOutputCopyWithImpl<_YoloEntityOutput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YoloEntityOutputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YoloEntityOutput&&(identical(other.boundingBox, boundingBox) || other.boundingBox == boundingBox)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boundingBox,classId,confidence);

@override
String toString() {
  return 'YoloEntityOutput(boundingBox: $boundingBox, classId: $classId, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$YoloEntityOutputCopyWith<$Res> implements $YoloEntityOutputCopyWith<$Res> {
  factory _$YoloEntityOutputCopyWith(_YoloEntityOutput value, $Res Function(_YoloEntityOutput) _then) = __$YoloEntityOutputCopyWithImpl;
@override @useResult
$Res call({
 BoundingBox boundingBox, int classId, double confidence
});


@override $BoundingBoxCopyWith<$Res> get boundingBox;

}
/// @nodoc
class __$YoloEntityOutputCopyWithImpl<$Res>
    implements _$YoloEntityOutputCopyWith<$Res> {
  __$YoloEntityOutputCopyWithImpl(this._self, this._then);

  final _YoloEntityOutput _self;
  final $Res Function(_YoloEntityOutput) _then;

/// Create a copy of YoloEntityOutput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? boundingBox = null,Object? classId = null,Object? confidence = null,}) {
  return _then(_YoloEntityOutput(
boundingBox: null == boundingBox ? _self.boundingBox : boundingBox // ignore: cast_nullable_to_non_nullable
as BoundingBox,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of YoloEntityOutput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoundingBoxCopyWith<$Res> get boundingBox {
  
  return $BoundingBoxCopyWith<$Res>(_self.boundingBox, (value) {
    return _then(_self.copyWith(boundingBox: value));
  });
}
}

// dart format on
