import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ShortcutCallback = void Function();

class KeyboardShortcutService {
  KeyboardShortcutService._();
  static final KeyboardShortcutService instance = KeyboardShortcutService._();

  // تحويل المفتاح لـ String (يمثل تجميعة الأزرار) لسهولة المطابقة السريعة ومنع كراش الـ Map
  final Map<String, ShortcutCallback> _shortcuts = {};
  final Map<String, String> _labels = {};
  bool enabled = true;

  // دالة جلب الليبلز المحدثة الآمنة تماماً من الكراشات
  Map<String, String> get shortcutLabels => Map.unmodifiable(_labels);

  /// تسجيل اختصار جديد (مثال: LogicalKeyboardKey.select, control: true)
  void register({
    required LogicalKeyboardKey key,
    bool control = false,
    bool shift = false,
    bool alt = false,
    required ShortcutCallback callback,
    required String label,
  }) {
    final shortcutKey = _buildShortcutKey(key, control: control, shift: shift, alt: alt);
    _shortcuts[shortcutKey] = callback;
    _labels[shortcutKey] = label;
  }

  /// إلغاء تسجيل الاختصار
  void unregister({
    required LogicalKeyboardKey key,
    bool control = false,
    bool shift = false,
    bool alt = false,
  }) {
    final shortcutKey = _buildShortcutKey(key, control: control, shift: shift, alt: alt);
    _shortcuts.remove(shortcutKey);
    _labels.remove(shortcutKey);
  }

  /// معالج ضغطات الأزرار الذكي المتوافق 100% مع فلاتر الحديث والـ Scanners
  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!enabled) return KeyEventResult.ignored;

    // لقط الضغطة الأولى فقط (KeyDown) لمنع تكرار الكول باك لو اليوزر علق إيده على الزرار
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final pressedKeys = HardwareKeyboard.instance.logicalKeysPressed;

    // الفحص الذكي لحالة الأزرار المساعدة المسؤولة عن تشغيل الـ shortcuts
    final hasControl = pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.controlRight);

    final hasShift = pressedKeys.contains(LogicalKeyboardKey.shiftLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.shiftRight);

    final hasAlt = pressedKeys.contains(LogicalKeyboardKey.altLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.altRight);

    // بناء كود المفتاح الحالي المضغوط الآن
    final currentShortcutKey = _buildShortcutKey(
      event.logicalKey,
      control: hasControl,
      shift: hasShift,
      alt: hasAlt,
    );

    // تنفيذ الـ callback فوراً لو متسجل عندنا بالسيستم
    final callback = _shortcuts[currentShortcutKey];
    if (callback != null) {
      callback();
      return KeyEventResult.handled; // إبلاغ النظام إننا استلمنا وضبطنا المفتاح بنجاح
    }

    return KeyEventResult.ignored;
  }

  // دالة مساعدة لتوحيد صياغة المفاتيح ومنع التضارب
  String _buildShortcutKey(LogicalKeyboardKey key, {bool control = false, bool shift = false, bool alt = false}) {
    return '${control ? "ctrl_" : ""}${shift ? "shift_" : ""}${alt ? "alt_" : ""}${key.keyId}';
  }
}


