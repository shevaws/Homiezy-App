class KosEntity {
  final String id;
  final String nama;
  final String alamat;
  final String kota;
  final double hargaPerBulan;
  final double rating;
  final int totalReview;
  final List<String> fasilitas;
  final List<String> fotoUrls;
  final String tipe; // 'putra' | 'putri' | 'campur'
  final bool tersedia;
  final double? jarak; // dalam km
  final String mitraId;
  final String mitraNama;

  const KosEntity({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.kota,
    required this.hargaPerBulan,
    required this.rating,
    required this.totalReview,
    required this.fasilitas,
    required this.fotoUrls,
    required this.tipe,
    required this.tersedia,
    this.jarak,
    required this.mitraId,
    required this.mitraNama,
  });
}