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

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final itemsAsync  = ref.watch(filteredLibraryListProvider);
    final allItems    = ref.watch(libraryListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'library_title'.tr(),
                  style: AppTextStyles.h2.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _SearchBar(isDark: isDark, ref: ref),
              ),
            ),
          ),

          // ── Categories ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: allItems.when(
              data: (items) {
                final categories = ['Barchasi', ...items.map((i) => i.category).toSet()];
                return _CategorySelector(categories: categories);
              },
              loading: () => const SizedBox(height: 60),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // ── Items Grid/List ──────────────────────────────────────────
          itemsAsync.when(
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, __) => _buildShimmer(isDark),
                  childCount: 4,
                ),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: _buildError(e.toString(), isDark),
            ),
            data: (items) {
              if (items.isEmpty) {
                return SliverFillRemaining(
                  child: _buildEmpty(isDark),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _LibraryCard(
                      item: items[i],
                      isDark: isDark,
                      onTap: () => context.push('/book/${items[i].id}'),
                    ),
                    childCount: items.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
      highlightColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.document_1, size: 64, color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
          const Gap(16),
          Text('library_empty'.tr(), style: AppTextStyles.body.copyWith(color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub)),
        ],
      ),
    );
  }

  Widget _buildError(String msg, bool isDark) {
    return Center(
      child: Text(msg, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;
  const _SearchBar({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (v) => ref.read(librarySearchQueryProvider.notifier).state = v,
      decoration: InputDecoration(
        hintText: 'library_search'.tr(),
        prefixIcon: const Icon(Iconsax.search_normal),
        fillColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CategorySelector extends ConsumerWidget {
  final List<String> categories;
  const _CategorySelector({required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedLibraryCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isActive = selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isActive,
              onSelected: (_) => ref.read(selectedLibraryCategoryProvider.notifier).state = cat,
              selectedColor: AppColors.primary,
              labelStyle: AppTextStyles.small.copyWith(
                color: isActive ? Colors.white : (isDark ? AppColors.darkTextSub : AppColors.lightTextSub),
              ),
              backgroundColor: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final LibraryModel item;
  final bool isDark;
  final VoidCallback onTap;

  const _LibraryCard({required this.item, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cover ──────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: item.coverUrl ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primaryLight,
                        child: const Icon(Iconsax.book, color: AppColors.primary, size: 40),
                      ),
                    ),
                    // Type Badge
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.typeLabel,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(10),
          // ── Info ───────────────────────────────────────────────────
          Text(
            item.title,
            style: AppTextStyles.h4.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(2),
          Text(
            item.author,
            style: AppTextStyles.small.copyWith(
              color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Row(
            children: [
              Icon(Iconsax.folder_2, size: 14, color: AppColors.primary.withValues(alpha: 0.7)),
              const Gap(4),
              Text(
                item.size,
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
