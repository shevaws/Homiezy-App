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
  // Parse status
  OrderStatus parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'success':   return OrderStatus.aktif;
      case 'cancelled': return OrderStatus.dibatalkan;
      case 'selesai':   return OrderStatus.selesai;
      default:          return OrderStatus.pending;
    }
  }

  // Parse type
  OrderType parseType(String? t) {
    switch (t?.toLowerCase()) {
      case 'katering':  return OrderType.catering;
      case 'laundry':   return OrderType.laundry;
      case 'paket':     return OrderType.paket;
      default:          return OrderType.kos;
    }
  }

  return OrderModel(
    id: json['id']?.toString() ?? '',
    type: parseType(json['tipe'] ?? json['type']),
    status: parseStatus(json['status']),
    userId: json['user_id']?.toString() ?? '',
    tanggalMulai: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now(),
    durasibulan: json['durasi_bulan'] ?? 1,
    alamat: json['alamat'] ?? '',
    catatan: json['catatan'],
    totalHarga: (json['total_harga'] ?? json['price'] ?? 0).toDouble(),
    snapToken: null,
    paymentUrl: json['xendit_invoice_url'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now(),
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