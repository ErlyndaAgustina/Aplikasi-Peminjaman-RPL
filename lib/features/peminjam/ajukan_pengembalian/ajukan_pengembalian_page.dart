import 'package:flutter/material.dart';
import '../../profile/profile_page.dart';
import '../ajukan_pengembalian/models/model.dart';
import '../ajukan_pengembalian/widgets/pengembalian_cart.dart';
import '../sidebar/sidebar_peminjam.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AjukanPengembalianPage extends StatefulWidget {
  const AjukanPengembalianPage({super.key});
  static const String roboto = 'Roboto';

  @override
  State<AjukanPengembalianPage> createState() => _AjukanPengembalianPageState();
}

class _AjukanPengembalianPageState extends State<AjukanPengembalianPage> {
  final supabase = Supabase.instance.client;
  List<TransaksiModel> daftarPeminjaman = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }
  Future<void> fetchPeminjaman() async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // 1. Ambil ID Internal (id_user) dari tabel users dulu, persis seperti di page peminjaman
    final userData = await supabase
        .from('users')
        .select('id_user')
        .eq('auth_user_id', user.id) // Asumsi kolom di tabel users adalah auth_user_id
        .single();

    final String idUserInternal = userData['id_user'];
    print("Mencari data untuk ID User Internal: $idUserInternal");

    // 2. Gunakan idUserInternal untuk filter tabel peminjaman
    final response = await supabase
        .from('peminjaman')
        .select('''
          id_peminjaman,
          kode_peminjaman,
          tanggal_pinjam,
          batas_kembali,
          status,
          jam_mulai,
          created_at,
          detail_peminjaman (
            alat_unit (
              kode_unit,
              alat (
                nama_alat
              )
            )
          )
        ''')
        .eq('id_user', idUserInternal)
        .inFilter('status', ['dipinjam', 'terlambat']) 
        .order('created_at', ascending: false);

    if (mounted) {
      setState(() {
        daftarPeminjaman = (response as List)
            .map((data) => TransaksiModel.fromMap(data))
            .toList();
        isLoading = false;
      });
    }
  } catch (e) {
    debugPrint('Error fetch detail: $e');
    if (mounted) setState(() => isLoading = false);
  }
}
  Future<void> ajukanPengembalian(String idPeminjaman) async {
  try {
    final detailResponse = await supabase
        .from('detail_peminjaman')
        .select('id_unit')
        .eq('id_peminjaman', idPeminjaman);

    final List unitIds = (detailResponse as List).map((d) => d['id_unit']).toList();

    await supabase
        .from('peminjaman')
        .update({'status': 'dikembalikan'})
        .eq('id_peminjaman', idPeminjaman);

    if (unitIds.isNotEmpty) {
      await supabase
          .from('alat_unit')
          .update({'status': 'tersedia'})
          .inFilter('id_unit', unitIds);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permintaan pengembalian dikirim & unit tersedia kembali!'),
          backgroundColor: Color.fromRGBO(62, 159, 127, 1),
        ),
      );
      fetchPeminjaman();
    }
  } catch (e) {
    debugPrint('Error proses pengembalian: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengajukan: $e'), backgroundColor: Colors.red),
      );
    }
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
                        'Ajukan Pengembalian',
                        style: TextStyle(
                          fontFamily: AjukanPengembalianPage.roboto,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(49, 47, 52, 1),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'RPLKIT • SMK Brantas Karangkates',
                        style: TextStyle(
                          fontFamily: AjukanPengembalianPage.roboto,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : daftarPeminjaman.isEmpty
          ? const Center(child: Text("Tidak ada alat yang dipinjam"))
          : RefreshIndicator(
              onRefresh: fetchPeminjaman,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: daftarPeminjaman.length,
                itemBuilder: (context, index) => TransaksiCard(
                  transaksi: daftarPeminjaman[index],
                  onAjukanPengembalian: () {
                    _showPengembalianDialog(context, daftarPeminjaman[index]);
                  },
                ),
              ),
            ),
    );
  }

  void _showPengembalianDialog(BuildContext context, TransaksiModel transaksi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Pengembalian',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin mengajukan pengembalian untuk ${transaksi.namaAlat}?',
          style: const TextStyle(fontFamily: 'Roboto', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Roboto', color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ajukanPengembalian(transaksi.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengembalian berhasil diajukan'),
                  backgroundColor: Color.fromRGBO(62, 159, 127, 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Ya, Ajukan',
              style: TextStyle(fontFamily: 'Roboto', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
