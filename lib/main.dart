import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_links/app_links.dart';
import 'core/constants/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Handle deep link saat app dibuka dari browser
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen((uri) {
    if (uri.host == 'payment') {
      if (uri.path == '/success') {
        // Navigate ke payment result
        navigatorKey.currentState?.pushReplacementNamed(
          AppRoutes.paymentResult,
          arguments: {'status': 'settlement'},
        );
      } else if (uri.path == '/failure') {
        navigatorKey.currentState?.pushReplacementNamed(
          AppRoutes.paymentResult,
          arguments: {'status': 'failed'},
        );
      }
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}