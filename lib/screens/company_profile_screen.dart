import 'package:flutter/material.dart';

import '../data/company_data.dart' as company_data;
import '../models/company_info.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/alco_logo.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/info_card.dart';

class _CompanyProfileSpacing {
  static const double pageMargin = 20;
  static const double pageVerticalPadding = 24;
  static const double cardPadding = 16;
  static const double cardRadius = 14;
  static const double cardGap = 12;
  static const double sectionGap = 24;
}

class CompanyProfileScreen extends StatelessWidget {
  final CompanyInfo companyInfo;

  const CompanyProfileScreen({
    super.key,
    this.companyInfo = company_data.companyInfo,
  });

  @override
  Widget build(BuildContext context) {
    final mission = _nonEmpty(companyInfo.mission);
    final commitment = _nonEmpty(companyInfo.commitment);

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToDashboard(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: CustomAppBar(
          title: 'Profil Perusahaan',
          onBackPressed: () => _goToDashboard(context),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: _CompanyProfileSpacing.pageMargin,
              vertical: _CompanyProfileSpacing.pageVerticalPadding,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoCard(
                      title: companyInfo.name,
                      icon: const AlcoLogo(width: 64, height: 40),
                      centerTitleWithIcon: true,
                      padding: const EdgeInsets.all(
                        _CompanyProfileSpacing.cardPadding,
                      ),
                      borderRadius: _CompanyProfileSpacing.cardRadius,
                    ),
                    if (_nonEmpty(companyInfo.overview)
                        case final overview?) ...[
                      const SizedBox(height: _CompanyProfileSpacing.cardGap),
                      InfoCard(
                        title: 'Tentang Kami',
                        description: overview,
                        padding: const EdgeInsets.all(
                          _CompanyProfileSpacing.cardPadding,
                        ),
                        borderRadius: _CompanyProfileSpacing.cardRadius,
                      ),
                    ],
                    if (mission != null) ...[
                      const SizedBox(height: _CompanyProfileSpacing.sectionGap),
                      InfoCard(
                        title: 'Misi',
                        description: mission,
                        padding: const EdgeInsets.all(
                          _CompanyProfileSpacing.cardPadding,
                        ),
                        borderRadius: _CompanyProfileSpacing.cardRadius,
                      ),
                    ],
                    if (companyInfo.values.isNotEmpty) ...[
                      const SizedBox(height: _CompanyProfileSpacing.sectionGap),
                      InfoCard(
                        title: 'Nilai Perusahaan',
                        customContent: _buildList(companyInfo.values),
                        padding: const EdgeInsets.all(
                          _CompanyProfileSpacing.cardPadding,
                        ),
                        borderRadius: _CompanyProfileSpacing.cardRadius,
                      ),
                    ],
                    if (companyInfo.qualityPolicies.isNotEmpty) ...[
                      const SizedBox(height: _CompanyProfileSpacing.sectionGap),
                      InfoCard(
                        title: 'Kebijakan Mutu',
                        customContent: _buildList(
                          companyInfo.qualityPolicies,
                          numbered: true,
                        ),
                        padding: const EdgeInsets.all(
                          _CompanyProfileSpacing.cardPadding,
                        ),
                        borderRadius: _CompanyProfileSpacing.cardRadius,
                      ),
                    ],
                    if (commitment != null) ...[
                      const SizedBox(height: _CompanyProfileSpacing.sectionGap),
                      InfoCard(
                        title: 'Komitmen Perusahaan',
                        description: commitment,
                        padding: const EdgeInsets.all(
                          _CompanyProfileSpacing.cardPadding,
                        ),
                        borderRadius: _CompanyProfileSpacing.cardRadius,
                      ),
                    ],
                    if (_companyDetails.isNotEmpty) ...[
                      const SizedBox(height: _CompanyProfileSpacing.sectionGap),
                      InfoCard(
                        title: 'Ringkasan Perusahaan',
                        customContent: _buildCompanyDetails(),
                        padding: const EdgeInsets.all(
                          _CompanyProfileSpacing.cardPadding,
                        ),
                        borderRadius: _CompanyProfileSpacing.cardRadius,
                      ),
                    ],
                    const SizedBox(height: _CompanyProfileSpacing.cardGap),
                    InfoCard(
                      title: 'Lihat Informasi Bisnis',
                      titleColor: AppColors.primaryGreen,
                      trailing: const Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.primaryGreen,
                      ),
                      padding: const EdgeInsets.all(
                        _CompanyProfileSpacing.cardPadding,
                      ),
                      borderRadius: _CompanyProfileSpacing.cardRadius,
                      onTap: () =>
                          Navigator.of(context)
                              .pushNamed(AppRoutes.businessInfo),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              _goToDashboard(context);
            } else if (index == 2) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.news);
            }
          },
        ),
      ),
    );
  }

  List<(String, String?)> get _companyDetails => [
    ('Alamat', companyInfo.address),
    ('Telepon', companyInfo.phone),
    ('Industri', companyInfo.industry),
    ('Tahun Pendirian', companyInfo.foundingYear),
    ('Jenis Perusahaan', companyInfo.companyType),
    ('Ukuran Perusahaan', companyInfo.employeeRange),
    ('Kantor Pusat', companyInfo.headquarters),
  ].where((detail) => _nonEmpty(detail.$2) != null).toList();

  static String? _nonEmpty(String? value) {
    final trimmedValue = value?.trim();
    return trimmedValue == null || trimmedValue.isEmpty ? null : trimmedValue;
  }

  static Widget _buildList(List<String> items, {bool numbered = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: _CompanyProfileSpacing.cardGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: numbered ? 28 : 16,
                child: numbered
                    ? Text(
                        '${index + 1}.',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: AppColors.primaryGreen,
                        ),
                      ),
              ),
              Expanded(
                child: Text(
                  items[index],
                  style: const TextStyle(
                    color: AppColors.mainText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCompanyDetails() {
    return Column(
      children: [
        for (var index = 0; index < _companyDetails.length; index++) ...[
          if (index > 0) ...[
            const SizedBox(height: _CompanyProfileSpacing.cardGap),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: _CompanyProfileSpacing.cardGap),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  _companyDetails[index].$1,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Text(
                  _nonEmpty(_companyDetails[index].$2)!,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.mainText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _goToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
  }
}
