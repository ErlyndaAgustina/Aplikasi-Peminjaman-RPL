import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../profile/profile_page.dart';
import '../sidebar/sidebar_peminjam.dart';
import 'widgets/summary_section.dart';
import 'widgets/quick_access_section.dart';
import 'widgets/transaksi_card.dart';
import 'models/model.dart';

const String roboto = 'Roboto';

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<PeminjamTransaksiModel> listPeminjaman = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDataPeminjam();
  }

  Future<void> _fetchDataPeminjam() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // 1. Ambil data dengan filter status yang lebih lengkap
      final response = await supabase
          .from('peminjaman')
          .select('''
          kode_peminjaman,
          tanggal_pinjam,
          jam_mulai,
          batas_kembali,
          status,
          detail_peminjaman(
            alat_unit(
              kode_unit,
              alat(nama_alat)
            )
          )
        ''')
          .eq('id_user', userId)
          .inFilter('status', [
            'dipinjam',
            'terlambat',
            'menunggu',
            'selesai',
            'dikembalikan',
            'ditolak',
          ])
          .order('created_at', ascending: false);
      debugPrint("JUMLAH DATA DARI SUPABASE: ${(response as List).length}");
      debugPrint("ISI DATA: $response");

      final List<PeminjamTransaksiModel> mappedData = (response as List).map((
        item,
      ) {
        // Safety check jika detail_peminjaman kosong
        final detailList = item['detail_peminjaman'] as List;
        final detail = detailList.isNotEmpty ? detailList[0] : null;

        final statusStr = item['status']?.toString().toLowerCase() ?? '';

        // 2. Perbaiki Logika Mapping Status ke Enum
        StatusTransaksi statusEnum;
        switch (statusStr) {
          case 'dipinjam':
            statusEnum = StatusTransaksi.dipinjam;
            break;
          case 'menunggu':
            statusEnum = StatusTransaksi.menunggu;
            break;
          case 'ditolak':
            statusEnum = StatusTransaksi.ditolak;
            break;
          case 'dikembalikan':
          case 'selesai':
            statusEnum = StatusTransaksi.selesai;
            break;
          default:
            statusEnum = StatusTransaksi.menunggu;
        }

        return PeminjamTransaksiModel(
          kode: item['kode_peminjaman'] ?? '-',
          namaAlat:
              detail?['alat_unit']?['alat']?['nama_alat'] ??
              'Alat Tidak Diketahui',
          idAlat: detail?['alat_unit']?['kode_unit'] ?? '-',
          tanggal: item['tanggal_pinjam'] != null
              ? item['tanggal_pinjam'].toString().split('T')[0]
              : '-',
          jam: item['jam_mulai'] != null ? "Jam ke-${item['jam_mulai']}" : "-",
          batasKembali: item['batas_kembali'] != null
              ? item['batas_kembali'].toString().split('T')[0]
              : '-',
          status: statusEnum,
        );
      }).toList();

      setState(() {
        listPeminjaman = mappedData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error Fetching Data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      drawer: const SidebarPeminjamDrawer(),
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
                        'Dashboard Peminjam',
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
        onRefresh: _fetchDataPeminjam,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SummarySection(), // Nanti sesuaikan isi ini dengan data real juga
              const SizedBox(height: 24),
              const QuickAccessSection(),
              const SizedBox(height: 24),
              const Text(
                "Peminjaman Aktif Saya",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(49, 47, 52, 1),
                ),
              ),
              const SizedBox(height: 12),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listPeminjaman.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listPeminjaman.length,
                      itemBuilder: (context, index) {
                        return TransaksiCard(data: listPeminjaman[index]);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEmptyState() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Belum ada peminjaman aktif",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}
