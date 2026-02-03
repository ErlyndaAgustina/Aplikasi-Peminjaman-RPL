import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status; // Sekarang pakai String sesuai model
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color text;
    late String label;

    // Normalisasi status ke lowercase agar tidak error jika ada perbedaan case di DB
    switch (status.toLowerCase()) {
      case 'dipinjam':
        bg = const Color.fromRGBO(230, 239, 255, 1);
        text = const Color.fromRGBO(59, 130, 246, 1);
        label = 'Dipinjam';
        break;
      case 'selesai':
        bg = const Color.fromRGBO(220, 252, 231, 1);
        text = const Color.fromRGBO(22, 163, 74, 1);
        label = 'Selesai';
        break;
      case 'ditolak':
        bg = const Color.fromRGBO(254, 226, 226, 1);
        text = const Color.fromRGBO(220, 38, 38, 1);
        label = 'Ditolak';
        break;
      case 'menunggu':
        bg = const Color.fromRGBO(243, 244, 246, 1);
        text = const Color.fromRGBO(107, 114, 128, 1);
        label = 'Menunggu';
        break;
      case 'dikembalikan':
        bg = const Color.fromRGBO(255, 247, 237, 1);
        text = const Color.fromRGBO(249, 115, 22, 1);
        label = 'Dikembalikan';
        break;
      default:
        bg = const Color.fromRGBO(255, 247, 237, 1);
        text = const Color.fromRGBO(249, 115, 22, 1);
        label = status; // Tampilkan status asli jika tidak terdaftar
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}
