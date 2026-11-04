import 'package:flutter_test/flutter_test.dart';

import 'package:alco_company_profile/data/business_data.dart';
import 'package:alco_company_profile/data/company_data.dart';
import 'package:alco_company_profile/data/news_data.dart';

void main() {
  group('Local company data', () {
    test('contains supplied company profile, values, policies, and details', () {
      expect(companyInfo.name, 'PT. Alcotraindo Batam');
      expect(
        companyInfo.overview,
        'PT. Alcotraindo Batam adalah perusahaan manufaktur tembakau, '
        'khususnya rokok putih, dengan jangkauan pasar di lebih dari 10 negara. '
        'Perusahaan memproduksi rokok mulai dari bahan baku hingga produk jadi, '
        'dengan teknologi mesin terkini untuk proses primer serta mesin pembuat '
        'dan pengemas rokok.',
      );
      expect(
        companyInfo.businessDescription,
        contains('bahan baku hingga produk jadi'),
      );
      expect(companyInfo.values, <String>[
        'Semangat untuk menang',
        'Inovasi melalui pembelajaran dan kewirausahaan',
        'Membangun kepercayaan secara internal dan eksternal',
        'Wawasan global',
        'Warga korporasi yang bertanggung jawab secara sosial',
      ]);
      expect(companyInfo.qualityPolicies, <String>[
        'Pengiriman produk berkualitas tepat waktu dengan harga yang kompetitif',
        'Menghasilkan produk/layanan berkualitas tinggi yang konsisten '
            'memenuhi kebutuhan pelanggan',
        'Keterlibatan penuh seluruh karyawan dengan rasa saling percaya untuk '
            'mewujudkan proses bisnis internal yang baik dan sehat',
        'Perbaikan berkelanjutan untuk meningkatkan efektivitas sistem '
            'manajemen mutu dan daya saing organisasi',
      ]);
      expect(
        companyInfo.commitment,
        'Perusahaan terus maju dengan perbaikan berkelanjutan pada seluruh '
        'proses, efektivitas, dan efisiensi. Organisasinya dinamis dan terbuka, '
        'melibatkan semua pihak dalam setiap kegiatan dan perbaikan, menjunjung '
        'kesetaraan dan kesempatan yang sama berdasarkan profesionalisme kerja, '
        'mematuhi kode etik yang ditetapkan perusahaan dan disepakati seluruh '
        'karyawan, serta tunduk pada regulasi global maupun lokal di lokasi '
        'perusahaan berada.',
      );
      expect(companyInfo.vision, isNull);
      expect(
        companyInfo.mission,
        'Menjadi pemain tembakau terkemuka di tingkat internasional.',
      );
      expect(
        companyInfo.address,
        'Citra Buana Industrial Park Phase III Lot 12A-12C, Batam Centre, '
        'Batam, Kepulauan Riau, Indonesia.',
      );
      expect(companyInfo.phone, '0778471221');
      expect(companyInfo.industry, 'Tembakau');
      expect(companyInfo.foundingYear, '2012');
      expect(companyInfo.companyType, 'Perseroan Tertutup');
      expect(companyInfo.employeeRange, '501-1.000 karyawan (perkiraan)');
      expect(companyInfo.headquarters, 'Batam, Kepulauan Riau');
    });

    test('provides topics derived from the supplied company profile', () {
      expect(businessTopics, hasLength(5));
      expect(
        businessTopics.every(
          (topic) =>
              topic.title.trim().isNotEmpty &&
              topic.description.trim().isNotEmpty,
        ),
        isTrue,
      );
      expect(
        businessTopics.map((topic) => topic.title),
        containsAll(<String>[
          'Manufaktur Tembakau',
          'Proses Produksi',
          'Teknologi Mesin',
          'Kebijakan Mutu',
          'Komitmen dan Kepatuhan',
        ]),
      );
    });
  });

  group('Local sample news', () {
    test('contains stable news entries with unique IDs', () {
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
      expect(newsItems.first.id, 'sample-activity-001');
      expect(newsItems.first.title, 'Annual Medical Check Up Karyawan');
      expect(newsItems.first.category, 'Kesehatan Kerja');
      expect(newsItems.first.date, '6 bulan lalu');
      expect(newsItems.first.imageAsset, 'assets/images/news/news_001.jpg');
      expect(newsItems.first.summary, contains('PT. Alcotraindo Batam'));
      final bukaPuasaItem = newsItems[1];
      expect(bukaPuasaItem.id, 'sample-activity-002');
      expect(bukaPuasaItem.title, 'Buka Puasa Bersama Karyawan dan Management');
      expect(bukaPuasaItem.category, 'Kebersamaan Karyawan');
      expect(bukaPuasaItem.date, '7 bulan lalu');
      expect(bukaPuasaItem.summary, contains('PT. Alcotraindo Batam'));
      expect(bukaPuasaItem.imageAsset, 'assets/images/news/news_002.jpg');
      final tukarKadoItem = newsItems[2];
      expect(tukarKadoItem.id, 'sample-activity-003');
      expect(tukarKadoItem.title, 'Tukar Kado Karyawan Tahunan');
      expect(tukarKadoItem.category, 'Kebersamaan Karyawan');
      expect(tukarKadoItem.date, '1 tahun lalu');
      expect(tukarKadoItem.summary, contains('merayakan kebersamaan'));
      expect(tukarKadoItem.imageAsset, 'assets/images/news/news_003.jpg');
      expect(
        newsItems
            .take(3)
            .every(
              (item) =>
                  !item.title.toLowerCase().contains('simulasi') &&
                  !item.category.toLowerCase().contains('fiktif') &&
                  !item.summary.toLowerCase().contains('fiktif') &&
                  !item.content.toLowerCase().contains('fiktif'),
            ),
        isTrue,
      );
      expect(
        newsItems.skip(3).every((item) => item.imageAsset == null),
        isTrue,
      );

      for (final item in newsItems) {
        expect(item.id, isNotEmpty);
        expect(item.title, isNotEmpty);
        expect(item.date, isNotEmpty);
      }
      for (final item in newsItems.skip(3)) {
        expect(item.category, contains('Contoh Fiktif'));
        expect(item.summary, contains('fiktif'));
        expect(item.content, contains('fiktif'));
      }
    });
  });
}
