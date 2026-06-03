import 'kos_entity.dart';
import 'catering_entity.dart';
import 'laundry_entity.dart';

enum TipePaket { kenyang, bersih, lengkap }

class PaketEntity {
  final String id;
  final TipePaket tipe;
  final String nama;
  final String deskripsi;
  final KosEntity kos;
  final CateringEntity? catering;
  final LaundryEntity? laundry;
  final double hargaNormal; // total tanpa diskon
  final double hargaPaket;  // harga setelah diskon
  final double diskonPersen;

  const PaketEntity({
    required this.id,
    required this.tipe,
    required this.nama,
    required this.deskripsi,
    required this.kos,
    this.catering,
    this.laundry,
    required this.hargaNormal,
    required this.hargaPaket,
    required this.diskonPersen,
  });

  String get namaLabel {
    switch (tipe) {
      case TipePaket.kenyang: return 'Paket Kenyang';
      case TipePaket.bersih: return 'Paket Bersih';
      case TipePaket.lengkap: return 'Paket Lengkap';
    }
  }

  String get deskripsiLayanan {
    switch (tipe) {
      case TipePaket.kenyang: return 'Kos + Catering';
      case TipePaket.bersih: return 'Kos + Laundry';
      case TipePaket.lengkap: return 'Kos + Catering + Laundry';
    }
  }
}