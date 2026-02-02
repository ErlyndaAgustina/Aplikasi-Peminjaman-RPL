import 'package:flutter/material.dart';
import '../detail_alat/detail_alat_page.dart';
import '../models/models.dart';
import 'delete_alat_dialog.dart';
import 'form_alat_dialog.dart';

const String roboto = 'Roboto';

class AlatCard extends StatelessWidget {
  final AlatModel alat;
  final VoidCallback onRefresh;

  const AlatCard({super.key, required this.alat, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final String totalUnit = alat.jumlah.toString(); 

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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 253, 240, 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 16,
                      color: Color.fromRGBO(1, 85, 56, 1),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$totalUnit Unit',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: roboto,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(1, 85, 56, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 253, 240, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  alat.kategoriNama,
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
                  _iconBtn(
                    Icons.visibility,
                    const Color.fromRGBO(236, 254, 248, 1),
                    iconColor: const Color.fromRGBO(62, 159, 127, 1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailAlatPage(
                            id: alat.id,
                            alat: alat,
                          ),
                        ),
                      ).then((_) => onRefresh());
                    },
                  ),
                  const SizedBox(width: 8),
                  _iconBtn(
                    Icons.edit,
                    const Color.fromRGBO(236, 254, 248, 1),
                    iconColor: const Color.fromRGBO(62, 159, 127, 1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => FormAlatDialog(
                          isEdit: true,
                          alat: alat,
                          onRefresh: onRefresh,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
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
                          onDeleteSuccess: onRefresh,
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

  Widget _iconBtn(
    IconData icon,
    Color bg, {
    Color iconColor = Colors.black,
    VoidCallback? onTap,
  }) {
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
