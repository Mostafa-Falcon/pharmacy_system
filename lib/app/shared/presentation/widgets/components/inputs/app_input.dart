import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

class AppInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? error;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final VoidCallback? onSuffixTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool showClearButton;
  final bool showObscureToggle;
  final bool isPassword;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final bool alignLabelWithHint;

  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onClear,
    this.onSuffixTap,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofocus = false,
    this.showClearButton = true,
    this.showObscureToggle = true,
    this.isPassword = false,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.alignLabelWithHint = false,
  });

  const AppInput.text({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.focusNode,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onClear,
    this.onSuffixTap,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.showClearButton = true,
    this.showObscureToggle = false,
    this.isPassword = false,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.alignLabelWithHint = false,
    TextInputAction? textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
  }) : keyboardType = TextInputType.text,
        obscureText = false,
        textInputAction = textInputAction ?? TextInputAction.next;

  const AppInput.email({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.focusNode,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onClear,
    this.onSuffixTap,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.showClearButton = true,
    this.showObscureToggle = false,
    this.isPassword = false,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.alignLabelWithHint = false,
    TextInputAction? textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  }) : keyboardType = TextInputType.emailAddress,
        obscureText = false,
        textInputAction = textInputAction ?? TextInputAction.next;

  const AppInput.password({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.focusNode,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onClear,
    this.onSuffixTap,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.showClearButton = false,
    this.showObscureToggle = true,
    this.isPassword = true,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.alignLabelWithHint = false,
    TextInputAction? textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  }) : keyboardType = TextInputType.visiblePassword,
        obscureText = true,
        textInputAction = textInputAction ?? TextInputAction.next;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscure;
  TextEditingController? _internalController;
  late FocusNode _effectiveFocusNode;
  bool _isFocused = false;
  bool _isHovered = false;
  bool _hasContent = false;

  TextEditingController get _effectiveController {
    return widget.controller ?? (_internalController ??= TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _effectiveFocusNode.addListener(_onFocusChange);

    _effectiveController.addListener(_onTextChanged);
    _hasContent = _effectiveController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _effectiveController.removeListener(_onTextChanged);

    if (widget.focusNode == null) _effectiveFocusNode.dispose();
    if (widget.controller == null) {
      _internalController?.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _effectiveFocusNode.hasFocus);
  }

  void _onTextChanged() {
    if (mounted) {
      final textNotEmpty = _effectiveController.text.isNotEmpty;
      if (textNotEmpty != _hasContent) {
        setState(() => _hasContent = textNotEmpty);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);

    // توحيد الـ Radius بـ .r لضمان استقرار حواف هندسية ناعمة
    final radius = BorderRadius.circular(AppRadius.md.r);
    final showClear = widget.showClearButton && _hasContent && !widget.readOnly && widget.enabled;

    Widget? effectiveSuffix;
    if (widget.isPassword && widget.showObscureToggle) {
      effectiveSuffix = IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: AppIconSize.md.value,
          color: _isFocused ? scheme.primary : AppColors.textSecondaryOf(context).withValues(alpha: 0.7),
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    } else if (showClear) {
      effectiveSuffix = IconButton(
        icon: Icon(Icons.cancel_rounded, size: AppIconSize.md.value, color: AppColors.textMutedOf(context)),
        onPressed: () {
          _effectiveController.clear();
          widget.onClear?.call();
          widget.onChanged?.call('');
        },
      );
    } else if (widget.suffixIcon != null) {
      effectiveSuffix = widget.suffixIcon;
    }

    // تأمين الـ maxLines في حالة الباسورد لمنع الكراش
    final effectiveMaxLines = widget.isPassword ? 1 : widget.maxLines;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: _isFocused
              ? [
            BoxShadow(
              color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.04),
              blurRadius: 10,
              spreadRadius: 0, // إلغاء الـ spread لمنع التمدد الحاد للظل
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: TextFormField(
          controller: _effectiveController,
          focusNode: _effectiveFocusNode,
          textAlign: widget.textAlign,
          obscureText: widget.isPassword && widget.showObscureToggle ? _obscure : widget.obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          maxLines: effectiveMaxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onTap: widget.onTap,
          textDirection: widget.textDirection,
          style: AppTextStyles.body(context),
          cursorColor: scheme.primary,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: AppTextStyles.caption(context).copyWith(
              fontWeight: FontWeight.w500,
              color: _isFocused ? scheme.primary : AppColors.textSecondaryOf(context),
            ),
            floatingLabelStyle: AppTextStyles.caption(context).copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
            hintText: widget.hint,
            errorText: widget.error,
            alignLabelWithHint: widget.alignLabelWithHint,
            hintStyle: AppTextStyles.caption(context).copyWith(
              color: AppColors.textMutedOf(context).withValues(alpha: 0.7),
            ),
            fillColor: widget.enabled
                ? (_isFocused
                    ? AppColors.surfaceOf(context)
                    : (_isHovered
                        ? AppColors.surfaceHighOf(context).withValues(alpha: 0.8)
                        : AppColors.inputFillOf(context)))
                : AppColors.inputFillOf(context).withValues(alpha: 0.4),
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: (effectiveMaxLines != null && effectiveMaxLines > 1) ? AppSpacing.md.h : 12.h, // ارتفاع رأسي منسق بالملي
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
                child: IconTheme(
                  data: IconThemeData(
                    color: _isFocused ? scheme.primary : AppColors.textSecondaryOf(context),
                    size: AppIconSize.md.value,
                  ),
                  child: widget.prefixIcon!,
                ),
            )
                : null,
            prefixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 20.h),
            suffixIcon: effectiveSuffix,
            suffixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 20.h),

            // البوردرات المنسابة هندسياً بالملي
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.4), width: 1.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                color: _isHovered
                    ? scheme.primary.withValues(alpha: 0.45)
                    : AppColors.borderOf(context).withValues(alpha: 0.3),
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: scheme.primary, width: 1.5.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: scheme.error.withValues(alpha: 0.4), width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: scheme.error, width: 1.5.w),
            ),
            errorStyle: AppTextStyles.caption(context).copyWith(
              color: scheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}



