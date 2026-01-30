import 'package:aplikasi_peminjaman_rpl/features/admin/alat/models/models.dart';
import 'package:flutter/material.dart';
import '../../../profile/profile_page.dart';
import '../detail_alat/widgets/alat_header_card.dart';
import '../services/service.dart';
import 'models/model.dart';
import '../detail_alat/widgets/unit_alat_card.dart';
import 'widgets/form_unit_dialog.dart';

const String roboto = 'Roboto';

class DetailAlatPage extends StatefulWidget {
  final String id;
  final AlatModel? alat;
  const DetailAlatPage({super.key, required this.id, this.alat});

  @override
  State<DetailAlatPage> createState() => _DetailAlatPageState();
}

class _DetailAlatPageState extends State<DetailAlatPage> {
  String searchQuery = '';
  List<UnitAlatModel> unitAlatList = [];
  AlatModel? currentAlat;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentAlat = widget.alat;
    _refreshSemuaData();
  }

  Future<void> _refreshSemuaData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final results = await Future.wait([
        AlatService().fetchUnitAlat(widget.id),
        AlatService().fetchAlatById(widget.id),
      ]);

      if (mounted) {
        setState(() {
          unitAlatList = results[0] as List<UnitAlatModel>;
          currentAlat = results[1] as AlatModel?;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
      }
    }
  }

  List<UnitAlatModel> get filteredUnitAlat {
    if (searchQuery.isEmpty) return unitAlatList;
    return unitAlatList.where((unit) {
      final String query = searchQuery.toLowerCase();
      return unit.kodeUnit.toLowerCase().contains(query) ||
          unit.kondisi.toLowerCase().contains(query) ||
          unit.status.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(216, 199, 246, 1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 253, 240, 0.49),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(62, 159, 127, 1),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Unit Alat',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(49, 47, 52, 1),
                        ),
                      ),
                      Text(
                        'RPLKIT • SMK Brantas Karangkates',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontSize: 12,
                          color: Color.fromRGBO(72, 141, 117, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePenggunaPage(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color.fromRGBO(217, 253, 240, 0.49),
                    child: Icon(
                      Icons.person,
                      color: Color.fromRGBO(62, 159, 127, 1),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSemuaData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AlatHeaderCard(
                alat: currentAlat,
                count: unitAlatList.length,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => FormUnitDialog(
                      isEdit: false,
                      idAlat: widget.id,
                      onRefresh: _refreshSemuaData,
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 22),
                label: const Text(
                  'Tambah Unit',
                  style: TextStyle(
                    fontFamily: roboto,
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Text(
                    'Daftar Unit Alat',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFamily: roboto,
                      color: Color.fromRGBO(49, 47, 52, 1),
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(62, 159, 127, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '${filteredUnitAlat.length} Unit',
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari kode unit atau kondisi...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromRGBO(72, 141, 117, 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(205, 238, 226, 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredUnitAlat.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Unit tidak ditemukan...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredUnitAlat.length,
                      itemBuilder: (context, index) {
                        return UnitAlatCard(
                          unit: filteredUnitAlat[index],
                          onRefresh: _refreshSemuaData,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
