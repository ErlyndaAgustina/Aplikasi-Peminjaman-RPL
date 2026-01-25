import 'package:flutter/material.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class InfoPeminjamanCard extends StatelessWidget {
  final DetailPeminjamanModel data;

  const InfoPeminjamanCard({super.key, required this.data});

  Widget _row(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color.fromRGBO(72, 141, 117, 1),
        ),
        const SizedBox(width: 8),

        /// LABEL
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 13,
              color: Color.fromRGBO(75, 85, 99, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        /// VALUE
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontFamily: roboto,
            fontSize: 13,
            color: Color.fromRGBO(72, 141, 117, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(205, 238, 226, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Peminjaman',
            style: TextStyle(
              fontFamily: roboto,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Color.fromRGBO(49, 47, 52, 1),
            ),
          ),
          const SizedBox(height: 10),

          _row(Icons.calendar_month, 'Tanggal Pinjam', data.tanggalPinjam),
          const SizedBox(height: 6),
          _row(Icons.schedule, 'Jam Pelajaran', data.jamPelajaran),
          const SizedBox(height: 6),
          _row(Icons.assignment_return, 'Batas Kembali', data.batasKembali),
        ],
      ),
    );
  }
}
