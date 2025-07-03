// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slicing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SliceInputParams _$SliceInputParamsFromJson(Map<String, dynamic> json) =>
    _SliceInputParams(
      sliceWidth: (json['sliceWidth'] as num).toInt(),
      sliceHeight: (json['sliceHeight'] as num).toInt(),
      overlapWidthRatio: (json['overlapWidthRatio'] as num).toDouble(),
      overlapHeightRatio: (json['overlapHeightRatio'] as num).toDouble(),
    );

Map<String, dynamic> _$SliceInputParamsToJson(_SliceInputParams instance) =>
    <String, dynamic>{
      'sliceWidth': instance.sliceWidth,
      'sliceHeight': instance.sliceHeight,
      'overlapWidthRatio': instance.overlapWidthRatio,
      'overlapHeightRatio': instance.overlapHeightRatio,
    };
