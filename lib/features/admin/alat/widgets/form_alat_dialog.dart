import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  final _deskripsiController = TextEditingController(); // Tambahan Deskripsi
  String? selectedKategoriId;
  List<KategoriModel> daftarKategori = [];
  bool isLoading = false;

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _currentImageUrl;

  // Konstanta Warna agar konsisten dengan gambar
  final Color primaryGreen = const Color.fromRGBO(62, 159, 127, 1);
  final Color lightGreenBorder = const Color.fromRGBO(205, 238, 226, 1);
  final Color textHintColor = const Color.fromRGBO(72, 141, 117, 1);

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.alat != null) {
      _namaController.text = widget.alat!.nama;
      _kodeController.text = widget.alat!.kode;
      _deskripsiController.text = widget.alat!.deskripsi ?? '';
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
    if (pickedFile != null) setState(() => _imageFile = pickedFile);
  }

  Future<void> simpan() async {
    if (_namaController.text.isEmpty || selectedKategoriId == null) return;
    setState(() => isLoading = true);
    try {
      String? finalImageUrl = _currentImageUrl;
      if (_imageFile != null) {
        finalImageUrl = await AlatService().uploadImage(_imageFile!);
      }

      final data = {
        'nama_alat': _namaController.text,
        'kode_alat': _kodeController.text,
        'deskripsi': _deskripsiController.text, // Simpan Deskripsi ke DB
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
      ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // HEADER (Sesuai Gambar)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                color: primaryGreen,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.isEdit ? Icons.edit : Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.isEdit ? 'Edit Alat' : 'Tambah Alat',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FOTO ALAT
                    _buildLabel('Foto Alat'),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FBF9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: lightGreenBorder),
                        ),
                        child: _buildImagePreview(),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // INPUT NAMA
                    _buildLabel('Nama Alat *'),
                    TextField(
                      controller: _namaController,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration('Masukkan nama alat'),
                    ),
                    const SizedBox(height: 18),

                    // INPUT KODE
                    _buildLabel('Kode alat *'),
                    TextField(
                      controller: _kodeController,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration('Masukkan kode alat'),
                    ),
                    const SizedBox(height: 18),

                    // INPUT DESKRIPSI (Baru)
                    _buildLabel('Deskripsi'),
                    TextField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(
                        'Masukkan deskripsi alat...',
                      ),
                    ),
                    const SizedBox(height: 18),

                    // DROPDOWN KATEGORI
                    _buildLabel('Kategori*'),
                    DropdownButtonFormField<String>(
                      value: selectedKategoriId,
                      items: daftarKategori
                          .map(
                            (k) => DropdownMenuItem(
                              value: k.id,
                              child: Text(k.nama),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedKategoriId = val),
                      decoration: _inputDecoration('Masukkan kategori alat'),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryGreen,
                      ),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      dropdownColor: Colors.white,
                    ),
                    const SizedBox(height: 32),

                    // BUTTONS
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(color: primaryGreen),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: lightGreenBorder),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: simpan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                widget.isEdit ? 'Simpan' : 'Tambah',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF312F34),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textHintColor.withOpacity(0.6), fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: lightGreenBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primaryGreen, width: 1.5),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: kIsWeb
            ? Image.network(_imageFile!.path, fit: BoxFit.cover)
            : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
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
      children: [
        Icon(Icons.add_a_photo, size: 32, color: primaryGreen),
        const SizedBox(height: 4),
        const Text(
          'Foto Alat',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
