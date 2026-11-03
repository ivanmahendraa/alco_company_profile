import 'package:flutter/material.dart';

import '../data/demo_credentials.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/alco_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color _emailFieldColor = Color(0xFFE8F0FE);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hasCredentialsError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearCredentialsError(String _) {
    if (_hasCredentialsError) {
      setState(() {
        _hasCredentialsError = false;
      });
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final credentialsAreValid = DemoCredentials.matches(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!credentialsAreValid) {
      setState(() {
        _hasCredentialsError = true;
      });
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight - 32,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AlcoLogo(width: 184),
                        const SizedBox(height: 24),
                        _buildLoginCard(context),
                        const SizedBox(height: 20),
                        const Text(
                          '© 2026 PT. Alcotraindo Batam. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: AppColors.primaryGreen, fontSize: 26),
            ),
            const SizedBox(height: 4),
            const Text(
              'Masuk ke akun Anda',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Email',
              hintText: 'Masukkan email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              fillColor: _emailFieldColor,
              onChanged: _clearCredentialsError,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Password',
              hintText: 'Masukkan password',
              controller: _passwordController,
              isPassword: true,
              textInputAction: TextInputAction.done,
              onChanged: _clearCredentialsError,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password wajib diisi.';
                }
                return null;
              },
            ),
            if (_hasCredentialsError) ...[
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: const Text(
                  'Email atau password tidak sesuai.',
                  key: Key('login-credentials-error'),
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            PrimaryButton(
              key: const Key('login-submit'),
              text: 'Masuk',
              onPressed: _submit,
              height: 52,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}
