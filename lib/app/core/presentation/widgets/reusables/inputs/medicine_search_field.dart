import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../dialogs/app_barcode_scan_dialog.dart';
import '../display/app_text.dart';
import '../inputs/app_input.dart';

class MedicineSearchField extends StatefulWidget {
  final ValueChanged<MedicineModel> onSelected;
  final String label;
  final String hint;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<MedicineModel>? customItems;
  final bool clearOnSelect;
  final ValueChanged<String>? onChanged;

  const MedicineSearchField({
    super.key,
    required this.onSelected,
    this.label = AppStrings.medicineSearchHint,
    this.hint = AppStrings.medicineSearchPlaceholder,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.customItems,
    this.clearOnSelect = true,
    this.onChanged,
  });

  @override
  State<MedicineSearchField> createState() => _MedicineSearchFieldState();
}

class _MedicineSearchFieldState extends State<MedicineSearchField> {
  final LayerLink _layerLink = LayerLink();
  FocusNode? _internalFocusNode;
  late final TextEditingController _controller;
  OverlayEntry? _overlayEntry;
  List<MedicineModel> _results = [];
  int _selectedIndex = -1;
  bool _isOverlayOpen = false;

  FocusNode get _focusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    if (widget.controller == null) _controller.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Delay hiding to allow for clicks on results
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _hideOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    if (_isOverlayOpen) {
      _overlayEntry?.markNeedsBuild();
      return;
    }

    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isOverlayOpen = true);
  }

  void _hideOverlay() {
    if (!mounted) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayOpen = false;
    _selectedIndex = -1;
    if (mounted) {
      setState(() {});
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 5),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              clipBehavior: Clip.antiAlias,
              child: Container(
                constraints: BoxConstraints(maxHeight: 350.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: _results.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(16.w),
                        child: const Center(child: ReusableText(AppStrings.searchNoResults)),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _results.length,
                        separatorBuilder: (_, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final medicine = _results[index];
                          final isSelected = index == _selectedIndex;
                          return _buildItem(medicine, isSelected);
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(MedicineModel medicine, bool isSelected) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => _selectItem(medicine),
      child: Container(
        color: isSelected ? scheme.primary.withValues(alpha: 0.15) : null,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected 
                    ? scheme.primary.withValues(alpha: 0.2)
                    : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.button.r),
              ),
              child: Icon(
                Icons.medication_rounded, 
                size: AppIconSize.md.value, 
                color: isSelected ? scheme.primary : scheme.primary.withValues(alpha: 0.7)
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    medicine.name, 
                    style: AppTextStyles.body(context).copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? scheme.primary : null,
                    )
                  ),
                  ReusableText(
                    AppStrings.medicineSearchStock.replaceFirst('%s', medicine.barcodes.firstOrNull ?? "---").replaceFirst('%s', '${medicine.quantity}'),
                    style: AppTextStyles.caption(context).copyWith(
                      color: isSelected ? scheme.primary.withValues(alpha: 0.7) : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ReusableText(
                  FormatUtils.currency(medicine.sellPrice), 
                  style: AppTextStyles.body(context).copyWith(
                    fontWeight: FontWeight.w900, 
                    color: isSelected ? scheme.primary : AppColors.success
                  )
                ),
                if (medicine.buyPrice > 0)
                  ReusableText(
                    AppStrings.medicineSearchBuyPrice.replaceFirst('%s', FormatUtils.currency(medicine.buyPrice)), 
                    style: AppTextStyles.caption(context).copyWith(
                      color: isSelected ? scheme.primary.withValues(alpha: 0.5) : scheme.onSurfaceVariant
                    )
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectItem(MedicineModel medicine) {
    if (!mounted) return;
    widget.onSelected(medicine);
    if (widget.clearOnSelect) {
      _controller.clear();
      widget.onChanged?.call('');
    }
    _hideOverlay();
    _focusNode.requestFocus();
  }

  void _onChanged(String value) async {
    widget.onChanged?.call(value);
    final query = value.trim().toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _selectedIndex = -1;
      });
      _hideOverlay();
      return;
    }

    List<MedicineModel> allItems = widget.customItems ?? BranchDataService.getMedicines(branchId: AuthService.currentBranchId);
    
    // ذكاء مهندسة: لو الكاش فاضي، نحاول نجيب الداتا Async من الداتابيز
    if (allItems.isEmpty && widget.customItems == null) {
      allItems = await BranchDataService.getMedicinesAsync(branchId: AuthService.currentBranchId);
    }
    
    // تسجيل عدد الأصناف المتاحة للبحث للتشخيص
    safeDebugPrint('MedicineSearch: Searching "$query" in ${allItems.length} items (Branch: ${AuthService.currentBranchId})');
      final nameMatch = m.name.toLowerCase().contains(query);
      final nameEnMatch = m.nameEn?.toLowerCase().contains(query) ?? false;
      final barcodeMatch = m.barcodes.any((b) => b.toLowerCase().contains(query));
      return nameMatch || nameEnMatch || barcodeMatch;
    }).toList();

    setState(() {
      _results = filteredResults;
      _selectedIndex = _results.isNotEmpty ? 0 : -1;
    });

    // Check for exact barcode match to auto-select
    final exactMatch = _results.firstWhereOrNull((m) => m.barcodes.any((b) => b.toLowerCase() == query));
    if (exactMatch != null) {
      safeDebugPrint('MedicineSearch: Exact barcode match found: ${exactMatch.name}');
      _selectItem(exactMatch);
      return;
    }

    _showOverlay();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_results.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % _results.length;
        });
        _overlayEntry?.markNeedsBuild();
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_results.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1 + _results.length) % _results.length;
        });
        _overlayEntry?.markNeedsBuild();
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selectedIndex >= 0 && _selectedIndex < _results.length) {
        _selectItem(_results[_selectedIndex]);
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _hideOverlay();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        onKeyEvent: (node, event) => _onKeyEvent(node, event),
        child: ReusableInput(
          controller: _controller,
          focusNode: _focusNode,
          label: widget.label,
          hint: widget.hint,
          autofocus: widget.autofocus,
          onChanged: _onChanged,
          onFieldSubmitted: (v) {
            if (_selectedIndex >= 0 && _selectedIndex < _results.length) {
              _selectItem(_results[_selectedIndex]);
            } else if (_results.length == 1) {
              _selectItem(_results.first);
            }
          },
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () async {
              final code = await BarcodeScanDialog.show(context);
              if (code != null) {
                _controller.text = code;
                _onChanged(code);
              }
            },
          ),
        ),
      ),
    );
  }
}

