import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'summary_card.dart';

const String roboto = 'Roboto';

class SummarySection extends StatefulWidget {
  const SummarySection({super.key});

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  final supabase = Supabase.instance.client;
  
  int totalPengguna = 0;
  int totalAlat = 0;
  int peminjamanAktif = 0;
  int pengembalianHariIni = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSummaryData();
  }

  Future<void> fetchSummaryData() async {
    try {
      // Mengambil data secara paralel agar lebih cepat
      final results = await Future.wait([
        supabase.from('users').count(),
        supabase.from('alat_unit').count(),
        supabase.from('peminjaman').count().eq('status', 'dipinjam'), // Sesuaikan statusnya
        supabase.from('pengembalian')
            .count()
            .gte('tanggal_kembali', DateTime.now().toIso8601String().substring(0, 10)), 
      ]);

      if (mounted) {
        setState(() {
          totalPengguna = results[0];
          totalAlat = results[1];
          peminjamanAktif = results[2];
          pengembalianHariIni = results[3];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error Fetch Summary: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Halo, Admin', // Nanti bisa ambil dari session user
          style: TextStyle(
            fontFamily: roboto,
            color: Color.fromRGBO(49, 47, 52, 1),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Berikut adalah ringkasan RPLKIT saat ini.',
          style: TextStyle(
            fontFamily: roboto,
            fontSize: 13,
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
        ),
        const SizedBox(height: 16),
        
        if (isLoading)
          const Center(child: LinearProgressIndicator())
        else
          Column(
            children: [
              SummaryCard(
                title: 'Total Pengguna',
                value: totalPengguna.toString(),
                icon: Icons.people,
                color: const Color.fromRGBO(99, 36, 235, 1),
              ),
              SummaryCard(
                title: 'Total Unit Alat',
                value: totalAlat.toString(),
                icon: Icons.inventory_2,
                color: const Color.fromRGBO(0, 169, 112, 1),
              ),
              SummaryCard(
                title: 'Peminjaman Aktif',
                value: peminjamanAktif.toString(),
                icon: Icons.assignment,
                color: const Color.fromRGBO(28, 106, 255, 1),
              ),
              SummaryCard(
                title: 'Pengembalian Hari Ini',
                value: pengembalianHariIni.toString(),
                icon: Icons.assignment_return,
                color: const Color.fromRGBO(239, 133, 0, 1),
              ),
            ],
          ),
      ],
    );
  }
}