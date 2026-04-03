import 'package:e_qollanma/core/constants/app_colors.dart';
import 'package:e_qollanma/core/constants/app_text_styles.dart';
import 'package:e_qollanma/data/models/library_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';


class BookCard extends StatelessWidget {
  final LibraryModel book;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Muqova ────────────────────────────────────────────────────
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
              child: book.coverUrl != null
                  ? CachedNetworkImage(
                imageUrl: book.coverUrl!,
                width:    double.infinity,
                height:   160,
                fit:      BoxFit.cover,
                placeholder: (_, __) => _placeholder(isDark),
                errorWidget: (_, __, ___) => _placeholder(isDark),
              )
                  : _placeholder(isDark),
            ),

            // ── Ma'lumot ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: AppTextStyles.h4.copyWith(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Text(
                    book.author,
                    style: AppTextStyles.small.copyWith(
                      color: isDark
                          ? AppColors.darkTextSub
                          : AppColors.lightTextSub,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  // Til badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      book.languageLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      height: 160,
      width: double.infinity,
      color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
      child: Icon(
        Iconsax.book,
        size: 40,
        color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
      ),
    );
  }
}