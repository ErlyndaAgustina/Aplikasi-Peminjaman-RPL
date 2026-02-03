import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../profile/profile_page.dart';
import '../detail_peminjaman/widgets/peminjaman_card.dart';
import 'models/models.dart';
import '../detail_peminjaman/widgets/unit_dipinjam_card.dart';
import 'widgets/tambah_unit.dart';

const String roboto = 'Roboto';

class DetailPeminjamanPage extends StatefulWidget {
  final String peminjamanId; // Tambahkan ini

  const DetailPeminjamanPage({super.key, required this.peminjamanId});

  @override
  State<DetailPeminjamanPage> createState() => _DetailPeminjamanPageState();
}

class _DetailPeminjamanPageState extends State<DetailPeminjamanPage> {
  final supabase = Supabase.instance.client;
  DetailPeminjamanModel? detailData;
  List<UnitDipinjamModel> listUnit = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetailPeminjaman();
  }

  Future<void> fetchDetailPeminjaman() async {
    try {
      final response = await supabase
          .from('peminjaman')
          .select('''
          *,
          users (nama),
          detail_peminjaman (
            id_detail,
            alat_unit (
              id_unit,
              kode_unit,
              kondisi,
              alat (
                nama_alat,
                kategori (nama_kategori)
              )
            )
          )
        ''')
          .eq(
            'id_peminjaman',
            widget.peminjamanId,
          ) // Pakai ID yang dikirim tadi
          .single();

      setState(() {
        detailData = DetailPeminjamanModel.fromJson(response);
        final listRaw = response['detail_peminjaman'] as List;
        listUnit = listRaw.map((e) => UnitDipinjamModel.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error detail: $e");
      setState(() => isLoading = false);
    }
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
            bottom: false,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Detail Peminjaman',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(49, 47, 52, 1),
                        ),
                      ),
                      SizedBox(height: 2),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailData == null
          ? const Center(child: Text("Data tidak ditemukan"))
          : RefreshIndicator(
              onRefresh: fetchDetailPeminjaman,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    PeminjamanCard(data: detailData!),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final bool? refresh = await showDialog<bool>(
                          context: context,
                          barrierColor: Colors.black54,
                          builder: (context) => TambahUnitModal(
                            idPeminjaman:
                                widget.peminjamanId,
                          ),
                        );

                        if (refresh == true) {
                          fetchDetailPeminjaman();
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Tambah Unit',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        const Text(
                          'Daftar Unit yang Dipinjam',
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
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(62, 159, 127, 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${listUnit.length} Unit',
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: listUnit.length,
                        itemBuilder: (context, index) {
                          return UnitDipinjamCard(
                            unit: listUnit[index],
                            onDelete: () {
                              fetchDetailPeminjaman();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
