import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class KategoriFilter extends StatelessWidget {
  // Gunakan Function(String) agar jelas menerima data teks
  final String selectedKategori;
  final Function(String) onKategoriChanged;

  const KategoriFilter({
    super.key,
    required this.selectedKategori,
    required this.onKategoriChanged,
  });

  final List<String> kategoriList = const [
    'Semua Status',
    'Perangkat Jaringan',
    'Perangkat Komputasi',
    'Perangkat mobile & IoT'
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => onKategoriChanged(value),
      offset: const Offset(0, 50),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      itemBuilder: (context) {
        return kategoriList.map((kategori) {
          return PopupMenuItem<String>(
            value: kategori,
            height: 30,
            child: Text(
              kategori,
              style: const TextStyle(
                fontFamily: roboto,
                fontSize: 12,
                color: Color.fromRGBO(72, 141, 117, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.filter_alt_outlined, size: 18, color: Color.fromRGBO(62, 159, 127, 1)),
            const SizedBox(width: 8),
            Text(
              selectedKategori,
              style: const TextStyle(
                fontFamily: roboto,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(62, 159, 127, 1),
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(62, 159, 127, 1)),
          ],
        ),
      ),
    );
  }
}