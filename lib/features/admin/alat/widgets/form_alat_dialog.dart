import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/service.dart';

class FormAlatDialog extends StatefulWidget {
  final bool isEdit;
  final AlatModel? alat;
  final VoidCallback onRefresh;

  const FormAlatDialog({
    super.key,
    this.isEdit = false,
    this.alat,
    required this.onRefresh,
  });

  @override
  State<FormAlatDialog> createState() => _FormAlatDialogState();
}

class _FormAlatDialogState extends State<FormAlatDialog> {
  final _namaController = TextEditingController();
  final _kodeController = TextEditingController();
  String? selectedKategoriId;
  List<KategoriModel> daftarKategori = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.alat != null) {
      _namaController.text = widget.alat!.nama;
      _kodeController.text = widget.alat!.kode;
      selectedKategoriId = widget.alat!.kategoriId;
    }
    loadKategori();
  }

  Future<void> loadKategori() async {
    final data = await AlatService().getKategori();
    setState(() => daftarKategori = data);
  }

  Future<void> simpan() async {
    if (_namaController.text.isEmpty || selectedKategoriId == null) return;

    setState(() => isLoading = true);
    final data = {
      'nama_alat': _namaController.text,
      'kode_alat': _kodeController.text,
      'id_kategori': selectedKategoriId,
    };

    try {
      if (widget.isEdit) {
        await AlatService().updateAlat(widget.alat!.id, data);
      } else {
        await AlatService().insertAlat(data);
      }
      widget.onRefresh();
      Navigator.pop(context);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color.fromRGBO(62, 159, 127, 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: primaryGreen,
              child: Row(
                children: [
                  Icon(
                    widget.isEdit ? Icons.edit : Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.isEdit ? 'Edit Alat' : 'Tambah Alat',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // BODY FORM
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Nama Alat *'),
                  TextField(
                    controller: _namaController,
                    decoration: _inputDecoration('Nama'),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Kode Alat *'),
                  TextField(
                    controller: _kodeController,
                    decoration: _inputDecoration('Kode'),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Kategori *'),
                  _buildDropdown(),
                  const SizedBox(height: 32),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton('Batal', isOutlined: true),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildButton(
                            widget.isEdit ? 'Simpan' : 'Tambah',
                          ),
                        ),
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

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
    ),
  );

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedKategoriId,
          items: daftarKategori
              .map((k) => DropdownMenuItem(value: k.id, child: Text(k.nama)))
              .toList(),
          onChanged: (val) => setState(() => selectedKategoriId = val),
        ),
      ),
    );
  }

  Widget _buildLabel(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildButton(String text, {bool isOutlined = false}) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: isOutlined
          ? Colors.white
          : const Color.fromRGBO(62, 159, 127, 1),
      foregroundColor: isOutlined ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: isOutlined ? () => Navigator.pop(context) : simpan,
    child: Text(text),
  );
}
