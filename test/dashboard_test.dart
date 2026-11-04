import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alco_company_profile/app.dart';
import 'package:alco_company_profile/data/company_data.dart';
import 'package:alco_company_profile/data/news_data.dart';
import 'package:alco_company_profile/screens/business_info_screen.dart';
import 'package:alco_company_profile/screens/company_profile_screen.dart';
import 'package:alco_company_profile/screens/dashboard_screen.dart';
import 'package:alco_company_profile/screens/destination_placeholder_screen.dart';
import 'package:alco_company_profile/screens/news_screen.dart';
import 'package:alco_company_profile/widgets/alco_logo.dart';
import 'package:alco_company_profile/widgets/info_card.dart';
import 'package:alco_company_profile/widgets/news_card.dart';

Future<void> _openDashboard(WidgetTester tester) async {
  await tester.pumpWidget(const AlcoApp());
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
    '123040014',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Masukkan password'),
    'Password',
  );
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Dashboard uses local profile data and previews up to 3 news', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Selamat datang di ALCO'), findsOneWidget);
    expect(
      find.text(
        'Jelajahi profil perusahaan, informasi bisnis, dan berita terbaru.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('dashboard-welcome-hero')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-header')), findsOneWidget);
    expect(find.byKey(const Key('alco-logo')), findsOneWidget);
    final headerLogo = tester.widget<AlcoLogo>(find.byType(AlcoLogo));
    expect(headerLogo.height, 40);
    expect(headerLogo.width, isNull);
    final header = tester.widget<AppBar>(
      find.byKey(const Key('dashboard-header')),
    );
    expect(header.toolbarHeight, 64);
    final headerRect = tester.getRect(
      find.byKey(const Key('dashboard-header')),
    );
    final logoRect = tester.getRect(find.byKey(const Key('alco-logo')));
    expect((logoRect.center.dy - headerRect.center.dy).abs(), lessThan(1));
    expect(
      logoRect.left,
      closeTo(
        tester.getRect(find.byKey(const Key('dashboard-welcome-hero'))).left,
        1,
      ),
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('dashboard-header')),
        matching: find.text('Beranda'),
      ),
      findsNothing,
    );
    expect(
      find.byKey(const Key('dashboard-view-profile-link')),
      findsOneWidget,
    );
    expect(
      tester
          .getSize(find.byKey(const Key('dashboard-view-profile-link')))
          .height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getRect(find.byKey(const Key('dashboard-welcome-hero'))).bottom -
          tester.getRect(find.text('Lihat Profil')).bottom,
      closeTo(17, 1),
    );
    expect(
      tester
          .getSize(find.byKey(const Key('dashboard-business-info-link')))
          .height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester
              .getRect(find.byKey(const Key('dashboard-company-summary')))
              .bottom -
          tester.getRect(find.text('Lihat Informasi Bisnis')).bottom,
      closeTo(17, 1),
    );
    final summaryCard = tester.widget<InfoCard>(
      find.byKey(const Key('dashboard-company-summary')),
    );
    expect(summaryCard.padding, const EdgeInsets.all(16));
    expect(summaryCard.borderRadius, 14);
    expect(summaryCard.centerTitleWithIcon, isTrue);
    final summaryTitle = find.descendant(
      of: find.byKey(const Key('dashboard-company-summary')),
      matching: find.text(companyInfo.name),
    );
    final summaryIcon = find.descendant(
      of: find.byKey(const Key('dashboard-company-summary')),
      matching: find.byIcon(Icons.business_outlined),
    );
    expect(
      (tester.getRect(summaryTitle).center.dy -
              tester.getRect(summaryIcon).center.dy)
          .abs(),
      lessThan(1),
    );
    for (final quickAccessKey in [
      const Key('quick-access-company'),
      const Key('quick-access-business'),
      const Key('quick-access-news'),
    ]) {
      final quickAccessCard = tester.widget<InfoCard>(
        find.descendant(
          of: find.byKey(quickAccessKey),
          matching: find.byType(InfoCard),
        ),
      );
      expect(quickAccessCard.padding, const EdgeInsets.all(16));
      expect(quickAccessCard.borderRadius, 14);
    }
    expect(
      find.descendant(
        of: find.byKey(const Key('dashboard-header')),
        matching: find.text('PT. Alcotraindo Batam'),
      ),
      findsNothing,
    );
    expect(find.text(companyInfo.name), findsOneWidget);
    expect(find.text('Akses Cepat'), findsOneWidget);
    expect(find.text('Berita Terbaru'), findsOneWidget);
    expect(find.byType(NewsCard), findsNWidgets(3));
    expect(find.byType(Image), findsOneWidget);
    expect(
      tester.widget<Image>(find.byType(Image)).semanticLabel,
      contains('Simulasi Annual Medical Check Up'),
    );
    for (final news in newsItems.take(3)) {
      expect(find.text(news.title), findsOneWidget);
    }
    expect(find.text(companyInfo.phone!), findsNothing);
    expect(find.text(companyInfo.address!), findsNothing);
    expect(companyInfo.vision, isNull);
    expect(tester.takeException(), isNull);

    double gapBetween(Finder first, Finder second) {
      return tester.getTopLeft(second).dy - tester.getBottomLeft(first).dy;
    }

    expect(
      gapBetween(
        find.byKey(const Key('dashboard-welcome-hero')),
        find.byKey(const Key('dashboard-company-summary')),
      ),
      12,
    );
    expect(
      gapBetween(
        find.byKey(const Key('dashboard-company-summary')),
        find.text('Akses Cepat'),
      ),
      24,
    );
    expect(
      gapBetween(
        find.text('Akses Cepat'),
        find.byKey(const Key('quick-access-company')),
      ),
      12,
    );
    expect(
      gapBetween(
        find.byKey(const Key('quick-access-company')),
        find.byKey(const Key('quick-access-business')),
      ),
      12,
    );
    expect(
      gapBetween(
        find.byKey(const Key('quick-access-business')),
        find.byKey(const Key('quick-access-news')),
      ),
      12,
    );
    expect(
      gapBetween(
        find.byKey(const Key('quick-access-news')),
        find.text('Berita Terbaru'),
      ),
      24,
    );
    expect(
      gapBetween(
        find.text('Berita Terbaru'),
        find.byKey(Key('dashboard-news-${newsItems.first.id}')),
      ),
      12,
    );
    expect(
      gapBetween(
        find.byKey(Key('dashboard-news-${newsItems[0].id}')),
        find.byKey(Key('dashboard-news-${newsItems[1].id}')),
      ),
      12,
    );
  });

  test('Dashboard greeting follows device-local hour boundaries', () {
    expect(dashboardGreeting(DateTime(2026, 1, 1, 3, 59)), 'Selamat malam');
    expect(dashboardGreeting(DateTime(2026, 1, 1, 4)), 'Selamat pagi');
    expect(dashboardGreeting(DateTime(2026, 1, 1, 10, 59)), 'Selamat pagi');
    expect(dashboardGreeting(DateTime(2026, 1, 1, 11)), 'Selamat siang');
    expect(dashboardGreeting(DateTime(2026, 1, 1, 14, 59)), 'Selamat siang');
    expect(dashboardGreeting(DateTime(2026, 1, 1, 15)), 'Selamat sore');
    expect(dashboardGreeting(DateTime(2026, 1, 1, 17, 59)), 'Selamat sore');
    expect(dashboardGreeting(DateTime(2026, 1, 1, 18)), 'Selamat malam');
  });

  testWidgets('Dashboard shortcuts and news preview open matching screens', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);

    await tester.tap(find.byKey(const Key('dashboard-view-profile-link')));
    await tester.pumpAndSettle();
    expect(find.byType(CompanyProfileScreen), findsOneWidget);
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('dashboard-business-info-link')));
    await tester.pumpAndSettle();
    expect(find.byType(BusinessInfoScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dashboard-company-summary')));
    await tester.pumpAndSettle();
    expect(find.byType(BusinessInfoScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('quick-access-business')));
    await tester.tap(find.byKey(const Key('quick-access-business')));
    await tester.pumpAndSettle();
    expect(find.byType(BusinessInfoScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('quick-access-company')));
    await tester.tap(find.byKey(const Key('quick-access-company')));
    await tester.pumpAndSettle();
    expect(find.byType(CompanyProfileScreen), findsOneWidget);

    await tester.tap(find.text('Berita'));
    await tester.pumpAndSettle();
    expect(find.byType(NewsScreen), findsOneWidget);
    expect(find.byKey(const Key('news-list')), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(Key('dashboard-news-${newsItems.first.id}')),
    );
    await tester.tap(find.text(newsItems.first.title));
    await tester.pumpAndSettle();
    expect(find.byType(DestinationPlaceholderScreen), findsOneWidget);
    expect(find.text(newsItems.first.title), findsOneWidget);
    expect(
      find.text('Layar Detail Berita akan dibuat pada Task 09.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('all non-Dashboard placeholders show a labeled back button', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);

    expect(find.byTooltip('Kembali'), findsNothing);

    await tester.tap(find.text('Perusahaan'));
    await tester.pumpAndSettle();
    expect(find.text('Profil Perusahaan'), findsOneWidget);
    expect(find.byTooltip('Kembali'), findsOneWidget);
    final backButton = tester.getRect(find.byTooltip('Kembali'));
    expect(backButton.width, greaterThanOrEqualTo(48));
    expect(backButton.height, greaterThanOrEqualTo(48));

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dashboard-business-info-link')));
    await tester.pumpAndSettle();
    expect(find.text('Informasi Bisnis'), findsOneWidget);
    expect(find.byTooltip('Kembali'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);

    await tester.tap(find.text('Berita'));
    await tester.pumpAndSettle();
    expect(find.text('Berita dan Aktivitas'), findsOneWidget);
    expect(find.byTooltip('Kembali'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(Key('dashboard-news-${newsItems.first.id}')),
    );
    await tester.tap(find.text(newsItems.first.title));
    await tester.pumpAndSettle();
    expect(find.text('Detail Berita'), findsOneWidget);
    expect(find.byTooltip('Kembali'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Berita dan Aktivitas'), findsOneWidget);
    expect(find.byTooltip('Kembali'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(DashboardScreen))).canPop(),
      isFalse,
    );
  });

  testWidgets('Dashboard quick access opens the populated News screen', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);

    await tester.ensureVisible(find.byKey(const Key('quick-access-news')));
    await tester.tap(find.byKey(const Key('quick-access-news')));
    await tester.pumpAndSettle();

    expect(find.byType(NewsScreen), findsOneWidget);
    expect(find.byKey(const Key('news-search-field')), findsOneWidget);
    expect(find.text(newsItems.first.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'system back from Company and News returns to Dashboard without stacking',
    (WidgetTester tester) async {
      await _openDashboard(tester);

      await tester.tap(find.text('Perusahaan'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(DashboardScreen))).canPop(),
        isFalse,
      );

      await tester.tap(find.text('Berita'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(DashboardScreen))).canPop(),
        isFalse,
      );
    },
  );

  testWidgets('Dashboard fits narrow portrait and landscape viewports', (
    WidgetTester tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final size in [const Size(320, 480), const Size(800, 360)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const AlcoApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
        '123040014',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Masukkan password'),
        'Password',
      );
      await tester.ensureVisible(find.byKey(const Key('login-submit')));
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
