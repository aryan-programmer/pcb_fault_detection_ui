import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pcb_fault_detection_ui/src/data/component_classes.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';

class AnnotatedImage extends StatelessWidget {
  final String imagePath;
  final int imageWidth;
  final int imageHeight;
  final double thresholdRed;
  final double thresholdBlue;
  final double? boxWidthOverride;
  final List<YoloEntityOutput>? boxesRed;
  final List<YoloEntityOutput>? boxesBlue;
  final Map<int, ResultClass> intToComponent;
  final void Function(YoloEntityOutput)? onRemoveRed;
  final void Function(YoloEntityOutput)? onRemoveBlue;

  const AnnotatedImage({
    super.key,
    required this.imagePath,
    this.boxesRed,
    this.boxesBlue,
    required this.imageWidth,
    required this.imageHeight,
    required this.thresholdRed,
    required this.thresholdBlue,
    required this.intToComponent,
    this.onRemoveRed,
    this.onRemoveBlue,
    this.boxWidthOverride,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth.toDouble(),
      height: imageHeight.toDouble(),
      child: Stack(
        children: [
          ExtendedImage.file(
            File(imagePath),
            width: imageWidth.toDouble(),
            height: imageHeight.toDouble(),
          ),
          ...?boxesRed?.expand(
            (box) => displayBox(
              box: box,
              color: Colors.redAccent,
              threshold: thresholdRed,
              onRemoved: onRemoveRed,
            ),
          ),
          ...?boxesBlue?.expand(
            (box) => displayBox(
              box: box,
              color: Colors.purpleAccent,
              threshold: thresholdBlue,
              onRemoved: onRemoveBlue,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> displayBox({
    required YoloEntityOutput box,
    required Color color,
    required double threshold,
    required void Function(YoloEntityOutput)? onRemoved,
  }) {
    final bw = (box.boundingBox.x2 - box.boundingBox.x1).toDouble();
    final bh = (box.boundingBox.y2 - box.boundingBox.y1).toDouble();
    final bx = (box.boundingBox.x1).toDouble();
    final by = (box.boundingBox.y1).toDouble();
    if (box.confidence < threshold) {
      return [];
    }
    final resultClass = intToComponent[box.classId];
    final className = resultClass?.name;
    final confidencePercentage = (box.confidence * 100).round().clamp(0, 100);
    final tooltipMessage = className == null
        ? "$confidencePercentage%"
        : "$className: $confidencePercentage%";
    final width =
        boxWidthOverride ?? ((0.5 + box.confidence.clamp(0, 1)) * 3.0);
    final padding = width;
    return [
      Positioned(
        key: ValueKey((imagePath, color, box)),
        left: bx - padding,
        top: by - padding,
        width: bw + padding * 2,
        height: bh + padding * 2,
        child: Tooltip(
          message: tooltipMessage,
          child: Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: color, width: width),
            ),
            child: InkWell(
              onLongPress: onRemoved == null ? () {} : () => onRemoved(box),
            ),
          ),
        ),
      ),
    ];
  }
}
