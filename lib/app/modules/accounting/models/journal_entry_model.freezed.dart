// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalEntryLineModel {

 String get id;@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'account_name') String get accountName;@JsonKey(name: 'account_code') String get accountCode; double get debit; double get credit; String? get description;
/// Create a copy of JournalEntryLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryLineModelCopyWith<JournalEntryLineModel> get copyWith => _$JournalEntryLineModelCopyWithImpl<JournalEntryLineModel>(this as JournalEntryLineModel, _$identity);

  /// Serializes this JournalEntryLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.debit, debit) || other.debit == debit)&&(identical(other.credit, credit) || other.credit == credit)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountName,accountCode,debit,credit,description);

@override
String toString() {
  return 'JournalEntryLineModel(id: $id, accountId: $accountId, accountName: $accountName, accountCode: $accountCode, debit: $debit, credit: $credit, description: $description)';
}


}

/// @nodoc
abstract mixin class $JournalEntryLineModelCopyWith<$Res>  {
  factory $JournalEntryLineModelCopyWith(JournalEntryLineModel value, $Res Function(JournalEntryLineModel) _then) = _$JournalEntryLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'account_name') String accountName,@JsonKey(name: 'account_code') String accountCode, double debit, double credit, String? description
});




}
/// @nodoc
class _$JournalEntryLineModelCopyWithImpl<$Res>
    implements $JournalEntryLineModelCopyWith<$Res> {
  _$JournalEntryLineModelCopyWithImpl(this._self, this._then);

  final JournalEntryLineModel _self;
  final $Res Function(JournalEntryLineModel) _then;

/// Create a copy of JournalEntryLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? accountName = null,Object? accountCode = null,Object? debit = null,Object? credit = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as double,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryLineModel].
extension JournalEntryLineModelPatterns on JournalEntryLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryLineModel value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'account_code')  String accountCode,  double debit,  double credit,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryLineModel() when $default != null:
return $default(_that.id,_that.accountId,_that.accountName,_that.accountCode,_that.debit,_that.credit,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'account_code')  String accountCode,  double debit,  double credit,  String? description)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryLineModel():
return $default(_that.id,_that.accountId,_that.accountName,_that.accountCode,_that.debit,_that.credit,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'account_code')  String accountCode,  double debit,  double credit,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryLineModel() when $default != null:
return $default(_that.id,_that.accountId,_that.accountName,_that.accountCode,_that.debit,_that.credit,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntryLineModel extends JournalEntryLineModel {
  const _JournalEntryLineModel({required this.id, @JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'account_name') this.accountName = '', @JsonKey(name: 'account_code') this.accountCode = '', this.debit = 0, this.credit = 0, this.description}): super._();
  factory _JournalEntryLineModel.fromJson(Map<String, dynamic> json) => _$JournalEntryLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'account_name') final  String accountName;
@override@JsonKey(name: 'account_code') final  String accountCode;
@override@JsonKey() final  double debit;
@override@JsonKey() final  double credit;
@override final  String? description;

/// Create a copy of JournalEntryLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryLineModelCopyWith<_JournalEntryLineModel> get copyWith => __$JournalEntryLineModelCopyWithImpl<_JournalEntryLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.debit, debit) || other.debit == debit)&&(identical(other.credit, credit) || other.credit == credit)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountName,accountCode,debit,credit,description);

