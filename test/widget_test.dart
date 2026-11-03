import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alco_company_profile/app.dart';
import 'package:alco_company_profile/screens/dashboard_placeholder_screen.dart';
import 'package:alco_company_profile/screens/login_screen.dart';
import 'package:alco_company_profile/screens/splash_screen.dart';
import 'package:alco_company_profile/widgets/alco_logo.dart';

Widget _loginHarness() {
  return const MaterialApp(home: LoginScreen());
}

void main() {
  test(
    'ALCO vector is transparent and uses colors visible on Splash',
    () async {
      final svg = await rootBundle.loadString(
        'assets/images/alco_logo_vector.svg',
      );

      expect(svg, contains('fill="#002E17"'));
      expect(svg, contains('fill="#96BA37"'));
      expect(svg, isNot(contains('<rect')));
      expect(svg, isNot(contains('<image')));
    },
  );

  testWidgets('Splash displays the logo then replaces itself with Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlcoApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    final logo = tester.widget<SvgPicture>(find.byKey(const Key('alco-logo')));
    expect(logo.fit, BoxFit.contain);
    expect(find.byType(DashboardPlaceholderScreen), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(LoginScreen))).canPop(),
      isFalse,
    );
  });

  testWidgets('Splash timer is cancelled when the screen is disposed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlcoApp());
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 3));

    expect(tester.takeException(), isNull);
  });

  testWidgets('Login shows required validation for both empty fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());

    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Email and password each show required validation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      'some-password',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan email'),
      'demo@alco.local',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      '',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi.'), findsNothing);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
  });

  testWidgets('Login password is hidden by default and can be toggled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());

    var editableText = tester.widget<EditableText>(
      find.byType(EditableText).last,
    );
    expect(editableText.obscureText, isTrue);

    await tester.tap(find.byTooltip('Tampilkan sandi'));
    await tester.pumpAndSettle();
    editableText = tester.widget<EditableText>(find.byType(EditableText).last);
    expect(editableText.obscureText, isFalse);

    await tester.tap(find.byTooltip('Sembunyikan sandi'));
    await tester.pumpAndSettle();
    editableText = tester.widget<EditableText>(find.byType(EditableText).last);
    expect(editableText.obscureText, isTrue);
  });

  testWidgets('Email field accent is configurable without changing password', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());

    final emailField = tester.widget<InputDecorator>(
      find.ancestor(
        of: find.text('Masukkan email'),
        matching: find.byType(InputDecorator),
      ),
    );
    expect(emailField.decoration.fillColor, const Color(0xFFE8F0FE));

    final passwordField = tester.widget<InputDecorator>(
      find.ancestor(
        of: find.text('Masukkan password'),
        matching: find.byType(InputDecorator),
      ),
    );
    expect(passwordField.decoration.fillColor, Colors.white);
  });

  testWidgets('Invalid demo credentials show an error and stay on Login', (
    WidgetTester tester,
  ) async {
    final invalidCredentials = [
      ('wrong@alco.local', 'AlcoDemo2026!'),
      ('demo@alco.local', 'wrong-password'),
      ('wrong@alco.local', 'wrong-password'),
    ];

    for (final (email, password) in invalidCredentials) {
      await tester.pumpWidget(_loginHarness());
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Masukkan email'),
        email,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Masukkan password'),
        password,
      );
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();

      expect(find.text('Email atau password tidak sesuai.'), findsOneWidget);
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(DashboardPlaceholderScreen), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Editing credentials clears the login error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan email'),
      'wrong@alco.local',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      'wrong-password',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Email atau password tidak sesuai.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan email'),
      'demo@alco.local',
    );
    await tester.pumpAndSettle();
    expect(find.text('Email atau password tidak sesuai.'), findsNothing);
  });

  testWidgets('Correct demo credentials replace Login with Dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlcoApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan email'),
      'demo@alco.local',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      'AlcoDemo2026!',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardPlaceholderScreen), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(
      find.text('Dashboard akan diimplementasikan pada TASK 05.'),
      findsOneWidget,
    );
    expect(
      Navigator.of(tester.element(find.byType(DashboardPlaceholderScreen)))
          .canPop(),
      isFalse,
    );
  });

  testWidgets(
    'Login remains scrollable when the keyboard reduces the viewport',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 960);
      tester.view.devicePixelRatio = 2;
      tester.view.viewInsets = const FakeViewPadding(bottom: 360);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(_loginHarness());
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('Masuk'));
      await tester.pumpAndSettle();
      expect(find.text('Masuk'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Splash and Login placeholder fit a small screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(640, 960);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AlcoApp());
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AlcoLogo can be reused at different sizes without stretching', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlcoLogo(key: Key('small-logo'), width: 120, height: 80),
            AlcoLogo(key: Key('large-logo'), width: 240, height: 100),
          ],
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsNWidgets(2));
    expect(
      tester.getSize(find.byKey(const Key('small-logo'))),
      const Size(120, 80),
    );
    expect(
      tester.getSize(find.byKey(const Key('large-logo'))),
      const Size(240, 100),
    );
    expect(tester.takeException(), isNull);
  });
}
