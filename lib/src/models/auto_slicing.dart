import 'dart:developer';
import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/slicing.dart';

part 'auto_slicing.freezed.dart';
part 'auto_slicing.g.dart';

@freezed
sealed class ModelInferenceParameters with _$ModelInferenceParameters {
  factory ModelInferenceParameters({
    required bool keepOriginal,
    required List<SliceInputParams> sliceOptions,
  }) = _ModelInferenceParameters;

  factory ModelInferenceParameters.fromJson(Map<String, dynamic> json) =>
      _$ModelInferenceParametersFromJson(json);

  /// Get slice parameters for resolution category
  static ModelInferenceParameters _getSliceParams(
    Resolution resolution, {
    required double minLength,
    required double sampleLength,
  }) {
    switch (resolution) {
      case Resolution.veryLow:
        int sliceSize = math.min(minLength, 640.0).toInt();
        return ModelInferenceParameters(
          keepOriginal: true,
          sliceOptions: [
            SliceInputParams(
              sliceWidth: sliceSize,
              sliceHeight: sliceSize,
              overlapWidthRatio: 0.0,
              overlapHeightRatio: 0.0,
            ),
          ],
        );
      case Resolution.low:
        int sliceSize1 = math.min(minLength ~/ 2, 640);
        return ModelInferenceParameters(
          keepOriginal: true,
          sliceOptions: [
            SliceInputParams(
              sliceWidth: sliceSize1,
              sliceHeight: sliceSize1,
              overlapWidthRatio: 0.25,
              overlapHeightRatio: 0.25,
            ),
          ],
        );
      case Resolution.medium:
        int sliceSize1 = math.min(minLength ~/ 2.5, 640);
        int sliceSize2 = sampleLength ~/ 1.5;
        return ModelInferenceParameters(
          keepOriginal: true,
          sliceOptions: [
            SliceInputParams(
              sliceWidth: sliceSize1,
              sliceHeight: sliceSize1,
              overlapWidthRatio: 0.2,
              overlapHeightRatio: 0.2,
            ),
            SliceInputParams(
              sliceWidth: sliceSize2,
              sliceHeight: sliceSize2,
              overlapWidthRatio: 0.15,
              overlapHeightRatio: 0.15,
            ),
          ],
        );
      case Resolution.high:
        int sliceSize1 = sampleLength ~/ 3.5;
        return ModelInferenceParameters(
          keepOriginal: true,
          sliceOptions: [
            SliceInputParams(
              sliceWidth: sliceSize1,
              sliceHeight: sliceSize1,
              overlapWidthRatio: 0.175,
              overlapHeightRatio: 0.175,
            ),
          ],
        );
      case Resolution.ultraHigh:
        int sliceSize1 = sampleLength ~/ 4;
        return ModelInferenceParameters(
          keepOriginal: false,
          sliceOptions: [
            SliceInputParams(
              sliceWidth: sliceSize1,
              sliceHeight: sliceSize1,
              overlapWidthRatio: 0.15,
              overlapHeightRatio: 0.15,
            ),
          ],
        );
    }
  }

  static ModelInferenceParameters calculateModelParams(int width, int height) {
    // Input validation
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be positive');
    }

    // Geometric mean of width 7 weight
    final sampleLength = math.sqrt(width * height);

    return _getSliceParams(
      Resolution.fromSize(width, height),
      sampleLength: sampleLength,
      minLength: math.min(width, height).toDouble(),
    );
  }
}

/// Represents different resolution categories for automatic slice parameter calculation
enum Resolution {
  veryLow,
  low,
  medium,
  high,
  ultraHigh;

  /// Calculate the resolution factor (power of 2) for an image
  static int calcResolutionFactor(int resolution) {
    if (resolution <= 0) return 0;
    return math.max(0, resolution.bitLength);
  }

  /// Get resolution category from factor efficiently
  static Resolution fromSize(int width, int height) {
    if (width <= 640 || height <= 640) return Resolution.veryLow;
    int resolution = width * height;
    int factor = calcResolutionFactor(resolution);
    log("Resolution factor: $width*$height=$resolution -> $factor");
    if (factor <= 19) return Resolution.low;
    if (factor <= 22) return Resolution.medium;
    if (factor <= 24) return Resolution.high;
    return Resolution.ultraHigh;
  }
}
