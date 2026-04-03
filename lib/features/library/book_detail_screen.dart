import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/library_model.dart';
import '../../providers/library_provider.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailScreen> createState() =>
      _BookDetailScreenState();
}

class _BookDetailScreenState
    extends ConsumerState<BookDetailScreen> {
  String? _localPath;
  bool _isDownloading = false;
  double _progress    = 0;
  String? _error;

  Future<void> _downloadPdf(String url) async {
    setState(() {
      _isDownloading = true;
      _error = null;
    });
    try {
      final dir  = await getTemporaryDirectory();
      final path = '${dir.path}/book_${widget.bookId}.pdf';

      await Dio().download(
        url,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => _progress = received / total);
          }
        },
      );

      setState(() {
        _localPath    = path;
        _isDownloading = false;
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    final booksAsync = ref.watch(bookListProvider);

    return booksAsync.when(
      loading: () => const Scaffold(
        body:
        Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(e.toString())),
      ),
      data: (books) {
        final book = books.firstWhere((b) => b.id == widget.bookId,
            orElse: () => books.first);

        // PDF yuklanmagan bo'lsa yuklab olish
        if (_localPath == null && !_isDownloading && _error == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _downloadPdf(book.fileUrl);
          });
        }

        return Scaffold(
          backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
          appBar: AppBar(
            title: Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
          ),
          body: _buildBody(isDark, book),
        );
      },
    );
  }

  Widget _buildBody(bool isDark, LibraryModel book) {
    // ── Yuklanmoqda ────────────────────────────────────────────────────────
    if (_isDownloading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                value: _progress > 0 ? _progress : null,
                color: AppColors.primary,
                strokeWidth: 3,
              ),
              const Gap(20),
              Text(
                '${(_progress * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const Gap(8),
              Text(
                'loading'.tr(),
                style: AppTextStyles.small.copyWith(
                  color: isDark
                      ? AppColors.darkTextSub
                      : AppColors.lightTextSub,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Xatolik ────────────────────────────────────────────────────────────
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 56, color: AppColors.error),
              const Gap(16),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.small),
              const Gap(20),
              ElevatedButton(
                onPressed: () => _downloadPdf(book.fileUrl),
                child: Text('btn_retry'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    // ── PDF ko'rsatish ─────────────────────────────────────────────────────
    if (_localPath != null) {
      return PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        backgroundColor:
        isDark ? AppColors.darkBg : AppColors.lightBg,
      );
    }

    return const SizedBox.shrink();
  }
}