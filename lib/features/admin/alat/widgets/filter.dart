import 'package:flutter/material.dart';
import '../services/service.dart';
import '../models/models.dart';

const String roboto = 'Roboto';

class KategoriFilter extends StatefulWidget {
  final Function(String) onChanged;
  const KategoriFilter({super.key, required this.onChanged});

  @override
  State<KategoriFilter> createState() => _KategoriFilterState();
}

class _KategoriFilterState extends State<KategoriFilter> {
  String selectedKategori = 'Semua Status';
  List<KategoriModel> listKategoriDB = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKategori();
  }

  Future<void> _loadKategori() async {
    try {
      final data = await AlatService()
          .getKategori();
      setState(() {
        listKategoriDB = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error load kategori: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> displayList = ['Semua Status'];
    displayList.addAll(listKategoriDB.map((k) => k.nama).toList());

    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() => selectedKategori = value);
        widget.onChanged(value);
      },
      offset: const Offset(0, 50),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      itemBuilder: (context) {
        if (isLoading) {
          return [
            const PopupMenuItem(enabled: false, child: Text('Loading...')),
          ];
        }
        return displayList.map((kategori) {
          return PopupMenuItem<String>(
            value: kategori,
            height: 40,
            child: Text(
              kategori,
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.filter_alt_outlined,
                  size: 18,
                  color: Color.fromRGBO(62, 159, 127, 1),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Text(
                    selectedKategori,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(62, 159, 127, 1),
                    ),
                  ),
                ),
              ],
            ),
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
