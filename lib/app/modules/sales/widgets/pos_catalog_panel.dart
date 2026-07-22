import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../bloc/catalog_cubit.dart';
import '../bloc/pos_bloc.dart';

class PosCatalogPanel extends StatelessWidget {
  const PosCatalogPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        final items = state.filteredMedicines;
        final scheme = Theme.of(context).colorScheme;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: TextField(
                onChanged: (q) => context.read<CatalogCubit>().updateSearch(q),
                decoration: InputDecoration(
                  hintText: AppStrings.searchItemsHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text(AppStrings.noItemsFound, style: TextStyle(color: scheme.onSurfaceVariant)))
                  : GridView.builder(
                      padding: EdgeInsets.all(8.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        return InkWell(
                          onTap: () => context.read<PosBloc>().add(PosAddMedicine(item)),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4.h),
                                Text('${item.sellPrice} ${AppStrings.currency}', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
