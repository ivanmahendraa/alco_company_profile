import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/news_item.dart';
import '../utils/app_colors.dart';

/// News & Activities card component adhering to the ALCO brand identity.
/// Displays item category, title, date, summary, optional local thumbnail,
/// and an interactive bookmark toggle.
class NewsCard extends StatelessWidget {
  final NewsItem item;
  final bool isBookmarked;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.item,
    this.isBookmarked = false,
    this.onBookmarkToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildThumbnail() {
      final imagePath = item.imageAsset;
      if (imagePath != null && imagePath.isNotEmpty) {
        if (imagePath.endsWith('.svg')) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SvgPicture.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildFallbackThumbnail(),
            ),
          );
        }
      }
      return _buildFallbackThumbnail();
    }

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: Category & Bookmark button
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withAlpha(15),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          item.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (onBookmarkToggle != null) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 22,
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? AppColors.primaryGreen
                              : AppColors.secondaryText,
                        ),
                        tooltip: isBookmarked
                            ? 'Hapus bookmark'
                            : 'Simpan bookmark',
                        onPressed: onBookmarkToggle,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10.0),
              // Body row: Title, summary, date and thumbnail
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.mainText,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          item.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 13.0,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 13.0,
                              color: AppColors.secondaryText,
                            ),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                item.date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  buildThumbnail(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackThumbnail() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.appBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Icon(
          Icons.article_outlined,
          color: AppColors.secondaryText,
          size: 32,
        ),
      ),
    );
  }
}
