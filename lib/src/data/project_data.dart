// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_data.freezed.dart';
part 'project_data.g.dart';

@freezed
abstract class ProjectData with _$ProjectData {
  factory ProjectData({String? benchmarkDataFolder}) = _ProjectData;

  factory ProjectData.fromJson(Map<String, dynamic> json) =>
      _$ProjectDataFromJson(json);
}
