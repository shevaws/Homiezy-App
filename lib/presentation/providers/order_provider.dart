import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/order_api_datasource.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/models/order_model.dart';

class OrderState {
  final List<OrderEntity> orders;
  final OrderEntity? currentOrder;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const OrderState({
    this.orders = const [],
    this.currentOrder,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  OrderState copyWith({
    List<OrderEntity>? orders,
    OrderEntity? currentOrder,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderApiDatasource _datasource;

  OrderNotifier(this._datasource) : super(const OrderState());

  Future<OrderModel?> createOrder({
    required OrderType type,
    required String userId,
    required DateTime tanggalMulai,
    required int durasibulan,
    required String alamat,
    String? catatan,
    required double totalHarga,
    dynamic layananData,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final order = await _datasource.createOrder(
        type: type,
        userId: userId,
        tanggalMulai: tanggalMulai,
        durasibulan: durasibulan,
        alamat: alamat,
        catatan: catatan,
        totalHarga: totalHarga,
        layananData: layananData,
      );
      state = state.copyWith(
        isLoading: false,
        currentOrder: order,
        orders: [...state.orders, order],
      );
      return order;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  Future<void> loadOrders(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final orders = await _datasource.getOrdersByUser(userId);
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    try {
      final updated = await _datasource.updateOrderStatus(orderId, status);
      final updatedOrders = state.orders.map((o) {
        return o.id == orderId ? updated : o;
      }).toList();
      state = state.copyWith(orders: updatedOrders, currentOrder: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

final orderDatasourceProvider = Provider<OrderApiDatasource>(
  (ref) => OrderApiDatasource(),
);

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref.watch(orderDatasourceProvider));
});