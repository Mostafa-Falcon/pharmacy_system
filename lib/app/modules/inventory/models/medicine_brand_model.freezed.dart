// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_brand_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicineBrandModel {

 String get id; String get name; String? get description; String? get logo;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of MedicineBrandModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineBrandModelCopyWith<MedicineBrandModel> get copyWith => _$MedicineBrandModelCopyWithImpl<MedicineBrandModel>(this as MedicineBrandModel, _$identity);

  /// Serializes this MedicineBrandModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineBrandModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,logo,createdAt);

@override
String toString() {
  return 'MedicineBrandModel(id: $id, name: $name, description: $description, logo: $logo, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MedicineBrandModelCopyWith<$Res>  {
  factory $MedicineBrandModelCopyWith(MedicineBrandModel value, $Res Function(MedicineBrandModel) _then) = _$MedicineBrandModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? logo,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$MedicineBrandModelCopyWithImpl<$Res>
    implements $MedicineBrandModelCopyWith<$Res> {
  _$MedicineBrandModelCopyWithImpl(this._self, this._then);

  final MedicineBrandModel _self;
  final $Res Function(MedicineBrandModel) _then;

/// Create a copy of MedicineBrandModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? logo = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicineBrandModel].
extension MedicineBrandModelPatterns on MedicineBrandModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineBrandModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineBrandModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineBrandModel value)  $default,){
final _that = this;
switch (_that) {
case _MedicineBrandModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineBrandModel value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineBrandModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? logo, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineBrandModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.logo,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? logo, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MedicineBrandModel():
return $default(_that.id,_that.name,_that.description,_that.logo,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? logo, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicineBrandModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.logo,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicineBrandModel implements MedicineBrandModel {
  const _MedicineBrandModel({required this.id, required this.name, this.description, this.logo, @JsonKey(name: 'created_at') required this.createdAt});
  factory _MedicineBrandModel.fromJson(Map<String, dynamic> json) => _$MedicineBrandModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? logo;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of MedicineBrandModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineBrandModelCopyWith<_MedicineBrandModel> get copyWith => __$MedicineBrandModelCopyWithImpl<_MedicineBrandModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicineBrandModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineBrandModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,logo,createdAt);

@override
String toString() {
  return 'MedicineBrandModel(id: $id, name: $name, description: $description, logo: $logo, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MedicineBrandModelCopyWith<$Res> implements $MedicineBrandModelCopyWith<$Res> {
  factory _$MedicineBrandModelCopyWith(_MedicineBrandModel value, $Res Function(_MedicineBrandModel) _then) = __$MedicineBrandModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? logo,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$MedicineBrandModelCopyWithImpl<$Res>
    implements _$MedicineBrandModelCopyWith<$Res> {
  __$MedicineBrandModelCopyWithImpl(this._self, this._then);

  final _MedicineBrandModel _self;
  final $Res Function(_MedicineBrandModel) _then;

/// Create a copy of MedicineBrandModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? logo = freezed,Object? createdAt = null,}) {
  return _then(_MedicineBrandModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
