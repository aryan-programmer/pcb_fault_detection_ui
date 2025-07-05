import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:pcb_fault_detection_ui/src/data/component_classes.dart';
import 'package:pcb_fault_detection_ui/src/data/image_data.dart';
import 'package:pcb_fault_detection_ui/src/models/pcb_components_model.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';
import 'package:pcb_fault_detection_ui/src/store/project.store.dart';
import 'package:pcb_fault_detection_ui/src/utils/snackbar.dart';
import 'package:pcb_fault_detection_ui/src/widgets/resizeable.dart';
import 'package:provider/provider.dart';

class BenchmarkCardListTile extends StatelessWidget {
  const BenchmarkCardListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ProjectStore>(context);
    return ListTile(
      title: const Text("Benchmark image"),
      subtitle: const Text("Tap to change"),
      onTap: store.onOpenBenchmarkFile,
    );
  }
}

class BenchmarkAccordionPanel extends StatefulObserverWidget {
  final String benchmarkImageFolderName;
  final String benchmarkImagePath;
  final BenchmarkImageData benchmarkImageData;
  final void Function(double threshold) setThreshold;
  final void Function(List<YoloEntityOutput> components) setComponents;
  final void Function(YoloEntityOutput remComp) removeComponent;

  const BenchmarkAccordionPanel({
    super.key,
    required this.benchmarkImageFolderName,
    required this.benchmarkImagePath,
    required this.benchmarkImageData,
    required this.setThreshold,
    required this.setComponents,
    required this.removeComponent,
  });

  @override
  State<BenchmarkAccordionPanel> createState() =>
      _BenchmarkAccordionPanelState();
}

class _BenchmarkAccordionPanelState extends State<BenchmarkAccordionPanel> {
  bool loading = false;
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

  Future<void> runInference(PcbComponentsModel model) async {
    final res = await model.runInference(widget.benchmarkImagePath);
    widget.setComponents(res);
  }

  void onRerunInference(BuildContext context, PcbComponentsModel model) {
    setState(() {
      loading = true;
    });
    runInference(model)
        .onError((err, stack) {
          log("Error in running inference: ", error: err, stackTrace: stack);
          if (!context.mounted) return;
          showInferenceFailedSnackbar(context);
        })
        .then((_) {
          if (!context.mounted) return;
          setState(() {
            loading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PcbComponentsModel?>(context);
    final store = Provider.of<ProjectStore?>(context);
    final resultCard = ReactionBuilder(
      builder: (context) => reaction(
        fireImmediately: true,
        (_) => store!.benchmarkImageData?.componentDetectionThreshold,
        (thresh) {
          if (thresh == null) return;
          final text = (thresh * 100).round().toString();
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BenchmarkCardListTile(),
            Expanded(
              child: ResizeableAnnotatedImage(
                maxScale: 5,
                minScale: 0.25,
                imagePath: widget.benchmarkImagePath,
                boxesBlue: widget.benchmarkImageData.components,
                imageWidth: widget.benchmarkImageData.imageWidth,
                imageHeight: widget.benchmarkImageData.imageHeight,
                thresholdBlue:
                    widget.benchmarkImageData.componentDetectionThreshold,
                thresholdRed: 1,
                intToComponent: ComponentClass.INT_TO_COMPONENT,
                onRemoveBlue: widget.removeComponent,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(widget.benchmarkImageFolderName),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    onThresholdInputChange();
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
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.percent),
                    labelText: 'Component Detection Threshold',
                    filled: true,
                  ),
                  onSubmitted: (_) => onThresholdInputChange(),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OverflowBar(
                  children: [
                    FilledButton.tonal(
                      onPressed: model != null
                          ? () {
                              onRerunInference(context, model);
                            }
                          : null,
                      child: const Text("Re-run inference"),
                    ),
                  ],
                ),
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

  void onThresholdInputChange() {
    final intV = int.tryParse(thresholdTextController.text);
    if (intV != null) {
      widget.setThreshold(intV.toDouble() / 100);
    }
  }
}
