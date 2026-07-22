// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_transfer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockTransferItemModel {

@JsonKey(name: 'medicine_id') String get medicineId;@JsonKey(name: 'medicine_name') String get medicineName; int get quantity;@JsonKey(name: 'unit_cost') double get unitCost; String? get barcode;@JsonKey(name: 'batch_id') String? get batchId;@JsonKey(name: 'batch_number') String? get batchNumber;
/// Create a copy of StockTransferItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockTransferItemModelCopyWith<StockTransferItemModel> get copyWith => _$StockTransferItemModelCopyWithImpl<StockTransferItemModel>(this as StockTransferItemModel, _$identity);

  /// Serializes this StockTransferItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockTransferItemModel&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicineId,medicineName,quantity,unitCost,barcode,batchId,batchNumber);

@override
String toString() {
  return 'StockTransferItemModel(medicineId: $medicineId, medicineName: $medicineName, quantity: $quantity, unitCost: $unitCost, barcode: $barcode, batchId: $batchId, batchNumber: $batchNumber)';
}


}

/// @nodoc
abstract mixin class $StockTransferItemModelCopyWith<$Res>  {
  factory $StockTransferItemModelCopyWith(StockTransferItemModel value, $Res Function(StockTransferItemModel) _then) = _$StockTransferItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'medicine_id') String medicineId,@JsonKey(name: 'medicine_name') String medicineName, int quantity,@JsonKey(name: 'unit_cost') double unitCost, String? barcode,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'batch_number') String? batchNumber
});




}
/// @nodoc
class _$StockTransferItemModelCopyWithImpl<$Res>
    implements $StockTransferItemModelCopyWith<$Res> {
  _$StockTransferItemModelCopyWithImpl(this._self, this._then);

  final StockTransferItemModel _self;
  final $Res Function(StockTransferItemModel) _then;

/// Create a copy of StockTransferItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? medicineName = null,Object? quantity = null,Object? unitCost = null,Object? barcode = freezed,Object? batchId = freezed,Object? batchNumber = freezed,}) {
  return _then(_self.copyWith(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockTransferItemModel].
extension StockTransferItemModelPatterns on StockTransferItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockTransferItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockTransferItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockTransferItemModel value)  $default,){
final _that = this;
switch (_that) {
case _StockTransferItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockTransferItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockTransferItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'medicine_id')  String medicineId, @JsonKey(name: 'medicine_name')  String medicineName,  int quantity, @JsonKey(name: 'unit_cost')  double unitCost,  String? barcode, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_number')  String? batchNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockTransferItemModel() when $default != null:
return $default(_that.medicineId,_that.medicineName,_that.quantity,_that.unitCost,_that.barcode,_that.batchId,_that.batchNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'medicine_id')  String medicineId, @JsonKey(name: 'medicine_name')  String medicineName,  int quantity, @JsonKey(name: 'unit_cost')  double unitCost,  String? barcode, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_number')  String? batchNumber)  $default,) {final _that = this;
switch (_that) {
case _StockTransferItemModel():
return $default(_that.medicineId,_that.medicineName,_that.quantity,_that.unitCost,_that.barcode,_that.batchId,_that.batchNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'medicine_id')  String medicineId, @JsonKey(name: 'medicine_name')  String medicineName,  int quantity, @JsonKey(name: 'unit_cost')  double unitCost,  String? barcode, @JsonKey(name: 'batch_id')  String? batchId, @JsonKey(name: 'batch_number')  String? batchNumber)?  $default,) {final _that = this;
switch (_that) {
case _StockTransferItemModel() when $default != null:
return $default(_that.medicineId,_that.medicineName,_that.quantity,_that.unitCost,_that.barcode,_that.batchId,_that.batchNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockTransferItemModel extends StockTransferItemModel {
  const _StockTransferItemModel({@JsonKey(name: 'medicine_id') required this.medicineId, @JsonKey(name: 'medicine_name') required this.medicineName, required this.quantity, @JsonKey(name: 'unit_cost') required this.unitCost, this.barcode, @JsonKey(name: 'batch_id') this.batchId, @JsonKey(name: 'batch_number') this.batchNumber}): super._();
  factory _StockTransferItemModel.fromJson(Map<String, dynamic> json) => _$StockTransferItemModelFromJson(json);

@override@JsonKey(name: 'medicine_id') final  String medicineId;
@override@JsonKey(name: 'medicine_name') final  String medicineName;
@override final  int quantity;
@override@JsonKey(name: 'unit_cost') final  double unitCost;
@override final  String? barcode;
@override@JsonKey(name: 'batch_id') final  String? batchId;
@override@JsonKey(name: 'batch_number') final  String? batchNumber;

/// Create a copy of StockTransferItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockTransferItemModelCopyWith<_StockTransferItemModel> get copyWith => __$StockTransferItemModelCopyWithImpl<_StockTransferItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockTransferItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockTransferItemModel&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicineId,medicineName,quantity,unitCost,barcode,batchId,batchNumber);

@override
String toString() {
  return 'StockTransferItemModel(medicineId: $medicineId, medicineName: $medicineName, quantity: $quantity, unitCost: $unitCost, barcode: $barcode, batchId: $batchId, batchNumber: $batchNumber)';
}


}

/// @nodoc
abstract mixin class _$StockTransferItemModelCopyWith<$Res> implements $StockTransferItemModelCopyWith<$Res> {
  factory _$StockTransferItemModelCopyWith(_StockTransferItemModel value, $Res Function(_StockTransferItemModel) _then) = __$StockTransferItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'medicine_id') String medicineId,@JsonKey(name: 'medicine_name') String medicineName, int quantity,@JsonKey(name: 'unit_cost') double unitCost, String? barcode,@JsonKey(name: 'batch_id') String? batchId,@JsonKey(name: 'batch_number') String? batchNumber
});




}
/// @nodoc
class __$StockTransferItemModelCopyWithImpl<$Res>
    implements _$StockTransferItemModelCopyWith<$Res> {
  __$StockTransferItemModelCopyWithImpl(this._self, this._then);

  final _StockTransferItemModel _self;
  final $Res Function(_StockTransferItemModel) _then;

/// Create a copy of StockTransferItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? medicineName = null,Object? quantity = null,Object? unitCost = null,Object? barcode = freezed,Object? batchId = freezed,Object? batchNumber = freezed,}) {
  return _then(_StockTransferItemModel(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StockTransferModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'from_branch_id') String get fromBranchId;@JsonKey(name: 'to_branch_id') String get toBranchId;@JsonKey(name: 'from_branch_name') String get fromBranchName;@JsonKey(name: 'to_branch_name') String get toBranchName;@JsonKey(name: 'transfer_number') int get transferNumber; List<StockTransferItemModel> get items;@JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson) TransferStatus get status; String? get notes;@JsonKey(name: 'created_by') String get createdBy;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(name: 'received_at') DateTime? get receivedAt;@JsonKey(name: 'received_by') String? get receivedBy;
/// Create a copy of StockTransferModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockTransferModelCopyWith<StockTransferModel> get copyWith => _$StockTransferModelCopyWithImpl<StockTransferModel>(this as StockTransferModel, _$identity);

  /// Serializes this StockTransferModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockTransferModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.fromBranchId, fromBranchId) || other.fromBranchId == fromBranchId)&&(identical(other.toBranchId, toBranchId) || other.toBranchId == toBranchId)&&(identical(other.fromBranchName, fromBranchName) || other.fromBranchName == fromBranchName)&&(identical(other.toBranchName, toBranchName) || other.toBranchName == toBranchName)&&(identical(other.transferNumber, transferNumber) || other.transferNumber == transferNumber)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.receivedBy, receivedBy) || other.receivedBy == receivedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,fromBranchId,toBranchId,fromBranchName,toBranchName,transferNumber,const DeepCollectionEquality().hash(items),status,notes,createdBy,createdAt,updatedAt,receivedAt,receivedBy);

@override
String toString() {
  return 'StockTransferModel(id: $id, branchId: $branchId, fromBranchId: $fromBranchId, toBranchId: $toBranchId, fromBranchName: $fromBranchName, toBranchName: $toBranchName, transferNumber: $transferNumber, items: $items, status: $status, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, receivedAt: $receivedAt, receivedBy: $receivedBy)';
}


}

