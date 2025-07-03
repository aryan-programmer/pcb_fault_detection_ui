import 'dart:developer';

import 'package:memoize/memoize.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';

class NonOverlappingComponentsResult {
  final List<YoloEntityOutput> missingComponents;
  final List<YoloEntityOutput> extraComponents;

  NonOverlappingComponentsResult({
    required this.missingComponents,
    required this.extraComponents,
  });

  NonOverlappingComponentsResult.empty()
    : missingComponents = [],
      extraComponents = [];
}

NonOverlappingComponentsResult __getNonOverlappingComponents({
  required List<YoloEntityOutput> benchmarkComponents,
  required double benchmarkComponentsDetectionThreshold,
  required List<YoloEntityOutput> testComponents,
  required double testComponentsDetectionThreshold,
  required double benchmarkOverlapThreshold,
}) {
  log("Slow");
  testComponents = testComponents
      .where((v) => v.confidence > testComponentsDetectionThreshold)
      .toList();
  Set<YoloEntityOutput> benchmarkComponentsSet = Set.from(
    benchmarkComponents.where(
      (benchmark) =>
          benchmark.confidence > benchmarkComponentsDetectionThreshold,
    ),
  );
  Set<YoloEntityOutput> testComponentsSet = Set.from(testComponents);
  for (YoloEntityOutput benchmark in benchmarkComponents) {
    if (benchmark.confidence <= benchmarkComponentsDetectionThreshold) {
      continue;
    }
    for (YoloEntityOutput test in testComponents) {
      if (test.confidence <= benchmarkComponentsDetectionThreshold) {
        benchmarkComponentsSet.remove(benchmark);
        continue;
      }
      if (benchmark.boundingBox.iou(box2: test.boundingBox) >=
          benchmarkOverlapThreshold) {
        benchmarkComponentsSet.remove(benchmark);
        testComponentsSet.remove(test);
      }
    }
  }
  return NonOverlappingComponentsResult(
    missingComponents: benchmarkComponentsSet.toList(),
    extraComponents: testComponentsSet.toList(),
  );
}

final _getNonOverlappingComponents = memo5(
  (
    List<YoloEntityOutput> benchmarkComponents,
    double benchmarkComponentsDetectionThreshold,
    List<YoloEntityOutput> testComponents,
    double testComponentsDetectionThreshold,
    double benchmarkOverlapThreshold,
  ) => __getNonOverlappingComponents(
    benchmarkComponents: benchmarkComponents,
    benchmarkComponentsDetectionThreshold:
        benchmarkComponentsDetectionThreshold,
    testComponents: testComponents,
    testComponentsDetectionThreshold: testComponentsDetectionThreshold,
    benchmarkOverlapThreshold: benchmarkOverlapThreshold,
  ),
);

NonOverlappingComponentsResult getNonOverlappingComponents({
  required List<YoloEntityOutput> benchmarkComponents,
  required double benchmarkComponentsDetectionThreshold,
  required List<YoloEntityOutput> testComponents,
  required double testComponentsDetectionThreshold,
  required double benchmarkOverlapThreshold,
}) => _getNonOverlappingComponents(
  benchmarkComponents,
  benchmarkComponentsDetectionThreshold,
  testComponents,
  testComponentsDetectionThreshold,
  benchmarkOverlapThreshold,
);
