import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:pcb_fault_detection_ui/src/data/image_data.dart';
import 'package:pcb_fault_detection_ui/src/data/project_data.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';
import 'package:pcb_fault_detection_ui/src/store/image_data.store.dart';
import 'package:pcb_fault_detection_ui/src/utils/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'project.store.g.dart';

const PROJECT_FOLDER_PREFERENCE = "PROJECT_FOLDER_PREFERENCE";
const PROJECT_DATA_FILE_NAME = "project-data.json";
const IMAGE_FILE_NAME = "original.png";
const IMAGE_DATA_FILE_NAME = "original.json";

class ProjectStore extends _ProjectStore with _$ProjectStore {
  ProjectStore() {
    super.parentStore = this;
  }
}

sealed class _ProjectStore with Store {
  static final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  @observable
  String? projectFolder;

  @observable
  ProjectData? projectData;

  @observable
  BenchmarkImageData? benchmarkImageData;

  @observable
  ObservableMap<String, ImageDataStore> images = ObservableMap();

  ProjectData? projectDataOnLastStore;
  BenchmarkImageData? benchmarkImageDataOnLastStore;
  Map<String, ImageData> imagesOnLastStore = {};

  late final ProjectStore parentStore;

  _ProjectStore() {
    prefs.getString(PROJECT_FOLDER_PREFERENCE).then((v) async {
      if (v != null) await _loadProjectFrom(v);
    });
  }

  @action
  void saveToFile() {
    final projectData = this.projectData;
    final projectFolder = this.projectFolder;
    if (projectFolder == null || projectData == null) return;
    if (projectData != projectDataOnLastStore) {
      final file = File(path.join(projectFolder, PROJECT_DATA_FILE_NAME));
      file.writeAsStringSync(jsonEncode(projectData.toJson()), flush: true);
      projectDataOnLastStore = projectData;
    }

    final benchmarkDataFolder = projectData.benchmarkDataFolder;
    if (benchmarkDataFolder != null &&
        benchmarkImageData != benchmarkImageDataOnLastStore) {
      final dataFile = File(
        path.join(projectFolder, benchmarkDataFolder, IMAGE_DATA_FILE_NAME),
      );
      dataFile.writeAsStringSync(jsonEncode(benchmarkImageData), flush: true);
    }

    for (var entry in images.entries) {
      final imageDataFolder = entry.key;
      if (imagesOnLastStore[imageDataFolder] != entry.value.imageData) {
        final dataFile = File(
          path.join(projectFolder, imageDataFolder, IMAGE_DATA_FILE_NAME),
        );
        dataFile.writeAsStringSync(
          jsonEncode(entry.value.imageData),
          flush: true,
        );
      }
    }
    imagesOnLastStore = images.map((k, v) => MapEntry(k, v.imageData));
  }

  @action
  Future<void> onOpenProject() async {
    var folder = await getDirectoryPath(
      confirmButtonText: "Open Project Folder",
    );
    if (folder == null) return;

    await _loadProjectFrom(folder);

    await prefs.setString(PROJECT_FOLDER_PREFERENCE, folder);
  }

  @action
  Future<void> _loadProjectFrom(String folder) async {
    if (!Directory(folder).existsSync()) {
      await closeProject();
      return;
    }

    _unloadProject();

    final file = File(path.join(folder, PROJECT_DATA_FILE_NAME));
    if (file.existsSync()) {
      final json = jsonDecode(await file.readAsString());
      assert(json is Map);
      projectData = ProjectData.fromJson(json);
    } else {
      projectData = ProjectData();
    }
    projectFolder = folder;
    projectDataOnLastStore = null;

    final benchmarkDataFolder = projectData?.benchmarkDataFolder;
    if (benchmarkDataFolder == null) {
      benchmarkImageData = null;
    } else {
      final benchmarkImageDataFile = File(
        path.join(folder, benchmarkDataFolder, IMAGE_DATA_FILE_NAME),
      );
      if (benchmarkImageDataFile.existsSync()) {
        final readData = jsonDecode(benchmarkImageDataFile.readAsStringSync());
        benchmarkImageData = readData == null
            ? null
            : BenchmarkImageData.fromJson(readData);
      } else {
        benchmarkImageData = null;
      }
    }
    benchmarkImageDataOnLastStore = null;

    final images = ObservableMap<String, ImageDataStore>();
    final dir = Directory(folder);
    final children = dir.listSync(recursive: false, followLinks: false);
    for (final child in children) {
      if (child case Directory childDir) {
        final absPath = childDir.absolute.path;
        final imageName = path.basename(absPath);
        if (imageName.startsWith("benchmark-")) continue;
        final imageDataFile = File(
          path.join(childDir.absolute.path, IMAGE_DATA_FILE_NAME),
        );
        if (!imageDataFile.existsSync()) continue;
        final readData = jsonDecode(imageDataFile.readAsStringSync());
        if (readData == null) continue;
        final imageData = ImageData.fromJson(readData);
        images[imageName] = ImageDataStore(
          imageData,
          parent: parentStore,
          folderName: imageName,
        );
      }
    }

    imagesOnLastStore = images.map((k, v) => MapEntry(k, v.imageData));
    this.images = images;
  }

