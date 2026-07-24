import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_unit_model.dart';
import 'package:pharmacy_system/app/core/models/base/lookup_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/lookup_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/barcode_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/medicines_bloc.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import '../add_medicine_form_data.dart';
import '../add_medicine_unit_card.dart';

class _ExpiryDateSlot {
  final TextEditingController dayCtrl = TextEditingController();
  final TextEditingController monthCtrl = TextEditingController();
  final TextEditingController yearCtrl = TextEditingController();
  DateTime? picked;

  int? get day => int.tryParse(dayCtrl.text);
  int? get month => int.tryParse(monthCtrl.text);
  int? get year => int.tryParse(yearCtrl.text);

  DateTime? get date {
    if (day != null && month != null && year != null) {
      try {
        return DateTime(year!, month!, day!);
      } catch (_) {
        return null;
      }
    }
    return picked;
  }

  void setDate(DateTime d) {
    dayCtrl.text = d.day.toString();
    monthCtrl.text = d.month.toString();
    yearCtrl.text = d.year.toString();
    picked = d;
  }

  void dispose() {
    dayCtrl.dispose();
    monthCtrl.dispose();
    yearCtrl.dispose();
  }
}

class MedicineFormContent extends StatefulWidget {
  final MedicineModel? initialMedicine;
  final bool isEditMode;

  const MedicineFormContent({
    super.key,
    this.initialMedicine,
    this.isEditMode = false,
  });

  @override
  State<MedicineFormContent> createState() => _MedicineFormContentState();
}

