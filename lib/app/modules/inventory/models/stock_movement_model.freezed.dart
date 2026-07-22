// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockMovementModel {

 String get id;@JsonKey(name: 'operation_id') String get operationId;@JsonKey(name: 'pharmacy_id') String get pharmacyId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'medicine_id') String get medicineId;@JsonKey(name: 'medicine_name') String? get medicineName;@JsonKey(name: 'batch_id') String? get batchId;@JsonKey(name: 'unit_id') String? get unitId;@JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson) MovementType get type; double get quantity;@JsonKey(name: 'unit_cost') double get unitCost;@JsonKey(name: 'before_quantity') double? get beforeQuantity;@JsonKey(name: 'after_quantity') double? get afterQuantity;@JsonKey(name: 'reference_type') String get referenceType;@JsonKey(name: 'reference_id') String get referenceId;@JsonKey(name: 'actor_id') String get actorId;@JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson) DateTime get occurredAt;
/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementModelCopyWith<StockMovementModel> get copyWith => _$StockMovementModelCopyWithImpl<StockMovementModel>(this as StockMovementModel, _$identity);

  /// Serializes this StockMovementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.pharmacyId, pharmacyId) || other.pharmacyId == pharmacyId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.beforeQuantity, beforeQuantity) || other.beforeQuantity == beforeQuantity)&&(identical(other.afterQuantity, afterQuantity) || other.afterQuantity == afterQuantity)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationId,pharmacyId,branchId,medicineId,medicineName,batchId,unitId,type,quantity,unitCost,beforeQuantity,afterQuantity,referenceType,referenceId,actorId,occurredAt);

