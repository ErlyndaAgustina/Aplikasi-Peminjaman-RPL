import 'package:flutter/material.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class TransaksiCard extends StatelessWidget {
  final PeminjamTransaksiModel data;
  const TransaksiCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Cek status untuk warna
    final isSelesai = data.status == StatusTransaksi.selesai;
    final isMenunggu = data.status == StatusTransaksi.menunggu;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        children: [
          // Header Hijau
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(62, 159, 127, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kode Peminjaman",
                  style: TextStyle(
                    fontFamily: roboto,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.kode,
                  style: const TextStyle(
                    fontFamily: roboto,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Konten
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.namaAlat,
                          style: const TextStyle(
                            fontFamily: roboto,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          data.idAlat,
                          style: const TextStyle(
                            fontFamily: roboto,
                            fontSize: 11,
                            color: Color.fromRGBO(72, 141, 117, 1),
                          ),
                        ),
                      ],
                    ),
                    _StatusBadge(status: data.status),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _InfoItem(
                      icon: Icons.calendar_today_outlined,
                      text: data.tanggal,
                    ),
                    const SizedBox(width: 95),
                    _InfoItem(icon: Icons.access_time, text: data.jam),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _InfoItem(
                      icon: Icons.assignment_return_outlined,
                      text: "Batas Kembali",
                    ),
                    Text(
                      data.batasKembali,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StatusTransaksi status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    // Di dalam class _StatusBadge
switch (status) {
  case StatusTransaksi.dipinjam:
    bgColor = const Color.fromRGBO(219, 234, 254, 1);
    textColor = const Color.fromRGBO(37, 99, 235, 1);
    label = "Dipinjam";
    break;
  case StatusTransaksi.menunggu:
    bgColor = Colors.orange.shade100;
    textColor = Colors.orange.shade900;
    label = "Menunggu";
    break;
  case StatusTransaksi.selesai:
  case StatusTransaksi.dikembalikan: // Tambahkan ini
    bgColor = const Color.fromRGBO(217, 253, 240, 1);
    textColor = const Color.fromRGBO(62, 159, 127, 1);
    label = "Selesai";
    break;
  case StatusTransaksi.ditolak:
    bgColor = Colors.red.shade100;
    textColor = Colors.red.shade900;
    label = "Ditolak";
    break;
  default:
    bgColor = Colors.grey.shade200;
    textColor = Colors.grey.shade700;
    label = "Proses";
}

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color.fromRGBO(75, 85, 99, 1)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color.fromRGBO(75, 85, 99, 1), fontFamily: roboto, fontWeight: FontWeight.w600,),
        ),
      ],
    );
  }
}
