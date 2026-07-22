// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceGroupModel {

 String get id; String get name;@JsonKey(name: 'markup_percentage') double get markupPercentage;@JsonKey(name: 'discount_percentage') double get discountPercentage;@JsonKey(name: 'is_default') bool get isDefault;
/// Create a copy of PriceGroupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceGroupModelCopyWith<PriceGroupModel> get copyWith => _$PriceGroupModelCopyWithImpl<PriceGroupModel>(this as PriceGroupModel, _$identity);

  /// Serializes this PriceGroupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceGroupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.markupPercentage, markupPercentage) || other.markupPercentage == markupPercentage)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,markupPercentage,discountPercentage,isDefault);

@override
String toString() {
  return 'PriceGroupModel(id: $id, name: $name, markupPercentage: $markupPercentage, discountPercentage: $discountPercentage, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $PriceGroupModelCopyWith<$Res>  {
  factory $PriceGroupModelCopyWith(PriceGroupModel value, $Res Function(PriceGroupModel) _then) = _$PriceGroupModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'markup_percentage') double markupPercentage,@JsonKey(name: 'discount_percentage') double discountPercentage,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class _$PriceGroupModelCopyWithImpl<$Res>
    implements $PriceGroupModelCopyWith<$Res> {
  _$PriceGroupModelCopyWithImpl(this._self, this._then);

  final PriceGroupModel _self;
  final $Res Function(PriceGroupModel) _then;

/// Create a copy of PriceGroupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? markupPercentage = null,Object? discountPercentage = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,markupPercentage: null == markupPercentage ? _self.markupPercentage : markupPercentage // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceGroupModel].
extension PriceGroupModelPatterns on PriceGroupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceGroupModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceGroupModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceGroupModel value)  $default,){
final _that = this;
switch (_that) {
case _PriceGroupModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceGroupModel value)?  $default,){
final _that = this;
switch (_that) {
case _PriceGroupModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'markup_percentage')  double markupPercentage, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'is_default')  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceGroupModel() when $default != null:
return $default(_that.id,_that.name,_that.markupPercentage,_that.discountPercentage,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'markup_percentage')  double markupPercentage, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'is_default')  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _PriceGroupModel():
return $default(_that.id,_that.name,_that.markupPercentage,_that.discountPercentage,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'markup_percentage')  double markupPercentage, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'is_default')  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _PriceGroupModel() when $default != null:
return $default(_that.id,_that.name,_that.markupPercentage,_that.discountPercentage,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceGroupModel implements PriceGroupModel {
  const _PriceGroupModel({required this.id, required this.name, @JsonKey(name: 'markup_percentage') this.markupPercentage = 0, @JsonKey(name: 'discount_percentage') this.discountPercentage = 0, @JsonKey(name: 'is_default') this.isDefault = false});
  factory _PriceGroupModel.fromJson(Map<String, dynamic> json) => _$PriceGroupModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'markup_percentage') final  double markupPercentage;
@override@JsonKey(name: 'discount_percentage') final  double discountPercentage;
@override@JsonKey(name: 'is_default') final  bool isDefault;

/// Create a copy of PriceGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceGroupModelCopyWith<_PriceGroupModel> get copyWith => __$PriceGroupModelCopyWithImpl<_PriceGroupModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceGroupModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceGroupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.markupPercentage, markupPercentage) || other.markupPercentage == markupPercentage)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,markupPercentage,discountPercentage,isDefault);

@override
String toString() {
  return 'PriceGroupModel(id: $id, name: $name, markupPercentage: $markupPercentage, discountPercentage: $discountPercentage, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$PriceGroupModelCopyWith<$Res> implements $PriceGroupModelCopyWith<$Res> {
  factory _$PriceGroupModelCopyWith(_PriceGroupModel value, $Res Function(_PriceGroupModel) _then) = __$PriceGroupModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'markup_percentage') double markupPercentage,@JsonKey(name: 'discount_percentage') double discountPercentage,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class __$PriceGroupModelCopyWithImpl<$Res>
    implements _$PriceGroupModelCopyWith<$Res> {
  __$PriceGroupModelCopyWithImpl(this._self, this._then);

  final _PriceGroupModel _self;
  final $Res Function(_PriceGroupModel) _then;

/// Create a copy of PriceGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? markupPercentage = null,Object? discountPercentage = null,Object? isDefault = null,}) {
  return _then(_PriceGroupModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,markupPercentage: null == markupPercentage ? _self.markupPercentage : markupPercentage // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
