import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HapusPengembalianDialog extends StatelessWidget {
  final String id;
  final VoidCallback onDeleted;
  const HapusPengembalianDialog({
    super.key,
    required this.id,
    required this.onDeleted,
  });

  Future<void> _deleteData(BuildContext context) async {
    try {
      // DEBUG: Pastikan ID yang dikirim benar
      debugPrint('Mencoba hapus ID: $id');

      await Supabase.instance.client
          .from('pengembalian')
          .delete()
          .eq('id_pengembalian', id);
      
      // Jika sampai sini berarti berhasil (tidak ada error)
      if (context.mounted) {
        Navigator.pop(context); // Tutup dialog
        onDeleted(); // Panggil refresh di halaman utama
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error delete: $e');
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF312F34),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Tombol Batal
                Expanded(
                  child: _btn('Batal', context, isOutlined: true, onPress: () {
                    Navigator.pop(context);
                  }),
                ),
                const SizedBox(width: 12),
                // Tombol Hapus
                Expanded(
                  child: _btn('Hapus', context, isDanger: true, onPress: () {
                    _deleteData(context); // JALANKAN FUNGSI HAPUS DI SINI
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget tombol yang sudah diperbaiki logic-nya
  Widget _btn(
    String t,
    BuildContext ctx, {
    bool isOutlined = false,
    bool isDanger = false,
    required VoidCallback onPress, // Tambahkan parameter wajib ini
  }) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDanger ? Colors.red : const Color(0xFF3E9F7F),
          ),
          backgroundColor: isDanger
              ? Colors.red
              : (isOutlined ? Colors.white : const Color(0xFF3E9F7F)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPress, // Gunakan callback yang dikirim dari build
        child: Text(
          t,
          style: TextStyle(
            color: isDanger
                ? Colors.white
                : (isOutlined ? const Color(0xFF3E9F7F) : Colors.white),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}