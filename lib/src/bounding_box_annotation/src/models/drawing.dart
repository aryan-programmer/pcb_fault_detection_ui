class StartPoint {
  final double dx;
  final double dy;

  StartPoint({
    required this.dx,
    required this.dy,
  });

  factory StartPoint.fromJson(Map<String, dynamic> json) {
    return StartPoint(dx: json["dx"], dy: json["dy"]);
  }
}

class EndPoint {
  final double dx;
  final double dy;

  EndPoint({
    required this.dx,
    required this.dy,
  });

  factory EndPoint.fromJson(Map<String, dynamic> json) {
    return EndPoint(dx: json["dx"], dy: json["dy"]);
  }
}

class Paint {
  final int blendMode;
  final int color;
  final int filterQuality;
  final bool invertColors;
  final bool isAntiAlias;
  final int strokeCap;
  final int strokeJoin;
  final double strokeWidth;
  final int style;

  Paint({
    required this.blendMode,
    required this.color,
    required this.filterQuality,
    required this.invertColors,
    required this.isAntiAlias,
    required this.strokeCap,
    required this.strokeJoin,
    required this.strokeWidth,
    required this.style,
  });

  factory Paint.fromJson(Map<String, dynamic> json) {
    return Paint(
      blendMode: json['blendMode'],
      color: json['color'],
      filterQuality: json['filterQuality'],
      invertColors: json['invertColors'],
      isAntiAlias: json['isAntiAlias'],
      strokeCap: json['strokeCap'],
      strokeJoin: json['strokeJoin'],
      strokeWidth: json['strokeWidth'],
      style: json['style'],
    );
  }
}

class Drawing {
  final String type;
  final StartPoint startPoint;
  final EndPoint endPoint;
  final Paint paint;
  final String label;

  Drawing({
    required this.type,
    required this.startPoint,
    required this.endPoint,
    required this.paint,
    required this.label,
  });

  factory Drawing.fromJson(Map<String, dynamic> json) {
    return Drawing(
      type: json["type"],
      startPoint: StartPoint.fromJson(json["startPoint"]),
      endPoint: EndPoint.fromJson(json["endPoint"]),
      paint: Paint.fromJson(json["paint"]),
      label: json["label"],
    );
  }
}
