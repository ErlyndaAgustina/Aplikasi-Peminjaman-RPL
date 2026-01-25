import 'package:flutter/material.dart';
import '../models/model.dart';
import '../widgets/status_badge.dart';

const String roboto = 'Roboto';

class TransaksiCard extends StatelessWidget {
  final TransaksiModel data;
  const TransaksiCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(205, 238, 226, 1))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// KIRI
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.namaPeminjam,
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.alat,
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 11,
                  color: Color.fromRGBO(72, 141, 117, 1),
                ),
              ),
            ],
          ),

          /// KANAN
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.durasi,
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              StatusBadge(status: data.status),
            ],
          ),
        ],
      ),
    );
  }
}
