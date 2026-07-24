import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';

import '../../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/pos_bloc.dart';
import 'package:pharmacy_system/app/modules/sales/models/pos_focus_nodes.dart';
import 'dialogs.dart';

class DesktopCartTable extends StatefulWidget {
  final PosBloc controller;
  const DesktopCartTable({super.key, required this.controller});

  @override
  State<DesktopCartTable> createState() => _DesktopCartTableState();
}

class _DesktopCartTableState extends State<DesktopCartTable> {
  final Map<String, RowFocusNodes> _focusNodes = {};

  RowFocusNodes getRowFocusNodes(String medicineId, int initialQuantity) {
    if (!_focusNodes.containsKey(medicineId)) {
      final nodes = RowFocusNodes();
      nodes.quantityController.text = '$initialQuantity';
      _focusNodes[medicineId] = nodes;
    } else {
      final nodes = _focusNodes[medicineId]!;
      if (!nodes.quantityNode.hasFocus && nodes.quantityController.text != '$initialQuantity') {
        nodes.quantityController.text = '$initialQuantity';
      }
    }
    return _focusNodes[medicineId]!;
  }

  @override
  void dispose() {
    for (final nodes in _focusNodes.values) {
      nodes.dispose();
    }
    super.dispose();
  }

  KeyEventResult _handleCellKey(KeyEvent event, String medicineId, int colIndex, BuildContext context) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final controller = widget.controller;
    final cart = controller.state.cart;
    final rowIndex = cart.indexWhere((l) => l.medicine.id == medicineId);
    if (rowIndex == -1) return KeyEventResult.ignored;

