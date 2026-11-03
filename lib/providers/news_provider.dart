import 'package:flutter/foundation.dart';

/// Foundation Provider for News & Activities shared state (bookmarks, search query).
/// Uses ChangeNotifier as specified in prd.md and design.md.
class NewsProvider extends ChangeNotifier {
  final Set<String> _bookmarkedIds = <String>{};
  String _searchQuery = '';

  Set<String> get bookmarkedIds => Set.unmodifiable(_bookmarkedIds);
  String get searchQuery => _searchQuery;

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}

