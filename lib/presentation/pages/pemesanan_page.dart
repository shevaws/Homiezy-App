import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/kos_entity.dart';
import '../../domain/entities/catering_entity.dart';
import '../../domain/entities/laundry_entity.dart';
import '../../domain/entities/paket_entity.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../../services/payment_service.dart';

class PemesananPage extends ConsumerStatefulWidget {
  const PemesananPage({super.key});

  @override
  ConsumerState<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends ConsumerState<PemesananPage> {
  final _formKey = GlobalKey<FormState>();
  final _alamatController = TextEditingController();
  final _catatanController = TextEditingController();

  DateTime _tanggalMulai = DateTime.now().add(const Duration(days: 1));
  int _durasi = 1;

  @override
  void dispose() {
    _alamatController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Ambil data dari arguments
  Map<String, dynamic> get _args =>
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

  String get _type => _args['type'] as String;
  dynamic get _data => _args['data'];

  String get _namaLayanan {
    switch (_type) {
      case 'kos': return (_data as KosEntity).nama;
      case 'catering': return (_data as CateringEntity).nama;
      case 'laundry': return (_data as LaundryEntity).nama;
      case 'paket': return (_data as PaketEntity).namaLabel;
      default: return '';
    }
  }

  double get _hargaPerBulan {
    switch (_type) {
      case 'kos': return (_data as KosEntity).hargaPerBulan;
      case 'catering': return (_data as CateringEntity).hargaPerBulan;
      case 'laundry': return (_data as LaundryEntity).hargaPerBulan;
      case 'paket': return (_data as PaketEntity).hargaPaket;
      default: return 0;
    }
  }

  double get _totalHarga => _hargaPerBulan * _durasi;

  OrderType get _orderType {
    switch (_type) {
      case 'kos': return OrderType.kos;
      case 'catering': return OrderType.catering;
      case 'laundry': return OrderType.laundry;
      case 'paket': return OrderType.paket;
      default: return OrderType.kos;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authProvider).user;
    if (user == null) return;

    // Buat order
    final order = await ref.read(orderProvider.notifier).createOrder(
      type: _orderType,
      userId: user.id,
      tanggalMulai: _tanggalMulai,
      durasibulan: _durasi,
      alamat: _alamatController.text.trim(),
      catatan: _catatanController.text.trim().isEmpty
          ? null
          : _catatanController.text.trim(),
      totalHarga: _totalHarga,
      layananData: _data,
    );

    if (order == null || !mounted) return;

    // Proses pembayaran
    await PaymentService.startPayment(
      context: context,
      order: order,
      onResult: (status) async {
        if (status == 'settlement' || status == 'capture') {
          await ref.read(orderProvider.notifier)
              .updateStatus(order.id, OrderStatus.aktif);
        }
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.paymentResult,
            arguments: {'order': order, 'status': status},
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Form Pemesanan', style: AppTextStyles.titleLarge),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan layanan
              _buildRingkasanLayanan(),
              const SizedBox(height: 24),

              // Tanggal mulai
              Text('Tanggal Mulai', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: AppColors.textHint, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd MMMM yyyy', 'id').format(_tanggalMulai),
                      style: AppTextStyles.bodyLarge,
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down_rounded,
                        color: AppColors.textHint),
                  ]),
                ),
              ),
              const SizedBox(height: 16),

              // Durasi
              Text('Durasi Sewa', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(children: [
                  const Icon(Icons.access_time_rounded,
                      color: AppColors.textHint, size: 20),
                  const SizedBox(width: 12),
                  Text('$_durasi bulan', style: AppTextStyles.bodyLarge),
                  const Spacer(),
                  // Minus button
                  GestureDetector(
                    onTap: () {
                      if (_durasi > 1) setState(() => _durasi--);
                    },
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: _durasi > 1
                            ? AppColors.primary
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.remove_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Plus button
                  GestureDetector(
                    onTap: () {
                      if (_durasi < 12) setState(() => _durasi++);
                    },
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              // Alamat
              AuthTextField(
                controller: _alamatController,
                label: 'Alamat Lengkap',
                hint: 'Jl. Contoh No. 1, Kota',
                prefixIcon: Icons.home_outlined,
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Alamat wajib diisi';
                  if (v.length < 10) return 'Alamat terlalu singkat';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Catatan (opsional)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('Catatan', style: AppTextStyles.titleMedium
                        .copyWith(fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Opsional',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textHint)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _catatanController,
                    maxLines: 3,
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Permintaan khusus, informasi tambahan...',
                      hintStyle: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textHint),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Ringkasan harga
              _buildRingkasanHarga(),
              const SizedBox(height: 24),

              // Error
              if (orderState.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(orderState.errorMessage!,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.error)),
                    ),
                  ]),
                ),

              // Submit button
              PrimaryButton(
                label: 'Lanjut ke Pembayaran',
                isLoading: orderState.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRingkasanLayanan() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getTypeIcon(), color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_namaLayanan,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(_getTypeLabel(),
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primary)),
            ],
          ),
        ),
        Text(
          'Rp ${_formatHarga(_hargaPerBulan)}/bln',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
        ),
      ]),
    );
  }

  Widget _buildRingkasanHarga() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(children: [
        _hargaRow('Harga per bulan',
            'Rp ${_formatHarga(_hargaPerBulan)}'),
        const SizedBox(height: 8),
        _hargaRow('Durasi', '$_durasi bulan'),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: AppColors.divider),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: AppTextStyles.titleMedium),
            Text(
              'Rp ${_formatHarga(_totalHarga)}',
              style: AppTextStyles.titleLarge
                  .copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _hargaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.bodyMedium
            .copyWith(fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMulai,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _tanggalMulai = picked);
  }

  IconData _getTypeIcon() {
    switch (_type) {
      case 'kos': return Icons.home_rounded;
      case 'catering': return Icons.restaurant_rounded;
      case 'laundry': return Icons.local_laundry_service_rounded;
      case 'paket': return Icons.workspace_premium_rounded;
      default: return Icons.home_rounded;
    }
  }

  String _getTypeLabel() {
    switch (_type) {
      case 'kos': return 'Sewa Kos';
      case 'catering': return 'Langganan Catering';
      case 'laundry': return 'Langganan Laundry';
      case 'paket': return 'Paket Bundling';
      default: return '';
    }
  }

  String _formatHarga(double harga) {
    if (harga >= 1000000) return '${(harga / 1000000).toStringAsFixed(1)}jt';
    return '${(harga / 1000).toStringAsFixed(0)}rb';
  }
}