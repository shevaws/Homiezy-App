import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/paket_entity.dart';

class PaketCard extends StatelessWidget {
  final PaketEntity paket;
  final VoidCallback onTap;

  const PaketCard({super.key, required this.paket, required this.onTap});

  Color get _warna {
    switch (paket.tipe) {
      case TipePaket.kenyang: return const Color(0xFF10B981);
      case TipePaket.bersih: return AppColors.primary;
      case TipePaket.lengkap: return const Color(0xFFF59E0B);
    }
  }

  IconData get _icon {
    switch (paket.tipe) {
      case TipePaket.kenyang: return Icons.restaurant_rounded;
      case TipePaket.bersih: return Icons.local_laundry_service_rounded;
      case TipePaket.lengkap: return Icons.workspace_premium_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [_warna, _warna.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: _warna.withOpacity(0.3),
                blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(paket.namaLabel,
                          style: AppTextStyles.titleLarge
                              .copyWith(color: Colors.white)),
                      Text(paket.deskripsiLayanan,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Hemat ${paket.diskonPersen.toInt()}%',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: _warna, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(paket.deskripsi,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white70)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rp ${_formatHarga(paket.hargaNormal)}/bln',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white54,
                            decoration: TextDecoration.lineThrough),
                      ),
                      Text(
                        'Rp ${_formatHarga(paket.hargaPaket)}/bln',
                        style: AppTextStyles.titleLarge
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Pilih Paket',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: _warna, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatHarga(double harga) {
    if (harga >= 1000000) return '${(harga / 1000000).toStringAsFixed(1)}jt';
    return '${(harga / 1000).toStringAsFixed(0)}rb';
  }
}