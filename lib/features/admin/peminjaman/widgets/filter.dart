import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class KategoriFilter extends StatefulWidget {
  const KategoriFilter({super.key});

  @override
  State<KategoriFilter> createState() => _KategoriFilterState();
}

class _KategoriFilterState extends State<KategoriFilter> {
  String selectedKategori = 'Semua Status';

  final List<String> kategoriList = [
    'Semua Status',
    'Dipinjam',
    'Terlambat'
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          selectedKategori = value;
        });
      },
      offset: const Offset(0, 50),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: Color.fromRGBO(205, 238, 226, 1),
        ),
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
          border: Border.all(
            color: const Color.fromRGBO(205, 238, 226, 1),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.filter_alt_outlined,
              size: 18,
              color: Color.fromRGBO(62, 159, 127, 1),
            ),
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
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromRGBO(62, 159, 127, 1),
            ),
          ],
        ),
      ),
    );
  }
}
