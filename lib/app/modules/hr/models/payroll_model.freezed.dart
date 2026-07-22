// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayrollModel {

 String get id; int get month; int get year;@JsonKey(name: 'branch_id') String get branchId; String get status;@JsonKey(name: 'total_salaries') double get totalSalaries;@JsonKey(name: 'total_adjustments') double get totalAdjustments;@JsonKey(name: 'net_total') double get netTotal;@JsonKey(name: 'employee_count') int get employeeCount;@JsonKey(name: 'processed_at') String? get processedAt;@JsonKey(name: 'approved_at') String? get approvedAt;@JsonKey(name: 'approved_by') String? get approvedBy;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of PayrollModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollModelCopyWith<PayrollModel> get copyWith => _$PayrollModelCopyWithImpl<PayrollModel>(this as PayrollModel, _$identity);

  /// Serializes this PayrollModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollModel&&(identical(other.id, id) || other.id == id)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalSalaries, totalSalaries) || other.totalSalaries == totalSalaries)&&(identical(other.totalAdjustments, totalAdjustments) || other.totalAdjustments == totalAdjustments)&&(identical(other.netTotal, netTotal) || other.netTotal == netTotal)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,month,year,branchId,status,totalSalaries,totalAdjustments,netTotal,employeeCount,processedAt,approvedAt,approvedBy,createdAt,updatedAt);

