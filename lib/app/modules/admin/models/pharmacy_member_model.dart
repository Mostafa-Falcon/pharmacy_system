import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharmacy_member_model.freezed.dart';
part 'pharmacy_member_model.g.dart';

@freezed
abstract class PharmacyMemberModel with _$PharmacyMemberModel {
  const PharmacyMemberModel._();

  const factory PharmacyMemberModel({
    required String id,
    String? userId,
    required String name,
    required String email,
    String? phone,
    required String roleId,
    required Set<String> branchIds,
    required Set<String> permissions,
    @Default(true) bool isActive,
    String? invitationStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PharmacyMemberModel;

  factory PharmacyMemberModel.fromJson(Map<String, dynamic> json) =>
      _$PharmacyMemberModelFromJson(json);
}
