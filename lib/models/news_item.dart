/// Data model for News & Activities items.
/// Based on specifications in prd.md and design.md.
class NewsItem {
  final String id;
  final String title;
  final String category;
  final String date;
  final String summary;
  final String content;
  final String? imageAsset;

  const NewsItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.summary,
    required this.content,
    this.imageAsset,
  });

  /// Factory helper for creating placeholder/dummy items if needed.
  NewsItem copyWith({
    String? id,
    String? title,
    String? category,
    String? date,
    String? summary,
    String? content,
    String? imageAsset,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      imageAsset: imageAsset ?? this.imageAsset,
    );
  }
}

