class CateringEntity {
  final String id;
  final String nama;
  final String deskripsi;
  final double hargaPerBulan;
  final double rating;
  final int totalReview;
  final List<String> menuContoh;
  final List<String> fotoUrls;
  final int jumlahMakanPerHari; // 1, 2, atau 3
  final bool tersedia;
  final String mitraId;
  final String mitraNama;

  const CateringEntity({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.hargaPerBulan,
    required this.rating,
    required this.totalReview,
    required this.menuContoh,
    required this.fotoUrls,
    required this.jumlahMakanPerHari,
    required this.tersedia,
    required this.mitraId,
    required this.mitraNama,
  });
}