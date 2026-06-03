import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_routes.dart';
import '../../domain/entities/kos_entity.dart';
import '../../domain/entities/catering_entity.dart';
import '../../domain/entities/laundry_entity.dart';
import '../../domain/entities/paket_entity.dart';
import '../providers/auth_provider.dart';
import '../providers/layanan_provider.dart';
import '../widgets/kos_card.dart';
import '../widgets/catering_card.dart';
import '../widgets/laundry_card.dart';
import '../widgets/paket_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final _tabs = const [
    Tab(text: 'Kos'),
    Tab(text: 'Catering'),
    Tab(text: 'Laundry'),
    Tab(text: 'Paket'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(layananProvider.notifier).setTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final layanan = ref.watch(layananProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context, user?.name ?? 'User'),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) =>
                          ref.read(layananProvider.notifier).search(v),
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari kos, catering, laundry...',
                        hintStyle: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textHint),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.textHint),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.textHint),
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(layananProvider.notifier)
                                      .search('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    labelStyle: AppTextStyles.titleMedium
                        .copyWith(fontSize: 14, color: Colors.white),
                    tabs: _tabs,
                  ),
                ],
              ),
            ),
          ),
        ],
        body: layanan.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildKosList(layanan.kosList),
                  _buildCateringList(layanan.cateringList),
                  _buildLaundryList(layanan.laundryList),
                  _buildPaketList(layanan.paketList),
                ],
              ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context, String nama) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
      20,
      MediaQuery.of(context).padding.top + 16, // ← dynamic status bar height
      20,
      16,
    ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Halo, $nama 👋',
                    style: AppTextStyles.titleLarge
                        .copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text('Mau cari apa hari ini?',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.white70)),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Text(
              nama.isNotEmpty ? nama[0].toUpperCase() : 'U',
              style: AppTextStyles.titleMedium
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKosList(List<KosEntity> list) {
    if (list.isEmpty) return _buildEmpty('Kos tidak ditemukan');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, i) => KosCard(
        kos: list[i],
        onTap: () => Navigator.pushNamed(
          context, AppRoutes.kosDetail,
          arguments: list[i],
        ),
      ),
    );
  }

  Widget _buildCateringList(List<CateringEntity> list) {
    if (list.isEmpty) return _buildEmpty('Catering tidak ditemukan');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, i) => CateringCard(
        catering: list[i],
        onTap: () => Navigator.pushNamed(
          context, AppRoutes.cateringDetail,
          arguments: list[i],
        ),
      ),
    );
  }

  Widget _buildLaundryList(List<LaundryEntity> list) {
    if (list.isEmpty) return _buildEmpty('Laundry tidak ditemukan');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, i) => LaundryCard(
        laundry: list[i],
        onTap: () => Navigator.pushNamed(
          context, AppRoutes.laundryDetail,
          arguments: list[i],
        ),
      ),
    );
  }

  Widget _buildPaketList(List<PaketEntity> list) {
    if (list.isEmpty) return _buildEmpty('Paket tidak ditemukan');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, i) => PaketCard(
        paket: list[i],
        onTap: () => Navigator.pushNamed(
          context, AppRoutes.paketDetail,
          arguments: list[i],
        ),
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 64, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
      onTap: (index) {
        if (index == 1) Navigator.pushNamed(context, AppRoutes.orderHistory);
        if (index == 2) Navigator.pushNamed(context, AppRoutes.profile);
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded), label: 'Pesanan'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: 'Profil'),
      ],
    );
  }
}