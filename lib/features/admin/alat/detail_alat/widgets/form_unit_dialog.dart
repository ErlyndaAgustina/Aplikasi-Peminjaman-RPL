import 'package:flutter/material.dart';
import '../../services/service.dart';
import '../models/model.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _kondisiController = TextEditingController();
  String _selectedStatus = 'tersedia';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.unit != null) {
      _kodeController.text = widget.unit!.kodeUnit;
      _kondisiController.text = widget.unit!.kondisi;
      _selectedStatus = widget.unit!.status.toLowerCase();
    }
  }

  Future<void> _handleSave() async {
    final data = {
      'id_alat': widget.idAlat ?? widget.unit?.idAlat,
      'kode_unit': _kodeController.text.trim(),
      'kondisi': _kondisiController.text.trim(),
      'status': _selectedStatus,
    };

    if (data['id_alat'] == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ID Alat tidak ditemukan")));
      return;
    }

    try {
      if (widget.isEdit) {
        await AlatService().updateUnitAlat(widget.unit!.idUnit, data);
      } else {
        await AlatService().insertUnitAlat(data);
      }
      widget.onRefresh();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color.fromRGBO(62, 159, 127, 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: primaryGreen,
                child: Row(
                  children: [
                    Icon(
                      widget.isEdit
                          ? Icons.edit_note
                          : Icons.add_circle_outline,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isEdit ? 'Edit Unit' : 'Tambah Unit',
                      style: const TextStyle(
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
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Kode unit *'),
                    _buildTextField(
                      hint: 'Contoh: LTP-001-U1',
                      controller: _kodeController,
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('Kondisi Alat *'),
                    _buildTextField(
                      hint: 'Masukkan kondisi alat',
                      controller: _kondisiController,
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('Status Ketersediaan *'),
                    _buildDropdown(),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            'Batal',
                            isOutlined: true,
                            context: context,
                            onPress: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildButton(
                            widget.isEdit ? 'Simpan' : 'Tambah',
                            context: context,
                            onPress: _handleSave,
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
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF312F34),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
        ),
      ),
    );
  }

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
          value: _selectedStatus,
          items: ['tersedia', 'dipinjam', 'rusak', 'perbaikan'].map((
            String val,
          ) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val[0].toUpperCase() + val.substring(1),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedStatus = value);
          },
        ),
      ),
    );
  }

  Widget _buildButton(
    String text, {
    bool isOutlined = false,
    required BuildContext context,
    required VoidCallback onPress,
  }) {
    const Color primaryGreen = Color.fromRGBO(62, 159, 127, 1);
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isOutlined ? Colors.white : primaryGreen,
          side: isOutlined
              ? const BorderSide(color: Color.fromRGBO(205, 238, 226, 1))
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
            color: isOutlined ? primaryGreen : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
