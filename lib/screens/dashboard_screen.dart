import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/company_data.dart';
import '../data/news_data.dart';
import '../providers/news_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/info_card.dart';
import '../widgets/news_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(title: 'Beranda'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const InfoCard(
                    title: 'Selamat datang',
                    description:
                        'Jelajahi profil perusahaan, informasi bisnis, dan '
                        'berita terbaru.',
                    icon: Icon(
                      Icons.waving_hand_outlined,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InfoCard(
                    key: const Key('dashboard-company-summary'),
                    title: companyInfo.name,
                    icon: const Icon(
                      Icons.business_outlined,
                      color: AppColors.primaryGreen,
                    ),
                    customContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyInfo.businessDescription,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Lihat Informasi Bisnis',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.businessInfo),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Akses Cepat',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _QuickAccessCard(
                    key: const Key('quick-access-company'),
                    title: 'Profil Perusahaan',
                    description: 'Informasi umum perusahaan.',
                    icon: Icons.business_outlined,
                    onTap: () =>
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.companyProfile),
                  ),
                  const SizedBox(height: 10),
                  _QuickAccessCard(
                    key: const Key('quick-access-business'),
                    title: 'Informasi Bisnis',
                    description: 'Gambaran umum bidang usaha.',
                    icon: Icons.factory_outlined,
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.businessInfo),
                  ),
                  const SizedBox(height: 10),
                  _QuickAccessCard(
                    key: const Key('quick-access-news'),
                    title: 'Berita dan Aktivitas',
                    description: 'Lihat contoh berita dan aktivitas.',
                    icon: Icons.newspaper_outlined,
                    onTap: () =>
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.news),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Berita Terbaru',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...newsItems
                      .take(3)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Consumer<NewsProvider>(
                            builder: (context, newsProvider, _) => NewsCard(
                              key: Key('dashboard-news-${item.id}'),
                              item: item,
                              isBookmarked: newsProvider.isBookmarked(item.id),
                              onBookmarkToggle: () =>
                                  newsProvider.toggleBookmark(item.id),
                              onTap: () => Navigator.of(context).pushNamed(
                                AppRoutes.newsDetail,
                                arguments: item,
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.companyProfile);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.news);
          }
        },
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAccessCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: title,
      description: description,
      icon: Icon(icon, color: AppColors.primaryGreen),
      trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText),
      onTap: onTap,
    );
  }
}
