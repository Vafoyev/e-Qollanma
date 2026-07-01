import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchDGU(BuildContext context) async {
    try {
      final ByteData data = await rootBundle.load('assets/dgu.pdf');
      final List<int> bytes = data.buffer.asUint8List();
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/dgu_isobek.pdf');
      await tempFile.writeAsBytes(bytes, flush: true);
      final Uri url = Uri.file(tempFile.path);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Faylni ochib bo\'lmadi');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('assets/dgu.pdf fayli topilmadi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Premium Header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2ECC71), Color(0xFF1ABC9C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withValues(alpha: 0.1)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(40),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(Iconsax.user, size: 50, color: AppColors.primaryDark),
                        ),
                      ),
                      const Gap(16),
                      const Text(
                        "Isobek Vafoyev",
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      const Text(
                        "Full-Stack Developer & Mobile Expert",
                        style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Patent va Guvohnomalar", isDark),
                  const Gap(12),
                  _buildPatentCard(
                    title: "Dasturiy mahsulot guvohnomasi (DGU)",
                    number: "DGU 2024 0541",
                    date: "20.03.2024",
                    isDark: isDark,
                    onTap: () => _launchDGU(context),
                  ),
                  const Gap(12),
                  _buildPatentCard(
                    title: "Mualliflik huquqi patenti",
                    number: "PAT №7741258",
                    date: "15.02.2024",
                    isDark: isDark,
                    onTap: () => _launchDGU(context),
                  ),
                  const Gap(32),

                  _buildSectionTitle("Dasturchi haqida", isDark),
                  const Gap(12),
                  _buildBioCard(
                    "Isobek Vafoyev — texnologiyalar olamida katta tajribaga ega bo'lgan Full-Stack dasturchi. "
                    "U nafaqat mobil (iOS va Android), balki Web texnologiyalari, Dart va zamonaviy backend tizimlari "
                    "bo'yicha professional mahoratga ega. 'E-Darslik.AI' loyihasi uning murakkab tizimlarni "
                    "yuqori sifatda qura olish qobiliyatining isbotidir.",
                    isDark,
                  ),
                  const Gap(32),

                  _buildSectionTitle("Bog'lanish", isDark),
                  const Gap(12),
                  _buildContactTile(Iconsax.send_1, "Telegram", "@Isobek_Androiddev", () => _launch("https://t.me/Isobek_Androiddev"), isDark),
                  _buildContactTile(Iconsax.instagram, "Instagram", "isobeksaid", () => _launch("https://instagram.com/isobeksaid"), isDark),
                  
                  const Gap(40),
                  Center(
                    child: Column(
                      children: [
                        Text("E-Darslik.AI v1.0.0", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                        const Gap(4),
                        const Text("Made with ❤️ in Uzbekistan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Gap(100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(title, style: AppTextStyles.h3.copyWith(fontSize: 20, color: isDark ? Colors.white : Colors.black));
  }

  Widget _buildPatentCard({required String title, required String number, required String date, required bool isDark, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Iconsax.verify5, color: AppColors.primary, size: 24),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontSize: 14)),
                  const Gap(4),
                  Text(number, style: AppTextStyles.h4.copyWith(color: AppColors.primary, fontSize: 16)),
                  Text("Sana: $date", style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.lightIcon),
          ],
        ),
      ),
    );
  }

  Widget _buildBioCard(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Text(text, style: AppTextStyles.body.copyWith(height: 1.6, color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub)),
    );
  }

  Widget _buildContactTile(IconData icon, String label, String value, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const Gap(16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.caption), Text(value, style: AppTextStyles.bodyMedium)]),
            const Spacer(),
            const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.lightIcon),
          ],
        ),
      ),
    );
  }
}
