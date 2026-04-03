import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/library_model.dart';
import '../../providers/library_provider.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchCtr = TextEditingController();

  @override
  void dispose() {
    _searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final filter      = ref.watch(libraryFilterProvider);
    final booksAsync  = ref.watch(bookListProvider);

    const langs = ['', 'uz', 'ru', 'en'];
    const langLabels = ['Barchasi', "O'zbek", 'Русский', 'English'];

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('library_title'.tr()),
        backgroundColor:
        isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: Column(
        children: [
          // ── Search ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextFormField(
              controller: _searchCtr,
              onChanged: (v) => ref
                  .read(libraryFilterProvider.notifier)
                  .update((s) => s.copyWith(search: v)),
              decoration: InputDecoration(
                hintText:   'library_search'.tr(),
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: _searchCtr.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchCtr.clear();
                    ref
                        .read(libraryFilterProvider.notifier)
                        .update((s) => s.copyWith(search: ''));
                  },
                )
                    : null,
              ),
            ),
          ),

          // ── Til filterlari ───────────────────────────────────────────────
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              itemCount: langs.length,
              itemBuilder: (_, i) {
                final selected = filter.lang == langs[i];
                return GestureDetector(
                  onTap: () => ref
                      .read(libraryFilterProvider.notifier)
                      .update((s) => s.copyWith(lang: langs[i])),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : (isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                      ),
                    ),
                    child: Text(
                      langLabels[i],
                      style: AppTextStyles.small.copyWith(
                        color: selected
                            ? Colors.white
                            : (isDark
                            ? AppColors.darkTextSub
                            : AppColors.lightTextSub),
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Kitoblar ─────────────────────────────────────────────────────
          Expanded(
            child: booksAsync.when(
              loading: () => _buildShimmer(isDark),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.wifi_square,
                        size: 48, color: AppColors.error),
                    const Gap(12),
                    Text(e.toString(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.small),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.refresh(bookListProvider),
                      child: Text('btn_retry'.tr()),
                    ),
                  ],
                ),
              ),
              data: (books) {
                if (books.isEmpty) {
                  return Center(
                    child: Text('library_empty'.tr(),
                        style: AppTextStyles.body.copyWith(
                          color: isDark
                              ? AppColors.darkTextSub
                              : AppColors.lightTextSub,
                        )),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () =>
                      ref.refresh(bookListProvider.future),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: books.length,
                    itemBuilder: (_, i) => _BookCard(
                      book: books[i],
                      isDark: isDark,
                      onTap: () =>
                          context.push('/book/${books[i].id}'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.62,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: isDark
            ? AppColors.darkSurface2
            : AppColors.lightSurface2,
        highlightColor:
        isDark ? AppColors.darkBorder : AppColors.lightBorder,
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final LibraryModel book;
  final bool isDark;
  final VoidCallback onTap;

  const _BookCard({
    required this.book,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
          isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Muqova ───────────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14)),
              child: book.coverUrl != null
                  ? CachedNetworkImage(
                imageUrl: book.coverUrl!,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    _coverPlaceholder(isDark),
              )
                  : _coverPlaceholder(isDark),
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

  Widget _coverPlaceholder(bool isDark) {
    return Container(
      height: 160,
      width: double.infinity,
      color:
      isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
      child: Icon(
        Iconsax.book,
        size: 40,
        color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
      ),
    );
  }
}