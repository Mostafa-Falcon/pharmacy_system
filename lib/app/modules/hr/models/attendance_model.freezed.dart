// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceModel {

 String get id;@JsonKey(name: 'employee_id') String get employeeId;@JsonKey(name: 'employee_name') String get employeeName;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'clock_in') String get clockIn;@JsonKey(name: 'clock_out') String? get clockOut; String get date; String get status;@JsonKey(name: 'approved_by') String? get approvedBy; String? get notes;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceModelCopyWith<AttendanceModel> get copyWith => _$AttendanceModelCopyWithImpl<AttendanceModel>(this as AttendanceModel, _$identity);

  /// Serializes this AttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.clockIn, clockIn) || other.clockIn == clockIn)&&(identical(other.clockOut, clockOut) || other.clockOut == clockOut)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,branchId,clockIn,clockOut,date,status,approvedBy,notes,createdAt,updatedAt);

@override
String toString() {
  return 'AttendanceModel(id: $id, employeeId: $employeeId, employeeName: $employeeName, branchId: $branchId, clockIn: $clockIn, clockOut: $clockOut, date: $date, status: $status, approvedBy: $approvedBy, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AttendanceModelCopyWith<$Res>  {
  factory $AttendanceModelCopyWith(AttendanceModel value, $Res Function(AttendanceModel) _then) = _$AttendanceModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'employee_id') String employeeId,@JsonKey(name: 'employee_name') String employeeName,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'clock_in') String clockIn,@JsonKey(name: 'clock_out') String? clockOut, String date, String status,@JsonKey(name: 'approved_by') String? approvedBy, String? notes,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$AttendanceModelCopyWithImpl<$Res>
    implements $AttendanceModelCopyWith<$Res> {
  _$AttendanceModelCopyWithImpl(this._self, this._then);

  final AttendanceModel _self;
  final $Res Function(AttendanceModel) _then;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? branchId = null,Object? clockIn = null,Object? clockOut = freezed,Object? date = null,Object? status = null,Object? approvedBy = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,clockIn: null == clockIn ? _self.clockIn : clockIn // ignore: cast_nullable_to_non_nullable
as String,clockOut: freezed == clockOut ? _self.clockOut : clockOut // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceModel].
extension AttendanceModelPatterns on AttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'clock_in')  String clockIn, @JsonKey(name: 'clock_out')  String? clockOut,  String date,  String status, @JsonKey(name: 'approved_by')  String? approvedBy,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.branchId,_that.clockIn,_that.clockOut,_that.date,_that.status,_that.approvedBy,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'clock_in')  String clockIn, @JsonKey(name: 'clock_out')  String? clockOut,  String date,  String status, @JsonKey(name: 'approved_by')  String? approvedBy,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel():
return $default(_that.id,_that.employeeId,_that.employeeName,_that.branchId,_that.clockIn,_that.clockOut,_that.date,_that.status,_that.approvedBy,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'clock_in')  String clockIn, @JsonKey(name: 'clock_out')  String? clockOut,  String date,  String status, @JsonKey(name: 'approved_by')  String? approvedBy,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.branchId,_that.clockIn,_that.clockOut,_that.date,_that.status,_that.approvedBy,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceModel extends AttendanceModel {
  const _AttendanceModel({required this.id, @JsonKey(name: 'employee_id') required this.employeeId, @JsonKey(name: 'employee_name') this.employeeName = '', @JsonKey(name: 'branch_id') this.branchId = '', @JsonKey(name: 'clock_in') this.clockIn = '', @JsonKey(name: 'clock_out') this.clockOut, required this.date, this.status = 'present', @JsonKey(name: 'approved_by') this.approvedBy, this.notes, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _AttendanceModel.fromJson(Map<String, dynamic> json) => _$AttendanceModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'employee_id') final  String employeeId;
@override@JsonKey(name: 'employee_name') final  String employeeName;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'clock_in') final  String clockIn;
@override@JsonKey(name: 'clock_out') final  String? clockOut;
@override final  String date;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'approved_by') final  String? approvedBy;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceModelCopyWith<_AttendanceModel> get copyWith => __$AttendanceModelCopyWithImpl<_AttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.clockIn, clockIn) || other.clockIn == clockIn)&&(identical(other.clockOut, clockOut) || other.clockOut == clockOut)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,branchId,clockIn,clockOut,date,status,approvedBy,notes,createdAt,updatedAt);

