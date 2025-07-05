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
    int benchmarkComponentsDetectionThreshold,
    List<YoloEntityOutput> testComponents,
    int testComponentsDetectionThreshold,
    int benchmarkOverlapThreshold,
  ) => __getNonOverlappingComponents(
    benchmarkComponents: benchmarkComponents,
    benchmarkComponentsDetectionThreshold:
        benchmarkComponentsDetectionThreshold / 100,
    testComponents: testComponents,
    testComponentsDetectionThreshold: testComponentsDetectionThreshold / 100,
    benchmarkOverlapThreshold: benchmarkOverlapThreshold / 100,
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
  (benchmarkComponentsDetectionThreshold * 100).round(),
  testComponents,
  (testComponentsDetectionThreshold * 100).round(),
  (benchmarkOverlapThreshold * 100).round(),
);
