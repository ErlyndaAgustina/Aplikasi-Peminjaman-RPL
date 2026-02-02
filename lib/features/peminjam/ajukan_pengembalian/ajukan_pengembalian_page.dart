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
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('peminjaman')
          .select('''
          id_peminjaman,
          kode_peminjaman,
          tanggal_pinjam,
          batas_kembali,
          status,
          jam_mulai,
          detail_peminjaman (
            alat_unit (
              kode_unit,
              alat (
                nama_alat
              )
            )
          )
        ''')
          .eq('id_user', userId)
          .or('status.eq.dipinjam,status.eq.terlambat')
          .order('created_at', ascending: false);
      setState(() {
        daftarPeminjaman = (response as List)
            .map((data) => TransaksiModel.fromMap(data))
            .toList();
        isLoading = false;
      });

      print("Data berhasil diambil: ${daftarPeminjaman.length} item");
    } catch (e) {
      debugPrint('Error fetch detail: $e');
      setState(() => isLoading = false);
    }
  }
  Future<void> ajukanPengembalian(String idPeminjaman) async {
    try {
      await supabase
          .from('peminjaman')
          .update({
            'status': 'menunggu',
          })
          .eq('id_peminjaman', idPeminjaman);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permintaan pengembalian dikirim!')),
        );
        fetchPeminjaman();
      }
    } catch (e) {
      debugPrint('Error update: $e');
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
