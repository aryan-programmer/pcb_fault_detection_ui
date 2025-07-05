import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_status_tile_data.freezed.dart';

enum ImageStatus {
  Unchecked,
  Faulty,
  Ok;

  (IconData, Color) get iconDataAndColor {
    late IconData trailingIcon;
    late Color tileColor;
    switch (this) {
      case ImageStatus.Unchecked:
        trailingIcon = Icons.warning_amber;
        tileColor = Colors.amberAccent[100]!;
      case ImageStatus.Faulty:
        trailingIcon = Icons.error;
        tileColor = Colors.redAccent[100]!;
      case ImageStatus.Ok:
        trailingIcon = Icons.check;
        tileColor = Colors.greenAccent[100]!;
    }
    return (trailingIcon, tileColor);
  }
}

@freezed
sealed class ImageStatusTileData with _$ImageStatusTileData {
  ImageStatusTileData._();

  factory ImageStatusTileData({
    required ImageStatus status,
    required String statusString,
  }) = _ImageStatusTileData;
}
