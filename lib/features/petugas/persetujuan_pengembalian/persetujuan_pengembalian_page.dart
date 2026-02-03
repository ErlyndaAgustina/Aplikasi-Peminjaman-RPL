import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../profile/profile_page.dart';
import '../sidebar/sidebar_petugas.dart';
import 'models/model.dart';
import 'widgets/pengembalian_card.dart';

const String roboto = 'Roboto';

class PersetujuanPengembalianPage extends StatefulWidget {
  const PersetujuanPengembalianPage({super.key});

  @override
  State<PersetujuanPengembalianPage> createState() =>
      _PersetujuanPengembalianPageState();
}

class _PersetujuanPengembalianPageState
    extends State<PersetujuanPengembalianPage>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late final TabController _tabController;

  Future<List<PengembalianModel>> fetchDataPetugas(String statusFilter) async {
    try {
      final response = await supabase
          .from('peminjaman')
          .select('''
          *,
          users ( nama ), 
          detail_peminjaman (
            alat_unit (
              alat ( nama_alat )
            )
          )
        ''')
          .eq('status', statusFilter)
          .order('created_at', ascending: false);

      final data = response as List;
      return data.map((item) => PengembalianModel.fromMap(item)).toList();
    } catch (e) {
      print('Error Supabase: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      drawer: const SidebarPetugasDrawer(),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(217, 253, 240, 0.49),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Builder(
                            builder: (context) => GestureDetector(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: Icon(
                                Icons.menu,
                                color: Color.fromRGBO(62, 159, 127, 1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Persetujuan Pengembalian',
                                style: TextStyle(
                                  fontFamily: roboto,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(49, 47, 52, 1),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'RPLKIT • SMK Brantas Karangkates',
                                style: TextStyle(
                                  fontFamily: roboto,
                                  fontSize: 12,
                                  color: Color.fromRGBO(72, 141, 117, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProfilePenggunaPage(),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color.fromRGBO(
                              217,
                              253,
                              240,
                              0.49,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Color.fromRGBO(62, 159, 127, 1),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// GARIS PEMISAH
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color.fromRGBO(216, 199, 246, 1),
                  ),

                  /// TAB BAR
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelStyle: TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(1, 85, 56, 1),
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(93, 93, 93, 1),
                      ),
                      indicatorColor: const Color.fromRGBO(1, 85, 56, 1),
                      indicatorWeight: 1,
                      indicatorPadding: const EdgeInsets.only(bottom: 6),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      tabs: const [
                        Tab(text: 'Menunggu Persetujuan'),
                        Tab(text: 'Selesai'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Menunggu
                FutureBuilder<List<PengembalianModel>>(
                  future: fetchDataPetugas('dikembalikan'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _TabContent(
                      data: snapshot.data ?? [],
                      onRefresh: _refreshData,
                    );
                  },
                ),
                FutureBuilder<List<PengembalianModel>>(
                  future: fetchDataPetugas('selesai'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _TabContent(
                      data: snapshot.data ?? [],
                      onRefresh: _refreshData,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final List<PengembalianModel> data;
  final VoidCallback onRefresh;
  const _TabContent({required this.data, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: CustomScrollView( 
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Daftar Pengembalian',
                    style: TextStyle(
                      fontFamily: roboto,
                      color: Color.fromRGBO(49, 47, 52, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tinjau dan proses permohonan pengembalian alat RPL.',
                    style: TextStyle(
                      fontFamily: roboto,
                      fontSize: 13,
                      color: Color.fromRGBO(72, 141, 117, 1),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return PengembalianCard(
                  data: data[index],
                  onRefresh: onRefresh, 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
