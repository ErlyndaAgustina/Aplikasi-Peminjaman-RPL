import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 253, 240, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Selesai',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color.fromRGBO(1, 85, 56, 1),
        ),
      ),
    );
  }
}
