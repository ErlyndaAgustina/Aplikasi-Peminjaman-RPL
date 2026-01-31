import 'package:flutter/material.dart';

const String roboto = 'Roboto';

// Buat class kecil supaya tipe datanya jelas, bukan Map lagi
class FilterItem {
  final String label;
  final String value;
  FilterItem(this.label, this.value);
}

class KategoriFilter extends StatefulWidget {
  final Function(String) onStatusChanged;
  const KategoriFilter({super.key, required this.onStatusChanged});

  @override
  State<KategoriFilter> createState() => _KategoriFilterState();
}

class _KategoriFilterState extends State<KategoriFilter> {
  // Secara default pilih item pertama (Semua Status)
  late FilterItem selectedItem;

  final List<FilterItem> kategoriList = [
    FilterItem('Semua Status', 'Semua Status'),
    FilterItem('Dipinjam', 'dipinjam'),
    FilterItem('Terlambat', 'terlambat'),
  ];

  @override
  void initState() {
    super.initState();
    selectedItem = kategoriList[0];
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FilterItem>( // Sekarang tipenya FilterItem
      onSelected: (FilterItem item) {
        setState(() {
          selectedItem = item;
        });
        widget.onStatusChanged(item.value); // Kirim value kecil
      },
      offset: const Offset(0, 45),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      itemBuilder: (context) {
        return kategoriList.map((FilterItem item) {
          return PopupMenuItem<FilterItem>(
            value: item,
            height: 40,
            child: Text(
              item.label,
              style: const TextStyle(
                fontFamily: roboto,
                fontSize: 13,
                color: Color.fromRGBO(72, 141, 117, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
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
              selectedItem.label, // Tampilkan Label (Kapital)
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