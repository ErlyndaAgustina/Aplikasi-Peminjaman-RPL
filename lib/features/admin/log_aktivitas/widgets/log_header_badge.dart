import 'package:flutter/material.dart';

class LogHeaderBadge extends StatelessWidget {
  final String aksi;
  final String kategori;

  const LogHeaderBadge({
    super.key,
    required this.aksi,
    required this.kategori,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _badge(aksi, Color.fromRGBO(217, 253, 240, 1), Color.fromRGBO(1, 85, 56, 1)),
        const Spacer(),
        _badge(kategori, Color.fromRGBO(219, 234, 254, 1), Color.fromRGBO(75, 85, 99, 1)),
      ],
    );
  }

  Widget _badge(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
