// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_adjustment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockAdjustmentModel {

 String get id;@JsonKey(name: 'pharmacy_id') String get pharmacyId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'adjustment_number') String get adjustmentNumber;@JsonKey(name: 'adjustment_date') DateTime get adjustmentDate; List<StockAdjustmentItemModel> get items;@JsonKey(name: 'created_by_id') String? get createdById;@JsonKey(name: 'created_by_name') String? get createdByName; String? get notes;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockAdjustmentModelCopyWith<StockAdjustmentModel> get copyWith => _$StockAdjustmentModelCopyWithImpl<StockAdjustmentModel>(this as StockAdjustmentModel, _$identity);

  /// Serializes this StockAdjustmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pharmacyId, pharmacyId) || other.pharmacyId == pharmacyId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.adjustmentNumber, adjustmentNumber) || other.adjustmentNumber == adjustmentNumber)&&(identical(other.adjustmentDate, adjustmentDate) || other.adjustmentDate == adjustmentDate)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pharmacyId,branchId,adjustmentNumber,adjustmentDate,const DeepCollectionEquality().hash(items),createdById,createdByName,notes,createdAt,updatedAt);

@override
String toString() {
  return 'StockAdjustmentModel(id: $id, pharmacyId: $pharmacyId, branchId: $branchId, adjustmentNumber: $adjustmentNumber, adjustmentDate: $adjustmentDate, items: $items, createdById: $createdById, createdByName: $createdByName, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StockAdjustmentModelCopyWith<$Res>  {
  factory $StockAdjustmentModelCopyWith(StockAdjustmentModel value, $Res Function(StockAdjustmentModel) _then) = _$StockAdjustmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'pharmacy_id') String pharmacyId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'adjustment_number') String adjustmentNumber,@JsonKey(name: 'adjustment_date') DateTime adjustmentDate, List<StockAdjustmentItemModel> items,@JsonKey(name: 'created_by_id') String? createdById,@JsonKey(name: 'created_by_name') String? createdByName, String? notes,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$StockAdjustmentModelCopyWithImpl<$Res>
    implements $StockAdjustmentModelCopyWith<$Res> {
  _$StockAdjustmentModelCopyWithImpl(this._self, this._then);

  final StockAdjustmentModel _self;
  final $Res Function(StockAdjustmentModel) _then;

/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pharmacyId = null,Object? branchId = null,Object? adjustmentNumber = null,Object? adjustmentDate = null,Object? items = null,Object? createdById = freezed,Object? createdByName = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pharmacyId: null == pharmacyId ? _self.pharmacyId : pharmacyId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,adjustmentNumber: null == adjustmentNumber ? _self.adjustmentNumber : adjustmentNumber // ignore: cast_nullable_to_non_nullable
as String,adjustmentDate: null == adjustmentDate ? _self.adjustmentDate : adjustmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StockAdjustmentItemModel>,createdById: freezed == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String?,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StockAdjustmentModel].
extension StockAdjustmentModelPatterns on StockAdjustmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockAdjustmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockAdjustmentModel value)  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockAdjustmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'pharmacy_id')  String pharmacyId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'adjustment_number')  String adjustmentNumber, @JsonKey(name: 'adjustment_date')  DateTime adjustmentDate,  List<StockAdjustmentItemModel> items, @JsonKey(name: 'created_by_id')  String? createdById, @JsonKey(name: 'created_by_name')  String? createdByName,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
return $default(_that.id,_that.pharmacyId,_that.branchId,_that.adjustmentNumber,_that.adjustmentDate,_that.items,_that.createdById,_that.createdByName,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'pharmacy_id')  String pharmacyId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'adjustment_number')  String adjustmentNumber, @JsonKey(name: 'adjustment_date')  DateTime adjustmentDate,  List<StockAdjustmentItemModel> items, @JsonKey(name: 'created_by_id')  String? createdById, @JsonKey(name: 'created_by_name')  String? createdByName,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentModel():
return $default(_that.id,_that.pharmacyId,_that.branchId,_that.adjustmentNumber,_that.adjustmentDate,_that.items,_that.createdById,_that.createdByName,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'pharmacy_id')  String pharmacyId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'adjustment_number')  String adjustmentNumber, @JsonKey(name: 'adjustment_date')  DateTime adjustmentDate,  List<StockAdjustmentItemModel> items, @JsonKey(name: 'created_by_id')  String? createdById, @JsonKey(name: 'created_by_name')  String? createdByName,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
return $default(_that.id,_that.pharmacyId,_that.branchId,_that.adjustmentNumber,_that.adjustmentDate,_that.items,_that.createdById,_that.createdByName,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockAdjustmentModel extends StockAdjustmentModel {
  const _StockAdjustmentModel({required this.id, @JsonKey(name: 'pharmacy_id') required this.pharmacyId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'adjustment_number') required this.adjustmentNumber, @JsonKey(name: 'adjustment_date') required this.adjustmentDate, final  List<StockAdjustmentItemModel> items = const [], @JsonKey(name: 'created_by_id') this.createdById, @JsonKey(name: 'created_by_name') this.createdByName, this.notes, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _items = items,super._();
  factory _StockAdjustmentModel.fromJson(Map<String, dynamic> json) => _$StockAdjustmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'pharmacy_id') final  String pharmacyId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'adjustment_number') final  String adjustmentNumber;
@override@JsonKey(name: 'adjustment_date') final  DateTime adjustmentDate;
 final  List<StockAdjustmentItemModel> _items;
@override@JsonKey() List<StockAdjustmentItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'created_by_id') final  String? createdById;
@override@JsonKey(name: 'created_by_name') final  String? createdByName;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockAdjustmentModelCopyWith<_StockAdjustmentModel> get copyWith => __$StockAdjustmentModelCopyWithImpl<_StockAdjustmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockAdjustmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockAdjustmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pharmacyId, pharmacyId) || other.pharmacyId == pharmacyId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.adjustmentNumber, adjustmentNumber) || other.adjustmentNumber == adjustmentNumber)&&(identical(other.adjustmentDate, adjustmentDate) || other.adjustmentDate == adjustmentDate)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pharmacyId,branchId,adjustmentNumber,adjustmentDate,const DeepCollectionEquality().hash(_items),createdById,createdByName,notes,createdAt,updatedAt);

