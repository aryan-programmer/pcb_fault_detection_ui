// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProjectStore on _ProjectStore, Store {
  Computed<String?>? _$benchmarkImagePathComputed;

  @override
  String? get benchmarkImagePath =>
      (_$benchmarkImagePathComputed ??= Computed<String?>(
        () => super.benchmarkImagePath,
        name: '_ProjectStore.benchmarkImagePath',
      )).value;

  late final _$projectFolderAtom = Atom(
    name: '_ProjectStore.projectFolder',
    context: context,
  );

  @override
  String? get projectFolder {
    _$projectFolderAtom.reportRead();
    return super.projectFolder;
  }

  @override
  set projectFolder(String? value) {
    _$projectFolderAtom.reportWrite(value, super.projectFolder, () {
      super.projectFolder = value;
    });
  }

  late final _$projectDataAtom = Atom(
    name: '_ProjectStore.projectData',
    context: context,
  );

  @override
  ProjectData? get projectData {
    _$projectDataAtom.reportRead();
    return super.projectData;
  }

  @override
  set projectData(ProjectData? value) {
    _$projectDataAtom.reportWrite(value, super.projectData, () {
      super.projectData = value;
    });
  }

  late final _$benchmarkImageDataAtom = Atom(
    name: '_ProjectStore.benchmarkImageData',
    context: context,
  );

  @override
  BenchmarkImageData? get benchmarkImageData {
    _$benchmarkImageDataAtom.reportRead();
    return super.benchmarkImageData;
  }

  @override
  set benchmarkImageData(BenchmarkImageData? value) {
    _$benchmarkImageDataAtom.reportWrite(value, super.benchmarkImageData, () {
      super.benchmarkImageData = value;
    });
  }

  late final _$imagesAtom = Atom(
    name: '_ProjectStore.images',
    context: context,
  );

  @override
  ObservableMap<String, ImageDataStore> get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableMap<String, ImageDataStore> value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  late final _$onOpenProjectAsyncAction = AsyncAction(
    '_ProjectStore.onOpenProject',
    context: context,
  );

  @override
  Future<void> onOpenProject() {
    return _$onOpenProjectAsyncAction.run(() => super.onOpenProject());
  }

  late final _$_loadProjectFromAsyncAction = AsyncAction(
    '_ProjectStore._loadProjectFrom',
    context: context,
  );

  @override
  Future<void> _loadProjectFrom(String folder) {
    return _$_loadProjectFromAsyncAction.run(
      () => super._loadProjectFrom(folder),
    );
  }

  late final _$onOpenBenchmarkFileAsyncAction = AsyncAction(
    '_ProjectStore.onOpenBenchmarkFile',
    context: context,
  );

  @override
  Future<void> onOpenBenchmarkFile() {
    return _$onOpenBenchmarkFileAsyncAction.run(
      () => super.onOpenBenchmarkFile(),
    );
  }

  late final _$onOpenImageFileAsyncAction = AsyncAction(
    '_ProjectStore.onOpenImageFile',
    context: context,
  );

  @override
  Future<void> onOpenImageFile() {
    return _$onOpenImageFileAsyncAction.run(() => super.onOpenImageFile());
  }

  late final _$_ProjectStoreActionController = ActionController(
    name: '_ProjectStore',
    context: context,
  );

  @override
  void saveToFile() {
    final _$actionInfo = _$_ProjectStoreActionController.startAction(
      name: '_ProjectStore.saveToFile',
    );
    try {
      return super.saveToFile();
    } finally {
      _$_ProjectStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBenchmarkImageDetectionThreshold(double newVal) {
    final _$actionInfo = _$_ProjectStoreActionController.startAction(
      name: '_ProjectStore.setBenchmarkImageDetectionThreshold',
    );
    try {
      return super.setBenchmarkImageDetectionThreshold(newVal);
    } finally {
      _$_ProjectStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBenchmarkImageComponents(List<YoloEntityOutput> newVal) {
    final _$actionInfo = _$_ProjectStoreActionController.startAction(
      name: '_ProjectStore.setBenchmarkImageComponents',
    );
    try {
      return super.setBenchmarkImageComponents(newVal);
    } finally {
      _$_ProjectStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeBenchmarkImageComponent(YoloEntityOutput remVal) {
    final _$actionInfo = _$_ProjectStoreActionController.startAction(
      name: '_ProjectStore.removeBenchmarkImageComponent',
    );
    try {
      return super.removeBenchmarkImageComponent(remVal);
    } finally {
      _$_ProjectStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
projectFolder: ${projectFolder},
projectData: ${projectData},
benchmarkImageData: ${benchmarkImageData},
images: ${images},
benchmarkImagePath: ${benchmarkImagePath}
    ''';
  }
}
