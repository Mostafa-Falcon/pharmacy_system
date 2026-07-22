import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/pos_bloc.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

class PosCartPanel extends StatelessWidget {
  const PosCartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final lines = state.cart;
        final scheme = Theme.of(context).colorScheme;

        if (lines.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(24.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 48.sp, color: scheme.onSurfaceVariant),
                  SizedBox(height: 12.h),
                  ReusableText(AppStrings.posCartEmpty, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14.sp)),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lines.length,
          separatorBuilder: (context, index) => Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.2)),
          itemBuilder: (context, i) {
            final line = lines[i];
            return ListTile(
              dense: true,
              title: Text(line.medicine.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${line.quantity} × ${line.unitPrice} ${AppStrings.currency}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${line.lineTotal} ${AppStrings.currency}', style: TextStyle(fontWeight: FontWeight.bold, color: scheme.primary)),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                    onPressed: () => context.read<PosBloc>().add(PosRemoveLine(line.medicine.id)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
