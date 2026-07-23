import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import '../../../core/data/services/sound_service.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../core/injection.dart';
import '../bloc/purchases_bloc.dart';
import '../bloc/purchases_event.dart';
import '../bloc/purchases_state.dart';

class AddPurchaseView extends StatefulWidget {
  const AddPurchaseView({super.key});

  @override
  State<AddPurchaseView> createState() => _AddPurchaseViewState();
}

class _AddPurchaseViewState extends State<AddPurchaseView> {
  final Map<int, List<FocusNode>> _lineFocusNodes = {};
  final TextEditingController _searchCtrl = TextEditingController();

  String get _branchId => AuthService.currentBranchId ?? '';

  static const Map<String, String> _paymentAccounts = {
    'system:cash': '1101 — ${AppStrings.accountCash}',
    'system:bank': '1102 — ${AppStrings.accountBank}',
    'system:mobile_wallet': '1103 — ${AppStrings.accountMobileWallet}',
    'system:card_clearing': '1104 — ${AppStrings.accountCardClearing}',
  };

  Future<void> _selectExpiry(BuildContext context, int index, DateTime? current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && context.mounted) {
      context.read<PurchasesBloc>().add(UpdatePurchaseLineExpiry(index, picked));
    }
  }

  @override
  void dispose() {
    for (final nodes in _lineFocusNodes.values) {
      for (final node in nodes) {
        node.dispose();
      }
    }
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final state = context.read<PurchasesBloc>().state;
    if (state.receiptLines.isEmpty) { AppSnackbar.error(AppStrings.emptyPurchaseError); return; }
    if (state.selectedSupplierId == null) { AppSnackbar.error(AppStrings.selectSupplierError); return; }
    context.read<PurchasesBloc>().add(const SubmitPurchase());
    Navigator.pop(context);
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final state = context.read<PurchasesBloc>().state;
    if (state.receiptLines.isEmpty && state.selectedSupplierId == null) return true;
    final res = await ReusableDialog.show<bool>(
      context,
      title: AppStrings.confirmExitTitle,
      headerIcon: const Icon(Icons.exit_to_app_rounded),
      children: [
        ReusableText(AppStrings.confirmExitMessage, style: AppTextStyles.body(context)),
        SizedBox(height: 16.h),
        DialogActions(
          cancelText: AppStrings.stayButton,
          confirmText: AppStrings.exitAndIgnoreButton,
          confirmType: ButtonType.outlined,
          onCancel: () => Navigator.pop(context, false),
          onConfirm: () => Navigator.pop(context, true),
        ),
      ],
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocProvider.value(
      value: sl<PurchasesBloc>(),
      child: BlocBuilder<PurchasesBloc, PurchasesState>(
        builder: (context, state) {
          final isEdit = state.editingPurchaseId != null;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                final shouldPop = await _confirmExit(context);
                if (shouldPop && context.mounted) Navigator.of(context).pop();
              }
            },
            child: HomeShell(
              title: isEdit ? AppStrings.editPurchaseTitle : AppStrings.newPurchaseTitle,
              child: Container(
                color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
                child: state.status == PurchasesStatus.submitting
                    ? const LoadingIndicator()
                    : CallbackShortcuts(
                        bindings: {
                          SingleActivator(LogicalKeyboardKey.keyS, control: true): () => _submitForm(context),
                          SingleActivator(LogicalKeyboardKey.enter, control: true): () => _submitForm(context),
                          const SingleActivator(LogicalKeyboardKey.f2): () => _openItemDialog(context, null, _searchCtrl),
                        },
                        child: Focus(
                          autofocus: true,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(AppSpacing.lg.w),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 1400.w),
                                child: _buildMainForm(context, scheme, state),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainForm(BuildContext context, ColorScheme scheme, PurchasesState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildHeaderFields(context, scheme, state),
      SizedBox(height: AppSpacing.lg.h),
      _buildShortcutBar(scheme),
      SizedBox(height: AppSpacing.lg.h),
      _buildItemSearchAndTable(context, scheme, state),
      SizedBox(height: AppSpacing.lg.h),
      _buildPaymentSectionMatchImage(context, scheme, state),
    ]);
  }

  Widget _buildHeaderFields(BuildContext context, ColorScheme scheme, PurchasesState state) {
    final vendors = state.vendors;
    return FormCard(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _responsiveFields(context, minWidth: 220, children: [
            // المورد (موحد من الحالة)
            ReusableDropdown<Map<String, String>>(
              hintText: AppStrings.select, labelText: AppStrings.supplierLabelPurchase,
              items: vendors,
              value: vendors.firstWhereOrNull((v) => v['id'] == state.selectedSupplierId),
              itemAsString: (v) => v['name'] ?? '',
              onChanged: (v) {
                if (v != null) {
                  context.read<PurchasesBloc>().add(SetPurchaseSupplier(v['id']!, v['name']!));
                }
              },
            ),
            // الرقم المرجعي
            ReusableInput(
              label: AppStrings.referenceNumberLabel,
              controller: TextEditingController(text: state.referenceNumber ?? 'PUR-0038'),
              onChanged: (v) => context.read<PurchasesBloc>().add(SetPurchaseReferenceNumber(v)),
            ),
            // تاريخ الشراء
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: state.purchaseDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && context.mounted) {
                  context.read<PurchasesBloc>().add(SetPurchaseDate(picked));
                }
              },
              child: ReusableInput(
                label: AppStrings.purchaseDateLabel,
                enabled: false,
                controller: TextEditingController(text: FormatUtils.date(state.purchaseDate)),
                suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
              ),
            ),
            // حالة الشراء
            ReusableDropdown<String>(
              labelText: AppStrings.purchaseStatusLabel,
              hintText: AppStrings.selectStatusHint,
              items: const [AppStrings.statusReceived, AppStrings.statusPendingPurchase, AppStrings.statusOrdered],
              value: state.purchaseStatus,
              itemAsString: (v) => v,
              onChanged: (v) => context.read<PurchasesBloc>().add(SetPurchaseStatus(v ?? AppStrings.statusReceived)),
            ),
            // فترة الدفع
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: ReusableInput(
                    label: AppStrings.paymentTermLabel,
                    hint: AppStrings.paymentTermLabel,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => context.read<PurchasesBloc>().add(SetPurchasePaymentTerm(int.tryParse(v))),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: ReusableDropdown<String>(
                    items: const [AppStrings.days, AppStrings.months],
                    value: state.paymentTermUnit,
                    hintText: AppStrings.unitLabelShort,
                    itemAsString: (v) => v,
                    onChanged: (v) => context.read<PurchasesBloc>().add(SetPurchasePaymentTerm(state.paymentTerm, v)),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildShortcutBar(ColorScheme scheme) {
    final shortcuts = [
      {'key': 'F4', 'label': AppStrings.shortcutSearch},
      {'key': 'Ctrl+S', 'label': AppStrings.shortcutSave},
      {'key': 'Esc', 'label': AppStrings.shortcutFocusSearch},
      {'key': '↑ / ↓', 'label': AppStrings.shortcutNavigateRows},
      {'key': 'Ctrl+Enter', 'label': AppStrings.shortcutSave},
      {'key': 'F2', 'label': AppStrings.shortcutItemSearch},
      {'key': 'Esc', 'label': AppStrings.shortcutClearCancel},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          ReusableText(AppStrings.keyboardShortcuts, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.onSurfaceVariant)),
          SizedBox(width: 16.w),
          Expanded(
            child: Wrap(
              spacing: 12.w,
              children: shortcuts.map((s) => _shortcutChip(scheme, s['key']!, s['label']!)).toList(),
            ),
          ),
          ReusableText('Esc ${AppStrings.shortcutFocusSearch} — Ctrl+S ${AppStrings.shortcutSave} — F4 ${AppStrings.shortcutSearch}', style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _shortcutChip(ColorScheme scheme, String key, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReusableText(key, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w900, color: scheme.primary)),
          SizedBox(width: 4.w),
          ReusableText(label, style: AppTextStyles.caption(context).copyWith(color: scheme.onSurface)),
        ],
      ),
    );
  }

  void _openItemDialog(BuildContext context, MedicineModel? preSelected, TextEditingController searchCtrl) {
    final bloc = context.read<PurchasesBloc>();
    String searchQuery = preSelected?.name ?? '';
    String? selectedId = preSelected?.id;
    final qtyCtrl = TextEditingController(text: '1');
    final priceCtrl = TextEditingController(text: preSelected != null ? preSelected.buyPrice.toStringAsFixed(2) : '0');
    final batchCtrl = TextEditingController(text: _generateBatchNumber());
    final discountCtrl = TextEditingController();
    final taxCtrl = TextEditingController();
    String discountType = '%';
    DateTime? expiryDate;
    String? selectedUnitId = preSelected?.units.isNotEmpty == true ? preSelected!.units.first.id : null;
    String? selectedUnitName = preSelected?.units.isNotEmpty == true ? preSelected!.units.first.name : null;

    showDialog(context: context, builder: (ctx) {
      return StatefulBuilder(builder: (ctx, setDialogState) {
        final results = BranchDataService.getMedicines(branchId: _branchId)
            .where((m) => m.isActive && !m.isDeleted)
            .where((m) {
              if (searchQuery.isEmpty) return true;
              final q = searchQuery.toLowerCase();
              return m.name.toLowerCase().contains(q) || m.barcodes.any((b) => b.toLowerCase().contains(q));
            }).toList();
        final selectedMed = selectedId != null ? BranchDataService.getMedicine(selectedId!) : null;
        final lastPrice = findLastUnitPrice(selectedId);

        return ReusableDialog(
          title: AppStrings.addItemToInvoiceTitle, maxWidth: 600,
          headerIcon: const Icon(Icons.add_shopping_cart_rounded),
          children: [
            ReusableInput(hint: AppStrings.searchItemHint, prefixIcon: const Icon(Icons.search_rounded),
              controller: TextEditingController(text: searchQuery), onChanged: (v) => setDialogState(() => searchQuery = v), showClearButton: false),
            SizedBox(height: 12.h),
            if (selectedId == null)
              Container(
                constraints: BoxConstraints(maxHeight: 200.h),
                decoration: BoxDecoration(border: Border.all(color: Theme.of(ctx).colorScheme.outlineVariant.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(AppRadius.md)),
                child: results.isEmpty ? Center(child: Padding(padding: EdgeInsets.all(20.w), child: const ReusableText(AppStrings.noMatchingResultsPurchase))) : ListView.separated(
                  shrinkWrap: true, itemCount: results.length,
                  separatorBuilder: (_, index) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final m = results[i];
                    return ListTile(dense: true,
                      title: ReusableText(m.name, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                      subtitle: ReusableText('${AppStrings.barcodeLabelPrefix}${m.barcodes.firstOrNull ?? "---"} | ${AppStrings.stockLabelPrefix}${m.quantity}', style: AppTextStyles.caption(context)),
                      trailing: Icon(Icons.add_circle_outline_rounded, size: AppIconSize.md.value, color: AppColors.primary),
                      onTap: () => setDialogState(() {
                        selectedId = m.id;
                        priceCtrl.text = m.buyPrice.toStringAsFixed(2);
                        if (m.units.isNotEmpty) { selectedUnitId = m.units.first.id; selectedUnitName = m.units.first.name; }
                      }),
                    );
                  },
                ),
              ),
            if (selectedId != null && selectedMed != null) ...[
              AppCard(
                backgroundColor: Theme.of(ctx).colorScheme.primaryContainer.withValues(alpha: 0.1),
                padding: EdgeInsets.all(AppSpacing.md.w),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ReusableText(selectedMed.name, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ReusableText(AppStrings.currentStockLabelFormat.replaceFirst('%s', '${selectedMed.quantity}'), style: AppTextStyles.caption(context).copyWith(color: Theme.of(ctx).colorScheme.onSurfaceVariant)),
                  ])),
                  IconButton(icon: const Icon(Icons.change_circle_outlined), onPressed: () => setDialogState(() => selectedId = null)),
                ]),
              ),
              SizedBox(height: 16.h),
              Row(children: [
                Expanded(child: ReusableInput(label: AppStrings.incomingQuantity, controller: qtyCtrl, keyboardType: TextInputType.number, prefixIcon: const Icon(Icons.unfold_more_rounded))),
                SizedBox(width: 12.w),
                Expanded(child: ReusableInput(label: AppStrings.buyUnitPrice, controller: priceCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: const Icon(Icons.attach_money_rounded))),
              ]),
              SizedBox(height: 12.h),
              Row(children: [
                Expanded(child: ReusableInput(label: AppStrings.batchNumberLabel, controller: batchCtrl, prefixIcon: const Icon(Icons.tag_rounded),
                  suffixIcon: IconButton(icon: const Icon(Icons.auto_awesome_rounded, size: 18), onPressed: () => setDialogState(() => batchCtrl.text = _generateBatchNumber())),
                )),
                SizedBox(width: 12.w),
                Expanded(child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(context: ctx, initialDate: DateTime.now().add(const Duration(days: 365)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 3650)));
                    if (picked != null) setDialogState(() => expiryDate = picked);
                  },
                  child: InputDecorator(decoration: InputDecoration(labelText: AppStrings.expiryDateLabel, isDense: true, border: const OutlineInputBorder(), suffixIcon: const Icon(Icons.calendar_month_rounded, size: 20)),
                    child: ReusableText(expiryDate == null ? AppStrings.selectDatePurchase : FormatUtils.date(expiryDate!), style: AppTextStyles.body(context)),
                  ),
                )),
              ]),
              if (selectedMed.units.length > 1) ...[
                SizedBox(height: 12.h),
                ReusableDropdown<String>(
                  labelText: AppStrings.supplyUnit, hintText: AppStrings.selectUnitHintPurchase,
                  items: selectedMed.units.map((u) => u.id).toList(), value: selectedUnitId,
                  itemAsString: (id) => selectedMed.units.firstWhereOrNull((x) => x.id == id)?.name ?? id,
                  onChanged: (v) {
                    final u = selectedMed.units.firstWhereOrNull((x) => x.id == v);
                    setDialogState(() { selectedUnitId = v; selectedUnitName = u?.name; if (u != null) priceCtrl.text = u.buyPrice.toStringAsFixed(2); });
                  },
                ),
              ],
              SizedBox(height: 12.h),
              Row(children: [
                Expanded(child: ReusableInput(label: AppStrings.itemDiscount, controller: discountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(ctx).colorScheme.outlineVariant), borderRadius: BorderRadius.circular(AppRadius.sm)),
                  child: DropdownButton<String>(value: discountType, underline: const SizedBox(),
                    items: const [DropdownMenuItem(value: '%', child: ReusableText('%')), DropdownMenuItem(value: 'fixed', child: ReusableText(AppStrings.fixedValue))],
                    onChanged: (v) => setDialogState(() => discountType = v ?? '%'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(child: ReusableInput(label: AppStrings.itemTaxValue, controller: taxCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
              ]),
              if (lastPrice != null)
                Padding(padding: EdgeInsets.only(top: 10.h), child: Row(children: [
                  Icon(Icons.info_outline_rounded, size: 14, color: AppColors.warning),
                  SizedBox(width: 6.w),
                  ReusableText('${AppStrings.lastPurchasePriceInfo}${FormatUtils.currency(lastPrice)}', style: AppTextStyles.caption(context).copyWith(color: AppColors.warning, fontWeight: FontWeight.bold)),
                ])),
            ],
            SizedBox(height: 24.h),
            DialogActions(confirmText: AppStrings.addToInvoiceAction, onConfirm: selectedId == null ? null : () => Navigator.pop(ctx, true)),
          ],
        );
      });
    }).then((result) {
      if (result == true && selectedId != null) {
        final med = BranchDataService.getMedicine(selectedId!);
        final qty = int.tryParse(qtyCtrl.text) ?? 1;
        final price = double.tryParse(priceCtrl.text) ?? 0;
        final disc = double.tryParse(discountCtrl.text);
        final tax = double.tryParse(taxCtrl.text);
        bloc.add(AddPurchaseLine(
          medicineId: selectedId!, medicineName: med?.name ?? selectedId!,
          quantity: qty, unitPrice: price,
          batchNumber: batchCtrl.text.trim().isEmpty ? null : batchCtrl.text.trim(),
          expiryDate: expiryDate, discount: disc, discountType: discountType,
          taxAmount: tax, unitId: selectedUnitId, unitName: selectedUnitName,
        ));
        searchCtrl.clear();
      }
      qtyCtrl.dispose(); priceCtrl.dispose(); batchCtrl.dispose(); discountCtrl.dispose(); taxCtrl.dispose();
    });
  }

  String _generateBatchNumber() {
    final now = DateTime.now();
    return 'B${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${Uuid().v4().substring(0, 6).toUpperCase()}';
  }

  double? findLastUnitPrice(String? medicineId) {
    if (medicineId == null) return null;
    final all = BranchDataService.getPurchases(branchId: _branchId)
        .where((p) => !p.isDeleted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    for (final p in all) {
      final item = p.items.firstWhereOrNull((i) => i.medicineId == medicineId);
      if (item != null) return item.unitPrice;
    }
    return null;
  }

  Widget _buildItemSearchAndTable(BuildContext context, ColorScheme scheme, PurchasesState state) {
    final bloc = context.read<PurchasesBloc>();

    void onMedicineSelected(MedicineModel medicine) {
      // ذكاء مهندسة: إضافة الصنف فوراً للفاتورة بالقيم الافتراضية
      bloc.add(AddPurchaseLine(
        medicineId: medicine.id,
        medicineName: medicine.name,
        quantity: 1,
        unitPrice: medicine.buyPrice,
        unitId: medicine.units.firstOrNull?.id,
        unitName: medicine.units.firstOrNull?.name,
        units: medicine.units,
        batchNumber: _generateBatchNumber(),
      ));
      
      // تشغيل تنبيه صوتي بسيط للنجاح
      SoundService.instance.play(SoundEffect.itemAdded);
      
      // تنبيه خفيف في الواجهة
      AppSnackbar.success('تم إضافة ${medicine.name} للفاتورة');
    }

    return FormCard(
      child: Column(
        children: [
          // Search Bar Row
          Padding(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: Row(
              children: [
                ReusableButton(
                  text: AppStrings.newMedicineAction,
                  prefixIcon: Icons.add,
                  type: ButtonType.outlined,
                  onPressed: () => context.push(Routes.INVENTORY_ADD),
                ),
                SizedBox(width: AppSizes.spacingMD),
                Expanded(
                  child: MedicineSearchField(
                    controller: _searchCtrl,
                    onSelected: onMedicineSelected,
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: scheme.primary, // Sector color (dynamically from theme)
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.md.r),
                topRight: Radius.circular(AppRadius.md.r),
              ),
            ),
            child: Row(
              children: [
                _tableHeader(AppStrings.columnHash, width: 30),
                _tableHeader(AppStrings.columnItemName, isExpanded: true),
                _tableHeader(AppStrings.columnStock, width: 80),
                _tableHeader(AppStrings.columnUnit, width: 90),
                _tableHeader(AppStrings.columnQuantity, width: 70),
                _tableHeader(AppStrings.columnBuyPrice, width: 90),
                _tableHeader(AppStrings.columnDiscountPercent, width: 60),
                _tableHeader(AppStrings.columnTotal, width: 80),
                _tableHeader(AppStrings.columnSellPrice, width: 90),
                _tableHeader(AppStrings.columnBatch, width: 120),
                _tableHeader(AppStrings.columnExpiry, width: 140),
                _tableHeader('', width: 40),
              ],
            ),
          ),
          // Table Body
          if (state.receiptLines.isEmpty)
            Padding(
              padding: EdgeInsets.all(AppSpacing.xxl.h),
              child: const Center(child: ReusableText(AppStrings.noItemsYet)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.receiptLines.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1),
              itemBuilder: (context, index) => _buildItemRow(context, scheme, state, index),
            ),
          // Table Footer Summary
          Container(
            padding: EdgeInsets.all(AppSpacing.md.w),
            color: scheme.surfaceContainerLow,
            child: Row(
              children: [
                ReusableText(AppStrings.totalQuantityLabel, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                ReusableText(state.receiptLines.fold(0.0, (s, l) => s + l.quantity).toStringAsFixed(2), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                SizedBox(width: 24.w),
                ReusableText(AppStrings.totalAmountLabel, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                ReusableText(FormatUtils.currency(state.finalAmount), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String label, {double? width, bool isExpanded = false}) {
    final child = ReusableText(
      label,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
    );
    if (isExpanded) return Expanded(child: child);
    return SizedBox(width: width?.w, child: child);
  }

  Widget _buildItemRow(BuildContext context, ColorScheme scheme, PurchasesState state, int index) {
    final line = state.receiptLines[index];
    final bloc = context.read<PurchasesBloc>();
    final med = BranchDataService.getMedicine(line.medicineId);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      color: index % 2 == 0 ? null : scheme.surfaceContainerHighest.withValues(alpha: 0.1),
      child: Row(
        children: [
          // #
          SizedBox(width: 30.w, child: ReusableText('${index + 1}', textAlign: TextAlign.center, style: AppTextStyles.caption(context))),
          // Item Name
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: ReusableText(line.medicineName, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          // Stock
          SizedBox(
            width: 80.w,
            child: ReusableText('${med?.quantity ?? 0} ${AppStrings.unitPiece}', textAlign: TextAlign.center, style: AppTextStyles.caption(context)),
          ),
          // Unit
          SizedBox(
            width: 90.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ReusableDropdown<String>(
                items: line.units.map((u) => u.id).toList(),
                value: line.unitId,
                hintText: AppStrings.unitLabelShort,
                itemAsString: (id) => line.units.firstWhereOrNull((u) => u.id == id)?.name ?? id,
                onChanged: (v) {
                  final u = line.units.firstWhereOrNull((x) => x.id == v);
                  if (u != null) bloc.add(UpdatePurchaseLineUnit(index, u.id, u.name));
                },
                isCompact: true,
              ),
            ),
          ),
          // Quantity
          SizedBox(
            width: 70.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextField(
                controller: TextEditingController(text: '${line.quantity}'),
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold),
                decoration: _compactInputDecoration(),
                keyboardType: TextInputType.number,
                onChanged: (v) => bloc.add(UpdatePurchaseLineQuantity(index, int.tryParse(v) ?? line.quantity)),
              ),
            ),
          ),
          // Purchase Price
          SizedBox(
            width: 90.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextField(
                controller: TextEditingController(text: line.unitPrice.toStringAsFixed(2)),
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(context),
                decoration: _compactInputDecoration(),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => bloc.add(UpdatePurchaseLineUnitPrice(index, double.tryParse(v) ?? line.unitPrice)),
              ),
            ),
          ),
          // Discount %
          SizedBox(
            width: 60.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextField(
                controller: TextEditingController(text: line.discount?.toStringAsFixed(0) ?? ''),
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(context),
                decoration: _compactInputDecoration(),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => bloc.add(UpdatePurchaseLineDiscount(index, double.tryParse(v))),
              ),
            ),
          ),
          // Total
          SizedBox(
            width: 80.w,
            child: ReusableText(line.finalLineTotal.toStringAsFixed(2), textAlign: TextAlign.center, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)),
          ),
          // Sale Price
          SizedBox(
            width: 90.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextField(
                controller: TextEditingController(text: med?.sellPrice.toStringAsFixed(2) ?? '0'),
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(context),
                decoration: _compactInputDecoration(),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => bloc.add(UpdatePurchaseLineSellPrice(index, double.tryParse(v) ?? 0)),
              ),
            ),
          ),
          // Batch Number
          SizedBox(
            width: 120.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextField(
                controller: TextEditingController(text: line.batchNumber ?? ''),
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(context),
                decoration: _compactInputDecoration(),
                onChanged: (v) => bloc.add(UpdatePurchaseLineBatch(index, v.isEmpty ? null : v)),
              ),
            ),
          ),
          // Expiry Date
          SizedBox(
            width: 140.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: InkWell(
                onTap: () => _selectExpiry(context, index, line.expiryDate),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: scheme.outlineVariant),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableText(
                        line.expiryDate == null ? AppStrings.expiryDateFormatHint : FormatUtils.date(line.expiryDate!),
                        style: AppTextStyles.caption(context).copyWith(color: line.expiryDate == null ? scheme.onSurfaceVariant : null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Delete
          SizedBox(
            width: 40.w,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => bloc.add(RemovePurchaseLine(index)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _compactInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r)),
    );
  }

  Widget _buildPaymentSectionMatchImage(BuildContext context, ColorScheme scheme, PurchasesState state) {
    final bloc = context.read<PurchasesBloc>();
    return Column(
      children: [
        FormCard(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(AppStrings.addPaymentTitle, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: AppSpacing.md.h),
              // Total Color Bar
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md.r),
                  border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText('${AppStrings.total}:', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                    ReusableText(FormatUtils.currency(state.finalAmount), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              _responsiveFields(context, minWidth: 260, children: [
                // المبلغ المدفوع
                ReusableInput(
                  label: AppStrings.paidAmountLabel,
                  controller: TextEditingController(text: state.paidAmount.toString()),
                  suffixIcon: const Icon(Icons.money_outlined, size: 18),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => bloc.add(SetPurchasePaidAmount(double.tryParse(v) ?? 0)),
                ),
                // المدفوعة على (التاريخ)
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.paymentDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && context.mounted) {
                      context.read<PurchasesBloc>().add(SetPurchasePaymentDate(picked));
                    }
                  },
                  child: ReusableInput(
                    label: AppStrings.paidOnDateLabel,
                    enabled: false,
                    controller: TextEditingController(text: FormatUtils.date(state.paymentDate)),
                    suffixIcon: const Icon(Icons.calendar_month, size: 18),
                  ),
                ),
                // طريقة الدفع
                ReusableDropdown<String>(
                  labelText: AppStrings.paymentMethodLabelPurchase,
                  hintText: AppStrings.selectPaymentMethodHint,
                  items: const [AppStrings.paymentMethodCashPurchase, AppStrings.paymentMethodCardPurchase, AppStrings.paymentMethodCreditPurchase],
                  value: state.getPaymentLabel(state.paymentMethod),
                  itemAsString: (v) => v,
                  onChanged: (v) {
                    final method = switch (v) { AppStrings.paymentMethodCashPurchase => 'cash', AppStrings.paymentMethodCreditPurchase => 'credit', AppStrings.paymentMethodCardPurchase => 'card', _ => 'cash' };
                    bloc.add(SetPurchasePaymentMethod(method));
                  },
                ),
              ]),
              SizedBox(height: AppSpacing.md.h),
              // الحساب
              _responsiveFields(context, minWidth: 260, children: [
                const SizedBox(), // Empty for alignment like image
                ReusableDropdown<String>(
                  labelText: AppStrings.accountLabel,
                  hintText: AppStrings.selectAccountHint,
                  items: _paymentAccounts.keys.toList(),
                  value: state.paymentAccountId ?? _paymentAccounts.keys.first,
                  itemAsString: (v) => _paymentAccounts[v] ?? v,
                  onChanged: (v) {
                    final name = _paymentAccounts[v];
                    if (v != null) bloc.add(SetPurchasePaymentAccount(v, name));
                  },
                ),
              ]),
              SizedBox(height: AppSpacing.md.h),
              // ملاحظة الدفع
              ReusableInput(
                label: AppStrings.paymentNoteLabel,
                maxLines: 3,
                onChanged: (v) => bloc.add(SetPurchaseNotes(v)),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        // Final Footer with Due Amount and Save
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 200), // Placeholder for left balance
            // Save Button
            SizedBox(
              width: 150.w,
              child: ReusableButton(
                text: AppStrings.save,
                prefixIcon: Icons.save,
                onPressed: () => _submitForm(context),
              ),
            ),
            // Due Amount
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md.r),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  ReusableText(AppStrings.dueAmountLabel, style: AppTextStyles.body(context).copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                  ReusableText(FormatUtils.currency(state.finalAmount - state.paidAmount), style: AppTextStyles.body(context).copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _responsiveFields(BuildContext context, {required List<Widget> children, double minWidth = 255}) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final cols = constraints.maxWidth >= 1050 ? 4 : constraints.maxWidth >= 720 ? 2 : 1;
      final w = cols == 1
          ? constraints.maxWidth
          : ((constraints.maxWidth - AppSpacing.md.w * (cols - 1)) / cols).clamp(minWidth, double.infinity);
      return Wrap(spacing: AppSpacing.md.w, runSpacing: AppSpacing.md.h, children: children.map((c) => SizedBox(width: w, child: c)).toList());
    });
  }
}


