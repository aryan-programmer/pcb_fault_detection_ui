// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ImageDataStore on _ImageDataStore, Store {
  Computed<NonOverlappingComponentsResult>? _$nonOverlappingComponentsComputed;

  @override
  NonOverlappingComponentsResult get nonOverlappingComponents =>
      (_$nonOverlappingComponentsComputed ??=
              Computed<NonOverlappingComponentsResult>(
                () => super.nonOverlappingComponents,
                name: '_ImageDataStore.nonOverlappingComponents',
              ))
          .value;
  Computed<String?>? _$imagePathComputed;

  @override
  String? get imagePath => (_$imagePathComputed ??= Computed<String?>(
    () => super.imagePath,
    name: '_ImageDataStore.imagePath',
  )).value;
  Computed<ImageStatusTileData>? _$statusTileDataComputed;

  @override
  ImageStatusTileData get statusTileData =>
      (_$statusTileDataComputed ??= Computed<ImageStatusTileData>(
        () => super.statusTileData,
        name: '_ImageDataStore.statusTileData',
      )).value;

  late final _$imageDataAtom = Atom(
    name: '_ImageDataStore.imageData',
    context: context,
  );

  @override
  ImageData get imageData {
    _$imageDataAtom.reportRead();
    return super.imageData;
  }

  @override
  set imageData(ImageData value) {
    _$imageDataAtom.reportWrite(value, super.imageData, () {
      super.imageData = value;
    });
  }

  late final _$_ImageDataStoreActionController = ActionController(
    name: '_ImageDataStore',
    context: context,
  );

  @override
  void setComponents(List<YoloEntityOutput> components) {
    final _$actionInfo = _$_ImageDataStoreActionController.startAction(
      name: '_ImageDataStore.setComponents',
    );
    try {
      return super.setComponents(components);
    } finally {
      _$_ImageDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsTracksOnly(bool isTracksOnly) {
    final _$actionInfo = _$_ImageDataStoreActionController.startAction(
      name: '_ImageDataStore.setIsTracksOnly',
    );
    try {
      return super.setIsTracksOnly(isTracksOnly);
    } finally {
      _$_ImageDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBenchmarkOverlapThreshold(double benchmarkOverlapThreshold) {
    final _$actionInfo = _$_ImageDataStoreActionController.startAction(
      name: '_ImageDataStore.setBenchmarkOverlapThreshold',
    );
    try {
      return super.setBenchmarkOverlapThreshold(benchmarkOverlapThreshold);
    } finally {
      _$_ImageDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTrackDefects(List<YoloEntityOutput> trackDefects) {
    final _$actionInfo = _$_ImageDataStoreActionController.startAction(
      name: '_ImageDataStore.setTrackDefects',
    );
    try {
      return super.setTrackDefects(trackDefects);
    } finally {
      _$_ImageDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTrackDefectDetectionThreshold(double trackDefectDetectionThreshold) {
    final _$actionInfo = _$_ImageDataStoreActionController.startAction(
      name: '_ImageDataStore.setTrackDefectDetectionThreshold',
    );
    try {
      return super.setTrackDefectDetectionThreshold(
        trackDefectDetectionThreshold,
      );
    } finally {
      _$_ImageDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeComponent(YoloEntityOutput remVal) {
    final _$actionInfo = _$_ImageDataStoreActionController.startAction(
      name: '_ImageDataStore.removeComponent',
    );
    try {
      return super.removeComponent(remVal);
    } finally {
      _$_ImageDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteImage() {
    final _$actionInfo = _$_ImageDataStoreActionController.startAction(
      name: '_ImageDataStore.deleteImage',
    );
    try {
      return super.deleteImage();
    } finally {
      _$_ImageDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
imageData: ${imageData},
nonOverlappingComponents: ${nonOverlappingComponents},
imagePath: ${imagePath},
statusTileData: ${statusTileData}
    ''';
  }
}
