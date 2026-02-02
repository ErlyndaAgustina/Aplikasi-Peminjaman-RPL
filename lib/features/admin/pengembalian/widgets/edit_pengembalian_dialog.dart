import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/model.dart';

class EditPengembalianDialog extends StatefulWidget {
  final PengembalianModel data;
  const EditPengembalianDialog({super.key, required this.data});

  @override
  State<EditPengembalianDialog> createState() => _EditPengembalianDialogState();
}

class _EditPengembalianDialogState extends State<EditPengembalianDialog> {
  bool _isLoading = false;
  // Controller untuk input teks
  late TextEditingController _terlambatController;
  late TextEditingController _dendaTerlambatController;
  late TextEditingController _dendaRusakController;
  late TextEditingController _catatanController;
  late TextEditingController _totalDendaController;

  // State untuk Dropdown
  int? _selectedJam;
  String? _selectedUnitId;
  String? _selectedUnit;
  String _currentNamaAlat = '';

  // Data Dummy untuk Unit (Nanti bisa kamu ambil dari database)
  List<Map<String, String>> _unitList = [
    {'id': 'uuid', 'kode': 'UNIT-001', 'nama': 'Laptop'},
  ];

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller
    _terlambatController = TextEditingController(
      text: widget.data.terlambatMenit.toString(),
    );
    _dendaTerlambatController = TextEditingController(
      text: widget.data.dendaTerlambat.toString(),
    );
    _dendaRusakController = TextEditingController(
      text: widget.data.dendaRusak.toString(),
    );
    _catatanController = TextEditingController(text: widget.data.catatan);
    _totalDendaController = TextEditingController(
      text: widget.data.totalDenda.toString(),
    );

    // Set nilai awal (aman walau unit belum diload)
    _selectedJam = widget.data.jamSelesai;
    _selectedUnitId = widget.data.idUnit;
    _selectedUnit = widget.data.kodeUnit;
    _currentNamaAlat = widget.data.namaAlat;

