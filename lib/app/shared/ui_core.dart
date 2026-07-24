/// 🎨 UI Core Master Export Barrel
library;

// 1. UI Tokens & System Constants (moved to core)
export 'package:pharmacy_system/app/core/theme/app_colors.dart';
export 'package:pharmacy_system/app/core/theme/app_sizes.dart';
export 'package:pharmacy_system/app/core/constants/app_assets.dart';

// 2. System Strings & Logic Constants (moved to core)
export 'package:pharmacy_system/app/core/constants/strings/app_strings.dart';
export 'package:pharmacy_system/app/core/constants/app_logic.dart';

// 3. Syntax & Context Extensions (moved to core)
export 'package:pharmacy_system/app/core/extensions/context_ext.dart';
export 'package:pharmacy_system/app/core/extensions/string_ext.dart';

// 4. UI Helpers & Utilities (moved to core)
export 'package:pharmacy_system/app/core/helpers/format_utils.dart';
export 'package:pharmacy_system/app/core/helpers/search_normalizer.dart';
export 'package:pharmacy_system/app/core/helpers/validators.dart';

// 5. Themes & Design System (moved to core)
export 'package:pharmacy_system/app/core/theme/app_theme.dart';
export 'package:pharmacy_system/app/core/theme/screen_tier.dart';

// 6. Shared Reusable Widgets
export 'package:pharmacy_system/app/shared/widgets/index.dart';