/// 🕒 موديل سجل وبصمة الحضور والانصراف (Attendance Model)
class AttendanceModel {
  // 🆔 المعرف الفريد لسجل الحضور (Primary Key)
  final String id;

  // 👤 معرف الموظف/الصيدلي
  final String employeeId;

  // 👤 اسم الموظف/الصيدلي
  final String employeeName;

  // 📅 تاريخ اليوم (yyyy-MM-dd)
  final DateTime date;

  // 🕒 وقت تسجيل الحضور/البصمة الأولى
  final DateTime checkInTime;

  // 🕒 وقت تسجيل الانصراف/البصمة الثانية
  final DateTime? checkOutTime;

  // ⏱️ إجمالي ساعات العمل الفعلية بالدعم المباشر
  final double workHours;

  // ⏱️ ساعات العمل الإضافية (Overtime Hours)
  final double overtimeHours;

  // ⏱️ دقائق التأخير (Late Minutes)
  final int lateMinutes;

  // 🟢 حالة التواجد (حاضر present / غائب absent / إجازة leave / مغادر earlyLeave)
  final String status;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🏬 معرف الفرع
  final String? branchId;

  // 📝 ملاحظات السجل
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    this.workHours = 0.0,
    this.overtimeHours = 0.0,
    this.lateMinutes = 0,
    this.status = 'present',
    this.accountId,
    this.branchId,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'employee_id': employeeId,
    'employee_name': employeeName,
    'date': date.toIso8601String(),
    'check_in_time': checkInTime.toIso8601String(),
    'check_out_time': checkOutTime?.toIso8601String(),
    'work_hours': workHours,
    'overtime_hours': overtimeHours,
    'late_minutes': lateMinutes,
    'status': status,
    'account_id': accountId,
    'branch_id': branchId,
    'notes': notes,
  };

  AttendanceModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? workHours,
    double? overtimeHours,
    int? lateMinutes,
    String? status,
    String? accountId,
    String? branchId,
    String? notes,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      workHours: workHours ?? this.workHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
      branchId: branchId ?? this.branchId,
      notes: notes ?? this.notes,
    );
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    id: json['id'] as String,
    employeeId: json['employee_id'] as String,
    employeeName: json['employee_name'] as String? ?? '',
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    checkInTime: DateTime.tryParse(json['check_in_time'] as String? ?? '') ?? DateTime.now(),
    checkOutTime: json['check_out_time'] != null ? DateTime.tryParse(json['check_out_time'] as String) : null,
    workHours: (json['work_hours'] as num?)?.toDouble() ?? 0.0,
    overtimeHours: (json['overtime_hours'] as num?)?.toDouble() ?? 0.0,
    lateMinutes: (json['late_minutes'] as num?)?.toInt() ?? 0,
    status: json['status'] as String? ?? 'present',
    accountId: json['account_id'] as String?,
    branchId: json['branch_id'] as String?,
    notes: json['notes'] as String?,
  );
}


