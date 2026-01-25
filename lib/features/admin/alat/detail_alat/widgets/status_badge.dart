import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get bgColor {
    switch (status) {
      case 'Tersedia':
        return const Color.fromRGBO(217, 253, 240, 1);
      case 'Dipinjam':
        return const Color.fromRGBO(219, 234, 254, 1);
      case 'Rusak':
        return const Color.fromRGBO(255, 119, 119, 0.22);
      default:
        return const Color.fromRGBO(255, 237, 213, 1);
    }
  }

  Color get textColor {
    switch (status) {
      case 'Tersedia':
        return const Color.fromRGBO(1, 85, 56, 1);
      case 'Dipinjam':
        return const Color.fromRGBO(37, 99, 235, 1);
      case 'Rusak':
        return Color.fromRGBO(255, 2, 2, 1);
      default:
        return const Color.fromRGBO(235, 98, 26, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
