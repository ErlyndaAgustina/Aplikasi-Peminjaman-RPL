import 'package:flutter/material.dart';
import '../models/model.dart';

class FormUnitDialog extends StatelessWidget {
  final bool isEdit;
  final UnitAlatModel? unit;

  const FormUnitDialog({super.key, this.isEdit = false, this.unit});

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
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: primaryGreen,
              child: Row(
                children: [
                  Icon(isEdit ? Icons.edit_note : Icons.add_circle_outline, color: Colors.white.withOpacity(0.8)),
                  const SizedBox(width: 8),
                  Text(
                    isEdit ? 'Edit Unit' : 'Tambah Unit',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Kode unit *'),
                  _buildTextField(hint: 'Contoh: LTP-001-U1', initialValue: unit?.kodeUnit),
                  const SizedBox(height: 16),
                  _buildLabel('Kondisi Alat *'),
                  _buildTextField(hint: 'Masukkan kondisi alat', initialValue: unit?.kondisi),
                  const SizedBox(height: 16),
                  _buildLabel('Status Ketersediaan *'),
                  _buildDropdown(),
                  const SizedBox(height: 32),
                  // Buttons
                  Row(
                    children: [
                      Expanded(child: _buildButton('Batal', isOutlined: true, context: context)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildButton(isEdit ? 'Simpan' : 'Tambah', context: context)),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF312F34))),
    );
  }

  Widget _buildTextField({required String hint, String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1))),
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
          hint: const Text('Pilih Status', style: TextStyle(fontSize: 14)),
          value: unit?.status,
          items: ['Tersedia', 'Dipinjam', 'Rusak', 'Perbaikan'].map((String val) {
            return DropdownMenuItem<String>(value: val, child: Text(val));
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _buildButton(String text, {bool isOutlined = false, required BuildContext context}) {
    const Color primaryGreen = Color.fromRGBO(62, 159, 127, 1);
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isOutlined ? Colors.white : primaryGreen,
          side: isOutlined ? const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(text, style: TextStyle(color: isOutlined ? primaryGreen : Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}