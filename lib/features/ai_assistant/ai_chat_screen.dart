import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: "Salom! Men sizning chizmachilik bo'yicha AI yordamchingizman. Savollaringiz bormi?",
      isAi: true,
    ),
  ];
  bool _isTyping = false;

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isAi: false));
      _messageController.clear();
      _isTyping = true;
    });

    // Simulyatsiya AI javobi
    await Future.delayed(const Duration(seconds: 1));

    String aiResponse = _generateMockResponse(text);

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(text: aiResponse, isAi: true));
    });
  }

  String _generateMockResponse(String userText) {
    userText = userText.toLowerCase();
    if (userText.contains('chiziq')) {
      return "Chizmachilikda asosiy chiziqlar: tutash yo'g'on (asosiy), tutash ingichka, shtrix va shtrix-punktir chiziqlardir. Har birining o'z o'rni bor.";
    } else if (userText.contains('format')) {
      return "Asosiy format o'lchamlari: A0 (841x1189), A1 (594x841), A2 (420x594), A3 (297x420) va A4 (210x297) mm hisoblanadi.";
    } else if (userText.contains('masshtab')) {
      return "Masshtablar uch xil bo'ladi: haqiqiy o'lcham (1:1), kichraytirish (1:2, 1:5...) va kattalashtirish (2:1, 5:1...).";
    }
    return "Tushunmadim, lekin chizmachilik haqida so'rasangiz, batafsil javob berishga harakat qilaman!";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
            ),
            const Gap(10),
            const Text("AI Yordamchi"),
          ],
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _ChatBubble(message: _messages[i], isDark: isDark),
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("AI javob yozmoqda...", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ),
            ),
          _buildInput(isDark),
        ],
      ),
    );
  }

  Widget _buildInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Savol yo'llang...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const Gap(10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.send_1, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isAi;
  const _ChatMessage({required this.text, required this.isAi});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDark;
  const _ChatBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isAi
              ? (isDark ? AppColors.darkSurface2 : AppColors.lightSurface2)
              : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isAi ? 0 : 16),
            bottomRight: Radius.circular(message.isAi ? 16 : 0),
          ),
        ),
        child: Text(
          message.text,
          style: AppTextStyles.body.copyWith(
            color: message.isAi 
                ? (isDark ? AppColors.darkText : AppColors.lightText)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
