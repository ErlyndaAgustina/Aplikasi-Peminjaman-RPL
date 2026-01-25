import 'package:flutter/material.dart';
import 'summary_card.dart';

const String roboto = 'Roboto';

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
          'Berikut adalah ringkasan RPLKIT hari ini.',
          style: TextStyle(
            fontFamily: roboto,
            fontSize: 13,
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
        ),
        const SizedBox(height: 16),

        /// BARIS 1
        Row(
          children: const [
            Expanded(
              child: SummaryCard(
                title: 'Peminjaman Aktif',
                value: '23',
                icon: Icons.assignment,
                color: Color.fromRGBO(28, 106, 255, 1),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Total Alat',
                value: '156',
                icon: Icons.inventory_2,
                color: Color.fromRGBO(0, 169, 112, 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        /// BARIS 2
        Row(
          children: const [
            Expanded(
              child: SummaryCard(
                title: 'Pengembalian',
                value: '8',
                icon: Icons.autorenew,
                color: Color.fromRGBO(239, 133, 0, 1),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Terlambat',
                value: '2',
                icon: Icons.block,
                color: Color.fromRGBO(255, 2, 2, 1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
