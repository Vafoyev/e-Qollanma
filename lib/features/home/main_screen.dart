import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../providers/theme_provider.dart';
import '../videos/videos_screen.dart';
import '../library/library_screen.dart';
import '../quiz/quiz_list_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';
import 'widgets/desktop_sidebar.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 900 || 
                              (defaultTargetPlatform == TargetPlatform.windows || 
                               defaultTargetPlatform == TargetPlatform.linux || 
                               defaultTargetPlatform == TargetPlatform.macOS);

        if (isDesktop) {
          return const _DesktopLayout(screens: _screens);
        }
        return const _MobileLayout(screens: _screens);
      },
    );
  }
}

class _DesktopLayout extends ConsumerWidget {
  final List<Widget> screens;
  const _DesktopLayout({required this.screens});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // ── Background Blobs ───────────────────────────────────────
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: isDark ? 0.05 : 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: const SizedBox(),
              ),
            ),
          ),
          
          Positioned(
            bottom: -100,
            left: 100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1ABC9C).withValues(alpha: isDark ? 0.03 : 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: const SizedBox(),
              ),
            ),
          ),

          Row(
            children: [
              DesktopSidebar(
                selectedIndex: currentIndex,
                isDark: isDark,
                onItemSelected: (index) => ref.read(navIndexProvider.notifier).state = index,
              ),
              Expanded(
                child: Column(
                  children: [
                    _DesktopTopBar(isDark: isDark),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 24, 24),
                        decoration: BoxDecoration(
                          color: isDark 
                              ? AppColors.darkSurface.withValues(alpha: 0.6) 
                              : Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: IndexedStack(
                              index: currentIndex,
                              children: screens,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesktopTopBar extends ConsumerWidget {
  final bool isDark;
  const _DesktopTopBar({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xush kelibsiz!',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Boshqaruv paneli',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Search
          Container(
            width: 350,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface2 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isDark ? Border.all(color: AppColors.darkBorder, width: 1) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Qidirish...',
                hintStyle: TextStyle(color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
                prefixIcon: Icon(Iconsax.search_normal, size: 20, color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Theme Toggle
          _TopBarAction(
            icon: isDark ? Iconsax.sun_1 : Iconsax.moon, 
            isDark: isDark,
            onTap: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          const SizedBox(width: 12),
          _TopBarAction(icon: Iconsax.notification, isDark: isDark),
          const SizedBox(width: 12),
          _TopBarAction(
            icon: Iconsax.magic_star, 
            isDark: isDark, 
            isPrimary: true,
            onTap: () => context.push(AppRoutes.aiChat),
          ),
        ],
      ),
    );
  }
}

class _TopBarAction extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final bool isPrimary;
  final VoidCallback? onTap;
  const _TopBarAction({required this.icon, required this.isDark, this.isPrimary = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : (isDark ? AppColors.darkSurface2 : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: (!isPrimary && isDark) ? Border.all(color: AppColors.darkBorder, width: 1) : null,
          boxShadow: [
            if(!isPrimary) BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon, 
          size: 22, 
          color: isPrimary ? Colors.white : (isDark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}

class _MobileLayout extends ConsumerWidget {
  final List<Widget> screens;
  const _MobileLayout({required this.screens});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = ref.watch(navIndexProvider);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: screens),
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
  const _UltraPremiumNavbar({required this.currentIndex, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
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
                    border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      _NavItem(icon: Iconsax.home, label: "Asosiy", isActive: currentIndex == 0, onTap: () => onTap(0), isDark: isDark),
                      _NavItem(icon: Iconsax.play_circle, label: "Video", isActive: currentIndex == 1, onTap: () => onTap(1), isDark: isDark),
                      const SizedBox(width: 60),
                      _NavItem(icon: Iconsax.book_1, label: "Kutubxona", isActive: currentIndex == 2, onTap: () => onTap(2), isDark: isDark),
                      _NavItem(icon: Iconsax.profile_circle, label: "Profil", isActive: currentIndex == 4, onTap: () => onTap(4), isDark: isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
  const _NavItem({required this.icon, required this.label, required this.isActive, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primary;
    final idleColor = isDark ? Colors.white70 : Colors.black45;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? activeColor : idleColor, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: isActive ? activeColor : idleColor, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _AiPulseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AiPulseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
        child: const Icon(Iconsax.magic_star, color: Colors.white, size: 26),
      ),
    );
  }
}
