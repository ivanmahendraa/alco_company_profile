import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/info_card.dart';

class DestinationPlaceholderScreen extends StatelessWidget {
  final String title;
  final String description;
  final int? selectedNavigationIndex;
  final NewsItem? newsItem;
  final String? backRoute;

  const DestinationPlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
    this.selectedNavigationIndex,
    this.newsItem,
    this.backRoute,
  });

  @override
  Widget build(BuildContext context) {
    final handlesBackNavigation =
        selectedNavigationIndex != null || backRoute != null;

    return PopScope<void>(
      canPop: !handlesBackNavigation,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && handlesBackNavigation) {
          _handleBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: CustomAppBar(
          title: title,
          onBackPressed: () => _handleBack(context),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: InfoCard(
                  title: newsItem?.title ?? 'Layar dalam persiapan',
                  description: description,
                  icon: const Icon(
                    Icons.construction_outlined,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: selectedNavigationIndex == null
            ? null
            : CustomBottomNav(
                currentIndex: selectedNavigationIndex!,
                onTap: (index) {
                  if (index == 0) {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.dashboard);
                  } else if (index == 1) {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.companyProfile);
                  } else if (index == 2) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.news);
                  }
                },
              ),
      ),
    );
  }

  void _handleBack(BuildContext context) {
    final navigator = Navigator.of(context);
    if (selectedNavigationIndex != null) {
      _returnToRoute(context, AppRoutes.dashboard);
    } else if (backRoute != null) {
      _returnToRoute(context, backRoute!);
    } else {
      navigator.maybePop();
    }
  }

  void _returnToRoute(BuildContext context, String routeName) {
    final navigator = Navigator.of(context);
    var foundRoute = false;
    navigator.popUntil((route) {
      if (route.settings.name == routeName) {
        foundRoute = true;
        return true;
      }
      return route.isFirst;
    });
    if (!foundRoute) {
      navigator.pushReplacementNamed(routeName);
    }
  }
}
