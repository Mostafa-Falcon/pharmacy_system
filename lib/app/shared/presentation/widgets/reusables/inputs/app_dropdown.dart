import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

class ReusableDropdown<T> extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final List<T> items;
  final T? value;
  final String Function(T) itemAsString;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final IconData? prefixIcon;
  final bool isCompact;

  const ReusableDropdown({
    super.key,
    this.labelText,
    required this.hintText,
    required this.items,
    this.value,
    required this.itemAsString,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.isCompact = false,
  });

  @override
  State<ReusableDropdown<T>> createState() => _ReusableDropdownState<T>();
}

class _ReusableDropdownState<T> extends State<ReusableDropdown<T>> {
  final MenuController _menuController = MenuController();
  final GlobalKey<FormFieldState<T>> _fieldKey = GlobalKey<FormFieldState<T>>();
  bool _isMenuOpen = false;
  bool _isHovered = false;

  @override
  void didUpdateWidget(covariant ReusableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        _fieldKey.currentState?.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fieldKey.currentState?.didChange(widget.value);
      });
    }
    if (!widget.enabled && _menuController.isOpen) {
      _menuController.close();
    }
  }

  @override
  void deactivate() {
    if (_menuController.isOpen) {
      _menuController.close();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);

    // توحيد الحواف بـ .r لضمان هندسة دائرية مثالية للحواف
    final radius = BorderRadius.circular(AppRadius.md.r);

    return FormField<T>(
      key: _fieldKey,
      initialValue: widget.value,
      validator: widget.validator,
      builder: (state) {
        final hasError = state.hasError;

        // ألوان البوردر التفاعلية بالملي لتتطابق مع ReusableInput
        BorderSide getBorderSide() {
          if (hasError) {
            return BorderSide(color: scheme.error, width: _isMenuOpen ? 1.5.w : 1.w);
          }
          if (_isMenuOpen) {
            return BorderSide(color: scheme.primary, width: 1.5.w);
          }
          if (_isHovered && widget.enabled) {
            return BorderSide(color: scheme.primary.withValues(alpha: 0.45), width: 1.w);
          }
          return BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.3), width: 1.w);
        }

        // لون الخلفية مع التحويم والتركيز بالملي
        Color getFillColor() {
          if (!widget.enabled) {
            return AppColors.inputFillOf(context).withValues(alpha: 0.4);
          }
          if (_isMenuOpen) {
            return AppColors.surfaceOf(context);
          }
          if (_isHovered) {
            return AppColors.surfaceHighOf(context).withValues(alpha: 0.8);
          }
          return AppColors.surfaceOf(context);
        }

        T? selectedValue = state.value;
        String? selectedLabel = selectedValue != null ? widget.itemAsString(selectedValue) : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.labelText != null) ...[
              Padding(
                padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 6.h),
                child: Text(
                  widget.labelText!,
                  style: AppTextStyles.caption(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isMenuOpen
                        ? scheme.primary
                        : AppColors.textPrimaryOf(context).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return MenuAnchor(
                  controller: _menuController,
                  crossAxisUnconstrained: false,
                  onOpen: () {
                    if (mounted && !_isMenuOpen) {
                      setState(() => _isMenuOpen = true);
                    }
                  },
                  onClose: () {
                    if (mounted && _isMenuOpen) {
                      setState(() => _isMenuOpen = false);
                    }
                  },
                  style: MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.surfaceOf(context)),
                    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                    elevation: const WidgetStatePropertyAll(12),
                    shadowColor: WidgetStatePropertyAll(
                      Colors.black.withValues(
                        alpha: isDark ? 0.32 : 0.14,
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: radius,
                      ),
                    ),
                    minimumSize: WidgetStatePropertyAll(Size(width, 0)),
                    maximumSize: WidgetStatePropertyAll(Size(width, 300.h)),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
                    ),
                  ),
                  menuChildren: widget.items.map((item) {
                    final isSelected = item == selectedValue;
                    return MenuItemButton(
                      onPressed: widget.enabled
                          ? () {
                              state.didChange(item);
                              widget.onChanged(item);
                            }
                          : null,
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: AppSpacing.md.w,
                            vertical: 10.h,
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return isDark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLow;
                          }
                          return isSelected
                              ? scheme.primary.withValues(alpha: isDark ? 0.18 : 0.08)
                              : Colors.transparent;
                        }),
                        foregroundColor: WidgetStatePropertyAll(
                          isSelected ? scheme.primary : AppColors.textPrimaryOf(context),
                        ),
                      ),
                      child: SizedBox(
                        width: width > 32.w ? width - 32.w : width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.itemAsString(item),
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body(context).copyWith(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? scheme.primary : AppColors.textPrimaryOf(context),
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                size: AppIconSize.md.value,
                                color: scheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  builder: (context, menuController, child) {
                    return MouseRegion(
                      onEnter: (_) => setState(() => _isHovered = true),
                      onExit: (_) => setState(() => _isHovered = false),
                      child: Semantics(
                        button: true,
                        enabled: widget.enabled,
                        label: widget.labelText ?? widget.hintText,
                        child: InkWell(
                          onTap: widget.enabled
                              ? () {
                                  if (menuController.isOpen) {
                                    menuController.close();
                                  } else {
                                    menuController.open();
                                  }
                                }
                              : null,
                          borderRadius: radius,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md.w,
                              vertical: widget.isCompact ? 8.h : 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: getFillColor(),
                              borderRadius: radius,
                              border: Border.fromBorderSide(getBorderSide()),
                              boxShadow: (_isMenuOpen)
                                  ? [
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                if (widget.prefixIcon != null) ...[
                                  Icon(
                                    widget.prefixIcon,
                                    size: AppIconSize.md.value,
                                    color: widget.enabled
                                        ? (_isMenuOpen ? scheme.primary : AppColors.textSecondaryOf(context))
                                        : AppColors.textMutedOf(context),
                                  ),
                                  SizedBox(width: AppSpacing.xs.w),
                                ],
                                Expanded(
                                  child: Text(
                                    selectedLabel ?? widget.hintText,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.body(context).copyWith(
                                      fontWeight: selectedValue != null ? FontWeight.w500 : FontWeight.normal,
                                      color: selectedValue != null
                                          ? AppColors.textPrimaryOf(context)
                                          : AppColors.textMutedOf(context).withValues(alpha: 0.7),
                                    ),
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: _isMenuOpen ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 180),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: widget.isCompact ? AppIconSize.md.value : AppIconSize.lg.value,
                                    color: widget.enabled
                                        ? AppColors.textSecondaryOf(context).withValues(alpha: 0.7)
                                        : AppColors.textMutedOf(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            if (hasError) ...[
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 6.w),
                child: Text(
                  state.errorText ?? '',
                  style: AppTextStyles.caption(context).copyWith(
                    color: scheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}



