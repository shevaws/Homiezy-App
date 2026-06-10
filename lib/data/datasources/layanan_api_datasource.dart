import 'package:dio/dio.dart';
import '../models/kos_model.dart';
import '../models/catering_model.dart';
import '../models/laundry_model.dart';
import '../models/paket_model.dart';
import '../../domain/entities/paket_entity.dart';
import '../../services/api_service.dart';

class LayananApiDatasource {
  // ── KOS ──────────────────────────────────────────────
  Future<List<KosModel>> getKosList({
    String? query,
    String? tipe,
    double? maxHarga,
  }) async {
    try {
      final response = await ApiService.dio.get('/kos', queryParameters: {
        if (query != null && query.isNotEmpty) 'search': query,
        if (tipe != null) 'tipe': tipe,
        if (maxHarga != null) 'max_harga': maxHarga,
      });

      final List data = response.data['data'] ?? [];
      return data.map((e) => KosModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat data kos');
    }
  }

  // ── CATERING ─────────────────────────────────────────
  Future<List<CateringModel>> getCateringList({String? query}) async {
    try {
      final response = await ApiService.dio.get('/catering', queryParameters: {
        if (query != null && query.isNotEmpty) 'search': query,
      });

      final List data = response.data['data'] ?? [];
      return data.map((e) => CateringModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat data catering');
    }
  }

  // ── LAUNDRY ──────────────────────────────────────────
  Future<List<LaundryModel>> getLaundryList({String? query}) async {
    try {
      final response = await ApiService.dio.get('/laundry', queryParameters: {
        if (query != null && query.isNotEmpty) 'search': query,
      });

      final List data = response.data['data'] ?? [];
      return data.map((e) => LaundryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat data laundry');
    }
  }

  // ── PAKET ────────────────────────────────────────────
  Future<List<PaketModel>> getPaketList() async {
    try {
      final response = await ApiService.dio.get('/paket');
      final List data = response.data['data'] ?? [];

      return data.map((e) => PaketModel(
        id: e['id'],
        tipe: _parseTipePaket(e['tipe']),
        nama: e['nama'],
        deskripsi: e['deskripsi'],
        kos: KosModel.fromJson(e['kos']),
        catering: e['catering'] != null
            ? CateringModel.fromJson(e['catering'])
            : null,
        laundry: e['laundry'] != null
            ? LaundryModel.fromJson(e['laundry'])
            : null,
        hargaNormal: (e['harga_normal'] as num).toDouble(),
        hargaPaket: (e['harga_paket'] as num).toDouble(),
        diskonPersen: (e['diskon_persen'] as num).toDouble(),
      )).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat data paket');
    }
  }

  TipePaket _parseTipePaket(String tipe) {
    switch (tipe) {
      case 'kenyang': return TipePaket.kenyang;
      case 'bersih': return TipePaket.bersih;
      default: return TipePaket.lengkap;
    }
  }
}