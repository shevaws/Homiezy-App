import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/laundry_entity.dart';

class LaundryCard extends StatelessWidget {
  final LaundryEntity laundry;
  final VoidCallback onTap;

  const LaundryCard({super.key, required this.laundry, required this.onTap});

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
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                laundry.fotoUrls.isNotEmpty ? laundry.fotoUrls[0] : '',
                width: 110, height: 110, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110, height: 110, color: AppColors.surfaceVariant,
                  child: const Icon(Icons.local_laundry_service_rounded,
                      size: 36, color: AppColors.textHint),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(laundry.nama, style: AppTextStyles.titleMedium,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('Selesai ${laundry.estimasiHari} hari',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: laundry.layanan.map((l) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(l,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary)),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${_formatHarga(laundry.hargaPerKg)}/kg',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(laundry.rating.toStringAsFixed(1),
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
      harga >= 1000 ? '${(harga / 1000).toStringAsFixed(0)}rb' : harga.toStringAsFixed(0);
}