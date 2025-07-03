// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectData implements DiagnosticableTreeMixin {

 String? get benchmarkDataFolder;
/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDataCopyWith<ProjectData> get copyWith => _$ProjectDataCopyWithImpl<ProjectData>(this as ProjectData, _$identity);

  /// Serializes this ProjectData to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProjectData'))
    ..add(DiagnosticsProperty('benchmarkDataFolder', benchmarkDataFolder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectData&&(identical(other.benchmarkDataFolder, benchmarkDataFolder) || other.benchmarkDataFolder == benchmarkDataFolder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,benchmarkDataFolder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProjectData(benchmarkDataFolder: $benchmarkDataFolder)';
}


}

/// @nodoc
abstract mixin class $ProjectDataCopyWith<$Res>  {
  factory $ProjectDataCopyWith(ProjectData value, $Res Function(ProjectData) _then) = _$ProjectDataCopyWithImpl;
@useResult
$Res call({
 String? benchmarkDataFolder
});




}
/// @nodoc
class _$ProjectDataCopyWithImpl<$Res>
    implements $ProjectDataCopyWith<$Res> {
  _$ProjectDataCopyWithImpl(this._self, this._then);

  final ProjectData _self;
  final $Res Function(ProjectData) _then;

/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? benchmarkDataFolder = freezed,}) {
  return _then(_self.copyWith(
benchmarkDataFolder: freezed == benchmarkDataFolder ? _self.benchmarkDataFolder : benchmarkDataFolder // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ProjectData with DiagnosticableTreeMixin implements ProjectData {
   _ProjectData({this.benchmarkDataFolder});
  factory _ProjectData.fromJson(Map<String, dynamic> json) => _$ProjectDataFromJson(json);

@override final  String? benchmarkDataFolder;

/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDataCopyWith<_ProjectData> get copyWith => __$ProjectDataCopyWithImpl<_ProjectData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDataToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProjectData'))
    ..add(DiagnosticsProperty('benchmarkDataFolder', benchmarkDataFolder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectData&&(identical(other.benchmarkDataFolder, benchmarkDataFolder) || other.benchmarkDataFolder == benchmarkDataFolder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,benchmarkDataFolder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProjectData(benchmarkDataFolder: $benchmarkDataFolder)';
}


}

/// @nodoc
abstract mixin class _$ProjectDataCopyWith<$Res> implements $ProjectDataCopyWith<$Res> {
  factory _$ProjectDataCopyWith(_ProjectData value, $Res Function(_ProjectData) _then) = __$ProjectDataCopyWithImpl;
@override @useResult
$Res call({
 String? benchmarkDataFolder
});




}
/// @nodoc
class __$ProjectDataCopyWithImpl<$Res>
    implements _$ProjectDataCopyWith<$Res> {
  __$ProjectDataCopyWithImpl(this._self, this._then);

  final _ProjectData _self;
  final $Res Function(_ProjectData) _then;

/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? benchmarkDataFolder = freezed,}) {
  return _then(_ProjectData(
benchmarkDataFolder: freezed == benchmarkDataFolder ? _self.benchmarkDataFolder : benchmarkDataFolder // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
