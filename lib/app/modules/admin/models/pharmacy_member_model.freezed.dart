// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pharmacy_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PharmacyMemberModel {

 String get id; String? get userId; String get name; String get email; String? get phone; String get roleId; Set<String> get branchIds; Set<String> get permissions; bool get isActive; String? get invitationStatus; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PharmacyMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyMemberModelCopyWith<PharmacyMemberModel> get copyWith => _$PharmacyMemberModelCopyWithImpl<PharmacyMemberModel>(this as PharmacyMemberModel, _$identity);

  /// Serializes this PharmacyMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&const DeepCollectionEquality().equals(other.branchIds, branchIds)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.invitationStatus, invitationStatus) || other.invitationStatus == invitationStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,email,phone,roleId,const DeepCollectionEquality().hash(branchIds),const DeepCollectionEquality().hash(permissions),isActive,invitationStatus,createdAt,updatedAt);

@override
String toString() {
  return 'PharmacyMemberModel(id: $id, userId: $userId, name: $name, email: $email, phone: $phone, roleId: $roleId, branchIds: $branchIds, permissions: $permissions, isActive: $isActive, invitationStatus: $invitationStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PharmacyMemberModelCopyWith<$Res>  {
  factory $PharmacyMemberModelCopyWith(PharmacyMemberModel value, $Res Function(PharmacyMemberModel) _then) = _$PharmacyMemberModelCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String name, String email, String? phone, String roleId, Set<String> branchIds, Set<String> permissions, bool isActive, String? invitationStatus, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PharmacyMemberModelCopyWithImpl<$Res>
    implements $PharmacyMemberModelCopyWith<$Res> {
  _$PharmacyMemberModelCopyWithImpl(this._self, this._then);

  final PharmacyMemberModel _self;
  final $Res Function(PharmacyMemberModel) _then;

/// Create a copy of PharmacyMemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? email = null,Object? phone = freezed,Object? roleId = null,Object? branchIds = null,Object? permissions = null,Object? isActive = null,Object? invitationStatus = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,branchIds: null == branchIds ? _self.branchIds : branchIds // ignore: cast_nullable_to_non_nullable
as Set<String>,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,invitationStatus: freezed == invitationStatus ? _self.invitationStatus : invitationStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PharmacyMemberModel].
extension PharmacyMemberModelPatterns on PharmacyMemberModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PharmacyMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PharmacyMemberModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PharmacyMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _PharmacyMemberModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PharmacyMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _PharmacyMemberModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String name,  String email,  String? phone,  String roleId,  Set<String> branchIds,  Set<String> permissions,  bool isActive,  String? invitationStatus,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyMemberModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.email,_that.phone,_that.roleId,_that.branchIds,_that.permissions,_that.isActive,_that.invitationStatus,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String name,  String email,  String? phone,  String roleId,  Set<String> branchIds,  Set<String> permissions,  bool isActive,  String? invitationStatus,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PharmacyMemberModel():
return $default(_that.id,_that.userId,_that.name,_that.email,_that.phone,_that.roleId,_that.branchIds,_that.permissions,_that.isActive,_that.invitationStatus,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String name,  String email,  String? phone,  String roleId,  Set<String> branchIds,  Set<String> permissions,  bool isActive,  String? invitationStatus,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyMemberModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.email,_that.phone,_that.roleId,_that.branchIds,_that.permissions,_that.isActive,_that.invitationStatus,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PharmacyMemberModel extends PharmacyMemberModel {
  const _PharmacyMemberModel({required this.id, this.userId, required this.name, required this.email, this.phone, required this.roleId, required final  Set<String> branchIds, required final  Set<String> permissions, this.isActive = true, this.invitationStatus, required this.createdAt, required this.updatedAt}): _branchIds = branchIds,_permissions = permissions,super._();
  factory _PharmacyMemberModel.fromJson(Map<String, dynamic> json) => _$PharmacyMemberModelFromJson(json);

@override final  String id;
@override final  String? userId;
@override final  String name;
@override final  String email;
@override final  String? phone;
@override final  String roleId;
 final  Set<String> _branchIds;
@override Set<String> get branchIds {
  if (_branchIds is EqualUnmodifiableSetView) return _branchIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_branchIds);
}

 final  Set<String> _permissions;
@override Set<String> get permissions {
  if (_permissions is EqualUnmodifiableSetView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_permissions);
}

@override@JsonKey() final  bool isActive;
@override final  String? invitationStatus;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PharmacyMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyMemberModelCopyWith<_PharmacyMemberModel> get copyWith => __$PharmacyMemberModelCopyWithImpl<_PharmacyMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PharmacyMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&const DeepCollectionEquality().equals(other._branchIds, _branchIds)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.invitationStatus, invitationStatus) || other.invitationStatus == invitationStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,email,phone,roleId,const DeepCollectionEquality().hash(_branchIds),const DeepCollectionEquality().hash(_permissions),isActive,invitationStatus,createdAt,updatedAt);

@override
String toString() {
  return 'PharmacyMemberModel(id: $id, userId: $userId, name: $name, email: $email, phone: $phone, roleId: $roleId, branchIds: $branchIds, permissions: $permissions, isActive: $isActive, invitationStatus: $invitationStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PharmacyMemberModelCopyWith<$Res> implements $PharmacyMemberModelCopyWith<$Res> {
  factory _$PharmacyMemberModelCopyWith(_PharmacyMemberModel value, $Res Function(_PharmacyMemberModel) _then) = __$PharmacyMemberModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String name, String email, String? phone, String roleId, Set<String> branchIds, Set<String> permissions, bool isActive, String? invitationStatus, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PharmacyMemberModelCopyWithImpl<$Res>
    implements _$PharmacyMemberModelCopyWith<$Res> {
  __$PharmacyMemberModelCopyWithImpl(this._self, this._then);

  final _PharmacyMemberModel _self;
  final $Res Function(_PharmacyMemberModel) _then;

/// Create a copy of PharmacyMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? email = null,Object? phone = freezed,Object? roleId = null,Object? branchIds = null,Object? permissions = null,Object? isActive = null,Object? invitationStatus = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PharmacyMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,branchIds: null == branchIds ? _self._branchIds : branchIds // ignore: cast_nullable_to_non_nullable
as Set<String>,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,invitationStatus: freezed == invitationStatus ? _self.invitationStatus : invitationStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
