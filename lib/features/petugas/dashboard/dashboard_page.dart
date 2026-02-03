import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/model.dart';
import 'widgets/summary_section.dart';
import 'widgets/quick_access_section.dart';
import 'widgets/transaksi_card.dart';
import '../sidebar/sidebar_petugas.dart';
import '../../profile/profile_page.dart';

class DashboardPetugasPage extends StatefulWidget {
  const DashboardPetugasPage({super.key});

  @override
  State<DashboardPetugasPage> createState() => _DashboardPetugasPageState();
}

class _DashboardPetugasPageState extends State<DashboardPetugasPage> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  String _namaPetugas = "Petugas";

  Map<String, int> _counts = {
    'aktif': 0,
    'total_alat': 0,
    'dikembalikan': 0,
    'selesai': 0,
  };
  List<TransaksiModel> _listPeminjamanAktif = [];
  List<TransaksiModel> _listPengembalianTerbaru = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final userData = await supabase
          .from('users')
          .select('nama')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (userData != null) {
        _namaPetugas = userData['nama'];
      }
      final resAktif = await supabase
          .from('peminjaman')
          .select()
          .eq('status', 'dipinjam')
          .count(CountOption.exact);

      final resAlat = await supabase
          .from('alat_unit')
          .select()
          .count(CountOption.exact);

      final resSelesai = await supabase
          .from('peminjaman')
          .select()
          .eq('status', 'selesai')
          .count(CountOption.exact);

      final resDikembalikan = await supabase
          .from('peminjaman')
          .select()
          .eq('status', 'dikembalikan') // Pastikan status sesuai DB
          .count(CountOption.exact);

      final resDitolak = await supabase
          .from('peminjaman')
          .select()
          .eq('status', 'ditolak')
          .count(CountOption.exact);

      _counts = {
        'aktif': resAktif.count,
        'total_alat': resAlat.count,
        'selesai': resSelesai.count,
        'dikembalikan': resDikembalikan.count,
        'ditolak': resDitolak.count,
      };

      // 3. Ambil List Peminjaman Aktif (Limit 3)
      final aktifData = await supabase
          .from('peminjaman')
          .select('*, users(nama)')
          .eq('status', 'dipinjam')
          .order('created_at', ascending: false)
          .limit(3);

      _listPeminjamanAktif = (aktifData as List).map((item) {
        return TransaksiModel(
          namaPeminjam: item['users']?['nama'] ?? 'Tanpa Nama',
          alat: 'Kode: ${item['kode_peminjaman']}',
          durasi: 'Jam ${item['jam_mulai']} - ${item['jam_selesai']}',
          status: item['status'],
        );
      }).toList();

      // 4. Ambil List Pengembalian Terbaru (Limit 3)
      final kembaliData = await supabase
          .from('peminjaman')
          .select('*, users(nama)')
          .eq('status', 'dikembalikan')
          .order('updated_at', ascending: false)
          .limit(3);

      _listPengembalianTerbaru = (kembaliData as List).map((item) {
        return TransaksiModel(
          namaPeminjam: item['users']?['nama'] ?? 'Tanpa Nama',
          alat: 'Kode: ${item['kode_peminjaman']}',
          durasi: 'Selesai',
          status: item['status'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error load dashboard: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      drawer: const SidebarPetugasDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(216, 199, 246, 1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dashboard Petugas',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(49, 47, 52, 1),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'RPLKIT • SMK Brantas Karangkates',
                        style: TextStyle(
                          fontFamily: "Roboto",
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
                        builder: (context) => const ProfilePenggunaPage(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color.fromRGBO(217, 253, 240, 0.49),
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SummarySection(counts: _counts, userName: _namaPetugas),
                    const SizedBox(height: 24),
                    const QuickAccessSection(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Peminjaman Aktif'),
                    const SizedBox(height: 8),
                    _listPeminjamanAktif.isEmpty
                        ? const Text('Tidak ada data aktif')
                        : Column(
                            children: _listPeminjamanAktif
                                .map((e) => TransaksiCard(data: e))
                                .toList(),
                          ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Pengembalian Terbaru'),
                    const SizedBox(height: 8),
                    _listPengembalianTerbaru.isEmpty
                        ? const Text('Belum ada data pengembalian')
                        : Column(
                            children: _listPengembalianTerbaru
                                .map((e) => TransaksiCard(data: e))
                                .toList(),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