@override
String toString() {
  return 'AttendanceModel(id: $id, employeeId: $employeeId, employeeName: $employeeName, branchId: $branchId, clockIn: $clockIn, clockOut: $clockOut, date: $date, status: $status, approvedBy: $approvedBy, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AttendanceModelCopyWith<$Res> implements $AttendanceModelCopyWith<$Res> {
  factory _$AttendanceModelCopyWith(_AttendanceModel value, $Res Function(_AttendanceModel) _then) = __$AttendanceModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'employee_id') String employeeId,@JsonKey(name: 'employee_name') String employeeName,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'clock_in') String clockIn,@JsonKey(name: 'clock_out') String? clockOut, String date, String status,@JsonKey(name: 'approved_by') String? approvedBy, String? notes,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$AttendanceModelCopyWithImpl<$Res>
    implements _$AttendanceModelCopyWith<$Res> {
  __$AttendanceModelCopyWithImpl(this._self, this._then);

  final _AttendanceModel _self;
  final $Res Function(_AttendanceModel) _then;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? branchId = null,Object? clockIn = null,Object? clockOut = freezed,Object? date = null,Object? status = null,Object? approvedBy = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AttendanceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,clockIn: null == clockIn ? _self.clockIn : clockIn // ignore: cast_nullable_to_non_nullable
as String,clockOut: freezed == clockOut ? _self.clockOut : clockOut // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AttendanceReport {

 String get month; int get year;@JsonKey(name: 'total_employees') int get totalEmployees;@JsonKey(name: 'total_working_days') int get totalWorkingDays; AttendanceSummary get summary; List<AttendanceModel> get records;
/// Create a copy of AttendanceReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceReportCopyWith<AttendanceReport> get copyWith => _$AttendanceReportCopyWithImpl<AttendanceReport>(this as AttendanceReport, _$identity);

  /// Serializes this AttendanceReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceReport&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalEmployees, totalEmployees) || other.totalEmployees == totalEmployees)&&(identical(other.totalWorkingDays, totalWorkingDays) || other.totalWorkingDays == totalWorkingDays)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.records, records));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,year,totalEmployees,totalWorkingDays,summary,const DeepCollectionEquality().hash(records));

@override
String toString() {
  return 'AttendanceReport(month: $month, year: $year, totalEmployees: $totalEmployees, totalWorkingDays: $totalWorkingDays, summary: $summary, records: $records)';
}


}

/// @nodoc
abstract mixin class $AttendanceReportCopyWith<$Res>  {
  factory $AttendanceReportCopyWith(AttendanceReport value, $Res Function(AttendanceReport) _then) = _$AttendanceReportCopyWithImpl;
@useResult
$Res call({
 String month, int year,@JsonKey(name: 'total_employees') int totalEmployees,@JsonKey(name: 'total_working_days') int totalWorkingDays, AttendanceSummary summary, List<AttendanceModel> records
});


$AttendanceSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$AttendanceReportCopyWithImpl<$Res>
    implements $AttendanceReportCopyWith<$Res> {
  _$AttendanceReportCopyWithImpl(this._self, this._then);

  final AttendanceReport _self;
  final $Res Function(AttendanceReport) _then;

/// Create a copy of AttendanceReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? year = null,Object? totalEmployees = null,Object? totalWorkingDays = null,Object? summary = null,Object? records = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalEmployees: null == totalEmployees ? _self.totalEmployees : totalEmployees // ignore: cast_nullable_to_non_nullable
as int,totalWorkingDays: null == totalWorkingDays ? _self.totalWorkingDays : totalWorkingDays // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AttendanceSummary,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>,
  ));
}
/// Create a copy of AttendanceReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceSummaryCopyWith<$Res> get summary {
  
  return $AttendanceSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendanceReport].
