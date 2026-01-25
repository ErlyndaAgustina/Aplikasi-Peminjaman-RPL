import 'package:flutter/material.dart';

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
          style: TextStyle(fontFamily: roboto,
            color: Color.fromRGBO(49, 47, 52, 1),
            fontSize: 18,
            fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _Button(label: "Daftar Alat", icon: Icons.inventory_2, isSolid: true),
        _Button(
          label: "Ajukan Peminjaman",
          icon: Icons.assignment_add,
          isSolid: false,
        ),
        _Button(
          label: "Ajukan Pengembalian",
          icon: Icons.assignment_return,
          isSolid: true,
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSolid;

  const _Button({
    required this.label,
    required this.icon,
    required this.isSolid,
  });

  static const Color _green = Color.fromRGBO(62, 159, 127, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(
          icon,
          size: 18,
          color: isSolid ? Colors.white : _green,
        ),
        label: Text(
          label,
          style: TextStyle(
                  fontFamily: roboto,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSolid ? Colors.white : _green,
                ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSolid ? _green : Colors.white,
          elevation: isSolid ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: _green),
          ),
        ),
      ),
    );
  }
}
