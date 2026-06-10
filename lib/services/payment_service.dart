import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/order_model.dart';
import '../domain/entities/order_entity.dart';
import '../data/models/order_model.dart';

class PaymentService {
  static Future<void> startPayment({
    required BuildContext context,
    required OrderModel order,
    required Function(String status) onResult,
  }) async {
    // Kalau ada invoice URL dari Xendit, buka di browser
    if (order.paymentUrl != null && order.paymentUrl!.isNotEmpty) {
      final uri = Uri.parse(order.paymentUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        // Simulasi hasil setelah user kembali dari browser
        // Nanti bisa pakai deep link untuk result yang lebih akurat
        onResult('settlement');
        return;
      }
    }

    // Fallback simulasi
    await Future.delayed(const Duration(seconds: 1));
    onResult('settlement');
  }
}