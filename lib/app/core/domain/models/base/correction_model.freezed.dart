// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'correction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CorrectionEntry {

 String get id;@JsonKey(name: 'reference_type') CorrectionReferenceType get referenceType;@JsonKey(name: 'reference_id') String get referenceId; CorrectionAction get action;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'user_display_name') String get userDisplayName; DateTime get timestamp; String? get details;
/// Create a copy of CorrectionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorrectionEntryCopyWith<CorrectionEntry> get copyWith => _$CorrectionEntryCopyWithImpl<CorrectionEntry>(this as CorrectionEntry, _$identity);

  /// Serializes this CorrectionEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorrectionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.action, action) || other.action == action)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referenceType,referenceId,action,userId,userDisplayName,timestamp,details);

@override
String toString() {
  return 'CorrectionEntry(id: $id, referenceType: $referenceType, referenceId: $referenceId, action: $action, userId: $userId, userDisplayName: $userDisplayName, timestamp: $timestamp, details: $details)';
}


}

/// @nodoc
abstract mixin class $CorrectionEntryCopyWith<$Res>  {
  factory $CorrectionEntryCopyWith(CorrectionEntry value, $Res Function(CorrectionEntry) _then) = _$CorrectionEntryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'reference_type') CorrectionReferenceType referenceType,@JsonKey(name: 'reference_id') String referenceId, CorrectionAction action,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'user_display_name') String userDisplayName, DateTime timestamp, String? details
});




}
/// @nodoc
class _$CorrectionEntryCopyWithImpl<$Res>
    implements $CorrectionEntryCopyWith<$Res> {
  _$CorrectionEntryCopyWithImpl(this._self, this._then);

  final CorrectionEntry _self;
  final $Res Function(CorrectionEntry) _then;

/// Create a copy of CorrectionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referenceType = null,Object? referenceId = null,Object? action = null,Object? userId = null,Object? userDisplayName = null,Object? timestamp = null,Object? details = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as CorrectionReferenceType,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CorrectionAction,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userDisplayName: null == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CorrectionEntry].
extension CorrectionEntryPatterns on CorrectionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorrectionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorrectionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorrectionEntry value)  $default,){
final _that = this;
switch (_that) {
case _CorrectionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorrectionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CorrectionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'reference_type')  CorrectionReferenceType referenceType, @JsonKey(name: 'reference_id')  String referenceId,  CorrectionAction action, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_display_name')  String userDisplayName,  DateTime timestamp,  String? details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorrectionEntry() when $default != null:
return $default(_that.id,_that.referenceType,_that.referenceId,_that.action,_that.userId,_that.userDisplayName,_that.timestamp,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'reference_type')  CorrectionReferenceType referenceType, @JsonKey(name: 'reference_id')  String referenceId,  CorrectionAction action, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_display_name')  String userDisplayName,  DateTime timestamp,  String? details)  $default,) {final _that = this;
switch (_that) {
case _CorrectionEntry():
return $default(_that.id,_that.referenceType,_that.referenceId,_that.action,_that.userId,_that.userDisplayName,_that.timestamp,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'reference_type')  CorrectionReferenceType referenceType, @JsonKey(name: 'reference_id')  String referenceId,  CorrectionAction action, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'user_display_name')  String userDisplayName,  DateTime timestamp,  String? details)?  $default,) {final _that = this;
switch (_that) {
case _CorrectionEntry() when $default != null:
return $default(_that.id,_that.referenceType,_that.referenceId,_that.action,_that.userId,_that.userDisplayName,_that.timestamp,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorrectionEntry extends CorrectionEntry {
  const _CorrectionEntry({required this.id, @JsonKey(name: 'reference_type') required this.referenceType, @JsonKey(name: 'reference_id') required this.referenceId, required this.action, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'user_display_name') required this.userDisplayName, required this.timestamp, this.details}): super._();
  factory _CorrectionEntry.fromJson(Map<String, dynamic> json) => _$CorrectionEntryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'reference_type') final  CorrectionReferenceType referenceType;
@override@JsonKey(name: 'reference_id') final  String referenceId;
@override final  CorrectionAction action;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'user_display_name') final  String userDisplayName;
@override final  DateTime timestamp;
@override final  String? details;

/// Create a copy of CorrectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorrectionEntryCopyWith<_CorrectionEntry> get copyWith => __$CorrectionEntryCopyWithImpl<_CorrectionEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorrectionEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorrectionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.action, action) || other.action == action)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referenceType,referenceId,action,userId,userDisplayName,timestamp,details);

@override
String toString() {
  return 'CorrectionEntry(id: $id, referenceType: $referenceType, referenceId: $referenceId, action: $action, userId: $userId, userDisplayName: $userDisplayName, timestamp: $timestamp, details: $details)';
}


}

/// @nodoc
abstract mixin class _$CorrectionEntryCopyWith<$Res> implements $CorrectionEntryCopyWith<$Res> {
  factory _$CorrectionEntryCopyWith(_CorrectionEntry value, $Res Function(_CorrectionEntry) _then) = __$CorrectionEntryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'reference_type') CorrectionReferenceType referenceType,@JsonKey(name: 'reference_id') String referenceId, CorrectionAction action,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'user_display_name') String userDisplayName, DateTime timestamp, String? details
});




}
/// @nodoc
class __$CorrectionEntryCopyWithImpl<$Res>
    implements _$CorrectionEntryCopyWith<$Res> {
  __$CorrectionEntryCopyWithImpl(this._self, this._then);

  final _CorrectionEntry _self;
  final $Res Function(_CorrectionEntry) _then;

/// Create a copy of CorrectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referenceType = null,Object? referenceId = null,Object? action = null,Object? userId = null,Object? userDisplayName = null,Object? timestamp = null,Object? details = freezed,}) {
  return _then(_CorrectionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as CorrectionReferenceType,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CorrectionAction,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userDisplayName: null == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
