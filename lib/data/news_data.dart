import '../models/news_item.dart';

/// The first three entries describe company events confirmed by the user.
/// Remaining entries are fictional examples for app development and testing.
const List<NewsItem> newsItems = <NewsItem>[
  NewsItem(
    id: 'sample-activity-001',
    title: 'Annual Medical Check Up Karyawan',
    category: 'Kesehatan Kerja',
    date: '6 bulan lalu',
    summary:
        'PT. Alcotraindo Batam melaksanakan pemeriksaan kesehatan berkala '
        'bagi karyawan.',
    content:
        'Kegiatan Annual Medical Check Up karyawan PT. Alcotraindo Batam '
        'dilaksanakan sebagai pemeriksaan kesehatan berkala.',
    imageAsset: 'assets/images/news/news_001.jpg',
  ),
  NewsItem(
    id: 'sample-activity-002',
    title: 'Buka Puasa Bersama Karyawan dan Management',
    category: 'Kebersamaan Karyawan',
    date: '7 bulan lalu',
    summary:
        'Karyawan dan management PT. Alcotraindo Batam berkumpul dalam acara '
        'buka puasa bersama.',
    content:
        'Acara buka puasa bersama menjadi momen bagi karyawan dan management '
        'PT. Alcotraindo Batam untuk berkumpul.',
    imageAsset: 'assets/images/news/news_002.jpg',
  ),
  NewsItem(
    id: 'sample-activity-003',
    title: 'Tukar Kado Karyawan Tahunan',
    category: 'Kebersamaan Karyawan',
    date: '1 tahun lalu',
    summary:
        'Karyawan PT. Alcotraindo Batam merayakan kebersamaan melalui acara '
        'tukar kado tahunan.',
    content:
        'Acara tukar kado karyawan tahunan menjadi momen kebersamaan bagi '
        'karyawan PT. Alcotraindo Batam. Foto kegiatan memperlihatkan para '
        'peserta membawa kado.',
    imageAsset: 'assets/images/news/news_003.jpg',
  ),
  NewsItem(
    id: 'sample-activity-004',
    title: 'Simulasi Lokakarya Pengendalian Mutu',
    category: 'Contoh Fiktif • Mutu',
    date: '21 Agustus 2026',
    summary:
        'Skenario fiktif untuk memperkenalkan pembahasan umum tentang mutu.',
    content:
        'Contoh fiktif ini berisi pembahasan umum tentang pemeriksaan proses '
        'dan konsistensi mutu. Isinya bukan informasi operasional atau '
        'pencapaian perusahaan.',
  ),
  NewsItem(
    id: 'sample-activity-005',
    title: 'Simulasi Sesi Berbagi Pengetahuan',
    category: 'Contoh Fiktif • Edukasi',
    date: '14 Juli 2026',
    summary:
        'Skenario fiktif berupa sesi berbagi pengetahuan untuk keperluan demo.',
    content:
        'Contoh fiktif ini menggambarkan sesi berbagi pengetahuan secara '
        'umum. Teks disediakan untuk mengisi contoh tampilan berita dan '
        'tidak mewakili acara perusahaan.',
  ),
  NewsItem(
    id: 'sample-activity-006',
    title: 'Simulasi Koordinasi Kegiatan Sosial',
    category: 'Contoh Fiktif • Sosial',
    date: '09 Juni 2026',
    summary: 'Skenario fiktif mengenai koordinasi kegiatan sosial secara umum.',
    content:
        'Contoh fiktif ini menjelaskan koordinasi kegiatan sosial sebagai '
        'tema demonstrasi aplikasi. Konten ini tidak menyatakan adanya '
        'program atau pencapaian sosial perusahaan.',
  ),
];
