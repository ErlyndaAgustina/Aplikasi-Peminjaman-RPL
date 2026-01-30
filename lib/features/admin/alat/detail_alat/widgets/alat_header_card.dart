import 'package:flutter/material.dart';
import '../../models/models.dart';

const String roboto = 'Roboto';

class AlatHeaderCard extends StatelessWidget {
  final AlatModel? alat;
  final int count; // Tambahkan parameter ini

  const AlatHeaderCard({super.key, this.alat, this.count = 0}); // Default 0

  @override
  Widget build(BuildContext context) {
    final String namaAlat = alat?.nama ?? 'Memuat...';
    final String kodeAlat = alat?.kode ?? '-';
    final String kategori = alat?.kategoriNama ?? 'Kategori';
    // Gunakan parameter count, bukan alat?.jumlah
    final String totalUnit = count.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaAlat,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color.fromRGBO(49, 47, 52, 1),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Kode: $kodeAlat',
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 14,
                        color: Color.fromRGBO(72, 141, 117, 1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: Color.fromRGBO(1, 85, 56, 1),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$totalUnit Unit',
                    style: const TextStyle(
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
                child: Text(
                  kategori,
                  style: const TextStyle(
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
