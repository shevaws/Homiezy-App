import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final orderState = ref.watch(orderProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.isAuthenticated && next.user != null) {
        ref.read(orderProvider.notifier).loadOrders(next.user!.id);
      }
    });
    
    final totalAktif = orderState.orders
        .where((o) => o.status.name == 'aktif').length;
    final totalSelesai = orderState.orders
        .where((o) => o.status.name == 'selesai').length;
    final totalPesanan = orderState.orders.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(context, ref, user),

            // Stats
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildStats(totalPesanan, totalAktif, totalSelesai),
            ),

            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Akun', style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.textHint)),
                  const SizedBox(height: 8),
                  _buildMenuGroup([
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profil',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.editProfile),
                    ),
                    _MenuItem(
                      icon: Icons.receipt_long_rounded,
                      label: 'Riwayat Pesanan',
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.orderHistory),
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'Alamat Tersimpan',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 20),

                  Text('Lainnya', style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.textHint)),
                  const SizedBox(height: 8),
                  _buildMenuGroup([
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Bantuan & FAQ',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      label: 'Tentang Aplikasi',
                      onTap: () => _showAboutDialog(context),
                    ),
                    _MenuItem(
                      icon: Icons.star_outline_rounded,
                      label: 'Beri Rating Aplikasi',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // Logout
                  _buildMenuGroup([
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Keluar',
                      color: AppColors.error,
                      onTap: () => _showLogoutDialog(context, ref),
                    ),
                  ]),
                  const SizedBox(height: 32),

                  // Version
                  Center(
                    child: Text('Homiezy v1.0.0',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textHint)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.orderHistory);
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

  Widget _buildHeader(BuildContext context, WidgetRef ref, user) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white24,
                    backgroundImage: user?.photoUrl != null
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                    child: user?.photoUrl == null
                        ? Text(
                            user?.name.isNotEmpty == true
                                ? user!.name[0].toUpperCase()
                                : 'U',
                            style: AppTextStyles.displayMedium
                                .copyWith(color: Colors.white),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.editProfile),
                      child: Container(
                        width: 28, height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nama
              Text(
                user?.name ?? 'User',
                style: AppTextStyles.titleLarge
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4),

              // Email
              Text(
                user?.email ?? '',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white70),
              ),
              if (user?.phone != null) ...[
                const SizedBox(height: 4),
                Text(
                  user!.phone!,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: Colors.white60),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(int total, int aktif, int selesai) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08),
                blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(children: [
          _statItem('Total', total.toString(), AppColors.primary),
          _verticalDivider(),
          _statItem('Aktif', aktif.toString(), AppColors.success),
          _verticalDivider(),
          _statItem('Selesai', selesai.toString(), AppColors.accent),
        ]),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Column(children: [
        Text(value,
            style: AppTextStyles.displayMedium.copyWith(color: color)),
        Text(label, style: AppTextStyles.bodySmall),
      ]),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.divider,
    );
  }

  Widget _buildMenuGroup(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                onTap: item.onTap,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (item.color ?? AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon,
                      color: item.color ?? AppColors.primary, size: 20),
                ),
                title: Text(item.label,
                    style: AppTextStyles.bodyLarge.copyWith(
                        color: item.color ?? AppColors.textPrimary)),
                trailing: item.color == null
                    ? const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.textHint)
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              if (i < items.length - 1)
                const Divider(
                    height: 1, indent: 56, color: AppColors.divider),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Keluar', style: AppTextStyles.titleLarge),
        content: Text(
          'Apakah kamu yakin ingin keluar dari akun Homiezy?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint)),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Keluar',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white,
                        fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.home_work_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Homiezy', style: AppTextStyles.titleLarge),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versi 1.0.0', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            Text(
              'Platform pencarian kos, catering, dan laundry terpadu untuk mahasiswa.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Tutup',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}