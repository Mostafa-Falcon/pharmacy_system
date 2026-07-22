// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyPaymentModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId; int get number;@JsonKey(name: 'payment_date') DateTime get paymentDate;@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) PartyPaymentKind get kind;@JsonKey(name: 'party_id') String get partyId;@JsonKey(name: 'party_name') String get partyName; double get amount;@JsonKey(name: 'payment_method') String get paymentMethod;@JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson) PartyBalanceEffect? get balanceEffect;@JsonKey(name: 'purchase_receipt_id') String? get purchaseReceiptId;@JsonKey(name: 'purchase_receipt_number') String? get purchaseReceiptNumber;@JsonKey(name: 'reference_number') String? get referenceNumber; String? get notes;@JsonKey(name: 'created_by_id') String get createdById;@JsonKey(name: 'created_by_name') String? get createdByName;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of PartyPaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyPaymentModelCopyWith<PartyPaymentModel> get copyWith => _$PartyPaymentModelCopyWithImpl<PartyPaymentModel>(this as PartyPaymentModel, _$identity);

  /// Serializes this PartyPaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyPaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.number, number) || other.number == number)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.partyId, partyId) || other.partyId == partyId)&&(identical(other.partyName, partyName) || other.partyName == partyName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.balanceEffect, balanceEffect) || other.balanceEffect == balanceEffect)&&(identical(other.purchaseReceiptId, purchaseReceiptId) || other.purchaseReceiptId == purchaseReceiptId)&&(identical(other.purchaseReceiptNumber, purchaseReceiptNumber) || other.purchaseReceiptNumber == purchaseReceiptNumber)&&(identical(other.referenceNumber, referenceNumber) || other.referenceNumber == referenceNumber)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,number,paymentDate,kind,partyId,partyName,amount,paymentMethod,balanceEffect,purchaseReceiptId,purchaseReceiptNumber,referenceNumber,notes,createdById,createdByName,createdAt,updatedAt);

