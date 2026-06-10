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
    id: json['id']?.toString() ?? '',
    nama: json['nama'] ?? json['name'] ?? '',
    deskripsi: json['deskripsi'] ?? json['subtitle'] ?? '',
    hargaPerKg: (json['harga_per_kg'] ?? json['harga'] ?? 0).toDouble(),
    hargaPerBulan: (json['harga_per_bulan'] ?? json['harga'] ?? 0).toDouble(),
    rating: (json['rating'] ?? 0).toDouble(),
    totalReview: json['total_review'] ?? 0,
    layanan: List<String>.from(json['layanan'] ?? json['features'] ?? []),
    fotoUrls: List<String>.from(json['foto_urls'] ?? []),
    estimasiHari: json['estimasi_hari'] ?? 2,
    tersedia: json['tersedia'] ?? true,
    mitraId: json['mitra_id']?.toString() ?? '',
    mitraNama: json['mitra_nama'] ?? '',
  );
}
}