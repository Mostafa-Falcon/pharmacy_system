import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/pos_bloc.dart';
import 'package:pharmacy_system/app/modules/sales/widgets/pos_catalog_panel.dart';
import '../pos_nav_drawer.dart';
import 'app_bar.dart';
import 'cart_tab.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PosBloc>();
    return Scaffold(
      backgroundColor: AppColors.surfaceTintLightAlt,
      drawer: const PosNavDrawer(),
      appBar: MobileAppBar(controller: bloc),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            color: Colors.white,
            child: ReusableInput(
              controller: TextEditingController(),
              focusNode: FocusNode(),
              hint: AppStrings.searchHint,
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18.sp,
                color: Colors.grey,
              ),
              onClear: () {},
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (v) {
                if (v.trim().isNotEmpty) bloc.add(PosAddByBarcode(v.trim()));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PosBloc, PosState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const Expanded(child: PosCatalogPanel()),
                    Expanded(child: MobileCartTab(controller: bloc)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 56.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ReusableNavTab(icon: Icons.store_rounded, label: AppStrings.itemsLabelSales, isSelected: true, onTap: () {}),
              ReusableNavTab(icon: Icons.shopping_cart_rounded, label: AppStrings.cartTitle, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
