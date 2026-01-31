import 'package:flutter/material.dart';
import '../../profile/profile_page.dart';
import '../peminjaman/widgets/filter.dart';
import 'models/models.dart';
import '../peminjaman/widgets/peminjaman_card.dart';
import '../sidebar/sidebar_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String roboto = 'Roboto';

class ManajemenPeminjamanPage extends StatefulWidget {
  const ManajemenPeminjamanPage({super.key});

  @override
  State<ManajemenPeminjamanPage> createState() =>
      _ManajemenPeminjamanPageState();
}

class _ManajemenPeminjamanPageState extends State<ManajemenPeminjamanPage> {
  final supabase = Supabase.instance.client;
  List<PeminjamanModel> allData = [];
  List<PeminjamanModel> filteredList = [];
  String searchQuery = "";
  String filterStatus = "Semua Status";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  

  Future<void> _fetchData() async {
    try {
      // Ambil data peminjaman JOIN dengan users untuk dapat nama
      final response = await supabase
          .from('peminjaman')
          .select('*, users(nama)')
          .or(
            'status.eq.dipinjam,status.eq.terlambat',
          ) // Filter status sesuai request
          
          .order('tanggal_pinjam', ascending: false);

      final List data = response;
      setState(() {
        allData = data
            .map((item) => PeminjamanModel.fromSupabase(item))
            .toList();
        _applyFilter();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetch: $e');
      setState(() => isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      filteredList = allData.where((p) {
        // 1. Logika Search
        final matchesSearch =
            p.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.kode.toLowerCase().contains(searchQuery.toLowerCase());

        // 2. Logika Filter Status (Samakan ke lowercase untuk jaga-jaga)
        final bool matchesFilter;
        if (filterStatus == "Semua Status") {
          matchesFilter = true;
        } else {
          // Bandingkan status data dengan status filter (keduanya jadikan kecil)
          matchesFilter = p.status.toLowerCase() == filterStatus.toLowerCase();
        }

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      drawer: const SidebarAdminDrawer(),
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
                        'Manajemen Peminjaman',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SEARCH BAR
            SizedBox(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  searchQuery = value;
                  _applyFilter(); // Memanggil fungsi filter saat ngetik
                },
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(72, 141, 117, 1),
                ),
                decoration: InputDecoration(
                  hintText: 'Cari peminjaman...',
                  hintStyle: const TextStyle(
                    fontFamily: roboto,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(72, 141, 117, 1),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 22,
                    color: Color.fromRGBO(72, 141, 117, 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(205, 238, 226, 1),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(72, 141, 117, 1),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // KATEGORI FILTER (Sudah diperbaiki panggilannya)
            // Di ManajemenPeminjamanPage
            KategoriFilter(
              onStatusChanged: (status) {
                setState(() {
                  filterStatus =
                      status; // Akan menerima 'dipinjam' atau 'terlambat'
                });
                _applyFilter();
              },
            ),

            const SizedBox(height: 16),

            // LISTVIEW (Sudah ganti ke .length)
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(62, 159, 127, 1),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchData, // Swipe down untuk refresh data
                      child: filteredList.isEmpty
                          ? const Center(child: Text("Data tidak ditemukan"))
                          : ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return PeminjamanCard(
                                  data: filteredList[index],
                                  onChanged:
                                      _fetchData, // Kirim callback untuk refresh setelah edit/hapus
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
