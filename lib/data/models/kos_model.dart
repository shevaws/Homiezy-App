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
    id: json['id']?.toString() ?? '',
    nama: json['nama'] ?? json['name'] ?? '',
    alamat: json['alamat'] ?? json['location'] ?? '',
    kota: json['kota'] ?? 'Purwokerto',
    hargaPerBulan: (json['harga'] ?? json['harga_per_bulan'] ?? 0).toDouble(),
    rating: (json['rating'] ?? 0).toDouble(),
    totalReview: json['total_review'] ?? json['reviews_count'] ?? 0,
    fasilitas: List<String>.from(json['fasilitas'] ?? json['features'] ?? []),
    fotoUrls: List<String>.from(json['foto_urls'] ?? []),
    tipe: _parseTipe(json['tipe_kos'] ?? json['gender'] ?? 'campur'),
    tersedia: json['tersedia'] ?? true,
    jarak: json['jarak'] != null
        ? double.tryParse(json['jarak'].toString())
        : null,
    mitraId: json['mitra_id']?.toString() ?? '',
    mitraNama: json['mitra_nama'] ?? '',
  );
}

static String _parseTipe(String tipe) {
  switch (tipe.toLowerCase()) {
    case 'putra': return 'putra';
    case 'putri': return 'putri';
    default: return 'campur';
  }
}
}