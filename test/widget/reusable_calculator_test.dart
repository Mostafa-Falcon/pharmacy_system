import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/index.dart';

void main() {
  group('ReusableCalculator', () {
    testWidgets('shows calculator dialog', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(800, 600),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => ReusableCalculator.show(context),
                  child: const Text('Open Calculator'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Calculator'));
      await tester.pumpAndSettle();

      expect(find.text('Ø¢Ù„Ø© Ø­Ø§Ø³Ø¨Ø© Ø§Ø­ØªØ±Ø§ÙÙŠØ©'), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}

