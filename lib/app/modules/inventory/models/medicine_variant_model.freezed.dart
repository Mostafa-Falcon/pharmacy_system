// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_variant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicineVariantModel {

 String get id;@JsonKey(name: 'medicine_id') String get medicineId; String get name; double get price; double get cost; String get sku;@JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson) Map<String, String> get attributes;
/// Create a copy of MedicineVariantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineVariantModelCopyWith<MedicineVariantModel> get copyWith => _$MedicineVariantModelCopyWithImpl<MedicineVariantModel>(this as MedicineVariantModel, _$identity);

  /// Serializes this MedicineVariantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineVariantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.sku, sku) || other.sku == sku)&&const DeepCollectionEquality().equals(other.attributes, attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicineId,name,price,cost,sku,const DeepCollectionEquality().hash(attributes));

@override
String toString() {
  return 'MedicineVariantModel(id: $id, medicineId: $medicineId, name: $name, price: $price, cost: $cost, sku: $sku, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class $MedicineVariantModelCopyWith<$Res>  {
  factory $MedicineVariantModelCopyWith(MedicineVariantModel value, $Res Function(MedicineVariantModel) _then) = _$MedicineVariantModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'medicine_id') String medicineId, String name, double price, double cost, String sku,@JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson) Map<String, String> attributes
});




}
/// @nodoc
class _$MedicineVariantModelCopyWithImpl<$Res>
    implements $MedicineVariantModelCopyWith<$Res> {
  _$MedicineVariantModelCopyWithImpl(this._self, this._then);

  final MedicineVariantModel _self;
  final $Res Function(MedicineVariantModel) _then;

/// Create a copy of MedicineVariantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicineId = null,Object? name = null,Object? price = null,Object? cost = null,Object? sku = null,Object? attributes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicineVariantModel].
extension MedicineVariantModelPatterns on MedicineVariantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineVariantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineVariantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineVariantModel value)  $default,){
final _that = this;
switch (_that) {
case _MedicineVariantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineVariantModel value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineVariantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'medicine_id')  String medicineId,  String name,  double price,  double cost,  String sku, @JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson)  Map<String, String> attributes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineVariantModel() when $default != null:
return $default(_that.id,_that.medicineId,_that.name,_that.price,_that.cost,_that.sku,_that.attributes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'medicine_id')  String medicineId,  String name,  double price,  double cost,  String sku, @JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson)  Map<String, String> attributes)  $default,) {final _that = this;
switch (_that) {
case _MedicineVariantModel():
return $default(_that.id,_that.medicineId,_that.name,_that.price,_that.cost,_that.sku,_that.attributes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'medicine_id')  String medicineId,  String name,  double price,  double cost,  String sku, @JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson)  Map<String, String> attributes)?  $default,) {final _that = this;
switch (_that) {
case _MedicineVariantModel() when $default != null:
return $default(_that.id,_that.medicineId,_that.name,_that.price,_that.cost,_that.sku,_that.attributes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicineVariantModel implements MedicineVariantModel {
  const _MedicineVariantModel({required this.id, @JsonKey(name: 'medicine_id') required this.medicineId, required this.name, required this.price, required this.cost, required this.sku, @JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson) final  Map<String, String> attributes = const {}}): _attributes = attributes;
  factory _MedicineVariantModel.fromJson(Map<String, dynamic> json) => _$MedicineVariantModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'medicine_id') final  String medicineId;
@override final  String name;
@override final  double price;
@override final  double cost;
@override final  String sku;
 final  Map<String, String> _attributes;
@override@JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson) Map<String, String> get attributes {
  if (_attributes is EqualUnmodifiableMapView) return _attributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_attributes);
}


/// Create a copy of MedicineVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineVariantModelCopyWith<_MedicineVariantModel> get copyWith => __$MedicineVariantModelCopyWithImpl<_MedicineVariantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicineVariantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineVariantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.sku, sku) || other.sku == sku)&&const DeepCollectionEquality().equals(other._attributes, _attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicineId,name,price,cost,sku,const DeepCollectionEquality().hash(_attributes));

@override
String toString() {
  return 'MedicineVariantModel(id: $id, medicineId: $medicineId, name: $name, price: $price, cost: $cost, sku: $sku, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class _$MedicineVariantModelCopyWith<$Res> implements $MedicineVariantModelCopyWith<$Res> {
  factory _$MedicineVariantModelCopyWith(_MedicineVariantModel value, $Res Function(_MedicineVariantModel) _then) = __$MedicineVariantModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'medicine_id') String medicineId, String name, double price, double cost, String sku,@JsonKey(fromJson: _stringMapFromJson, toJson: _stringMapToJson) Map<String, String> attributes
});




}
/// @nodoc
class __$MedicineVariantModelCopyWithImpl<$Res>
    implements _$MedicineVariantModelCopyWith<$Res> {
  __$MedicineVariantModelCopyWithImpl(this._self, this._then);

  final _MedicineVariantModel _self;
  final $Res Function(_MedicineVariantModel) _then;

/// Create a copy of MedicineVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicineId = null,Object? name = null,Object? price = null,Object? cost = null,Object? sku = null,Object? attributes = null,}) {
  return _then(_MedicineVariantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self._attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
