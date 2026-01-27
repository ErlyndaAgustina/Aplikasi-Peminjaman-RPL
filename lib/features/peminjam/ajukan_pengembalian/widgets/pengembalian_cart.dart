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
    bool isTerlambat = transaksi.status == StatusTransaksi.terlambat;

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
                    _StatusBadge(isTerlambat: isTerlambat),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _InfoItem(
                      icon: Icons.calendar_today_outlined,
                      text: transaksi.tanggal,
                    ),
                    const SizedBox(width: 95),
                    _InfoItem(icon: Icons.access_time, text: transaksi.jam),
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
                      transaksi.batasKembali,
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
          )
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isTerlambat;
  const _StatusBadge({required this.isTerlambat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isTerlambat
            ? const Color.fromRGBO(255, 119, 119, 0.22)
            : const Color.fromRGBO(219, 234, 254, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isTerlambat ? "Terlambat" : "Dipinjam",
        style: TextStyle(
          fontFamily: roboto,
          color: isTerlambat
              ? const Color.fromRGBO(255, 2, 2, 1)
              : const Color.fromRGBO(37, 99, 235, 1),
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