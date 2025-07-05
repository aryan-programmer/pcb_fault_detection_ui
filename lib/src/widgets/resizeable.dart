import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pcb_fault_detection_ui/src/data/component_classes.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';
import 'package:pcb_fault_detection_ui/src/widgets/annotated_image.dart';
import 'package:provider/single_child_widget.dart';

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function(Size?) onChange;

  const WidgetSize({super.key, required this.onChange, required this.child});

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(key: widgetKey, child: widget.child);
  }

  var widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}

class CoverInteractiveViewer extends StatefulWidget {
  const CoverInteractiveViewer({required this.child, super.key});

  final Widget child;

  @override
  State<CoverInteractiveViewer> createState() => _CoverInteractiveViewerState();
}

class _CoverInteractiveViewerState extends State<CoverInteractiveViewer> {
  final controller = TransformationController();
  @override
  Widget build(BuildContext _) {
    return LayoutBuilder(
      builder: (_, constraint) {
        return InteractiveViewer(
          transformationController: controller,
          minScale: 0.001,
          boundaryMargin: EdgeInsets.all(double.infinity),
          constrained: false,
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                final renderBox = context.findRenderObject() as RenderBox?;
                final childSize = renderBox?.size ?? Size.zero;
                if (childSize != Size.zero) {
                  controller.value = Matrix4.identity()
                    ..scale(_coverRatio(constraint.biggest, childSize));
                }
              });
              return widget.child;
            },
          ),
        );
      },
    );
  }

  double _coverRatio(Size outside, Size inside) {
    if (outside.width / inside.height > outside.width / inside.height) {
      return outside.width / inside.width;
    } else {
      return outside.height / inside.height;
    }
  }
}

// class Resizeable extends SingleChildStatelessWidget {
//   final double minScale;
//   final double maxScale;

//   const Resizeable({
//     super.key,
//     super.child,
//     required this.minScale,
//     required this.maxScale,
//   });

//   @override
//   Widget buildWithChild(BuildContext context, Widget? child) {
//     // return CoverInteractiveViewer(child: child ?? SizedBox.shrink());
//     return InteractiveViewer(
//       clipBehavior: Clip.antiAlias,
//       maxScale: maxScale,
//       minScale: minScale,
//       scaleEnabled: true,
//       panEnabled: true,
//       panAxis: PanAxis.free,
//       constrained: false,
//       child: child,
//     );
//   }
// }

class ResizeableAnnotatedImage extends SingleChildStatefulWidget {
  final double minScale;
  final double maxScale;

  final String imagePath;
  final int imageWidth;
  final int imageHeight;
  final double thresholdRed;
  final double thresholdBlue;
  final double? minBoxWidth;
  final double? maxBoxWidth;
  final List<YoloEntityOutput>? boxesRed;
  final List<YoloEntityOutput>? boxesBlue;
  final Map<int, ResultClass> intToComponent;
  final void Function(YoloEntityOutput)? onRemoveRed;
  final void Function(YoloEntityOutput)? onRemoveBlue;

  const ResizeableAnnotatedImage({
    super.key,
    super.child,
    required this.minScale,
    required this.maxScale,

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
    this.minBoxWidth,
    this.maxBoxWidth,
  });

  @override
  SingleChildState<ResizeableAnnotatedImage> createState() =>
      _ResizeableAnnotatedImageState();
}

class _ResizeableAnnotatedImageState
    extends SingleChildState<ResizeableAnnotatedImage> {
  static final effectivelyInfinite = 1000000.0;

  EdgeInsets boundaryMargin = EdgeInsets.all(effectivelyInfinite);

  TransformationController controller = TransformationController();

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    // return CoverInteractiveViewer(child: child ?? SizedBox.shrink());
    return LayoutBuilder(
      builder: (context, constraint) {
        return WidgetSize(
          onChange: (outside) {
            if (outside == null) return;
            log(outside.toString());
            final inside = Size(
              widget.imageWidth.toDouble(),
              widget.imageHeight.toDouble(),
            );

            double scale;
            EdgeInsets newBoundaryMargin;
            final wRatio = outside.width / inside.width;
            final hRatio = outside.height / inside.height;
            if (wRatio < hRatio) {
              scale = wRatio;
              newBoundaryMargin = EdgeInsets.symmetric(
                vertical: effectivelyInfinite,
              );
            } else {
              scale = hRatio;
              newBoundaryMargin = EdgeInsets.symmetric(
                horizontal: effectivelyInfinite,
              );
            }
            if (boundaryMargin != newBoundaryMargin) {
              setState(() {
                boundaryMargin = newBoundaryMargin;
              });
            }

            final w = ((widget.imageWidth / 2) * scale) - outside.width / 2;
            final h = ((widget.imageHeight / 2) * scale) - outside.height / 2;

            // Set the initial transform and center the canvas
            final initialTransform = Transform.translate(
              offset: Offset(-w, -h),
            ).transform;
            initialTransform.scale(scale);
            log(scale.toString());
            controller.value = initialTransform;
          },
          child: InteractiveViewer(
            transformationController: controller,
            clipBehavior: Clip.antiAlias,
            maxScale: widget.maxScale,
            // minScale: widget.minScale,
            boundaryMargin: boundaryMargin,
            scaleEnabled: true,
            panEnabled: true,
            panAxis: PanAxis.free,
            minScale: 0.001,
            constrained: false,
            child: AnnotatedImage(
              imagePath: widget.imagePath,
              boxesRed: widget.boxesRed,
              boxesBlue: widget.boxesBlue,
              imageWidth: widget.imageWidth,
              imageHeight: widget.imageHeight,
              thresholdRed: widget.thresholdRed,
              thresholdBlue: widget.thresholdBlue,
              intToComponent: widget.intToComponent,
              onRemoveRed: widget.onRemoveRed,
              onRemoveBlue: widget.onRemoveBlue,
              minBoxWidth: widget.minBoxWidth,
              maxBoxWidth: widget.maxBoxWidth,
            ),
          ),
        );
      },
    );
  }
}
