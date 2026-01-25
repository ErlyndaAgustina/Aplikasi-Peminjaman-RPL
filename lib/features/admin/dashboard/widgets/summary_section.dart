import 'package:flutter/material.dart';
import 'summary_card.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Halo, Erlynda',
          style: TextStyle(
            fontFamily: roboto,
            color: Color.fromRGBO(49, 47, 52, 1),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Berikut adalah ringkasan RPLKIT bulan ini.',
          style: TextStyle(
            fontFamily: roboto,
            fontSize: 13,
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: const [
            SummaryCard(
              title: 'Total Pengguna',
              value: '48',
              icon: Icons.people,
              color: Color.fromRGBO(99, 36, 235, 1), // hijau
            ),
            SummaryCard(
              title: 'Total Alat',
              value: '156',
              icon: Icons.inventory_2,
              color: Color.fromRGBO(0, 169, 112, 1), // biru
            ),
            SummaryCard(
              title: 'Peminjaman Aktif',
              value: '23',
              icon: Icons.assignment,
              color: Color.fromRGBO(28, 106, 255, 1), // kuning
            ),
            SummaryCard(
              title: 'Pengembalian Hari Ini',
              value: '8',
              icon: Icons.assignment_return,
              color: Color.fromRGBO(239, 133, 0, 1), // merah
            ),
          ],
        ),
      ],
    );
  }
}
