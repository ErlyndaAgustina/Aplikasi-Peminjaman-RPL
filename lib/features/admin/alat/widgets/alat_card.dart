import 'package:flutter/material.dart';
import '../detail_alat/detail_alat_page.dart';
import '../models/models.dart';
import 'delete_alat_dialog.dart';
import 'form_alat_dialog.dart';


const String roboto = 'Roboto';

class AlatCard extends StatelessWidget {
  final AlatModel alat;
  final VoidCallback onRefresh;

  // Pastikan HANYA ada dua parameter ini:
  const AlatCard({
    super.key, 
    required this.alat, 
    required this.onRefresh,
  });

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
        children: [
          /// BARIS ATAS (NAMA + UNIT)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
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
                    const SizedBox(height: 2),
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
                    '${alat.jumlah} Unit',
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

          /// BARIS BAWAH (KATEGORI + ACTION)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 253, 240, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  alat.kategoriNama, // Pakai kategoriNama dari model
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: roboto,
                    color: Color.fromRGBO(1, 85, 56, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  // Tombol Detail
                  _iconBtn(
                    Icons.visibility,
                    const Color.fromRGBO(236, 254, 248, 1),
                    iconColor: const Color.fromRGBO(93, 93, 93, 1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailAlatPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  // Tombol Edit
                  _iconBtn(
                    Icons.edit,
                    const Color.fromRGBO(236, 254, 248, 1),
                    iconColor: const Color.fromRGBO(93, 93, 93, 1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => FormAlatDialog(
                          isEdit: true, 
                          alat: alat,
                          onRefresh: onRefresh, // Kirim callback
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  // Tombol Delete
                  _iconBtn(
                    Icons.delete,
                    const Color.fromRGBO(255, 119, 119, 0.22),
                    iconColor: const Color.fromRGBO(255, 2, 2, 1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteAlatDialog(
                          id: alat.id,
                          nama: alat.nama,
                          onDeleteSuccess: onRefresh, // Kirim callback
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color bg, {Color iconColor = Colors.black, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}