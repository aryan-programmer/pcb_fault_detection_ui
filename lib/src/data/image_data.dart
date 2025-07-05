// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';

part 'image_data.freezed.dart';
part 'image_data.g.dart';

@freezed
sealed class ImageData with _$ImageData {
  ImageData._();

  factory ImageData({
    required int imageWidth,
    required int imageHeight,
    @Default([]) List<YoloEntityOutput> components,
    // @Default(0.3) double componentDetectionThreshold,
    @Default(0.1) double benchmarkOverlapThreshold,
    @Default([]) List<YoloEntityOutput> trackDefects,
    @Default(0.25) double trackDefectDetectionThreshold,
    @Default(false) bool tracksOnly,
  }) = _ImageData;

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // componentDetectionThreshold: $componentDetectionThreshold,
    return '''ImageData(
  imageWidth: $imageWidth, 
  imageHeight: $imageHeight, 
  components: [List of size ${components.length}], 
  benchmarkOverlapThreshold: $benchmarkOverlapThreshold,
  trackDefects: [List of size ${trackDefects.length}], 
  trackDefectDetectionThreshold: $trackDefectDetectionThreshold,
)''';
  }
}

@freezed
sealed class BenchmarkImageData with _$BenchmarkImageData {
  const BenchmarkImageData._();

  factory BenchmarkImageData({
    required int imageWidth,
    required int imageHeight,
    @Default([]) List<YoloEntityOutput> components,
    @Default(0.3) double componentDetectionThreshold,
  }) = _BenchmarkImageData;

  factory BenchmarkImageData.fromJson(Map<String, dynamic> json) =>
      _$BenchmarkImageDataFromJson(json);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BenchmarkImageData(imageWidth: $imageWidth, imageHeight: $imageHeight, components: [List of size ${components.length}], componentDetectionThreshold: $componentDetectionThreshold)';
  }
}
