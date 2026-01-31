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

  late DateTime selectedTanggalPinjam;
  late DateTime selectedBatasKembali;
  String? selectedStatus;
  String? selectedUserId;
  int jamMulai = 1;
  int jamSelesai = 1;

  bool isSaving = false;
  List<Map<String, dynamic>> peminjamList = [];
  final List<String> statusOptions = [
    'dipinjam',
    'terlambat',
  ];

  @override
  void initState() {
    super.initState();
    _initData();
    _fetchUsers();
  }

  void _initData() {
    // Karena widget.data.tanggal sudah diformat "DD Bulan YYYY",
    // kita tidak bisa pakai tryParse langsung.
    // Idealnya, simpan DateTime asli di model. Untuk sekarang, kita default ke .now()
    // atau kamu bisa tambahkan property DateTime original di modelmu nanti.
    selectedTanggalPinjam = DateTime.now();
    selectedBatasKembali = DateTime.now().add(const Duration(hours: 5));

    selectedStatus = widget.data.status.toLowerCase();

    // Parsing jam dari "1 - 5" menjadi int
    try {
      final parts = widget.data.jam.split(' - ');
      jamMulai = int.parse(parts[0]);
      jamSelesai = int.parse(parts[1]);
    } catch (_) {
      jamMulai = 1;
      jamSelesai = 1;
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final data = await supabase
          .from('users')
          .select('id_user, nama')
          .eq('role', 'peminjam')
          .order('nama');

      if (mounted) {
        setState(() {
          peminjamList = List<Map<String, dynamic>>.from(data);
          // Cari ID user berdasarkan nama yang ada di card
          try {
            selectedUserId = peminjamList
                .firstWhere((u) => u['nama'] == widget.data.nama)['id_user']
                .toString();
          } catch (_) {
            selectedUserId = null;
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  Future<void> _updateData() async {
    setState(() => isSaving = true);
    try {
      await supabase
          .from('peminjaman')
          .update({
            'id_user':
                selectedUserId, // Pastikan nama kolom di DB adalah id_user
            'status': selectedStatus,
            'tanggal_pinjam': selectedTanggalPinjam.toIso8601String(),
            'batas_kembali': selectedBatasKembali.toIso8601String(),
            'jam_mulai': jamMulai,
            'jam_selesai': jamSelesai,
          })
          .eq('id_peminjaman', widget.data.id);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update: $e')));
    } finally {
      if (mounted) setState(() => isSaving = false);
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
                      Expanded(
                        child: _buildDateSection('Tanggal Pinjam', true),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateSection('Batas Kembali', false),
                      ),
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

  // --- UI COMPONENTS (FIXED) ---

  Widget _buildUserDropdown() {
    return _dropdownContainer(
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text(
            "Pilih nama peminjam",
            style: TextStyle(fontSize: 13),
          ),
          value:
              (peminjamList.any(
                (u) => u['id_user'].toString() == selectedUserId,
              ))
              ? selectedUserId
              : null,
          items: peminjamList.map((user) {
            return DropdownMenuItem<String>(
              value: user['id_user'].toString(),
              child: Text(
                user['nama'] ?? 'Tanpa Nama',
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => selectedUserId = val),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return _dropdownContainer(
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: statusOptions.contains(selectedStatus) ? selectedStatus : null,
          items: statusOptions
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    s[0].toUpperCase() + s.substring(1),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => selectedStatus = v),
        ),
      ),
    );
  }

  Widget _buildJamPelajaran() {
    return Row(
      children: [
        _jamBox(jamMulai, (val) => setState(() => jamMulai = val!)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text("-", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        _jamBox(jamSelesai, (val) => setState(() => jamSelesai = val!)),
      ],
    );
  }

  Widget _jamBox(int currentVal, ValueChanged<int?> onChanged) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCDEEE2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: currentVal,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Color(0xFF3E9F7F),
          ),
          items: List.generate(10, (index) => index + 1)
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.toString(),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- UI HELPERS (STYLES) ---
  Widget _dropdownContainer(Widget child) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCDEEE2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Color(0xFF312F34),
      ),
    ),
  );

  Widget _field(String val, {bool enabled = true}) => TextFormField(
    initialValue: val,
    enabled: enabled,
    style: const TextStyle(fontSize: 13),
    decoration: InputDecoration(
      filled: !enabled,
      fillColor: enabled ? Colors.white : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
      ),
    ),
  );

  Widget _buildHeader(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_note_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Edit Peminjaman',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(String title, bool isPinjam) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        _datePickerField(
          DateFormat(
            'dd/MM/yyyy',
          ).format(isPinjam ? selectedTanggalPinjam : selectedBatasKembali),
          () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: isPinjam
                  ? selectedTanggalPinjam
                  : selectedBatasKembali,
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(
                () => isPinjam
                    ? selectedTanggalPinjam = picked
                    : selectedBatasKembali = picked,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _datePickerField(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCDEEE2)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
            const Icon(
              Icons.calendar_month,
              size: 18,
              color: Color(0xFF3E9F7F),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnBatal() => OutlinedButton(
    onPressed: () => Navigator.pop(context),
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: Color(0xFF3E9F7F)),
      minimumSize: const Size(0, 50),
    ),
    child: const Text(
      'Batal',
      style: TextStyle(
        color: Color(0xFF3E9F7F),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );

  Widget _btnSimpan(Color color) => ElevatedButton(
    onPressed: isSaving ? null : _updateData,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      minimumSize: const Size(0, 50),
    ),
    child: isSaving
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : const Text(
            'Simpan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
  );
}
