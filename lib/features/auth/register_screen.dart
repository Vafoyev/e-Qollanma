import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtr   = TextEditingController();
  final _phoneCtr  = TextEditingController();
  final _passCtr   = TextEditingController();
  bool _obscure    = true;

  @override
  void dispose() {
    _nameCtr.dispose();
    _phoneCtr.dispose();
    _passCtr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref.read(authProvider.notifier).register(
      fullName: _nameCtr.text.trim(),
      phone:    _phoneCtr.text.trim(),
      password: _passCtr.text.trim(),
    );

    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.home);
    } else {
      final err = ref.read(authProvider).error ?? 'error_unknown'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(56),

                // ── Logo / Icon ──────────────────────────────────────────
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_add_outlined,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),

                const Gap(24),

                // ── Sarlavha ─────────────────────────────────────────────
                Text(
                  'register_title'.tr(),
                  style: AppTextStyles.h1.copyWith(
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),

                const Gap(8),

                Text(
                  'register_subtitle'.tr(),
                  style: AppTextStyles.body.copyWith(
                    color: isDark
                        ? AppColors.darkTextSub
                        : AppColors.lightTextSub,
                  ),
                ),

                const Gap(40),

                // ── To'liq ism ────────────────────────────────────────────
                Text('register_fullname'.tr(), style: AppTextStyles.label),
                const Gap(8),
                TextFormField(
                  controller:     _nameCtr,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText:   'register_fullname_hint'.tr(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: AppValidators.fullName,
                ),

                const Gap(20),

                // ── Telefon ───────────────────────────────────────────────
                Text('register_phone'.tr(), style: AppTextStyles.label),
                const Gap(8),
                TextFormField(
                  controller:    _phoneCtr,
                  keyboardType:  TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText:   'login_phone_hint'.tr(),
                    prefixIcon: const Icon(Icons.phone_outlined),
                    prefixText: '+',
                  ),
                  validator: AppValidators.phone,
                ),

                const Gap(20),

                // ── Parol ─────────────────────────────────────────────────
                Text('register_password'.tr(), style: AppTextStyles.label),
                const Gap(8),
                TextFormField(
                  controller:     _passCtr,
                  obscureText:    _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText:   'login_password_hint'.tr(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: AppValidators.password,
                ),

                const Gap(32),

                // ── Register tugmasi ──────────────────────────────────────
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : Text('btn_register'.tr()),
                ),

                const Gap(24),

                // ── Login havola ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'register_has_account'.tr(),
                      style: AppTextStyles.body.copyWith(
                        color: isDark
                            ? AppColors.darkTextSub
                            : AppColors.lightTextSub,
                      ),
                    ),
                    const Gap(4),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: Text(
                        'register_login_link'.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}