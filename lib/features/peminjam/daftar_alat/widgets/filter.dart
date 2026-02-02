import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String roboto = 'Roboto';

class KategoriFilter extends StatefulWidget {
  final String selectedKategori;
  final Function(String) onKategoriChanged;

  const KategoriFilter({
    super.key,
    required this.selectedKategori,
    required this.onKategoriChanged,
  });

  @override
  State<KategoriFilter> createState() => _KategoriFilterState();
}

class _KategoriFilterState extends State<KategoriFilter> {
  List<String> _categories = ['Semua Status'];
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  Future<void> _fetchKategori() async {
    try {
      final response = await supabase
          .from('kategori')
          .select('nama_kategori')
          .order('nama_kategori', ascending: true);

      final List data = response as List;
      
      if (mounted) {
        setState(() {
          _categories = ['Semua Status', ...data.map((item) => item['nama_kategori'].toString())];
        });
      }
    } catch (e) {
      debugPrint("Gagal ambil kategori: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => widget.onKategoriChanged(value),
      offset: const Offset(0, 50),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      itemBuilder: (context) {
        return _categories.map((kategori) {
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.filter_alt_outlined, 
                size: 18, color: Color.fromRGBO(62, 159, 127, 1)),
            const SizedBox(width: 8),
            Text(
              widget.selectedKategori,
              style: const TextStyle(
                fontFamily: roboto,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(62, 159, 127, 1),
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, 
                color: Color.fromRGBO(62, 159, 127, 1)),
          ],
        ),
      ),
    );
  }
}