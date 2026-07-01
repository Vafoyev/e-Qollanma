import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/prefs_storage.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  static const _pages = [
    _IntroPage(
      title: "O'quv dasturlari",
      desc: "Chizmachilik bo'yicha barcha o'quv dasturlari bir joyda jamlangan.",
      icon: Iconsax.book_1,
      color: Color(0xFF6366F1),
    ),
    _IntroPage(
      title: "Loyihaning maqsadi",
      desc: "Talabalar uchun chizmachilik fanini raqamli va innovatsion usulda o'rganish imkonini yaratish.",
      icon: Iconsax.lamp_charge,
      color: Color(0xFF10B981),
    ),
    _IntroPage(
      title: "Bilimingizni sinang",
      desc: "Har bir mavzu bo'yicha maxsus testlar va AI yordamchisi orqali o'z bilimlaringizni oshiring.",
      icon: Iconsax.status_up,
      color: Color(0xFFF59E0B),
    ),
  ];

  Future<void> _finish() async {
    await PrefsStorage.setOnboardDone();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: _pages[_currentPage].color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDots(),
                      TextButton(
                        onPressed: _finish,
                        child: Text(
                          'O\'tkazib yuborish',
                          style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (context, i) => _IntroPageView(page: _pages[i], isDark: isDark),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageCtrl.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                          } else {
                            _finish();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          backgroundColor: _pages[_currentPage].color,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_currentPage < _pages.length - 1 ? "Keyingisi" : "Boshlash"),
                            const Gap(10),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                          ],
                        ),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SmallActionButton(
                            icon: Iconsax.info_circle,
                            label: "Loyiha haqida",
                            onTap: () => context.push(AppRoutes.about),
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      children: List.generate(_pages.length, (i) {
        final active = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 6),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? _pages[_currentPage].color : Colors.grey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _IntroPage {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;

  const _IntroPage({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
  });
}

class _IntroPageView extends StatelessWidget {
  final _IntroPage page;
  final bool isDark;

  const _IntroPageView({required this.page, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 80, color: page.color),
          ),
          const Gap(48),
          Text(
            page.title,
            style: AppTextStyles.h1.copyWith(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          Text(
            page.desc,
            style: AppTextStyles.body.copyWith(
              color: isDark ? Colors.white54 : Colors.black54,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _SmallActionButton({required this.icon, required this.label, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDark ? Colors.white70 : Colors.black54),
          const Gap(8),
          Text(label, style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
