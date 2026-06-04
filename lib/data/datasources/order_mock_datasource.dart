import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';

class OrderMockDatasource {
  static const _delay = Duration(milliseconds: 1000);

  // Simulasi list order user
  static final List<OrderModel> _orders = [];

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
    await Future.delayed(_delay);

    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      status: OrderStatus.pending,
      userId: userId,
      tanggalMulai: tanggalMulai,
      durasibulan: durasibulan,
      alamat: alamat,
      catatan: catatan,
      totalHarga: totalHarga,
      // Mock snap token — nanti diganti dari response Laravel
      snapToken: 'mock-snap-token-${DateTime.now().millisecondsSinceEpoch}',
      paymentUrl: 'https://app.sandbox.midtrans.com/snap/v2/vtweb/mock',
      createdAt: DateTime.now(),
      kos: type == OrderType.kos ? layananData : null,
      catering: type == OrderType.catering ? layananData : null,
      laundry: type == OrderType.laundry ? layananData : null,
      paket: type == OrderType.paket ? layananData : null,
    );

    _orders.add(order);
    return order;
  }

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    await Future.delayed(_delay);
    return _orders.where((o) => o.userId == userId).toList();
  }

  Future<OrderModel?> getOrderById(String id) async {
    await Future.delayed(_delay);
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<OrderModel> updateOrderStatus(
      String id, OrderStatus status) async {
    await Future.delayed(_delay);
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) throw Exception('Order tidak ditemukan');

    final updated = OrderModel(
      id: _orders[index].id,
      type: _orders[index].type,
      status: status,
      userId: _orders[index].userId,
      tanggalMulai: _orders[index].tanggalMulai,
      durasibulan: _orders[index].durasibulan,
      alamat: _orders[index].alamat,
      catatan: _orders[index].catatan,
      totalHarga: _orders[index].totalHarga,
      snapToken: _orders[index].snapToken,
      paymentUrl: _orders[index].paymentUrl,
      createdAt: _orders[index].createdAt,
    );

    _orders[index] = updated;
    return updated;
  }
}