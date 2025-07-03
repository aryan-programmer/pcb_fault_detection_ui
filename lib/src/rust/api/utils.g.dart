// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoundingBox _$BoundingBoxFromJson(Map<String, dynamic> json) => _BoundingBox(
  x1: (json['x1'] as num).toInt(),
  y1: (json['y1'] as num).toInt(),
  x2: (json['x2'] as num).toInt(),
  y2: (json['y2'] as num).toInt(),
);

Map<String, dynamic> _$BoundingBoxToJson(_BoundingBox instance) =>
    <String, dynamic>{
      'x1': instance.x1,
      'y1': instance.y1,
      'x2': instance.x2,
      'y2': instance.y2,
    };

_YoloEntityOutput _$YoloEntityOutputFromJson(Map<String, dynamic> json) =>
    _YoloEntityOutput(
      boundingBox: BoundingBox.fromJson(
        json['boundingBox'] as Map<String, dynamic>,
      ),
      classId: (json['classId'] as num).toInt(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$YoloEntityOutputToJson(_YoloEntityOutput instance) =>
    <String, dynamic>{
      'boundingBox': instance.boundingBox,
      'classId': instance.classId,
      'confidence': instance.confidence,
    };
