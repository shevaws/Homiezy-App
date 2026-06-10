import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/kos_entity.dart';
import '../../domain/entities/catering_entity.dart';
import '../../domain/entities/laundry_entity.dart';
import '../../domain/entities/paket_entity.dart';
import '../../data/datasources/layanan_api_datasource.dart';

// Datasource provider
final layananDatasourceProvider = Provider<LayananApiDatasource>(
  (ref) => LayananApiDatasource(),
);

// State class
class LayananState {
  final List<KosEntity> kosList;
  final List<CateringEntity> cateringList;
  final List<LaundryEntity> laundryList;
  final List<PaketEntity> paketList;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? filterTipeKos;
  final double? filterMaxHarga;
  final int activeTab; // 0=kos, 1=catering, 2=laundry, 3=paket

  const LayananState({
    this.kosList = const [],
    this.cateringList = const [],
    this.laundryList = const [],
    this.paketList = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.filterTipeKos,
    this.filterMaxHarga,
    this.activeTab = 0,
  });

  LayananState copyWith({
    List<KosEntity>? kosList,
    List<CateringEntity>? cateringList,
    List<LaundryEntity>? laundryList,
    List<PaketEntity>? paketList,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? filterTipeKos,
    double? filterMaxHarga,
    int? activeTab,
  }) {
    return LayananState(
      kosList: kosList ?? this.kosList,
      cateringList: cateringList ?? this.cateringList,
      laundryList: laundryList ?? this.laundryList,
      paketList: paketList ?? this.paketList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterTipeKos: filterTipeKos ?? this.filterTipeKos,
      filterMaxHarga: filterMaxHarga ?? this.filterMaxHarga,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

// Update LayananNotifier — ganti tipe datasource ke API
class LayananNotifier extends StateNotifier<LayananState> {
  final LayananApiDatasource _datasource;

  LayananNotifier(this._datasource) : super(const LayananState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await Future.wait([
        _datasource.getKosList(),
        _datasource.getCateringList(),
        _datasource.getLaundryList(),
        _datasource.getPaketList(),
      ]);
      state = state.copyWith(
        kosList: results[0] as List<KosEntity>,
        cateringList: results[1] as List<CateringEntity>,
        laundryList: results[2] as List<LaundryEntity>,
        paketList: results[3] as List<PaketEntity>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true);
    try {
      final kos = await _datasource.getKosList(
        query: query, tipe: state.filterTipeKos, maxHarga: state.filterMaxHarga,
      );
      final catering = await _datasource.getCateringList(query: query);
      final laundry = await _datasource.getLaundryList(query: query);
      state = state.copyWith(kosList: kos, cateringList: catering,
          laundryList: laundry, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setTab(int tab) => state = state.copyWith(activeTab: tab);

  void setFilterTipe(String? tipe) {
    state = state.copyWith(filterTipeKos: tipe);
    search(state.searchQuery);
  }

  void setFilterMaxHarga(double? harga) {
    state = state.copyWith(filterMaxHarga: harga);
    search(state.searchQuery);
  }
}

final layananProvider = StateNotifierProvider<LayananNotifier, LayananState>((ref) {
  return LayananNotifier(ref.watch(layananDatasourceProvider));
});