import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alco_company_profile/app.dart';
import 'package:alco_company_profile/data/company_data.dart';
import 'package:alco_company_profile/data/news_data.dart';
import 'package:alco_company_profile/screens/dashboard_screen.dart';
import 'package:alco_company_profile/screens/destination_placeholder_screen.dart';
import 'package:alco_company_profile/widgets/news_card.dart';

Future<void> _openDashboard(WidgetTester tester) async {
  await tester.pumpWidget(const AlcoApp());
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Masukkan ID Card Anda'),
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
    expect(find.text('Selamat datang'), findsOneWidget);
    expect(find.text(companyInfo.name), findsOneWidget);
    expect(find.text('Akses Cepat'), findsOneWidget);
    expect(find.text('Berita Terbaru'), findsOneWidget);
    expect(find.byType(NewsCard), findsNWidgets(3));
    for (final news in newsItems.take(3)) {
      expect(find.text(news.title), findsOneWidget);
    }
    expect(find.text(companyInfo.phone!), findsNothing);
    expect(find.text(companyInfo.address!), findsNothing);
    expect(companyInfo.vision, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Dashboard shortcuts and news preview open matching placeholders',
    (WidgetTester tester) async {
      await _openDashboard(tester);

      await tester.tap(find.byKey(const Key('dashboard-company-summary')));
      await tester.pumpAndSettle();
      expect(
        find.text('Layar Informasi Bisnis akan dibuat pada Task 07.'),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('quick-access-business')),
      );
      await tester.tap(find.byKey(const Key('quick-access-business')));
      await tester.pumpAndSettle();
      expect(
        find.text('Layar Informasi Bisnis akan dibuat pada Task 07.'),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('quick-access-company')));
      await tester.tap(find.byKey(const Key('quick-access-company')));
      await tester.pumpAndSettle();
      expect(
        find.text('Layar Profil Perusahaan akan dibuat pada Task 06.'),
        findsOneWidget,
      );

      await tester.tap(find.text('News'));
      await tester.pumpAndSettle();
      expect(
        find.text('Layar Berita dan Aktivitas akan dibuat pada Task 08.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Home'));
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
        find.widgetWithText(TextFormField, 'Masukkan ID Card Anda'),
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