@override
String toString() {
  return 'StockAdjustmentModel(id: $id, pharmacyId: $pharmacyId, branchId: $branchId, adjustmentNumber: $adjustmentNumber, adjustmentDate: $adjustmentDate, items: $items, createdById: $createdById, createdByName: $createdByName, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StockAdjustmentModelCopyWith<$Res> implements $StockAdjustmentModelCopyWith<$Res> {
  factory _$StockAdjustmentModelCopyWith(_StockAdjustmentModel value, $Res Function(_StockAdjustmentModel) _then) = __$StockAdjustmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'pharmacy_id') String pharmacyId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'adjustment_number') String adjustmentNumber,@JsonKey(name: 'adjustment_date') DateTime adjustmentDate, List<StockAdjustmentItemModel> items,@JsonKey(name: 'created_by_id') String? createdById,@JsonKey(name: 'created_by_name') String? createdByName, String? notes,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$StockAdjustmentModelCopyWithImpl<$Res>
    implements _$StockAdjustmentModelCopyWith<$Res> {
  __$StockAdjustmentModelCopyWithImpl(this._self, this._then);

  final _StockAdjustmentModel _self;
  final $Res Function(_StockAdjustmentModel) _then;

/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pharmacyId = null,Object? branchId = null,Object? adjustmentNumber = null,Object? adjustmentDate = null,Object? items = null,Object? createdById = freezed,Object? createdByName = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StockAdjustmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pharmacyId: null == pharmacyId ? _self.pharmacyId : pharmacyId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,adjustmentNumber: null == adjustmentNumber ? _self.adjustmentNumber : adjustmentNumber // ignore: cast_nullable_to_non_nullable
as String,adjustmentDate: null == adjustmentDate ? _self.adjustmentDate : adjustmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StockAdjustmentItemModel>,createdById: freezed == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String?,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StockAdjustmentItemModel {

 String get id;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'item_name') String? get itemName; String? get barcode;@JsonKey(name: 'unit_id') String? get unitId;@JsonKey(name: 'unit_name') String? get unitName;@JsonKey(name: 'batch_id') String? get batchId;@JsonKey(name: 'batch_number') String? get batchNumber;@JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson) AdjustmentType get type;@JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson) AdjustmentReason get reason; double get quantity;@JsonKey(name: 'unit_cost') double? get unitCost;
