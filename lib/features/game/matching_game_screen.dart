import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Matching Game - Match drawing formats with their descriptions
class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  late List<_MatchItem> items;
  late List<_MatchItem> shuffledRight;
  int _matchedCount = 0;
  final int totalPairs = 5;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    items = [
      _MatchItem(id: 1, left: "A4 Format", icon: Iconsax.document),
      _MatchItem(id: 2, left: "1:2 Masshtab", icon: Iconsax.bezier),
      _MatchItem(id: 3, left: "GOST Chiziq", icon: Iconsax.minus),
      _MatchItem(id: 4, left: "Proyeksiya", icon: Iconsax.box),
      _MatchItem(id: 5, left: "Kesim", icon: Iconsax.slash),
    ];

    shuffledRight = List.from(items)..shuffle();
  }

  void _onMatch(int leftIndex, int rightIndex) {
    if (items[leftIndex].id == shuffledRight[rightIndex].id) {
      setState(() {
        items[leftIndex].matched = true;
        shuffledRight[rightIndex].matched = true;
        _matchedCount++;
      });

      if (_matchedCount == totalPairs) {
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Ajoyib!"),
        content: const Text("Siz barcha moslamalarni to'g'ri tanladingiz!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _matchedCount = 0;
                _initializeGame();
              });
            },
            child: const Text("Qayta o'ynash"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text("Mosla o'yini"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _matchedCount / totalPairs,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const Gap(20),
            Expanded(
              child: Row(
                children: [
                  // Left side
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _DraggableItem(
                          item: item,
                          onDragStart: () {},
                        );
                      },
                    ),
                  ),
                  const Gap(20),
                  // Right side
                  Expanded(
                    child: ListView.separated(
                      itemCount: shuffledRight.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final item = shuffledRight[index];
                        return DragTarget<_MatchItem>(
                          onAccept: (draggedItem) {
                            _onMatch(
                              items.indexOf(draggedItem),
                              index,
                            );
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: item.matched
                                    ? AppColors.primary.withValues(alpha: 0.2)
                                    : (isDark ? AppColors.darkSurface : Colors.white),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: item.matched
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(item.icon, color: AppColors.primary),
                                  const Gap(8),
                                  Expanded(
                                    child: Text(
                                      item.left,
                                      style: AppTextStyles.body,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (item.matched)
                                    const Icon(Iconsax.tick_circle, color: AppColors.success),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
}

class _MatchItem {
  final int id;
  final String left;
  final IconData icon;
  bool matched;

  _MatchItem({
    required this.id,
    required this.left,
    required this.icon,
    this.matched = false,
  });
}

class _DraggableItem extends StatelessWidget {
  final _MatchItem item;
  final VoidCallback onDragStart;

  const _DraggableItem({
    required this.item,
    required this.onDragStart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Draggable<_MatchItem>(
      data: item,
      onDragStarted: onDragStart,
      feedback: Material(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            item.left,
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildItemWidget(isDark),
      ),
      child: _buildItemWidget(isDark),
    );
  }

  Widget _buildItemWidget(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: item.matched
            ? AppColors.primary.withValues(alpha: 0.2)
            : (isDark ? AppColors.darkSurface : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.matched
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary),
          const Gap(8),
          Expanded(
            child: Text(
              item.left,
              style: AppTextStyles.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.matched)
            const Icon(Iconsax.tick_circle, color: AppColors.success),
        ],
      ),
    );
  }
}