@override
String toString() {
  return 'StockMovementModel(id: $id, operationId: $operationId, pharmacyId: $pharmacyId, branchId: $branchId, medicineId: $medicineId, medicineName: $medicineName, batchId: $batchId, unitId: $unitId, type: $type, quantity: $quantity, unitCost: $unitCost, beforeQuantity: $beforeQuantity, afterQuantity: $afterQuantity, referenceType: $referenceType, referenceId: $referenceId, actorId: $actorId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $StockMovementModelCopyWith<$Res>  {
  factory $StockMovementModelCopyWith(StockMovementModel value, $Res Function(StockMovementModel) _then) = _$StockMovementModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'operation_id') String operationId,@JsonKey(name: 'pharmacy_id') String pharmacyId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'medicine_id') String medicineId,@JsonKey(name: 'medicine_name') String? medicineName,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson) MovementType type, double quantity,@JsonKey(name: 'unit_cost') double unitCost,@JsonKey(name: 'before_quantity') double? beforeQuantity,@JsonKey(name: 'after_quantity') double? afterQuantity,@JsonKey(name: 'reference_type') String referenceType,@JsonKey(name: 'reference_id') String referenceId,@JsonKey(name: 'actor_id') String actorId,@JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson) DateTime occurredAt
});




}
/// @nodoc
class _$StockMovementModelCopyWithImpl<$Res>
    implements $StockMovementModelCopyWith<$Res> {
  _$StockMovementModelCopyWithImpl(this._self, this._then);

  final StockMovementModel _self;
  final $Res Function(StockMovementModel) _then;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? operationId = null,Object? pharmacyId = null,Object? branchId = null,Object? medicineId = null,Object? medicineName = freezed,Object? batchId = freezed,Object? unitId = freezed,Object? type = null,Object? quantity = null,Object? unitCost = null,Object? beforeQuantity = freezed,Object? afterQuantity = freezed,Object? referenceType = null,Object? referenceId = null,Object? actorId = null,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,pharmacyId: null == pharmacyId ? _self.pharmacyId : pharmacyId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,medicineName: freezed == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,beforeQuantity: freezed == beforeQuantity ? _self.beforeQuantity : beforeQuantity // ignore: cast_nullable_to_non_nullable
as double?,afterQuantity: freezed == afterQuantity ? _self.afterQuantity : afterQuantity // ignore: cast_nullable_to_non_nullable
as double?,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovementModel].
extension StockMovementModelPatterns on StockMovementModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovementModel value)  $default,){
final _that = this;
switch (_that) {
case _StockMovementModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovementModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'operation_id')  String operationId, @JsonKey(name: 'pharmacy_id')  String pharmacyId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'medicine_id')  String medicineId, @JsonKey(name: 'medicine_name')  String? medicineName, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson)  MovementType type,  double quantity, @JsonKey(name: 'unit_cost')  double unitCost, @JsonKey(name: 'before_quantity')  double? beforeQuantity, @JsonKey(name: 'after_quantity')  double? afterQuantity, @JsonKey(name: 'reference_type')  String referenceType, @JsonKey(name: 'reference_id')  String referenceId, @JsonKey(name: 'actor_id')  String actorId, @JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson)  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
return $default(_that.id,_that.operationId,_that.pharmacyId,_that.branchId,_that.medicineId,_that.medicineName,_that.batchId,_that.unitId,_that.type,_that.quantity,_that.unitCost,_that.beforeQuantity,_that.afterQuantity,_that.referenceType,_that.referenceId,_that.actorId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'operation_id')  String operationId, @JsonKey(name: 'pharmacy_id')  String pharmacyId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'medicine_id')  String medicineId, @JsonKey(name: 'medicine_name')  String? medicineName, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson)  MovementType type,  double quantity, @JsonKey(name: 'unit_cost')  double unitCost, @JsonKey(name: 'before_quantity')  double? beforeQuantity, @JsonKey(name: 'after_quantity')  double? afterQuantity, @JsonKey(name: 'reference_type')  String referenceType, @JsonKey(name: 'reference_id')  String referenceId, @JsonKey(name: 'actor_id')  String actorId, @JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson)  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _StockMovementModel():
return $default(_that.id,_that.operationId,_that.pharmacyId,_that.branchId,_that.medicineId,_that.medicineName,_that.batchId,_that.unitId,_that.type,_that.quantity,_that.unitCost,_that.beforeQuantity,_that.afterQuantity,_that.referenceType,_that.referenceId,_that.actorId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'operation_id')  String operationId, @JsonKey(name: 'pharmacy_id')  String pharmacyId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'medicine_id')  String medicineId, @JsonKey(name: 'medicine_name')  String? medicineName, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson)  MovementType type,  double quantity, @JsonKey(name: 'unit_cost')  double unitCost, @JsonKey(name: 'before_quantity')  double? beforeQuantity, @JsonKey(name: 'after_quantity')  double? afterQuantity, @JsonKey(name: 'reference_type')  String referenceType, @JsonKey(name: 'reference_id')  String referenceId, @JsonKey(name: 'actor_id')  String actorId, @JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson)  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
return $default(_that.id,_that.operationId,_that.pharmacyId,_that.branchId,_that.medicineId,_that.medicineName,_that.batchId,_that.unitId,_that.type,_that.quantity,_that.unitCost,_that.beforeQuantity,_that.afterQuantity,_that.referenceType,_that.referenceId,_that.actorId,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockMovementModel implements StockMovementModel {
  const _StockMovementModel({required this.id, @JsonKey(name: 'operation_id') required this.operationId, @JsonKey(name: 'pharmacy_id') required this.pharmacyId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'medicine_id') required this.medicineId, @JsonKey(name: 'medicine_name') this.medicineName, @JsonKey(name: 'batch_id') this.batchId, @JsonKey(name: 'unit_id') this.unitId, @JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson) required this.type, required this.quantity, @JsonKey(name: 'unit_cost') this.unitCost = 0, @JsonKey(name: 'before_quantity') this.beforeQuantity, @JsonKey(name: 'after_quantity') this.afterQuantity, @JsonKey(name: 'reference_type') required this.referenceType, @JsonKey(name: 'reference_id') required this.referenceId, @JsonKey(name: 'actor_id') required this.actorId, @JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson) required this.occurredAt});
  factory _StockMovementModel.fromJson(Map<String, dynamic> json) => _$StockMovementModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'operation_id') final  String operationId;
