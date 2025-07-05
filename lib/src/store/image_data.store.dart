import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:pcb_fault_detection_ui/src/data/image_data.dart';
import 'package:pcb_fault_detection_ui/src/data/image_status_tile_data.dart';
import 'package:pcb_fault_detection_ui/src/rust/api/utils.dart';
import 'package:pcb_fault_detection_ui/src/store/project.store.dart';
import 'package:pcb_fault_detection_ui/src/utils/components.dart';

part 'image_data.store.g.dart';

class ImageDataStore extends _ImageDataStore with _$ImageDataStore {
  ImageDataStore(
    super.imageData, {
    required super.folderName,
    required super.parent,
  });
}

sealed class _ImageDataStore with Store {
  @observable
  ImageData imageData;

  final String folderName;
  final ProjectStore parent;

  _ImageDataStore(
    this.imageData, {
    required this.folderName,
    required this.parent,
  });

  @computed
  NonOverlappingComponentsResult get nonOverlappingComponents {
    var benchmarkImageData = parent.benchmarkImageData;
    imageData /* read to register to mobx */;
    if (benchmarkImageData == null) {
      return NonOverlappingComponentsResult.empty();
    }
    return getNonOverlappingComponents(
      benchmarkComponents: benchmarkImageData.components,
      benchmarkOverlapThreshold: imageData.benchmarkOverlapThreshold,
      testComponents: imageData.components,
      benchmarkComponentsDetectionThreshold:
          benchmarkImageData.componentDetectionThreshold,
      testComponentsDetectionThreshold:
          benchmarkImageData.componentDetectionThreshold,
      // testComponentsDetectionThreshold: imageData.componentDetectionThreshold,
    );
  }

  @computed
  String? get imagePath {
    final projectFolder = parent.projectFolder;
    if (projectFolder == null) return null;
    return path.join(projectFolder, folderName, IMAGE_FILE_NAME);
  }

  @computed
  ImageStatusTileData get statusTileData {
    if (imageData.tracksOnly) {
      if (imageData.trackDefects.isEmpty) {
        return ImageStatusTileData(
          status: ImageStatus.Unchecked,
          statusString: "Please run inference on this image.",
        );
      }
      final numTrackDefects = imageData.trackDefects
          .where((v) => v.confidence >= imageData.trackDefectDetectionThreshold)
          .length;
      if (numTrackDefects == 0) {
        return ImageStatusTileData(
          status: ImageStatus.Ok,
          statusString: "No track defects found.",
        );
      } else {
        return ImageStatusTileData(
          status: ImageStatus.Faulty,
          statusString: "Track defects: $numTrackDefects",
        );
      }
    } else {
      if (imageData.components.isEmpty) {
        return ImageStatusTileData(
          status: ImageStatus.Unchecked,
          statusString: "Please run inference on this image.",
        );
      }
      if (parent.benchmarkImageData?.components.isEmpty ?? true) {
        return ImageStatusTileData(
          status: ImageStatus.Unchecked,
          statusString: "Please run inference on the benchmark image.",
        );
      }
      int numMissingComponents =
          nonOverlappingComponents.missingComponents.length;
      int numExtraComponents = nonOverlappingComponents.extraComponents.length;
      if (numMissingComponents == 0 && numExtraComponents == 0) {
        return ImageStatusTileData(
          status: ImageStatus.Ok,
          statusString: "No component defects found.",
        );
      } else {
        return ImageStatusTileData(
          status: ImageStatus.Faulty,
          statusString:
              "Missing: $numMissingComponents, Extra: $numExtraComponents",
        );
      }
    }
  }

  @action
  void setComponents(List<YoloEntityOutput> components) {
    imageData = imageData.copyWith(components: components);
  }

  @action
  void setIsTracksOnly(bool isTracksOnly) {
    if (isTracksOnly) {
      imageData = imageData.copyWith(tracksOnly: isTracksOnly, components: []);
    } else {
      imageData = imageData.copyWith(
        tracksOnly: isTracksOnly,
        trackDefects: [],
      );
    }
  }

  @action
  void setBenchmarkOverlapThreshold(double benchmarkOverlapThreshold) {
    imageData = imageData.copyWith(
      benchmarkOverlapThreshold: benchmarkOverlapThreshold,
    );
  }

  @action
  void setTrackDefects(List<YoloEntityOutput> trackDefects) {
    imageData = imageData.copyWith(trackDefects: trackDefects);
  }

  @action
  void setTrackDefectDetectionThreshold(double trackDefectDetectionThreshold) {
    imageData = imageData.copyWith(
      trackDefectDetectionThreshold: trackDefectDetectionThreshold,
    );
  }

  @action
  void removeComponent(YoloEntityOutput remVal) {
    var components = imageData.components;
    final idx = components.indexOf(remVal);
    if (idx == -1) return;
    components = List.of(components);
    components.removeAt(idx);
    setComponents(components);
  }

  @action
  void deleteImage() {
    parent.removeImage(folderName);
  }
}
