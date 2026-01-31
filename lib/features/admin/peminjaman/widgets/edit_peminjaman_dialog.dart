import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';

class EditPeminjamanDialog extends StatefulWidget {
  final PeminjamanModel data;
  const EditPeminjamanDialog({super.key, required this.data});

  @override
  State<EditPeminjamanDialog> createState() => _EditPeminjamanDialogState();
}

class _EditPeminjamanDialogState extends State<EditPeminjamanDialog> {
  final supabase = Supabase.instance.client;
  
  // Form State
  late DateTime selectedTanggalPinjam;
  late DateTime selectedBatasKembali;
  String? selectedStatus;
  String? selectedUserId; // Untuk menyimpan UUID user yang dipilih
  int jamMulai = 1;
  int jamSelesai = 1;
  
  bool isSaving = false;
  List<Map<String, dynamic>> peminjamList = []; // List untuk dropdown user
  final List<String> statusOptions = ['dipinjam', 'terlambat', 'kembali'];

  @override
  void initState() {
    super.initState();
    _initData();
    _fetchUsers();
  }

  void _initData() {
    // Parsing data awal dari model
    selectedTanggalPinjam = DateTime.tryParse(widget.data.tanggal) ?? DateTime.now();
    selectedBatasKembali = DateTime.tryParse(widget.data.tanggal) ?? DateTime.now();
    selectedStatus = widget.data.status.toLowerCase();
    // Inisialisasi jam (Asumsi format data jam di model kamu tersedia)
    jamMulai = 1; 
    jamSelesai = 2;
  }

  // Fungsi ambil data user dengan role 'peminjam'
  Future<void> _fetchUsers() async {
  try {
    final data = await supabase
        .from('users')
        .select('id_user, nama') // Ganti 'id' jadi 'id_user' (sesuaikan database kamu)
        .eq('role', 'peminjam')
        .order('nama');
    
    setState(() {
      peminjamList = List<Map<String, dynamic>>.from(data);
      try {
        // Ganti 'id' di sini juga sesuai nama kolom database
        selectedUserId = peminjamList.firstWhere((u) => u['nama'] == widget.data.nama)['id_user'];
      } catch (_) {}
    });
  } catch (e) {
    print('Error fetching users: $e');
  }
}

  Future<void> _updateData() async {
    setState(() => isSaving = true);
    try {
      await supabase.from('peminjaman').update({
        'user_id': selectedUserId,
        'status': selectedStatus,
        'tanggal_pinjam': selectedTanggalPinjam.toIso8601String(),
        'batas_kembali': selectedBatasKembali.toIso8601String(),
        'jam_pelajaran': '$jamMulai-$jamSelesai', // Format sesuai UI kamu
      }).eq('id_peminjaman', widget.data.id);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color.fromRGBO(62, 159, 127, 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(primaryGreen),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Kode Peminjaman'),
                  _field(widget.data.kode, enabled: false),
                  const SizedBox(height: 16),

                  _label('Nama Peminjam'),
                  _buildUserDropdown(),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: _buildDateSection('Tanggal Pinjam', true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDateSection('Batas Kembali', false)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _label('Jam Pelajaran'),
                  _buildJamPelajaran(),
                  const SizedBox(height: 16),

                  _label('Status Peminjaman'),
                  _buildStatusDropdown(),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(child: _btnBatal()),
                      const SizedBox(width: 12),
                      Expanded(child: _btnSimpan(primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER COMPONENTS ---

  Widget _buildUserDropdown() {
  // 1. Cek apakah list user sudah ada isinya atau belum
  if (peminjamList.isEmpty) {
    return _dropdownContainer(
      const Center(
        child: Text("Memuat data user...", style: TextStyle(fontSize: 12)),
      ),
    );
  }

  // 2. Cek apakah selectedUserId yang sekarang ada di dalam list
  final bool isIdValid = peminjamList.any((user) => user['id'].toString() == selectedUserId);
  
  // Jika valid pakai ID-nya, jika tidak valid (atau null) jangan dipaksa
  final String? safeValue = isIdValid ? selectedUserId : null;

  return _dropdownContainer(
    DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text("Pilih nama peminjam"),
        value: safeValue, // Gunakan nilai yang sudah dicek
        // Kita filter items supaya tidak ada nilai duplikat atau null yang tidak sengaja masuk
        items: peminjamList.map((user) {
          return DropdownMenuItem<String>(
            value: user['id'].toString(),
            child: Text(user['nama'] ?? 'Tanpa Nama'),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            selectedUserId = val;
          });
        },
      ),
    ),
  );
}

  Widget _buildJamPelajaran() {
    return Row(
      children: [
        _jamBox(jamMulai, (val) => setState(() => jamMulai = val!)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("-")),
        _jamBox(jamSelesai, (val) => setState(() => jamSelesai = val!)),
      ],
    );
  }

  Widget _jamBox(int currentVal, ValueChanged<int?> onChanged) {
  return Container(
    width: 75, // Ditambah sedikit biar gak sesak (tadi 60)
    padding: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFCDEEE2)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: currentVal,
        isExpanded: true, // Tambahkan ini agar konten menyesuaikan lebar Container
        icon: const Icon(Icons.arrow_drop_down, size: 18), // Kecilkan icon-nya
        items: List.generate(10, (index) => index + 1)
            .map((e) => DropdownMenuItem(
                  value: e, 
                  child: Text(e.toString(), style: const TextStyle(fontSize: 13))
                ))
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

  Widget _buildDateSection(String title, bool isPinjam) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        _datePickerField(
          DateFormat('dd/MM/yyyy').format(isPinjam ? selectedTanggalPinjam : selectedBatasKembali),
          () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: isPinjam ? selectedTanggalPinjam : selectedBatasKembali,
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() => isPinjam ? selectedTanggalPinjam = picked : selectedBatasKembali = picked);
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return _dropdownContainer(
      DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        value: selectedStatus,
        items: statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s[0].toUpperCase() + s.substring(1)))).toList(),
        onChanged: (v) => setState(() => selectedStatus = v),
      ),
    );
  }

  Widget _dropdownContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCDEEE2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  // --- Stylings remain similar to your UI ---
  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF312F34))));
  
  Widget _field(String val, {bool enabled = true}) => TextFormField(
    initialValue: val, enabled: enabled,
    decoration: InputDecoration(
      filled: !enabled, fillColor: enabled ? Colors.white : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCDEEE2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCDEEE2))),
    ),
  );

  Widget _buildHeader(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: Row(
        children: [
          const Icon(Icons.edit_document, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          const Text('Edit Peminjaman', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const Spacer(),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
        ],
      ),
    );
  }
  
  Widget _datePickerField(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCDEEE2)), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
            const Icon(Icons.calendar_month, size: 20, color: Color(0xFF3E9F7F)),
          ],
        ),
      ),
    );
  }

  Widget _btnBatal() => OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: Color(0xFF3E9F7F)), minimumSize: const Size(0, 50)), child: const Text('Batal', style: TextStyle(color: Color(0xFF3E9F7F), fontWeight: FontWeight.bold, fontSize: 16)));

  Widget _btnSimpan(Color color) => ElevatedButton(onPressed: isSaving ? null : _updateData, style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(0, 50)), child: isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)));
}