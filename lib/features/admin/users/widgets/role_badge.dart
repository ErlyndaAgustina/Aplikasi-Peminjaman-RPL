import 'package:flutter/material.dart';

const String roboto = 'Roboto';
class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  Color get bgColor {
    switch (role) {
      case 'admin':
        return const Color.fromRGBO(217, 253, 240, 1);
      case 'petugas':
        return const Color.fromRGBO(219, 234, 254, 1);
      case 'peminjam':
        return const Color.fromRGBO(255, 237, 213, 1);
      default:
        return const Color(0xFFFFEFE5);
    }
  }

  Color get textColor {
    switch (role) {
      case 'admin':
        return const Color.fromRGBO(1, 85, 56, 1);
      case 'petugas':
        return const Color.fromRGBO(37, 99, 235, 1);
      case 'peminjam':
        return const Color.fromRGBO(235, 98, 26, 1);
      default:
        return const Color(0xFFEF6C00);
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
        role,
        style: TextStyle(
          fontFamily: roboto,
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
