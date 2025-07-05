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
  final double minBoxWidth;
  final double maxBoxWidth;
  late final double boxWidthDiff;
  final List<YoloEntityOutput>? boxesRed;
  final List<YoloEntityOutput>? boxesBlue;
  final Map<int, ResultClass> intToComponent;
  final void Function(YoloEntityOutput)? onRemoveRed;
  final void Function(YoloEntityOutput)? onRemoveBlue;

  AnnotatedImage({
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
    double? minBoxWidth,
    double? maxBoxWidth,
  }) : minBoxWidth = minBoxWidth ?? 2,
       maxBoxWidth = maxBoxWidth ?? 6 {
    boxWidthDiff = this.maxBoxWidth - this.minBoxWidth;
  }

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
          ...?boxesRed
              ?.take(1000)
              .expand(
                (box) => displayBox(
                  box: box,
                  color: Colors.redAccent,
                  threshold: thresholdRed,
                  onRemoved: onRemoveRed,
                ),
              ),
          ...?boxesBlue
              ?.take(1000)
              .expand(
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
    final bw =
        (box.boundingBox.x2 - box.boundingBox.x1) * imageWidth.toDouble();
    final bh =
        (box.boundingBox.y2 - box.boundingBox.y1) * imageHeight.toDouble();
    final bx = (box.boundingBox.x1) * imageWidth.toDouble();
    final by = (box.boundingBox.y1) * imageHeight.toDouble();
    if (box.confidence < threshold) {
      return [];
    }
    final resultClass = intToComponent[box.classId];
    final className = resultClass?.name;
    final confidencePercentage = (box.confidence * 100).round().clamp(0, 100);
    final tooltipMessage = className == null
        ? "$confidencePercentage%"
        : "$className: $confidencePercentage%";
    final width = minBoxWidth + ((box.confidence.clamp(0, 1)) * boxWidthDiff);
    final padding = width;
    return [
      Positioned(
        key: ValueKey((
          #annotatedImageBoundingBoxPositioned,
          imagePath,
          color,
          box,
        )),
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
