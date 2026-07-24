import 'package:pharmacy_system/app/core/models/inventory/medicine_unit_model.dart';

class UnitLevelInfo {
  final String name;
  final double multiplier; // Number of items in the parent unit

  const UnitLevelInfo({required this.name, required this.multiplier});
}

class UnitParsedInfo {
  final String displayName;
  final List<UnitLevelInfo> levels;
  final UnitCategory category;

  const UnitParsedInfo({
    required this.displayName,
    required this.levels,
    required this.category,
  });

  int get piecesPerUnit {
    if (levels.isEmpty) return 1;
    double total = 1.0;
    for (int i = 1; i < levels.length; i++) {
      total *= levels[i].multiplier;
    }
    return total.toInt();
  }

  int get piecesPerSubUnit {
    if (levels.length < 2) return 1;
    double total = 1.0;
    for (int i = 2; i < levels.length; i++) {
      total *= levels[i].multiplier;
    }
    return total.toInt();
  }

  String? get subUnitName => levels.length > 1 ? levels[1].name : null;

  MedicineUnitModel toMainUnit(String medicineId) => MedicineUnitModel(
        id: '${medicineId}_unit_main',
        name: levels.isNotEmpty ? levels[0].name : '\u0639\u0644\u0628\u0629',
        level: 1,
        conversionFactor: piecesPerUnit.toDouble(),
      );

  MedicineUnitModel? toSubUnit(String medicineId) {
    if (levels.length < 2) return null;
    return MedicineUnitModel(
      id: '${medicineId}_unit_2',
      name: levels[1].name,
      level: 2,
      conversionFactor: piecesPerSubUnit.toDouble(),
    );
  }

  MedicineUnitModel baseUnit(String medicineId) {
    final name = levels.isNotEmpty ? levels.last.name : '\u062d\u0628\u0627\u064a\u0629';
    return MedicineUnitModel(
      id: '${medicineId}_unit_base',
      name: name,
      level: 3,
      conversionFactor: 1,
    );
  }
}

enum UnitCategory {
  box,
  strip,
  ampoule,
  tablet,
  sachet,
  film,
  set,
  other,
}

class UnitNormalizer {
  UnitNormalizer._();

  static const _mainUnits = ['علبة', 'كرتونة', 'باكت', 'مجموعة', 'علبه', 'درزن'];
  static const _subUnits = ['شريط', 'امبول', 'كيس', 'بخاخة', 'قمع', 'حقنة', 'فيلم', 'لصقة', 'زجاجة', 'فايال', 'انبول', 'فلرص'];
  static const _baseUnits = ['قرص', 'حبة', 'كبسولة', 'نقطة', 'مل', 'سم', 'وحدة', 'حباية', 'قطعة', 'بخة', 'ملل'];

