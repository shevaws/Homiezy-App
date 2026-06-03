import '../../domain/entities/kos_entity.dart';

class KosModel extends KosEntity {
  const KosModel({
    required super.id,
    required super.nama,
    required super.alamat,
    required super.kota,
    required super.hargaPerBulan,
    required super.rating,
    required super.totalReview,
    required super.fasilitas,
    required super.fotoUrls,
    required super.tipe,
    required super.tersedia,
    super.jarak,
    required super.mitraId,
    required super.mitraNama,
  });

  factory KosModel.fromJson(Map<String, dynamic> json) {
    return KosModel(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      kota: json['kota'] ?? '',
      hargaPerBulan: (json['harga_per_bulan'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      totalReview: json['total_review'] ?? 0,
      fasilitas: List<String>.from(json['fasilitas'] ?? []),
      fotoUrls: List<String>.from(json['foto_urls'] ?? []),
      tipe: json['tipe'] ?? 'campur',
      tersedia: json['tersedia'] ?? true,
      jarak: json['jarak'] != null ? (json['jarak'] as num).toDouble() : null,
      mitraId: json['mitra_id'].toString(),
      mitraNama: json['mitra_nama'] ?? '',
    );
  }
}