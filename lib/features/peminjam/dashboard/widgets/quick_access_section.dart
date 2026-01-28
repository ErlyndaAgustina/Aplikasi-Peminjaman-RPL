import 'package:flutter/material.dart';

import '../../ajukan_pengembalian/ajukan_pengembalian_page.dart';
import '../../ajukan_pinjaman/ajukan_peminjaman_page.dart';
import '../../daftar_alat/daftar_alat_peminjam_page.dart';

const String roboto = 'Roboto';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Access",
          style: TextStyle(
            fontFamily: roboto,
            color: Color.fromRGBO(49, 47, 52, 1),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _Button(
          label: "Daftar Alat",
          icon: Icons.inventory_2,
          isSolid: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DaftarAlatPeminjamPage(),
              ),
            );
          },
        ),
        _Button(
          label: "Ajukan Peminjaman",
          icon: Icons.assignment_add,
          isSolid: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AjukanPeminjamanPage(),
              ),
            );
          },
        ),
        _Button(
          label: "Ajukan Pengembalian",
          icon: Icons.assignment_return,
          isSolid: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AjukanPengembalianPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSolid;
  final VoidCallback onTap;

  const _Button({
    required this.label,
    required this.icon,
    required this.isSolid,
    required this.onTap,
  });

  static const Color _green = Color.fromRGBO(62, 159, 127, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSolid ? _green : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _green),
        boxShadow: isSolid
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSolid ? Colors.white : _green),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: roboto,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSolid ? Colors.white : _green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