/// Create a copy of StockAdjustmentItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockAdjustmentItemModelCopyWith<StockAdjustmentItemModel> get copyWith => _$StockAdjustmentItemModelCopyWithImpl<StockAdjustmentItemModel>(this as StockAdjustmentItemModel, _$identity);

  /// Serializes this StockAdjustmentItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustmentItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemName,barcode,unitId,unitName,batchId,batchNumber,type,reason,quantity,unitCost);

@override
String toString() {
  return 'StockAdjustmentItemModel(id: $id, itemId: $itemId, itemName: $itemName, barcode: $barcode, unitId: $unitId, unitName: $unitName, batchId: $batchId, batchNumber: $batchNumber, type: $type, reason: $reason, quantity: $quantity, unitCost: $unitCost)';
}


}

/// @nodoc
abstract mixin class $StockAdjustmentItemModelCopyWith<$Res>  {
  factory $StockAdjustmentItemModelCopyWith(StockAdjustmentItemModel value, $Res Function(StockAdjustmentItemModel) _then) = _$StockAdjustmentItemModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'item_name') String? itemName, String? barcode,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(name: 'unit_name') String? unitName,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson) AdjustmentType type,@JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson) AdjustmentReason reason, double quantity,@JsonKey(name: 'unit_cost') double? unitCost
});




}
/// @nodoc
class _$StockAdjustmentItemModelCopyWithImpl<$Res>
    implements $StockAdjustmentItemModelCopyWith<$Res> {
  _$StockAdjustmentItemModelCopyWithImpl(this._self, this._then);

  final StockAdjustmentItemModel _self;
  final $Res Function(StockAdjustmentItemModel) _then;

/// Create a copy of StockAdjustmentItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? itemName = freezed,Object? barcode = freezed,Object? unitId = freezed,Object? unitName = freezed,Object? batchId = freezed,Object? batchNumber = freezed,Object? type = null,Object? reason = null,Object? quantity = null,Object? unitCost = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,unitName: freezed == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AdjustmentType,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as AdjustmentReason,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitCost: freezed == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockAdjustmentItemModel].
extension StockAdjustmentItemModelPatterns on StockAdjustmentItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockAdjustmentItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockAdjustmentItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockAdjustmentItemModel value)  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockAdjustmentItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'item_name')  String? itemName,  String? barcode, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'unit_name')  String? unitName, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson)  AdjustmentType type, @JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson)  AdjustmentReason reason,  double quantity, @JsonKey(name: 'unit_cost')  double? unitCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockAdjustmentItemModel() when $default != null:
return $default(_that.id,_that.itemId,_that.itemName,_that.barcode,_that.unitId,_that.unitName,_that.batchId,_that.batchNumber,_that.type,_that.reason,_that.quantity,_that.unitCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'item_name')  String? itemName,  String? barcode, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'unit_name')  String? unitName, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson)  AdjustmentType type, @JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson)  AdjustmentReason reason,  double quantity, @JsonKey(name: 'unit_cost')  double? unitCost)  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentItemModel():
return $default(_that.id,_that.itemId,_that.itemName,_that.barcode,_that.unitId,_that.unitName,_that.batchId,_that.batchNumber,_that.type,_that.reason,_that.quantity,_that.unitCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'item_name')  String? itemName,  String? barcode, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'unit_name')  String? unitName, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson)  AdjustmentType type, @JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson)  AdjustmentReason reason,  double quantity, @JsonKey(name: 'unit_cost')  double? unitCost)?  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentItemModel() when $default != null:
return $default(_that.id,_that.itemId,_that.itemName,_that.barcode,_that.unitId,_that.unitName,_that.batchId,_that.batchNumber,_that.type,_that.reason,_that.quantity,_that.unitCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockAdjustmentItemModel extends StockAdjustmentItemModel {
  const _StockAdjustmentItemModel({required this.id, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'item_name') this.itemName, this.barcode, @JsonKey(name: 'unit_id') this.unitId, @JsonKey(name: 'unit_name') this.unitName, @JsonKey(name: 'batch_id') this.batchId, @JsonKey(name: 'batch_number') this.batchNumber, @JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson) required this.type, @JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson) required this.reason, required this.quantity, @JsonKey(name: 'unit_cost') this.unitCost}): super._();
  factory _StockAdjustmentItemModel.fromJson(Map<String, dynamic> json) => _$StockAdjustmentItemModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'item_name') final  String? itemName;
