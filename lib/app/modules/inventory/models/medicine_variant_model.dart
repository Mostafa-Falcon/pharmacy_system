// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine_variant_model.freezed.dart';
part 'medicine_variant_model.g.dart';

@freezed
abstract class MedicineVariantModel with _$MedicineVariantModel {
  const factory MedicineVariantModel({
    required String id,
    @JsonKey(name: 'medicine_id') required String medicineId,
    required String name,
    required double price,
    required double cost,
    required String sku,
    @Default({})
    @JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson)
    Map<String, String> attributes,
  }) = _MedicineVariantModel;

  factory MedicineVariantModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineVariantModelFromJson(json);
}

Map<String, String> _stringMapFromJson(Map<String, dynamic>? json) =>
    json?.map((k, v) => MapEntry(k, v.toString())) ?? {};

Map<String, dynamic> _stringMapToJson(Map<String, String> map) => map;
