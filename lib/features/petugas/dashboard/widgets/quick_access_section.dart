import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Quick Access",
          style: TextStyle(
            fontFamily: roboto,
            color: Color.fromRGBO(49, 47, 52, 1),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),
        _QuickAccessButton(
          icon: Icons.swap_horiz,
          label: "Peminjaman",
          solid: true,
        ),
        _QuickAccessButton(
          icon: Icons.assignment_return_outlined,
          label: "Pengembalian",
          solid: false,
        ),
        _QuickAccessButton(
          icon: Icons.receipt_long,
          label: "Laporan",
          solid: true,
        ),
      ],
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool solid;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.solid,
  });

  static const Color _green = Color.fromRGBO(62, 159, 127, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: solid ? _green : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _green),
        boxShadow: solid
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
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: solid ? Colors.white : _green,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: roboto,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: solid ? Colors.white : _green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
