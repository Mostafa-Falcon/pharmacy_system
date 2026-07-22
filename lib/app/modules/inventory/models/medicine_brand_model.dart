// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine_brand_model.freezed.dart';
part 'medicine_brand_model.g.dart';

@freezed
abstract class MedicineBrandModel with _$MedicineBrandModel {
  const factory MedicineBrandModel({
    required String id,
    required String name,
    String? description,
    String? logo,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MedicineBrandModel;

  factory MedicineBrandModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineBrandModelFromJson(json);
}
