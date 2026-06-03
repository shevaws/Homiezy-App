import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_routes.dart';
import '../providers/auth_provider.dart';

class PlaceholderHomePage extends ConsumerWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.secondary, size: 64),
            const SizedBox(height: 16),
            Text('Login Berhasil! 🎉', style: AppTextStyles.displayMedium),
            const SizedBox(height: 8),
            Text('Halo, ${user?.name ?? 'User'}',
                style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            Text('Home page akan dibuat di Fase 2',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
              child: Text('Logout', style: AppTextStyles.link),
            ),
          ],
        ),
      ),
    );
  }
}