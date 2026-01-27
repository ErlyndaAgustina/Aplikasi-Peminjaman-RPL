import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/model.dart';
import 'widgets/peminjam_info_card.dart';
import 'widgets/input_text_field.dart';
import 'widgets/auto_calculated_box.dart';
import 'widgets/unit_dipinjam_section.dart';
import 'widgets/simpan_button.dart';

const String roboto = 'Roboto';

class FormPengembalianPage extends StatefulWidget {
  const FormPengembalianPage({super.key});

  @override
  State<FormPengembalianPage> createState() => _FormPengembalianPageState();
}

class _FormPengembalianPageState extends State<FormPengembalianPage> {
  final data = dummyPengembalian;

  late TextEditingController tanggalCtrl;
  late TextEditingController jamCtrl;
  late TextEditingController dendaCtrl;
  late TextEditingController catatanCtrl;

  int dendaTerlambat = 0;
  int terlambatMenit = 0;
  int dendaKerusakanValue = 0;

  @override
  void initState() {
    super.initState();
    tanggalCtrl = TextEditingController();
    jamCtrl = TextEditingController();
    dendaCtrl = TextEditingController();
    catatanCtrl = TextEditingController();

    dendaCtrl.addListener(_onDendaChanged);
  }

  @override
  void dispose() {
    tanggalCtrl.dispose();
    jamCtrl.dispose();
    dendaCtrl.dispose();
    catatanCtrl.dispose();
    super.dispose();
  }

  void _onDendaChanged() {
    setState(() {
      // Menangkap inputan denda kerusakan dari user
      dendaKerusakanValue =
          int.tryParse(dendaCtrl.text.replaceAll('.', '')) ?? 0;
    });
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF3E9F7F)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        tanggalCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _pilihJam() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF3E9F7F)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        jamCtrl.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _simpan() {
    // Logic simpan data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data pengembalian berhasil disimpan'),
        backgroundColor: Color(0xFF3E9F7F),
      ),
    );
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
                        'Form Pengembalian',
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
            PeminjamInfoCard(data: data),
            const SizedBox(height: 20),

            const Text(
              'Input Data Kembali',
              style: TextStyle(fontFamily: roboto,
                fontWeight: FontWeight.w800,
                fontSize: 20,),
            ),
            const SizedBox(height: 5),

            Row(
              children: [
                Expanded(
                  child: InputTextField(
                    label: 'Tanggal Kembali',
                    controller: tanggalCtrl,
                    isDatePicker: true,
                    readOnly: true,
                    onTap: _pilihTanggal,
                    hintText: 'dd/mm/yy',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InputTextField(
                    label: 'Jam Kembali',
                    controller: jamCtrl,
                    isTimePicker: true,
                    readOnly: true,
                    onTap: _pilihJam,
                    hintText: '00:00',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            InputTextField(
              label: 'Denda Kerusakan (Rp)',
              controller: dendaCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              hintText: 'Rp 0',
            ),
            const SizedBox(height: 12),

            InputTextField(
              label: 'Catatan Kerusakan',
              controller: catatanCtrl,
              maxLines: 3,
              hintText: 'Tulis catatan jika ada kerusakan pada alat...',
            ),
            const SizedBox(height: 16),

            if (tanggalCtrl.text.isNotEmpty && jamCtrl.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AutoCalculateBox(
                  terlambatMenit: 1200, // Data dummy atau dari logic sistem
                  dendaTerlambat: 50000, // Data dummy atau dari logic sistem
                  dendaKerusakan: dendaKerusakanValue, // Data dari input user
                ),
              ),

            const Text(
              'Unit Dipinjam',
              style: TextStyle(
                fontFamily: roboto,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),

            ...data.units.map(
              (u) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: UnitDipinjamCard(unit: u),
              ),
            ),

            const SizedBox(height: 24),
            SimpanButton(onPressed: _simpan),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
