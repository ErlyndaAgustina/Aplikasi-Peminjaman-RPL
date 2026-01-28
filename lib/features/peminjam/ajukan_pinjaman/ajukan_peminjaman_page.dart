import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../profile/profile_page.dart';
import '../daftar_alat/models/model.dart';
import 'models/model.dart';
import 'widgets/form_widgets.dart';
import 'widgets/info_alat_card.dart';
import 'widgets/form_peminjaman_card.dart';

class AjukanPeminjamanPage extends StatefulWidget {
  const AjukanPeminjamanPage({super.key});

  @override
  State<AjukanPeminjamanPage> createState() => _AjukanPeminjamanPageState();
}

class _AjukanPeminjamanPageState extends State<AjukanPeminjamanPage> {
  static const String roboto = 'Roboto';

  final TextEditingController _tanggalPinjamController =
      TextEditingController();
  final TextEditingController _batasKembaliController = TextEditingController();
  final TextEditingController _batasKembaliOtomatisController =
      TextEditingController();

  DateTime? _tanggalPinjam;
  DateTime? _batasKembali;
  String? _jamPelajaranAwal;
  String? _jamPelajaranAkhir;

  final List<String> _jamPelajaranList = [
    'Jam Pelajaran 1',
    'Jam Pelajaran 2',
    'Jam Pelajaran 3',
    'Jam Pelajaran 4',
    'Jam Pelajaran 5',
    'Jam Pelajaran 6',
    'Jam Pelajaran 7',
    'Jam Pelajaran 8',
    'Jam Pelajaran 9',
    'Jam Pelajaran 10',
  ];

  @override
  void dispose() {
    _tanggalPinjamController.dispose();
    _batasKembaliController.dispose();
    _batasKembaliOtomatisController.dispose();
    super.dispose();
  }

  void _hitungBatasKembaliOtomatis() {
    if (_batasKembali != null && _jamPelajaranAkhir != null) {
      String tanggal = DateFormat('dd MMMM yyyy').format(_batasKembali!);
      setState(() {
        _batasKembaliOtomatisController.text = '$tanggal - $_jamPelajaranAkhir';
      });
    } else {
      setState(() {
        _batasKembaliOtomatisController.text = '-';
      });
    }
  }

  Future<void> _pilihTanggal(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(62, 159, 127, 1),
              onPrimary: Colors.white,
              onSurface: Color.fromRGBO(49, 47, 52, 1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formatted = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
          _tanggalPinjamController.text = formatted;
        } else {
          _batasKembali = picked;
          _batasKembaliController.text = formatted;
          _hitungBatasKembaliOtomatis();
        }
      });
    }
  }

  void _pilihJamPelajaran(bool isAwal) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isAwal ? 'Pilih Jam Pelajaran' : 'Pilih Sampai Jam Pelajaran',
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _jamPelajaranList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _jamPelajaranList[index],
                    style: const TextStyle(fontFamily: roboto, fontSize: 14),
                  ),
                  onTap: () => Navigator.pop(context, _jamPelajaranList[index]),
                );
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        if (isAwal) {
          _jamPelajaranAwal = selected;
        } else {
          _jamPelajaranAkhir = selected;
          _hitungBatasKembaliOtomatis();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Alat',
              style: TextStyle(
                color: Color.fromRGBO(49, 47, 52, 1),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            InfoAlatCard(
              onRemove: (alat) => setState(() {
                keranjangAlat.remove(alat);
                if (keranjangAlat.isEmpty) Navigator.pop(context);
              }),
            ),
            const SizedBox(height: 24),
            const Text(
              'Form Peminjaman',
              style: TextStyle(
                color: Color.fromRGBO(49, 47, 52, 1),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            FormPeminjamanCard(
              tanggalPinjamController: _tanggalPinjamController,
              batasKembaliController: _batasKembaliController,
              batasKembaliOtomatisController: _batasKembaliOtomatisController,
              jamPelajaranAwal: _jamPelajaranAwal,
              jamPelajaranAkhir: _jamPelajaranAkhir,
              onPilihTanggal: (isPinjam) => _pilihTanggal(context, isPinjam),
              onPilihJam: (isAwal) => _pilihJamPelajaran(isAwal),
            ),
            const SizedBox(height: 15),
            _buildWarningBanner(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
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
                      'Ajukan Peminjaman',
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
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 237, 213, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Permintaan peminjaman akan akan diproses oleh petugas.',
        style: TextStyle(
          fontFamily: roboto,
          color: Color.fromRGBO(235, 98, 26, 1),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (_tanggalPinjam == null ||
              _batasKembali == null ||
              _jamPelajaranAwal == null ||
              _jamPelajaranAkhir == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mohon lengkapi semua field'),
                backgroundColor: Color.fromRGBO(235, 98, 26, 1),
              ),
            );
            return;
          }
          setState(() {
            keranjangAlat.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permintaan peminjaman berhasil dikirim'),
            ),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Kirim Permintaan Peminjaman',
          style: TextStyle(
            fontFamily: roboto,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
