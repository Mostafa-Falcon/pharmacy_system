import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_definition_model.freezed.dart';
part 'role_definition_model.g.dart';

@freezed
abstract class RoleDefinitionModel with _$RoleDefinitionModel {
  const factory RoleDefinitionModel({
    required String id,
    required String name,
    String? description,
    required Set<String> permissions,
    @Default(false) bool isSystem,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RoleDefinitionModel;

  factory RoleDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$RoleDefinitionModelFromJson(json);
}
