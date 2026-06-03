import '../models/kos_model.dart';
import '../models/catering_model.dart';
import '../models/laundry_model.dart';
import '../models/paket_model.dart';
import '../../domain/entities/paket_entity.dart';

class LayananMockDatasource {
  static const _delay = Duration(milliseconds: 800);

  // ── KOS DATA ──────────────────────────────────────────────
  static final List<Map<String, dynamic>> _mockKos = [
    {
      'id': '1', 'nama': 'Kos Melati Indah', 'alamat': 'Jl. Melati No. 12, Tembalang',
      'kota': 'Semarang', 'harga_per_bulan': 800000.0, 'rating': 4.8,
      'total_review': 124, 'tipe': 'putri', 'tersedia': true, 'jarak': 0.8,
      'mitra_id': 'm1', 'mitra_nama': 'Bu Sari',
      'fasilitas': ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Lemari', 'Meja Belajar'],
      'foto_urls': ['https://picsum.photos/seed/kos1/400/300',
                    'https://picsum.photos/seed/kos1b/400/300'],
    },
    {
      'id': '2', 'nama': 'Kos Putra Mandiri', 'alamat': 'Jl. Ngesrep Timur V No. 5',
      'kota': 'Semarang', 'harga_per_bulan': 650000.0, 'rating': 4.5,
      'total_review': 89, 'tipe': 'putra', 'tersedia': true, 'jarak': 1.2,
      'mitra_id': 'm2', 'mitra_nama': 'Pak Budi',
      'fasilitas': ['WiFi', 'Parkir Motor', 'Dapur Bersama', 'Lemari'],
      'foto_urls': ['https://picsum.photos/seed/kos2/400/300'],
    },
    {
      'id': '3', 'nama': 'Kos Griya Asri', 'alamat': 'Jl. Banjarsari No. 8',
      'kota': 'Semarang', 'harga_per_bulan': 1200000.0, 'rating': 4.9,
      'total_review': 201, 'tipe': 'campur', 'tersedia': true, 'jarak': 0.5,
      'mitra_id': 'm3', 'mitra_nama': 'Bu Dewi',
      'fasilitas': ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Kasur', 'Lemari', 'TV', 'Kulkas'],
      'foto_urls': ['https://picsum.photos/seed/kos3/400/300',
                    'https://picsum.photos/seed/kos3b/400/300'],
    },
    {
      'id': '4', 'nama': 'Kos Sejahtera', 'alamat': 'Jl. Gajahmada No. 45',
      'kota': 'Semarang', 'harga_per_bulan': 500000.0, 'rating': 4.2,
      'total_review': 56, 'tipe': 'campur', 'tersedia': false, 'jarak': 2.1,
      'mitra_id': 'm4', 'mitra_nama': 'Pak Joko',
      'fasilitas': ['WiFi', 'Parkir Motor', 'Dapur Bersama'],
      'foto_urls': ['https://picsum.photos/seed/kos4/400/300'],
    },
  ];

  // ── CATERING DATA ─────────────────────────────────────────
  static final List<Map<String, dynamic>> _mockCatering = [
    {
      'id': 'c1', 'nama': 'Catering Ibu Sari', 'harga_per_bulan': 450000.0,
      'rating': 4.7, 'total_review': 98, 'jumlah_makan_per_hari': 2,
      'tersedia': true, 'mitra_id': 'm1', 'mitra_nama': 'Bu Sari',
      'deskripsi': 'Masakan rumahan sehat dan lezat, menu berganti setiap hari.',
      'menu_contoh': ['Ayam Goreng', 'Sayur Sop', 'Tempe Orek', 'Nasi Putih'],
      'foto_urls': ['https://picsum.photos/seed/cat1/400/300'],
    },
    {
      'id': 'c2', 'nama': 'Catering Sehat Pak Budi', 'harga_per_bulan': 550000.0,
      'rating': 4.6, 'total_review': 72, 'jumlah_makan_per_hari': 3,
      'tersedia': true, 'mitra_id': 'm2', 'mitra_nama': 'Pak Budi',
      'deskripsi': 'Menu 3x sehari, termasuk sarapan. Pilihan menu diet tersedia.',
      'menu_contoh': ['Nasi + Lauk', 'Buah', 'Sup Sayur', 'Ayam Bakar'],
      'foto_urls': ['https://picsum.photos/seed/cat2/400/300'],
    },
    {
      'id': 'c3', 'nama': 'Dapur Bu Dewi', 'harga_per_bulan': 400000.0,
      'rating': 4.8, 'total_review': 134, 'jumlah_makan_per_hari': 2,
      'tersedia': true, 'mitra_id': 'm3', 'mitra_nama': 'Bu Dewi',
      'deskripsi': 'Masakan Jawa otentik, diantar langsung ke kamar.',
      'menu_contoh': ['Gudeg', 'Opor Ayam', 'Sambal Goreng', 'Lodeh'],
      'foto_urls': ['https://picsum.photos/seed/cat3/400/300'],
    },
  ];