@override
String toString() {
  return 'JournalEntryLineModel(id: $id, accountId: $accountId, accountName: $accountName, accountCode: $accountCode, debit: $debit, credit: $credit, description: $description)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryLineModelCopyWith<$Res> implements $JournalEntryLineModelCopyWith<$Res> {
  factory _$JournalEntryLineModelCopyWith(_JournalEntryLineModel value, $Res Function(_JournalEntryLineModel) _then) = __$JournalEntryLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'account_name') String accountName,@JsonKey(name: 'account_code') String accountCode, double debit, double credit, String? description
});




}
/// @nodoc
class __$JournalEntryLineModelCopyWithImpl<$Res>
    implements _$JournalEntryLineModelCopyWith<$Res> {
  __$JournalEntryLineModelCopyWithImpl(this._self, this._then);

  final _JournalEntryLineModel _self;
  final $Res Function(_JournalEntryLineModel) _then;

/// Create a copy of JournalEntryLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? accountName = null,Object? accountCode = null,Object? debit = null,Object? credit = null,Object? description = freezed,}) {
  return _then(_JournalEntryLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as double,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$JournalEntryModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'entry_number') int get entryNumber;@JsonKey(name: 'entry_date') DateTime get entryDate;@JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson) JournalEntryType get entryType;@JsonKey(name: 'reference_id') String? get referenceId;@JsonKey(name: 'reference_number') String? get referenceNumber; String? get description; List<JournalEntryLineModel> get lines;@JsonKey(name: 'total_debit') double get totalDebit;@JsonKey(name: 'total_credit') double get totalCredit;@JsonKey(name: 'created_by_id') String get createdById;@JsonKey(name: 'created_by_name') String? get createdByName;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryModelCopyWith<JournalEntryModel> get copyWith => _$JournalEntryModelCopyWithImpl<JournalEntryModel>(this as JournalEntryModel, _$identity);

  /// Serializes this JournalEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.entryNumber, entryNumber) || other.entryNumber == entryNumber)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.entryType, entryType) || other.entryType == entryType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.referenceNumber, referenceNumber) || other.referenceNumber == referenceNumber)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.totalDebit, totalDebit) || other.totalDebit == totalDebit)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,entryNumber,entryDate,entryType,referenceId,referenceNumber,description,const DeepCollectionEquality().hash(lines),totalDebit,totalCredit,createdById,createdByName,createdAt,updatedAt);

@override
String toString() {
  return 'JournalEntryModel(id: $id, branchId: $branchId, entryNumber: $entryNumber, entryDate: $entryDate, entryType: $entryType, referenceId: $referenceId, referenceNumber: $referenceNumber, description: $description, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit, createdById: $createdById, createdByName: $createdByName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JournalEntryModelCopyWith<$Res>  {
  factory $JournalEntryModelCopyWith(JournalEntryModel value, $Res Function(JournalEntryModel) _then) = _$JournalEntryModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'entry_number') int entryNumber,@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson) JournalEntryType entryType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'reference_number') String? referenceNumber, String? description, List<JournalEntryLineModel> lines,@JsonKey(name: 'total_debit') double totalDebit,@JsonKey(name: 'total_credit') double totalCredit,@JsonKey(name: 'created_by_id') String createdById,@JsonKey(name: 'created_by_name') String? createdByName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$JournalEntryModelCopyWithImpl<$Res>
    implements $JournalEntryModelCopyWith<$Res> {
  _$JournalEntryModelCopyWithImpl(this._self, this._then);

  final JournalEntryModel _self;
  final $Res Function(JournalEntryModel) _then;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? entryNumber = null,Object? entryDate = null,Object? entryType = null,Object? referenceId = freezed,Object? referenceNumber = freezed,Object? description = freezed,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,Object? createdById = null,Object? createdByName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,entryNumber: null == entryNumber ? _self.entryNumber : entryNumber // ignore: cast_nullable_to_non_nullable
as int,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,entryType: null == entryType ? _self.entryType : entryType // ignore: cast_nullable_to_non_nullable
as JournalEntryType,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,referenceNumber: freezed == referenceNumber ? _self.referenceNumber : referenceNumber // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalEntryLineModel>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as double,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as double,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryModel].
extension JournalEntryModelPatterns on JournalEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'entry_number')  int entryNumber, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson)  JournalEntryType entryType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'reference_number')  String? referenceNumber,  String? description,  List<JournalEntryLineModel> lines, @JsonKey(name: 'total_debit')  double totalDebit, @JsonKey(name: 'total_credit')  double totalCredit, @JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'created_by_name')  String? createdByName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that.id,_that.branchId,_that.entryNumber,_that.entryDate,_that.entryType,_that.referenceId,_that.referenceNumber,_that.description,_that.lines,_that.totalDebit,_that.totalCredit,_that.createdById,_that.createdByName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'entry_number')  int entryNumber, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson)  JournalEntryType entryType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'reference_number')  String? referenceNumber,  String? description,  List<JournalEntryLineModel> lines, @JsonKey(name: 'total_debit')  double totalDebit, @JsonKey(name: 'total_credit')  double totalCredit, @JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'created_by_name')  String? createdByName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryModel():
return $default(_that.id,_that.branchId,_that.entryNumber,_that.entryDate,_that.entryType,_that.referenceId,_that.referenceNumber,_that.description,_that.lines,_that.totalDebit,_that.totalCredit,_that.createdById,_that.createdByName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'entry_number')  int entryNumber, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson)  JournalEntryType entryType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'reference_number')  String? referenceNumber,  String? description,  List<JournalEntryLineModel> lines, @JsonKey(name: 'total_debit')  double totalDebit, @JsonKey(name: 'total_credit')  double totalCredit, @JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'created_by_name')  String? createdByName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that.id,_that.branchId,_that.entryNumber,_that.entryDate,_that.entryType,_that.referenceId,_that.referenceNumber,_that.description,_that.lines,_that.totalDebit,_that.totalCredit,_that.createdById,_that.createdByName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntryModel extends JournalEntryModel {
  const _JournalEntryModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'entry_number') required this.entryNumber, @JsonKey(name: 'entry_date') required this.entryDate, @JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson) this.entryType = JournalEntryType.other, @JsonKey(name: 'reference_id') this.referenceId, @JsonKey(name: 'reference_number') this.referenceNumber, this.description, final  List<JournalEntryLineModel> lines = const [], @JsonKey(name: 'total_debit') this.totalDebit = 0, @JsonKey(name: 'total_credit') this.totalCredit = 0, @JsonKey(name: 'created_by_id') required this.createdById, @JsonKey(name: 'created_by_name') this.createdByName, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _lines = lines,super._();
  factory _JournalEntryModel.fromJson(Map<String, dynamic> json) => _$JournalEntryModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'entry_number') final  int entryNumber;
