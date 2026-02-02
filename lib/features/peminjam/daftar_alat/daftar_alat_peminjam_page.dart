import 'package:flutter/material.dart';
import '../../profile/profile_page.dart';
import '../ajukan_pinjaman/ajukan_peminjaman_page.dart';
import '../sidebar/sidebar_peminjam.dart';
import 'models/model.dart';
import 'widgets/alat_card_peminjam.dart';
import 'widgets/filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String roboto = 'Roboto';

// ... import tetap sama ...

class DaftarAlatPeminjamPage extends StatefulWidget {
  const DaftarAlatPeminjamPage({super.key});

  @override
  State<DaftarAlatPeminjamPage> createState() => _DaftarAlatPeminjamPageState();
}

class _DaftarAlatPeminjamPageState extends State<DaftarAlatPeminjamPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  
  List<AlatModel> _allAlatFromDb = []; // Data asli dari DB
  List<AlatModel> _filteredAlatList = []; // Data untuk tampilan
  bool _isLoading = true;
  String _selectedKategori = 'Semua Status';

  @override
  void initState() {
    super.initState();
    _fetchAlatData();
    _searchController.addListener(_filterAlat);
  }

  // FUNGSI AMBIL DATA DARI SUPABASE
  Future<void> _fetchAlatData() async {
    try {
      setState(() => _isLoading = true);
      
      // Query dengan join ke kategori dan filter unit yang 'tersedia' saja
      final response = await supabase
          .from('alat')
          .select('''
            id_alat, nama_alat, kode_alat,
            kategori (nama_kategori),
            alat_unit (id_unit)
          ''')
          .eq('alat_unit.status', 'tersedia'); // Hanya ambil unit yang tersedia

      final List data = response as List;
      
      setState(() {
        _allAlatFromDb = data.map((item) => AlatModel.fromSupabase(item)).toList();
        // Hanya tampilkan alat yang jumlah unit tersedianya > 0
        _allAlatFromDb = _allAlatFromDb.where((a) => a.jumlah > 0).toList();
        _filteredAlatList = _allAlatFromDb;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetch data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterAlat() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAlatList = _allAlatFromDb.where((alat) {
        bool matchesSearch = alat.nama.toLowerCase().contains(query) ||
                             alat.kode.toLowerCase().contains(query);
        bool matchesKategori = _selectedKategori == 'Semua Status' ||
                               alat.kategori == _selectedKategori;
        return matchesSearch && matchesKategori;
      }).toList();
    });
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Daftar Alat',
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

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _searchController, // 3. Pasang Controller
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(72, 141, 117, 1),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau kode alat...',
                      // ... dekorasi lainnya tetap sama ...
                      hintStyle: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 14,
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
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
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 4. Update Filter Kategori agar bisa mengubah State
                KategoriFilter(
                  selectedKategori: _selectedKategori,
                  onKategoriChanged: (newKategori) {
                    setState(() {
                      _selectedKategori = newKategori;
                      _filterAlat(); // Jalankan filter ulang
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) // Loading State
                : RefreshIndicator(
                    onRefresh: _fetchAlatData, // Bisa ditarik untuk refresh
                    child: _filteredAlatList.isEmpty
                        ? const Center(child: Text("Alat tersedia tidak ditemukan"))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: _filteredAlatList.length,
                            itemBuilder: (context, index) {
                              return AlatCardPeminjam(
                                alat: _filteredAlatList[index],
                                onTambah: () => setState(() {}),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        // ... Logika FAB tetap sama ...
        onPressed: () {
          if (keranjangAlat.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Keranjang masih kosong!')),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AjukanPeminjamanPage(),
              ),
            ).then((_) => setState(() {}));
          }
        },
        backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 28,
            ),
            if (keranjangAlat.isNotEmpty)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${keranjangAlat.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
