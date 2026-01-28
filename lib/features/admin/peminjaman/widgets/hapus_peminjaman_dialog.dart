import 'package:flutter/material.dart';

class HapusPeminjamanDialog extends StatelessWidget {
  final String namaPeminjam;
  const HapusPeminjamanDialog({super.key, required this.namaPeminjam});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Trash Red
            const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 80),
            const SizedBox(height: 24),
            Text(
              'Apakah yakin ingin menghapus\nPeminjaman $namaPeminjam?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF312F34),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildBtn('Batal', isOutlined: true, context: context)),
                const SizedBox(width: 12),
                Expanded(child: _buildBtn('Hapus', isOutlined: false, context: context, isDelete: true)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(String text, {required bool isOutlined, required BuildContext context, bool isDelete = false}) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isDelete ? Colors.red : const Color(0xFFCDEEE2)),
          backgroundColor: isOutlined ? Colors.white : (isDelete ? Colors.red : Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => Navigator.pop(context, isDelete ? true : false),
        child: Text(
          text,
          style: TextStyle(
            color: isOutlined ? (isDelete ? Colors.red : const Color(0xFF3E9F7F)) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}