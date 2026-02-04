import 'package:flutter/material.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class TransaksiCard extends StatelessWidget {
  final TransaksiModel transaksi;
  final VoidCallback onAjukanPengembalian;

  const TransaksiCard({
    super.key,
    required this.transaksi,
    required this.onAjukanPengembalian,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
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
                  transaksi.kode,
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
                          transaksi.namaAlat,
                          style: const TextStyle(
                            fontFamily: roboto,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          transaksi.idAlat,
                          style: const TextStyle(
                            fontFamily: roboto,
                            fontSize: 11,
                            color: Color.fromRGBO(72, 141, 117, 1),
                          ),
                        ),
                      ],
                    ),
                    // Di dalam build TransaksiCard
                    _StatusBadge(status: transaksi.status),
                  ],
                ),
                const SizedBox(height: 16),
                // Di dalam TransaksiCard build...
                Row(
                  children: [
                    _InfoItem(
                      icon: Icons.calendar_today_outlined,
                      // Tinggal panggil getter dari model
                      text: transaksi.tanggalFormatted,
                    ),
                    const Spacer(), // Gunakan Spacer agar jaraknya otomatis penuh ke kanan
                    _InfoItem(
                      icon: Icons.access_time,
                      text: transaksi.jam, // Sudah format "Jam ke X"
                    ),
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
                      transaksi.batasKembaliFormatted, // Tanggal + Jam batas
                      style: const TextStyle(
                        fontFamily: roboto,
                        color: Color.fromRGBO(255, 2, 2, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Button Ajukan Pengembalian
                if (transaksi.status == 'dipinjam' ||
                    transaksi.status == 'terlambat')
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: onAjukanPengembalian,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Ajukan Pengembalian',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
  final String status; // Ubah dari bool ke String
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    // Logic penentuan warna berdasarkan string status dari Supabase
    switch (status) {
      case 'terlambat':
        bgColor = const Color.fromRGBO(255, 119, 119, 0.22);
        textColor = const Color.fromRGBO(255, 2, 2, 1);
        label = "Terlambat";
        break;
      case 'menunggu':
        bgColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange.shade900;
        label = "Menunggu";
        break;
      case 'dikembalikan':
        bgColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green.shade900;
        label = "Selesai";
        break;
      default: // Status 'dipinjam'
        bgColor = const Color.fromRGBO(219, 234, 254, 1);
        textColor = const Color.fromRGBO(37, 99, 235, 1);
        label = "Dipinjam";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
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
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromRGBO(75, 85, 99, 1),
            fontFamily: roboto,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
