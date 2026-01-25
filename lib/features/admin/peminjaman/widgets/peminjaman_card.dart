import 'package:flutter/material.dart';
import 'models.dart';
import 'status_chip.dart';
import 'filter.dart';

class PeminjamanCard extends StatefulWidget {
  final PeminjamanModel data;
  const PeminjamanCard({super.key, required this.data});

  @override
  State<PeminjamanCard> createState() => _PeminjamanCardState();
}

class _PeminjamanCardState extends State<PeminjamanCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                ),
              ),
              StatusChip(status: widget.data.status),
            ],
          ),
          const SizedBox(height: 2),
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
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 6),
              Text(
                widget.data.tanggal,
                style: const TextStyle(fontSize: 12, fontFamily: roboto),
              ),
              const SizedBox(width: 50),
              const Icon(Icons.schedule, size: 14),
              const SizedBox(width: 6),
              Text(
                widget.data.jam,
                style: const TextStyle(fontSize: 12, fontFamily: roboto),
              ),
            ],
          ),
          if (widget.data.catatan != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: Color.fromRGBO(255, 2, 2, 1),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.data.catatan!,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontSize: 12,
                    color: Color.fromRGBO(255, 2, 2, 1),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),

              _iconBtn(
                Icons.visibility,
                const Color.fromRGBO(236, 254, 248, 1),
                iconColor: const Color.fromRGBO(93, 93, 93, 1),
              ),
              const SizedBox(width: 6),
              _iconBtn(
                Icons.edit,
                const Color.fromRGBO(236, 254, 248, 1),
                iconColor: const Color.fromRGBO(93, 93, 93, 1),
              ),
              const SizedBox(width: 6),
              _iconBtn(
                Icons.delete,
                const Color.fromRGBO(255, 119, 119, 0.22),
                iconColor: const Color.fromRGBO(255, 2, 2, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color bg, {Color iconColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }
}
