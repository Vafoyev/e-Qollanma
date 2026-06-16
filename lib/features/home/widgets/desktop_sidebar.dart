import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class DesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isDark;

  const DesktopSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // ── Logo/Title ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.edit_2, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'E-Darslik.AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          // ── Menu Items ─────────────────────────────────────────────
          _SidebarItem(
            icon: Iconsax.home,
            label: 'Asosiy',
            isActive: selectedIndex == 0,
            onTap: () => onItemSelected(0),
            isDark: isDark,
          ),
          _SidebarItem(
            icon: Iconsax.play_circle,
            label: 'Videolar',
            isActive: selectedIndex == 1,
            onTap: () => onItemSelected(1),
            isDark: isDark,
          ),
          _SidebarItem(
            icon: Iconsax.book_1,
            label: 'Kutubxona',
            isActive: selectedIndex == 2,
            onTap: () => onItemSelected(2),
            isDark: isDark,
          ),
          _SidebarItem(
            icon: Iconsax.task_square,
            label: 'Testlar',
            isActive: selectedIndex == 3,
            onTap: () => onItemSelected(3),
            isDark: isDark,
          ),
          _SidebarItem(
            icon: Iconsax.profile_circle,
            label: 'Profil',
            isActive: selectedIndex == 4,
            onTap: () => onItemSelected(4),
            isDark: isDark,
          ),
          
          const Spacer(),
          
          // ── Footer / Logout ────────────────────────────────────────
          _SidebarItem(
            icon: Iconsax.info_circle,
            label: 'Dastur haqida',
            isActive: false,
            onTap: () {
               // Add navigation if needed
            },
            isDark: isDark,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final idleColor = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive 
              ? activeColor.withValues(alpha: 0.1)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : idleColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? activeColor : idleColor,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
