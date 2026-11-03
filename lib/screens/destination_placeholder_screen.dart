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

  const DestinationPlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
    this.selectedNavigationIndex,
    this.newsItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: title,
        showBackButton: selectedNavigationIndex == null,
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
    );
  }
}
