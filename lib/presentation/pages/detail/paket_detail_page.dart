import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/paket_entity.dart';

class PaketDetailPage extends StatelessWidget {
  const PaketDetailPage({super.key});

  Color get _warna => const Color(0xFFF59E0B); // override per tipe jika perlu

  @override
  Widget build(BuildContext context) {
    final paket =
        ModalRoute.of(context)!.settings.arguments as PaketEntity;
    final warna = _getWarna(paket.tipe);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: warna,
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
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [warna.withOpacity(0.8), warna],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(_getIcon(paket.tipe),
                          color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 12),
                    Text(paket.namaLabel,
                        style: AppTextStyles.titleLarge
                            .copyWith(color: Colors.white)),
                    Text(paket.deskripsiLayanan,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Harga dengan diskon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: warna.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: warna.withOpacity(0.2)),
                    ),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Harga Normal',
                              style: AppTextStyles.bodySmall),
                          Text(
                            'Rp ${_formatHarga(paket.hargaNormal)}/bln',
                            style: AppTextStyles.bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textHint,
                            ),
                          ),
                          Text(
                            'Rp ${_formatHarga(paket.hargaPaket)}/bln',
                            style: AppTextStyles.titleLarge
                                .copyWith(color: warna),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: warna,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Hemat\n${paket.diskonPersen.toInt()}%',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  Text('Yang Termasuk', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 12),

                  // Kos detail
                  _layananCard(
                    icon: Icons.home_rounded,
                    color: AppColors.primary,
                    title: paket.kos.nama,
                    subtitle: paket.kos.alamat,
                    harga: 'Rp ${_formatHarga(paket.kos.hargaPerBulan)}/bln',
                    details: paket.kos.fasilitas.take(3).toList(),
                  ),

                  // Catering detail (kalau ada)
                  if (paket.catering != null)
                    _layananCard(
                      icon: Icons.restaurant_rounded,
                      color: const Color(0xFF10B981),
                      title: paket.catering!.nama,
                      subtitle:
                          '${paket.catering!.jumlahMakanPerHari}x makan per hari',
                      harga:
                          'Rp ${_formatHarga(paket.catering!.hargaPerBulan)}/bln',
                      details: paket.catering!.menuContoh.take(3).toList(),
                    ),

                  // Laundry detail (kalau ada)
                  if (paket.laundry != null)
                    _layananCard(
                      icon: Icons.local_laundry_service_rounded,
                      color: AppColors.accent,
                      title: paket.laundry!.nama,
                      subtitle:
                          'Selesai dalam ${paket.laundry!.estimasiHari} hari',
                      harga:
                          'Rp ${_formatHarga(paket.laundry!.hargaPerBulan)}/bln',
                      details: paket.laundry!.layanan,
                    ),

                  const SizedBox(height: 20),
                  Text('Deskripsi', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 8),
                  Text(paket.deskripsi, style: AppTextStyles.bodyMedium),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, paket, warna),
    );
  }

  Widget _layananCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String harga,
    required List<String> details,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(harga,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: color, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: details.map((d) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(d,
                style: AppTextStyles.bodySmall
                    .copyWith(color: color)),
          )).toList(),
        ),
      ]),
    );
  }

  Widget _buildBottomBar(BuildContext context, PaketEntity paket, Color warna) {
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
          Text('Total per bulan', style: AppTextStyles.bodySmall),
          Text(
            'Rp ${_formatHarga(paket.hargaPaket)}',
            style: AppTextStyles.titleLarge.copyWith(color: warna),
          ),
        ],
      ),
      const Spacer(),
      SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
              context, AppRoutes.pemesanan,
              arguments: {'type': 'paket', 'data': paket}),
          style: ElevatedButton.styleFrom(
            backgroundColor: warna,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 28),
          ),
          child: Text('Pilih Paket', style: AppTextStyles.labelLarge),
        ),
      ),
    ]),
  );
}

  Color _getWarna(TipePaket tipe) {
    switch (tipe) {
      case TipePaket.kenyang: return const Color(0xFF10B981);
      case TipePaket.bersih: return AppColors.primary;
      case TipePaket.lengkap: return const Color(0xFFF59E0B);
    }
  }

  IconData _getIcon(TipePaket tipe) {
    switch (tipe) {
      case TipePaket.kenyang: return Icons.restaurant_rounded;
      case TipePaket.bersih: return Icons.local_laundry_service_rounded;
      case TipePaket.lengkap: return Icons.workspace_premium_rounded;
    }
  }

  String _formatHarga(double harga) {
    if (harga >= 1000000) return '${(harga / 1000000).toStringAsFixed(1)}jt';
    return '${(harga / 1000).toStringAsFixed(0)}rb';
  }
}