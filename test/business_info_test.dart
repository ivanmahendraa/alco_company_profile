import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alco_company_profile/app.dart';
import 'package:alco_company_profile/data/business_data.dart' as business_data;
import 'package:alco_company_profile/data/company_data.dart';
import 'package:alco_company_profile/models/company_info.dart';
import 'package:alco_company_profile/screens/business_info_screen.dart';
import 'package:alco_company_profile/screens/company_profile_screen.dart';
import 'package:alco_company_profile/screens/dashboard_screen.dart';
import 'package:alco_company_profile/widgets/info_card.dart';

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
  testWidgets('Business screen displays local introduction and topics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BusinessInfoScreen()));

    expect(find.text(business_data.businessInfoScreenTitle), findsOneWidget);
    expect(find.text(companyInfo.name), findsOneWidget);
    expect(find.text(companyInfo.businessDescription), findsOneWidget);
    expect(business_data.businessTopics, hasLength(5));

    final visibleTopics = business_data.businessTopics.take(4).toList();
    for (final topic in visibleTopics) {
      expect(find.text(topic.title), findsOneWidget);
      expect(find.text(topic.description), findsOneWidget);
    }
    expect(find.text(business_data.businessTopics.last.title), findsNothing);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
    expect(find.byTooltip('Kembali'), findsOneWidget);
    expect(find.text('null'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Business content has no sales or promotional language', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BusinessInfoScreen()));

    final screenText = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data ?? '')
        .join(' ')
        .toLowerCase();
    expect(screenText, isNot(contains('beli')));
    expect(screenText, isNot(contains('pesan sekarang')));
    expect(screenText, isNot(contains('promo')));
    expect(screenText, isNot(contains('null')));
  });

  testWidgets('Empty business description and topics are omitted safely', (
    WidgetTester tester,
  ) async {
    const emptyCompanyInfo = CompanyInfo(
      name: '',
      overview: '',
      businessDescription: '  ',
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: BusinessInfoScreen(
          companyInfo: emptyCompanyInfo,
          topics: <business_data.BusinessTopic>[],
        ),
      ),
    );

    expect(find.text('null'), findsNothing);
    expect(find.byType(InfoCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Business back arrow returns to its Dashboard origin', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);
    await tester.ensureVisible(find.byKey(const Key('quick-access-business')));
    await tester.tap(find.byKey(const Key('quick-access-business')));
    await tester.pumpAndSettle();

    expect(find.byType(BusinessInfoScreen), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(DashboardScreen))).canPop(),
      isFalse,
    );
  });

  testWidgets('Business system back returns to its Company Profile origin', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);
    await tester.ensureVisible(find.byKey(const Key('quick-access-company')));
    await tester.tap(find.byKey(const Key('quick-access-company')));
    await tester.pumpAndSettle();
    expect(find.byType(CompanyProfileScreen), findsOneWidget);

    await tester.ensureVisible(find.text('Lihat Informasi Bisnis'));
    await tester.tap(find.text('Lihat Informasi Bisnis'));
    await tester.pumpAndSettle();
    expect(find.byType(BusinessInfoScreen), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(CompanyProfileScreen), findsOneWidget);
    expect(find.byTooltip('Kembali'), findsOneWidget);
  });

  testWidgets('Business screen fits phone and landscape layouts', (
    WidgetTester tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(320, 480), const Size(800, 360)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const MaterialApp(home: BusinessInfoScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.ensureVisible(
        find.text(business_data.businessTopics[3].description),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'Business Perusahaan tab opens Company Profile without stacking',
    (WidgetTester tester) async {
      await _openDashboard(tester);
      await tester.tap(find.byKey(const Key('quick-access-business')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Perusahaan'));
      await tester.pumpAndSettle();

      expect(find.byType(CompanyProfileScreen), findsOneWidget);
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