/// @nodoc
abstract mixin class $StockTransferModelCopyWith<$Res>  {
  factory $StockTransferModelCopyWith(StockTransferModel value, $Res Function(StockTransferModel) _then) = _$StockTransferModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'from_branch_id') String fromBranchId,@JsonKey(name: 'to_branch_id') String toBranchId,@JsonKey(name: 'from_branch_name') String fromBranchName,@JsonKey(name: 'to_branch_name') String toBranchName,@JsonKey(name: 'transfer_number') int transferNumber, List<StockTransferItemModel> items,@JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson) TransferStatus status, String? notes,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'received_at') DateTime? receivedAt,@JsonKey(name: 'received_by') String? receivedBy
});




}
/// @nodoc
class _$StockTransferModelCopyWithImpl<$Res>
    implements $StockTransferModelCopyWith<$Res> {
  _$StockTransferModelCopyWithImpl(this._self, this._then);

  final StockTransferModel _self;
  final $Res Function(StockTransferModel) _then;

/// Create a copy of StockTransferModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? fromBranchId = null,Object? toBranchId = null,Object? fromBranchName = null,Object? toBranchName = null,Object? transferNumber = null,Object? items = null,Object? status = null,Object? notes = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? receivedAt = freezed,Object? receivedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,fromBranchId: null == fromBranchId ? _self.fromBranchId : fromBranchId // ignore: cast_nullable_to_non_nullable
as String,toBranchId: null == toBranchId ? _self.toBranchId : toBranchId // ignore: cast_nullable_to_non_nullable
as String,fromBranchName: null == fromBranchName ? _self.fromBranchName : fromBranchName // ignore: cast_nullable_to_non_nullable
as String,toBranchName: null == toBranchName ? _self.toBranchName : toBranchName // ignore: cast_nullable_to_non_nullable
as String,transferNumber: null == transferNumber ? _self.transferNumber : transferNumber // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StockTransferItemModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedBy: freezed == receivedBy ? _self.receivedBy : receivedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockTransferModel].
extension StockTransferModelPatterns on StockTransferModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockTransferModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockTransferModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockTransferModel value)  $default,){
final _that = this;
switch (_that) {
case _StockTransferModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockTransferModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockTransferModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'from_branch_id')  String fromBranchId, @JsonKey(name: 'to_branch_id')  String toBranchId, @JsonKey(name: 'from_branch_name')  String fromBranchName, @JsonKey(name: 'to_branch_name')  String toBranchName, @JsonKey(name: 'transfer_number')  int transferNumber,  List<StockTransferItemModel> items, @JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson)  TransferStatus status,  String? notes, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'received_at')  DateTime? receivedAt, @JsonKey(name: 'received_by')  String? receivedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockTransferModel() when $default != null:
return $default(_that.id,_that.branchId,_that.fromBranchId,_that.toBranchId,_that.fromBranchName,_that.toBranchName,_that.transferNumber,_that.items,_that.status,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt,_that.receivedAt,_that.receivedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'from_branch_id')  String fromBranchId, @JsonKey(name: 'to_branch_id')  String toBranchId, @JsonKey(name: 'from_branch_name')  String fromBranchName, @JsonKey(name: 'to_branch_name')  String toBranchName, @JsonKey(name: 'transfer_number')  int transferNumber,  List<StockTransferItemModel> items, @JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson)  TransferStatus status,  String? notes, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'received_at')  DateTime? receivedAt, @JsonKey(name: 'received_by')  String? receivedBy)  $default,) {final _that = this;
switch (_that) {
case _StockTransferModel():
return $default(_that.id,_that.branchId,_that.fromBranchId,_that.toBranchId,_that.fromBranchName,_that.toBranchName,_that.transferNumber,_that.items,_that.status,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt,_that.receivedAt,_that.receivedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'from_branch_id')  String fromBranchId, @JsonKey(name: 'to_branch_id')  String toBranchId, @JsonKey(name: 'from_branch_name')  String fromBranchName, @JsonKey(name: 'to_branch_name')  String toBranchName, @JsonKey(name: 'transfer_number')  int transferNumber,  List<StockTransferItemModel> items, @JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson)  TransferStatus status,  String? notes, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'received_at')  DateTime? receivedAt, @JsonKey(name: 'received_by')  String? receivedBy)?  $default,) {final _that = this;
switch (_that) {
case _StockTransferModel() when $default != null:
return $default(_that.id,_that.branchId,_that.fromBranchId,_that.toBranchId,_that.fromBranchName,_that.toBranchName,_that.transferNumber,_that.items,_that.status,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt,_that.receivedAt,_that.receivedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockTransferModel extends StockTransferModel {
  const _StockTransferModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'from_branch_id') required this.fromBranchId, @JsonKey(name: 'to_branch_id') required this.toBranchId, @JsonKey(name: 'from_branch_name') required this.fromBranchName, @JsonKey(name: 'to_branch_name') required this.toBranchName, @JsonKey(name: 'transfer_number') required this.transferNumber, required final  List<StockTransferItemModel> items, @JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson) this.status = TransferStatus.draft, this.notes, @JsonKey(name: 'created_by') required this.createdBy, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'received_at') this.receivedAt, @JsonKey(name: 'received_by') this.receivedBy}): _items = items,super._();
  factory _StockTransferModel.fromJson(Map<String, dynamic> json) => _$StockTransferModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'from_branch_id') final  String fromBranchId;