    int newRow = rowIndex;
    int newCol = colIndex;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      newCol = colIndex + 1;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      newCol = colIndex - 1;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      newRow = rowIndex + 1;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      newRow = rowIndex - 1;
    } else {
      return KeyEventResult.ignored;
    }

    if (newRow >= 0 && newRow < cart.length && newCol >= 0 && newCol < 4) {
      final targetLine = cart[newRow];
      final nodes = getRowFocusNodes(targetLine.medicine.id, targetLine.quantity);

      switch (newCol) {
        case 0:
          nodes.nameNode.requestFocus();
          break;
        case 1:
          nodes.unitNode.requestFocus();
          break;
        case 2:
          nodes.quantityNode.requestFocus();
          break;
        case 3:
          nodes.deleteNode.requestFocus();
          break;
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final items = state.cart;
        if (items.isEmpty) {
          return const AppStateView.empty(
            icon: Icons.shopping_cart_outlined,
            title: SalesStrings.cartEmptyTitle,
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Container(
                color: isDark ? scheme.surfaceContainerHigh : Colors.grey.shade50,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: AppText(SalesStrings.cartTableProduct, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                    Expanded(flex: 2, child: AppText(InventoryStrings.barcodeLabel, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: AppText(SalesStrings.cartTableUnit, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: AppText(SalesStrings.cartPrice, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: AppText(SalesStrings.cartQuantity, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: AppText(SalesStrings.cartTotal, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),
              Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5)),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  itemBuilder: (context, i) {
                    final line = items[i];
                    final unitNameVal = line.unitName ?? InventoryStrings.defaultUnitBox;
                    final nodes = getRowFocusNodes(line.medicine.id, line.quantity);

                    String expiryWarning = '';
                    if (line.medicine.expiryDate != null) {
                      final exp = line.medicine.expiryDate!;
                      expiryWarning = 'Exp: ${exp.year}-${exp.month.toString().padLeft(2, '0')}';
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Focus(
                              focusNode: nodes.nameNode,
                              onKeyEvent: (node, event) {
                                if (event is KeyDownEvent && (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space)) {
                                  DesktopDialogs.showEditCartLineDialog(context, controller, line);
                                  return KeyEventResult.handled;
                                }
                                return _handleCellKey(event, line.medicine.id, 0, context);
                              },
                              child: Builder(
                                builder: (context) {
                                  final hasFocus = Focus.of(context).hasFocus;
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: hasFocus ? Border.all(color: scheme.primary, width: 1.w) : null,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        DesktopDialogs.showEditCartLineDialog(context, controller, line);
                                      },
                                      borderRadius: BorderRadius.circular(4.r),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              line.medicine.name,
                                              style: AppTextStyles.caption(context).copyWith(
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.underline,
                                                decorationStyle: TextDecorationStyle.dashed,
                                                color: scheme.onSurface,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (expiryWarning.isNotEmpty)
                                              AppText(
                                                expiryWarning,
                                                style: AppTextStyles.caption(context).copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                              child: AppText(
                                line.medicine.barcodes.isNotEmpty ? line.medicine.barcodes.first : '-',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
                              ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Focus(
                              focusNode: nodes.unitNode,
                              onKeyEvent: (node, event) {
                                return _handleCellKey(event, line.medicine.id, 1, context);
                              },
                              child: Builder(
                                builder: (context) {
                                  final hasFocus = Focus.of(context).hasFocus;
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: hasFocus ? Border.all(color: scheme.primary, width: 1.w) : null,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: ReusableDropdown<String>(
                                      hintText: SalesStrings.cartTableUnit,
                                      value: unitNameVal,
                                      items: line.medicine.units.isEmpty
                                          ? const [InventoryStrings.defaultUnitBox]
                                          : line.medicine.units.map((u) => u.name).toList(),
                                      itemAsString: (v) => v,
                                    onChanged: (v) {
                                      if (v != null) {
                                        controller.add(
                                          PosUpdateLineUnit(
                                            line.medicine.id,
                                            v,
                                          ),
                                        );
                                      }
                                    },
                                      isCompact: true,
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                              child: AppText(
                                line.unitPrice.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
                              ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, size: AppIconSize.sm.value, color: scheme.primary),
                                    onPressed:
                                        line.quantity > 1
                                            ? () => controller.add(
                                              PosDecrementLine(
                                                line.medicine.id,
                                              ),
                                            )
                                            : null,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(maxWidth: 24.w, maxHeight: 24.h),
                                  ),
                                  SizedBox(width: 4.w),
                                  SizedBox(
                                    width: 50.w,
                                    height: 32.h,
                                    child: Focus(
                                      focusNode: nodes.quantityNode,
                                      onKeyEvent: (node, event) => _handleCellKey(event, line.medicine.id, 2, context),
                                      onFocusChange: (hasFocus) {
                                        if (!hasFocus) {
                                          final qty = int.tryParse(nodes.quantityController.text) ?? 0;
                                          if (qty <= 0) {
                                            nodes.quantityController.text =
                                                '${line.quantity}';
                                          } else {
                                            controller.add(
                                              PosUpdateLineQuantity(
                                                line.medicine.id,
                                                qty,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: TextField(
                                        controller: nodes.quantityController,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        style: AppTextStyles.caption(context).copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: scheme.onSurface,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          fillColor: scheme.surfaceContainerLow,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.h,
                                            horizontal: 2.w,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                            borderSide: BorderSide(color: scheme.outlineVariant),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                            borderSide: BorderSide(color: scheme.outlineVariant),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          final qty = int.tryParse(val) ?? 0;
                                          if (qty > 0) {
                                            controller.add(
                                              PosUpdateLineQuantity(
                                                line.medicine.id,
                                                qty,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: AppIconSize.sm.value,
                                      color: scheme.primary,
                                    ),
                                    onPressed:
                                        () => controller.add(
                                          PosIncrementLine(line.medicine.id),
                                        ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(
                                      maxWidth: 24.w,
                                      maxHeight: 24.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AppText(
                              line.lineTotal.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
                            ),
                          ),
                          SizedBox(
                            width: 40.w,
                            child: Center(
                              child: Focus(
                                focusNode: nodes.deleteNode,
                                onKeyEvent: (node, event) {
                                  if (event is KeyDownEvent &&
                                      (event.logicalKey ==
                                              LogicalKeyboardKey.enter ||
                                          event.logicalKey ==
                                              LogicalKeyboardKey.space)) {
                                    controller.add(
                                      PosRemoveLine(line.medicine.id),
                                    );
                                    return KeyEventResult.handled;
                                  }
                                  return _handleCellKey(
                                    event,
                                    line.medicine.id,
                                    3,
                                    context,
                                  );
                                },
                                child: Builder(
                                  builder: (context) {
                                    final hasFocus = Focus.of(context).hasFocus;
                                    return Container(
                                      decoration: BoxDecoration(
                                        border:
                                            hasFocus
                                                ? Border.all(
                                                  color: AppColors.error,
                                                  width: 1.w,
                                                )
                                                : null,
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: InkWell(
                                        onTap:
                                            () => controller.add(
                                              PosRemoveLine(line.medicine.id),
                                            ),
                                        borderRadius: BorderRadius.circular(4.r),
                                        child: Container(
                                          padding: EdgeInsets.all(4.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.error.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: AppColors.error,
                                            size: 14.sp,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}





