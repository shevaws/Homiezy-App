import '../../domain/entities/paket_entity.dart';
import '../../domain/entities/kos_entity.dart';
import '../../domain/entities/catering_entity.dart';
import '../../domain/entities/laundry_entity.dart';

class PaketModel extends PaketEntity {
  const PaketModel({
    required super.id, required super.tipe, required super.nama,
    required super.deskripsi, required super.kos,
    super.catering, super.laundry,
    required super.hargaNormal, required super.hargaPaket,
    required super.diskonPersen,
  });
}