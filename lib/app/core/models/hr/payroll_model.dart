/// 💵 موديل مسير وتفاصيل الرواتب الشهرية للموظفين (Payroll Model)
class PayrollModel {
  // 🆔 المعرف الفريد لمسير الراتب (Primary Key)
  final String id;

  // 👤 معرف الموظف
  final String employeeId;

  // 👤 اسم الموظف/الصيدلي
  final String employeeName;

  // 📅 الشهر والسنة المستحقة (مثل: 05-2026)
  final String monthYear;

  // 💵 الراتب الأساسي المتعاقد عليه بالجنيه
  final double basicSalary;

  // 💵 قيمة البدلات والحوافز والمكافآت (Allowances & Bonuses)
  final double allowances;

  // 💵 قيمة الخصومات والجزاءات والغرامات (Deductions & Penalties)
  final double deductions;

  // 💵 قيمة السلف والسحبيات المسحوبة خلال الشهر (Advances)
  final double advances;

  // 💰 صافي الراتب المستحق للصرف النهائي (الأساسي + البدلات - الخصومات - السلف)
  final double netSalary;

  // 🟢 حالة صرف الراتب (غير مدفوع unpaid / مدفوع paid)
  final bool isPaid;

  // 📅 تاريخ ووقت صرف الراتب
  final DateTime? paidAt;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🏬 معرف الفرع
  final String? branchId;

  // 📝 ملاحظات مسير الراتب
  final String? notes;

  PayrollModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.monthYear,
    required this.basicSalary,
    this.allowances = 0.0,
    this.deductions = 0.0,
    this.advances = 0.0,
    required this.netSalary,
    this.isPaid = false,
    this.paidAt,
    this.accountId,
    this.branchId,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'employee_id': employeeId,
    'employee_name': employeeName,
    'month_year': monthYear,
    'basic_salary': basicSalary,
    'allowances': allowances,
    'deductions': deductions,
    'advances': advances,
    'net_salary': netSalary,
    'is_paid': isPaid,
    'paid_at': paidAt?.toIso8601String(),
    'account_id': accountId,
    'branch_id': branchId,
    'notes': notes,
  };

  PayrollModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? monthYear,
    double? basicSalary,
    double? allowances,
    double? deductions,
    double? advances,
    double? netSalary,
    bool? isPaid,
    DateTime? paidAt,
    String? accountId,
    String? branchId,
    String? notes,
  }) {
    return PayrollModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      monthYear: monthYear ?? this.monthYear,
      basicSalary: basicSalary ?? this.basicSalary,
      allowances: allowances ?? this.allowances,
      deductions: deductions ?? this.deductions,
      advances: advances ?? this.advances,
      netSalary: netSalary ?? this.netSalary,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      accountId: accountId ?? this.accountId,
      branchId: branchId ?? this.branchId,
      notes: notes ?? this.notes,
    );
  }

  factory PayrollModel.fromJson(Map<String, dynamic> json) => PayrollModel(
    id: json['id'] as String,
    employeeId: json['employee_id'] as String,
    employeeName: json['employee_name'] as String? ?? '',
    monthYear: json['month_year'] as String? ?? '',
    basicSalary: (json['basic_salary'] as num?)?.toDouble() ?? 0.0,
    allowances: (json['allowances'] as num?)?.toDouble() ?? 0.0,
    deductions: (json['deductions'] as num?)?.toDouble() ?? 0.0,
    advances: (json['advances'] as num?)?.toDouble() ?? 0.0,
    netSalary: (json['net_salary'] as num?)?.toDouble() ?? 0.0,
    isPaid: json['is_paid'] as bool? ?? false,
    paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at'] as String) : null,
    accountId: json['account_id'] as String?,
    branchId: json['branch_id'] as String?,
    notes: json['notes'] as String?,
  );
}


