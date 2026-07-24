// hr_strings.dart — الموارد البشرية (الموظفين، الحضور، الإجازات، الرواتب، الإدارات)



class HrStrings {
  HrStrings._();

  // ─── HR ───
  static const String hrTitle = 'إدارة الموارد البشرية';
  static const String hrEmployees = 'الموظفين';
  static const String hrAttendance = 'الحضور والانصراف';
  static const String hrLeave = 'الإجازات';
  static const String hrPayroll = 'الرواتب';
  static const String hrDepartments = 'الإدارات';
  static const String hrTodayAttendance = 'حضور اليوم';
  static const String hrPresent = 'تم الحضور';
  static const String hrDeparted = 'تم الانصراف';
  static const String hrTotal = 'الإجمالي';
  static const String hrCheckOut = 'تسجيل انصراف';
  static const String hrCheckIn = 'تسجيل حضور';
  static const String hrNoEmployees = 'لا يوجد موظفون للتسجيل';
  static const String hrAttendanceLog = 'سجل الحضور';
  static const String hrNewPayroll = 'إنشاء كشف راتب جديد';
  static const String hrYear = 'السنة';
  static const String hrCreatePayroll = 'إنشاء الكشف';
  static const String hrPayrollSummary = 'إجمالي مخصصات الرواتب للشهر الحالي';
  static const String hrDraft = 'مسودة';
  static const String hrProcessing = 'قيد التجهيز';
  static const String hrApproved = 'معتمد';
  static const String hrPaid = 'مدفوع';
  static const String hrPreviousPayrolls = 'كشوف الرواتب السابقة';
  static const String hrStartProcessing = 'بدء التجهيز';
  static const String hrApprovePayroll = 'اعتماد الكشف';
  static const String hrViewDetails = 'عرض التفاصيل';

  // ─── HR: Employees ───
  static const String hrEmpEmpty = 'لا يوجد موظفون';
  static const String hrEmpEmptySubtitle = 'لم يتم إضافة أي موظفين بعد.';
  static const String hrEmpAdd = 'إضافة موظف جديد';
  static const String hrEmpFullName = 'الاسم الكامل';
  static const String hrEmpPhone = 'رقم الهاتف';
  static const String hrEmpMobileHint = 'رقم الجوال';
  static const String hrEmpJobTitle = 'المسمى الوظيفي';
  static const String hrEmpDepartment = 'الإدارة';
  static const String hrEmpDepartmentHint = 'اختر الإدارة';
  static const String hrEmpNotes = 'ملاحظات';
  static const String hrEmpNotesHint = 'ملاحظات إضافية';
  static const String hrEmpAddButton = 'إضافة الموظف';
  static const String hrEmpStatusActive = 'نشط';
  static const String hrEmpStatusInactive = 'غير نشط';
  static const String hrEmpStatusLeft = 'غادر';
  static const String hrEmpDelete = 'حذف الموظف';
  static const String hrEmpDeleteConfirm = 'هل أنت متأكد من حذف الموظف "';
  static const String hrEmpEdit = 'تعديل البيانات';
  static const String hrEmpEditDialog = 'تعديل بيانات الموظف';
  static const String hrEmpName = 'الاسم';
  static const String hrEmpBaseSalary = 'الراتب الأساسي';
  static const String hrEmpStatus = 'حالة الموظف';
  static const String hrEmpStatusHint = 'اختر الحالة';

  // ─── HR: Departments ───
  static const String hrDeptEmpty = 'لا توجد إدارات';
  static const String hrDeptEmptySubtitle = 'لم يتم إضافة أي إدارات بعد.';
  static const String hrDeptAdd = 'إضافة إدارة جديدة';
  static const String hrDeptName = 'اسم الإدارة';
  static const String hrDeptDescription = 'الوصف';
  static const String hrDeptDescriptionHint = 'وصف مختصر';
  static const String hrDeptManager = 'مدير الإدارة';
  static const String hrDeptManagerHint = 'اختر موظف';

  // ─── HR: Leave ───
  static const String hrLeaveNew = 'طلب إجازة جديدة';
  static const String hrLeaveEmployee = 'الموظف';
  static const String hrLeaveEmployeeHint = 'اختر الموظف';
  static const String hrLeaveType = 'نوع الإجازة';
  static const String hrLeaveTypeHint = 'اختر النوع';
  static const String hrLeaveSick = 'مرضية';
  static const String hrLeaveAnnual = 'سنوية';
  static const String hrLeaveEmergency = 'طارئة';
  static const String hrLeaveMission = 'مأمورية';
  static const String hrLeaveUnpaid = 'إجازة بدون مرتب';
  static const String hrLeaveStartDate = 'تاريخ البداية';
  static const String hrLeaveEndDate = 'تاريخ النهاية';

  // ─── HR: Messages (Bloc) ───
  static const String hrMsgEmployeeAdded = 'تم إضافة الموظف بنجاح';
  static const String hrMsgEmployeeUpdated = 'تم تحديث بيانات الموظف';
  static const String hrMsgEmployeeDeleted = 'تم حذف الموظف';
  static const String hrMsgAttendanceIn = 'تم تسجيل الحضور';
  static const String hrMsgAttendanceOut = 'تم تسجيل الانصراف';
  static const String hrMsgLeaveRequested = 'تم تقديم طلب الإجازة';
  static const String hrMsgLeaveApproved = 'تم الموافقة على الإجازة';
  static const String hrMsgLeaveRejected = 'تم رفض الإجازة';
  static const String hrMsgPayrollCreated = 'تم إنشاء كشف الراتب';
  static const String hrMsgPayrollProcessed = 'تم تجهيز كشف الراتب';
  static const String hrMsgPayrollApproved = 'تم اعتماد كشف الراتب';
  static const String hrMsgDepartmentAdded = 'تم إضافة الإدارة بنجاح';
  static const String hrMsgDepartmentUpdated = 'تم تحديث الإدارة';
  static const String hrMsgDepartmentDeleted = 'تم حذف الإدارة';
}


