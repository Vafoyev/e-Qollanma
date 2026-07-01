import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/library_model.dart';
import '../../providers/library_provider.dart';
import '../../shared/widgets/app_error_widget.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  String? _localPath;
  bool _isDownloading = false;
  double _progress = 0;
  String? _error;

  Future<void> _downloadAndOpen(String url, String fileName) async {
    setState(() {
      _isDownloading = true;
      _error = null;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        setState(() {
          _localPath = file.path;
          _isDownloading = false;
        });
        return;
      }

      final dio = Dio();
      await dio.download(
        url,
        file.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => _progress = received / total);
          }
        },
      );

      setState(() {
        _localPath = file.path;
        _isDownloading = false;
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _error = "Faylni yuklab bo'lmadi. Internetni tekshiring.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemsAsync = ref.watch(libraryListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('library_read'.tr()),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(message: e.toString(), onRetry: () => ref.refresh(libraryListProvider)),
        data: (items) {
          final item = items.firstWhere((b) => b.id == widget.bookId, orElse: () => items.first);

          if (_localPath == null && !_isDownloading && _error == null) {
            // Avtomatik yuklashni boshlash (Haqiqiy URL bo'lsa)
            // _downloadAndOpen(item.fileUrl, "book_${item.id}.pdf");
          }

          return _buildViewer(isDark, item);
        },
      ),
    );
  }

  Widget _buildViewer(bool isDark, LibraryModel item) {
    if (_isDownloading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.document_download, size: 64, color: AppColors.primary),
            const Gap(20),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const Gap(12),
            Text("${(_progress * 100).toInt()}%", style: AppTextStyles.h4),
          ],
        ),
      );
    }

    if (_error != null) {
      return AppErrorWidget(message: _error!, onRetry: () => _downloadAndOpen(item.fileUrl, "file.pdf"));
    }

    // Mock Viewer for Presentation/Docs
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.type == LibraryType.presentation ? Iconsax.presention_chart : Iconsax.document_text,
            size: 100,
            color: AppColors.primary,
          ),
          const Gap(24),
          Text(item.title, style: AppTextStyles.h3, textAlign: TextAlign.center),
          const Gap(8),
          Text(item.typeLabel, style: AppTextStyles.body),
          const Gap(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                // Haqiqiy ochish mantiqi
              },
              child: const Text("Faylni ochish"),
            ),
          ),
        ],
      ),
    );
  }
}
