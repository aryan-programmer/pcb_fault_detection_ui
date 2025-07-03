import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:image/image.dart' as img;
import 'package:pcb_fault_detection_ui/src/utils/logging_timer.dart';

Future<XFile?> showImageOpenDialog(String name) async {
  return await openFile(
    acceptedTypeGroups: [
      XTypeGroup(
        label: "Image File",
        extensions: [
          ".apng",
          ".png ",
          ".avif",
          ".gif",
          ".jpg",
          ".jpeg",
          ".jfif",
          ".pjpeg",
          ".pjp",
          ".png",
          ".webp",
        ],
        mimeTypes: [
          "image/apng",
          "image/gif",
          "image/jpeg",
          "image/png",
          "image/webp",
        ],
      ),
    ],
    confirmButtonText: name,
  );
}

Future<(img.Image, Uint8List)?> readImage(String imagePath) async {
  final timerImage = LoggingTimer("readImage($imagePath)");
  try {
    final command = img.Command()..decodeImageFile(imagePath);
    await command.executeThread();
    final image = await command.getImage();
    if (image == null) return null;
    return (image, image.getBytes(order: img.ChannelOrder.rgb));
  } finally {
    timerImage.log();
  }
}
