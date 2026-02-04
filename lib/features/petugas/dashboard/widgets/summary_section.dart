import 'package:flutter/material.dart';
import 'summary_card.dart';

class SummarySection extends StatelessWidget {
  final Map<String, int> counts;
  final String userName;

  const SummarySection({
    super.key, 
    required this.counts, 
    this.userName = 'Petugas'
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, $userName',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(49, 47, 52, 1),
          ),
        ),
        const Text(
          'Berikut adalah ringkasan RPLKIT hari ini.',
          style: TextStyle(fontSize: 13, color: Color.fromRGBO(72, 141, 117, 1)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Peminjaman Aktif',
                value: counts['aktif'].toString(),
                icon: Icons.assignment,
                color: const Color.fromRGBO(28, 106, 255, 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Total Unit Alat',
                value: counts['total_alat'].toString(),
                icon: Icons.inventory_2,
                color: const Color.fromRGBO(0, 169, 112, 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Pengembalian',
                value: counts['dikembalikan'].toString(),
                icon: Icons.autorenew,
                color: const Color.fromRGBO(239, 133, 0, 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Ditolak',
                value: counts['ditolak'].toString(),
                icon: Icons.cancel,
                color: const Color.fromRGBO(255, 2, 2, 1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}