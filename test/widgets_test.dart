import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alco_company_profile/models/news_item.dart';
import 'package:alco_company_profile/widgets/custom_app_bar.dart';
import 'package:alco_company_profile/widgets/custom_bottom_nav.dart';
import 'package:alco_company_profile/widgets/custom_button.dart';
import 'package:alco_company_profile/widgets/custom_text_field.dart';
import 'package:alco_company_profile/widgets/empty_state.dart';
import 'package:alco_company_profile/widgets/info_card.dart';
import 'package:alco_company_profile/widgets/news_card.dart';

void main() {
  group('CustomAppBar Tests', () {
    testWidgets('renders title and actions without back button when disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              title: 'Test Header',
              showBackButton: false,
              actions: [Icon(Icons.info, key: Key('info_icon'))],
            ),
          ),
        ),
      );

      expect(find.text('Test Header'), findsOneWidget);
      expect(find.byKey(const Key('info_icon')), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('renders back button and calls onBackPressed when tapped', (
      tester,
    ) async {
      bool backPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              title: 'Detail',
              showBackButton: true,
              onBackPressed: () {
                backPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(backPressed, isTrue);
    });
  });

  group('CustomButton Tests', () {
    testWidgets('PrimaryButton handles tap and displays content', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Submit',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      await tester.tap(find.text('Submit'));
      expect(tapped, isTrue);
    });

    testWidgets('PrimaryButton does not trigger tap when disabled or loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PrimaryButton(text: 'Disabled', onPressed: null),
                PrimaryButton(
                  text: 'Loading',
                  onPressed: null,
                  isLoading: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Disabled'),
      );
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('SecondaryButton handles tap and displays distinct style', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Cancel',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      expect(tapped, isTrue);
    });
  });

  group('InfoCard Tests', () {
    testWidgets('renders title, description, icon, and triggers onTap', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoCard(
              title: 'Company History',
              description: 'General historical description of PT. Alcotraindo.',
              icon: const Icon(Icons.history, key: Key('card_icon')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Company History'), findsOneWidget);
      expect(
        find.text('General historical description of PT. Alcotraindo.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('card_icon')), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      await tester.tap(find.text('Company History'));
      expect(tapped, isTrue);
    });
  });

  group('CustomTextField Tests', () {
    testWidgets('accepts input and handles validation error', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                label: 'Username',
                hintText: 'Enter your username',
                controller: controller,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Username is required.';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Enter your username'), findsOneWidget);

      // Validate empty field
      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('Username is required.'), findsOneWidget);

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'demo_user');
      expect(controller.text, 'demo_user');

      // Re-validate
      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('Username is required.'), findsNothing);
    });

    testWidgets('toggles password visibility when isPassword is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(label: 'Password', isPassword: true),
          ),
        ),
      );

      // Initially obscureText is true and eye icon is visibility_outlined
      final editableTextFinder = find.byType(EditableText);
      EditableText editableText = tester.widget(editableTextFinder);
      expect(editableText.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap toggle button
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      editableText = tester.widget(editableTextFinder);
      expect(editableText.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  group('NewsCard Tests', () {
    const testItem = NewsItem(
      id: 'news-1',
      title: 'Facility Expansion 2026',
      category: 'Activity',
      date: '03 Nov 2026',
      summary: 'Summary of the recent company facility expansion activity.',
      content: 'Detailed description of the activity.',
    );
    const medicalCheckUpItem = NewsItem(
      id: 'sample-activity-001',
      title: 'Simulasi Annual Medical Check Up Karyawan',
      category: 'Contoh Fiktif • Kesehatan Kerja',
      date: '04 November 2026',
      summary:
          'Skenario fiktif tentang pemeriksaan kesehatan berkala karyawan.',
      content: 'Contoh fiktif tentang kesehatan kerja.',
      imageAsset: 'assets/images/news/news_001.jpg',
    );
    const bukaPuasaItem = NewsItem(
      id: 'sample-activity-002',
      title: 'Simulasi Buka Puasa Bersama Karyawan dan Management',
      category: 'Contoh Fiktif • Kebersamaan Karyawan',
      date: '12 Oktober 2026',
      summary: 'Skenario fiktif tentang buka puasa bersama.',
      content: 'Contoh fiktif tentang kebersamaan karyawan.',
      imageAsset: 'assets/images/news/news_002.jpg',
    );
    const tukarKadoItem = NewsItem(
      id: 'sample-activity-003',
      title: 'Simulasi Tukar Kado Karyawan Tahunan',
      category: 'Contoh Fiktif • Kebersamaan Karyawan',
      date: '18 September 2026',
      summary: 'Skenario fiktif tentang merayakan kebersamaan karyawan.',
      content: 'Contoh fiktif tentang acara tukar kado karyawan tahunan.',
      imageAsset: 'assets/images/news/news_003.jpg',
    );

    testWidgets('renders all content and supports tap and bookmark toggle', (
      tester,
    ) async {
      bool cardTapped = false;
      bool bookmarkToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(
              item: testItem,
              isBookmarked: false,
              onTap: () {
                cardTapped = true;
              },
              onBookmarkToggle: () {
                bookmarkToggled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Facility Expansion 2026'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('03 Nov 2026'), findsOneWidget);
      expect(
        find.text('Summary of the recent company facility expansion activity.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

      // Tap card
      await tester.tap(find.text('Facility Expansion 2026'));
      expect(cardTapped, isTrue);

      // Tap bookmark
      await tester.tap(find.byIcon(Icons.bookmark_border));
      expect(bookmarkToggled, isTrue);
    });

    testWidgets('shows filled bookmark icon when isBookmarked is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(
              item: testItem,
              isBookmarked: true,
              onBookmarkToggle: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('shows the local medical check-up image with alt text', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NewsCard(item: medicalCheckUpItem)),
        ),
      );
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image));
      final resizedImage = image.image as ResizeImage;
      expect(resizedImage.imageProvider, isA<AssetImage>());
      expect(
        (resizedImage.imageProvider as AssetImage).assetName,
        'assets/images/news/news_001.jpg',
      );
      expect(image.fit, BoxFit.cover);
      expect(image.width, 80);
      expect(image.height, 80);
      expect(resizedImage.width, 240);
      expect(image.semanticLabel, contains('Simulasi Annual Medical Check Up'));
      expect(find.byIcon(Icons.article_outlined), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows the local buka puasa image with Indonesian alt text', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NewsCard(item: bukaPuasaItem)),
        ),
      );
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image));
      final resizedImage = image.image as ResizeImage;
      expect(resizedImage.imageProvider, isA<AssetImage>());
      expect(
        (resizedImage.imageProvider as AssetImage).assetName,
        'assets/images/news/news_002.jpg',
      );
      expect(image.fit, BoxFit.cover);
      expect(image.semanticLabel, contains('Simulasi Buka Puasa Bersama'));
      expect(find.byIcon(Icons.article_outlined), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows the local annual gift exchange image with alt text', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NewsCard(item: tukarKadoItem)),
        ),
      );
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image));
      final resizedImage = image.image as ResizeImage;
      expect(resizedImage.imageProvider, isA<AssetImage>());
      expect(
        (resizedImage.imageProvider as AssetImage).assetName,
        'assets/images/news/news_003.jpg',
      );
      expect(image.fit, BoxFit.cover);
      expect(
        image.semanticLabel,
        contains('Simulasi Tukar Kado Karyawan Tahunan'),
      );
      expect(find.byIcon(Icons.article_outlined), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('missing local image safely uses the existing placeholder', (
      tester,
    ) async {
      const missingImageItem = NewsItem(
        id: 'missing-image',
        title: 'Berita tanpa gambar',
        category: 'Contoh Fiktif • Contoh',
        date: '04 November 2026',
        summary: 'Skenario fiktif tanpa gambar.',
        content: 'Konten contoh.',
        imageAsset: 'assets/images/news/missing.jpg',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NewsCard(item: missingImageItem)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Berita tanpa gambar'), findsOneWidget);
      expect(find.byIcon(Icons.article_outlined), findsOneWidget);
      expect(find.text('null'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mixed image and placeholder cards fit narrow and landscape', (
      tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final size in [const Size(320, 480), const Size(800, 360)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  NewsCard(item: medicalCheckUpItem),
                  const SizedBox(height: 12),
                  NewsCard(item: bukaPuasaItem),
                  const SizedBox(height: 12),
                  NewsCard(item: tukarKadoItem),
                  const SizedBox(height: 12),
                  NewsCard(item: testItem),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Image), findsWidgets);
        await tester.scrollUntilVisible(
          find.byIcon(Icons.article_outlined),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.byIcon(Icons.article_outlined), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('EmptyState Tests', () {
    testWidgets('renders icon, title, description, and triggers action', (
      tester,
    ) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.search_off_outlined,
              title: 'No Items Found',
              description: 'Try adjusting your search query.',
              actionLabel: 'Reset Search',
              onActionPressed: () {
                actionTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off_outlined), findsOneWidget);
      expect(find.text('No Items Found'), findsOneWidget);
      expect(find.text('Try adjusting your search query.'), findsOneWidget);
      expect(find.text('Reset Search'), findsOneWidget);

      await tester.tap(find.text('Reset Search'));
      expect(actionTapped, isTrue);
    });
  });

  group('CustomBottomNav Tests', () {
    testWidgets(
      'renders 3 destinations and triggers onTap with correct index',
      (tester) async {
        int selectedIndex = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: StatefulBuilder(
                builder: (context, setState) {
                  return CustomBottomNav(
                    currentIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Beranda'), findsOneWidget);
        expect(find.text('Perusahaan'), findsOneWidget);
        expect(find.text('Berita'), findsOneWidget);

        // Tap Perusahaan
        await tester.tap(find.text('Perusahaan'));
        await tester.pumpAndSettle();
        expect(selectedIndex, 1);

        // Tap Berita
        await tester.tap(find.text('Berita'));
        await tester.pumpAndSettle();
        expect(selectedIndex, 2);
      },
    );
  });

  group('Responsiveness Tests', () {
    testWidgets(
      'all components fit without overflow on small screens (320x480)',
      (tester) async {
        tester.view.physicalSize = const Size(320 * 2.0, 480 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: const CustomAppBar(title: 'Small Screen'),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const PrimaryButton(
                        text: 'Primary Action',
                        onPressed: null,
                      ),
                      const SizedBox(height: 8),
                      const SecondaryButton(
                        text: 'Secondary Action',
                        onPressed: null,
                      ),
                      const SizedBox(height: 8),
                      const InfoCard(
                        title: 'Card Title',
                        description: 'Card description on narrow screen.',
                      ),
                      const SizedBox(height: 8),
                      const CustomTextField(label: 'Input Field'),
                      const SizedBox(height: 8),
                      NewsCard(
                        item: const NewsItem(
                          id: 'n-1',
                          title: 'Narrow Screen News Item',
                          category: 'Update',
                          date: '2026',
                          summary: 'Brief description.',
                          content: 'Content',
                        ),
                        onBookmarkToggle: () {},
                      ),
                      const SizedBox(height: 8),
                      const EmptyState(
                        title: 'Empty',
                        description: 'No data available.',
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: CustomBottomNav(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  });
}
