// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveModel {

 String get id;@JsonKey(name: 'employee_id') String get employeeId;@JsonKey(name: 'employee_name') String get employeeName;@JsonKey(name: 'leave_type') String get leaveType;@JsonKey(name: 'start_date') String get startDate;@JsonKey(name: 'end_date') String get endDate; int get duration; String get status; String? get reason;@JsonKey(name: 'approved_by') String? get approvedBy;@JsonKey(name: 'rejection_reason') String? get rejectionReason;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveModelCopyWith<LeaveModel> get copyWith => _$LeaveModelCopyWithImpl<LeaveModel>(this as LeaveModel, _$identity);

  /// Serializes this LeaveModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,leaveType,startDate,endDate,duration,status,reason,approvedBy,rejectionReason,createdAt,updatedAt);

@override
String toString() {
  return 'LeaveModel(id: $id, employeeId: $employeeId, employeeName: $employeeName, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, duration: $duration, status: $status, reason: $reason, approvedBy: $approvedBy, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LeaveModelCopyWith<$Res>  {
  factory $LeaveModelCopyWith(LeaveModel value, $Res Function(LeaveModel) _then) = _$LeaveModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'employee_id') String employeeId,@JsonKey(name: 'employee_name') String employeeName,@JsonKey(name: 'leave_type') String leaveType,@JsonKey(name: 'start_date') String startDate,@JsonKey(name: 'end_date') String endDate, int duration, String status, String? reason,@JsonKey(name: 'approved_by') String? approvedBy,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$LeaveModelCopyWithImpl<$Res>
    implements $LeaveModelCopyWith<$Res> {
  _$LeaveModelCopyWithImpl(this._self, this._then);

  final LeaveModel _self;
  final $Res Function(LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? duration = null,Object? status = null,Object? reason = freezed,Object? approvedBy = freezed,Object? rejectionReason = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveModel].
extension LeaveModelPatterns on LeaveModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'leave_type')  String leaveType, @JsonKey(name: 'start_date')  String startDate, @JsonKey(name: 'end_date')  String endDate,  int duration,  String status,  String? reason, @JsonKey(name: 'approved_by')  String? approvedBy, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.leaveType,_that.startDate,_that.endDate,_that.duration,_that.status,_that.reason,_that.approvedBy,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'leave_type')  String leaveType, @JsonKey(name: 'start_date')  String startDate, @JsonKey(name: 'end_date')  String endDate,  int duration,  String status,  String? reason, @JsonKey(name: 'approved_by')  String? approvedBy, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LeaveModel():
return $default(_that.id,_that.employeeId,_that.employeeName,_that.leaveType,_that.startDate,_that.endDate,_that.duration,_that.status,_that.reason,_that.approvedBy,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'employee_id')  String employeeId, @JsonKey(name: 'employee_name')  String employeeName, @JsonKey(name: 'leave_type')  String leaveType, @JsonKey(name: 'start_date')  String startDate, @JsonKey(name: 'end_date')  String endDate,  int duration,  String status,  String? reason, @JsonKey(name: 'approved_by')  String? approvedBy, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.leaveType,_that.startDate,_that.endDate,_that.duration,_that.status,_that.reason,_that.approvedBy,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveModel extends LeaveModel {
  const _LeaveModel({required this.id, @JsonKey(name: 'employee_id') required this.employeeId, @JsonKey(name: 'employee_name') this.employeeName = '', @JsonKey(name: 'leave_type') required this.leaveType, @JsonKey(name: 'start_date') required this.startDate, @JsonKey(name: 'end_date') required this.endDate, this.duration = 1, this.status = 'pending', this.reason, @JsonKey(name: 'approved_by') this.approvedBy, @JsonKey(name: 'rejection_reason') this.rejectionReason, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _LeaveModel.fromJson(Map<String, dynamic> json) => _$LeaveModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'employee_id') final  String employeeId;
@override@JsonKey(name: 'employee_name') final  String employeeName;
@override@JsonKey(name: 'leave_type') final  String leaveType;
@override@JsonKey(name: 'start_date') final  String startDate;
@override@JsonKey(name: 'end_date') final  String endDate;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String status;
@override final  String? reason;
@override@JsonKey(name: 'approved_by') final  String? approvedBy;
@override@JsonKey(name: 'rejection_reason') final  String? rejectionReason;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveModelCopyWith<_LeaveModel> get copyWith => __$LeaveModelCopyWithImpl<_LeaveModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,leaveType,startDate,endDate,duration,status,reason,approvedBy,rejectionReason,createdAt,updatedAt);

@override
String toString() {
  return 'LeaveModel(id: $id, employeeId: $employeeId, employeeName: $employeeName, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, duration: $duration, status: $status, reason: $reason, approvedBy: $approvedBy, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LeaveModelCopyWith<$Res> implements $LeaveModelCopyWith<$Res> {
  factory _$LeaveModelCopyWith(_LeaveModel value, $Res Function(_LeaveModel) _then) = __$LeaveModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'employee_id') String employeeId,@JsonKey(name: 'employee_name') String employeeName,@JsonKey(name: 'leave_type') String leaveType,@JsonKey(name: 'start_date') String startDate,@JsonKey(name: 'end_date') String endDate, int duration, String status, String? reason,@JsonKey(name: 'approved_by') String? approvedBy,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$LeaveModelCopyWithImpl<$Res>
    implements _$LeaveModelCopyWith<$Res> {
  __$LeaveModelCopyWithImpl(this._self, this._then);

  final _LeaveModel _self;
  final $Res Function(_LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? duration = null,Object? status = null,Object? reason = freezed,Object? approvedBy = freezed,Object? rejectionReason = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_LeaveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$LeaveBalance {

 LeaveTypeBalance get sick; LeaveTypeBalance get annual; LeaveTypeBalance get emergency; LeaveTypeBalance get unpaid;
/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceCopyWith<LeaveBalance> get copyWith => _$LeaveBalanceCopyWithImpl<LeaveBalance>(this as LeaveBalance, _$identity);

  /// Serializes this LeaveBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalance&&(identical(other.sick, sick) || other.sick == sick)&&(identical(other.annual, annual) || other.annual == annual)&&(identical(other.emergency, emergency) || other.emergency == emergency)&&(identical(other.unpaid, unpaid) || other.unpaid == unpaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sick,annual,emergency,unpaid);

@override
String toString() {
  return 'LeaveBalance(sick: $sick, annual: $annual, emergency: $emergency, unpaid: $unpaid)';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceCopyWith<$Res>  {
  factory $LeaveBalanceCopyWith(LeaveBalance value, $Res Function(LeaveBalance) _then) = _$LeaveBalanceCopyWithImpl;
@useResult
$Res call({
 LeaveTypeBalance sick, LeaveTypeBalance annual, LeaveTypeBalance emergency, LeaveTypeBalance unpaid
});


$LeaveTypeBalanceCopyWith<$Res> get sick;$LeaveTypeBalanceCopyWith<$Res> get annual;$LeaveTypeBalanceCopyWith<$Res> get emergency;$LeaveTypeBalanceCopyWith<$Res> get unpaid;

}
/// @nodoc
class _$LeaveBalanceCopyWithImpl<$Res>
    implements $LeaveBalanceCopyWith<$Res> {
  _$LeaveBalanceCopyWithImpl(this._self, this._then);

  final LeaveBalance _self;
  final $Res Function(LeaveBalance) _then;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sick = null,Object? annual = null,Object? emergency = null,Object? unpaid = null,}) {
  return _then(_self.copyWith(
sick: null == sick ? _self.sick : sick // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,annual: null == annual ? _self.annual : annual // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,emergency: null == emergency ? _self.emergency : emergency // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,unpaid: null == unpaid ? _self.unpaid : unpaid // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,
  ));
}
/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get sick {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.sick, (value) {
    return _then(_self.copyWith(sick: value));
  });
}/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get annual {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.annual, (value) {
    return _then(_self.copyWith(annual: value));
  });
}/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get emergency {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.emergency, (value) {
    return _then(_self.copyWith(emergency: value));
  });
}/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get unpaid {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.unpaid, (value) {
    return _then(_self.copyWith(unpaid: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveBalance].
extension LeaveBalancePatterns on LeaveBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalance value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalance value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LeaveTypeBalance sick,  LeaveTypeBalance annual,  LeaveTypeBalance emergency,  LeaveTypeBalance unpaid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
return $default(_that.sick,_that.annual,_that.emergency,_that.unpaid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LeaveTypeBalance sick,  LeaveTypeBalance annual,  LeaveTypeBalance emergency,  LeaveTypeBalance unpaid)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalance():
return $default(_that.sick,_that.annual,_that.emergency,_that.unpaid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LeaveTypeBalance sick,  LeaveTypeBalance annual,  LeaveTypeBalance emergency,  LeaveTypeBalance unpaid)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
return $default(_that.sick,_that.annual,_that.emergency,_that.unpaid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveBalance extends LeaveBalance {
  const _LeaveBalance({this.sick = const LeaveTypeBalance(total: 30), this.annual = const LeaveTypeBalance(total: 21), this.emergency = const LeaveTypeBalance(total: 7), this.unpaid = const LeaveTypeBalance(total: 30)}): super._();
  factory _LeaveBalance.fromJson(Map<String, dynamic> json) => _$LeaveBalanceFromJson(json);

@override@JsonKey() final  LeaveTypeBalance sick;
@override@JsonKey() final  LeaveTypeBalance annual;
@override@JsonKey() final  LeaveTypeBalance emergency;
@override@JsonKey() final  LeaveTypeBalance unpaid;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceCopyWith<_LeaveBalance> get copyWith => __$LeaveBalanceCopyWithImpl<_LeaveBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalance&&(identical(other.sick, sick) || other.sick == sick)&&(identical(other.annual, annual) || other.annual == annual)&&(identical(other.emergency, emergency) || other.emergency == emergency)&&(identical(other.unpaid, unpaid) || other.unpaid == unpaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sick,annual,emergency,unpaid);

@override
String toString() {
  return 'LeaveBalance(sick: $sick, annual: $annual, emergency: $emergency, unpaid: $unpaid)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceCopyWith<$Res> implements $LeaveBalanceCopyWith<$Res> {
  factory _$LeaveBalanceCopyWith(_LeaveBalance value, $Res Function(_LeaveBalance) _then) = __$LeaveBalanceCopyWithImpl;
@override @useResult
$Res call({
 LeaveTypeBalance sick, LeaveTypeBalance annual, LeaveTypeBalance emergency, LeaveTypeBalance unpaid
});


@override $LeaveTypeBalanceCopyWith<$Res> get sick;@override $LeaveTypeBalanceCopyWith<$Res> get annual;@override $LeaveTypeBalanceCopyWith<$Res> get emergency;@override $LeaveTypeBalanceCopyWith<$Res> get unpaid;

}
/// @nodoc
class __$LeaveBalanceCopyWithImpl<$Res>
    implements _$LeaveBalanceCopyWith<$Res> {
  __$LeaveBalanceCopyWithImpl(this._self, this._then);

  final _LeaveBalance _self;
  final $Res Function(_LeaveBalance) _then;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sick = null,Object? annual = null,Object? emergency = null,Object? unpaid = null,}) {
  return _then(_LeaveBalance(
sick: null == sick ? _self.sick : sick // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,annual: null == annual ? _self.annual : annual // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,emergency: null == emergency ? _self.emergency : emergency // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,unpaid: null == unpaid ? _self.unpaid : unpaid // ignore: cast_nullable_to_non_nullable
as LeaveTypeBalance,
  ));
}

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get sick {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.sick, (value) {
    return _then(_self.copyWith(sick: value));
  });
}/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get annual {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.annual, (value) {
    return _then(_self.copyWith(annual: value));
  });
}/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get emergency {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.emergency, (value) {
    return _then(_self.copyWith(emergency: value));
  });
}/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<$Res> get unpaid {
  
  return $LeaveTypeBalanceCopyWith<$Res>(_self.unpaid, (value) {
    return _then(_self.copyWith(unpaid: value));
  });
}
}


/// @nodoc
mixin _$LeaveTypeBalance {

 int get total; int get used; int get remaining;
/// Create a copy of LeaveTypeBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveTypeBalanceCopyWith<LeaveTypeBalance> get copyWith => _$LeaveTypeBalanceCopyWithImpl<LeaveTypeBalance>(this as LeaveTypeBalance, _$identity);

  /// Serializes this LeaveTypeBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveTypeBalance&&(identical(other.total, total) || other.total == total)&&(identical(other.used, used) || other.used == used)&&(identical(other.remaining, remaining) || other.remaining == remaining));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,used,remaining);

@override
String toString() {
  return 'LeaveTypeBalance(total: $total, used: $used, remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class $LeaveTypeBalanceCopyWith<$Res>  {
  factory $LeaveTypeBalanceCopyWith(LeaveTypeBalance value, $Res Function(LeaveTypeBalance) _then) = _$LeaveTypeBalanceCopyWithImpl;
@useResult
$Res call({
 int total, int used, int remaining
});




}
/// @nodoc
class _$LeaveTypeBalanceCopyWithImpl<$Res>
    implements $LeaveTypeBalanceCopyWith<$Res> {
  _$LeaveTypeBalanceCopyWithImpl(this._self, this._then);

  final LeaveTypeBalance _self;
  final $Res Function(LeaveTypeBalance) _then;

/// Create a copy of LeaveTypeBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? used = null,Object? remaining = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveTypeBalance].
extension LeaveTypeBalancePatterns on LeaveTypeBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveTypeBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveTypeBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveTypeBalance value)  $default,){
final _that = this;
switch (_that) {
case _LeaveTypeBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveTypeBalance value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveTypeBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int used,  int remaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveTypeBalance() when $default != null:
return $default(_that.total,_that.used,_that.remaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int used,  int remaining)  $default,) {final _that = this;
switch (_that) {
case _LeaveTypeBalance():
return $default(_that.total,_that.used,_that.remaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int used,  int remaining)?  $default,) {final _that = this;
switch (_that) {
case _LeaveTypeBalance() when $default != null:
return $default(_that.total,_that.used,_that.remaining);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveTypeBalance extends LeaveTypeBalance {
  const _LeaveTypeBalance({this.total = 30, this.used = 0, this.remaining = 30}): super._();
  factory _LeaveTypeBalance.fromJson(Map<String, dynamic> json) => _$LeaveTypeBalanceFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  int used;
@override@JsonKey() final  int remaining;

/// Create a copy of LeaveTypeBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveTypeBalanceCopyWith<_LeaveTypeBalance> get copyWith => __$LeaveTypeBalanceCopyWithImpl<_LeaveTypeBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveTypeBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveTypeBalance&&(identical(other.total, total) || other.total == total)&&(identical(other.used, used) || other.used == used)&&(identical(other.remaining, remaining) || other.remaining == remaining));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,used,remaining);

@override
String toString() {
  return 'LeaveTypeBalance(total: $total, used: $used, remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class _$LeaveTypeBalanceCopyWith<$Res> implements $LeaveTypeBalanceCopyWith<$Res> {
  factory _$LeaveTypeBalanceCopyWith(_LeaveTypeBalance value, $Res Function(_LeaveTypeBalance) _then) = __$LeaveTypeBalanceCopyWithImpl;
@override @useResult
$Res call({
 int total, int used, int remaining
});




}
/// @nodoc
class __$LeaveTypeBalanceCopyWithImpl<$Res>
    implements _$LeaveTypeBalanceCopyWith<$Res> {
  __$LeaveTypeBalanceCopyWithImpl(this._self, this._then);

  final _LeaveTypeBalance _self;
  final $Res Function(_LeaveTypeBalance) _then;

/// Create a copy of LeaveTypeBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? used = null,Object? remaining = null,}) {
  return _then(_LeaveTypeBalance(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