@override
String toString() {
  return 'PartyPaymentModel(id: $id, branchId: $branchId, number: $number, paymentDate: $paymentDate, kind: $kind, partyId: $partyId, partyName: $partyName, amount: $amount, paymentMethod: $paymentMethod, balanceEffect: $balanceEffect, purchaseReceiptId: $purchaseReceiptId, purchaseReceiptNumber: $purchaseReceiptNumber, referenceNumber: $referenceNumber, notes: $notes, createdById: $createdById, createdByName: $createdByName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PartyPaymentModelCopyWith<$Res>  {
  factory $PartyPaymentModelCopyWith(PartyPaymentModel value, $Res Function(PartyPaymentModel) _then) = _$PartyPaymentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId, int number,@JsonKey(name: 'payment_date') DateTime paymentDate,@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) PartyPaymentKind kind,@JsonKey(name: 'party_id') String partyId,@JsonKey(name: 'party_name') String partyName, double amount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson) PartyBalanceEffect? balanceEffect,@JsonKey(name: 'purchase_receipt_id') String? purchaseReceiptId,@JsonKey(name: 'purchase_receipt_number') String? purchaseReceiptNumber,@JsonKey(name: 'reference_number') String? referenceNumber, String? notes,@JsonKey(name: 'created_by_id') String createdById,@JsonKey(name: 'created_by_name') String? createdByName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$PartyPaymentModelCopyWithImpl<$Res>
    implements $PartyPaymentModelCopyWith<$Res> {
  _$PartyPaymentModelCopyWithImpl(this._self, this._then);

  final PartyPaymentModel _self;
  final $Res Function(PartyPaymentModel) _then;

/// Create a copy of PartyPaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? number = null,Object? paymentDate = null,Object? kind = null,Object? partyId = null,Object? partyName = null,Object? amount = null,Object? paymentMethod = null,Object? balanceEffect = freezed,Object? purchaseReceiptId = freezed,Object? purchaseReceiptNumber = freezed,Object? referenceNumber = freezed,Object? notes = freezed,Object? createdById = null,Object? createdByName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,paymentDate: null == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PartyPaymentKind,partyId: null == partyId ? _self.partyId : partyId // ignore: cast_nullable_to_non_nullable
as String,partyName: null == partyName ? _self.partyName : partyName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,balanceEffect: freezed == balanceEffect ? _self.balanceEffect : balanceEffect // ignore: cast_nullable_to_non_nullable
as PartyBalanceEffect?,purchaseReceiptId: freezed == purchaseReceiptId ? _self.purchaseReceiptId : purchaseReceiptId // ignore: cast_nullable_to_non_nullable
as String?,purchaseReceiptNumber: freezed == purchaseReceiptNumber ? _self.purchaseReceiptNumber : purchaseReceiptNumber // ignore: cast_nullable_to_non_nullable
as String?,referenceNumber: freezed == referenceNumber ? _self.referenceNumber : referenceNumber // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyPaymentModel].
extension PartyPaymentModelPatterns on PartyPaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyPaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyPaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyPaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _PartyPaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyPaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _PartyPaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId,  int number, @JsonKey(name: 'payment_date')  DateTime paymentDate, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson)  PartyPaymentKind kind, @JsonKey(name: 'party_id')  String partyId, @JsonKey(name: 'party_name')  String partyName,  double amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson)  PartyBalanceEffect? balanceEffect, @JsonKey(name: 'purchase_receipt_id')  String? purchaseReceiptId, @JsonKey(name: 'purchase_receipt_number')  String? purchaseReceiptNumber, @JsonKey(name: 'reference_number')  String? referenceNumber,  String? notes, @JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'created_by_name')  String? createdByName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyPaymentModel() when $default != null:
return $default(_that.id,_that.branchId,_that.number,_that.paymentDate,_that.kind,_that.partyId,_that.partyName,_that.amount,_that.paymentMethod,_that.balanceEffect,_that.purchaseReceiptId,_that.purchaseReceiptNumber,_that.referenceNumber,_that.notes,_that.createdById,_that.createdByName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId,  int number, @JsonKey(name: 'payment_date')  DateTime paymentDate, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson)  PartyPaymentKind kind, @JsonKey(name: 'party_id')  String partyId, @JsonKey(name: 'party_name')  String partyName,  double amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson)  PartyBalanceEffect? balanceEffect, @JsonKey(name: 'purchase_receipt_id')  String? purchaseReceiptId, @JsonKey(name: 'purchase_receipt_number')  String? purchaseReceiptNumber, @JsonKey(name: 'reference_number')  String? referenceNumber,  String? notes, @JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'created_by_name')  String? createdByName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PartyPaymentModel():
return $default(_that.id,_that.branchId,_that.number,_that.paymentDate,_that.kind,_that.partyId,_that.partyName,_that.amount,_that.paymentMethod,_that.balanceEffect,_that.purchaseReceiptId,_that.purchaseReceiptNumber,_that.referenceNumber,_that.notes,_that.createdById,_that.createdByName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId,  int number, @JsonKey(name: 'payment_date')  DateTime paymentDate, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson)  PartyPaymentKind kind, @JsonKey(name: 'party_id')  String partyId, @JsonKey(name: 'party_name')  String partyName,  double amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson)  PartyBalanceEffect? balanceEffect, @JsonKey(name: 'purchase_receipt_id')  String? purchaseReceiptId, @JsonKey(name: 'purchase_receipt_number')  String? purchaseReceiptNumber, @JsonKey(name: 'reference_number')  String? referenceNumber,  String? notes, @JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'created_by_name')  String? createdByName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PartyPaymentModel() when $default != null:
return $default(_that.id,_that.branchId,_that.number,_that.paymentDate,_that.kind,_that.partyId,_that.partyName,_that.amount,_that.paymentMethod,_that.balanceEffect,_that.purchaseReceiptId,_that.purchaseReceiptNumber,_that.referenceNumber,_that.notes,_that.createdById,_that.createdByName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyPaymentModel extends PartyPaymentModel {
  const _PartyPaymentModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, required this.number, @JsonKey(name: 'payment_date') required this.paymentDate, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) required this.kind, @JsonKey(name: 'party_id') required this.partyId, @JsonKey(name: 'party_name') this.partyName = '', required this.amount, @JsonKey(name: 'payment_method') this.paymentMethod = 'cash', @JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson) this.balanceEffect, @JsonKey(name: 'purchase_receipt_id') this.purchaseReceiptId, @JsonKey(name: 'purchase_receipt_number') this.purchaseReceiptNumber, @JsonKey(name: 'reference_number') this.referenceNumber, this.notes, @JsonKey(name: 'created_by_id') required this.createdById, @JsonKey(name: 'created_by_name') this.createdByName, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _PartyPaymentModel.fromJson(Map<String, dynamic> json) => _$PartyPaymentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override final  int number;
