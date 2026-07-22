// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_definition_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoleDefinitionModel {

 String get id; String get name; String? get description; Set<String> get permissions; bool get isSystem; bool get isActive; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RoleDefinitionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleDefinitionModelCopyWith<RoleDefinitionModel> get copyWith => _$RoleDefinitionModelCopyWithImpl<RoleDefinitionModel>(this as RoleDefinitionModel, _$identity);

  /// Serializes this RoleDefinitionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleDefinitionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(permissions),isSystem,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'RoleDefinitionModel(id: $id, name: $name, description: $description, permissions: $permissions, isSystem: $isSystem, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RoleDefinitionModelCopyWith<$Res>  {
  factory $RoleDefinitionModelCopyWith(RoleDefinitionModel value, $Res Function(RoleDefinitionModel) _then) = _$RoleDefinitionModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, Set<String> permissions, bool isSystem, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RoleDefinitionModelCopyWithImpl<$Res>
    implements $RoleDefinitionModelCopyWith<$Res> {
  _$RoleDefinitionModelCopyWithImpl(this._self, this._then);

  final RoleDefinitionModel _self;
  final $Res Function(RoleDefinitionModel) _then;

/// Create a copy of RoleDefinitionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? permissions = null,Object? isSystem = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleDefinitionModel].
extension RoleDefinitionModelPatterns on RoleDefinitionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleDefinitionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleDefinitionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleDefinitionModel value)  $default,){
final _that = this;
switch (_that) {
case _RoleDefinitionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleDefinitionModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoleDefinitionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  Set<String> permissions,  bool isSystem,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleDefinitionModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.permissions,_that.isSystem,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  Set<String> permissions,  bool isSystem,  bool isActive,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RoleDefinitionModel():
return $default(_that.id,_that.name,_that.description,_that.permissions,_that.isSystem,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  Set<String> permissions,  bool isSystem,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RoleDefinitionModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.permissions,_that.isSystem,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoleDefinitionModel implements RoleDefinitionModel {
  const _RoleDefinitionModel({required this.id, required this.name, this.description, required final  Set<String> permissions, this.isSystem = false, this.isActive = true, required this.createdAt, required this.updatedAt}): _permissions = permissions;
  factory _RoleDefinitionModel.fromJson(Map<String, dynamic> json) => _$RoleDefinitionModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
 final  Set<String> _permissions;
@override Set<String> get permissions {
  if (_permissions is EqualUnmodifiableSetView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_permissions);
}

@override@JsonKey() final  bool isSystem;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RoleDefinitionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleDefinitionModelCopyWith<_RoleDefinitionModel> get copyWith => __$RoleDefinitionModelCopyWithImpl<_RoleDefinitionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleDefinitionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleDefinitionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_permissions),isSystem,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'RoleDefinitionModel(id: $id, name: $name, description: $description, permissions: $permissions, isSystem: $isSystem, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RoleDefinitionModelCopyWith<$Res> implements $RoleDefinitionModelCopyWith<$Res> {
  factory _$RoleDefinitionModelCopyWith(_RoleDefinitionModel value, $Res Function(_RoleDefinitionModel) _then) = __$RoleDefinitionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, Set<String> permissions, bool isSystem, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RoleDefinitionModelCopyWithImpl<$Res>
    implements _$RoleDefinitionModelCopyWith<$Res> {
  __$RoleDefinitionModelCopyWithImpl(this._self, this._then);

  final _RoleDefinitionModel _self;
  final $Res Function(_RoleDefinitionModel) _then;

/// Create a copy of RoleDefinitionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? permissions = null,Object? isSystem = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RoleDefinitionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
