import 'package:flutter/material.dart';
import 'dart:typed_data'; // Tambahkan ini untuk Uint8List
import '../../services/service.dart';
import '../models/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormUnitDialog extends StatefulWidget {
  final bool isEdit;
  final UnitAlatModel? unit;
  final String? idAlat;
  final VoidCallback onRefresh;

  const FormUnitDialog({
    super.key,
    this.isEdit = false,
    this.unit,
    this.idAlat,
    required this.onRefresh,
  });

  @override
  State<FormUnitDialog> createState() => _FormUnitDialogState();
}

class _FormUnitDialogState extends State<FormUnitDialog> {
  final _kodeController = TextEditingController();
  final _kondisiController = TextEditingController();
  final _videoUrlController =
      TextEditingController(); // Untuk simpan URL lama/baru
  String? _selectedStatus;

  static const Color primaryGreen = Color(0xFF43A081);
  static const Color lightGreenBorder = Color(0xFFD1EBE1);
  static const Color textHintColor = Color(0xFF6DA391);

  XFile? _selectedVideoXFile; // PAKAI XFILE
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.unit != null) {
      _kodeController.text = widget.unit!.kodeUnit;
      _kondisiController.text = widget.unit!.kondisi;
      _videoUrlController.text = widget.unit!.videoUrl ?? '';
      _selectedStatus = widget.unit!.status.toLowerCase();
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );

    if (pickedFile != null) {
      setState(() {
        _selectedVideoXFile = pickedFile;
      });
    }
  }

  // REVISI: Fungsi upload menerima XFile, bukan File
  Future<String?> _uploadVideo(XFile xFile) async {
    try {
      final fileName = 'vid_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Ambil bytes langsung dari XFile, ini kunci anti error _Namespace
      final Uint8List bytes = await xFile.readAsBytes();

      await Supabase.instance.client.storage
          .from('alat_vidios')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'video/mp4',
              upsert: false,
            ),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from('alat_vidios')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      debugPrint("Error upload ke storage: $e");
      return null;
    }
  }

  Future<void> _handleSave() async {
    if (_kodeController.text.isEmpty || _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode unit dan Status harus diisi!")),
      );
      return;
    }

    setState(() => _isUploading = true);

    String finalVideoUrl = _videoUrlController.text.trim();

    // REVISI: Cek _selectedVideoXFile
    if (_selectedVideoXFile != null) {
      final uploadedUrl = await _uploadVideo(_selectedVideoXFile!);
      if (uploadedUrl != null) {
        finalVideoUrl = uploadedUrl;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Gagal mengupload video. Cek koneksi/Storage Policy.",
              ),
            ),
          );
        }
        setState(() => _isUploading = false);
        return;
      }
    }

    final data = {
      'id_alat': widget.idAlat ?? widget.unit?.idAlat,
      'kode_unit': _kodeController.text.trim(),
      'kondisi': _kondisiController.text.trim(),
      'status': _selectedStatus,
      'video_url': finalVideoUrl,
    };

    try {
      if (widget.isEdit) {
        await AlatService().updateUnitAlat(widget.unit!.idUnit, data);
      } else {
        if (data['id_alat'] == null) throw "ID Alat induk tidak ditemukan";
        await AlatService().insertUnitAlat(data);
      }

      widget.onRefresh();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("DB Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal simpan ke database: $e")));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  String _generateRandomCode() {
    final randomNum = (1000 + (DateTime.now().millisecond % 900));
    return "LTP-$randomNum";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Upload Video Unit'),
                        _buildVideoPicker(),
                        const SizedBox(height: 18),
                        _buildLabel('Kode Unit *'),
                        Row(
                          children: [
                            // Bagian TextField yang dipersingkat
                            Expanded(
                              child: _buildTextField(
                                hint: 'LTP-001',
                                controller: _kodeController,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Tombol Generate
                            Container(
                              height: 50, // Sesuaikan dengan tinggi TextField
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F9F6),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: lightGreenBorder),
                              ),
                              child: IconButton(
                                tooltip: "Generate Kode Otomatis",
                                icon: const Icon(
                                  Icons.auto_awesome,
                                  color: primaryGreen,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _kodeController.text =
                                        _generateRandomCode();
                                  });
                                  // Kasih feedback dikit biar keren
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Kode berhasil dibuat otomatis!",
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _buildLabel('Kondisi Alat *'),
                        _buildTextField(
                          hint: 'Masukkan kondisi alat',
                          controller: _kondisiController,
                        ),
                        const SizedBox(height: 18),
                        _buildLabel('Status Ketersediaan *'),
                        _buildDropdown(),
                        const SizedBox(height: 32),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(color: primaryGreen),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: primaryGreen,
      child: Row(
        children: [
          Icon(
            widget.isEdit ? Icons.edit : Icons.add_circle,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(
            widget.isEdit ? 'Edit Unit Alat' : 'Tambah Unit Alat',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPicker() {
    return GestureDetector(
      onTap: _pickVideo,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: lightGreenBorder),
        ),
        child: Column(
          children: [
            const Icon(Icons.cloud_upload, color: primaryGreen, size: 32),
            const SizedBox(height: 8),
            Text(
              _selectedVideoXFile == null
                  ? (_videoUrlController.text.isNotEmpty
                        ? 'Video Tersedia (Klik untuk ganti)'
                        : 'Pilih Video dari Galeri')
                  : _selectedVideoXFile!.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: textHintColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: lightGreenBorder),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Batal', style: TextStyle(color: primaryGreen)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isUploading ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(widget.isEdit ? 'Simpan' : 'Tambah'),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightGreenBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGreen),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      hint: const Text(
        'Pilih status alat',
        style: TextStyle(color: textHintColor, fontSize: 14),
      ),
      items: ['tersedia', 'dipinjam', 'rusak', 'perbaikan'].map((
        String status,
      ) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(
            status[0].toUpperCase() + status.substring(1),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedStatus = newValue;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightGreenBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGreen),
        ),
      ),
      // Styling dropdown popup
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: primaryGreen),
    );
  }
}
