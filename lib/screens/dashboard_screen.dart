import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/company_data.dart';
import '../data/news_data.dart';
import '../providers/news_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/alco_logo.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/info_card.dart';
import '../widgets/news_card.dart';

class _DashboardSpacing {
  static const double pageMargin = 20;
  static const double pageVerticalPadding = 24;
  static const double cardPadding = 16;
  static const double cardRadius = 14;
  static const double cardGap = 12;
  static const double sectionGap = 24;
  static const double headingGap = 12;
  static const double headerLogoHeight = 40;
  static const double headerLogoVerticalPadding = 12;
}

String dashboardGreeting(DateTime dateTime) {
  final hour = dateTime.hour;
  if (hour >= 4 && hour <= 10) return 'Selamat pagi';
  if (hour >= 11 && hour <= 14) return 'Selamat siang';
  if (hour >= 15 && hour <= 17) return 'Selamat sore';
  return 'Selamat malam';
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        key: const Key('dashboard-header'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight:
            _DashboardSpacing.headerLogoHeight +
            2 * _DashboardSpacing.headerLogoVerticalPadding,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: _DashboardSpacing.headerLogoVerticalPadding,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth =
                  (constraints.maxWidth - 2 * _DashboardSpacing.pageMargin)
                      .clamp(0.0, 720.0)
                      .toDouble();
              return SizedBox(
                width: double.infinity,
                child: Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: AlcoLogo(
                        height: _DashboardSpacing.headerLogoHeight,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: _DashboardSpacing.pageMargin,
            vertical: _DashboardSpacing.pageVerticalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _WelcomeHeroCard(
                    greeting: dashboardGreeting(DateTime.now()),
                    onViewProfile: () =>
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.companyProfile),
                  ),
                  const SizedBox(height: _DashboardSpacing.cardGap),
                  InfoCard(
                    key: const Key('dashboard-company-summary'),
                    title: companyInfo.name,
                    padding: const EdgeInsets.all(
                      _DashboardSpacing.cardPadding,
                    ),
                    borderRadius: _DashboardSpacing.cardRadius,
                    centerTitleWithIcon: true,
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
                        const SizedBox(height: _DashboardSpacing.cardGap),
                        _DashboardLinkRow(
                          key: const Key('dashboard-business-info-link'),
                          text: 'Lihat Informasi Bisnis',
                          onTap: () =>
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.businessInfo),
                        ),
                      ],
                    ),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.businessInfo),
                  ),
                  const SizedBox(height: _DashboardSpacing.sectionGap),
                  Text(
                    'Akses Cepat',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: _DashboardSpacing.headingGap),
                  _QuickAccessCard(
                    key: const Key('quick-access-company'),
                    title: 'Profil Perusahaan',
                    description: 'Informasi umum perusahaan.',
                    icon: Icons.business_outlined,
                    onTap: () =>
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.companyProfile),
                  ),
                  const SizedBox(height: _DashboardSpacing.cardGap),
                  _QuickAccessCard(
                    key: const Key('quick-access-business'),
                    title: 'Informasi Bisnis',
                    description: 'Gambaran umum bidang usaha.',
                    icon: Icons.factory_outlined,
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.businessInfo),
                  ),
                  const SizedBox(height: _DashboardSpacing.cardGap),
                  _QuickAccessCard(
                    key: const Key('quick-access-news'),
                    title: 'Berita dan Aktivitas',
                    description: 'Lihat contoh berita dan aktivitas.',
                    icon: Icons.newspaper_outlined,
                    onTap: () =>
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.news),
                  ),
                  const SizedBox(height: _DashboardSpacing.sectionGap),
                  Text(
                    'Berita Terbaru',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: _DashboardSpacing.headingGap),
                  ...newsItems
                      .take(3)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: _DashboardSpacing.cardGap,
                          ),
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

class _WelcomeHeroCard extends StatelessWidget {
  final String greeting;
  final VoidCallback onViewProfile;

  const _WelcomeHeroCard({required this.greeting, required this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('dashboard-welcome-hero'),
      width: double.infinity,
      padding: const EdgeInsets.all(_DashboardSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_DashboardSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selamat datang di ALCO',
            style: TextStyle(
              color: AppColors.mainText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jelajahi profil perusahaan, informasi bisnis, dan berita terbaru.',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          _DashboardLinkRow(
            key: const Key('dashboard-view-profile-link'),
            text: 'Lihat Profil',
            onTap: onViewProfile,
          ),
        ],
      ),
    );
  }
}

class _DashboardLinkRow extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _DashboardLinkRow({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        ),
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
      padding: const EdgeInsets.all(_DashboardSpacing.cardPadding),
      borderRadius: _DashboardSpacing.cardRadius,
      onTap: onTap,
    );
  }
}
