import 'package:flutter/material.dart';
import 'form_widgets.dart';

class FormPeminjamanCard extends StatelessWidget {
  final TextEditingController tanggalPinjamController;
  final TextEditingController batasKembaliController;
  final TextEditingController batasKembaliOtomatisController;
  final String? jamPelajaranAwal;
  final String? jamPelajaranAkhir;
  final Function(bool) onPilihTanggal;
  final Function(bool) onPilihJam;

  const FormPeminjamanCard({
    super.key,
    required this.tanggalPinjamController,
    required this.batasKembaliController,
    required this.batasKembaliOtomatisController,
    required this.jamPelajaranAwal,
    required this.jamPelajaranAkhir,
    required this.onPilihTanggal,
    required this.onPilihJam,
  });

  @override
  Widget build(BuildContext context) {
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
                  controller: tanggalPinjamController,
                  onTap: () => onPilihTanggal(true), // Memanggil fungsi di Page
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: BuildTextField(
                  label: 'Batas Kembali',
                  hint: 'dd/mm/yyyy',
                  icon: Icons.calendar_today_outlined,
                  controller: batasKembaliController,
                  onTap: () =>
                      onPilihTanggal(false), // Memanggil fungsi di Page
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BuildDropdownField(
            label: 'Jam Pelajaran',
            hint: jamPelajaranAwal ?? 'Pilih jam pelajaran',
            onTap: () => onPilihJam(true),
          ),
          const SizedBox(height: 16),
          BuildDropdownField(
            label: 'Sampai Jam Pelajaran',
            hint: jamPelajaranAkhir ?? 'Pilih jam pelajaran',
            onTap: () => onPilihJam(false),
          ),
          const SizedBox(height: 16),
          // Di dalam FormPeminjamanCard
          BuildTextField(
            label: 'Batas Kembali',
            hint: '-',
            isReadOnly: true, // Pastikan ini true agar tidak bisa diedit manual
            controller:
                batasKembaliOtomatisController, // Harus pakai controller ini!
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
