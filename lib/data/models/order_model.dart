import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.type,
    required super.status,
    required super.userId,
    required super.tanggalMulai,
    required super.durasibulan,
    required super.alamat,
    super.catatan,
    required super.totalHarga,
    super.snapToken,
    super.paymentUrl,
    required super.createdAt,
    super.kos,
    super.catering,
    super.laundry,
    super.paket,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      type: OrderType.values.firstWhere(
          (e) => e.name == json['type'], orElse: () => OrderType.kos),
      status: OrderStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => OrderStatus.pending),
      userId: json['user_id'].toString(),
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      durasibulan: json['durasi_bulan'] ?? 1,
      alamat: json['alamat'] ?? '',
      catatan: json['catatan'],
      totalHarga: (json['total_harga'] as num).toDouble(),
      snapToken: json['snap_token'],
      paymentUrl: json['payment_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'status': status.name,
    'user_id': userId,
    'tanggal_mulai': tanggalMulai.toIso8601String(),
    'durasi_bulan': durasibulan,
    'alamat': alamat,
    'catatan': catatan,
    'total_harga': totalHarga,
    'snap_token': snapToken,
    'payment_url': paymentUrl,
    'created_at': createdAt.toIso8601String(),
  };
}