  @action
  Future<void> onOpenBenchmarkFile() async {
    final projectFolder = this.projectFolder;
    if (projectFolder == null) return;
    final file = await showImageOpenDialog("Open Bencmark Image");
    if (file == null) return;
    final benchmarkImageFolderName =
        "benchmark-${DateFormat("yyyy-MM-ddTHH_mm_ss").format(DateTime.now())}";
    final oldBenchmarkDataFolder = projectData?.benchmarkDataFolder;
    if (oldBenchmarkDataFolder != null) {
      projectData = (projectData ?? ProjectData()).copyWith(
        benchmarkDataFolder: null,
      );
      benchmarkImageData = null;
      Directory(
        path.join(projectFolder, oldBenchmarkDataFolder),
      ).delete(recursive: true);
    }
    final cmd = img.Command()
      ..decodeImageFile(file.path)
      ..writeToFile(
        path.join(projectFolder, benchmarkImageFolderName, IMAGE_FILE_NAME),
      );
    await cmd.executeThread();
    final image = await cmd.getImage();
    if (image == null) return;
    final dataFile = File(
      path.join(projectFolder, benchmarkImageFolderName, IMAGE_DATA_FILE_NAME),
    );
    benchmarkImageData = BenchmarkImageData(
      imageWidth: image.width,
      imageHeight: image.height,
    );
    dataFile.writeAsStringSync(jsonEncode(benchmarkImageData), flush: true);
    projectData = (projectData ?? ProjectData()).copyWith(
      benchmarkDataFolder: benchmarkImageFolderName,
    );
    log("Benchmark: $projectFolder/$benchmarkImageFolderName");
  }

  @action
  Future<void> onOpenImageFile() async {
    final projectFolder = this.projectFolder;
    if (projectFolder == null) return;
    final file = await showImageOpenDialog("Open Image");
    if (file == null) return;
    final imageOrigName = path.basenameWithoutExtension(file.path);
    final folderName =
        "image-${DateFormat("yyyy-MM-ddTHH_mm_ss").format(DateTime.now())}-$imageOrigName";
    final cmd = img.Command()
      ..decodeImageFile(file.path)
      ..writeToFile(path.join(projectFolder, folderName, IMAGE_FILE_NAME));
    await cmd.executeThread();
    final image = await cmd.getImage();
    if (image == null) return;
    final dataFile = File(
      path.join(projectFolder, folderName, IMAGE_DATA_FILE_NAME),
    );
    final imageData = ImageData(
      imageWidth: image.width,
      imageHeight: image.height,
    );
    dataFile.writeAsStringSync(jsonEncode(imageData), flush: true);
    images[folderName] = ImageDataStore(
      imageData,
      folderName: folderName,
      parent: parentStore,
    );
    log("Image: $projectFolder/$folderName");
  }

  @action
  Future<void> closeProject() async {
    _unloadProject();

    await prefs.remove(PROJECT_FOLDER_PREFERENCE);
  }

  @action
  void _unloadProject() {
    projectDataOnLastStore = null;
    imagesOnLastStore.clear();
    projectFolder = null;
    projectData = null;
    benchmarkImageData = null;
    benchmarkImageDataOnLastStore = null;
    images.clear();
  }

  @action
  void setBenchmarkImageDetectionThreshold(double newVal) {
    var data = benchmarkImageData;
    if (data == null) {
      return;
    }
    var origVal = data.componentDetectionThreshold;
    if ((origVal - newVal).abs() < 0.005) {
      return;
    }
    benchmarkImageData = data.copyWith(componentDetectionThreshold: newVal);
  }

  @action
  void setBenchmarkImageComponents(List<YoloEntityOutput> newVal) {
    benchmarkImageData = benchmarkImageData?.copyWith(components: newVal);
  }

  @action
  void removeBenchmarkImageComponent(YoloEntityOutput remVal) {
    final benchmarkImageData = this.benchmarkImageData;
    if (benchmarkImageData == null) return;
    var components = benchmarkImageData.components;
    final idx = components.indexOf(remVal);
    if (idx == -1) return;
    components = List.of(components);
    components.removeAt(idx);
    this.benchmarkImageData = benchmarkImageData.copyWith(
      components: components,
    );
  }

  @action
  void removeImage(String imageFolderName) {
    final imageDataStore = images.remove(imageFolderName);
    final projectFolder = this.projectFolder;
    if (projectFolder == null || imageDataStore == null) return;
    Directory(
      path.join(projectFolder, imageFolderName),
    ).delete(recursive: true);
  }

  @computed
  String? get benchmarkImagePath {
    final projectFolder = this.projectFolder;
    final benchmarkDataFolder = projectData?.benchmarkDataFolder;
    if (projectFolder == null || benchmarkDataFolder == null) return null;
    return path.join(projectFolder, benchmarkDataFolder, IMAGE_FILE_NAME);
  }
}
