// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.10.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'slicing.freezed.dart';
part 'slicing.g.dart';

// These functions are ignored because they are not marked as `pub`: `get_slice_bboxes`
// These types are ignored because they are neither used by any `pub` functions nor (for structs and enums) marked `#[frb(unignore)]`: `SliceData`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`, `fmt`, `fmt`

@freezed
sealed class SliceInputParams with _$SliceInputParams {
  const factory SliceInputParams({
    required int sliceWidth,
    required int sliceHeight,
    required double overlapWidthRatio,
    required double overlapHeightRatio,
  }) = _SliceInputParams;

  factory SliceInputParams.fromJson(Map<String, dynamic> json) =>
      _$SliceInputParamsFromJson(json);
}
