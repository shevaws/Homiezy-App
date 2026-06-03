import '../../domain/entities/laundry_entity.dart';

class LaundryModel extends LaundryEntity {
  const LaundryModel({
    required super.id, required super.nama, required super.deskripsi,
    required super.hargaPerKg, required super.hargaPerBulan,
    required super.rating, required super.totalReview, required super.layanan,
    required super.fotoUrls, required super.estimasiHari, required super.tersedia,
    required super.mitraId, required super.mitraNama,
  });

  factory LaundryModel.fromJson(Map<String, dynamic> json) {
    return LaundryModel(
      id: json['id'].toString(), nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      hargaPerKg: (json['harga_per_kg'] as num).toDouble(),
      hargaPerBulan: (json['harga_per_bulan'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      totalReview: json['total_review'] ?? 0,
      layanan: List<String>.from(json['layanan'] ?? []),
      fotoUrls: List<String>.from(json['foto_urls'] ?? []),
      estimasiHari: json['estimasi_hari'] ?? 2,
      tersedia: json['tersedia'] ?? true,
      mitraId: json['mitra_id'].toString(), mitraNama: json['mitra_nama'] ?? '',
    );
  }
}