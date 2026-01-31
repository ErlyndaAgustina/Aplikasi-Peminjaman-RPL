import 'package:flutter/material.dart';
import '../models/model.dart';

class DetailPengembalianDialog extends StatelessWidget {
  final PengembalianModel data;
  const DetailPengembalianDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _item('Nama Peminjam', data.nama),
                    _item('Kode Peminjaman', data.kode),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2, // Tanggal lebih lebar
                          child: _item('Kembali Pada', data.tanggal),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1, // Jam lebih kecil
                          child: _item('Jam ke', '${data.jamSelesai}'),
                        ),
                      ],
                    ),

                    _item(
                      'Unit yang dikembalikan',
                      '${data.namaAlat}\nKode: ${data.kodeUnit}', // Ini akan muncul persis seperti gambar
                      isBox: true,
                    ),

                    _item('Terlambat', '${data.terlambatMenit} menit'),
                    _item('Denda Terlambat', 'Rp ${data.dendaTerlambat}'),
                    _item('Denda Rusak', 'Rp ${data.dendaRusak}'),
                    _item('Catatan Kerusakan', data.catatan),

                    _item(
                      'Total Denda',
                      'Rp ${data.totalDenda}',
                      isLast: true,
                      isBoldVal: true, // Tambahkan opsi bold untuk total
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF3E9F7F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.visibility, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Detail Pengembalian',
            style: TextStyle(
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
    );
  }

  Widget _item(
    String label,
    String val, {
    bool isBox = false,
    bool isLast = false,
    bool isBoldVal = false, // Parameter baru
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isBox ? const Color(0xFFF0F9F6) : Colors.white,
              border: Border.all(color: const Color(0xFFCDEEE2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              val,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBoldVal ? FontWeight.bold : FontWeight.normal,
                color: isBox
                    ? const Color(0xFF3E9F7F)
                    : (isBoldVal ? Colors.red : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
