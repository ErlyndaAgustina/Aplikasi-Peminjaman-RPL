import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class AlatHeaderCard extends StatelessWidget {
  const AlatHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color.fromRGBO(205, 238, 226, 1),
        ),
      ),
      child: Column(
        children: [
          /// BARIS ATAS (NAMA + UNIT)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Macbook Pro',
                      style: TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color.fromRGBO(49, 47, 52, 1),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Kode: LPT-001',
                      style: TextStyle(
                        fontFamily: roboto,
                        fontSize: 14,
                        color: Color.fromRGBO(72, 141, 117, 1),
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
              ),

              /// RIGHT
              Row(
                children: const [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: Color.fromRGBO(1, 85, 56, 1),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '12 Unit',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: roboto,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(1, 85, 56, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// BARIS BAWAH (KATEGORI SAJA)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 253, 240, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Perangkat Komputasi',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: roboto,
                    color: Color.fromRGBO(1, 85, 56, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