class _MedicineFormContentState extends State<MedicineFormContent> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _strengthController;
  late final TextEditingController _packageSizeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _locationController;
  late final TextEditingController _taxValueController;
  late final List<TextEditingController> _additionalBarcodeControllers;

  String? _selectedItemTypeId;
  String? _selectedGroupId;
  String? _selectedSupplierId;
  String? _selectedDosageForm;
  String? _selectedContainerShape;

  bool _appearanceSpecsEnabled = false;
  bool _alertEnabled = false;
  bool _expiryTrackingEnabled = false;
  bool _showOldPrice = false;
  bool _isTaxable = false;
  bool _pricesIncludeTax = false;
  bool _allowNegativeStock = false;
  bool _isActive = true;
  final List<_ExpiryDateSlot> _expiryDateSlots = [];
  String? _imageUrl;
  String? _selectedTaxType;
  bool _isDirty = false;
  bool _allowPop = false;

  late final TextEditingController _imageUrlController;
  late final List<AddUnitFormData> _units;
  bool _isSubmitting = false;

  static const _dosageForms = [
    'أقراص',
    'كبسولات',
    'شرب (شراب)',
    'حقن',
    'كريم',
    'قطرات',
    'مسحوق',
    'أخرى',
  ];
  static const _containerShapes = [
    'صندوق (كارتون)',
    'شريط (بليستر)',
    'زجاجة',
    'أنبوبة',
    'عبوة بلاستيك',
    'أمبولة',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialMedicine;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _nameEnController = TextEditingController(text: initial?.nameEn ?? '');
    _strengthController = TextEditingController(text: initial?.strength ?? '');
    _packageSizeController = TextEditingController(text: initial?.packageSize ?? '');
    _descriptionController = TextEditingController(text: initial?.description ?? '');
    _barcodeController = TextEditingController(text: initial?.barcodes.firstOrNull ?? '');
    _locationController = TextEditingController(text: initial?.location ?? '');
    _taxValueController = TextEditingController(
      text: initial?.taxValue?.toString() ?? '',
    );
    _imageUrlController = TextEditingController(
      text: initial?.imageUrl ?? '',
    );
    _additionalBarcodeControllers = [];

    if (initial != null) {
      _selectedItemTypeId = initial.itemTypeId;
      _selectedGroupId = initial.groupId;
      _selectedSupplierId = initial.supplierName;
      _selectedDosageForm = initial.dosageForm;
      _selectedContainerShape = initial.containerShape;
      _appearanceSpecsEnabled = initial.dosageFormEnabled;
      _alertEnabled = initial.alertEnabled;
      _expiryTrackingEnabled = initial.expiryTrackingEnabled;
      _showOldPrice = initial.oldSellPrice != null;
      _isTaxable = initial.isTaxable;
      _pricesIncludeTax = initial.pricesIncludeTax;
      _allowNegativeStock = initial.allowNegativeStock;
      _isActive = initial.isActive;
      _imageUrl = initial.imageUrl;
      if ((initial.expiryDates ?? []).isNotEmpty) {
        for (final d in initial.expiryDates!) {
          final slot = _ExpiryDateSlot();
          slot.setDate(d);
          _expiryDateSlots.add(slot);
        }
      } else if (initial.expiryDate != null) {
        final slot = _ExpiryDateSlot();
        slot.setDate(initial.expiryDate!);
        _expiryDateSlots.add(slot);
      }
      _selectedTaxType = initial.taxType;
    }

    _units = [
      AddUnitFormData(
        name: initial?.units.firstOrNull?.name ?? 'علبة',
        level: 1,
        factor: initial?.units.firstOrNull?.conversionFactor.toString() ?? '10',
        buyPrice: initial?.units.firstOrNull?.buyPrice.toString() ?? '0',
        sellPrice: initial?.units.firstOrNull?.sellPrice.toString() ?? '0',
        oldPrice: initial?.units.firstOrNull?.oldSellPrice?.toString() ?? '',
        quantity: initial?.units.firstOrNull?.quantity.toString() ?? '0',
        minStock: initial?.minStock.toString() ?? '10',
        discount: initial?.units.firstOrNull?.discountPercent?.toString() ?? '',
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _strengthController.dispose();
    _packageSizeController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    _locationController.dispose();
    _taxValueController.dispose();
    _imageUrlController.dispose();
    for (final c in _additionalBarcodeControllers) {
      c.dispose();
    }
    for (final u in _units) {
      u.dispose();
    }
    for (final s in _expiryDateSlots) {
      s.dispose();
    }
    super.dispose();
  }

  double get _totalQuantity {
    if (_units.isEmpty) return 0;
    
    // حساب المعاملات المطلقة لكل وحدة (عدد القطع الصغرى في كل وحدة)
    List<double> absoluteFactors = _calculateAbsoluteFactors();
    
    double total = 0;
    for (var i = 0; i < _units.length; i++) {
      final qty = int.tryParse(_units[i].quantityController.text) ?? 0;
      total += qty * absoluteFactors[i];
    }
    return total;
  }

  List<double> _calculateAbsoluteFactors() {
    List<double> absoluteFactors = List.filled(_units.length, 1.0);
    
    // الوحدات تترتب من الأكبر للأصغر: علبة (0)، شريط (1)، قرص (2)
    // المعامل المدخل في الواجهة للوحدة i هو "كم قطعة من الأصغر (Base Unit) موجودة في هذه الوحدة"
    for (var i = 0; i < _units.length; i++) {
      absoluteFactors[i] = double.tryParse(_units[i].factorController.text) ?? (i == _units.length - 1 ? 1.0 : 10.0);
    }
    return absoluteFactors;
  }

  double get _profitMargin {
    if (_units.isEmpty) return 0;
    final buy = double.tryParse(_units.first.buyPriceController.text) ?? 0;
    final sell = double.tryParse(_units.first.sellPriceController.text) ?? 0;
    if (buy <= 0) return 0;
    return ((sell - buy) / buy) * 100;
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<bool> _confirmExit() async {
    if (!_isDirty || _allowPop) return true;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ReusableDialog(
        title: GeneralStrings.cancel,
        headerIcon: const Icon(Icons.warning_amber_rounded),
        children: [
          const ReusableText(InventoryStrings.unsavedChangesSimple),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: InventoryStrings.continueEditing,
            confirmText: GeneralStrings.exit,
            onCancel: () => Navigator.pop(context, false),
            onConfirm: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _allowPop = true);
    }
    return confirm ?? false;
  }

  void _addBarcodeField() {
    setState(() {
      _additionalBarcodeControllers.add(TextEditingController());
      _isDirty = true;
    });
  }

  void _removeBarcodeField(int index) {
    setState(() {
      _additionalBarcodeControllers[index].dispose();
      _additionalBarcodeControllers.removeAt(index);
      _isDirty = true;
    });
  }

  void _onImageUrlChanged(String value) {
    setState(() => _imageUrl = value.trim().isEmpty ? null : value.trim());
    _markDirty();
  }

  void _clearImage() {
    _imageUrlController.clear();
    setState(() => _imageUrl = null);
  }

  void _showAddLookupDialog(BuildContext context, LookupType type) async {
    final nameController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: type == LookupType.itemType
            ? 'إضافة نوع صنف جديد'
            : 'إضافة مجموعة جديدة',
        children: [
          AppInput(
            controller: nameController,
            label: 'الاسم الجديد',
            autofocus: true,
          ),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: 'إلغاء',
            confirmText: 'تأكيد الحفظ',
            onCancel: () => Navigator.pop(ctx),
            onConfirm: () => Navigator.pop(ctx, nameController.text.trim()),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (result != null && result.isNotEmpty) {
      final lookup = await LookupService.addByName(name: result, type: type);
      setState(() {
        _isDirty = true;
        if (type == LookupType.itemType) {
          _selectedItemTypeId = lookup.id;
        } else {
          _selectedGroupId = lookup.id;
        }
      });
    }
  }

  void _showAddSupplierDialog() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: 'إضافة مورد جديد معتمد',
        children: [
          AppInput(
            controller: nameController,
            label: 'اسم الشركة أو المورد *',
            prefixIcon: const Icon(Icons.business_rounded),
            autofocus: true,
          ),
          SizedBox(height: 16.h),
          AppInput(
            controller: phoneController,
            label: 'رقم الهاتف',
            prefixIcon: const Icon(Icons.phone_rounded),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: 'إلغاء الأمر',
            confirmText: 'حفظ المورد',
            onCancel: () => Navigator.pop(ctx, false),
            onConfirm: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (result == true && nameController.text.trim().isNotEmpty) {
      final supplier = await SupplierService.add(
        name: nameController.text.trim(),
        partyType: SupplierPartyType.company,
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
      );
      setState(() {
        _selectedSupplierId = supplier.id;
        _isDirty = true;
      });
    }
    nameController.dispose();
    phoneController.dispose();
  }

  void _addUnit() {
    final level = _units.length + 1;
    setState(() {
      _units.add(
        AddUnitFormData(
          name: level == 2
              ? 'شريط'
              : level == 3
                  ? 'قرص'
                  : 'وحدة $level',
          level: level,
        ),
      );
      _isDirty = true;
    });
  }

  void _removeUnit(int index) {
    if (index <= 0 || index >= _units.length) return;
    setState(() {
      _units[index].dispose();
      _units.removeAt(index);
      _isDirty = true;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    var primaryBarcode = _barcodeController.text.trim();
    if (primaryBarcode.isEmpty) {
      primaryBarcode = await BarcodeService.generate();
      _barcodeController.text = primaryBarcode;
    }

    if (await BarcodeService.isBarcodeTaken(primaryBarcode,
        excludeMedicineId: widget.initialMedicine?.id)) {
      setState(() => _isSubmitting = false);
      AppSnackbar.error(
        'الباركود الرئيسي مستخدم بالفعل!',
        title: 'أمان نظام الأدوية',
      );
      return;
    }

    final barcodes = [primaryBarcode];
    for (final c in _additionalBarcodeControllers) {
      final code = c.text.trim();
      if (code.isNotEmpty && !barcodes.contains(code)) barcodes.add(code);
    }
    final absoluteFactors = _calculateAbsoluteFactors();
    final units = _units.asMap().entries.map((entry) {
      final i = entry.key;
      final u = entry.value;
      return MedicineUnitModel(
        id: 'unit_${i + 1}',
        name: u.nameController.text.trim().isNotEmpty
            ? u.nameController.text.trim()
            : (i == 0 ? 'علبة' : 'وحدة ${i + 1}'),
        level: u.level,
        conversionFactor: absoluteFactors[i],
        buyPrice: double.tryParse(u.buyPriceController.text) ?? 0,
        sellPrice: double.tryParse(u.sellPriceController.text) ?? 0,
        oldSellPrice: _showOldPrice
            ? (double.tryParse(u.oldPriceController.text))
            : null,
        discountPercent: double.tryParse(u.discountController.text),
        quantity: int.tryParse(u.quantityController.text) ?? 0,
        allowSale: u.allowSale,
      );
    }).toList();

    final mainUnit = units.isNotEmpty ? units.first : null;
    final location = _locationController.text.trim();
    final taxValue = double.tryParse(_taxValueController.text);

    if (widget.isEditMode && widget.initialMedicine != null) {
      final updated = widget.initialMedicine!.copyWith(
        name: _nameController.text.trim(),
        nameEn: _nameEnController.text.trim().isEmpty
            ? null
            : _nameEnController.text.trim(),
        itemTypeId: _selectedItemTypeId,
        groupId: _selectedGroupId,
        barcodes: barcodes,
        buyPrice: mainUnit?.buyPrice ?? 0,
        sellPrice: mainUnit?.sellPrice ?? 0,
        oldSellPrice: _showOldPrice ? mainUnit?.oldSellPrice : null,
        quantity: _totalQuantity.toInt(),
        minStock: _alertEnabled
            ? (int.tryParse(_units.first.minStockController.text) ?? 10)
            : 0,
        alertEnabled: _alertEnabled,
        expiryTrackingEnabled: _expiryTrackingEnabled,
        expiryDate: _expiryTrackingEnabled ? _expiryDateSlots.map((s) => s.date).firstOrNull : null,
        expiryDates: _expiryTrackingEnabled ? _expiryDateSlots.map((s) => s.date).whereType<DateTime>().toList() : [],
        dosageFormEnabled: _appearanceSpecsEnabled,
        dosageForm: _appearanceSpecsEnabled ? _selectedDosageForm : null,
        strength: _strengthController.text.trim().isEmpty
            ? null
            : _strengthController.text.trim(),
        packageSize: _packageSizeController.text.trim().isEmpty
            ? null
            : _packageSizeController.text.trim(),
        supplierName: _selectedSupplierId,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        imageUrl: _imageUrl,
        containerShape: _appearanceSpecsEnabled ? _selectedContainerShape : null,
        units: units,
        location: location.isNotEmpty ? location : null,
        isTaxable: _isTaxable,
        taxType: _isTaxable ? _selectedTaxType : null,
        taxValue: _isTaxable && taxValue != null ? taxValue : null,
        pricesIncludeTax: _pricesIncludeTax,
        allowNegativeStock: _allowNegativeStock,
        isActive: _isActive,
      );
      if (!mounted) return;
      context.read<MedicinesBloc>().add(UpdateMedicine(updated));
    } else {
      final medicine = MedicineModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_med',
        name: _nameController.text.trim(),
        nameEn: _nameEnController.text.trim().isEmpty
            ? null
            : _nameEnController.text.trim(),
        itemTypeId: _selectedItemTypeId,
        groupId: _selectedGroupId,
        barcodes: barcodes,
        buyPrice: mainUnit?.buyPrice ?? 0,
        sellPrice: mainUnit?.sellPrice ?? 0,
        oldSellPrice: _showOldPrice ? mainUnit?.oldSellPrice : null,
        quantity: _totalQuantity.toInt(),
        minStock: _alertEnabled
            ? (int.tryParse(_units.first.minStockController.text) ?? 10)
            : 0,
        alertEnabled: _alertEnabled,
        expiryTrackingEnabled: _expiryTrackingEnabled,
        expiryDate: _expiryTrackingEnabled ? _expiryDateSlots.map((s) => s.date).firstOrNull : null,
        expiryDates: _expiryTrackingEnabled ? _expiryDateSlots.map((s) => s.date).whereType<DateTime>().toList() : [],
        dosageFormEnabled: _appearanceSpecsEnabled,
        dosageForm: _appearanceSpecsEnabled ? _selectedDosageForm : null,
        strength: _strengthController.text.trim().isEmpty
            ? null
            : _strengthController.text.trim(),
        packageSize: _packageSizeController.text.trim().isEmpty
            ? null
            : _packageSizeController.text.trim(),
        supplierName: _selectedSupplierId,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        imageUrl: _imageUrl,
        containerShape: _appearanceSpecsEnabled ? _selectedContainerShape : null,
        branchId: AuthService.currentBranchId ?? '',
        units: units,
        location: location.isNotEmpty ? location : null,
        isTaxable: _isTaxable,
        taxType: _isTaxable ? _selectedTaxType : null,
        taxValue: _isTaxable && taxValue != null ? taxValue : null,
        pricesIncludeTax: _pricesIncludeTax,
        allowNegativeStock: _allowNegativeStock,
        isActive: _isActive,
      );
      if (!mounted) return;
      context.read<MedicinesBloc>().add(AddMedicine(medicine));
    }

    setState(() {
      _isSubmitting = false;
      _allowPop = true;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _addExpirySlot() {
    setState(() {
      _expiryDateSlots.add(_ExpiryDateSlot());
      _isDirty = true;
    });
  }

  void _removeExpirySlot(int index) {
    setState(() {
      _expiryDateSlots[index].dispose();
      _expiryDateSlots.removeAt(index);
      _isDirty = true;
    });
  }

  void _pickDateForSlot(int index) async {
    final now = DateTime.now();
    final current = _expiryDateSlots[index].date;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      setState(() {
        _expiryDateSlots[index].setDate(picked);
        _isDirty = true;
      });
    }
  }

  Widget buildBasicInfoCard() {
    final scheme = Theme.of(context).colorScheme;
    return FormCard(
      child: Column(
        children: [
          const SectionHeader(
            title: InventoryStrings.basicInfo,
            icon: Icons.assignment_outlined,
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 24.w,
            runSpacing: 16.h,
            children: [
              SizedBox(
                width: 450.w,
                child: AppInput(
                  controller: _nameController,
                  label: InventoryStrings.medicineNameAr,
                  prefixIcon: Icon(
                    Icons.medication_rounded,
                    size: 18.sp,
                    color: scheme.primary,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'اسم الدواء بالعربية إجباري'
                      : null,
                ),
              ),
              SizedBox(
                width: 450.w,
                child: AppInput(
                  controller: _nameEnController,
                  label: InventoryStrings.medicineNameEn,
                  prefixIcon: Icon(Icons.font_download_outlined, size: 18.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ReusableItemImage(
                imageUrl: _imageUrl,
                size: 56,
                borderRadius: 8,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppInput(
                  controller: _imageUrlController,
                  label: InventoryStrings.imageUrlLabel,
                  prefixIcon: Icon(Icons.link_rounded, size: 18.sp),
                  hint: InventoryStrings.imageUrlHint,
                  onChanged: _onImageUrlChanged,
                  suffixIcon: _imageUrl != null
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18.sp,
                            color: AppColors.error,
                          ),
                          onPressed: _clearImage,
                        )
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          buildToggleCardTile(
            label: InventoryStrings.extraOptionsToggle,
            value: _appearanceSpecsEnabled,
            icon: Icons.auto_awesome,
            onChanged: (v) => setState(() => _appearanceSpecsEnabled = v),
          ),
          if (_appearanceSpecsEnabled) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    controller: _strengthController,
                    label: InventoryStrings.strength,
                    prefixIcon: const Icon(Icons.biotech_rounded),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppInput(
                    controller: _packageSizeController,
                    label: InventoryStrings.packageSize,
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: AppDropdown<String>(
                    hintText: InventoryStrings.dosageFormHint,
                    labelText: InventoryStrings.dosageFormLabel,
                    items: _dosageForms,
                    value: _selectedDosageForm,
                    itemAsString: (v) => v,
                    onChanged: (v) => setState(() => _selectedDosageForm = v),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppDropdown<String>(
                    hintText: InventoryStrings.containerShapeHint,
                    labelText: InventoryStrings.containerShapeLabel,
                    items: _containerShapes,
                    value: _selectedContainerShape,
                    itemAsString: (v) => v,
                    onChanged: (v) =>
                        setState(() => _selectedContainerShape = v),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            AppInput(
              controller: _locationController,
              label: InventoryStrings.storageLocation,
              prefixIcon: Icon(
                Icons.location_on_outlined,
                size: 18.sp,
                color: scheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildBarcodeAndClassificationCard() {
    final scheme = Theme.of(context).colorScheme;
    final itemTypes = LookupService.getAll(type: LookupType.itemType);
    final groups = LookupService.getAll(type: LookupType.group);

    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: InventoryStrings.classificationAndBarcode,
            icon: Icons.qr_code_scanner_rounded,
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                width: 400.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppDropdown<LookupModel>(
                        labelText: InventoryStrings.itemTypeLabel,
                        hintText: GeneralStrings.searchHint,
                        items: itemTypes,
                        value: _selectedItemTypeId != null
                            ? itemTypes.firstWhereOrNull(
                                (l) => l.id == _selectedItemTypeId,
                              )
                            : null,
                        itemAsString: (l) => l.name,
                        onChanged: (v) =>
                            setState(() => _selectedItemTypeId = v?.id),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    IconButton.filledTonal(
                      onPressed: () =>
                          _showAddLookupDialog(context, LookupType.itemType),
                      icon: const Icon(Icons.add_rounded),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        minimumSize: Size(44.w, 44.h),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 400.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppDropdown<LookupModel>(
                        labelText: InventoryStrings.groupLabel,
                        hintText: GeneralStrings.searchHint,
                        items: groups,
                        value: _selectedGroupId != null
                            ? groups.firstWhereOrNull(
                                (l) => l.id == _selectedGroupId,
                              )
                            : null,
                        itemAsString: (l) => l.name,
                        onChanged: (v) =>
                            setState(() => _selectedGroupId = v?.id),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    IconButton.filledTonal(
                      onPressed: () =>
                          _showAddLookupDialog(context, LookupType.group),
                      icon: const Icon(Icons.add_rounded),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        minimumSize: Size(44.w, 44.h),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          buildSupplierDropdownSection(),
          SizedBox(height: 16.h),
          AppInput(
            controller: _barcodeController,
            label: InventoryStrings.barcodeMainLabel,
            prefixIcon: Icon(
              Icons.qr_code_2_rounded,
              size: 20.sp,
              color: scheme.primary,
            ),
            suffixIcon: IconButton(
              tooltip: InventoryStrings.generateBarcodeTooltip,
              icon: Icon(
                Icons.autorenew_rounded,
                color: scheme.primary,
                size: 20.sp,
              ),
              onPressed: () async {
                final generated = await BarcodeService.generate();
                _barcodeController.text = generated;
                _markDirty();
                AppSnackbar.success(
                  '${InventoryStrings.barcodeGeneratedSuccess}$generated',
                  title: InventoryStrings.generateBarcode,
                );
              },
            ),
            inputFormatters: [LengthLimitingTextInputFormatter(32)],
          ),
          for (var i = 0; i < _additionalBarcodeControllers.length; i++)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: AppInput(
                controller: _additionalBarcodeControllers[i],
                label: '${InventoryStrings.extraBarcodePrefix}${i + 2}',
                prefixIcon: Icon(
                  Icons.view_week_rounded,
                  size: 20.sp,
                  color: scheme.primary,
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(32)],
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: AppColors.error,
                  ),
                  onPressed: () => _removeBarcodeField(i),
                ),
              ),
            ),
          SizedBox(height: 4.h),
          TextButton.icon(
            onPressed: _addBarcodeField,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: ReusableText(
              '${InventoryStrings.addExtraBarcodePrefix}${_additionalBarcodeControllers.length + 2}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSupplierDropdownSection() {
    final suppliers = SupplierService.getAll();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AppDropdown<SupplierModel>(
            labelText: InventoryStrings.supplierLabel,
            hintText: InventoryStrings.supplierHint,
            items: suppliers,
            value: _selectedSupplierId != null
                ? suppliers.firstWhereOrNull((s) => s.id == _selectedSupplierId)
                : null,
            itemAsString: (s) => s.name,
            onChanged: (v) => setState(() => _selectedSupplierId = v?.id),
          ),
        ),
        SizedBox(width: 4.w),
        IconButton.filledTonal(
          onPressed: _showAddSupplierDialog,
          icon: const Icon(Icons.person_add_alt_1_rounded),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            minimumSize: Size(44.w, 44.h),
          ),
        ),
      ],
    );
  }

  Widget buildPricingAndUnitsCard() {
    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: InventoryStrings.pricingAndUnitsAdd,
            icon: Icons.monetization_on_outlined,
          ),
          SizedBox(height: 24.h),
          buildToggleCardTile(
            label: InventoryStrings.dualPricingToggle,
            value: _showOldPrice,
            icon: Icons.swap_horizontal_circle_outlined,
            onChanged: (v) => setState(() => _showOldPrice = v),
          ),
          SizedBox(height: 24.h),
          ..._units.asMap().entries.map((entry) {
            return AddUnitCard(
              data: entry.value,
              index: entry.key,
              showOldPrice: _showOldPrice,
              canDelete: entry.key > 0 && entry.key == _units.length - 1,
              onDelete: () => _removeUnit(entry.key),
              onPriceChanged: () => setState(() {}),
            );
          }),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_units.isNotEmpty)
                ReusableButton(
                  text: _units.length == 1
                      ? InventoryStrings.addSubUnitSimple
                      : InventoryStrings.addSubSubUnit,
                  prefixIcon: Icons.playlist_add_rounded,
                  type: ButtonType.outlined,
                  onPressed: _addUnit,
                ),
              if (_units.isNotEmpty &&
                  _units.first.buyPriceController.text.isNotEmpty &&
                  _units.first.sellPriceController.text.isNotEmpty)
                buildCleanProfitBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTaxAndAdvancedCard() {
    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: InventoryStrings.taxAndAdvancedSimple,
            icon: Icons.tune_rounded,
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 12.h,
            children: [
              SizedBox(
                width: 450.w,
                child: buildToggleTile(
                  label: InventoryStrings.isTaxableSimple,
                  value: _isTaxable,
                  icon: Icons.receipt_long_rounded,
                  onChanged: (v) => setState(() {
                    _isTaxable = v;
                    if (!v) {
                      _taxValueController.clear();
                      _selectedTaxType = null;
                      _pricesIncludeTax = false;
                    }
                    _isDirty = true;
                  }),
                ),
              ),
              SizedBox(
                width: 450.w,
                child: buildToggleTile(
                  label: InventoryStrings.allowNegativeStockSimple,
                  value: _allowNegativeStock,
                  icon: Icons.unpublished_rounded,
                  onChanged: (v) => setState(() {
                    _allowNegativeStock = v;
                    _isDirty = true;
                  }),
                ),
              ),
            ],
          ),
          if (_isTaxable) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: AppDropdown<String>(
                    hintText: InventoryStrings.taxType,
                    labelText: InventoryStrings.taxType,
                    items: const ['percentage', 'fixed'],
                    value: _selectedTaxType,
                    itemAsString: (v) =>
                        v == 'percentage' ? 'نسبة مئوية %' : 'قيمة ثابتة',
                    onChanged: (v) => setState(() {
                      _selectedTaxType = v;
                      _taxValueController.clear();
                      _isDirty = true;
                    }),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppInput(
                    controller: _taxValueController,
                    label: _selectedTaxType == 'percentage'
                        ? InventoryStrings.taxPercentage
                        : InventoryStrings.fixedTax,
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() => _isDirty = true),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            buildToggleTile(
              label: InventoryStrings.pricesIncludeTaxSimple,
              value: _pricesIncludeTax,
              icon: Icons.price_check_rounded,
              onChanged: (v) => setState(() {
                _pricesIncludeTax = v;
                _isDirty = true;
              }),
            ),
          ],
          SizedBox(height: 12.h),
          buildToggleTile(
            label: InventoryStrings.isActiveLabel,
            value: _isActive,
            icon: Icons.toggle_on_rounded,
            onChanged: (v) => setState(() {
              _isActive = v;
              _isDirty = true;
            }),
          ),
        ],
      ),
    );
  }

  Widget buildToggleTile({
    required String label,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return SettingsToggleTile(
      icon: icon,
      title: label,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget buildInventoryControlCard() {
    return FormCard(
      child: Column(
        children: [
          const SectionHeader(
            title: InventoryStrings.inventorySecurityAdd,
            icon: Icons.shield_outlined,
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 12.h,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              SizedBox(
                width: 450.w,
                child: Column(
                  children: [
                    buildToggleCardTile(
                      label: InventoryStrings.lowStockAlertOptional,
                      value: _alertEnabled,
                      icon: Icons.notifications_none_rounded,
                      onChanged: (v) => setState(() => _alertEnabled = v),
                    ),
                    if (_alertEnabled) ...[
                      SizedBox(height: 16.h),
                      AppInput(
                        controller: _units.first.minStockController,
                        label: InventoryStrings.minStockLimitSimple,
                        prefixIcon:
                            const Icon(Icons.report_problem_outlined),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                width: 450.w,
                child: Column(
                  children: [
                    buildToggleCardTile(
                      label: InventoryStrings.expiryTrackingOptional,
                      value: _expiryTrackingEnabled,
                      icon: Icons.calendar_today_outlined,
                      onChanged: (v) =>
                          setState(() => _expiryTrackingEnabled = v),
                    ),
                    if (_expiryTrackingEnabled) ...[
                      SizedBox(height: 16.h),
                      ..._expiryDateSlots.asMap().entries.map((entry) {
                        final i = entry.key;
                        final slot = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _ExpiryDateRow(
                            slot: slot,
                            index: i,
                            canDelete: _expiryDateSlots.length > 1,
                            onPickDate: () => _pickDateForSlot(i),
                            onDelete: () => _removeExpirySlot(i),
                          ),
                        );
                      }),
                      TextButton.icon(
                        onPressed: _addExpirySlot,
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                        label: ReusableText(
                          'إضافة تاريخ صلاحية آخر',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppInput(
            controller: _descriptionController,
            label: InventoryStrings.notesAndFormulasAdd,
            prefixIcon: const Icon(Icons.edit_note_rounded),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 24.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ReusableButton(
          text: AuthStrings.cancelAndBack,
          onPressed: () => Navigator.of(context).pop(),
          type: ButtonType.outlined,
        ),
        SizedBox(
          width: 300.w,
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ReusableButton(
              text: _isSubmitting
                  ? InventoryStrings.submittingMedicine
                  : InventoryStrings.saveMedicineFull,
              onPressed: _isSubmitting ? null : _submit,
              prefixIcon: Icons.check_circle_rounded,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildToggleCardTile({
    required String label,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return SettingsToggleTile(
      icon: icon,
      title: label,
      value: value,
      onChanged: onChanged,
    );
  }



  Widget buildCleanProfitBadge() {
    final color = _profitMargin >= 0 ? AppColors.success : AppColors.error;
    return StatusBadge(
      label:
          '${InventoryStrings.profitMarginSimplePrefix}${_profitMargin.toStringAsFixed(1)}%',
      color: color,
      icon: _profitMargin >= 0
          ? Icons.trending_up_rounded
          : Icons.trending_down_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: widget.isEditMode ? InventoryStrings.editMedicine : InventoryStrings.addMedicine,
      child: PopScope(
        canPop: !_isDirty || _allowPop,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldPop = await _confirmExit();
            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            onChanged: _markDirty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBasicInfoCard(),
                SizedBox(height: 16.h),
                buildBarcodeAndClassificationCard(),
                SizedBox(height: 16.h),
                buildPricingAndUnitsCard(),
                SizedBox(height: 16.h),
                buildTaxAndAdvancedCard(),
                SizedBox(height: 16.h),
                buildInventoryControlCard(),
                SizedBox(height: 24.h),
                buildActionButtons(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpiryDateRow extends StatelessWidget {
  final _ExpiryDateSlot slot;
  final int index;
  final bool canDelete;
  final VoidCallback onPickDate;
  final VoidCallback onDelete;

  const _ExpiryDateRow({
    required this.slot,
    required this.index,
    required this.canDelete,
    required this.onPickDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          ReusableText(
            '${index + 1}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AppInput(
                    controller: slot.dayCtrl,
                    label: 'يوم',
                    hint: 'DD',
                    keyboardType: TextInputType.number,
                    showClearButton: false,
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: AppInput(
                    controller: slot.monthCtrl,
                    label: 'شهر',
                    hint: 'MM',
                    keyboardType: TextInputType.number,
                    showClearButton: false,
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: AppInput(
                    controller: slot.yearCtrl,
                    label: 'سنة',
                    hint: 'YYYY',
                    keyboardType: TextInputType.number,
                    showClearButton: false,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          IconButton(
            icon: Icon(
              Icons.calendar_month_rounded,
              color: scheme.primary,
              size: 20.sp,
            ),
            onPressed: onPickDate,
            tooltip: 'اختيار من التقويم',
          ),
          if (canDelete)
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline_rounded,
                color: AppColors.error,
                size: 20.sp,
              ),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}






