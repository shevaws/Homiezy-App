import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';

class OrderHistoryPage extends ConsumerStatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  ConsumerState<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    Tab(text: 'Semua'),
    Tab(text: 'Aktif'),
    Tab(text: 'Selesai'),
    Tab(text: 'Dibatalkan'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Load orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        ref.read(orderProvider.notifier).loadOrders(user.id);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderEntity> _filterOrders(
      List<OrderEntity> orders, int tabIndex) {
    switch (tabIndex) {
      case 1: return orders.where((o) => o.status == OrderStatus.aktif).toList();
      case 2: return orders.where((o) => o.status == OrderStatus.selesai).toList();
      case 3: return orders.where((o) => o.status == OrderStatus.dibatalkan).toList();
      default: return orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Riwayat Pesanan',
            style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: AppTextStyles.bodyMedium
              .copyWith(fontWeight: FontWeight.w600),
          tabs: _tabs,
        ),
      ),
      body: orderState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: List.generate(4, (i) {
                final filtered =
                    _filterOrders(orderState.orders, i);
                if (filtered.isEmpty) return _buildEmpty(i);
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _buildOrderCard(context, filtered[index]),
                );
              }),
            ),
        bottomNavigationBar: BottomNavigationBar(
      currentIndex: 1, // tab Pesanan aktif
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, AppRoutes.profile);
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded), label: 'Pesanan'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: 'Profil'),
      ],
    ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context, AppRoutes.orderDetail,
        arguments: order,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05),
                blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTypeColor(order.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_getTypeIcon(order.type),
                      color: _getTypeColor(order.type), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.namaLayanan,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(order.id,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textHint)),
                    ],
                  ),
                ),
                _buildStatusBadge(order.status),
              ]),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.divider),
              ),

              // Detail
              Row(children: [
                _infoItem(Icons.calendar_today_rounded,
                    _formatDate(order.tanggalMulai)),
                const SizedBox(width: 16),
                _infoItem(Icons.access_time_rounded,
                    '${order.durasibulan} bulan'),
                const Spacer(),
                Text(
                  'Rp ${_formatHarga(order.totalHarga)}',
                  style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.primary),
                ),
              ]),

              // Tombol aksi jika pending
              if (order.status == OrderStatus.pending) ...[
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await ref.read(orderProvider.notifier)
                            .updateStatus(order.id, OrderStatus.dibatalkan);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('Batalkan',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.error,
                                  fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      // TODO: Re-trigger payment
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('Bayar Sekarang',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.pending: color = AppColors.warning; break;
      case OrderStatus.aktif: color = AppColors.success; break;
      case OrderStatus.selesai: color = AppColors.primary; break;
      case OrderStatus.dibatalkan: color = AppColors.error; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusLabel(status),
        style: AppTextStyles.bodySmall
            .copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 14, color: AppColors.textHint),
      const SizedBox(width: 4),
      Text(text, style: AppTextStyles.bodySmall),
    ]);
  }

  Widget _buildEmpty(int tabIndex) {
    final messages = [
      'Belum ada pesanan',
      'Tidak ada pesanan aktif',
      'Belum ada pesanan selesai',
      'Tidak ada pesanan dibatalkan',
    ];
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 64, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(messages[tabIndex], style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(
                context, AppRoutes.home),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Cari Layanan',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white,
                        fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(OrderType type) {
    switch (type) {
      case OrderType.kos: return AppColors.primary;
      case OrderType.catering: return const Color(0xFF10B981);
      case OrderType.laundry: return AppColors.accent;
      case OrderType.paket: return AppColors.primaryDark;
    }
  }

  IconData _getTypeIcon(OrderType type) {
    switch (type) {
      case OrderType.kos: return Icons.home_rounded;
      case OrderType.catering: return Icons.restaurant_rounded;
      case OrderType.laundry: return Icons.local_laundry_service_rounded;
      case OrderType.paket: return Icons.workspace_premium_rounded;
    }
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'Menunggu';
      case OrderStatus.aktif: return 'Aktif';
      case OrderStatus.selesai: return 'Selesai';
      case OrderStatus.dibatalkan: return 'Dibatalkan';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatHarga(double harga) {
    if (harga >= 1000000) return '${(harga / 1000000).toStringAsFixed(1)}jt';
    return '${(harga / 1000).toStringAsFixed(0)}rb';
  }
}