import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:pcb_fault_detection_ui/src/models/auto_slicing.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/model.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';
import 'package:pcb_fault_detection_ui/src/utils/image.dart';
import 'package:pcb_fault_detection_ui/src/utils/logging_timer.dart';

class TrackDefectsModel {
  YoloModelSession model;

  TrackDefectsModel._(this.model);

  static Future<TrackDefectsModel> load() async {
    final timer = LoggingTimer("TrackDefectsModel::load()");
    try {
      final modelBytes = (await rootBundle.load(
        "assets/yolo11n_model_copper_track.onnx",
      )).buffer.asUint8List();
      var yoloModelSession = await YoloModelSession.fromMemory(
        bytes: VecU8Wrapper(v: modelBytes),
        finalMetricThreshold: 0.5,
        finalMetric: MatchMetric.iou,
        sliceIouThreshold: 0.5,
        confidenceThreshold: 0.05,
      );
      return TrackDefectsModel._(yoloModelSession);
    } finally {
      timer.log();
    }
  }

  Future<List<YoloEntityOutput>> runInference(String imagePath) async {
    final imageAndBytes = await readImage(imagePath);
    if (imageAndBytes == null) {
      return [];
    }
    final (image, bytes) = imageAndBytes;
    final timerInference = LoggingTimer(
      "TrackDefectsModel::runInference($imagePath)",
    );
    try {
      var width = image.width;
      var height = image.height;
      final opts = ModelInferenceParameters.calculateModelParams(width, height);
      log("Image: $width*$height: $opts");
      final components = await model.slicedInference(
        image: VecU8Wrapper(v: bytes),
        imageWidth: image.width,
        imageHeight: image.height,
        keepOriginal: false, //opts.keepOriginal
        sliceOptions: opts.sliceOptions,
      );
      return components;
    } finally {
      timerInference.log();
    }
  }
}
