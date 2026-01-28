import 'package:flutter/material.dart';

class KategoriFormDialog extends StatelessWidget {
  final bool isEdit;
  final TextEditingController nameController;
  final TextEditingController descController;
  final VoidCallback onSave;

  const KategoriFormDialog({
    super.key,
    required this.isEdit,
    required this.nameController,
    required this.descController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildIconHeader(),
                    const SizedBox(width: 12),
                    Text(isEdit ? "Edit Kategori" : "Tambah Kategori",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel("Nama Kategori *"),
            TextField(controller: nameController, decoration: _inputDecoration("Masukkan nama kategori")),
            const SizedBox(height: 15),
            _buildLabel("Keterangan"),
            TextField(controller: descController, maxLines: 3, decoration: _inputDecoration("Keterangan kategori (opsional)")),
            const SizedBox(height: 25),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIconHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(62, 159, 127, 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(isEdit ? Icons.edit_note : Icons.add, color: const Color.fromRGBO(62, 159, 127, 1)),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      );

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Color.fromRGBO(62, 159, 127, 1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Batal", style: TextStyle(color: Color.fromRGBO(62, 159, 127, 1), fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(isEdit ? "Simpan" : "Tambah", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}