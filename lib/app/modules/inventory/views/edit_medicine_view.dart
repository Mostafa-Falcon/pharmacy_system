import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/medicines_bloc.dart';
import 'widgets/medicine_form_content.dart';

/// شاشة تعديل بيانات الدواء — كود نظيف وموحد باستعمال MedicineFormContent
class EditMedicineView extends StatelessWidget {
  final MedicineModel? medicine;
  const EditMedicineView({super.key, this.medicine});

  @override
  Widget build(BuildContext context) {
    if (medicine == null) {
      return HomeShell(
        title: AppStrings.editMedicine,
        child: Center(
          child: ReusableText(
            AppStrings.medicineNotFound,
            style: AppTextStyles.body(context),
          ),
        ),
      );
    }
    return BlocProvider(
      create: (_) => MedicinesBloc(),
      child: MedicineFormContent(
        initialMedicine: medicine,
        isEditMode: true,
      ),
    );
  }
}

