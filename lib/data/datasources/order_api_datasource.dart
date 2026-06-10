import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../services/api_service.dart';

class OrderApiDatasource {
  Future<OrderModel> createOrder({
    required OrderType type,
    required String userId,
    required DateTime tanggalMulai,
    required int durasibulan,
    required String alamat,
    String? catatan,
    required double totalHarga,
    dynamic layananData,
  }) async {
    try {
      // Ambil service_id dari layanan data
      String? serviceId;
      if (layananData != null) {
        serviceId = layananData.id?.toString();
      }

      final response = await ApiService.dio.post('/orders', data: {
        'service_id':    serviceId,
        'tanggal_mulai': tanggalMulai.toIso8601String(),
        'durasi_bulan':  durasibulan,
        'alamat':        alamat,
        'catatan':       catatan,
      });

      final data = response.data['data'];
      return OrderModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal membuat order');
    }
  }

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final response = await ApiService.dio.get('/orders');
      final List data = response.data['data'] ?? [];
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal memuat riwayat order');
    }
  }

  Future<OrderModel?> getOrderById(String id) async {
    try {
      final response = await ApiService.dio.get('/orders/$id');
      return OrderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Order tidak ditemukan');
    }
  }

  Future<OrderModel> updateOrderStatus(
      String id, OrderStatus status) async {
    try {
      if (status == OrderStatus.dibatalkan) {
        await ApiService.dio.patch('/orders/$id/cancel');
      }

      final response = await ApiService.dio.get('/orders/$id');
      return OrderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal update status order');
    }
  }
}