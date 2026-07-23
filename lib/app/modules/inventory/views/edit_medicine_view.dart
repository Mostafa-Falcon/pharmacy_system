import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import '../bloc/medicines_bloc.dart';
import 'widgets/medicine_form_content.dart';

/// شاشة تعديل بيانات الدواء — محسنة لضمان جلب البيانات حتى بعد ريفريش الصفحة
class EditMedicineView extends StatefulWidget {
  final MedicineModel? medicine;
  final String? medicineId;

  const EditMedicineView({
    super.key,
    this.medicine,
    this.medicineId,
  });

  @override
  State<EditMedicineView> createState() => _EditMedicineViewState();
}

class _EditMedicineViewState extends State<EditMedicineView> {
  MedicineModel? _medicine;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMedicine();
  }

  Future<void> _loadMedicine() async {
    if (widget.medicine != null) {
      setState(() {
        _medicine = widget.medicine;
        _isLoading = false;
      });
      return;
    }

    if (widget.medicineId == null) {
      setState(() {
        _isLoading = false;
        _error = AppStrings.medicineNotFound;
      });
      return;
    }

    try {
      final medicine = await sl<MedicinesRepository>().getByIdAsync(widget.medicineId!);
      if (mounted) {
        setState(() {
          _medicine = medicine;
          _isLoading = false;
          if (medicine == null) _error = AppStrings.medicineNotFound;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'خطأ في تحميل بيانات الدواء: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const HomeShell(
        title: AppStrings.editMedicine,
        child: Center(child: LoadingIndicator()),
      );
    }

    if (_medicine == null) {
      return HomeShell(
        title: AppStrings.editMedicine,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableText(
                _error ?? AppStrings.medicineNotFound,
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: 16.h),
              ReusableButton(
                text: 'العودة للمخزن',
                prefixIcon: Icons.arrow_back_rounded,
                type: ButtonType.outlined,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<MedicinesBloc>(),
      child: MedicineFormContent(
        initialMedicine: _medicine,
        isEditMode: true,
      ),
    );
  }
}
