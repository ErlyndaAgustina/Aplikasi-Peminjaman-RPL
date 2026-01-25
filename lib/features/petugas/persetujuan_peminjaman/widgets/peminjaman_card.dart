import 'package:flutter/material.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class PeminjamanCard extends StatefulWidget {
  final PeminjamanModel data;
  const PeminjamanCard({super.key, required this.data});
  @override
  State<PeminjamanCard> createState() => _PeminjamanCardState();
}

class _PeminjamanCardState extends State<PeminjamanCard> {
  Color getStatusColor() {
    switch (widget.data.status) {
      case 'disetujui':
        return Color.fromRGBO(235, 98, 26, 1);
      case 'ditolak':
        return Color.fromRGBO(255, 2, 2, 1);
      default:
        return Color.fromRGBO(1, 85, 56, 1);
    }
  }

  Color bgStatusColor() {
    switch (widget.data.status) {
      case 'disetujui':
        return Color.fromRGBO(255, 237, 213, 1);
      case 'ditolak':
        return Color.fromRGBO(255, 119, 119, 0.22);
      default:
        return Color.fromRGBO(217, 253, 240, 1);
    }
  }

  String getButtonText() {
    return widget.data.status == 'menunggu' ? 'Proses' : 'Detail';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.data.nama,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromRGBO(49, 47, 52, 1),
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
                  color: bgStatusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.data.status.capitalize(),
                  style: TextStyle(
                    color: getStatusColor(),
                    fontFamily: roboto,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

          /// Kode
          Text(
            widget.data.kode,
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 12,
              color: Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),

          /// Tanggal & Jam
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 6),
              Text(
                widget.data.tanggal,
                style: const TextStyle(fontFamily: roboto, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14),
              const SizedBox(width: 6),
              Text(
                widget.data.jam,
                style: const TextStyle(fontFamily: roboto, fontSize: 12),
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
                    widget.data.alat.join(', '),
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 13,
                      color: Color.fromRGBO(37, 99, 235, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ================= BUTTON =================
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(62, 159, 127, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                getButtonText(),
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

extension on String {
  String capitalize() => this[0].toUpperCase() + substring(1).toLowerCase();
}
