import 'package:flutter/material.dart';

import '../data/business_data.dart' as business_data;
import '../data/company_data.dart' as company_data;
import '../models/company_info.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/info_card.dart';

class _BusinessInfoSpacing {
  static const double pageMargin = 20;
  static const double pageVerticalPadding = 24;
  static const double cardPadding = 16;
  static const double cardRadius = 14;
  static const double cardGap = 12;
  static const double sectionGap = 24;
}

class BusinessInfoScreen extends StatelessWidget {
  final CompanyInfo companyInfo;
  final List<business_data.BusinessTopic> topics;

  const BusinessInfoScreen({
    super.key,
    this.companyInfo = company_data.companyInfo,
    this.topics = business_data.businessTopics,
  });

  @override
  Widget build(BuildContext context) {
    final visibleTopics = topics
        .where(
          (topic) =>
              topic.title.trim().isNotEmpty &&
              topic.description.trim().isNotEmpty,
        )
        .take(4)
        .toList();
    final businessDescription = companyInfo.businessDescription.trim();

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(title: business_data.businessInfoScreenTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: _BusinessInfoSpacing.pageMargin,
            vertical: _BusinessInfoSpacing.pageVerticalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (businessDescription.isNotEmpty)
                    InfoCard(
                      title: companyInfo.name,
                      description: businessDescription,
                      icon: const Icon(
                        Icons.factory_outlined,
                        color: AppColors.primaryGreen,
                      ),
                      padding: const EdgeInsets.all(
                        _BusinessInfoSpacing.cardPadding,
                      ),
                      borderRadius: _BusinessInfoSpacing.cardRadius,
                    ),
                  if (businessDescription.isNotEmpty &&
                      visibleTopics.isNotEmpty)
                    const SizedBox(height: _BusinessInfoSpacing.sectionGap),
                  for (
                    var index = 0;
                    index < visibleTopics.length;
                    index++
                  ) ...[
                    if (index > 0)
                      const SizedBox(height: _BusinessInfoSpacing.cardGap),
                    InfoCard(
                      title: visibleTopics[index].title,
                      description: visibleTopics[index].description,
                      titleColor: AppColors.primaryGreen,
                      icon: Icon(
                        _topicIcons[index],
                        color: AppColors.primaryGreen,
                      ),
                      padding: const EdgeInsets.all(
                        _BusinessInfoSpacing.cardPadding,
                      ),
                      borderRadius: _BusinessInfoSpacing.cardRadius,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
        onTap: (index) {
          final route = switch (index) {
            0 => AppRoutes.dashboard,
            1 => AppRoutes.companyProfile,
            2 => AppRoutes.news,
            _ => null,
          };
          if (route != null) {
            Navigator.of(context).pushReplacementNamed(route);
          }
        },
      ),
    );
  }

  static const List<IconData> _topicIcons = [
    Icons.factory_outlined,
    Icons.precision_manufacturing_outlined,
    Icons.settings_outlined,
    Icons.verified_outlined,
  ];
}
