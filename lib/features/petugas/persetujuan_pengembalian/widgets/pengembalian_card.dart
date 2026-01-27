import 'package:flutter/material.dart';
import '../detail_pengembalian/form_pengembalian_petugas_page.dart';
import '../form_pengembalian/form_pengembalian_petugas_page.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class PengembalianCard extends StatelessWidget {
  final PengembalianModel data;
  const PengembalianCard({super.key, required this.data});

  Color get statusColor => data.status == StatusPengembalian.selesai
      ? const Color.fromRGBO(235, 98, 26, 1)
      : const Color.fromRGBO(37, 99, 235, 1);

  Color get statusBgColor => data.status == StatusPengembalian.selesai
      ? const Color.fromRGBO(255, 237, 213, 1)
      : const Color.fromRGBO(219, 234, 254, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Expanded(
                child: Text(
                  data.nama,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data.statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontFamily: roboto,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            data.kode,
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 12,
              color: Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 6),
              Text(
                data.tanggal,
                style: const TextStyle(fontFamily: roboto, fontSize: 12),
              ),
              const SizedBox(width: 45),
              const Icon(Icons.access_time, size: 14),
              const SizedBox(width: 6),
              Text(
                data.jam,
                style: const TextStyle(fontFamily: roboto, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.assignment_return, size: 14),
              SizedBox(width: 6),
              Text(
                'Batas Kembali',
                style: TextStyle(fontFamily: roboto, fontSize: 12),
              ),
              SizedBox(width: 50),
              Expanded(
                child: Text(
                  '2 Januari 2024, 09.00',
                  style: TextStyle(
                    fontFamily: roboto,
                    fontSize: 12,
                    color: Color.fromRGBO(255, 2, 2, 1),
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(219, 234, 254, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2,
                  size: 18,
                  color: Color.fromRGBO(37, 99, 235, 1),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.alat.join(', '),
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(37, 99, 235, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                if (data.status == StatusPengembalian.dipinjam) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FormPengembalianPage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPengembalianPage(),
                    ),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                data.buttonText, // ← pakai getter model (lebih bersih)
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
