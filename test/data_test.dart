import 'package:flutter_test/flutter_test.dart';

import 'package:alco_company_profile/data/business_data.dart';
import 'package:alco_company_profile/data/company_data.dart';
import 'package:alco_company_profile/data/news_data.dart';

void main() {
  group('Local company data', () {
    test('uses explicit placeholders for unverified company information', () {
      expect(companyInfo.name, 'PT. Alcotraindo Batam');
      expect(companyInfo.overview, contains('belum diverifikasi'));
      expect(companyInfo.businessDescription, contains('Placeholder'));
      expect(companyInfo.vision, isNull);
      expect(companyInfo.mission, isNull);
      expect(companyInfo.contactDetails, isNull);
    });

    test('provides general non-promotional business topics', () {
      expect(businessTopics, hasLength(inInclusiveRange(3, 4)));
      expect(
        businessTopics.every(
          (topic) =>
              topic.title.trim().isNotEmpty &&
              topic.description.trim().isNotEmpty,
        ),
        isTrue,
      );
    });
  });

  group('Local sample news', () {
    test('contains six complete fictional entries with stable unique IDs', () {
      expect(newsItems, hasLength(inInclusiveRange(5, 6)));

      final ids = newsItems.map((item) => item.id).toSet();
      expect(ids, hasLength(newsItems.length));
      expect(newsItems.map((item) => item.id).toList(), <String>[
        'sample-activity-001',
        'sample-activity-002',
        'sample-activity-003',
        'sample-activity-004',
        'sample-activity-005',
        'sample-activity-006',
      ]);

      for (final item in newsItems) {
        expect(item.id, isNotEmpty);
        expect(item.title, isNotEmpty);
        expect(item.category, contains('Contoh Fiktif'));
        expect(item.date, isNotEmpty);
        expect(item.summary, contains('fiktif'));
        expect(item.content, contains('fiktif'));
      }
    });
  });
}
