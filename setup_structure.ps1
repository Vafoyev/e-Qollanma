# E-DrawGuide — Flutter loyiha strukturasini yaratish
# PS C:\Users\isobe\AndroidStudioProjects\e_Qollanma> .\setup_structure.ps1

$base = "lib"

# ── Papkalar ──────────────────────────────────────────────────────────────────

$folders = @(
    # core
    "$base/core/constants",
    "$base/core/theme",
    "$base/core/router",
    "$base/core/localization",
    "$base/core/network",
    "$base/core/storage",
    "$base/core/utils",

    # data
    "$base/data/models",
    "$base/data/repositories",

    # providers
    "$base/providers",

    # features
    "$base/features/splash",
    "$base/features/language",
    "$base/features/onboarding",
    "$base/features/auth/widgets",
    "$base/features/home",
    "$base/features/videos/widgets",
    "$base/features/library/widgets",
    "$base/features/quiz/widgets",
    "$base/features/profile",

    # shared
    "$base/shared/widgets",

    # assets
    "assets/animations",
    "assets/images",
    "assets/fonts",
    "assets/translations"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
    Write-Host "✅ $folder" -ForegroundColor Green
}

# ── Fayllar ───────────────────────────────────────────────────────────────────

$files = @(
    # entry
    "$base/main.dart",

    # core/constants
    "$base/core/constants/app_colors.dart",
    "$base/core/constants/app_text_styles.dart",
    "$base/core/constants/app_strings.dart",
    "$base/core/constants/api_endpoints.dart",

    # core/theme
    "$base/core/theme/app_theme.dart",

    # core/router
    "$base/core/router/app_router.dart",

    # core/localization
    "$base/core/localization/app_localizations.dart",

    # core/network
    "$base/core/network/dio_client.dart",
    "$base/core/network/api_interceptor.dart",

    # core/storage
    "$base/core/storage/secure_storage.dart",
    "$base/core/storage/prefs_storage.dart",

    # core/utils
    "$base/core/utils/validators.dart",
    "$base/core/utils/extensions.dart",

    # data/models
    "$base/data/models/user_model.dart",
    "$base/data/models/video_model.dart",
    "$base/data/models/library_model.dart",
    "$base/data/models/quiz_model.dart",
    "$base/data/models/question_model.dart",
    "$base/data/models/result_model.dart",

    # data/repositories
    "$base/data/repositories/auth_repository.dart",
    "$base/data/repositories/video_repository.dart",
    "$base/data/repositories/library_repository.dart",
    "$base/data/repositories/quiz_repository.dart",

    # providers
    "$base/providers/auth_provider.dart",
    "$base/providers/theme_provider.dart",
    "$base/providers/locale_provider.dart",
    "$base/providers/video_provider.dart",
    "$base/providers/library_provider.dart",
    "$base/providers/quiz_provider.dart",

    # features/splash
    "$base/features/splash/splash_screen.dart",

    # features/language
    "$base/features/language/language_screen.dart",

    # features/onboarding
    "$base/features/onboarding/intro_screen.dart",
    "$base/features/onboarding/authors_screen.dart",
    "$base/features/onboarding/curriculum_screen.dart",

    # features/auth
    "$base/features/auth/login_screen.dart",
    "$base/features/auth/register_screen.dart",
    "$base/features/auth/widgets/phone_field.dart",
    "$base/features/auth/widgets/password_field.dart",

    # features/home
    "$base/features/home/main_screen.dart",

    # features/videos
    "$base/features/videos/videos_screen.dart",
    "$base/features/videos/video_detail_screen.dart",
    "$base/features/videos/widgets/video_card.dart",

    # features/library
    "$base/features/library/library_screen.dart",
    "$base/features/library/book_detail_screen.dart",
    "$base/features/library/widgets/book_card.dart",

    # features/quiz
    "$base/features/quiz/quiz_list_screen.dart",
    "$base/features/quiz/quiz_screen.dart",
    "$base/features/quiz/quiz_result_screen.dart",
    "$base/features/quiz/widgets/question_card.dart",

    # features/profile
    "$base/features/profile/profile_screen.dart",

    # shared/widgets
    "$base/shared/widgets/custom_button.dart",
    "$base/shared/widgets/custom_text_field.dart",
    "$base/shared/widgets/loading_widget.dart",
    "$base/shared/widgets/app_error_widget.dart",
    "$base/shared/widgets/app_navbar.dart",

    # translations
    "assets/translations/uz.json",
    "assets/translations/ru.json",
    "assets/translations/en.json"
)

foreach ($file in $files) {
    if (!(Test-Path $file)) {
        New-Item -ItemType File -Force -Path $file | Out-Null
        Write-Host "📄 $file" -ForegroundColor Cyan
    } else {
        Write-Host "⏭️  exists: $file" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  ✅  Struktura muvaffaqiyatli yaratildi!" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
