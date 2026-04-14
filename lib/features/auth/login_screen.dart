import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _phoneCtr   = TextEditingController();
  final _passCtr    = TextEditingController();
  bool _obscure     = true;

  @override
  void dispose() {
    _phoneCtr.dispose();
    _passCtr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref.read(authProvider.notifier).login(
      phone:    _phoneCtr.text.trim(),
      password: _passCtr.text.trim(),
    );

    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.home);
    } else {
      final err = ref.read(authProvider).error ?? 'error_unknown'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _skip() async {
    await ref.read(authProvider.notifier).devLogin();
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      body: Stack(
        children: [
          // Background Decor
          Positioned(
            top: -150,
            right: -150,
            child: CircleAvatar(radius: 200, backgroundColor: AppColors.primary.withValues(alpha: 0.05)),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: _skip,
                        child: const Text("O'tkazib yuborish"),
                      ),
                    ),
                    const Gap(32),
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Iconsax.lock, color: AppColors.primary, size: 32),
                    ),
                    const Gap(32),
                    Text(
                      'login_title'.tr(),
                      style: AppTextStyles.h1.copyWith(fontSize: 32),
                    ),
                    const Gap(8),
                    Text(
                      'login_subtitle'.tr(),
                      style: AppTextStyles.body.copyWith(color: isDark ? Colors.white54 : Colors.black54),
                    ),
                    const Gap(48),

                    // Inputs
                    _buildLabel('login_phone'.tr()),
                    const Gap(10),
                    TextFormField(
                      controller: _phoneCtr,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'login_phone_hint'.tr(),
                        prefixIcon: const Icon(Iconsax.call, size: 20),
                        prefixText: '+',
                      ),
                      validator: AppValidators.phone,
                    ),

                    const Gap(24),

                    _buildLabel('login_password'.tr()),
                    const Gap(10),
                    TextFormField(
                      controller: _passCtr,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: 'login_password_hint'.tr(),
                        prefixIcon: const Icon(Iconsax.key, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Iconsax.eye_slash : Iconsax.eye, size: 20),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: AppValidators.password,
                    ),

                    const Gap(48),

                    // Submit
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('btn_login'.tr()),
                    ),

                    const Gap(32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('login_no_account'.tr(), style: AppTextStyles.small),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.register),
                          child: Text('login_register_link'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }
}