@override@JsonKey(name: 'pharmacy_id') final  String pharmacyId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'medicine_id') final  String medicineId;
@override@JsonKey(name: 'medicine_name') final  String? medicineName;
@override@JsonKey(name: 'batch_id') final  String? batchId;
@override@JsonKey(name: 'unit_id') final  String? unitId;
@override@JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson) final  MovementType type;
@override final  double quantity;
@override@JsonKey(name: 'unit_cost') final  double unitCost;
@override@JsonKey(name: 'before_quantity') final  double? beforeQuantity;
@override@JsonKey(name: 'after_quantity') final  double? afterQuantity;
@override@JsonKey(name: 'reference_type') final  String referenceType;
@override@JsonKey(name: 'reference_id') final  String referenceId;
@override@JsonKey(name: 'actor_id') final  String actorId;
@override@JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson) final  DateTime occurredAt;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementModelCopyWith<_StockMovementModel> get copyWith => __$StockMovementModelCopyWithImpl<_StockMovementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockMovementModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.pharmacyId, pharmacyId) || other.pharmacyId == pharmacyId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.beforeQuantity, beforeQuantity) || other.beforeQuantity == beforeQuantity)&&(identical(other.afterQuantity, afterQuantity) || other.afterQuantity == afterQuantity)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationId,pharmacyId,branchId,medicineId,medicineName,batchId,unitId,type,quantity,unitCost,beforeQuantity,afterQuantity,referenceType,referenceId,actorId,occurredAt);

@override
String toString() {
  return 'StockMovementModel(id: $id, operationId: $operationId, pharmacyId: $pharmacyId, branchId: $branchId, medicineId: $medicineId, medicineName: $medicineName, batchId: $batchId, unitId: $unitId, type: $type, quantity: $quantity, unitCost: $unitCost, beforeQuantity: $beforeQuantity, afterQuantity: $afterQuantity, referenceType: $referenceType, referenceId: $referenceId, actorId: $actorId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$StockMovementModelCopyWith<$Res> implements $StockMovementModelCopyWith<$Res> {
  factory _$StockMovementModelCopyWith(_StockMovementModel value, $Res Function(_StockMovementModel) _then) = __$StockMovementModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'operation_id') String operationId,@JsonKey(name: 'pharmacy_id') String pharmacyId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'medicine_id') String medicineId,@JsonKey(name: 'medicine_name') String? medicineName,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson) MovementType type, double quantity,@JsonKey(name: 'unit_cost') double unitCost,@JsonKey(name: 'before_quantity') double? beforeQuantity,@JsonKey(name: 'after_quantity') double? afterQuantity,@JsonKey(name: 'reference_type') String referenceType,@JsonKey(name: 'reference_id') String referenceId,@JsonKey(name: 'actor_id') String actorId,@JsonKey(name: 'occurred_at', fromJson: _parseOccurredAt, toJson: _occurredAtToJson) DateTime occurredAt
});




}
/// @nodoc
class __$StockMovementModelCopyWithImpl<$Res>
    implements _$StockMovementModelCopyWith<$Res> {
  __$StockMovementModelCopyWithImpl(this._self, this._then);

  final _StockMovementModel _self;
  final $Res Function(_StockMovementModel) _then;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? operationId = null,Object? pharmacyId = null,Object? branchId = null,Object? medicineId = null,Object? medicineName = freezed,Object? batchId = freezed,Object? unitId = freezed,Object? type = null,Object? quantity = null,Object? unitCost = null,Object? beforeQuantity = freezed,Object? afterQuantity = freezed,Object? referenceType = null,Object? referenceId = null,Object? actorId = null,Object? occurredAt = null,}) {
  return _then(_StockMovementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,pharmacyId: null == pharmacyId ? _self.pharmacyId : pharmacyId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,medicineName: freezed == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,beforeQuantity: freezed == beforeQuantity ? _self.beforeQuantity : beforeQuantity // ignore: cast_nullable_to_non_nullable
as double?,afterQuantity: freezed == afterQuantity ? _self.afterQuantity : afterQuantity // ignore: cast_nullable_to_non_nullable
as double?,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
