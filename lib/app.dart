import 'package:flutter/material.dart';
import 'package:homiezy/presentation/pages/home_page.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_text_styles.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/onboarding_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/detail/kos_detail_page.dart';
import 'presentation/pages/detail/catering_detail_page.dart';
import 'presentation/pages/detail/laundry_detail_page.dart';
import 'presentation/pages/detail/paket_detail_page.dart';
import 'presentation/pages/pemesanan_page.dart';
import 'presentation/pages/payment_result_page.dart';
import 'presentation/pages/order_history_page.dart';
import 'presentation/pages/order_detail_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/edit_profile_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Homiezy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: AppTextStyles.titleLarge,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.onboarding: (context) => const OnboardingPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.kosDetail: (context) => const KosDetailPage(),
        AppRoutes.cateringDetail: (context) => const CateringDetailPage(),
        AppRoutes.laundryDetail: (context) => const LaundryDetailPage(),
        AppRoutes.paketDetail: (context) => const PaketDetailPage(),
        AppRoutes.pemesanan: (context) => const PemesananPage(),
        AppRoutes.paymentResult: (context) => const PaymentResultPage(),
        AppRoutes.orderHistory: (context) => const OrderHistoryPage(),
        AppRoutes.orderDetail: (context) => const OrderDetailPage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.editProfile: (context) => const EditProfilePage(),
      },
    );
  }
}