@override@JsonKey(name: 'to_branch_id') final  String toBranchId;
@override@JsonKey(name: 'from_branch_name') final  String fromBranchName;
@override@JsonKey(name: 'to_branch_name') final  String toBranchName;
@override@JsonKey(name: 'transfer_number') final  int transferNumber;
 final  List<StockTransferItemModel> _items;
@override List<StockTransferItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson) final  TransferStatus status;
@override final  String? notes;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(name: 'received_at') final  DateTime? receivedAt;
@override@JsonKey(name: 'received_by') final  String? receivedBy;

/// Create a copy of StockTransferModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockTransferModelCopyWith<_StockTransferModel> get copyWith => __$StockTransferModelCopyWithImpl<_StockTransferModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockTransferModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockTransferModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.fromBranchId, fromBranchId) || other.fromBranchId == fromBranchId)&&(identical(other.toBranchId, toBranchId) || other.toBranchId == toBranchId)&&(identical(other.fromBranchName, fromBranchName) || other.fromBranchName == fromBranchName)&&(identical(other.toBranchName, toBranchName) || other.toBranchName == toBranchName)&&(identical(other.transferNumber, transferNumber) || other.transferNumber == transferNumber)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.receivedBy, receivedBy) || other.receivedBy == receivedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,fromBranchId,toBranchId,fromBranchName,toBranchName,transferNumber,const DeepCollectionEquality().hash(_items),status,notes,createdBy,createdAt,updatedAt,receivedAt,receivedBy);

