import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alco_company_profile/app.dart';
import 'package:alco_company_profile/data/company_data.dart';
import 'package:alco_company_profile/models/company_info.dart';
import 'package:alco_company_profile/screens/company_profile_screen.dart';
import 'package:alco_company_profile/screens/dashboard_screen.dart';
import 'package:alco_company_profile/screens/destination_placeholder_screen.dart';
import 'package:alco_company_profile/utils/app_colors.dart';
import 'package:alco_company_profile/widgets/alco_logo.dart';

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
  testWidgets('Company profile displays all supplied company data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CompanyProfileScreen()));

    expect(find.text('Profil Perusahaan'), findsOneWidget);
    expect(find.byType(AlcoLogo), findsOneWidget);
    expect(find.text(companyInfo.name), findsOneWidget);
    expect(find.text('Tentang Kami'), findsOneWidget);
    expect(find.text(companyInfo.overview), findsOneWidget);
    expect(find.text('Misi'), findsOneWidget);
    expect(find.text(companyInfo.mission!), findsOneWidget);
    expect(find.text('Nilai Perusahaan'), findsOneWidget);
    for (final value in companyInfo.values) {
      expect(find.text(value), findsOneWidget);
    }
    expect(find.text('Kebijakan Mutu'), findsOneWidget);
    for (final policy in companyInfo.qualityPolicies) {
      expect(find.text(policy), findsOneWidget);
    }
    expect(find.text('Komitmen Perusahaan'), findsOneWidget);
    expect(find.text(companyInfo.commitment!), findsOneWidget);
    expect(find.text('Ringkasan Perusahaan'), findsOneWidget);
    expect(find.text('Alamat'), findsOneWidget);
    expect(find.text(companyInfo.address!), findsOneWidget);
    expect(find.text('Telepon'), findsOneWidget);
    expect(find.text(companyInfo.phone!), findsOneWidget);
    expect(find.text('Industri'), findsOneWidget);
    expect(find.text(companyInfo.industry!), findsOneWidget);
    expect(find.text('Tahun Pendirian'), findsOneWidget);
    expect(find.text(companyInfo.foundingYear!), findsOneWidget);
    expect(find.text('Jenis Perusahaan'), findsOneWidget);
    expect(find.text(companyInfo.companyType!), findsOneWidget);
    expect(find.text('Ukuran Perusahaan'), findsOneWidget);
    expect(find.text(companyInfo.employeeRange!), findsOneWidget);
    expect(find.text('Kantor Pusat'), findsOneWidget);
    expect(find.text(companyInfo.headquarters!), findsOneWidget);
    expect(find.text('Visi'), findsNothing);
    expect(find.text('null'), findsNothing);
    final businessLink = tester.widget<Text>(
      find.text('Lihat Informasi Bisnis'),
    );
    expect(businessLink.style?.color, AppColors.primaryGreen);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Empty optional fields and sections are omitted safely', (
    WidgetTester tester,
  ) async {
    const emptyInfo = CompanyInfo(
      name: 'Perusahaan Contoh',
      overview: ' ',
      businessDescription: '',
      values: [],
      qualityPolicies: [],
      vision: null,
      mission: ' ',
      commitment: null,
      address: '',
      phone: null,
      industry: ' ',
      foundingYear: null,
      companyType: '',
      employeeRange: null,
      headquarters: ' ',
    );
    await tester.pumpWidget(
      const MaterialApp(home: CompanyProfileScreen(companyInfo: emptyInfo)),
    );

    expect(find.text('Perusahaan Contoh'), findsOneWidget);
    expect(find.text('Tentang Kami'), findsNothing);
    expect(find.text('Misi'), findsNothing);
    expect(find.text('Nilai Perusahaan'), findsNothing);
    expect(find.text('Kebijakan Mutu'), findsNothing);
    expect(find.text('Komitmen Perusahaan'), findsNothing);
    expect(find.text('Ringkasan Perusahaan'), findsNothing);
    expect(find.text('Visi'), findsNothing);
    expect(find.text('null'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Company navigation highlights Perusahaan and back returns home',
    (WidgetTester tester) async {
      await _openDashboard(tester);
      await tester.tap(find.byKey(const Key('dashboard-view-profile-link')));
      await tester.pumpAndSettle();

      expect(find.byType(CompanyProfileScreen), findsOneWidget);
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1,
      );
      expect(find.byTooltip('Kembali'), findsOneWidget);
      await tester.tap(find.byTooltip('Kembali'));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(DashboardScreen))).canPop(),
        isFalse,
      );
    },
  );

  testWidgets('Android system back from company profile returns home', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);
    await tester.tap(find.text('Perusahaan'));
    await tester.pumpAndSettle();
    expect(find.byType(CompanyProfileScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(DashboardScreen))).canPop(),
      isFalse,
    );
  });

  testWidgets('Business information shortcut opens its placeholder', (
    WidgetTester tester,
  ) async {
    await _openDashboard(tester);
    await tester.tap(find.text('Perusahaan'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Lihat Informasi Bisnis'));
    await tester.tap(find.text('Lihat Informasi Bisnis'));
    await tester.pumpAndSettle();

    expect(find.byType(DestinationPlaceholderScreen), findsOneWidget);
    expect(find.text('Informasi Bisnis'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Company profile scrolls on narrow and landscape screens', (
    WidgetTester tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(320, 480), const Size(800, 360)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const MaterialApp(home: CompanyProfileScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text(companyInfo.address!));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Lihat Informasi Bisnis'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
