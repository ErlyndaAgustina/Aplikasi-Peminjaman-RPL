import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Penting untuk cek Web
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

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.alat != null) {
      _namaController.text = widget.alat!.nama;
      _kodeController.text = widget.alat!.kode;
      selectedKategoriId = widget.alat!.kategoriId;
      _currentImageUrl = widget.alat!.imageUrl;
    }
    loadKategori();
  }

  Future<void> loadKategori() async {
    final data = await AlatService().getKategori();
    setState(() => daftarKategori = data);
  }

  Future<void> _pickImage() async {
  final XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 70,
  );

  if (pickedFile != null) {
    setState(() {
      _imageFile = pickedFile;
    });
  }
}

  Future<void> simpan() async {
    if (_namaController.text.isEmpty || selectedKategoriId == null) return;

    setState(() => isLoading = true);

    try {
      String? finalImageUrl = _currentImageUrl;

      // Jika ada gambar baru yang dipilih
      if (_imageFile != null) {
        finalImageUrl = await AlatService().uploadImage(_imageFile!);
      }

      final data = {
        'nama_alat': _namaController.text,
        'kode_alat': _kodeController.text,
        'id_kategori': selectedKategoriId,
        'image_url': finalImageUrl,
      };

      if (widget.isEdit) {
        await AlatService().updateAlat(widget.alat!.id, data);
      } else {
        await AlatService().insertAlat(data);
      }

      widget.onRefresh();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
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
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isEdit ? Icons.edit : Icons.add,
                    color: Colors.white,
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Foto Alat'),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color.fromRGBO(205, 238, 226, 1),
                        ),
                      ),
                      child: _buildImagePreview(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Nama Alat *'),
                  TextField(
                    controller: _namaController,
                    decoration: _inputDecoration('Contoh: Laptop MacBook Pro'),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Kode Alat *'),
                  TextField(
                    controller: _kodeController,
                    decoration: _inputDecoration('Contoh: LPT-001'),
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

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: kIsWeb
            ? Image.network(_imageFile!.path, fit: BoxFit.cover)
            : Image.network(_imageFile!.path, fit: BoxFit.cover),
      );
    }

    if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(_currentImageUrl!, fit: BoxFit.cover),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.add_a_photo,
          size: 40,
          color: Color.fromRGBO(62, 159, 127, 1),
        ),
        SizedBox(height: 8),
        Text('Ketuk untuk pilih foto', style: TextStyle(color: Colors.grey)),
      ],
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