extension AttendanceReportPatterns on AttendanceReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceReport value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceReport value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  int year, @JsonKey(name: 'total_employees')  int totalEmployees, @JsonKey(name: 'total_working_days')  int totalWorkingDays,  AttendanceSummary summary,  List<AttendanceModel> records)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceReport() when $default != null:
return $default(_that.month,_that.year,_that.totalEmployees,_that.totalWorkingDays,_that.summary,_that.records);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  int year, @JsonKey(name: 'total_employees')  int totalEmployees, @JsonKey(name: 'total_working_days')  int totalWorkingDays,  AttendanceSummary summary,  List<AttendanceModel> records)  $default,) {final _that = this;
switch (_that) {
case _AttendanceReport():
return $default(_that.month,_that.year,_that.totalEmployees,_that.totalWorkingDays,_that.summary,_that.records);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  int year, @JsonKey(name: 'total_employees')  int totalEmployees, @JsonKey(name: 'total_working_days')  int totalWorkingDays,  AttendanceSummary summary,  List<AttendanceModel> records)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceReport() when $default != null:
return $default(_that.month,_that.year,_that.totalEmployees,_that.totalWorkingDays,_that.summary,_that.records);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceReport extends AttendanceReport {
  const _AttendanceReport({required this.month, required this.year, @JsonKey(name: 'total_employees') this.totalEmployees = 0, @JsonKey(name: 'total_working_days') this.totalWorkingDays = 0, this.summary = const AttendanceSummary(), final  List<AttendanceModel> records = const []}): _records = records,super._();
  factory _AttendanceReport.fromJson(Map<String, dynamic> json) => _$AttendanceReportFromJson(json);

@override final  String month;
@override final  int year;
@override@JsonKey(name: 'total_employees') final  int totalEmployees;
@override@JsonKey(name: 'total_working_days') final  int totalWorkingDays;
@override@JsonKey() final  AttendanceSummary summary;
 final  List<AttendanceModel> _records;
@override@JsonKey() List<AttendanceModel> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}


/// Create a copy of AttendanceReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceReportCopyWith<_AttendanceReport> get copyWith => __$AttendanceReportCopyWithImpl<_AttendanceReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceReport&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalEmployees, totalEmployees) || other.totalEmployees == totalEmployees)&&(identical(other.totalWorkingDays, totalWorkingDays) || other.totalWorkingDays == totalWorkingDays)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._records, _records));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,year,totalEmployees,totalWorkingDays,summary,const DeepCollectionEquality().hash(_records));

@override
String toString() {
  return 'AttendanceReport(month: $month, year: $year, totalEmployees: $totalEmployees, totalWorkingDays: $totalWorkingDays, summary: $summary, records: $records)';
}


}

