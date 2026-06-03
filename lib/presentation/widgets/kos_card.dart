import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/kos_entity.dart';

class KosCard extends StatelessWidget {
  final KosEntity kos;
  final VoidCallback onTap;

  const KosCard({super.key, required this.kos, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    kos.fotoUrls.isNotEmpty ? kos.fotoUrls[0] : '',
                    height: 160, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.home_rounded,
                          size: 48, color: AppColors.textHint),
                    ),
                  ),
                ),
                // Badge tipe
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTipeColor(kos.tipe),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getTipeLabel(kos.tipe),
                      style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                // Badge tidak tersedia
                if (!kos.tersedia)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: Container(
                        color: Colors.black45,
                        child: Center(
                          child: Text('Penuh',
                              style: AppTextStyles.titleMedium
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kos.nama,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_rounded,
                        size: 14, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(kos.alamat,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    if (kos.jarak != null)
                      Text('${kos.jarak!.toStringAsFixed(1)} km',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.primary)),
                  ]),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${_formatHarga(kos.hargaPerBulan)}/bln',
                        style: AppTextStyles.titleMedium
                            .copyWith(color: AppColors.primary),
                      ),
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            size: 16, color: AppColors.accent),
                        const SizedBox(width: 2),
                        Text(kos.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        Text(' (${kos.totalReview})',
                            style: AppTextStyles.bodySmall),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTipeColor(String tipe) {
    switch (tipe) {
      case 'putra': return AppColors.primary;
      case 'putri': return const Color(0xFFEC4899);
      default: return AppColors.secondary;
    }
  }

  String _getTipeLabel(String tipe) {
    switch (tipe) {
      case 'putra': return 'Putra';
      case 'putri': return 'Putri';
      default: return 'Campur';
    }
  }

  String _formatHarga(double harga) {
    if (harga >= 1000000) {
      return '${(harga / 1000000).toStringAsFixed(1)}jt';
    }
    return '${(harga / 1000).toStringAsFixed(0)}rb';
  }
}