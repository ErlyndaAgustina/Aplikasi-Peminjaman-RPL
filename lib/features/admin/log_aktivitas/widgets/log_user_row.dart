import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class LogUserRow extends StatelessWidget {
  final String nama;
  final String role;
  final String tanggal;

  const LogUserRow({
    super.key,
    required this.nama,
    required this.role,
    required this.tanggal,
  });

  Color _bgRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color.fromRGBO(217, 253, 240, 1);
      case 'petugas':
        return const Color.fromRGBO(219, 234, 254, 1);
      case 'peminjam':
        return const Color.fromRGBO(255, 237, 213, 1);
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  Color _textRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color.fromRGBO(1, 85, 56, 1);
      case 'petugas':
        return const Color.fromRGBO(37, 99, 235, 1);
      case 'peminjam':
        return const Color.fromRGBO(235, 98, 26, 1);
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// BARIS ATAS (NAMA + ROLE)
        Row(
          children: [
            const Icon(
              Icons.person,
              size: 15,
              color: Color.fromRGBO(75, 85, 99, 1),
            ),
            const SizedBox(width: 8),
            Text(
              nama,
              style: const TextStyle(
                fontFamily: roboto,
                fontSize: 12,
                color: Color.fromRGBO(75, 85, 99, 1),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _bgRole(role),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _textRole(role),
                  fontFamily: roboto,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// BARIS BAWAH (TANGGAL)
        Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 15,
              color: Color.fromRGBO(75, 85, 99, 1),
            ),
            const SizedBox(width: 4),
            Text(
              tanggal,
              style: const TextStyle(
                fontFamily: roboto,
                fontSize: 12,
                color: Color.fromRGBO(75, 85, 99, 1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
