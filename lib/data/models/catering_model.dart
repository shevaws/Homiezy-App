import '../../domain/entities/catering_entity.dart';

class CateringModel extends CateringEntity {
  const CateringModel({
    required super.id, required super.nama, required super.deskripsi,
    required super.hargaPerBulan, required super.rating, required super.totalReview,
    required super.menuContoh, required super.fotoUrls,
    required super.jumlahMakanPerHari, required super.tersedia,
    required super.mitraId, required super.mitraNama,
  });

  factory CateringModel.fromJson(Map<String, dynamic> json) {
    return CateringModel(
      id: json['id'].toString(), nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      hargaPerBulan: (json['harga_per_bulan'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      totalReview: json['total_review'] ?? 0,
      menuContoh: List<String>.from(json['menu_contoh'] ?? []),
      fotoUrls: List<String>.from(json['foto_urls'] ?? []),
      jumlahMakanPerHari: json['jumlah_makan_per_hari'] ?? 2,
      tersedia: json['tersedia'] ?? true,
      mitraId: json['mitra_id'].toString(), mitraNama: json['mitra_nama'] ?? '',
    );
  }
}