import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pcb_fault_detection_ui/src/data/component_classes.dart';
import 'package:pcb_fault_detection_ui/src/models/pcb_components_model.dart';
import 'package:pcb_fault_detection_ui/src/models/track_defects_model.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';
import 'package:pcb_fault_detection_ui/src/store/image_data.store.dart';
import 'package:pcb_fault_detection_ui/src/store/project.store.dart';
import 'package:pcb_fault_detection_ui/src/utils/snackbar.dart';
import 'package:pcb_fault_detection_ui/src/widgets/annotated_image.dart';
import 'package:provider/provider.dart';

enum DisplayMode {
  selfOnly,
  benchmarkAndSelf,
  missingComponentsOnly,
  extraComponentsOnly,
  nonOverlappingComponents,
  trackDefectsOnly;

  String displayString() {
    return switch (this) {
      DisplayMode.selfOnly => "Only Current Components",
      DisplayMode.benchmarkAndSelf => "Also with Benchmark's Components",
      DisplayMode.missingComponentsOnly => "Missing Components Only",
      DisplayMode.extraComponentsOnly => "Spurious/Extra Components Only",
      DisplayMode.nonOverlappingComponents => "All Non-Overlapping Components",
      DisplayMode.trackDefectsOnly => "Track Defects Only",
    };
  }
}

class PcbAccordionPanel extends StatefulObserverWidget {
  final String imageFolderName;
  final String imagePath;
  final ImageDataStore imageDataStore;

  const PcbAccordionPanel({
    super.key,
    required this.imageFolderName,
    required this.imagePath,
    required this.imageDataStore,
    // required this.setTrackDefectThreshold,
  });

  @override
  State<PcbAccordionPanel> createState() => _PcbAccordionPanelState();
}

class _PcbAccordionPanelState extends State<PcbAccordionPanel> {
  bool loading = false;

  DisplayMode displayMode = DisplayMode.nonOverlappingComponents;

  Future<void> runInferenceForComponents(PcbComponentsModel model) async {
    final res = await model.runInference(widget.imagePath);
    widget.imageDataStore.setComponents(res);
  }

  Future<void> runInferenceForTrackDefects(TrackDefectsModel model) async {
    final res = await model.runInference(widget.imagePath);
    widget.imageDataStore.setTrackDefects(res);
  }

  void onRunInferenceForComponents(
    BuildContext context,
    PcbComponentsModel model,
  ) {
    if (loading) return;
    setState(() {
      loading = true;
    });
    runInferenceForComponents(model)
        .onError((err, stack) {
          log("Error in running inference: ", error: err, stackTrace: stack);
          if (!context.mounted) return;
          showInferenceFailedSnackbar(context);
        })
        .then((_) {
          setState(() {
            loading = false;
          });
        });
  }

