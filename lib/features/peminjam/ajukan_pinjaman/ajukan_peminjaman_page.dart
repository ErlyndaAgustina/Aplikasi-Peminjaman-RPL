import 'package:flutter/material.dart';
import 'models/model.dart';
import 'widgets/form_widgets.dart';
import 'package:intl/intl.dart';

class AjukanPeminjamanPage extends StatefulWidget {
  const AjukanPeminjamanPage({super.key});

  @override
  State<AjukanPeminjamanPage> createState() => _AjukanPeminjamanPageState();
}

class _AjukanPeminjamanPageState extends State<AjukanPeminjamanPage> {
  static const String roboto = 'Roboto';
  
  final TextEditingController _tanggalPinjamController = TextEditingController();
  final TextEditingController _batasKembaliController = TextEditingController();
  final TextEditingController _batasKembaliOtomatisController = TextEditingController();
  
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
      // Format batas kembali otomatis
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
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, _jamPelajaranList[index]);
                  },
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Daftar Alat',
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
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color.fromRGBO(217, 253, 240, 0.49),
                  child: Icon(
                    Icons.person,
                    color: Color.fromRGBO(62, 159, 127, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
            _buildInfoCard(),
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
            _buildFormCard(),
            const SizedBox(height: 15),
            _buildWarningBanner(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alatTerpilih.nama,
            style: const TextStyle(
              fontFamily: roboto,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Color.fromRGBO(49, 47, 52, 1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Unit: ${alatTerpilih.unitKode}',
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 14,
              color: Color.fromRGBO(72, 141, 117, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Tanggal Pinjam',
                  hint: 'dd/mm/yyyy',
                  icon: Icons.calendar_today_outlined,
                  isDate: true,
                  controller: _tanggalPinjamController,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: BuildTextField(
                  label: 'Batas Kembali',
                  hint: 'dd/mm/yyyy',
                  icon: Icons.calendar_today_outlined,
                  isDate: true,
                  controller: _batasKembaliController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BuildDropdownField(
            label: 'Jam Pelajaran',
            hint: _jamPelajaranAwal ?? 'Pilih jam pelajaran',
            onTap: () => _pilihJamPelajaran(true),
          ),
          const SizedBox(height: 16),
          BuildDropdownField(
            label: 'Sampai Jam Pelajaran',
            hint: _jamPelajaranAkhir ?? 'Pilih jam pelajaran',
            onTap: () => _pilihJamPelajaran(false),
          ),
          const SizedBox(height: 16),
          BuildTextField(
            label: 'Batas Kembali',
            hint: '-',
            isReadOnly: true,
            controller: _batasKembaliOtomatisController,
          ),
        ],
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
          // Validasi form
          if (_tanggalPinjam == null || _batasKembali == null || 
              _jamPelajaranAwal == null || _jamPelajaranAkhir == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mohon lengkapi semua field'),
                backgroundColor: Color.fromRGBO(235, 98, 26, 1),
              ),
            );
            return;
          }
          
          // Proses submit
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permintaan peminjaman berhasil dikirim'),
              backgroundColor: Color.fromRGBO(62, 159, 127, 1),
            ),
          );
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