import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../videos/videos_screen.dart';
import '../library/library_screen.dart';
import '../quiz/quiz_list_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const _screens = [
    HomeScreen(),
    VideosScreen(),
    LibraryScreen(),
    QuizListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = ref.watch(navIndexProvider);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: _UltraPremiumNavbar(
        currentIndex: currentIndex,
        isDark: isDark,
        onTap: (index) => ref.read(navIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _UltraPremiumNavbar extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  final Function(int) onTap;

  const _UltraPremiumNavbar({
    required this.currentIndex,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Balanced height for floating icons
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ── Main Glass Background ───────────────────────────────────
          Container(
            height: 65,
            margin: const EdgeInsets.only(bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: (isDark ? const Color(0xFF1E293B) : Colors.white).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      _NavItem(icon: Iconsax.home, label: "Asosiy", isActive: currentIndex == 0, onTap: () => onTap(0), isDark: isDark),
                      _NavItem(icon: Iconsax.play_circle, label: "Video", isActive: currentIndex == 1, onTap: () => onTap(1), isDark: isDark),
                      const SizedBox(width: 60), // Larger space for center button
                      _NavItem(icon: Iconsax.book_1, label: "Kutubxona", isActive: currentIndex == 2, onTap: () => onTap(2), isDark: isDark),
                      _NavItem(icon: Iconsax.profile_circle, label: "Profil", isActive: currentIndex == 4, onTap: () => onTap(4), isDark: isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // ── Floating AI Button ──────────────────────────────────────
          Positioned(
            bottom: 25,
            child: _AiPulseButton(onTap: () => context.push(AppRoutes.aiChat)),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // High contrast colors
    final activeColor = AppColors.primary;
    final idleColor = isDark ? Colors.white70 : Colors.black45;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : idleColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? activeColor : idleColor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

class _AiPulseButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AiPulseButton({required this.onTap});

  @override
  State<_AiPulseButton> createState() => _AiPulseButtonState();
}

class _AiPulseButtonState extends State<_AiPulseButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _jumpAnimation;

  @override
  void initState() {
    super.initState();
    // Glow/Pulse animation
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    
    // Wave/Ripple animation
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

    // Jump/Bounce animation for the Star
    _jumpAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.bounceIn)), weight: 50),
    ]).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Subtle Waves ─────────────────────────────────────────────
          ...List.generate(2, (index) {
            return AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                double progress = (_waveController.value + (index / 2)) % 1.0;
                return Container(
                  width: 54 + (progress * 35),
                  height: 54 + (progress * 35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: (1.0 - progress) * 0.3),
                      width: 1.2,
                    ),
                  ),
                );
              },
            );
          }),
          
          // ── Main Button with Jumping Star ────────────────────────────
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4 + (_pulseController.value * 0.2)),
                      blurRadius: 10 + (_pulseController.value * 10),
                      spreadRadius: _pulseController.value * 2,
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: _jumpAnimation.value,
                  child: const Icon(Iconsax.magic_star, color: Colors.white, size: 26),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