  void onRunInferenceForTrackDefects(
    BuildContext context,
    TrackDefectsModel model,
  ) {
    if (loading) return;
    setState(() {
      loading = true;
    });
    runInferenceForTrackDefects(model)
        .onError((err, stack) {
          log("Error in running inference: ", error: err, stackTrace: stack);
          if (!context.mounted) return;
          showInferenceFailedSnackbar(context);
        })
        .then((_) {
          setState(() {
            loading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    PcbComponentsModel? componentsModel = Provider.of<PcbComponentsModel?>(
      context,
    );
    TrackDefectsModel? tracksModel = Provider.of<TrackDefectsModel?>(context);
    final store = Provider.of<ProjectStore>(context);

    // Reads for mobx
    widget.imageDataStore.folderName;
    widget.imageDataStore.imageData;
    store.benchmarkImageData;

    late List<YoloEntityOutput>? boxesRed;
    late List<YoloEntityOutput>? boxesBlue;
    double? boxWidthOverride;
    bool isTracksMode = false;

    switch (displayMode) {
      case DisplayMode.selfOnly:
        boxesRed = widget.imageDataStore.imageData.components;
        boxesBlue = null;
      case DisplayMode.benchmarkAndSelf:
        boxesRed = widget.imageDataStore.imageData.components;
        boxesBlue = store.benchmarkImageData?.components;
      case DisplayMode.missingComponentsOnly:
        boxesRed = null;
        boxesBlue =
            widget.imageDataStore.nonOverlappingComponents.missingComponents;
        boxWidthOverride = 6;
      case DisplayMode.extraComponentsOnly:
        boxesRed =
            widget.imageDataStore.nonOverlappingComponents.extraComponents;
        boxesBlue = null;
        boxWidthOverride = 6;
      case DisplayMode.nonOverlappingComponents:
        boxesRed =
            widget.imageDataStore.nonOverlappingComponents.extraComponents;
        boxesBlue =
            widget.imageDataStore.nonOverlappingComponents.missingComponents;
        boxWidthOverride = 6;
      case DisplayMode.trackDefectsOnly:
        boxesRed = widget.imageDataStore.imageData.trackDefects;
        boxesBlue = null;
        boxWidthOverride = 8;
        isTracksMode = true;
    }
    final resultCard = Card(
      margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
      elevation: 3,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: InteractiveViewer(
              clipBehavior: Clip.antiAlias,
              maxScale: 5,
              minScale: 0.25,
              scaleEnabled: true,
              panEnabled: true,
              panAxis: PanAxis.free,
              child: AnnotatedImage(
                imagePath: widget.imagePath,
                boxesRed: boxesRed,
                boxesBlue: boxesBlue,
                imageWidth: widget.imageDataStore.imageData.imageWidth,
                imageHeight: widget.imageDataStore.imageData.imageHeight,
                thresholdRed:
                    store.benchmarkImageData?.componentDetectionThreshold ?? 1,
                thresholdBlue:
                    store.benchmarkImageData?.componentDetectionThreshold ?? 1,
                intToComponent: isTracksMode
                    ? TrackDefectClasses.INT_TO_COMPONENT
                    : ComponentClass.INT_TO_COMPONENT,
                onRemoveRed: widget.imageDataStore.removeComponent,
                onRemoveBlue: store.removeBenchmarkImageComponent,
                boxWidthOverride: boxWidthOverride,
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "Component Bounding Box Threshold:",
          //     textAlign: TextAlign.start,
          //   ),
          // ),
          // Slider(
          //   label:
          //       "${widget.imageDataStore.imageData.componentDetectionThreshold}",
          //   min: 0,
          //   max: 1,
          //   divisions: 100,
          //   value: widget.imageDataStore.imageData.componentDetectionThreshold,
          //   onChanged: widget.imageDataStore.setComponentDetectionThreshold,
          //   year2023: false,
          // ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Benchmark Overlap Threshold:",
              textAlign: TextAlign.start,
            ),
          ),
          Slider(
            label:
                "${(widget.imageDataStore.imageData.benchmarkOverlapThreshold * 100).round()}%",
            min: 0,
            max: 1,
            divisions: 100,
            value: widget.imageDataStore.imageData.benchmarkOverlapThreshold,
            onChanged: widget.imageDataStore.setBenchmarkOverlapThreshold,
            year2023: false,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OverflowBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<DisplayMode>(
                    value: displayMode,
                    icon: const Icon(Icons.arrow_downward),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (DisplayMode? value) {
                      setState(() {
                        displayMode = value!;
                      });
                    },
                    items: DisplayMode.values
                        .map<DropdownMenuItem<DisplayMode>>((
                          DisplayMode value,
                        ) {
                          return DropdownMenuItem<DisplayMode>(
                            value: value,
                            child: Text(value.displayString()),
                          );
                        })
                        .toList(),
                  ),
                  FilledButton.tonal(
                    onPressed: isTracksMode
                        ? (tracksModel != null
                              ? () => onRunInferenceForTrackDefects(
                                  context,
                                  tracksModel,
                                )
                              : null)
                        : (componentsModel != null
                              ? () => onRunInferenceForComponents(
                                  context,
                                  componentsModel,
                                )
                              : null),
                    child: Text("Re-run inference"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return Stack(
      children: [
        resultCard,
        if (loading)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Colors.black,
                size: 200,
              ),
            ),
          ),
      ],
    );
  }
}