@override@JsonKey(name: 'payment_date') final  DateTime paymentDate;
@override@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) final  PartyPaymentKind kind;
@override@JsonKey(name: 'party_id') final  String partyId;
@override@JsonKey(name: 'party_name') final  String partyName;
@override final  double amount;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override@JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson) final  PartyBalanceEffect? balanceEffect;
@override@JsonKey(name: 'purchase_receipt_id') final  String? purchaseReceiptId;
@override@JsonKey(name: 'purchase_receipt_number') final  String? purchaseReceiptNumber;
@override@JsonKey(name: 'reference_number') final  String? referenceNumber;
@override final  String? notes;
@override@JsonKey(name: 'created_by_id') final  String createdById;
@override@JsonKey(name: 'created_by_name') final  String? createdByName;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of PartyPaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyPaymentModelCopyWith<_PartyPaymentModel> get copyWith => __$PartyPaymentModelCopyWithImpl<_PartyPaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyPaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyPaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.number, number) || other.number == number)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.partyId, partyId) || other.partyId == partyId)&&(identical(other.partyName, partyName) || other.partyName == partyName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.balanceEffect, balanceEffect) || other.balanceEffect == balanceEffect)&&(identical(other.purchaseReceiptId, purchaseReceiptId) || other.purchaseReceiptId == purchaseReceiptId)&&(identical(other.purchaseReceiptNumber, purchaseReceiptNumber) || other.purchaseReceiptNumber == purchaseReceiptNumber)&&(identical(other.referenceNumber, referenceNumber) || other.referenceNumber == referenceNumber)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,number,paymentDate,kind,partyId,partyName,amount,paymentMethod,balanceEffect,purchaseReceiptId,purchaseReceiptNumber,referenceNumber,notes,createdById,createdByName,createdAt,updatedAt);

@override
String toString() {
  return 'PartyPaymentModel(id: $id, branchId: $branchId, number: $number, paymentDate: $paymentDate, kind: $kind, partyId: $partyId, partyName: $partyName, amount: $amount, paymentMethod: $paymentMethod, balanceEffect: $balanceEffect, purchaseReceiptId: $purchaseReceiptId, purchaseReceiptNumber: $purchaseReceiptNumber, referenceNumber: $referenceNumber, notes: $notes, createdById: $createdById, createdByName: $createdByName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PartyPaymentModelCopyWith<$Res> implements $PartyPaymentModelCopyWith<$Res> {
  factory _$PartyPaymentModelCopyWith(_PartyPaymentModel value, $Res Function(_PartyPaymentModel) _then) = __$PartyPaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId, int number,@JsonKey(name: 'payment_date') DateTime paymentDate,@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) PartyPaymentKind kind,@JsonKey(name: 'party_id') String partyId,@JsonKey(name: 'party_name') String partyName, double amount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson) PartyBalanceEffect? balanceEffect,@JsonKey(name: 'purchase_receipt_id') String? purchaseReceiptId,@JsonKey(name: 'purchase_receipt_number') String? purchaseReceiptNumber,@JsonKey(name: 'reference_number') String? referenceNumber, String? notes,@JsonKey(name: 'created_by_id') String createdById,@JsonKey(name: 'created_by_name') String? createdByName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$PartyPaymentModelCopyWithImpl<$Res>
    implements _$PartyPaymentModelCopyWith<$Res> {
  __$PartyPaymentModelCopyWithImpl(this._self, this._then);

  final _PartyPaymentModel _self;
  final $Res Function(_PartyPaymentModel) _then;

/// Create a copy of PartyPaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? number = null,Object? paymentDate = null,Object? kind = null,Object? partyId = null,Object? partyName = null,Object? amount = null,Object? paymentMethod = null,Object? balanceEffect = freezed,Object? purchaseReceiptId = freezed,Object? purchaseReceiptNumber = freezed,Object? referenceNumber = freezed,Object? notes = freezed,Object? createdById = null,Object? createdByName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PartyPaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,paymentDate: null == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PartyPaymentKind,partyId: null == partyId ? _self.partyId : partyId // ignore: cast_nullable_to_non_nullable
as String,partyName: null == partyName ? _self.partyName : partyName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,balanceEffect: freezed == balanceEffect ? _self.balanceEffect : balanceEffect // ignore: cast_nullable_to_non_nullable
as PartyBalanceEffect?,purchaseReceiptId: freezed == purchaseReceiptId ? _self.purchaseReceiptId : purchaseReceiptId // ignore: cast_nullable_to_non_nullable
as String?,purchaseReceiptNumber: freezed == purchaseReceiptNumber ? _self.purchaseReceiptNumber : purchaseReceiptNumber // ignore: cast_nullable_to_non_nullable
as String?,referenceNumber: freezed == referenceNumber ? _self.referenceNumber : referenceNumber // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
