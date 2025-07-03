// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_slicing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModelInferenceParameters {

 bool get keepOriginal; List<SliceInputParams> get sliceOptions;
/// Create a copy of ModelInferenceParameters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelInferenceParametersCopyWith<ModelInferenceParameters> get copyWith => _$ModelInferenceParametersCopyWithImpl<ModelInferenceParameters>(this as ModelInferenceParameters, _$identity);

  /// Serializes this ModelInferenceParameters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelInferenceParameters&&(identical(other.keepOriginal, keepOriginal) || other.keepOriginal == keepOriginal)&&const DeepCollectionEquality().equals(other.sliceOptions, sliceOptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keepOriginal,const DeepCollectionEquality().hash(sliceOptions));

@override
String toString() {
  return 'ModelInferenceParameters(keepOriginal: $keepOriginal, sliceOptions: $sliceOptions)';
}


}

/// @nodoc
abstract mixin class $ModelInferenceParametersCopyWith<$Res>  {
  factory $ModelInferenceParametersCopyWith(ModelInferenceParameters value, $Res Function(ModelInferenceParameters) _then) = _$ModelInferenceParametersCopyWithImpl;
@useResult
$Res call({
 bool keepOriginal, List<SliceInputParams> sliceOptions
});




}
/// @nodoc
class _$ModelInferenceParametersCopyWithImpl<$Res>
    implements $ModelInferenceParametersCopyWith<$Res> {
  _$ModelInferenceParametersCopyWithImpl(this._self, this._then);

  final ModelInferenceParameters _self;
  final $Res Function(ModelInferenceParameters) _then;

/// Create a copy of ModelInferenceParameters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keepOriginal = null,Object? sliceOptions = null,}) {
  return _then(_self.copyWith(
keepOriginal: null == keepOriginal ? _self.keepOriginal : keepOriginal // ignore: cast_nullable_to_non_nullable
as bool,sliceOptions: null == sliceOptions ? _self.sliceOptions : sliceOptions // ignore: cast_nullable_to_non_nullable
as List<SliceInputParams>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ModelInferenceParameters implements ModelInferenceParameters {
   _ModelInferenceParameters({required this.keepOriginal, required final  List<SliceInputParams> sliceOptions}): _sliceOptions = sliceOptions;
  factory _ModelInferenceParameters.fromJson(Map<String, dynamic> json) => _$ModelInferenceParametersFromJson(json);

@override final  bool keepOriginal;
 final  List<SliceInputParams> _sliceOptions;
@override List<SliceInputParams> get sliceOptions {
  if (_sliceOptions is EqualUnmodifiableListView) return _sliceOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sliceOptions);
}


/// Create a copy of ModelInferenceParameters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelInferenceParametersCopyWith<_ModelInferenceParameters> get copyWith => __$ModelInferenceParametersCopyWithImpl<_ModelInferenceParameters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelInferenceParametersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelInferenceParameters&&(identical(other.keepOriginal, keepOriginal) || other.keepOriginal == keepOriginal)&&const DeepCollectionEquality().equals(other._sliceOptions, _sliceOptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keepOriginal,const DeepCollectionEquality().hash(_sliceOptions));

@override
String toString() {
  return 'ModelInferenceParameters(keepOriginal: $keepOriginal, sliceOptions: $sliceOptions)';
}


}

/// @nodoc
abstract mixin class _$ModelInferenceParametersCopyWith<$Res> implements $ModelInferenceParametersCopyWith<$Res> {
  factory _$ModelInferenceParametersCopyWith(_ModelInferenceParameters value, $Res Function(_ModelInferenceParameters) _then) = __$ModelInferenceParametersCopyWithImpl;
@override @useResult
$Res call({
 bool keepOriginal, List<SliceInputParams> sliceOptions
});




}
/// @nodoc
class __$ModelInferenceParametersCopyWithImpl<$Res>
    implements _$ModelInferenceParametersCopyWith<$Res> {
  __$ModelInferenceParametersCopyWithImpl(this._self, this._then);

  final _ModelInferenceParameters _self;
  final $Res Function(_ModelInferenceParameters) _then;

/// Create a copy of ModelInferenceParameters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keepOriginal = null,Object? sliceOptions = null,}) {
  return _then(_ModelInferenceParameters(
keepOriginal: null == keepOriginal ? _self.keepOriginal : keepOriginal // ignore: cast_nullable_to_non_nullable
as bool,sliceOptions: null == sliceOptions ? _self._sliceOptions : sliceOptions // ignore: cast_nullable_to_non_nullable
as List<SliceInputParams>,
  ));
}


}

// dart format on
