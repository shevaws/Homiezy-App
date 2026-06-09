import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/kos_entity.dart';

class KosDetailPage extends StatefulWidget {
  const KosDetailPage({super.key});

  @override
  State<KosDetailPage> createState() => _KosDetailPageState();
}

class _KosDetailPageState extends State<KosDetailPage> {
  int _currentPhoto = 0;

  @override
  Widget build(BuildContext context) {
    final kos = ModalRoute.of(context)!.settings.arguments as KosEntity;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotoHeader(context, kos),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNamaRating(kos),
                      const SizedBox(height: 8),
                      _buildAlamat(kos),
                      const SizedBox(height: 20),
                      _buildMitra(kos),
                      const SizedBox(height: 20),
                      _buildFasilitas(kos),
                      const SizedBox(height: 20),
                      _buildUlasan(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Back button overlay ─────────────────────────
          Positioned(
            top: statusBarHeight + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, kos),
    );
  }

  Widget _buildPhotoHeader(BuildContext context, KosEntity kos) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          // Foto carousel
          PageView.builder(
            itemCount: kos.fotoUrls.isEmpty ? 1 : kos.fotoUrls.length,
            onPageChanged: (i) => setState(() => _currentPhoto = i),
            itemBuilder: (context, i) {
              return kos.fotoUrls.isNotEmpty
                  ? Image.network(
                      kos.fotoUrls[i],
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _photoPlaceholder(),
                    )
                  : _photoPlaceholder();
            },
          ),

          // Dots indicator
          if (kos.fotoUrls.length > 1)
            Positioned(
              bottom: 12, left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(kos.fotoUrls.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPhoto == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentPhoto == i
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),

          // Badge tipe kos
          Positioned(
            top: 16, right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
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
        ],
      ),
    );
  }

  Widget _buildNamaRating(KosEntity kos) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(kos.nama, style: AppTextStyles.displayMedium),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            const Icon(Icons.star_rounded, size: 16, color: AppColors.accent),
            const SizedBox(width: 4),
            Text(kos.rating.toStringAsFixed(1),
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.accent)),
          ]),
        ),
      ],
    );
  }

  Widget _buildAlamat(KosEntity kos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.location_on_rounded,
              size: 16, color: AppColors.textHint),
          const SizedBox(width: 4),
          Expanded(
            child: Text(kos.alamat, style: AppTextStyles.bodyMedium),
          ),
        ]),
        if (kos.jarak != null) ...[
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.directions_walk_rounded,
                size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              '${kos.jarak!.toStringAsFixed(1)} km dari lokasi kamu',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.primary),
            ),
          ]),
        ],
      ],
    );
  }

  Widget _buildMitra(KosEntity kos) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 20,
          child: Text(kos.mitraNama[0].toUpperCase(),
              style: AppTextStyles.titleMedium
                  .copyWith(color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Pemilik Kos', style: AppTextStyles.bodySmall),
          Text(kos.mitraNama, style: AppTextStyles.titleMedium),
        ]),
        const Spacer(),
        const Icon(Icons.chat_bubble_outline_rounded,
            color: AppColors.primary),
      ]),
    );
  }

  Widget _buildFasilitas(KosEntity kos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fasilitas', style: AppTextStyles.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: kos.fasilitas.map((f) => Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(_getFasilitasIcon(f),
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(f, style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
            ]),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildUlasan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ulasan', style: AppTextStyles.titleLarge),
        const SizedBox(height: 12),
        _reviewItem('Budi S.', 5,
            'Kamar bersih, pemilik ramah, lokasi strategis!'),
        _reviewItem('Ani R.', 4,
            'WiFi kencang, fasilitas lengkap. Recommended!'),
      ],
    );
  }

  Widget _reviewItem(String nama, int bintang, String komentar) {
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
            child: Text(nama[0], style: AppTextStyles.bodySmall
                .copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          Text(nama,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
          const Spacer(),
          Row(children: List.generate(5, (i) => Icon(
            i < bintang
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            size: 14, color: AppColors.accent,
          ))),
        ]),
        const SizedBox(height: 8),
        Text(komentar, style: AppTextStyles.bodyMedium),
      ]),
    );
  }

  Widget _buildBottomBar(BuildContext context, KosEntity kos) {
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
              'Rp ${_formatHarga(kos.hargaPerBulan)}',
              style: AppTextStyles.titleLarge
                  .copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: kos.tersedia
                ? () => Navigator.pushNamed(
                    context, AppRoutes.pemesanan,
                    arguments: {'type': 'kos', 'data': kos})
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.divider,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 28),
            ),
            child: Text(
              kos.tersedia ? 'Pesan Sekarang' : 'Tidak Tersedia',
              style: AppTextStyles.labelLarge,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(Icons.home_rounded,
            size: 64, color: AppColors.textHint),
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

  IconData _getFasilitasIcon(String fasilitas) {
    switch (fasilitas.toLowerCase()) {
      case 'wifi': return Icons.wifi_rounded;
      case 'ac': return Icons.ac_unit_rounded;
      case 'kamar mandi dalam': return Icons.bathtub_rounded;
      case 'lemari': return Icons.door_sliding_rounded;
      case 'kasur': return Icons.bed_rounded;
      case 'tv': return Icons.tv_rounded;
      case 'kulkas': return Icons.kitchen_rounded;
      case 'parkir motor': return Icons.two_wheeler_rounded;
      case 'dapur bersama': return Icons.soup_kitchen_rounded;
      case 'meja belajar': return Icons.desk_rounded;
      default: return Icons.check_circle_rounded;
    }
  }

  String _formatHarga(double harga) {
    if (harga >= 1000000) {
      return '${(harga / 1000000).toStringAsFixed(1)}jt/bln';
    }
    return '${(harga / 1000).toStringAsFixed(0)}rb/bln';
  }
}