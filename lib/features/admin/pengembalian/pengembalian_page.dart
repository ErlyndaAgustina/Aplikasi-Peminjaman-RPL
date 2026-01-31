import 'package:flutter/material.dart';
import '../../profile/profile_page.dart';
import '../sidebar/sidebar_admin.dart';
import 'models/model.dart';
import 'widgets/pengembalian_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Definisi font roboto jika belum ada secara global
const String roboto = 'Roboto';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();

  List<PengembalianModel> _allData = [];
  List<PengembalianModel> _filteredData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fungsi READ
  // Di dalam file pengembalian_page.dart, fungsi _fetchData
  // Di pengembalian_page.dart
Future<void> _fetchData() async {
  // Jangan hapus isLoading biar user tahu data lagi ditarik ulang
  setState(() => _isLoading = true); 
  
  try {
    // Query ini sudah sangar karena narik sampai ke akar-akarnya (detail_peminjaman)
    final response = await _supabase
        .from('pengembalian')
        .select('''
          *,
          peminjaman:id_peminjaman (
            kode_peminjaman,
            jam_selesai,
            users:id_user ( nama ),
            detail_peminjaman (
              alat_unit (
                kode_unit,
                alat ( nama_alat )
              )
            )
          )
        ''')
        .order('created_at', ascending: false);

    final data = (response as List)
        .map((e) => PengembalianModel.fromJson(e))
        .toList();

    if (mounted) {
      setState(() {
        _allData = data;
        _filteredData = data;
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) setState(() => _isLoading = false);
    print("Error: $e");
  }
}

  void _filterSearch(String query) {
    setState(() {
      _filteredData = _allData
          .where(
            (item) =>
                item.nama.toLowerCase().contains(query.toLowerCase()) ||
                item.kode.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                        'Manajemen Pengembalian',
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
            _buildSearchBar(),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchData,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredData.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _filteredData.length,
                        itemBuilder: (context, index) {
                          return PengembalianCard(
                            data: _filteredData[index],
                            onRefresh: _fetchData, // Tambahkan callback refresh
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

  Widget _buildSearchBar() {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: _searchController,
        onChanged: _filterSearch,
        style: const TextStyle(
          fontFamily: roboto,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(72, 141, 117, 1),
        ),
        decoration: InputDecoration(
          hintText: 'Cari nama atau kode...',
          hintStyle: const TextStyle(
            fontFamily: roboto,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(160, 200, 185, 1),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 22,
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
          // Gunakan suffix biasa tapi panggil setState saat berubah
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _filterSearch('');
                  },
                )
              : null,
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Data tidak ditemukan',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
