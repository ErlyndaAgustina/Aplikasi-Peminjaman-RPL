import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../profile/profile_page.dart';
import '../daftar_alat/models/model.dart';
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

  final List<String> _jamPelajaranList = List.generate(
    10,
    (i) => 'Jam Pelajaran ${i + 1}',
  );

  // Fungsi konversi Jam Pelajaran ke angka
  int _extractJamPelajaran(String? jamText) {
    if (jamText == null) return 0;
    return int.parse(RegExp(r'\d+').stringMatch(jamText) ?? '0');
  }

  @override
  void dispose() {
    _tanggalPinjamController.dispose();
    _batasKembaliController.dispose();
    _batasKembaliOtomatisController.dispose();
    super.dispose();
  }

  void _hitungBatasKembaliOtomatis() {
    if (_batasKembali != null && _jamPelajaranAkhir != null) {
      String tanggal = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(_batasKembali!);
      setState(() {
        _batasKembaliOtomatisController.text = '$tanggal - $_jamPelajaranAkhir';
      });
    } else {
      setState(() => _batasKembaliOtomatisController.text = '-');
    }
  }

  // Fungsi untuk menghitung jam asli berdasarkan urutan jam pelajaran
  // Jam 1 = 07:00, Jam 2 = 07:40, dst.
  String _hitungEstimasiJam(int urutanJam) {
    // Setiap jam pelajaran = 40 menit, dimulai jam 07:00
    // Jika urutanJam adalah 7, maka 7 * 40 = 280 menit
    DateTime baseTime = DateTime(2026, 1, 1, 7, 0);
    DateTime hasil = baseTime.add(Duration(minutes: urutanJam * 40));
    return DateFormat('HH:mm').format(hasil);
  }

  void _updateBatasKembaliOtomatis() {
    if (_batasKembali != null && _jamPelajaranAkhir != null) {
      int urutan = _extractJamPelajaran(_jamPelajaranAkhir);
      String jamMenit = _hitungEstimasiJam(urutan);

      // Format: 02 Februari 2026 (08:20 WIB)
      String tanggalFormat = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(_batasKembali!);

      setState(() {
        _batasKembaliOtomatisController.text = "$tanggalFormat ($jamMenit WIB)";
      });
    } else {
      setState(() {
        _batasKembaliOtomatisController.text = "-";
      });
    }
  }

  Future<void> _submitPeminjaman() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      _showSnackBar('Sesi habis, silakan login kembali', isError: true);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(62, 159, 127, 1),
        ),
      ),
    );

    try {
      final userData = await supabase
          .from('users')
          .select('id_user')
          .eq('auth_user_id', user.id)
          .single();

      final String idUserInternal = userData['id_user'];
      String kodePinjam = "PJM-${DateTime.now().millisecondsSinceEpoch}";

final peminjamanResponse = await supabase
          .from('peminjaman')
          .insert({
            'id_user': idUserInternal,
            'tanggal_pinjam': _tanggalPinjam?.toIso8601String(),
            'batas_kembali': _batasKembali?.toIso8601String(),
            'status': 'menunggu',
            'kode_peminjaman': kodePinjam,
            'jam_mulai': _extractJamPelajaran(_jamPelajaranAwal),
            'jam_selesai': _extractJamPelajaran(_jamPelajaranAkhir),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select('id_peminjaman') // 🟢 PAKSA hanya ambil ID, jangan biarkan Supabase narik kolom lain
          .single();

      final String idPeminjaman = peminjamanResponse['id_peminjaman'];

      // LOOP KERANJANG
      for (var alat in keranjangAlat) {
        // Kita cari unit yang statusnya 'tersedia'
        final unitData = await supabase
            .from('alat_unit')
            .select('id_unit')
            .eq('id_alat', alat.idAlat)
            .eq('status', 'tersedia')
            .limit(1)
            .maybeSingle();

        if (unitData == null) {
          throw "Unit untuk alat '${alat.nama}' tidak tersedia saat ini.";
        }
        await supabase.from('detail_peminjaman').insert({
          'id_peminjaman': idPeminjaman,
          'id_unit': unitData['id_unit'],
        });

        await supabase
            .from('alat_unit')
            .update({'status': 'dipinjam'})
            .eq('id_unit', unitData['id_unit']);
      }

      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Permintaan peminjaman berhasil terkirim!');
        setState(() => keranjangAlat.clear());
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      String pesanError = e.toString().replaceAll("Exception: ", "");
      _showSnackBar(pesanError, isError: true);
    }
  }
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Colors.redAccent
            : const Color.fromRGBO(62, 159, 127, 1),
      ),
    );
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
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
          _tanggalPinjamController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(picked);
          // Defaultkan batas kembali sama dengan tanggal pinjam
          _batasKembali = picked;
          _batasKembaliController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(picked);
        } else {
          _batasKembali = picked;
          _batasKembaliController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(picked);
        }
      });

      _updateBatasKembaliOtomatis();
    }
  }

  void _pilihJamPelajaran(bool isAwal) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isAwal ? 'Pilih Jam Pelajaran' : 'Pilih Sampai Jam Pelajaran',
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _jamPelajaranList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_jamPelajaranList[index]),
                onTap: () => Navigator.pop(context, _jamPelajaranList[index]),
              ),
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
        }
      });
      _updateBatasKembaliOtomatis();
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
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          if (_tanggalPinjam == null ||
              _batasKembali == null ||
              _jamPelajaranAwal == null ||
              _jamPelajaranAkhir == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mohon lengkapi semua data')),
            );
            return;
          }
          _submitPeminjaman(); // Panggil fungsi Supabase
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Kirim Permintaan Peminjaman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
