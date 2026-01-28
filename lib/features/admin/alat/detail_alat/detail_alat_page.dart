import 'package:flutter/material.dart';
import '../../../profile/profile_page.dart';
import '../detail_alat/widgets/alat_header_card.dart';
import '../detail_alat/widgets/models.dart';
import '../detail_alat/widgets/unit_alat_card.dart';
import 'widgets/form_unit_dialog.dart';

const String roboto = 'Roboto';

class DetailAlatPage extends StatefulWidget {
  const DetailAlatPage({super.key});

  @override
  State<DetailAlatPage> createState() => _DetailAlatPageState();
}

class _DetailAlatPageState extends State<DetailAlatPage> {
  // 1. Tambahkan variabel untuk menyimpan input pencarian
  String searchQuery = '';

  // 2. Buat getter untuk memfilter list unit berdasarkan pencarian
  List<UnitAlatModel> get filteredUnitAlat {
    // Jika kolom pencarian kosong, tampilkan semua
    if (searchQuery.isEmpty) {
      return unitAlatList;
    }

    return unitAlatList.where((unit) {
      // Kita filter berdasarkan properti yang ada di model kamu:
      // Pastikan nama variabel (kodeUnit, kondisi, status) sesuai dengan di models.dart
      final String kode = (unit.kodeUnit ?? "").toLowerCase();
      final String kondisi = (unit.kondisi ?? "").toLowerCase();
      final String status = (unit.status ?? "").toLowerCase();
      final String query = searchQuery.toLowerCase();

      // User bisa cari berdasarkan kode, kondisi (Misal: "Baik"), atau status (Misal: "Tersedia")
      return kode.contains(query) ||
          kondisi.contains(query) ||
          status.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
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
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 253, 240, 0.49),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(62, 159, 127, 1),
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
                        'Detail Unit Alat',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const AlatHeaderCard(),
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
                  builder: (context) => const FormUnitDialog(isEdit: false),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 22),
              label: const Text(
                'Tambah Unit',
                style: TextStyle(
                  fontFamily: roboto,
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Text(
                  'Daftar Unit Alat',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: roboto,
                    color: Color.fromRGBO(49, 47, 52, 1),
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(62, 159, 127, 1), // hijau muda
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    // Update jumlah tersedia secara dinamis
                    '${filteredUnitAlat.length} Tersedia',
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(72, 141, 117, 1),
                ),
                decoration: InputDecoration(
                  hintText: 'Cari kode unit alat atau kondisi...',
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
            const SizedBox(height: 14),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUnitAlat.length, // Gunakan list hasil filter
              itemBuilder: (context, index) {
                final unitAlat = filteredUnitAlat[index];
                return UnitAlatCard(unit: unitAlat);
              },
            ),
            // Di dalam Column body:
            filteredUnitAlat.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Unit tidak ditemukan...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredUnitAlat.length,
                    itemBuilder: (context, index) {
                      return UnitAlatCard(unit: filteredUnitAlat[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
