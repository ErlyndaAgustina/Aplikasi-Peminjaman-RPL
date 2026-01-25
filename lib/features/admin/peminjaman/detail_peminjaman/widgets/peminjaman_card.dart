import 'package:flutter/material.dart';
import 'models.dart';
import 'unit_dipinjam_card.dart';
import '../../widgets/status_chip.dart';

class PeminjamanCard extends StatefulWidget {
  final DetailPeminjamanModel data;
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
                  widget.data.namaPeminjam,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            widget.data.kodePeminjaman,
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 12,
              color: Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          /// TANGGAL & JAM (RESPONSIVE)
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        widget.data.tanggal,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: roboto,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.schedule, size: 14),
                    const SizedBox(width: 0),
                    Text(
                      widget.data.jam,
                      style: const TextStyle(fontSize: 12, fontFamily: roboto),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Row(
            children: [
              /// LEFT - CATATAN
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: Color.fromRGBO(255, 2, 2, 1),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.data.catatan,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: roboto,
                          fontSize: 12,
                          color: Color.fromRGBO(255, 2, 2, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// RIGHT - UNIT
              Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.data.totalUnit} unit',
                    style: const TextStyle(fontFamily: roboto, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
