import 'package:flutter/material.dart';
import 'models.dart';

const String roboto = 'Roboto';

class UnitDipinjamCard extends StatelessWidget {
  final UnitDipinjamModel unit;

  const UnitDipinjamCard({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color.fromRGBO(205, 238, 226, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            children: [
              Expanded(
                child: Text(
                  'Unit ${unit.kodeUnit}',
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromRGBO(49, 47, 52, 1),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 237, 213, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Kondisi: ${unit.kondisi}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(235, 98, 26, 1),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),
          Text(
            'Unit: ${unit.kodeUnit}',
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(72, 141, 117, 1),
            ),
          ),

          const SizedBox(height: 16),

          // ===== ACTION BUTTON =====
          Row(
            children: [
              /// LEFT
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 253, 240, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unit.kategori,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: roboto,
                    color: Color.fromRGBO(1, 85, 56, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              /// RIGHT
              Row(
                children: [
                  _iconBtn(
                    Icons.delete,
                    const Color.fromRGBO(255, 119, 119, 0.22),
                    iconColor: const Color.fromRGBO(255, 2, 2, 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _iconBtn(IconData icon, Color bg, {Color iconColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }
}