  // ── LAUNDRY DATA ──────────────────────────────────────────
  static final List<Map<String, dynamic>> _mockLaundry = [
    {
      'id': 'l1', 'nama': 'Laundry Bersih Jaya', 'harga_per_kg': 7000.0,
      'harga_per_bulan': 120000.0, 'rating': 4.6, 'total_review': 87,
      'estimasi_hari': 2, 'tersedia': true, 'mitra_id': 'm1', 'mitra_nama': 'Bu Sari',
      'deskripsi': 'Laundry kiloan dengan antar jemput gratis radius 2km.',
      'layanan': ['Cuci', 'Setrika', 'Antar Jemput'],
      'foto_urls': ['https://picsum.photos/seed/lnd1/400/300'],
    },
    {
      'id': 'l2', 'nama': 'Fresh Laundry', 'harga_per_kg': 8000.0,
      'harga_per_bulan': 150000.0, 'rating': 4.8, 'total_review': 112,
      'estimasi_hari': 1, 'tersedia': true, 'mitra_id': 'm2', 'mitra_nama': 'Pak Budi',
      'deskripsi': 'Express laundry 1 hari selesai, wangi tahan lama.',
      'layanan': ['Cuci', 'Setrika', 'Antar Jemput', 'Express'],
      'foto_urls': ['https://picsum.photos/seed/lnd2/400/300'],
    },
    {
      'id': 'l3', 'nama': 'Laundry Hemat Bu Dewi', 'harga_per_kg': 5000.0,
      'harga_per_bulan': 100000.0, 'rating': 4.4, 'total_review': 65,
      'estimasi_hari': 3, 'tersedia': true, 'mitra_id': 'm3', 'mitra_nama': 'Bu Dewi',
      'deskripsi': 'Harga terjangkau, hasil bersih dan rapi.',
      'layanan': ['Cuci', 'Setrika'],
      'foto_urls': ['https://picsum.photos/seed/lnd3/400/300'],
    },
  ];

  // ── FETCH METHODS ─────────────────────────────────────────
  Future<List<KosModel>> getKosList({String? query, String? tipe, double? maxHarga}) async {
    await Future.delayed(_delay);
    var list = _mockKos.map((e) => KosModel.fromJson(e)).toList();
    if (query != null && query.isNotEmpty) {
      list = list.where((k) =>
        k.nama.toLowerCase().contains(query.toLowerCase()) ||
        k.alamat.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    if (tipe != null) list = list.where((k) => k.tipe == tipe).toList();
    if (maxHarga != null) list = list.where((k) => k.hargaPerBulan <= maxHarga).toList();
    return list;
  }

  Future<List<CateringModel>> getCateringList({String? query}) async {
    await Future.delayed(_delay);
    var list = _mockCatering.map((e) => CateringModel.fromJson(e)).toList();
    if (query != null && query.isNotEmpty) {
      list = list.where((c) =>
        c.nama.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    return list;
  }

  Future<List<LaundryModel>> getLaundryList({String? query}) async {
    await Future.delayed(_delay);
    var list = _mockLaundry.map((e) => LaundryModel.fromJson(e)).toList();
    if (query != null && query.isNotEmpty) {
      list = list.where((l) =>
        l.nama.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    return list;
  }

  Future<List<PaketModel>> getPaketList() async {
    await Future.delayed(_delay);
    final kosList = _mockKos.map((e) => KosModel.fromJson(e)).toList();
    final cateringList = _mockCatering.map((e) => CateringModel.fromJson(e)).toList();
    final laundryList = _mockLaundry.map((e) => LaundryModel.fromJson(e)).toList();

    return [
      PaketModel(
        id: 'p1', tipe: TipePaket.kenyang,
        nama: 'Paket Kenyang', deskripsi: 'Kos nyaman + catering lezat setiap hari',
        kos: kosList[0], catering: cateringList[0], laundry: null,
        hargaNormal: kosList[0].hargaPerBulan + cateringList[0].hargaPerBulan,
        hargaPaket: (kosList[0].hargaPerBulan + cateringList[0].hargaPerBulan) * 0.9,
        diskonPersen: 10,
      ),
      PaketModel(
        id: 'p2', tipe: TipePaket.bersih,
        nama: 'Paket Bersih', deskripsi: 'Kos nyaman + laundry bersih tanpa repot',
        kos: kosList[1], catering: null, laundry: laundryList[0],
        hargaNormal: kosList[1].hargaPerBulan + laundryList[0].hargaPerBulan,
        hargaPaket: (kosList[1].hargaPerBulan + laundryList[0].hargaPerBulan) * 0.9,
        diskonPersen: 10,
      ),
      PaketModel(
        id: 'p3', tipe: TipePaket.lengkap,
        nama: 'Paket Lengkap', deskripsi: 'Semua kebutuhan kos dalam satu paket hemat',
        kos: kosList[2], catering: cateringList[2], laundry: laundryList[2],
        hargaNormal: kosList[2].hargaPerBulan + cateringList[2].hargaPerBulan + laundryList[2].hargaPerBulan,
        hargaPaket: (kosList[2].hargaPerBulan + cateringList[2].hargaPerBulan + laundryList[2].hargaPerBulan) * 0.85,
        diskonPersen: 15,
      ),
    ];
  }
}