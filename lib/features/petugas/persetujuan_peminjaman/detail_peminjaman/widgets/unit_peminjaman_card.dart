import 'package:flutter/material.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class UnitPeminjamanCard extends StatelessWidget {
  final UnitPinjamanModel unit;

  const UnitPeminjamanCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 🔑 kunci utamanya
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.nama,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color.fromRGBO(49, 47, 52, 1),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 253, 240, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    unit.kategori,
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 12,
                      color: Color.fromRGBO(1, 85, 56, 1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Kode: ${unit.kode}',
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 12,
              color: Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
