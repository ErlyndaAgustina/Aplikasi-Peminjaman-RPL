import 'package:flutter/material.dart';
import 'models/model.dart';
import 'widgets/form_widgets.dart';

class AjukanPeminjamanPage extends StatelessWidget {
  const AjukanPeminjamanPage({super.key});
  static const String roboto = 'Roboto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F2),
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
                Container(
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
            children: const [
              Expanded(
                child: BuildTextField(
                  label: 'Tanggal Pinjam',
                  hint: '02/01/2026',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: BuildTextField(
                  label: 'Batas Kembali',
                  hint: '02/01/2026',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const BuildDropdownField(
            label: 'Jam Pelajaran',
            hint: 'Pilih jam pelajaran',
          ),
          const SizedBox(height: 16),
          const BuildDropdownField(
            label: 'Sampai Jam Pelajaran',
            hint: 'Pilih jam pelajaran',
          ),
          const SizedBox(height: 16),
          const BuildTextField(
            label: 'Batas Kembali',
            hint: '-',
            isReadOnly: true,
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
        onPressed: () {},
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