    // Ambil unit dari Supabase
    _fetchUnitFromSupabase();
  }

  Future<void> _fetchUnitFromSupabase() async {
    final supabase = Supabase.instance.client;

    final res = await supabase
        .from('alat_unit')
        .select('id_unit, kode_unit, alat(nama_alat)')
        .order('kode_unit');

    final units = res.map<Map<String, String>>((item) {
      return {
        'id': item['id_unit'],
        'kode': item['kode_unit'],
        'nama': item['alat']['nama_alat'],
      };
    }).toList();

    if (mounted) {
      setState(() {
        _unitList = units;
        _selectedUnitId ??= widget.data.idUnit;
        _selectedUnit ??= widget.data.kodeUnit;
        _currentNamaAlat = widget.data.namaAlat;
      });
    }
  }

  Future<void> _updatePengembalian() async {
    try {
      final supabase = Supabase.instance.client;

      // 1. Lakukan update data pengembalian
      // Gunakan .select() di akhir jika ingin mendapatkan data balikan untuk dicek isEmpty-nya
      final response = await supabase
          .from('pengembalian')
          .update({
            'terlambat_menit': int.tryParse(_terlambatController.text) ?? 0,
            'denda_terlambat':
                int.tryParse(_dendaTerlambatController.text) ?? 0,
            'denda_rusak': int.tryParse(_dendaRusakController.text) ?? 0,
            'total_denda': int.tryParse(_totalDendaController.text) ?? 0,
            'catatan_kerusakan': _catatanController.text,
          })
          .eq('id_pengembalian', widget.data.id)
          .select(); // Tambahkan .select() agar mengembalikan List data

      // 2. Update unit di detail_peminjaman
      await supabase
          .from('detail_peminjaman')
          .update({'id_unit': _selectedUnitId})
          .eq('id_detail', widget.data.idDetailPeminjaman);

      // Sekarang response tidak null karena ada .select()
      if (response.isEmpty) {
        throw Exception('Update gagal: ID pengembalian tidak ditemukan');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal update: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _terlambatController.dispose();
    _dendaTerlambatController.dispose();
    _dendaRusakController.dispose();
    _catatanController.dispose();
    _totalDendaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Nama & Kode (Read Only/Item biasa)
                    _itemReadOnly('Nama Peminjam', widget.data.nama),
                    _itemReadOnly('Kode Peminjaman', widget.data.kode),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _inputLabel('Kembali Pada'),
                              _dateField(widget.data.tanggal),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [_inputLabel('Jam ke'), _dropdownJam()],
                          ),
                        ),
                      ],
                    ),

                    // 4. Unit Dropdown & Nama Alat Otomatis
                    _inputLabel('Unit yang dikembalikan'),
                    _buildUnitDisplayBox(),

                    _inputLabel('Terlambat (Menit)'),
                    _textField(_terlambatController),

                    _inputLabel('Denda Terlambat'),
                    _textField(_dendaTerlambatController),

                    _inputLabel('Denda Rusak'),
                    _textField(_dendaRusakController),

                    _inputLabel('Catatan Kerusakan'),
                    _textField(_catatanController, maxLines: 3),

                    _inputLabel('Total Denda'),
                    _textField(_totalDendaController, isBold: true),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _btn(
                            'Batal',
                            context,
                            isOutlined: true,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _btn(
                                  'Simpan',
                                  context,
                                  isPrimary: true,
                                  onTap: () async {
                                    setState(() => _isLoading = true);
                                    await _updatePengembalian(); // Panggil fungsi update ke Supabase
                                    if (mounted)
                                      setState(() => _isLoading = false);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF3E9F7F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          const Text(
            'Edit Pengembalian',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Pengganti _item untuk yang tidak bisa diedit
  Widget _itemReadOnly(String label, String val, {bool isBox = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputLabel(label),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isBox ? const Color(0xFFF0F9F6) : Colors.grey[100],
            border: Border.all(color: const Color(0xFFCDEEE2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            val,
            style: TextStyle(
              fontSize: 13,
              color: isBox ? const Color(0xFF3E9F7F) : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputLabel(String t) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      t,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );

  Widget _textField(
    TextEditingController controller, {
    bool isBold = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 13,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3E9F7F)),
        ),
      ),
    );
  }

  Widget _dropdownJam() {
    int? safeValue = (_selectedJam != null && _selectedJam! >= 1 && _selectedJam! <= 10) 
                   ? _selectedJam 
                   : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCDEEE2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: safeValue,
          isExpanded: true,
          items: List.generate(
            10,
            (index) => index + 1,
          ).map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
          onChanged: (v) => setState(() => _selectedJam = v),
        ),
      ),
    );
  }

  // 1. Tambahkan fungsi helper untuk membuat tampilan kotak hijau isi Nama + Kode
  Widget _buildUnitDisplayBox() {
    bool itemExists = _unitList.any((e) => e['kode'] == _selectedUnit);
    if (!itemExists && _selectedUnit != null) {
  // Jangan biarkan error, pastikan Dropdown punya setidaknya satu item yang cocok
  // atau biarkan value-nya null sementara
}
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9F6), // Warna hijau muda sesuai gambar
        border: Border.all(color: const Color(0xFFCDEEE2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Bagian Teks (Nama Alat & Kode)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentNamaAlat,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF312F34),
                  ),
                ),
                Text(
                  'Kode: $_selectedUnit',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3E9F7F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Dropdown Icon & Button yang "transparan" di atas kotak
          DropdownButtonHideUnderline(
  child: DropdownButton<String>(
    value: itemExists ? _selectedUnit : null, // ✅ Cegah error merah
    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF3E9F7F)),
    items: _unitList.map((u) {
      return DropdownMenuItem(
        value: u['kode'],
        child: Text(u['kode']!, style: const TextStyle(fontSize: 13)),
      );
    }).toList(),
    onChanged: (v) {
      final selected = _unitList.firstWhere((e) => e['kode'] == v);
      setState(() {
        _selectedUnit = selected['kode'];
        _selectedUnitId = selected['id'];
        _currentNamaAlat = selected['nama']!;
      });
    },
  ),
),
        ],
      ),
    );
  }

  Widget _dateField(String val) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFCDEEE2)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Text(val, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const Spacer(),
        const Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: Color(0xFF3E9F7F),
        ),
      ],
    ),
  );

  Widget _btn(
    String t,
    BuildContext ctx, {
    bool isOutlined = false,
    bool isPrimary = false,
    required VoidCallback onTap, // Ubah tipe data jadi VoidCallback
  }) => SizedBox(
    height: 48,
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF3E9F7F) : Colors.white,
        side: const BorderSide(color: Color(0xFFCDEEE2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      // HUBUNGKAN onPressed ke onTap yang kita kirim
      onPressed: onTap,
      child: Text(
        t,
        style: TextStyle(
          color: isPrimary ? Colors.white : const Color(0xFF3E9F7F),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
