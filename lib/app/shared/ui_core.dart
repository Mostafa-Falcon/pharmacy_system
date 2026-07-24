/// 🎨 UI Core Master Export Barrel
/// 
/// المصدر الموحد المجمع لجميع الثوابت والنصوص، الثيم، الـ Extensions،
/// والـ Helpers والـ Reusable Components في التطبيق.
library;

// 1. UI Tokens & System Constants
export 'package:pharmacy_system/app/shared/constants/ui/app_colors.dart';
export 'package:pharmacy_system/app/shared/constants/ui/app_sizes.dart';
export 'package:pharmacy_system/app/shared/constants/ui/app_assets.dart';

// 2. System Strings & Logic Constants
export 'package:pharmacy_system/app/shared/constants/strings/app_strings.dart';
export 'package:pharmacy_system/app/shared/constants/logic/app_logic.dart';

// 3. Syntax & Context Extensions
export 'package:pharmacy_system/app/shared/extensions/context_ext.dart';
export 'package:pharmacy_system/app/shared/extensions/string_ext.dart';

// 4. UI Helpers & Utilities
export 'package:pharmacy_system/app/shared/helpers/format_utils.dart';
export 'package:pharmacy_system/app/shared/helpers/search_normalizer.dart';
export 'package:pharmacy_system/app/shared/helpers/validators.dart';

// 5. Themes & Design System
export 'package:pharmacy_system/app/shared/presentation/theme/app_theme.dart';
export 'package:pharmacy_system/app/shared/presentation/design_system/screen_tier.dart';

// 6. Shared Reusable Widgets
export 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
