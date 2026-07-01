import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../features/game/memory_game_screen.dart';
import '../../features/game/matching_game_screen.dart';
import '../../features/game/game_quiz_screen.dart';
import '../../features/game/drawing_game_screen.dart';

enum GameType { memory, matching, quiz, drawing }

class GameSelectorScreen extends StatelessWidget {
  const GameSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final games = [
      _GameInfo(
        type: GameType.memory,
        title: "Xotira o'yini",
        description: "Chizmachilik asboblarinin juftini toping",
        icon: Iconsax.mask,
        color: const Color(0xFF6366F1),
      ),
      _GameInfo(
        type: GameType.matching,
        title: "Mosla",
        description: "Chiziqlar va formatlarni to'g'ri mosla",
        icon: Iconsax.link_square,
        color: const Color(0xFF8B5CF6),
      ),
      _GameInfo(
        type: GameType.quiz,
        title: "Test",
        description: "Chizmachilik mavzulari bo'yicha savollar",
        icon: Iconsax.book,
        color: const Color(0xFF10B981),
      ),
      _GameInfo(
        type: GameType.drawing,
        title: "Chizmali",
        description: "To'g'ri proyeksiyalarni toping",
        icon: Iconsax.brush_2,
        color: const Color(0xFFF59E0B),
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text("O'yinlar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final crossAxisCount = isTablet ? 3 : 2;
          
          return Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.9,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return _GameCard(game: game);
              },
            ),
          );
        },
      ),
    );
  }
}

class _GameInfo {
  final GameType type;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _GameInfo({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _GameCard extends StatelessWidget {
  final _GameInfo game;

  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchGame(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              game.color.withValues(alpha: 0.8),
              game.color.withValues(alpha: 0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: game.color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.1,
                child: Icon(game.icon, size: 120),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(game.icon, color: Colors.white, size: 48),
                  Column(
                    children: [
                      Text(
                        game.title,
                        style: AppTextStyles.h3.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Text(
                        game.description,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Icon(
                    Iconsax.arrow_right,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchGame(BuildContext context) {
    Widget gameScreen;
    switch (game.type) {
      case GameType.memory:
        gameScreen = const MemoryGameScreen();
        break;
      case GameType.matching:
        gameScreen = const MatchingGameScreen();
        break;
      case GameType.quiz:
        gameScreen = const GameQuizScreen();
        break;
      case GameType.drawing:
        gameScreen = const DrawingGameScreen();
        break;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => gameScreen),
    );
  }
}
