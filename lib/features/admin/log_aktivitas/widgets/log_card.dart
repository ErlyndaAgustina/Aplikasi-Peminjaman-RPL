import 'package:flutter/material.dart';
import '../models/model.dart';
import 'log_header_badge.dart';
import 'log_user_row.dart';
import 'unit_dropdown.dart';

const String roboto = 'Roboto';

class LogCard extends StatelessWidget {
  final LogAktivitasModel data;
  const LogCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD0EEE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LogHeaderBadge(aksi: data.aksi, kategori: data.kategori),
          const SizedBox(height: 15),
          Text(
            data.deskripsi,
            style: const TextStyle(
              fontFamily: roboto,
              fontWeight: FontWeight.w500, fontSize: 12, color: Color.fromRGBO(72, 141, 117, 1)),
          ),
          const SizedBox(height: 20),
          LogUserRow(
            nama: data.namaUser,
            role: data.role,
            tanggal: data.tanggal,
          ),
          const SizedBox(height: 10),
          UnitDropdown(alat: data.alat, unit: data.unit),
        ],
      ),
    );
  }
}
