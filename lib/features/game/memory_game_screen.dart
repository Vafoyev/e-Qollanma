import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Memory Game - Match pairs of drawing tools
class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<IconData> _icons;
  late List<IconData> _shuffledIcons;
  late List<bool> _visible;
  late List<bool> _matched;
  int? _prevIndex;
  bool _busy = false;
  int _score = 0;
  int _tries = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _icons = [
        Iconsax.ruler, Iconsax.ruler,
        Iconsax.pen_tool, Iconsax.pen_tool,
        Iconsax.brush, Iconsax.brush,
        Iconsax.edit, Iconsax.edit,
        Iconsax.shapes, Iconsax.shapes,
        Iconsax.scissor, Iconsax.scissor,
      ];
      _shuffledIcons = List.from(_icons)..shuffle();
      _visible = List.filled(12, false);
      _matched = List.filled(12, false);
      _prevIndex = null;
      _score = 0;
      _tries = 0;
      _busy = false;
    });
  }

  void _onTap(int index) {
    if (_busy || _matched[index] || _visible[index]) return;

    setState(() {
      _visible[index] = true;
    });

    if (_prevIndex == null) {
      _prevIndex = index;
    } else {
      _tries++;
      if (_shuffledIcons[_prevIndex!] == _shuffledIcons[index]) {
        setState(() {
          _matched[_prevIndex!] = true;
          _matched[index] = true;
          _score++;
          _prevIndex = null;
        });
        if (_score == 6) {
          _showWinDialog();
        }
      } else {
        _busy = true;
        Timer(const Duration(milliseconds: 800), () {
          setState(() {
            _visible[_prevIndex!] = false;
            _visible[index] = false;
            _prevIndex = null;
            _busy = false;
          });
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("G'alaba!"),
        content: Text("Tabriklaymiz! Siz $_tries ta urinishda barcha juftliklarni topdingiz."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
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
        title: const Text("Xotira o'yini"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatTile(label: "Ball", value: "$_score/6", color: AppColors.primary),
                _StatTile(label: "Urinishlar", value: "$_tries", color: Colors.orange),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: 12,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => _onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _matched[i] 
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : (_visible[i] ? AppColors.primary : (isDark ? AppColors.darkSurface : Colors.white)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _visible[i] ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: _visible[i] || _matched[i]
                        ? Icon(_shuffledIcons[i], color: _matched[i] ? AppColors.primary : Colors.white, size: 32)
                        : Icon(Iconsax.mask, color: isDark ? Colors.white24 : Colors.black12, size: 32),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              "Chizmachilik asboblarining juftini toping!",
              style: AppTextStyles.body.copyWith(color: isDark ? Colors.white54 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatTile({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.h2.copyWith(color: color)),
      ],
    );
  }
}