@override@JsonKey(name: 'entry_date') final  DateTime entryDate;
@override@JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson) final  JournalEntryType entryType;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override@JsonKey(name: 'reference_number') final  String? referenceNumber;
@override final  String? description;
 final  List<JournalEntryLineModel> _lines;
@override@JsonKey() List<JournalEntryLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey(name: 'total_debit') final  double totalDebit;
@override@JsonKey(name: 'total_credit') final  double totalCredit;
@override@JsonKey(name: 'created_by_id') final  String createdById;
@override@JsonKey(name: 'created_by_name') final  String? createdByName;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryModelCopyWith<_JournalEntryModel> get copyWith => __$JournalEntryModelCopyWithImpl<_JournalEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.entryNumber, entryNumber) || other.entryNumber == entryNumber)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.entryType, entryType) || other.entryType == entryType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.referenceNumber, referenceNumber) || other.referenceNumber == referenceNumber)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.totalDebit, totalDebit) || other.totalDebit == totalDebit)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,entryNumber,entryDate,entryType,referenceId,referenceNumber,description,const DeepCollectionEquality().hash(_lines),totalDebit,totalCredit,createdById,createdByName,createdAt,updatedAt);

@override
String toString() {
  return 'JournalEntryModel(id: $id, branchId: $branchId, entryNumber: $entryNumber, entryDate: $entryDate, entryType: $entryType, referenceId: $referenceId, referenceNumber: $referenceNumber, description: $description, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit, createdById: $createdById, createdByName: $createdByName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryModelCopyWith<$Res> implements $JournalEntryModelCopyWith<$Res> {
  factory _$JournalEntryModelCopyWith(_JournalEntryModel value, $Res Function(_JournalEntryModel) _then) = __$JournalEntryModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'entry_number') int entryNumber,@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(fromJson: _journalEntryTypeFromJson, toJson: _journalEntryTypeToJson) JournalEntryType entryType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'reference_number') String? referenceNumber, String? description, List<JournalEntryLineModel> lines,@JsonKey(name: 'total_debit') double totalDebit,@JsonKey(name: 'total_credit') double totalCredit,@JsonKey(name: 'created_by_id') String createdById,@JsonKey(name: 'created_by_name') String? createdByName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$JournalEntryModelCopyWithImpl<$Res>
    implements _$JournalEntryModelCopyWith<$Res> {
  __$JournalEntryModelCopyWithImpl(this._self, this._then);

  final _JournalEntryModel _self;
  final $Res Function(_JournalEntryModel) _then;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? entryNumber = null,Object? entryDate = null,Object? entryType = null,Object? referenceId = freezed,Object? referenceNumber = freezed,Object? description = freezed,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,Object? createdById = null,Object? createdByName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_JournalEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,entryNumber: null == entryNumber ? _self.entryNumber : entryNumber // ignore: cast_nullable_to_non_nullable
as int,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,entryType: null == entryType ? _self.entryType : entryType // ignore: cast_nullable_to_non_nullable
as JournalEntryType,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,referenceNumber: freezed == referenceNumber ? _self.referenceNumber : referenceNumber // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalEntryLineModel>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as double,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as double,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
