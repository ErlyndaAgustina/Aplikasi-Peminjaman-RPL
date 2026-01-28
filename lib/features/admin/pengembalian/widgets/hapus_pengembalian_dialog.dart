import 'package:flutter/material.dart';

class HapusPengembalianDialog extends StatelessWidget {
  const HapusPengembalianDialog({super.key});

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
            const SizedBox(height: 16),
            const Text(
              'Apakah yakin ingin menghapus Pengembalian?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF312F34)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _btn('Batal', context, isOutlined: true)),
                const SizedBox(width: 12),
                Expanded(child: _btn('Hapus', context, isDanger: true)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String t, BuildContext ctx, {bool isOutlined = false, bool isDanger = false}) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isDanger ? Colors.red : const Color(0xFF3E9F7F)),
          backgroundColor: isDanger ? Colors.white : (isOutlined ? Colors.white : const Color(0xFF3E9F7F)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: () => Navigator.pop(ctx),
        child: Text(t, style: TextStyle(color: isDanger ? Colors.red : (isOutlined ? const Color(0xFF3E9F7F) : Colors.white), fontWeight: FontWeight.bold)),
      ),
    );
  }
}