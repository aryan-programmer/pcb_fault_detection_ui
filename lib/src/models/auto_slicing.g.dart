// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_slicing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModelInferenceParameters _$ModelInferenceParametersFromJson(
  Map<String, dynamic> json,
) => _ModelInferenceParameters(
  keepOriginal: json['keepOriginal'] as bool,
  sliceOptions: (json['sliceOptions'] as List<dynamic>)
      .map((e) => SliceInputParams.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ModelInferenceParametersToJson(
  _ModelInferenceParameters instance,
) => <String, dynamic>{
  'keepOriginal': instance.keepOriginal,
  'sliceOptions': instance.sliceOptions,
};
