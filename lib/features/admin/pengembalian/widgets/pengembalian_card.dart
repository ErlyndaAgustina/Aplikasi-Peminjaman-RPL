import 'package:flutter/material.dart';
import '../models/model.dart';
import 'detail_pengembalian_dialog.dart';
import 'edit_pengembalian_dialog.dart';
import 'hapus_pengembalian_dialog.dart';
import 'status_badge.dart';

const String roboto = 'Roboto';

class PengembalianCard extends StatefulWidget {
  final PengembalianModel data;
  const PengembalianCard({super.key, required this.data});

  @override
  State<PengembalianCard> createState() => _PengembalianCardState();
}

class _PengembalianCardState extends State<PengembalianCard> {
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
                  widget.data.nama,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromRGBO(49, 47, 52, 1),
                  ),
                ),
              ),
              const StatusBadge(),
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

          const SizedBox(height: 16),

          /// BODY 2 KOLOM (INI KUNCI UTAMA)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// KIRI
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kembali pada',
                      style: TextStyle(
                        fontFamily: roboto,
                        fontSize: 10,
                        color: Color.fromRGBO(138, 146, 158, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.data.tanggal,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(75, 85, 99, 1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Total Denda',
                      style: TextStyle(
                        fontFamily: roboto,
                        fontSize: 10,
                        color: Color.fromRGBO(138, 146, 158, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.totalDenda == 0
                          ? 'Rp 0'
                          : 'Rp ${widget.data.totalDenda}',
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(235, 98, 26, 1),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 80,
                    ), // 👈 geser ke kiri secara optik
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Terlambat',
                          style: TextStyle(
                            fontFamily: roboto,
                            fontSize: 10,
                            color: Color.fromRGBO(138, 146, 158, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.data.terlambatMenit} menit',
                          style: const TextStyle(
                            fontFamily: roboto,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(255, 2, 2, 1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ACTION BUTTON (tetap kanan, sesuai gambar)
                  Row(
                    children: [
                      _iconButton(
                        Icons.visibility,
                        const Color.fromRGBO(236, 254, 248, 1),
                        iconColor: const Color.fromRGBO(93, 93, 93, 1),
                        onTap: () {
  showDialog(context: context, builder: (_) => DetailPengembalianDialog(data: widget.data));
}
                      
                      ),
                      const SizedBox(width: 6),
                       _iconButton(
                        Icons.edit,
                        const Color.fromRGBO(236, 254, 248, 1),
                        iconColor: const Color.fromRGBO(93, 93, 93, 1),
                        onTap: () {
  showDialog(context: context, builder: (_) => EditPengembalianDialog(data: widget.data));
}
                      ),
                      const SizedBox(width: 6),
                      _iconButton(
                        Icons.delete,
                        const Color.fromRGBO(255, 119, 119, 0.22),
                        iconColor: const Color.fromRGBO(255, 2, 2, 1),
                        onTap: () {
  showDialog(context: context, builder: (_) => const HapusPengembalianDialog());
}
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    Color bg, {
    Color iconColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}
