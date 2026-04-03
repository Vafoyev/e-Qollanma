import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

// ── Loading ───────────────────────────────────────────────────────────────────
class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const Gap(16),
            Text(
              message!,
              style: AppTextStyles.body.copyWith(
                color: context.isDark
                    ? AppColors.darkTextSub
                    : AppColors.lightTextSub,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.wifi_square,
              size: 56,
              color: AppColors.error,
            ),
            const Gap(16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: isDark
                    ? AppColors.darkTextSub
                    : AppColors.lightTextSub,
              ),
            ),
            if (onRetry != null) ...[
              const Gap(24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('btn_retry'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Empty ─────────────────────────────────────────────────────────────────────
class EmptyWidget extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyWidget({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Iconsax.document,
            size: 56,
            color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
          ),
          const Gap(16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: isDark
                  ? AppColors.darkTextSub
                  : AppColors.lightTextSub,
            ),
          ),
        ],
      ),
    );
  }
}

// BuildContext extension — isDark
extension _ContextDark on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}