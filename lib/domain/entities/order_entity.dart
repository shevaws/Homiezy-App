import 'kos_entity.dart';
import 'catering_entity.dart';
import 'laundry_entity.dart';
import 'paket_entity.dart';

enum OrderStatus { pending, aktif, selesai, dibatalkan }
enum OrderType { kos, catering, laundry, paket }

class OrderEntity {
  final String id;
  final OrderType type;
  final OrderStatus status;
  final String userId;
  final DateTime tanggalMulai;
  final int durasibulan;
  final String alamat;
  final String? catatan;
  final double totalHarga;
  final String? snapToken;
  final String? paymentUrl;
  final DateTime createdAt;

  // Layanan yang dipesan (salah satu akan diisi)
  final KosEntity? kos;
  final CateringEntity? catering;
  final LaundryEntity? laundry;
  final PaketEntity? paket;

  const OrderEntity({
    required this.id,
    required this.type,
    required this.status,
    required this.userId,
    required this.tanggalMulai,
    required this.durasibulan,
    required this.alamat,
    this.catatan,
    required this.totalHarga,
    this.snapToken,
    this.paymentUrl,
    required this.createdAt,
    this.kos,
    this.catering,
    this.laundry,
    this.paket,
  });

  String get namaLayanan {
    if (kos != null) return kos!.nama;
    if (catering != null) return catering!.nama;
    if (laundry != null) return laundry!.nama;
    if (paket != null) return paket!.namaLabel;
    return '-';
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending: return 'Menunggu Pembayaran';
      case OrderStatus.aktif: return 'Aktif';
      case OrderStatus.selesai: return 'Selesai';
      case OrderStatus.dibatalkan: return 'Dibatalkan';
    }
  }
}