# E-Qollanma (E-Darslik.AI)

E-Qollanma — Flutter bilan yozilgan ko'p-platformali ta'limiy ilova. Ilovada:

- AI yordamchi (chat) — `lib/features/ai_assistant/ai_chat_screen.dart`
- Kutubxona va videolar bo'limlari
- Testlar va quiz funksiyalari

Tez boshlash (PowerShell):

```powershell
# Repoga klonlash
git clone https://github.com/Vafoyev/e-Qollanma.git
Set-Location 'C:\Users\isobe\AndroidStudioProjects\e-Qollanma'

# Paketlarni o'rnatish
flutter pub get

# Ilovani ishga tushurish
flutter run

# Testlarni ishga tushurish
flutter test
```

Repo statistikasi (lokal holat):

- Tracked files: 198
- Current branch: main
- Branchlar (local/remote):
  - main
  - origin
  - origin/main

Muhim xavfsizlik eslatmasi:

Yaqinda repo tarixidan biror ochiq API kalit olib tashlandi va tozalangan tarix GitHub-ga push qilindi. Agar siz ilgari reponi klonlagan yoki eski commitlarni olgan bo'lsangiz, xavfsiz tomondan reponi qayta klonlang yoki quyidagilarni bajaring:

```powershell
# Remote bilan toza sinxronizatsiya
git fetch origin
git reset --hard origin/main
```

Kalitlarni doim environment variables yoki secret manager orqali boshqaring — kod ichiga yozmang.

Asosiy direktoriyalar:

- `lib/` — Flutter ilova kodi (features modul tuzilmasi)
- `android/`, `ios/`, `web/`, `windows/`, `macos/` — platformaga oid native kod
- `assets/` — rasm, animatsiya, tarjimalar
- `pubspec.yaml` — dependency va asset konfiguratsiyasi

Qo'shimcha yordam kerak bo'lsa (CI/CD, deploy, kalitlarni rotate qilish yoki hamkorlarga xabar matni tayyorlash) — ayting, men yordam beraman.

