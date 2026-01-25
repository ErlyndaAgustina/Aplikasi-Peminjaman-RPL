import 'package:flutter/material.dart';
import '../models/model.dart';

class StatusBadge extends StatelessWidget {
  final StatusTransaksi status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color text;
    late String label;

    switch (status) {
      case StatusTransaksi.dipinjam:
        bg = const Color.fromRGBO(230, 239, 255, 1);
        text = const Color.fromRGBO(59, 130, 246, 1);
        label = 'Dipinjam';
        break;
      case StatusTransaksi.selesai:
        bg = const Color.fromRGBO(220, 252, 231, 1);
        text = const Color.fromRGBO(22, 163, 74, 1);
        label = 'Selesai';
        break;
      case StatusTransaksi.terlambat:
        bg = const Color.fromRGBO(254, 226, 226, 1);
        text = const Color.fromRGBO(220, 38, 38, 1);
        label = 'Terlambat';
        break;
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
