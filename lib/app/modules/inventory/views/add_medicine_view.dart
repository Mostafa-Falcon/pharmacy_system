import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/medicines_bloc.dart';
import 'widgets/medicine_form_content.dart';

/// شاشة إضافة دواء جديد — كود نظيف وموحد باستعمال MedicineFormContent
class AddMedicineView extends StatelessWidget {
  const AddMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicinesBloc(),
      child: const MedicineFormContent(isEditMode: false),
    );
  }
}
