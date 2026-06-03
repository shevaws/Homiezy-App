import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/catering_entity.dart';

class CateringDetailPage extends StatelessWidget {
  const CateringDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final catering =
        ModalRoute.of(context)!.settings.arguments as CateringEntity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF10B981),
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
              background: catering.fotoUrls.isNotEmpty
                  ? Image.network(catering.fotoUrls[0],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        child: const Icon(Icons.restaurant_rounded,
                            size: 80, color: Color(0xFF10B981)),
                      ))
                  : Container(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      child: const Icon(Icons.restaurant_rounded,
                          size: 80, color: Color(0xFF10B981)),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama & rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(catering.nama,
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
                          Text(catering.rating.toStringAsFixed(1),
                              style: AppTextStyles.titleMedium
                                  .copyWith(color: AppColors.accent)),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(catering.deskripsi, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 16),

                  // Info cards
                  Row(children: [
                    _infoCard(Icons.restaurant_rounded,
                        '${catering.jumlahMakanPerHari}x/hari', 'Porsi Makan',
                        const Color(0xFF10B981)),
                    const SizedBox(width: 12),
                    _infoCard(Icons.people_rounded,
                        '${catering.totalReview}', 'Pelanggan',
                        AppColors.primary),
                    const SizedBox(width: 12),
                    _infoCard(Icons.delivery_dining_rounded,
                        'Gratis', 'Antar ke Kamar',
                        AppColors.accent),
                  ]),
                  const SizedBox(height: 20),

                  // Contoh menu
                  Text('Contoh Menu', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 12),
                  ...catering.menuContoh.map((menu) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(children: [
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(menu, style: AppTextStyles.bodyLarge),
                    ]),
                  )),
                  const SizedBox(height: 20),

                  // Mitra info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF10B981),
                        radius: 20,
                        child: Text(catering.mitraNama[0].toUpperCase(),
                            style: AppTextStyles.titleMedium
                                .copyWith(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Penyedia Catering',
                              style: AppTextStyles.bodySmall),
                          Text(catering.mitraNama,
                              style: AppTextStyles.titleMedium),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // Review
                  Text('Ulasan', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 12),
                  _buildReviewItem('Rina W.', 5, 'Enak banget, menu variatif!'),
                  _buildReviewItem('Doni P.', 4, 'Porsinya pas, suka menunya.'),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, catering),
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
          Text(value, style: AppTextStyles.titleMedium.copyWith(color: color)),
          Text(label,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center),
        ]),
      ),
    );
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

  Widget _buildBottomBar(BuildContext context, CateringEntity catering) {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Harga per bulan', style: AppTextStyles.bodySmall),
          Text(
            'Rp ${(catering.hargaPerBulan / 1000).toStringAsFixed(0)}rb',
            style: AppTextStyles.titleLarge
                .copyWith(color: const Color(0xFF10B981)),
          ),
        ],
      ),
      const Spacer(),
      SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
              context, AppRoutes.pemesanan,
              arguments: {'type': 'catering', 'data': catering}),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
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