@override
String toString() {
  return 'StockTransferModel(id: $id, branchId: $branchId, fromBranchId: $fromBranchId, toBranchId: $toBranchId, fromBranchName: $fromBranchName, toBranchName: $toBranchName, transferNumber: $transferNumber, items: $items, status: $status, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, receivedAt: $receivedAt, receivedBy: $receivedBy)';
}


}

/// @nodoc
abstract mixin class _$StockTransferModelCopyWith<$Res> implements $StockTransferModelCopyWith<$Res> {
  factory _$StockTransferModelCopyWith(_StockTransferModel value, $Res Function(_StockTransferModel) _then) = __$StockTransferModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'from_branch_id') String fromBranchId,@JsonKey(name: 'to_branch_id') String toBranchId,@JsonKey(name: 'from_branch_name') String fromBranchName,@JsonKey(name: 'to_branch_name') String toBranchName,@JsonKey(name: 'transfer_number') int transferNumber, List<StockTransferItemModel> items,@JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson) TransferStatus status, String? notes,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'received_at') DateTime? receivedAt,@JsonKey(name: 'received_by') String? receivedBy
});




}
/// @nodoc
class __$StockTransferModelCopyWithImpl<$Res>
    implements _$StockTransferModelCopyWith<$Res> {
  __$StockTransferModelCopyWithImpl(this._self, this._then);

  final _StockTransferModel _self;
  final $Res Function(_StockTransferModel) _then;

/// Create a copy of StockTransferModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? fromBranchId = null,Object? toBranchId = null,Object? fromBranchName = null,Object? toBranchName = null,Object? transferNumber = null,Object? items = null,Object? status = null,Object? notes = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? receivedAt = freezed,Object? receivedBy = freezed,}) {
  return _then(_StockTransferModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,fromBranchId: null == fromBranchId ? _self.fromBranchId : fromBranchId // ignore: cast_nullable_to_non_nullable
as String,toBranchId: null == toBranchId ? _self.toBranchId : toBranchId // ignore: cast_nullable_to_non_nullable
as String,fromBranchName: null == fromBranchName ? _self.fromBranchName : fromBranchName // ignore: cast_nullable_to_non_nullable
as String,toBranchName: null == toBranchName ? _self.toBranchName : toBranchName // ignore: cast_nullable_to_non_nullable
as String,transferNumber: null == transferNumber ? _self.transferNumber : transferNumber // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StockTransferItemModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedBy: freezed == receivedBy ? _self.receivedBy : receivedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
