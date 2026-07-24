import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/constants/strings/auth_strings.dart';

class AuthCallbackView extends StatefulWidget {
  const AuthCallbackView({super.key});

  @override
  State<AuthCallbackView> createState() => _AuthCallbackViewState();
}

class _AuthCallbackViewState extends State<AuthCallbackView> {
  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    try {
      // ─── Supabase Redirect Handling ───
      final uri = Uri.base;
      if (uri.hasQuery || uri.fragment.isNotEmpty) {
        await Supabase.instance.client.auth.getSessionFromUrl(uri);
      }
      
      if (!mounted) return;
      context.go(Routes.INITIAL);
    } catch (e) {
      safeDebugPrint('AuthCallbackView Redirect Error: $e');
      if (!mounted) return;
      context.go(Routes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AuthStrings.emailConfirmationCheck),
          ],
        ),
      ),
    );
  }
}
