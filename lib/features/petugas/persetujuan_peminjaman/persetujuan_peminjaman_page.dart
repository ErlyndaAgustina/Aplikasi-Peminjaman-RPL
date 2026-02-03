import 'package:flutter/material.dart';
import '../../profile/profile_page.dart';
import '../persetujuan_peminjaman/models/model.dart';
import '../persetujuan_peminjaman/widgets/peminjaman_card.dart';
import '../sidebar/sidebar_petugas.dart';
import '../persetujuan_peminjaman/services/peminjaman_service.dart';

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
                              child: const Icon(
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
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color.fromRGBO(216, 199, 246, 1),
                  ),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelStyle: const TextStyle(
                      fontFamily: roboto,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: roboto,
                      fontWeight: FontWeight.w500,
                    ),
                    labelColor: const Color.fromRGBO(1, 85, 56, 1),
                    unselectedLabelColor: const Color.fromRGBO(93, 93, 93, 1),
                    indicatorColor: const Color.fromRGBO(1, 85, 56, 1),
                    indicatorWeight: 1,
                    indicatorPadding: const EdgeInsets.only(bottom: 6),
                    tabs: const [
                      Tab(text: 'Menunggu Persetujuan'),
                      Tab(text: 'Disetujui'),
                      Tab(text: 'Ditolak'),
                    ],
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
              children: const [
                _TabContent(
                  status: 'menunggu',
                ), // Pakai status, bukan getData manual
                _TabContent(status: 'dipinjam'),
                _TabContent(status: 'ditolak'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatefulWidget {
  final String status;
  const _TabContent({required this.status});

  @override
  State<_TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<_TabContent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PeminjamanModel>>(
      // Memanggil fungsi fetch dari service
      future: PeminjamanService().fetchPeminjaman(widget.status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(62, 159, 127, 1),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
        }

        final List<PeminjamanModel> data = snapshot.data ?? [];

        if (data.isEmpty) {
          return const Center(child: Text("Tidak ada data peminjaman"));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.separated(
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return PeminjamanCard(
                    data: data[index],
                    onRefresh: () {
                      // Ini yang bikin data ter-update otomatis setelah klik Setuju/Tolak
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
