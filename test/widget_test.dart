import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alco_company_profile/app.dart';
import 'package:alco_company_profile/screens/dashboard_screen.dart';
import 'package:alco_company_profile/screens/login_screen.dart';
import 'package:alco_company_profile/screens/splash_screen.dart';
import 'package:alco_company_profile/screens/destination_placeholder_screen.dart';
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
    expect(find.byType(DashboardScreen), findsNothing);

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

    expect(find.text('Kartu ID wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Kartu ID and password each show required validation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      'some-password',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Kartu ID wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
      '123040014',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      '',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Kartu ID wajib diisi.'), findsNothing);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
  });

  testWidgets('Login displays centered Kartu ID and password fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());

    expect(find.text('Kartu ID'), findsOneWidget);
    expect(find.text('Masukkan Kartu ID Anda'), findsOneWidget);
    expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Lupa password?'), findsOneWidget);
    expect(find.byTooltip('Tampilkan sandi'), findsOneWidget);

    final title = tester.widget<Text>(find.text('Login'));
    final subtitle = tester.widget<Text>(find.text('Masuk ke akun Anda'));
    expect(title.textAlign, TextAlign.center);
    expect(subtitle.textAlign, TextAlign.center);

    final idCardField = tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
        matching: find.byType(EditableText),
      ),
    );
    expect(idCardField.keyboardType, TextInputType.text);
    expect(
      tester.getTopLeft(find.text('Lupa password?')).dy,
      lessThan(tester.getTopLeft(find.byKey(const Key('login-submit'))).dy),
    );
  });

  testWidgets('Login content is vertically centered with a two-line footer', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_loginHarness());

    expect(find.text('© 2026 PT. Alcotraindo Batam.'), findsOneWidget);
    expect(find.text('All rights reserved.'), findsOneWidget);

    final top = tester.getTopLeft(find.byType(AlcoLogo)).dy;
    final bottom = tester.getBottomRight(find.text('All rights reserved.')).dy;
    final screenCenter = tester.getSize(find.byType(Scaffold)).height / 2;
    expect(((top + bottom) / 2 - screenCenter).abs(), lessThan(1));
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

  testWidgets('Kartu ID and password share white field decoration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());

    final idCardFinder = find.widgetWithText(
      TextFormField,
      'Masukkan Kartu ID Anda',
    );
    final passwordFinder = find.widgetWithText(
      TextFormField,
      'Masukkan password',
    );
    final idCardInput = tester.widget<EditableText>(
      find.descendant(
        of: idCardFinder,
        matching: find.byType(EditableText),
      ),
    );
    final passwordInput = tester.widget<EditableText>(
      find.descendant(
        of: passwordFinder,
        matching: find.byType(EditableText),
      ),
    );
    expect(idCardInput.textInputAction, TextInputAction.next);
    expect(passwordInput.textInputAction, TextInputAction.done);

    Color inputFillColor(Finder hintFinder) {
      return tester
          .widget<InputDecorator>(
            find.ancestor(
              of: hintFinder,
              matching: find.byType(InputDecorator),
            ),
          )
          .decoration
          .fillColor!;
    }

    final idleIdCardFillColor = inputFillColor(
      find.text('Masukkan Kartu ID Anda'),
    );
    expect(idleIdCardFillColor, Colors.white);
    expect(
      inputFillColor(find.text('Masukkan password')),
      idleIdCardFillColor,
    );

    await tester.tap(idCardFinder);
    await tester.pump();

    final focusedIdCardFillColor = inputFillColor(
      find.text('Masukkan Kartu ID Anda'),
    );
    expect(focusedIdCardFillColor, Colors.white);
    expect(
      inputFillColor(find.text('Masukkan password')),
      focusedIdCardFillColor,
    );
  });

  testWidgets('Invalid demo credentials show an error and stay on Login', (
    WidgetTester tester,
  ) async {
    final invalidCredentials = [
      ('123040000', 'Password'),
      ('123040014', 'wrong-password'),
      ('WRONG001', 'wrong-password'),
    ];

    for (final (idCard, password) in invalidCredentials) {
      await tester.pumpWidget(_loginHarness());
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
        idCard,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Masukkan password'),
        password,
      );
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();

      expect(find.text('Kartu ID atau password tidak sesuai.'), findsOneWidget);
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(DashboardScreen), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Editing credentials clears the login error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_loginHarness());
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
      '123040000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      'wrong-password',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Kartu ID atau password tidak sesuai.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
      '123040014',
    );
    await tester.pumpAndSettle();
    expect(find.text('Kartu ID atau password tidak sesuai.'), findsNothing);
  });

  testWidgets('Correct demo credentials replace Login with Dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlcoApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan Kartu ID Anda'),
      ' 123040014 ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      'Password',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.byKey(const Key('alco-logo')), findsOneWidget);
    expect(find.text('Selamat datang di ALCO'), findsOneWidget);
    expect(find.text('Akses Cepat'), findsOneWidget);
    expect(find.byKey(const Key('dashboard-company-summary')), findsOneWidget);
    expect(find.byType(DestinationPlaceholderScreen), findsNothing);
    expect(
      Navigator.of(tester.element(find.byType(DashboardScreen))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
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

  testWidgets('Splash and Login screen fit a small screen', (
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