@override
String toString() {
  return 'PayrollModel(id: $id, month: $month, year: $year, branchId: $branchId, status: $status, totalSalaries: $totalSalaries, totalAdjustments: $totalAdjustments, netTotal: $netTotal, employeeCount: $employeeCount, processedAt: $processedAt, approvedAt: $approvedAt, approvedBy: $approvedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PayrollModelCopyWith<$Res>  {
  factory $PayrollModelCopyWith(PayrollModel value, $Res Function(PayrollModel) _then) = _$PayrollModelCopyWithImpl;
@useResult
$Res call({
 String id, int month, int year,@JsonKey(name: 'branch_id') String branchId, String status,@JsonKey(name: 'total_salaries') double totalSalaries,@JsonKey(name: 'total_adjustments') double totalAdjustments,@JsonKey(name: 'net_total') double netTotal,@JsonKey(name: 'employee_count') int employeeCount,@JsonKey(name: 'processed_at') String? processedAt,@JsonKey(name: 'approved_at') String? approvedAt,@JsonKey(name: 'approved_by') String? approvedBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$PayrollModelCopyWithImpl<$Res>
    implements $PayrollModelCopyWith<$Res> {
  _$PayrollModelCopyWithImpl(this._self, this._then);

  final PayrollModel _self;
  final $Res Function(PayrollModel) _then;

/// Create a copy of PayrollModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? month = null,Object? year = null,Object? branchId = null,Object? status = null,Object? totalSalaries = null,Object? totalAdjustments = null,Object? netTotal = null,Object? employeeCount = null,Object? processedAt = freezed,Object? approvedAt = freezed,Object? approvedBy = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,totalSalaries: null == totalSalaries ? _self.totalSalaries : totalSalaries // ignore: cast_nullable_to_non_nullable
as double,totalAdjustments: null == totalAdjustments ? _self.totalAdjustments : totalAdjustments // ignore: cast_nullable_to_non_nullable
as double,netTotal: null == netTotal ? _self.netTotal : netTotal // ignore: cast_nullable_to_non_nullable
as double,employeeCount: null == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollModel].
extension PayrollModelPatterns on PayrollModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollModel value)  $default,){
final _that = this;
switch (_that) {
case _PayrollModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollModel value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int month,  int year, @JsonKey(name: 'branch_id')  String branchId,  String status, @JsonKey(name: 'total_salaries')  double totalSalaries, @JsonKey(name: 'total_adjustments')  double totalAdjustments, @JsonKey(name: 'net_total')  double netTotal, @JsonKey(name: 'employee_count')  int employeeCount, @JsonKey(name: 'processed_at')  String? processedAt, @JsonKey(name: 'approved_at')  String? approvedAt, @JsonKey(name: 'approved_by')  String? approvedBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollModel() when $default != null:
return $default(_that.id,_that.month,_that.year,_that.branchId,_that.status,_that.totalSalaries,_that.totalAdjustments,_that.netTotal,_that.employeeCount,_that.processedAt,_that.approvedAt,_that.approvedBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int month,  int year, @JsonKey(name: 'branch_id')  String branchId,  String status, @JsonKey(name: 'total_salaries')  double totalSalaries, @JsonKey(name: 'total_adjustments')  double totalAdjustments, @JsonKey(name: 'net_total')  double netTotal, @JsonKey(name: 'employee_count')  int employeeCount, @JsonKey(name: 'processed_at')  String? processedAt, @JsonKey(name: 'approved_at')  String? approvedAt, @JsonKey(name: 'approved_by')  String? approvedBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PayrollModel():
return $default(_that.id,_that.month,_that.year,_that.branchId,_that.status,_that.totalSalaries,_that.totalAdjustments,_that.netTotal,_that.employeeCount,_that.processedAt,_that.approvedAt,_that.approvedBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int month,  int year, @JsonKey(name: 'branch_id')  String branchId,  String status, @JsonKey(name: 'total_salaries')  double totalSalaries, @JsonKey(name: 'total_adjustments')  double totalAdjustments, @JsonKey(name: 'net_total')  double netTotal, @JsonKey(name: 'employee_count')  int employeeCount, @JsonKey(name: 'processed_at')  String? processedAt, @JsonKey(name: 'approved_at')  String? approvedAt, @JsonKey(name: 'approved_by')  String? approvedBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PayrollModel() when $default != null:
return $default(_that.id,_that.month,_that.year,_that.branchId,_that.status,_that.totalSalaries,_that.totalAdjustments,_that.netTotal,_that.employeeCount,_that.processedAt,_that.approvedAt,_that.approvedBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollModel extends PayrollModel {
  const _PayrollModel({required this.id, required this.month, required this.year, @JsonKey(name: 'branch_id') this.branchId = '', this.status = 'draft', @JsonKey(name: 'total_salaries') this.totalSalaries = 0, @JsonKey(name: 'total_adjustments') this.totalAdjustments = 0, @JsonKey(name: 'net_total') this.netTotal = 0, @JsonKey(name: 'employee_count') this.employeeCount = 0, @JsonKey(name: 'processed_at') this.processedAt, @JsonKey(name: 'approved_at') this.approvedAt, @JsonKey(name: 'approved_by') this.approvedBy, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _PayrollModel.fromJson(Map<String, dynamic> json) => _$PayrollModelFromJson(json);

@override final  String id;
@override final  int month;
@override final  int year;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'total_salaries') final  double totalSalaries;
@override@JsonKey(name: 'total_adjustments') final  double totalAdjustments;
@override@JsonKey(name: 'net_total') final  double netTotal;
@override@JsonKey(name: 'employee_count') final  int employeeCount;
@override@JsonKey(name: 'processed_at') final  String? processedAt;
@override@JsonKey(name: 'approved_at') final  String? approvedAt;
@override@JsonKey(name: 'approved_by') final  String? approvedBy;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of PayrollModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollModelCopyWith<_PayrollModel> get copyWith => __$PayrollModelCopyWithImpl<_PayrollModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollModel&&(identical(other.id, id) || other.id == id)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalSalaries, totalSalaries) || other.totalSalaries == totalSalaries)&&(identical(other.totalAdjustments, totalAdjustments) || other.totalAdjustments == totalAdjustments)&&(identical(other.netTotal, netTotal) || other.netTotal == netTotal)&&(identical(other.employeeCount, employeeCount) || other.employeeCount == employeeCount)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,month,year,branchId,status,totalSalaries,totalAdjustments,netTotal,employeeCount,processedAt,approvedAt,approvedBy,createdAt,updatedAt);

@override
String toString() {
  return 'PayrollModel(id: $id, month: $month, year: $year, branchId: $branchId, status: $status, totalSalaries: $totalSalaries, totalAdjustments: $totalAdjustments, netTotal: $netTotal, employeeCount: $employeeCount, processedAt: $processedAt, approvedAt: $approvedAt, approvedBy: $approvedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PayrollModelCopyWith<$Res> implements $PayrollModelCopyWith<$Res> {
  factory _$PayrollModelCopyWith(_PayrollModel value, $Res Function(_PayrollModel) _then) = __$PayrollModelCopyWithImpl;
@override @useResult
$Res call({
 String id, int month, int year,@JsonKey(name: 'branch_id') String branchId, String status,@JsonKey(name: 'total_salaries') double totalSalaries,@JsonKey(name: 'total_adjustments') double totalAdjustments,@JsonKey(name: 'net_total') double netTotal,@JsonKey(name: 'employee_count') int employeeCount,@JsonKey(name: 'processed_at') String? processedAt,@JsonKey(name: 'approved_at') String? approvedAt,@JsonKey(name: 'approved_by') String? approvedBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$PayrollModelCopyWithImpl<$Res>
    implements _$PayrollModelCopyWith<$Res> {
  __$PayrollModelCopyWithImpl(this._self, this._then);

  final _PayrollModel _self;
  final $Res Function(_PayrollModel) _then;

/// Create a copy of PayrollModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? month = null,Object? year = null,Object? branchId = null,Object? status = null,Object? totalSalaries = null,Object? totalAdjustments = null,Object? netTotal = null,Object? employeeCount = null,Object? processedAt = freezed,Object? approvedAt = freezed,Object? approvedBy = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PayrollModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,totalSalaries: null == totalSalaries ? _self.totalSalaries : totalSalaries // ignore: cast_nullable_to_non_nullable
as double,totalAdjustments: null == totalAdjustments ? _self.totalAdjustments : totalAdjustments // ignore: cast_nullable_to_non_nullable
as double,netTotal: null == netTotal ? _self.netTotal : netTotal // ignore: cast_nullable_to_non_nullable
as double,employeeCount: null == employeeCount ? _self.employeeCount : employeeCount // ignore: cast_nullable_to_non_nullable
as int,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PayrollLineModel {

 String get id;@JsonKey(name: 'payroll_id') String get payrollId;@JsonKey(name: 'employee_id') String get employeeId;@JsonKey(name: 'employee_name') String get employeeName;@JsonKey(name: 'base_salary') double get baseSalary;@JsonKey(name: 'working_days') int get workingDays;@JsonKey(name: 'absent_days') int get absentDays; double get overtime; double get bonuses; double get deductions;@JsonKey(name: 'net_salary') double get netSalary;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of PayrollLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollLineModelCopyWith<PayrollLineModel> get copyWith => _$PayrollLineModelCopyWithImpl<PayrollLineModel>(this as PayrollLineModel, _$identity);

  /// Serializes this PayrollLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.payrollId, payrollId) || other.payrollId == payrollId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary)&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.absentDays, absentDays) || other.absentDays == absentDays)&&(identical(other.overtime, overtime) || other.overtime == overtime)&&(identical(other.bonuses, bonuses) || other.bonuses == bonuses)&&(identical(other.deductions, deductions) || other.deductions == deductions)&&(identical(other.netSalary, netSalary) || other.netSalary == netSalary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,payrollId,employeeId,employeeName,baseSalary,workingDays,absentDays,overtime,bonuses,deductions,netSalary,createdAt,updatedAt);

@override
String toString() {
  return 'PayrollLineModel(id: $id, payrollId: $payrollId, employeeId: $employeeId, employeeName: $employeeName, baseSalary: $baseSalary, workingDays: $workingDays, absentDays: $absentDays, overtime: $overtime, bonuses: $bonuses, deductions: $deductions, netSalary: $netSalary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PayrollLineModelCopyWith<$Res>  {
  factory $PayrollLineModelCopyWith(PayrollLineModel value, $Res Function(PayrollLineModel) _then) = _$PayrollLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'payroll_id') String payrollId,@JsonKey(name: 'employee_id') String employeeId,@JsonKey(name: 'employee_name') String employeeName,@JsonKey(name: 'base_salary') double baseSalary,@JsonKey(name: 'working_days') int workingDays,@JsonKey(name: 'absent_days') int absentDays, double overtime, double bonuses, double deductions,@JsonKey(name: 'net_salary') double netSalary,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$PayrollLineModelCopyWithImpl<$Res>
    implements $PayrollLineModelCopyWith<$Res> {
  _$PayrollLineModelCopyWithImpl(this._self, this._then);

  final PayrollLineModel _self;
  final $Res Function(PayrollLineModel) _then;

/// Create a copy of PayrollLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? payrollId = null,Object? employeeId = null,Object? employeeName = null,Object? baseSalary = null,Object? workingDays = null,Object? absentDays = null,Object? overtime = null,Object? bonuses = null,Object? deductions = null,Object? netSalary = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,payrollId: null == payrollId ? _self.payrollId : payrollId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as double,workingDays: null == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as int,absentDays: null == absentDays ? _self.absentDays : absentDays // ignore: cast_nullable_to_non_nullable
as int,overtime: null == overtime ? _self.overtime : overtime // ignore: cast_nullable_to_non_nullable
as double,bonuses: null == bonuses ? _self.bonuses : bonuses // ignore: cast_nullable_to_non_nullable
as double,deductions: null == deductions ? _self.deductions : deductions // ignore: cast_nullable_to_non_nullable
as double,netSalary: null == netSalary ? _self.netSalary : netSalary // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollLineModel].
extension PayrollLineModelPatterns on PayrollLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollLineModel value)  $default,){
final _that = this;
switch (_that) {
case _PayrollLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'payroll_id')  String payrollId, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'base_salary')  double baseSalary, @JsonKey(name: 'working_days')  int workingDays, @JsonKey(name: 'absent_days')  int absentDays,  double overtime,  double bonuses,  double deductions, @JsonKey(name: 'net_salary')  double netSalary, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollLineModel() when $default != null:
return $default(_that.id,_that.payrollId,_that.employeeId,_that.employeeName,_that.baseSalary,_that.workingDays,_that.absentDays,_that.overtime,_that.bonuses,_that.deductions,_that.netSalary,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'payroll_id')  String payrollId, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'base_salary')  double baseSalary, @JsonKey(name: 'working_days')  int workingDays, @JsonKey(name: 'absent_days')  int absentDays,  double overtime,  double bonuses,  double deductions, @JsonKey(name: 'net_salary')  double netSalary, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PayrollLineModel():
return $default(_that.id,_that.payrollId,_that.employeeId,_that.employeeName,_that.baseSalary,_that.workingDays,_that.absentDays,_that.overtime,_that.bonuses,_that.deductions,_that.netSalary,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'payroll_id')  String payrollId, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'base_salary')  double baseSalary, @JsonKey(name: 'working_days')  int workingDays, @JsonKey(name: 'absent_days')  int absentDays,  double overtime,  double bonuses,  double deductions, @JsonKey(name: 'net_salary')  double netSalary, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PayrollLineModel() when $default != null:
return $default(_that.id,_that.payrollId,_that.employeeId,_that.employeeName,_that.baseSalary,_that.workingDays,_that.absentDays,_that.overtime,_that.bonuses,_that.deductions,_that.netSalary,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollLineModel extends PayrollLineModel {
  const _PayrollLineModel({required this.id, @JsonKey(name: 'payroll_id') required this.payrollId, @JsonKey(name: 'employee_id') required this.employeeId, @JsonKey(name: 'employee_name') this.employeeName = '', @JsonKey(name: 'base_salary') this.baseSalary = 0, @JsonKey(name: 'working_days') this.workingDays = 0, @JsonKey(name: 'absent_days') this.absentDays = 0, this.overtime = 0, this.bonuses = 0, this.deductions = 0, @JsonKey(name: 'net_salary') this.netSalary = 0, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _PayrollLineModel.fromJson(Map<String, dynamic> json) => _$PayrollLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'payroll_id') final  String payrollId;
@override@JsonKey(name: 'employee_id') final  String employeeId;
@override@JsonKey(name: 'employee_name') final  String employeeName;
@override@JsonKey(name: 'base_salary') final  double baseSalary;
@override@JsonKey(name: 'working_days') final  int workingDays;
@override@JsonKey(name: 'absent_days') final  int absentDays;
@override@JsonKey() final  double overtime;
@override@JsonKey() final  double bonuses;
@override@JsonKey() final  double deductions;
@override@JsonKey(name: 'net_salary') final  double netSalary;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of PayrollLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollLineModelCopyWith<_PayrollLineModel> get copyWith => __$PayrollLineModelCopyWithImpl<_PayrollLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.payrollId, payrollId) || other.payrollId == payrollId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary)&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.absentDays, absentDays) || other.absentDays == absentDays)&&(identical(other.overtime, overtime) || other.overtime == overtime)&&(identical(other.bonuses, bonuses) || other.bonuses == bonuses)&&(identical(other.deductions, deductions) || other.deductions == deductions)&&(identical(other.netSalary, netSalary) || other.netSalary == netSalary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,payrollId,employeeId,employeeName,baseSalary,workingDays,absentDays,overtime,bonuses,deductions,netSalary,createdAt,updatedAt);

@override
String toString() {
  return 'PayrollLineModel(id: $id, payrollId: $payrollId, employeeId: $employeeId, employeeName: $employeeName, baseSalary: $baseSalary, workingDays: $workingDays, absentDays: $absentDays, overtime: $overtime, bonuses: $bonuses, deductions: $deductions, netSalary: $netSalary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PayrollLineModelCopyWith<$Res> implements $PayrollLineModelCopyWith<$Res> {
  factory _$PayrollLineModelCopyWith(_PayrollLineModel value, $Res Function(_PayrollLineModel) _then) = __$PayrollLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'payroll_id') String payrollId,@JsonKey(name: 'employee_id') String employeeId,@JsonKey(name: 'employee_name') String employeeName,@JsonKey(name: 'base_salary') double baseSalary,@JsonKey(name: 'working_days') int workingDays,@JsonKey(name: 'absent_days') int absentDays, double overtime, double bonuses, double deductions,@JsonKey(name: 'net_salary') double netSalary,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$PayrollLineModelCopyWithImpl<$Res>
    implements _$PayrollLineModelCopyWith<$Res> {
  __$PayrollLineModelCopyWithImpl(this._self, this._then);

  final _PayrollLineModel _self;
  final $Res Function(_PayrollLineModel) _then;

/// Create a copy of PayrollLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? payrollId = null,Object? employeeId = null,Object? employeeName = null,Object? baseSalary = null,Object? workingDays = null,Object? absentDays = null,Object? overtime = null,Object? bonuses = null,Object? deductions = null,Object? netSalary = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PayrollLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,payrollId: null == payrollId ? _self.payrollId : payrollId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as double,workingDays: null == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as int,absentDays: null == absentDays ? _self.absentDays : absentDays // ignore: cast_nullable_to_non_nullable
as int,overtime: null == overtime ? _self.overtime : overtime // ignore: cast_nullable_to_non_nullable
as double,bonuses: null == bonuses ? _self.bonuses : bonuses // ignore: cast_nullable_to_non_nullable
as double,deductions: null == deductions ? _self.deductions : deductions // ignore: cast_nullable_to_non_nullable
as double,netSalary: null == netSalary ? _self.netSalary : netSalary // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
