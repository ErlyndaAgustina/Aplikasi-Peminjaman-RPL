import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_outline, color: Colors.red, size: 80),
            const SizedBox(height: 24),
            const Text(
              'Apakah yakin ingin menghapus Detail Alat?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF312F34)),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildBtn('Batal', isRed: false, context: context)),
                const SizedBox(width: 12),
                Expanded(child: _buildBtn('Hapus', isRed: true, context: context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(String text, {required bool isRed, required BuildContext context}) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isRed ? Colors.red : const Color.fromRGBO(62, 159, 127, 1)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(text, style: TextStyle(color: isRed ? Colors.red : const Color.fromRGBO(62, 159, 127, 1), fontWeight: FontWeight.bold)),
      ),
    );
  }
}