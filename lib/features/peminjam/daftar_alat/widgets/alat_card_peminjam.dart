import 'package:flutter/material.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class AlatCardPeminjam extends StatelessWidget {
  final AlatModel alat;
  const AlatCardPeminjam({super.key, required this.alat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Nama, Kode, dan Jumlah Unit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alat.nama,
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Color.fromRGBO(49, 47, 52, 1),
                    ),
                  ),
                  Text(
                    'Kode: ${alat.kode}',
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 14,
                      color: Color.fromRGBO(72, 141, 117, 1),
                    ),
                  ),
                ],
              ),
              // Bagian Unit dengan Ikon Bin (Sesuai Gambar)
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: Color.fromRGBO(1, 85, 56, 1),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${alat.jumlah} Unit',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: roboto,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(1, 85, 56, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Baris Bawah: Kategori dan Tombol Pinjam
          Row(
            children: [
              /// ===== KATEGORI =====
              Expanded(
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 253, 240, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    alat.kategori,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: roboto,
                      color: Color.fromRGBO(1, 85, 56, 1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// ===== TOMBOL PINJAM =====
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Pinjam',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: roboto,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
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
