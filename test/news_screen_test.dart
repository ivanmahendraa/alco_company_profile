import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:alco_company_profile/data/news_data.dart';
import 'package:alco_company_profile/models/news_item.dart';
import 'package:alco_company_profile/providers/news_provider.dart';
import 'package:alco_company_profile/screens/news_screen.dart';
import 'package:alco_company_profile/utils/app_routes.dart';
import 'package:alco_company_profile/widgets/news_card.dart';

Widget _buildNewsApp({List<NewsItem> items = newsItems}) {
  return ChangeNotifierProvider(
    create: (_) => NewsProvider(),
    child: MaterialApp(
      home: NewsScreen(items: items),
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.newsDetail) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) =>
                Scaffold(body: Text('Detail ID: ${settings.arguments}')),
          );
        }
        if (settings.name == AppRoutes.dashboard) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const Scaffold(body: Text('Dashboard tujuan')),
          );
        }
        return null;
      },
    ),
  );
}

int _newsListChildCount(WidgetTester tester) {
  final list = tester.widget<ListView>(find.byKey(const Key('news-list')));
  return (list.childrenDelegate as SliverChildBuilderDelegate).childCount!;
}

void main() {
  testWidgets('shows local news cards and Indonesian search field', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNewsApp());

    expect(find.text('Berita dan Aktivitas'), findsOneWidget);
    expect(find.byKey(const Key('news-search-field')), findsOneWidget);
    expect(_newsListChildCount(tester), newsItems.length * 2 - 1);
    expect(find.text(newsItems.first.title), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('search filters title and summary case-insensitively', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNewsApp());
    final searchField = find.byKey(const Key('news-search-field'));

    await tester.enterText(searchField, 'aNnUaL mEdIcAl');
    await tester.pumpAndSettle();
    expect(find.byType(NewsCard), findsOneWidget);
    expect(find.text(newsItems.first.title), findsOneWidget);

    await tester.enterText(searchField, 'PEMERIKSAAN KESEHATAN');
    await tester.pumpAndSettle();
    expect(find.byType(NewsCard), findsOneWidget);
    expect(find.text(newsItems.first.title), findsOneWidget);

    await tester.enterText(searchField, 'kata yang tidak ditemukan');
    await tester.pumpAndSettle();
    expect(find.byType(NewsCard), findsNothing);
    expect(find.text('Berita tidak ditemukan'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pumpAndSettle();
    expect(_newsListChildCount(tester), newsItems.length * 2 - 1);
  });

  testWidgets('empty local data shows a helpful empty state', (tester) async {
    await tester.pumpWidget(_buildNewsApp(items: const []));

    expect(find.text('Belum ada berita atau aktivitas'), findsOneWidget);
    expect(
      find.text('Berita dan aktivitas akan ditampilkan di sini.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('bookmark toggles and selecting a card opens its detail route', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNewsApp());

    final firstCard = find.byKey(Key('news-card-${newsItems.first.id}'));
    final bookmarkButtonSize = tester.getSize(
      find.byTooltip('Simpan bookmark').first,
    );
    expect(bookmarkButtonSize.width, greaterThanOrEqualTo(48));
    expect(bookmarkButtonSize.height, greaterThanOrEqualTo(48));
    await tester.tap(
      find.descendant(
        of: firstCard,
        matching: find.byIcon(Icons.bookmark_border),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: firstCard, matching: find.byIcon(Icons.bookmark)),
      findsOneWidget,
    );

    await tester.tap(find.text(newsItems.first.title));
    await tester.pumpAndSettle();
    expect(find.text('Detail ID: ${newsItems.first.id}'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back button returns to Dashboard', (tester) async {
    await tester.pumpWidget(_buildNewsApp());

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard tujuan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('system back returns to Dashboard', (tester) async {
    await tester.pumpWidget(_buildNewsApp());

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Dashboard tujuan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('list fits narrow portrait and landscape viewports', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(320, 480), const Size(800, 360)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(_buildNewsApp());
      await tester.pumpAndSettle();

      expect(find.byType(NewsScreen), findsOneWidget);
      expect(_newsListChildCount(tester), newsItems.length * 2 - 1);
      expect(tester.takeException(), isNull);
    }
  });
}
