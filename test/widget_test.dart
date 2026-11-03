import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alco_company_profile/app.dart';
import 'package:alco_company_profile/screens/login_placeholder_screen.dart';
import 'package:alco_company_profile/screens/splash_screen.dart';
import 'package:alco_company_profile/widgets/alco_logo.dart';

void main() {
  test('ALCO vector is transparent and uses colors visible on Splash', () async {
    final svg = await rootBundle.loadString(
      'assets/images/alco_logo_vector.svg',
    );

    expect(svg, contains('fill="#002E17"'));
    expect(svg, contains('fill="#96BA37"'));
    expect(svg, isNot(contains('<rect')));
    expect(svg, isNot(contains('<image')));
  });

  testWidgets('Splash displays the logo then replaces itself with Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlcoApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    final logo = tester.widget<SvgPicture>(find.byKey(const Key('alco-logo')));
    expect(logo.fit, BoxFit.contain);
    expect(find.byType(LoginPlaceholderScreen), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.text('Login'), findsOneWidget);
    expect(
      find.text('Halaman Login akan diimplementasikan pada TASK 04.'),
      findsOneWidget,
    );
    expect(
      Navigator.of(tester.element(find.byType(LoginPlaceholderScreen)))
          .canPop(),
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
