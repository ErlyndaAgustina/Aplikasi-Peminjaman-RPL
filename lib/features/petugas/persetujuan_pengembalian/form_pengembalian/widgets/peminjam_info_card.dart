import 'package:flutter/material.dart';
import '../models/model.dart'; // Pastikan PengembalianModel memiliki field yang sesuai

class PeminjamInfoCard extends StatelessWidget {
  final PengembalianModel data;
  const PeminjamInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const String roboto = 'Roboto';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Corner lebih bulat
        border: Border.all(
          color: const Color.fromRGBO(205, 238, 226, 1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BARIS ATAS: Nama dan Kode Peminjaman
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.nama,
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 18, // Ukuran lebih besar
                  fontWeight: FontWeight.w800,
                  color: Color.fromRGBO(49, 47, 52, 1),
                ),
              ),
              Text(
                data.kode,
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(72, 141, 117, 1), // Warna hijau kode
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // BARIS TENGAH: Tanggal Pinjam dan Jam
          Row(
            children: [
              // Tanggal
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color.fromRGBO(75, 85, 99, 1),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data.tanggalPinjam,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(75, 85, 99, 1),
                      ),
                    ),
                  ],
                ),
              ),
              // Jam
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      size: 18,
                      color: Color.fromRGBO(75, 85, 99, 1),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data.jamPelajaran,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(75, 85, 99, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // BARIS BAWAH: Batas Kembali
          Row(
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(
                      Icons.event_busy_outlined,
                      size: 18,
                      color: Color.fromRGBO(75, 85, 99, 1),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Batas Kembali',
                      style: TextStyle(
                        fontFamily: roboto,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(75, 85, 99, 1),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded (
              child: Text(
                data.batasKembali,
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color.fromRGBO(255, 2, 2, 1),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
