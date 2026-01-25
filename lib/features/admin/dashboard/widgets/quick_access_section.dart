import 'package:flutter/material.dart';
import 'quick_access_item.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(
            fontFamily: roboto,
            color: Color.fromRGBO(49, 47, 52, 1),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Akses cepat ke modul CRUD',
          style: TextStyle(
            fontFamily: roboto,
            fontSize: 13,
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                const items = [
                  QuickAccessItem(
                    'Kelola Pengguna',
                    Icons.people,
                    Color.fromRGBO(99, 36, 235, 1),
                  ),
                  QuickAccessItem(
                    'Kelola Alat',
                    Icons.inventory,
                    Color.fromRGBO(0, 169, 112, 1),
                  ),
                  QuickAccessItem(
                    'Kelola Kategori',
                    Icons.category,
                    Color.fromRGBO(43, 127, 255, 1),
                  ),
                  QuickAccessItem(
                    'Kelola Peminjaman',
                    Icons.assignment,
                    Color.fromRGBO(254, 154, 0, 1),
                  ),
                  QuickAccessItem(
                    'Kelola Pengembalian',
                    Icons.assignment_return,
                    Color.fromRGBO(173, 70, 255, 1),
                  ),
                  QuickAccessItem(
                    'Log Aktivitas',
                    Icons.show_chart,
                    Color.fromRGBO(246, 51, 154, 1),
                  ),
                ];

                return items[index];
              },
            );
          },
        ),
      ],
    );
  }
}
