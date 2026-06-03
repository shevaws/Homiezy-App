import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/catering_entity.dart';

class CateringCard extends StatelessWidget {
  final CateringEntity catering;
  final VoidCallback onTap;

  const CateringCard({super.key, required this.catering, required this.onTap});

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
            BoxShadow(color: Colors.black.withOpacity(0.06),
                blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Foto
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                catering.fotoUrls.isNotEmpty ? catering.fotoUrls[0] : '',
                width: 110, height: 110, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110, height: 110, color: AppColors.surfaceVariant,
                  child: const Icon(Icons.restaurant_rounded,
                      size: 36, color: AppColors.textHint),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(catering.nama, style: AppTextStyles.titleMedium,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('${catering.jumlahMakanPerHari}x makan/hari',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(catering.deskripsi, style: AppTextStyles.bodySmall,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${_formatHarga(catering.hargaPerBulan)}/bln',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(catering.rating.toStringAsFixed(1),
                              style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHarga(double harga) =>
      '${(harga / 1000).toStringAsFixed(0)}rb';
}