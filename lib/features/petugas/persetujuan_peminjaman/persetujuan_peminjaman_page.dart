import 'package:flutter/material.dart';
import '../persetujuan_peminjaman/models/model.dart';
import '../persetujuan_peminjaman/widgets/peminjaman_card.dart';
import '../sidebar/sidebar_petugas.dart';

const String roboto = 'Roboto';

class PersetujuanPeminjamanPage extends StatefulWidget {
  const PersetujuanPeminjamanPage({super.key});

  @override
  State<PersetujuanPeminjamanPage> createState() =>
      _PersetujuanPeminjamanPageState();
}

class _PersetujuanPeminjamanPageState extends State<PersetujuanPeminjamanPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<PeminjamanModel> getData(String status) {
    return [
      PeminjamanModel(
        nama: 'Siti Aminah',
        kode: 'PJM-20260114-g6ht',
        tanggal: '2 Januari 2026',
        jam: 'Jam ke 2',
        alat: ['Macbook Pro', 'Arduino'],
        status: status,
      ),
      PeminjamanModel(
        nama: 'Dewangga Putra',
        kode: 'PJM-20260114-g6hf',
        tanggal: '3 Januari 2026',
        jam: 'Jam ke 2 - 4',
        alat: ['Arduino'],
        status: status,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      drawer: const SidebarPetugasDrawer(),
      body: Column(
        children: [
          /// ================= HEADER + TAB =================
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
                                'Persetujuan Peminjaman',
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
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromRGBO(217, 253, 240, 0.49),
                          child: Icon(
                            Icons.person,
                            color: Color.fromRGBO(62, 159, 127, 1),
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
                        Tab(text: 'Disetujui'),
                        Tab(text: 'Ditolak'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= ISI TAB =================
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                _TabContent(data: getData('menunggu')),
                _TabContent(data: getData('disetujui')),
                _TabContent(data: getData('ditolak')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final List<PeminjamanModel> data;
  const _TabContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        /// ===== JUDUL DI ATAS CARD =====
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Daftar Peminjaman',
                  style: TextStyle(
                    fontFamily: roboto,
                    color: Color.fromRGBO(49, 47, 52, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tinjau dan proses permohonan peminjaman alat RPL.',
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

        /// ===== LIST CARD =====
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverList.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return PeminjamanCard(data: data[index]);
            },
          ),
        ),
      ],
    );
  }
}
