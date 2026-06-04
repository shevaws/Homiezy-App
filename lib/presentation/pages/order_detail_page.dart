import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/order_provider.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order =
        ModalRoute.of(context)!.settings.arguments as OrderEntity;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Pesanan',
            style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            _buildStatusBanner(order),
            const SizedBox(height: 20),

            // Info layanan
            _buildSection(
              title: 'Layanan Dipesan',
              child: _buildLayananInfo(order),
            ),
            const SizedBox(height: 16),

            // Info pesanan
            _buildSection(
              title: 'Detail Pesanan',
              child: Column(children: [
                _detailRow('ID Pesanan', order.id),
                _divider(),
                _detailRow('Tanggal Mulai',
                    _formatDate(order.tanggalMulai)),
                _divider(),
                _detailRow('Durasi', '${order.durasibulan} bulan'),
                _divider(),
                _detailRow('Alamat', order.alamat),
                if (order.catatan != null) ...[
                  _divider(),
                  _detailRow('Catatan', order.catatan!),
                ],
              ]),
            ),
            const SizedBox(height: 16),

            // Ringkasan harga
            _buildSection(
              title: 'Ringkasan Pembayaran',
              child: Column(children: [
                _detailRow('Harga Layanan',
                    'Rp ${_formatHarga(order.totalHarga / order.durasibulan)}/bln'),
                _divider(),
                _detailRow('Durasi', '${order.durasibulan} bulan'),
                _divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Pembayaran',
                        style: AppTextStyles.titleMedium),
                    Text('Rp ${_formatHarga(order.totalHarga)}',
                        style: AppTextStyles.titleMedium
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Tombol aksi
            if (order.status == OrderStatus.pending)
              _buildAksiButtons(context, ref, order),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(OrderEntity order) {
    Color color;
    IconData icon;
    String message;

    switch (order.status) {
      case OrderStatus.pending:
        color = AppColors.warning;
        icon = Icons.access_time_rounded;
        message = 'Menunggu pembayaran';
        break;
      case OrderStatus.aktif:
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        message = 'Pesanan sedang aktif';
        break;
      case OrderStatus.selesai:
        color = AppColors.primary;
        icon = Icons.done_all_rounded;
        message = 'Pesanan telah selesai';
        break;
      case OrderStatus.dibatalkan:
        color = AppColors.error;
        icon = Icons.cancel_rounded;
        message = 'Pesanan dibatalkan';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(order.statusLabel,
              style: AppTextStyles.titleMedium.copyWith(color: color)),
          Text(message, style: AppTextStyles.bodySmall),
        ]),
      ]),
    );
  }

  Widget _buildLayananInfo(OrderEntity order) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(_getTypeIcon(order.type),
            color: AppColors.primary, size: 24),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.namaLayanan, style: AppTextStyles.titleMedium),
            Text(_getTypeLabel(order.type),
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.primary)),
          ]),
      ),
    ]);
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildAksiButtons(
      BuildContext context, WidgetRef ref, OrderEntity order) {
    return Row(children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () async {
            await ref.read(orderProvider.notifier)
                .updateStatus(order.id, OrderStatus.dibatalkan);
            if (context.mounted) Navigator.pop(context);
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.error),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text('Batalkan Pesanan',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.error,
                      fontWeight: FontWeight.w600)),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text('Bayar Sekarang',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: Colors.white,
                      fontWeight: FontWeight.w600)),
        ),
      ),
    ]);
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          Expanded(
            child: Text(value,
                style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Divider(height: 1, color: AppColors.divider),
  );

  IconData _getTypeIcon(OrderType type) {
    switch (type) {
      case OrderType.kos: return Icons.home_rounded;
      case OrderType.catering: return Icons.restaurant_rounded;
      case OrderType.laundry: return Icons.local_laundry_service_rounded;
      case OrderType.paket: return Icons.workspace_premium_rounded;
    }
  }

  String _getTypeLabel(OrderType type) {
    switch (type) {
      case OrderType.kos: return 'Sewa Kos';
      case OrderType.catering: return 'Langganan Catering';
      case OrderType.laundry: return 'Langganan Laundry';
      case OrderType.paket: return 'Paket Bundling';
    }
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  String _formatHarga(double harga) {
    if (harga >= 1000000) return '${(harga / 1000000).toStringAsFixed(1)}jt';
    return '${(harga / 1000).toStringAsFixed(0)}rb';
  }
}