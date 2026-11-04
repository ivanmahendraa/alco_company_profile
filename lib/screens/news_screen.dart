import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/news_data.dart';
import '../models/news_item.dart';
import '../providers/news_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/empty_state.dart';
import '../widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  final List<NewsItem> items;

  const NewsScreen({super.key, this.items = newsItems});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<NewsProvider>().searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final query = provider.searchQuery.trim().toLowerCase();
    final visibleItems = widget.items.where((item) {
      return query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.summary.toLowerCase().contains(query);
    }).toList();

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _returnToDashboard(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: CustomAppBar(
          title: 'Berita dan Aktivitas',
          onBackPressed: () => _returnToDashboard(context),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: TextField(
                      key: const Key('news-search-field'),
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: provider.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Cari berdasarkan judul atau ringkasan',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Hapus pencarian',
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.clearSearch();
                                },
                              ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: visibleItems.isEmpty
                        ? EmptyState(
                            icon: Icons.search_off_outlined,
                            title: widget.items.isEmpty
                                ? 'Belum ada berita atau aktivitas'
                                : 'Berita tidak ditemukan',
                            description: widget.items.isEmpty
                                ? 'Berita dan aktivitas akan ditampilkan di sini.'
                                : 'Coba kata kunci lain atau hapus pencarian.',
                          )
                        : ListView.separated(
                            key: const Key('news-list'),
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                            itemCount: visibleItems.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = visibleItems[index];
                              return NewsCard(
                                key: Key('news-card-${item.id}'),
                                item: item,
                                isBookmarked: provider.isBookmarked(item.id),
                                onBookmarkToggle: () =>
                                    provider.toggleBookmark(item.id),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.newsDetail,
                                    arguments: item.id,
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: 2,
          onTap: (index) {
            final route = switch (index) {
              0 => AppRoutes.dashboard,
              1 => AppRoutes.companyProfile,
              2 => AppRoutes.news,
              _ => null,
            };
            if (route != null && route != AppRoutes.news) {
              Navigator.of(context).pushReplacementNamed(route);
            }
          },
        ),
      ),
    );
  }

  void _returnToDashboard(BuildContext context) {
    final navigator = Navigator.of(context);
    var foundDashboard = false;
    navigator.popUntil((route) {
      if (route.settings.name == AppRoutes.dashboard) {
        foundDashboard = true;
        return true;
      }
      return route.isFirst;
    });
    if (!foundDashboard) {
      navigator.pushReplacementNamed(AppRoutes.dashboard);
    }
  }
}
