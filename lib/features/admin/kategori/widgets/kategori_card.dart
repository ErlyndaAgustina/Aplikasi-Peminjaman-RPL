import 'package:flutter/material.dart';
import '../widgets/models.dart';

const String roboto = 'Roboto';

class KategoriCard extends StatefulWidget {
  final KategoriModel kategori;

  const KategoriCard({super.key, required this.kategori});

  @override
  State<KategoriCard> createState() => _KategoriCardState();
}

class _KategoriCardState extends State<KategoriCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.kategori.nama,
            style: const TextStyle(
              fontFamily: roboto,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Color.fromRGBO(49, 47, 52, 1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.kategori.deskripsi,
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 14,
              color: Color.fromRGBO(72, 141, 117, 1),
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 17,
                color: Color.fromRGBO(20, 72, 54, 1),
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.kategori.totalAlat} Alat Tersedia',
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 12,
                  color: Color.fromRGBO(20, 72, 54, 1),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(72, 141, 117, 1),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Color.fromRGBO(1, 85, 56, 1),
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color.fromRGBO(1, 85, 56, 1),
                      fontFamily: roboto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(255, 2, 2, 1),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete,
                    size: 16,
                    color: Color.fromRGBO(255, 2, 2, 1),
                  ),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 2, 2, 1),
                      fontFamily: roboto,
                      fontWeight: FontWeight.bold,
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