  static UnitParsedInfo parse(String raw) {
    String text = raw.trim().replaceAll('\u200f', '').replaceAll('\u200e', ''); // Remove RTL/LTR marks
    if (text.isEmpty) {
      return const UnitParsedInfo(
        displayName: 'علبة',
        levels: [UnitLevelInfo(name: 'علبة', multiplier: 1)],
        category: UnitCategory.box,
      );
    }

    // 1. تنظيف وتوحيد الحروف العربية
    text = text
        .replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه').replaceAll('ى', 'ي')
        .replaceAll('قلرص', 'قرص'); // تصحيح "قلرص"

    // 2. استخراج الأرقام والكلمات (Tokens)
    final tokens = _tokenize(text);
    
    // 3. تحليل المستويات
    final levels = <UnitLevelInfo>[];
    
    // محاولة اكتشاف المستوى الأول (الحاوية)
    String? mainUnit;
    for (final token in tokens) {
      if (token is String && _mainUnits.any((u) => token.contains(u))) {
        mainUnit = token;
        break;
      }
    }
    levels.add(UnitLevelInfo(name: mainUnit ?? 'علبة', multiplier: 1));

    // محاولة اكتشاف المستوى الثاني (شريط/امبول/كيس/فيلم)
    double subMultiplier = 1;
    String? subName;
    for (int i = 0; i < tokens.length; i++) {
      final t = tokens[i];
      if (t is String && _subUnits.any((u) => t.contains(u))) {
        subName = t;
        // البحث عن رقم قبله أو بعده (6 شريط أو شريط 5)
        if (i > 0 && tokens[i - 1] is num) {
          subMultiplier = (tokens[i - 1] as num).toDouble();
        } else if (i < tokens.length - 1 && tokens[i + 1] is num) {
          subMultiplier = (tokens[i + 1] as num).toDouble();
        }
        break;
      }
    }
    
    // محاولة اكتشاف المستوى الثالث (حبة/قرص/كبسولة)
    double baseMultiplier = 1;
    String? baseName;
    for (int i = 0; i < tokens.length; i++) {
      final t = tokens[i];
      if (t is String && _baseUnits.any((u) => t.contains(u))) {
        // لو لقينا كلمة "قرص" وكان قبلها "شريط"، يبقى ده عدد الحبات في الشريط
        // لو مفيش شريط، يبقى ده عدد الحبات في العلبة
        baseName = t;
        if (i > 0 && tokens[i - 1] is num) {
          baseMultiplier = (tokens[i - 1] as num).toDouble();
        } else if (i < tokens.length - 1 && tokens[i + 1] is num) {
          baseMultiplier = (tokens[i + 1] as num).toDouble();
        }
        break;
      }
    }

    // بناء الهرم (Hierarchy)
    if (subName != null) {
      // حالة: علبة -> شريط -> قرص
      levels.add(UnitLevelInfo(name: subName, multiplier: subMultiplier));
      if (baseName != null) {
        levels.add(UnitLevelInfo(name: baseName, multiplier: baseMultiplier));
      } else {
        // ذكاء مهندسة: لو مفيش ذكر للحبات، بنفترض 10 حبات للشريط للأصناف الصلبة (أقراص/كبسولات)
        // أما لو كانت أمبولات أو سوائل، فالمستوى التاني هو الأخير (multiplier 1)
        if (subName.contains('شريط') || subName.contains('فلرص')) {
           levels.add(const UnitLevelInfo(name: 'حباية', multiplier: 10));
        } else {
           levels.add(const UnitLevelInfo(name: 'وحدة', multiplier: 1));
        }
      }
    } else if (baseName != null) {
      // حالة: علبة -> قرص مباشرة (زي 12 قرص)
      levels.add(UnitLevelInfo(name: baseName, multiplier: baseMultiplier));
    }

    // تصحيح القيم الافتراضية
    if (levels.length == 2 && levels[1].multiplier == 1) {
       // لو لقى شريط بس ملوش رقم، غالباً ده "شريط 10" (ديفولت)
       if (_subUnits.any((u) => levels[1].name.contains(u))) {
         // نتحقق لو الكلمة الأصلية فيها رقم (زي 6شريط)
         if (!text.contains(RegExp(r'\d'))) {
           // مستويات منطقية افتراضية
         }
       }
    }

    return UnitParsedInfo(
      displayName: raw,
      levels: levels,
      category: _inferCategory(levels),
    );
  }

  static List<dynamic> _tokenize(String text) {
    final result = <dynamic>[];
    final regex = RegExp(r'(\d+\.?\d*)|([^\d\s]+)');
    final matches = regex.allMatches(text);
    for (final m in matches) {
      final numVal = m.group(1);
      final textVal = m.group(2);
      if (numVal != null) result.add(double.tryParse(numVal) ?? 0);
      if (textVal != null) result.add(textVal);
    }
    return result;
  }

  static UnitCategory _inferCategory(List<UnitLevelInfo> levels) {
    if (levels.isEmpty) return UnitCategory.other;
    final name = levels.length > 1 ? levels[1].name : levels[0].name;
    if (name.contains('شريط')) return UnitCategory.strip;
    if (name.contains('امبول') || name.contains('انبول')) return UnitCategory.ampoule;
    if (name.contains('قرص') || name.contains('حبة') || name.contains('كبسولة')) return UnitCategory.tablet;
    if (name.contains('كيس')) return UnitCategory.sachet;
    if (name.contains('فيلم')) return UnitCategory.film;
    return UnitCategory.box;
  }
}



