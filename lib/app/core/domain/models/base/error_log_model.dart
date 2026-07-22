import 'package:equatable/equatable.dart';

/// مستوى خطورة الخطأ المزمن.
enum ErrorSeverity {
  /// خطأ يمنع عملية أو يُفقد بيانات (مزامنة، حفظ، استيراد).
  critical,

  /// خطأ منطقي أو سلوك غير متوقع لكن لا يوقف التطبيق.
  warning,

  /// ملاحظة تقنية لمراجعة لاحقة.
  info,
}

/// نموذج خطأ مزمن يُحفظ لعرضه لاحقاً في صفحة الأخطاء.
class ErrorLogModel extends Equatable {
  final String id;
  final String title;
  final String message;
  final String? source;
  final String? stackTrace;
  final ErrorSeverity severity;
  final DateTime createdAt;
  final bool isRead;

  const ErrorLogModel({
    required this.id,
    required this.title,
    required this.message,
    this.source,
    this.stackTrace,
    this.severity = ErrorSeverity.warning,
    required this.createdAt,
    this.isRead = false,
  });

  ErrorLogModel copyWith({bool? isRead}) {
    return ErrorLogModel(
      id: id,
      title: title,
      message: message,
      source: source,
      stackTrace: stackTrace,
      severity: severity,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id];
}
