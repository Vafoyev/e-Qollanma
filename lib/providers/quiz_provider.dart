import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../data/models/quiz_model.dart';

// ── Quiz list ─────────────────────────────────────────────────────────────────
final quizListProvider = FutureProvider<List<QuizModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  
  return [
    const QuizModel(
      id: '1',
      title: 'Geometrik yasashlar asoslari',
      isActive: true,
      createdAt: '2024-03-01',
      category: 'Geometriya',
      questionCount: 10,
      icon: Iconsax.mask,
    ),
    const QuizModel(
      id: '2',
      title: 'Proyeksiyalash usullari',
      isActive: true,
      createdAt: '2024-03-05',
      category: 'Proyeksiya',
      questionCount: 15,
      icon: Iconsax.box,
    ),
    const QuizModel(
      id: '3',
      title: 'Kesimlar va qirqimlar',
      isActive: true,
      createdAt: '2024-03-10',
      category: 'Texnik chizmachilik',
      questionCount: 12,
      icon: Iconsax.edit,
    ),
    const QuizModel(
      id: '4',
      title: 'Aksonometrik ko\'rinishlar',
      isActive: true,
      createdAt: '2024-03-15',
      category: 'Aksonometriya',
      questionCount: 8,
      icon: Iconsax.shapes,
    ),
  ];
});

// ── Quiz savollari ──────────────────────────────────────────
final quizQuestionsProvider =
FutureProvider.family<List<QuestionModel>, String>((ref, quizId) async {
  await Future.delayed(const Duration(milliseconds: 600));

  return [
    const QuestionModel(
      id: 'q1',
      questionText: 'Chizmachilikda qanday chiziq asosiy hisoblanadi?',
      options: [
        {'A': 'Ingichka tutash chiziq'},
        {'B': 'Yo\'g\'on tutash asosiy chiziq'},
        {'C': 'Shtrix chiziq'},
        {'D': 'Shtrix-punktir chiziq'},
      ],
    ),
    const QuestionModel(
      id: 'q2',
      questionText: 'A4 formatining o\'lchamlari qanday?',
      options: [
        {'A': '297x420 mm'},
        {'B': '210x297 mm'},
        {'C': '148x210 mm'},
        {'D': '420x594 mm'},
      ],
    ),
    const QuestionModel(
      id: 'q3',
      questionText: 'Masshtab 1:2 nimani anglatadi?',
      options: [
        {'A': 'Kattalashtirish'},
        {'B': 'Haqiqiy o\'lcham'},
        {'C': 'Kichiklashtirish'},
        {'D': 'Noto\'g\'ri masshtab'},
      ],
    ),
    const QuestionModel(
      id: 'q4',
      questionText: 'Narsaning ko\'rinmaydigan qismlarini chizishda qanday chiziq ishlatiladi?',
      options: [
        {'A': 'Shtrix chiziq'},
        {'B': 'Yo\'g\'on tutash chiziq'},
        {'C': 'To\'lqinli chiziq'},
        {'D': 'Ingichka tutash chiziq'},
      ],
    ),
    const QuestionModel(
      id: 'q5',
      questionText: 'Chizmalardagi o\'lchamlar qaysi birlikda ko\'rsatiladi?',
      options: [
        {'A': 'Santimetr (sm)'},
        {'B': 'Millimetr (mm)'},
        {'C': 'Metr (m)'},
        {'D': 'Detsimetr (dm)'},
      ],
    ),
    const QuestionModel(
      id: 'q6',
      questionText: 'A3 formatida nechta A4 formati bor?',
      options: [
        {'A': '1 ta'},
        {'B': '2 ta'},
        {'C': '4 ta'},
        {'D': '8 ta'},
      ],
    ),
    const QuestionModel(
      id: 'q7',
      questionText: 'Chizmada aylana markazini ko\'rsatish uchun qanday chiziq ishlatiladi?',
      options: [
        {'A': 'Shtrix chiziq'},
        {'B': 'Ingichka tutash chiziq'},
        {'C': 'Shtrix-punktir ingichka chiziq'},
        {'D': 'Yo\'g\'on tutash chiziq'},
      ],
    ),
  ];
});

// ── Foydalanuvchi tanlagan javoblar ───────────────────────────────────────────
final quizAnswersProvider =
StateProvider.family<Map<String, String>, String>((ref, quizId) => {});
