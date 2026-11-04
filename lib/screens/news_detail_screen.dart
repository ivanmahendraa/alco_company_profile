import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/news_data.dart';
import '../models/news_item.dart';
import '../providers/news_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/empty_state.dart';

class NewsDetailScreen extends StatelessWidget {
  final String? newsId;
  final List<NewsItem> items;

  const NewsDetailScreen({
    super.key,
    required this.newsId,
    this.items = newsItems,
  });

  @override
  Widget build(BuildContext context) {
    final item = _findNewsItem();

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(title: 'Detail Berita'),
      body: SafeArea(
        child: item == null
            ? const EmptyState(
                icon: Icons.article_outlined,
                title: 'Berita tidak ditemukan',
                description: 'Data berita yang diminta tidak tersedia.',
              )
            : _NewsDetailContent(item: item),
      ),
    );
  }

  NewsItem? _findNewsItem() {
    final requestedId = newsId;
    if (requestedId == null || requestedId.isEmpty) {
      return null;
    }

    for (final item in items) {
      if (item.id == requestedId) {
        return item;
      }
    }
    return null;
  }
}

class _NewsDetailContent extends StatelessWidget {
  final NewsItem item;

  const _NewsDetailContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (item.imageAsset != null && item.imageAsset!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        item.imageAsset!,
                        fit: BoxFit.cover,
                        cacheWidth: 960,
                        semanticLabel: 'Gambar berita: ${item.title}',
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: AppColors.surface,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.secondaryText,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (item.category.trim().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withAlpha(15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (item.date.trim().isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: AppColors.secondaryText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.date,
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (item.title.trim().isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.mainText,
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ],
                    if (item.summary.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        item.summary,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16,
                          height: 1.55,
                        ),
                      ),
                    ],
                    if (item.content.trim().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 12),
                      Text(
                        item.content,
                        style: const TextStyle(
                          color: AppColors.mainText,
                          fontSize: 15,
                          height: 1.65,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Consumer<NewsProvider>(
                      builder: (context, provider, _) {
                        final isBookmarked = provider.isBookmarked(item.id);
                        return SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            key: const Key('news-detail-bookmark'),
                            onPressed: () => provider.toggleBookmark(item.id),
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                            label: Text(
                              isBookmarked
                                  ? 'Hapus bookmark'
                                  : 'Simpan bookmark',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryGreen,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
