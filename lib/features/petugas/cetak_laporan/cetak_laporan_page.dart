import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/profile_page.dart';
import '../cetak_laporan/widgets/filter_card.dart';
import '../sidebar/sidebar_petugas.dart';
import 'widgets/pdf_printing.dart';

const String roboto = 'Roboto';

class CetakLaporanPage extends StatefulWidget {
  const CetakLaporanPage({super.key});

  @override
  State<CetakLaporanPage> createState() => _CetakLaporanPageState();
}

class _CetakLaporanPageState extends State<CetakLaporanPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  String jenis = "peminjaman";
  String tglMulai = "";
  String tglAkhir = "";
  String kategori = "semua";
  String status = "semua";

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
                      child: Icon(Icons.menu, color: Color.fromRGBO(62, 159, 127, 1),),
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
                        'Cetak Laporan',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter Laporan",
              style: TextStyle(
                fontFamily: roboto,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            FilterCard(
              onFilterChanged: ({
                required jenis,
                required tglMulai,
                required tglAkhir,
                required kategori,
                required status,
              }) {
                setState(() {
                  this.jenis = jenis;
                  this.tglMulai = tglMulai;
                  this.tglAkhir = tglAkhir;
                  this.kategori = kategori;
                  this.status = status;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _cetakLaporan,
                icon: const Icon(Icons.print_outlined, color: Colors.white),
                label: const Text(
                  "Cetak Laporan",
                  style: TextStyle(
                    fontFamily: roboto,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cetakLaporan() async {
    final query = supabase.from('peminjaman').select('''
      tanggal_pinjam,
      status,
      users(nama),
      detail_peminjaman(
        alat_unit(
          status,
          alat(
            nama_alat,
            kategori(nama_kategori)
          )
        )
      )
    ''');

    if (status != 'semua') {
      query.eq('status', status);
    }

    if (tglMulai.isNotEmpty && tglAkhir.isNotEmpty) {
      query
          .gte('tanggal_pinjam', tglMulai)
          .lte('tanggal_pinjam', tglAkhir);
    }

    final List data = await query;

    final List<List<String>> tableData = [
      ['No', 'Tanggal', 'Nama Peminjam', 'Alat', 'Status'],
    ];

    int no = 1;
    for (final row in data) {
      final peminjam = row['users']['nama'];
      final tanggal = row['tanggal_pinjam'].toString().split('T').first;
      final statusPinjam = row['status'];

      for (final detail in row['detail_peminjaman']) {
        final alat = detail['alat_unit']['alat']['nama_alat'];
        final kategoriDb =
            detail['alat_unit']['alat']['kategori']['nama_kategori'];

        if (kategori != 'semua' && kategoriDb != kategori) continue;

        tableData.add([
          no.toString(),
          tanggal,
          peminjam,
          alat,
          statusPinjam,
        ]);

        no++;
      }
    }

    if (tableData.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data laporan tidak ditemukan')),
      );
      return;
    }

    await PdfService.generateLaporan(
      judul: _judulLaporan(),
      periode: _periode(),
      kategori: kategori,
      status: status,
      tableData: tableData,
    );
  }

  String _judulLaporan() {
    switch (jenis) {
      case 'pengembalian':
        return 'Laporan Pengembalian';
      case 'alat':
        return 'Laporan Daftar Alat';
      default:
        return 'Laporan Peminjaman';
    }
  }

  String _periode() {
    if (tglMulai.isEmpty || tglAkhir.isEmpty) {
      return 'Semua Periode';
    }
    return '$tglMulai - $tglAkhir';
  }

}
