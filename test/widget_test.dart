import 'package:flutter_test/flutter_test.dart';
import 'package:alco_company_profile/app.dart';

void main() {
  testWidgets('App foundation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AlcoApp());
    await tester.pumpAndSettle();

    expect(find.text('ALCO Company Profile'), findsOneWidget);
    expect(find.text('Task 01 Foundation Ready'), findsOneWidget);
  });
}
