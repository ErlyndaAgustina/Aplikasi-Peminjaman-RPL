import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  Color get bg {
    switch (status) {
      case 'dipinjam':
        return const Color.fromRGBO(219, 234, 254, 1);
      case 'terlambat':
        return const Color.fromRGBO(255, 225, 225, 1);
      default:
        return const Color(0xFFE6F4EA);
    }
  }

  Color get fg {
    switch (status) {
      case 'dipinjam':
        return const Color.fromRGBO(37, 99, 235, 1);
      case 'terlambat':
        return Color.fromRGBO(255, 2, 2, 1);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
