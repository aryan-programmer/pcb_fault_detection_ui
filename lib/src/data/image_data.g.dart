// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageData _$ImageDataFromJson(Map<String, dynamic> json) => _ImageData(
  imageWidth: (json['imageWidth'] as num).toInt(),
  imageHeight: (json['imageHeight'] as num).toInt(),
  components:
      (json['components'] as List<dynamic>?)
          ?.map((e) => YoloEntityOutput.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  benchmarkOverlapThreshold:
      (json['benchmarkOverlapThreshold'] as num?)?.toDouble() ?? 0.1,
  trackDefects:
      (json['trackDefects'] as List<dynamic>?)
          ?.map((e) => YoloEntityOutput.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  trackDefectDetectionThreshold:
      (json['trackDefectDetectionThreshold'] as num?)?.toDouble() ?? 0.25,
  tracksOnly: json['tracksOnly'] as bool? ?? false,
);

Map<String, dynamic> _$ImageDataToJson(_ImageData instance) =>
    <String, dynamic>{
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
      'components': instance.components,
      'benchmarkOverlapThreshold': instance.benchmarkOverlapThreshold,
      'trackDefects': instance.trackDefects,
      'trackDefectDetectionThreshold': instance.trackDefectDetectionThreshold,
      'tracksOnly': instance.tracksOnly,
    };

_BenchmarkImageData _$BenchmarkImageDataFromJson(Map<String, dynamic> json) =>
    _BenchmarkImageData(
      imageWidth: (json['imageWidth'] as num).toInt(),
      imageHeight: (json['imageHeight'] as num).toInt(),
      components:
          (json['components'] as List<dynamic>?)
              ?.map((e) => YoloEntityOutput.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      componentDetectionThreshold:
          (json['componentDetectionThreshold'] as num?)?.toDouble() ?? 0.3,
    );

Map<String, dynamic> _$BenchmarkImageDataToJson(_BenchmarkImageData instance) =>
    <String, dynamic>{
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
      'components': instance.components,
      'componentDetectionThreshold': instance.componentDetectionThreshold,
    };