@override final  String? barcode;
@override@JsonKey(name: 'unit_id') final  String? unitId;
@override@JsonKey(name: 'unit_name') final  String? unitName;
@override@JsonKey(name: 'batch_id') final  String? batchId;
@override@JsonKey(name: 'batch_number') final  String? batchNumber;
@override@JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson) final  AdjustmentType type;
@override@JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson) final  AdjustmentReason reason;
@override final  double quantity;
@override@JsonKey(name: 'unit_cost') final  double? unitCost;

/// Create a copy of StockAdjustmentItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockAdjustmentItemModelCopyWith<_StockAdjustmentItemModel> get copyWith => __$StockAdjustmentItemModelCopyWithImpl<_StockAdjustmentItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockAdjustmentItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockAdjustmentItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemName,barcode,unitId,unitName,batchId,batchNumber,type,reason,quantity,unitCost);

@override
String toString() {
  return 'StockAdjustmentItemModel(id: $id, itemId: $itemId, itemName: $itemName, barcode: $barcode, unitId: $unitId, unitName: $unitName, batchId: $batchId, batchNumber: $batchNumber, type: $type, reason: $reason, quantity: $quantity, unitCost: $unitCost)';
}


}

/// @nodoc
abstract mixin class _$StockAdjustmentItemModelCopyWith<$Res> implements $StockAdjustmentItemModelCopyWith<$Res> {
  factory _$StockAdjustmentItemModelCopyWith(_StockAdjustmentItemModel value, $Res Function(_StockAdjustmentItemModel) _then) = __$StockAdjustmentItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'item_name') String? itemName, String? barcode,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(name: 'unit_name') String? unitName,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson) AdjustmentType type,@JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson) AdjustmentReason reason, double quantity,@JsonKey(name: 'unit_cost') double? unitCost
});




}
/// @nodoc
class __$StockAdjustmentItemModelCopyWithImpl<$Res>
    implements _$StockAdjustmentItemModelCopyWith<$Res> {
  __$StockAdjustmentItemModelCopyWithImpl(this._self, this._then);

  final _StockAdjustmentItemModel _self;
  final $Res Function(_StockAdjustmentItemModel) _then;

/// Create a copy of StockAdjustmentItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? itemName = freezed,Object? barcode = freezed,Object? unitId = freezed,Object? unitName = freezed,Object? batchId = freezed,Object? batchNumber = freezed,Object? type = null,Object? reason = null,Object? quantity = null,Object? unitCost = freezed,}) {
  return _then(_StockAdjustmentItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,unitName: freezed == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AdjustmentType,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as AdjustmentReason,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitCost: freezed == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
