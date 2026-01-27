import 'package:flutter/material.dart';
import '../models/model.dart';

class UnitDipinjamCard extends StatelessWidget {
  final UnitDipinjam unit;
  const UnitDipinjamCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    const String roboto = 'Roboto';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Radius lebih besar sesuai gambar
        border: Border.all(
          color: const Color.fromRGBO(205, 238, 226, 1), // Warna border hijau sangat muda
          width: 1,
        ),
      ),
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
          const SizedBox(height: 2),
          Text(
            'Unit: ${unit.kode}',
            style: const TextStyle(
              fontFamily: roboto,
              color: Color.fromRGBO(72, 141, 117, 1), // Warna teks kode unit
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}