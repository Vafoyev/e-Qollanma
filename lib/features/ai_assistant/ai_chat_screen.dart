import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/constants/app_colors.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // ── AI SOZLAMALARI ──────────────────────────────────────────
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  
  late final GenerativeModel _model;
  late final ChatSession _chat;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: "Salom! Men E-Darslik.AI aqlli yordamchisiman. Men faqat chizmachilik fani bo'yicha mutaxassisman. Qanday savollaringiz bor?",
      isAi: true,
    ),
  ];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        "Sening isming E-Darslik.AI yordamchisi. Sen chizmachilik va muhandislik grafikasi fani bo'yicha "
        "o'ta bilimdon, tajribali va muloyim professorsan. Sening vazifang foydalanuvchilarga chizmachilik sirlarini o'rgatish. "
        "Javoblaringda o'z bilimingni isbotlash uchun davlat standartlari (GOST), chiziqlar qalinligi, "
        "format o'lchamlari kabi aniq texnik ma'lumotlardan foydalan. "
        "Faqat chizmachilikka oid savollarga javob ber. Agar boshqa mavzularda savol berishsa, "
        "muloyimlik bilan rad et va faqat chizmachilik (formatlar, masshtablar, chiziqlar, proyeksiyalar, kesimlar, detallar) "
        "bo'yicha yordam bera olishingni ayt. Javoblaringni aniq, ilmiy va faqat o'zbek tilida ber."
      ),
    );
    _chat = _model.startChat();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isAi: false));
      _messageController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final responseText = response.text;

      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(_ChatMessage(text: responseText ?? "AI javob qaytara olmadi...", isAi: true));
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('GEMINI ERROR: $e');
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(_ChatMessage(
            text: "Xatolik yuz berdi: ${e.toString().contains('403') ? 'API kalitda ruxsat yo\'q (403)' : 'Ulanish xatosi'}. Iltimos, internetni yoki API kalitni tekshiring.",
            isAi: true
          ));
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800 || (defaultTargetPlatform == TargetPlatform.windows);

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            leading: IconButton(
              icon: Icon(Iconsax.arrow_left_2, color: isDark ? Colors.white : Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                  child: const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
                ),
                const Gap(12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("E-Darslik.AI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Aqlli yordamchi", style: TextStyle(fontSize: 11, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? constraints.maxWidth * 0.15 : 16,
                    vertical: 20,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) => _ChatBubble(message: _messages[i], isDark: isDark),
                ),
              ),
              if (_isTyping)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? constraints.maxWidth * 0.15 + 20 : 20, vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                      const Gap(8),
                      Text("AI o'ylamoqda...", style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54)),
                    ],
                  ),
                ),
              _buildInput(isDark, isDesktop, constraints.maxWidth),
            ],
          ),
        );
      }
    );
  }

  Widget _buildInput(bool isDark, bool isDesktop, double width) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? width * 0.15 : 16, 12, 
        isDesktop ? width * 0.15 : 16, 
        kIsWeb || defaultTargetPlatform != TargetPlatform.android ? 24 : 12
      ),
      decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface2 : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: isDark ? AppColors.darkBorder : Colors.black12),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: const InputDecoration(
                  hintText: "Chizmachilik bo'yicha savol bering...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const Gap(12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              height: 50, width: 50,
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
              child: const Icon(Iconsax.send_1, color: Colors.white, size: 24),
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
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isAi
              ? (isDark ? AppColors.darkSurface2 : Colors.white)
              : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isAi ? 0 : 20),
            bottomRight: Radius.circular(message.isAi ? 20 : 0),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: MarkdownBody(
          data: message.text,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontSize: 15, height: 1.5,
              color: message.isAi ? (isDark ? Colors.white : Colors.black87) : Colors.white,
            ),
            listBullet: TextStyle(
              color: message.isAi ? (isDark ? Colors.white : Colors.black87) : Colors.white,
            ),
            strong: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
