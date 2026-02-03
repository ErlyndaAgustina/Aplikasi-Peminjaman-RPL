import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../profile/profile_page.dart';
import 'models/model.dart';
import 'widgets/peminjam_info_card.dart';
import 'widgets/auto_calculated_box.dart';
import 'widgets/unit_dipinjam_section.dart';
import 'widgets/DisplayDataBox.dart';

const String roboto = 'Roboto';

class DetailPengembalianPage extends StatefulWidget {
final String idPeminjaman;
  const DetailPengembalianPage({super.key, required this.idPeminjaman});

  @override
  State<DetailPengembalianPage> createState() => _DetailPengembalianPageState();
}

class _DetailPengembalianPageState extends State<DetailPengembalianPage> {
  bool isLoading = true;
  DetailPengembalianModel? data;
  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  Future<void> _loadDetailData() async {
    try {
      final res = await Supabase.instance.client
          .from('peminjaman')
          .select('''
            *,
            users(nama),
            pengembalian(*),
            detail_peminjaman(
              alat_unit(
                alat(nama_alat),
                kode_unit
              )
            )
          ''')
          .eq('id_peminjaman', widget.idPeminjaman)
          .single();

      setState(() {
        data = DetailPengembalianModel.fromDetailSupabase(res);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error load detail: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF3E9F7F))));
    }

    if (data == null) {
      return const Scaffold(body: Center(child: Text("Data tidak ditemukan")));
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PeminjamInfoCard(data: data!),
            const SizedBox(height: 20),

            const Text(
              'Data Pengembalian',
              style: TextStyle(
                fontFamily: roboto,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DisplayDataBox(
                    label: 'Tanggal Kembali',
                    value: data!.tanggalKembali,
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DisplayDataBox(
                    label: 'Jam Kembali',
                    value: data!.jamKembali,
                    icon: Icons.access_time,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            DisplayDataBox(
              label: 'Denda Kerusakan (Rp)',
              value: 'Rp ${data!.dendaKerusakan.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}',
            ),
            const SizedBox(height: 12),

            DisplayDataBox(
              label: 'Catatan Kerusakan',
              value: data!.catatan,
            ),
            const SizedBox(height: 16),

            // Box Kalkulasi (Selalu muncul di detail karena data sudah ada)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AutoCalculateBox(
              terlambatMenit: data!.terlambatMenit,
              dendaTerlambat: data!.dendaTerlambat,
              dendaKerusakan: data!.dendaKerusakan,
            ),
            ),

            const Text(
              'Unit Dipinjam',
              style: TextStyle(
                fontFamily: roboto,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),

            ...data!.units.map((u) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: UnitDipinjamCard(unit: u),
            )),
            
            const SizedBox(height: 24),
            // Tompol "Kembali" sebagai pengganti "Simpan"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Tutup Detail',
                  style: TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
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
                        'Detail Pengembalian Alat',
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
      );
  }
}