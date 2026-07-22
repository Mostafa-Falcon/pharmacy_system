import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../routes/app_routes.dart';

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
      await Supabase.instance.client.auth.getSessionFromUrl(Uri.base);
      if (!mounted) return;
      context.go(Routes.HOME);
    } catch (e) {
      if (!mounted) return;
      context.go(Routes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingIndicator(
        message: AppStrings.emailConfirmationCheck,
      ),
    );
  }
}
