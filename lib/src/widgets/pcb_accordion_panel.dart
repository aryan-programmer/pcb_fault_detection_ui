import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:pcb_fault_detection_ui/src/data/component_classes.dart';
import 'package:pcb_fault_detection_ui/src/data/image_status_tile_data.dart';
import 'package:pcb_fault_detection_ui/src/models/pcb_components_model.dart';
import 'package:pcb_fault_detection_ui/src/models/track_defects_model.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';
import 'package:pcb_fault_detection_ui/src/store/image_data.store.dart';
import 'package:pcb_fault_detection_ui/src/store/project.store.dart';
import 'package:pcb_fault_detection_ui/src/utils/snackbar.dart';
import 'package:pcb_fault_detection_ui/src/widgets/resizeable.dart';
import 'package:provider/provider.dart';

class PcbCardListNavTile extends StatelessWidget {
  final String name;
  final ImageStatusTileData status;

  const PcbCardListNavTile({
    super.key,
    required this.name,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final (trailingIcon, tileColor) = status.status.iconDataAndColor;

    return ListTile(
      title: Text(name),
      subtitle: Text(status.statusString),
      isThreeLine: true,
      tileColor: tileColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      trailing: Icon(trailingIcon),
    );
  }
}

enum DisplayMode {
  selfOnly,
  benchmarkAndSelf,
  missingComponentsOnly,
  extraComponentsOnly,
  nonOverlappingComponents;

  String displayString() {
    return switch (this) {
      DisplayMode.selfOnly => "Only Current Components",
      DisplayMode.benchmarkAndSelf => "Also with Benchmark's Components",
      DisplayMode.missingComponentsOnly => "Missing Components Only",
      DisplayMode.extraComponentsOnly => "Spurious/Extra Components Only",
      DisplayMode.nonOverlappingComponents => "All Non-Overlapping Components",
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

  final TextEditingController thresholdTextController = TextEditingController(
    text: "30",
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    thresholdTextController.dispose();
    super.dispose();
  }

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

  void onThresholdInputChange(bool isTracksMode) {
    final intV = int.tryParse(thresholdTextController.text);
    if (intV != null) {
      widget.imageDataStore.setTrackDefectDetectionThreshold(
        intV.toDouble() / 100,
      );
      widget.imageDataStore.setBenchmarkOverlapThreshold(intV.toDouble() / 100);
    }
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
    double? minBoxWidth;
    double? maxBoxWidth;
    bool isTracksMode = widget.imageDataStore.imageData.tracksOnly;

    if (isTracksMode) {
      boxesRed = widget.imageDataStore.imageData.trackDefects;
      boxesBlue = null;
      maxBoxWidth = 8;
      minBoxWidth = 2.5;
    } else {
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
          maxBoxWidth = 7;
        case DisplayMode.extraComponentsOnly:
          boxesRed =
              widget.imageDataStore.nonOverlappingComponents.extraComponents;
          boxesBlue = null;
          maxBoxWidth = 7;
        case DisplayMode.nonOverlappingComponents:
          boxesRed =
              widget.imageDataStore.nonOverlappingComponents.extraComponents;
          boxesBlue =
              widget.imageDataStore.nonOverlappingComponents.missingComponents;
          maxBoxWidth = 7;
      }
    }
    final resultCard = ReactionBuilder(
      builder: (context) => reaction(
        fireImmediately: true,
        (_) => (
          widget.imageDataStore.imageData.tracksOnly,
          widget.imageDataStore.imageData.trackDefectDetectionThreshold,
          widget.imageDataStore.imageData.benchmarkOverlapThreshold,
        ),
        (vs) {
          final (isTracksMode, trackThesh, overlapThesh) = vs;
          final text = ((isTracksMode ? trackThesh : overlapThesh) * 100)
              .round()
              .toString();
          thresholdTextController.value = TextEditingValue(
            text: text,
            selection: TextSelection.fromPosition(
              TextPosition(offset: text.length),
            ),
          );
        },
      ),
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PcbCardListNavTile(
              name: widget.imageFolderName,
              status: widget.imageDataStore.statusTileData,
            ),
            Expanded(
              child: ResizeableAnnotatedImage(
                maxScale: 5,
                minScale: 0.25,
                imagePath: widget.imagePath,
                boxesRed: boxesRed,
                boxesBlue: boxesBlue,
                imageWidth: widget.imageDataStore.imageData.imageWidth,
                imageHeight: widget.imageDataStore.imageData.imageHeight,
                thresholdRed: isTracksMode
                    ? widget
                          .imageDataStore
                          .imageData
                          .trackDefectDetectionThreshold
                    : (store.benchmarkImageData?.componentDetectionThreshold ??
                          1),
                thresholdBlue:
                    store.benchmarkImageData?.componentDetectionThreshold ?? 1,
                intToComponent: isTracksMode
                    ? TrackDefectClasses.INT_TO_COMPONENT
                    : ComponentClass.INT_TO_COMPONENT,
                onRemoveRed: widget.imageDataStore.removeComponent,
                onRemoveBlue: store.removeBenchmarkImageComponent,
                minBoxWidth: minBoxWidth,
                maxBoxWidth: maxBoxWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          value: isTracksMode,
                          onChanged: widget.imageDataStore.setIsTracksOnly,
                          title: Text("Is this a PCB track image?"),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              onThresholdInputChange(isTracksMode);
                            }
                          },
                          child: TextField(
                            controller: thresholdTextController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp("^(([0-9]?[0-9])|100)\$"),
                              ),
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.percent),
                              labelText: isTracksMode
                                  ? "Track Defect Threshold:"
                                  : "Benchmark Overlap Threshold:",
                              filled: true,
                            ),
                            onSubmitted: (_) =>
                                onThresholdInputChange(isTracksMode),
                          ),
                        ),
                      ),
                    ],
                  ),
                  OverflowBar(
                    alignment: isTracksMode
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isTracksMode)
                        DropdownButton<DisplayMode>(
                          isDense: true,
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
                ],
              ),
            ),
          ],
        ),
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
