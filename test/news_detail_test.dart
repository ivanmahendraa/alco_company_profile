import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:alco_company_profile/data/news_data.dart';
import 'package:alco_company_profile/models/news_item.dart';
import 'package:alco_company_profile/providers/news_provider.dart';
import 'package:alco_company_profile/screens/news_detail_screen.dart';
import 'package:alco_company_profile/screens/news_screen.dart';
import 'package:alco_company_profile/utils/app_routes.dart';
import 'package:alco_company_profile/widgets/news_card.dart';

Widget _buildNewsApp({List<NewsItem> items = newsItems, Widget? home}) {
  return ChangeNotifierProvider(
    create: (_) => NewsProvider(),
    child: MaterialApp(
      home: home ?? NewsScreen(items: items),
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.newsDetail) {
          final newsId = settings.arguments;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => NewsDetailScreen(
              newsId: newsId is String ? newsId : null,
              items: items,
            ),
          );
        }
        return null;
      },
    ),
  );
}

void main() {
  testWidgets('shows selected item details and each available local image', (
    tester,
  ) async {
    final reorderedItems = newsItems.reversed.toList();
    for (final item in newsItems.take(3)) {
      await tester.pumpWidget(
        _buildNewsApp(
          items: reorderedItems,
          home: NewsDetailScreen(newsId: item.id, items: reorderedItems),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Detail Berita'), findsOneWidget);
      expect(find.text(item.category), findsOneWidget);
      expect(find.text(item.date), findsOneWidget);
      expect(find.text(item.title), findsOneWidget);
      expect(find.text(item.summary), findsOneWidget);
      expect(find.text(item.content), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      final resizedImage = image.image as ResizeImage;
      expect(resizedImage.imageProvider, isA<AssetImage>());
      expect(
        (resizedImage.imageProvider as AssetImage).assetName,
        item.imageAsset,
      );
      expect(image.semanticLabel, contains(item.title));
      expect(image.fit, BoxFit.cover);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('preserves search and shares bookmark state on return', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNewsApp());
    await tester.enterText(
      find.byKey(const Key('news-search-field')),
      'annual',
    );
    await tester.pumpAndSettle();

    expect(find.byType(NewsCard), findsOneWidget);
    await tester.tap(find.text(newsItems.first.title));
    await tester.pumpAndSettle();
    expect(find.byType(NewsDetailScreen), findsOneWidget);

    final bookmarkButton = find.byKey(const Key('news-detail-bookmark'));
    expect(tester.getSize(bookmarkButton).height, greaterThanOrEqualTo(48));
    expect(find.text('Simpan bookmark'), findsOneWidget);
    await tester.ensureVisible(bookmarkButton);
    await tester.tap(bookmarkButton);
    await tester.pumpAndSettle();
    expect(find.text('Hapus bookmark'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(NewsScreen), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('news-search-field')))
          .controller!
          .text,
      'annual',
    );
    expect(find.byType(NewsCard), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail for an item without an image omits the image area', (
    tester,
  ) async {
    final itemWithoutImage = newsItems[3];
    await tester.pumpWidget(
      _buildNewsApp(home: NewsDetailScreen(newsId: itemWithoutImage.id)),
    );

    expect(find.text(itemWithoutImage.title), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid image asset displays a neutral fallback safely', (
    tester,
  ) async {
    const item = NewsItem(
      id: 'item-with-missing-image',
      title: 'Berita dengan aset gambar tidak tersedia',
      category: 'Contoh Fiktif • Contoh',
      date: '04 November 2026',
      summary: 'Skenario fiktif untuk menguji tampilan gambar.',
      content: 'Contoh fiktif.',
      imageAsset: 'assets/images/news/missing.jpg',
    );
    await tester.pumpWidget(
      _buildNewsApp(
        items: const [item],
        home: NewsDetailScreen(newsId: item.id, items: const [item]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(item.title), findsOneWidget);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    expect(find.text('null'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown ID shows a safe fallback and back action', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildNewsApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.newsDetail, arguments: 'unknown-news-id'),
              child: const Text('Buka berita tidak dikenal'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka berita tidak dikenal'));
    await tester.pumpAndSettle();

    expect(find.byType(NewsDetailScreen), findsOneWidget);
    expect(find.text('Berita tidak ditemukan'), findsOneWidget);
    expect(
      find.text('Data berita yang diminta tidak tersedia.'),
      findsOneWidget,
    );
    expect(find.text('null'), findsNothing);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Buka berita tidak dikenal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('malformed detail route arguments show the safe fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildNewsApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(AppRoutes.newsDetail, arguments: newsItems.first),
              child: const Text('Buka dengan argumen yang salah'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka dengan argumen yang salah'));
    await tester.pumpAndSettle();

    expect(find.text('Berita tidak ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail content fits narrow portrait and landscape screens', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(320, 480), const Size(800, 360)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        _buildNewsApp(home: NewsDetailScreen(newsId: newsItems.first.id)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NewsDetailScreen), findsOneWidget);
      expect(find.text(newsItems.first.title), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
