import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class AutoCalculateBox extends StatelessWidget {
  final int terlambatMenit;
  final int dendaTerlambat;
  final int dendaKerusakan;

  const AutoCalculateBox({
    super.key,
    required this.terlambatMenit,
    required this.dendaTerlambat,
    required this.dendaKerusakan,
  });

  String formatRupiah(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final int totalDenda = dendaTerlambat + dendaKerusakan;
    final bool isTerlambat = dendaTerlambat > 0;
    final bool isRusak = dendaKerusakan > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER (Selalu Muncul) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.history_toggle_off_outlined,
                    color: Color.fromRGBO(62, 159, 127, 1),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AUTO-CALCULATED',
                    style: TextStyle(
                      fontFamily: roboto,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color.fromRGBO(49, 47, 52, 1),
                    ),
                  ),
                ],
              ),
              // Status Terlambat di pojok kanan (Hanya jika denda > 0)
              if (isTerlambat)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 119, 119, 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Terlambat',
                    style: TextStyle(
                      fontFamily: roboto,
                      color: Color.fromRGBO(255, 2, 2, 1),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 20),

          // --- RINCIAN DENDA TERLAMBAT ---
          if (isTerlambat) ...[
            Row(
              children: [
                _buildInfoColumn('Terlambat (menit)', 
                  '${terlambatMenit.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} min'),
                _buildInfoColumn('Denda Terlambat', formatRupiah(dendaTerlambat)),
              ],
            ),
          ],

          // Beri jarak antar rincian jika ada dua jenis denda
          if (isTerlambat && isRusak) const SizedBox(height: 12),
          if (isRusak) ...[
            Row(
              children: [
                const Text(
                  'Denda Kerusakan',
                  style: TextStyle(
                    fontFamily: roboto,
                    color: Color.fromRGBO(72, 141, 117, 1),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(), // Ini yang bikin harga geser ke kanan mentok
                Text(
                  formatRupiah(dendaKerusakan),
                  style: const TextStyle(
                    fontFamily: roboto,
                    color: Color.fromRGBO(255, 2, 2, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
          
          // --- FOOTER TOTAL ---
          const SizedBox(height: 8),
          const Divider(color: Color.fromRGBO(205, 238, 226, 1), thickness: 1.2),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Denda:',
                style: TextStyle(
                  fontFamily: roboto,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color.fromRGBO(49, 47, 52, 1),
                ),
              ),
              Text(
                formatRupiah(totalDenda),
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(255, 2, 2, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: roboto,
              color: Color.fromRGBO(72, 141, 117, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: roboto,
              color: Color.fromRGBO(255, 2, 2, 1),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}