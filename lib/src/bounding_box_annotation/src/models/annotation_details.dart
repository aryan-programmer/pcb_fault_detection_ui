import 'dart:typed_data';

import 'package:flutter/material.dart';

class AnnotationDetails {
  final Offset p1;
  final Offset p2;
  final Offset p3;
  final Offset p4;
  final String label;
  final Uint8List image;

  AnnotationDetails({
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p4,
    required this.label,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "p1": {"dx": p1.dx, "dy": p2.dy},
      "p2": {"dx": p2.dx, "dy": p2.dy},
      "p3": {"dx": p3.dx, "dy": p3.dy},
      "p4": {"dx": p4.dx, "dy": p4.dy},
      "label": label,
    };
  }
}
