# About this project — E-Qollanma (E-Darslik.AI)

Loyiha haqida: E-Qollanma — o'quvchilar va talabalar uchun yaratilgan ko'p-platformali (mobile, web, desktop) Flutter ilovasi. Ilovaning maqsadi: chizmachilik (texnik chizmalar) bo'yicha interaktiv o'quv resurslari, videolar, kitobxona va AI yordamchi orqali savol-javoblarni taqdim etish.

Arxitektura va muhim fayllar:

- `lib/main.dart` — ilova kirish nuqtasi.
- `lib/features/` — ilovaning asosiy modullari (ai_assistant, auth, home, library, profile, quiz va boshqalar).
- `lib/core/` — constants, network, storage, theme, router va boshqa umumiy modul kodlari.
- `lib/data/` — modellari va repository'lar.
- `assets/` — animatsiyalar, rasm va tarjimalar (assets/translations/*.json).
- `pubspec.yaml` — bog'liqliklar (dependencies) va asset konfiguratsiyasi.

Asosiy dependency'lar (pubspec.yaml ichidan):
- flutter_riverpod — state management
- google_generative_ai — Gemini integratsiyasi (AI chat)
- flutter_markdown — AI javoblarini markdown tarzida ko'rsatish uchun
- iconsax, gap va boshqa UI yordamchi paketlar

AI yordamchi haqida:
- Asosiy chat ekran: `lib/features/ai_assistant/ai_chat_screen.dart`.
- Eslatma: dastlab faylga API kalit qator sifatida qo'yilgan edi — keyin tarixdan tozalab, kalit REDACTED qilindi. Ilovada haqiqiy kalitlarni environment o'zgaruvchilari yoki server-side secrets manager orqali saqlash kerak.

Local/remote git holati:
- Tracked files: 198
- Branch: main (current)
- Remote: https://github.com/Vafoyev/e-Qollanma.git

Ishga tushirish uchun qo'shimcha ko'rsatmalar:

1) Flutter SDK va platforma uchun kerakli toolchain o'rnating (Android Studio, Xcode macOS uchun, msbuild/windows toolchain agar kerak bo'lsa).
2) `flutter pub get` ishlating.
3) `flutter run` orqali ilovani ishga tushiring.

Xavfsizlik va ishlab chiqish oqimi (recommended):
- Secrets: hech qachon kod ichiga API kalit yozmang. Agar kalit yuborilgan bo'lsa — darhol rotate/revoke qiling va repo tarixini tozalang.
- Branch workflow: feature-branch -> pull request -> review -> merge to main.
- CI: build va testlarni GitHub Actions (yoki boshqa CI) orqali avtomatlashtirish tavsiya etiladi.

Hissangizni qo'shish (how to contribute):

1. Fork qiling yoki yangi branch yarating: `git checkout -b feat/sizning-feature`.
2. O'zgartirishlar qiling va testlarni qo'shing.
3. Pull request yarating va tagging qiling.

Kontakt va yordam: repo issues orqali muammolarni yuboring yoki README.md dagi qo'shimcha izohlar uchun murojaat qiling.

