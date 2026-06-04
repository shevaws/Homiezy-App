import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import '../data/datasources/order_mock_datasource.dart';
import '../data/models/order_model.dart';
import '../domain/entities/order_entity.dart';

class PaymentService {
  static MidtransSDK? _midtrans;

  // Ganti dengan Client Key dari dashboard Midtrans
  static const _clientKey = 'SB-Mid-client-XXXXXXXXXXXXXXXX'; // Sandbox key

  static Future<void> init() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: _clientKey,
        merchantBaseUrl: '', // kosongkan, kita pakai snap token langsung
        enableLog: true,
      ),
    );
  }

  static Future<void> startPayment({
  required BuildContext context,
  required OrderModel order,
  required Function(String status) onResult,
}) async {
  // Simulasi loading sebentar
  await Future.delayed(const Duration(seconds: 1));
  
  // Langsung panggil onResult tanpa try-catch yang kompleks
  onResult('settlement');
}
}