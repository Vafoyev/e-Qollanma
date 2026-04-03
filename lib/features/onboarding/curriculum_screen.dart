import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';

class CurriculumScreen extends StatelessWidget {
  const CurriculumScreen({super.key});

  static const _items = [
    _CurriculumItem(
      icon:  Iconsax.book,
      title: 'Geometrik chizmachilik',
      desc:  'Nuqta, to\'g\'ri chiziq, burchak, ko\'pburchaklar',
      count: '12 ta mavzu',
    ),
    _CurriculumItem(
      icon: Iconsax.box,
      title: 'Proyeksion chizmachilik',
      desc:  'Ortogonal proyeksiya, kesimlar, qirqimlar',
      count: '18 ta mavzu',
    ),
    _CurriculumItem(
      icon:  Iconsax.ruler,
      title: 'Muhandislik grafika',
      desc:  'Standartlar, o\'lchamlar, texnik hujjatlar',
      count: '15 ta mavzu',
    ),
    _CurriculumItem(
      icon:  Iconsax.cpu,
      title: 'Kompyuter grafika',
      desc:  'AutoCAD va boshqa dasturlarda ishlash',
      count: '10 ta mavzu',
    ),
    _CurriculumItem(
      icon:  Iconsax.task_square,
      title: 'Mashq va testlar',
      desc:  'Har mavzu bo\'yicha amaliy topshiriqlar',
      count: '55 ta test',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('intro_title_1'.tr()),
        backgroundColor:
        isDark ? AppColors.darkSurface : AppColors.lightSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppRoutes.intro),
        ),
      ),
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chizmachilik kursi',
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
                const Gap(6),
                Text(
                  '5 ta bo\'lim • 55+ mavzu • 55 ta test',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),

          // ── Ro'yxat ───────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _items.length,
              itemBuilder: (_, i) => _CurriculumCard(
                item:   _items[i],
                index:  i + 1,
                isDark: isDark,
              ),
            ),
          ),

          // ── Dasturga kirish tugmasi ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text('intro_title_3'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurriculumItem {
  final IconData icon;
  final String title;
  final String desc;
  final String count;
  const _CurriculumItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.count,
  });
}

class _CurriculumCard extends StatelessWidget {
  final _CurriculumItem item;
  final int index;
  final bool isDark;
  const _CurriculumCard({
    required this.item,
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: AppColors.primaryDark, size: 22),
          ),

          const Gap(14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.h4.copyWith(
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),
                const Gap(2),
                Text(
                  item.desc,
                  style: AppTextStyles.small.copyWith(
                    color: isDark
                        ? AppColors.darkTextSub
                        : AppColors.lightTextSub,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const Gap(10),

          // Count badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.count,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}