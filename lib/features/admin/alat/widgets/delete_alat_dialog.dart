import 'package:flutter/material.dart';
import '../services/service.dart';

class DeleteAlatDialog extends StatefulWidget { // Ubah ke StatefulWidget untuk handle loading
  final String id;
  final String nama;
  final VoidCallback onDeleteSuccess;

  const DeleteAlatDialog({
    super.key,
    required this.id,
    required this.nama,
    required this.onDeleteSuccess,
  });

  @override
  State<DeleteAlatDialog> createState() => _DeleteAlatDialogState();
}

class _DeleteAlatDialogState extends State<DeleteAlatDialog> {
  bool isLoading = false; // Status loading

  Future<void> _prosesHapus() async {
    setState(() => isLoading = true);
    try {
      await AlatService().deleteAlat(widget.id); // Panggil service Supabase
      widget.onDeleteSuccess(); // Refresh list di halaman utama
      if (mounted) Navigator.pop(context); // Tutup dialog
      
      // Opsional: Kasih snackbar biar user tau udah berhasil
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.nama} berhasil dihapus')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      // Tampilkan error jika gagal
      if (mounted) {
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
            const SizedBox(height: 24),
            Text(
              'Apakah yakin ingin menghapus\n${widget.nama}?', // Menampilkan nama alat biar jelas
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFF312F34),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 32),
            if (isLoading)
              const CircularProgressIndicator(color: Colors.red)
            else
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
    final Color color = isRed ? Colors.red : const Color.fromRGBO(62, 159, 127, 1);
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: isRed ? _prosesHapus : () => Navigator.pop(context), // Pasang fungsi hapus
        child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}