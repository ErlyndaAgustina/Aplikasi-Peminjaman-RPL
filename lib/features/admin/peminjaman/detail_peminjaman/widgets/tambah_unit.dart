import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Asumsi pakai Supabase berdasarkan schema

class TambahUnitModal extends StatefulWidget {
  final String idPeminjaman;
  const TambahUnitModal({super.key, required this.idPeminjaman});

  @override
  State<TambahUnitModal> createState() => _TambahUnitModalState();
}

class _TambahUnitModalState extends State<TambahUnitModal> {
  final _supabase = Supabase.instance.client;

  // Variabel penampung data dari DB
  List<Map<String, dynamic>> kategoriList = [];
  List<Map<String, dynamic>> alatList = [];
  List<Map<String, dynamic>> unitList = [];

  // Variabel pilihan user
  String? selectedKategori;
  String? selectedAlat;
  String? selectedUnit;
  String kondisiAlat = "-";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  // Ambil data Kategori
  Future<void> _fetchKategori() async {
    final data = await _supabase.from('kategori').select();
    setState(() => kategoriList = List<Map<String, dynamic>>.from(data));
  }

  // Ambil data Alat berdasarkan Kategori
  Future<void> _fetchAlat(String idKategori) async {
    final data = await _supabase.from('alat').select().eq('id_kategori', idKategori);
    setState(() {
      alatList = List<Map<String, dynamic>>.from(data);
      selectedAlat = null;
      unitList = [];
      selectedUnit = null;
    });
  }

  // Ambil data Unit berdasarkan Alat yang STATUS-nya 'tersedia'
  Future<void> _fetchUnit(String idAlat) async {
    final data = await _supabase
        .from('alat_unit')
        .select()
        .eq('id_alat', idAlat)
        .eq('status', 'tersedia');
    setState(() {
      unitList = List<Map<String, dynamic>>.from(data);
      selectedUnit = null;
    });
  }

  // Fungsi Simpan ke Tabel detail_peminjaman
  Future<void> _simpanUnit() async {
    if (selectedUnit == null) return;

    setState(() => isLoading = true);
    try {
      // 1. Insert ke detail_peminjaman
      await _supabase.from('detail_peminjaman').insert({
        'id_peminjaman': widget.idPeminjaman,
        'id_unit': selectedUnit,
      });

      // 2. Update status unit jadi 'dipinjam'
      await _supabase
          .from('alat_unit')
          .update({'status': 'dipinjam'})
          .eq('id_unit', selectedUnit!);

      if (mounted) Navigator.pop(context, true); // Kirim true agar halaman detail refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER
          _buildHeader(context),

          // BODY
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBox(),
                  const SizedBox(height: 20),

                  _buildLabel("Kategori *"),
                  _buildDropdown(
                    hint: "Pilih kategori",
                    value: selectedKategori,
                    items: kategoriList.map((e) => DropdownMenuItem(
                      value: e['id_kategori'].toString(),
                      child: Text(e['nama_kategori']),
                    )).toList(),
                    onChanged: (val) {
                      setState(() => selectedKategori = val);
                      _fetchAlat(val!);
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildLabel("Alat *"),
                  _buildDropdown(
                    hint: "Pilih alat",
                    value: selectedAlat,
                    items: alatList.map((e) => DropdownMenuItem(
                      value: e['id_alat'].toString(),
                      child: Text(e['nama_alat']),
                    )).toList(),
                    onChanged: selectedKategori == null ? null : (val) {
                      setState(() => selectedAlat = val);
                      _fetchUnit(val!);
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildLabel("Unit Alat (Hanya yang Tersedia) *"),
                  _buildDropdown(
                    hint: "Pilih unit alat",
                    value: selectedUnit,
                    items: unitList.map((e) => DropdownMenuItem(
                      value: e['id_unit'].toString(),
                      child: Text(e['kode_unit']),
                    )).toList(),
                    onChanged: selectedAlat == null ? null : (val) {
                      final item = unitList.firstWhere((u) => u['id_unit'] == val);
                      setState(() {
                        selectedUnit = val;
                        kondisiAlat = item['kondisi'] ?? 'Bagus';
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildLabel("Kondisi Alat (Otomatis)"),
                  _buildReadOnlyField(kondisiAlat),

                  const SizedBox(height: 30),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color.fromRGBO(62, 159, 127, 1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text("Tambah Unit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(234, 247, 242, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info, color: Color.fromRGBO(62, 159, 127, 1), size: 20),
          SizedBox(width: 10),
          Expanded(child: Text("Hanya unit dengan status tersedia yang muncul.", style: TextStyle(fontSize: 11, color: Color.fromRGBO(62, 159, 127, 1)))),
        ],
      ),
    );
  }

  Widget _buildDropdown({required String hint, String? value, required List<DropdownMenuItem<String>> items, Function(String?)? onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black54)),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: const Text("Batal"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading || selectedUnit == null ? null : _simpanUnit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Tambah", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}