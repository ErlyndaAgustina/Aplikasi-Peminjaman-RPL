import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  // Kita buat helper agar pengecekan tidak sensitif huruf besar/kecil
  String get _cleanStatus => status.toLowerCase().trim();

  Color get bgColor {
    switch (_cleanStatus) {
      case 'tersedia':
        return const Color.fromRGBO(217, 253, 240, 1);
      case 'dipinjam':
        return const Color.fromRGBO(219, 234, 254, 1);
      case 'rusak':
        return const Color.fromRGBO(255, 119, 119, 0.22);
      case 'perbaikan':
        return const Color.fromRGBO(255, 237, 213, 1); // Kuning lembut
      default:
        return const Color.fromRGBO(243, 244, 246, 1);
    }
  }

  Color get textColor {
    switch (_cleanStatus) {
      case 'tersedia':
        return const Color.fromRGBO(1, 85, 56, 1);
      case 'dipinjam':
        return const Color.fromRGBO(37, 99, 235, 1);
      case 'rusak':
        return const Color.fromRGBO(255, 2, 2, 1); // Merah tegas
      case 'perbaikan':
        return const Color.fromRGBO(235, 98, 26, 1); // Coklat/Gold
      default:
        return const Color.fromRGBO(107, 114, 128, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Agar tampilan teks di UI tetap rapi (Capital di depan)
    String displayStatus = _cleanStatus.isEmpty
        ? 'Unknown'
        : _cleanStatus[0].toUpperCase() + _cleanStatus.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          8,
        ), // Dibuat sedikit lebih kotak agar modern
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'Roboto', // Sesuai desain kamu sebelumnya
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
