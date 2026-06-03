class LaundryEntity {
  final String id;
  final String nama;
  final String deskripsi;
  final double hargaPerKg;
  final double hargaPerBulan; // paket bulanan
  final double rating;
  final int totalReview;
  final List<String> layanan; // ['cuci', 'setrika', 'antar jemput']
  final List<String> fotoUrls;
  final int estimasiHari;
  final bool tersedia;
  final String mitraId;
  final String mitraNama;

  const LaundryEntity({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.hargaPerKg,
    required this.hargaPerBulan,
    required this.rating,
    required this.totalReview,
    required this.layanan,
    required this.fotoUrls,
    required this.estimasiHari,
    required this.tersedia,
    required this.mitraId,
    required this.mitraNama,
  });
}