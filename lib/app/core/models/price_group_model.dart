// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_group_model.freezed.dart';
part 'price_group_model.g.dart';

@freezed
abstract class PriceGroupModel with _$PriceGroupModel {
  const factory PriceGroupModel({
    required String id,
    required String name,
    @JsonKey(name: 'markup_percentage') @Default(0) double markupPercentage,
    @JsonKey(name: 'discount_percentage') @Default(0) double discountPercentage,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _PriceGroupModel;

  factory PriceGroupModel.fromJson(Map<String, dynamic> json) =>
      _$PriceGroupModelFromJson(json);
}
