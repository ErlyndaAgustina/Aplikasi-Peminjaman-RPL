import 'package:flutter/material.dart';
import '../../alat/manajemen_alat_page.dart';
import '../../kategori/manajemen_kategori_page.dart';
import '../../log_aktivitas/log_aktivitas_page.dart';
import '../../peminjaman/manajemen_peminjaman_page.dart';
import '../../pengembalian/pengembalian_page.dart';
import '../../users/manajemen_pengguna_page.dart';
import 'quick_access_item.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  // Pindahkan definisi font ke level class agar bisa diakses di mana saja
  static const String roboto = 'Roboto';

  @override
  Widget build(BuildContext context) {
    // Definisi data item di dalam build agar Navigator context bisa digunakan
    final List<QuickAccessItem> items = [
      QuickAccessItem(
        title: 'Kelola Pengguna',
        icon: Icons.people,
        color: const Color.fromRGBO(99, 36, 235, 1),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManajemenPenggunaPage()));
        },
      ),
      QuickAccessItem(
        title: 'Kelola Alat',
        icon: Icons.inventory,
        color:  Color.fromRGBO(0, 169, 112, 1),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManajemenAlatPage()));
        },
      ),
      QuickAccessItem(
        title: 'Kelola Kategori',
        icon: Icons.category,
        color:  Color.fromRGBO(43, 127, 255, 1),
        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ManajemenKategoriPage()));},
      ),
      QuickAccessItem(
        title: 'Kelola Peminjaman',
        icon: Icons.assignment,
        color:  Color.fromRGBO(254, 154, 0, 1),
        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ManajemenPeminjamanPage()));},
      ),
      QuickAccessItem(
        title: 'Kelola Pengembalian',
        icon: Icons.assignment_return,
        color: const Color.fromRGBO(173, 70, 255, 1),
        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const PengembalianPage()));},
      ),
      QuickAccessItem(
        title: 'Log Aktivitas',
        icon: Icons.show_chart,
        color:  Color.fromRGBO(246, 51, 154, 1),
        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const LogAktivitasPage()));},
      ),
    ];

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
          'Akses cepat ke manajemen pengelolaan',
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
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                return items[index];
              },
            );
          },
        ),
      ],
    );
  }
}
