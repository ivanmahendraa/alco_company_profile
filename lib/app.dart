import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/news_data.dart';
import 'models/news_item.dart';
import 'providers/news_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/destination_placeholder_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

/// The root application widget for ALCO Company Profile.
/// Configures Provider, Material 3 theme, and Navigator route handling.
class AlcoApp extends StatelessWidget {
  const AlcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NewsProvider())],
      child: MaterialApp(
        title: 'ALCO Company Profile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const DashboardScreen(),
        );
      case AppRoutes.splash:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.companyProfile:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const DestinationPlaceholderScreen(
            title: 'Profil Perusahaan',
            description: 'Layar Profil Perusahaan akan dibuat pada Task 06.',
            selectedNavigationIndex: 1,
          ),
        );
      case AppRoutes.businessInfo:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const DestinationPlaceholderScreen(
            title: 'Informasi Bisnis',
            description: 'Layar Informasi Bisnis akan dibuat pada Task 07.',
          ),
        );
      case AppRoutes.news:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const DestinationPlaceholderScreen(
            title: 'Berita dan Aktivitas',
            description: 'Layar Berita dan Aktivitas akan dibuat pada Task 08.',
            selectedNavigationIndex: 2,
          ),
        );
      case AppRoutes.newsDetail:
        final item = settings.arguments;
        if (item is NewsItem && newsItems.any((news) => news.id == item.id)) {
          return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => DestinationPlaceholderScreen(
              title: 'Detail Berita',
              description: 'Layar Detail Berita akan dibuat pada Task 09.',
              newsItem: item,
            ),
          );
        }
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const DestinationPlaceholderScreen(
            title: 'Detail Berita',
            description:
                'Berita yang dipilih tidak tersedia. Layar Detail Berita '
                'akan dibuat pada Task 09.',
          ),
        );
      default:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const AppFoundationScreen(),
        );
    }
  }
}

/// Foundation landing screen used during Task 01 to verify:
/// 1. Material 3 and ALCO theme integration.
/// 2. Provider accessibility.
/// 3. Navigation and layout readiness.
///
/// NOTE: Full screen widgets (Splash, Login, etc.) are implemented in subsequent tasks.
class AppFoundationScreen extends StatelessWidget {
  const AppFoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ALCO Company Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.accentLime,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Task 01 Foundation Ready',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.primaryGreen),
                          ),
                        ],
                      ),
                      const SizedBox(width: 0, height: 12),
                      Text(
                        'Material 3 theme, centralized ALCO color tokens, Navigator routing, and Provider state foundation have been initialized.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<NewsProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Provider Status:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.success.withAlpha(80),
                              ),
                            ),
                            child: const Text(
                              'Connected (Active)',
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
