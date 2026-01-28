import 'package:flutter/material.dart';
import '../../admin/alat/widgets/alat_card.dart';
import '../../profile/profile_page.dart';
import '../alat/widgets/filter.dart';
import 'models/models.dart';
import '../sidebar/sidebar_admin.dart';
import 'widgets/form_alat_dialog.dart';

const String roboto = 'Roboto';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({super.key});

  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  // State untuk menyimpan filter
  String searchQuery = '';
  String selectedKategori = 'Semua Status';

  // Logika Filter Data
  // Logika Filter Data yang Lebih Aman
  List<AlatModel> get filteredAlat {
    // Jika list utama null atau kosong, langsung kembalikan list kosong
    if (alatList.isEmpty) return [];

    return alatList.where((alat) {
      // 1. Pastikan objek 'alat' itu sendiri tidak null
      // ignore: unnecessary_null_comparison
      if (alat == null) return false;

      // 2. Ambil nilai dengan pengaman (?? "") untuk menghindari undefined
      final String nama = (alat.nama ?? "").toString().toLowerCase();
      final String kode = (alat.kode ?? "").toString().toLowerCase();
      final String query = searchQuery.toLowerCase();

      // 3. Cek pencarian
      final bool matchesSearch = nama.contains(query) || kode.contains(query);

      // 4. Cek kategori (Gunakan toLowerCase pada kedua sisi agar aman)
      final String kategoriAlat = (alat.kategori ?? "")
          .toString()
          .toLowerCase()
          .trim();
      final String kategoriSelected = selectedKategori.toLowerCase().trim();

      final bool matchesKategori =
          selectedKategori == 'Semua Status' ||
          kategoriAlat == kategoriSelected;

      return matchesSearch && matchesKategori;
    }).toList();
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
                        'Manajemen Alat',
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const FormAlatDialog(isEdit: false),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 22),
              label: const Text(
                'Tambah Alat',
                style: TextStyle(
                  fontFamily: roboto,
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  setState(() => searchQuery = value); // Update state pencarian
                },
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(72, 141, 117, 1),
                ),
                decoration: InputDecoration(
                  hintText: 'Cari nama atau kode alat...',
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            KategoriFilter(
              onChanged: (value) {
                setState(
                  () => selectedKategori = value,
                ); // Update state kategori
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredAlat.isEmpty
                  ? const Center(child: Text('Data tidak ditemukan'))
                  : ListView.builder(
                      itemCount: filteredAlat.length,
                      itemBuilder: (context, index) {
                        return AlatCard(alat: filteredAlat[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