/// @nodoc
abstract mixin class _$AttendanceReportCopyWith<$Res> implements $AttendanceReportCopyWith<$Res> {
  factory _$AttendanceReportCopyWith(_AttendanceReport value, $Res Function(_AttendanceReport) _then) = __$AttendanceReportCopyWithImpl;
@override @useResult
$Res call({
 String month, int year,@JsonKey(name: 'total_employees') int totalEmployees,@JsonKey(name: 'total_working_days') int totalWorkingDays, AttendanceSummary summary, List<AttendanceModel> records
});


@override $AttendanceSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$AttendanceReportCopyWithImpl<$Res>
    implements _$AttendanceReportCopyWith<$Res> {
  __$AttendanceReportCopyWithImpl(this._self, this._then);

  final _AttendanceReport _self;
  final $Res Function(_AttendanceReport) _then;

/// Create a copy of AttendanceReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? year = null,Object? totalEmployees = null,Object? totalWorkingDays = null,Object? summary = null,Object? records = null,}) {
  return _then(_AttendanceReport(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalEmployees: null == totalEmployees ? _self.totalEmployees : totalEmployees // ignore: cast_nullable_to_non_nullable
as int,totalWorkingDays: null == totalWorkingDays ? _self.totalWorkingDays : totalWorkingDays // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AttendanceSummary,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>,
  ));
}

/// Create a copy of AttendanceReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceSummaryCopyWith<$Res> get summary {
  
  return $AttendanceSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$AttendanceSummary {

 int get present; int get late; int get absent;@JsonKey(name: 'half_day') int get halfDay;
/// Create a copy of AttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceSummaryCopyWith<AttendanceSummary> get copyWith => _$AttendanceSummaryCopyWithImpl<AttendanceSummary>(this as AttendanceSummary, _$identity);

  /// Serializes this AttendanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceSummary&&(identical(other.present, present) || other.present == present)&&(identical(other.late, late) || other.late == late)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.halfDay, halfDay) || other.halfDay == halfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,present,late,absent,halfDay);

@override
String toString() {
  return 'AttendanceSummary(present: $present, late: $late, absent: $absent, halfDay: $halfDay)';
}


}

/// @nodoc
abstract mixin class $AttendanceSummaryCopyWith<$Res>  {
  factory $AttendanceSummaryCopyWith(AttendanceSummary value, $Res Function(AttendanceSummary) _then) = _$AttendanceSummaryCopyWithImpl;
@useResult
$Res call({
 int present, int late, int absent,@JsonKey(name: 'half_day') int halfDay
});




}
/// @nodoc
class _$AttendanceSummaryCopyWithImpl<$Res>
    implements $AttendanceSummaryCopyWith<$Res> {
  _$AttendanceSummaryCopyWithImpl(this._self, this._then);

  final AttendanceSummary _self;
  final $Res Function(AttendanceSummary) _then;

/// Create a copy of AttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? present = null,Object? late = null,Object? absent = null,Object? halfDay = null,}) {
  return _then(_self.copyWith(
present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,halfDay: null == halfDay ? _self.halfDay : halfDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceSummary].
extension AttendanceSummaryPatterns on AttendanceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int present,  int late,  int absent, @JsonKey(name: 'half_day')  int halfDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceSummary() when $default != null:
return $default(_that.present,_that.late,_that.absent,_that.halfDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int present,  int late,  int absent, @JsonKey(name: 'half_day')  int halfDay)  $default,) {final _that = this;
switch (_that) {
case _AttendanceSummary():
return $default(_that.present,_that.late,_that.absent,_that.halfDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int present,  int late,  int absent, @JsonKey(name: 'half_day')  int halfDay)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceSummary() when $default != null:
return $default(_that.present,_that.late,_that.absent,_that.halfDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceSummary extends AttendanceSummary {
  const _AttendanceSummary({this.present = 0, this.late = 0, this.absent = 0, @JsonKey(name: 'half_day') this.halfDay = 0}): super._();
  factory _AttendanceSummary.fromJson(Map<String, dynamic> json) => _$AttendanceSummaryFromJson(json);

@override@JsonKey() final  int present;
@override@JsonKey() final  int late;
@override@JsonKey() final  int absent;
@override@JsonKey(name: 'half_day') final  int halfDay;

/// Create a copy of AttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceSummaryCopyWith<_AttendanceSummary> get copyWith => __$AttendanceSummaryCopyWithImpl<_AttendanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceSummary&&(identical(other.present, present) || other.present == present)&&(identical(other.late, late) || other.late == late)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.halfDay, halfDay) || other.halfDay == halfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,present,late,absent,halfDay);

@override
String toString() {
  return 'AttendanceSummary(present: $present, late: $late, absent: $absent, halfDay: $halfDay)';
}


}

/// @nodoc
abstract mixin class _$AttendanceSummaryCopyWith<$Res> implements $AttendanceSummaryCopyWith<$Res> {
  factory _$AttendanceSummaryCopyWith(_AttendanceSummary value, $Res Function(_AttendanceSummary) _then) = __$AttendanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 int present, int late, int absent,@JsonKey(name: 'half_day') int halfDay
});




}
/// @nodoc
class __$AttendanceSummaryCopyWithImpl<$Res>
    implements _$AttendanceSummaryCopyWith<$Res> {
  __$AttendanceSummaryCopyWithImpl(this._self, this._then);

  final _AttendanceSummary _self;
  final $Res Function(_AttendanceSummary) _then;

/// Create a copy of AttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? present = null,Object? late = null,Object? absent = null,Object? halfDay = null,}) {
  return _then(_AttendanceSummary(
present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,halfDay: null == halfDay ? _self.halfDay : halfDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
