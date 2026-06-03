import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/laundry_entity.dart';

class LaundryDetailPage extends StatelessWidget {
  const LaundryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final laundry =
        ModalRoute.of(context)!.settings.arguments as LaundryEntity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: laundry.fotoUrls.isNotEmpty
                  ? Image.network(laundry.fotoUrls[0], fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.local_laundry_service_rounded,
                            size: 80, color: AppColors.primary),
                      ))
                  : Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.local_laundry_service_rounded,
                          size: 80, color: AppColors.primary),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(laundry.nama,
                              style: AppTextStyles.displayMedium)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(laundry.rating.toStringAsFixed(1),
                              style: AppTextStyles.titleMedium
                                  .copyWith(color: AppColors.accent)),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(laundry.deskripsi, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 16),

                  // Info cards
                  Row(children: [
                    _infoCard(Icons.timer_rounded,
                        '${laundry.estimasiHari} hari', 'Estimasi Selesai',
                        AppColors.primary),
                    const SizedBox(width: 12),
                    _infoCard(Icons.scale_rounded,
                        'Rp ${(laundry.hargaPerKg / 1000).toStringAsFixed(0)}rb',
                        'Per Kilogram', const Color(0xFF10B981)),
                    const SizedBox(width: 12),
                    _infoCard(Icons.calendar_month_rounded,
                        'Rp ${(laundry.hargaPerBulan / 1000).toStringAsFixed(0)}rb',
                        'Paket Bulanan', AppColors.accent),
                  ]),
                  const SizedBox(height: 20),

                  // Layanan tersedia
                  Text('Layanan', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 12),
                  ...laundry.layanan.map((l) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_getLayananIcon(l),
                            size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Text(l, style: AppTextStyles.bodyLarge),
                      const Spacer(),
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.secondary, size: 20),
                    ]),
                  )),
                  const SizedBox(height: 20),

                  // Mitra
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 20,
                        child: Text(laundry.mitraNama[0].toUpperCase(),
                            style: AppTextStyles.titleMedium
                                .copyWith(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Penyedia Laundry',
                              style: AppTextStyles.bodySmall),
                          Text(laundry.mitraNama,
                              style: AppTextStyles.titleMedium),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  Text('Ulasan', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 12),
                  _buildReviewItem('Sari M.', 5,
                      'Bersih dan wangi, tepat waktu!'),
                  _buildReviewItem('Hendra K.', 4,
                      'Antar jemput sangat membantu.'),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, laundry),
    );
  }

  Widget _infoCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value,
              style: AppTextStyles.titleMedium.copyWith(color: color),
              textAlign: TextAlign.center),
          Text(label,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  IconData _getLayananIcon(String layanan) {
    switch (layanan.toLowerCase()) {
      case 'cuci': return Icons.local_laundry_service_rounded;
      case 'setrika': return Icons.iron_rounded;
      case 'antar jemput': return Icons.delivery_dining_rounded;
      case 'express': return Icons.flash_on_rounded;
      default: return Icons.check_rounded;
    }
  }

  Widget _buildReviewItem(String nama, int bintang, String komentar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceVariant,
            child: Text(nama[0],
                style: AppTextStyles.bodySmall
                    .copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          Text(nama,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
          const Spacer(),
          Row(children: List.generate(5, (i) => Icon(
            i < bintang ? Icons.star_rounded : Icons.star_border_rounded,
            size: 14, color: AppColors.accent,
          ))),
        ]),
        const SizedBox(height: 8),
        Text(komentar, style: AppTextStyles.bodyMedium),
      ]),
    );
  }

  Widget _buildBottomBar(BuildContext context, LaundryEntity laundry) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20, offset: const Offset(0, -4))],
    ),
    child: Row(children: [
      Column(
        mainAxisSize: MainAxisSize.min, // ← tambah ini
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mulai dari', style: AppTextStyles.bodySmall),
          Text('Rp ${(laundry.hargaPerKg / 1000).toStringAsFixed(0)}rb/kg',
              style: AppTextStyles.titleLarge
                  .copyWith(color: AppColors.primary)),
        ]),
      const Spacer(),
      SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
              context, AppRoutes.pemesanan,
              arguments: {'type': 'laundry', 'data': laundry}),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 28),
          ),
          child: Text('Pesan Sekarang', style: AppTextStyles.labelLarge),
        ),
      ),
    ]),
  );
}
}