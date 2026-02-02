import 'package:flutter/material.dart';
import '../models/models.dart';
import '../../widgets/status_chip.dart';
import 'package:intl/intl.dart';

class PeminjamanCard extends StatefulWidget {
  final DetailPeminjamanModel data;
  const PeminjamanCard({super.key, required this.data});

  @override
  State<PeminjamanCard> createState() => _PeminjamanCardState();
}

class _PeminjamanCardState extends State<PeminjamanCard> {
  @override
  Widget build(BuildContext context) {
    // Definisi warna sesuai gambar
    const Color primaryGreen = Color(0xFF488D75);
    const Color borderGreen = Color(0xFFCDEEE2);
    const Color textDark = Color(0xFF312F34);
    const Color warningOrange = Color(0xFFE67E22); // Warna oranye batas waktu
    const Color subTextGrey = Color(0xFF5A5A5A);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Lebih rounded sesuai gambar
        border: Border.all(color: borderGreen, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER (Nama & Status)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.data.namaPeminjam,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: textDark,
                  ),
                ),
              ),
              // Ganti dengan StatusChip milikmu
              StatusChip(status: widget.data.status),
            ],
          ),

          /// KODE PEMINJAMAN
          Text(
            widget.data.kodePeminjaman,
            style: const TextStyle(
              fontSize: 14,
              color: primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          /// INFO BARIS 1 (Tanggal & Jam)
          Row(
            children: [
              // Tanggal
              Expanded(
                flex: 6,
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: textDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      // Parsing string dari Supabase ke DateTime, lalu format ke lokal Indonesia
                      DateFormat(
                        'dd MMMM yyyy',
                        'id',
                      ).format(DateTime.parse(widget.data.tanggal)),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),
              // Jam
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      size: 20,
                      color: subTextGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.data.jam,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// INFO BARIS 2 (Batas Waktu & Unit)
          Row(
            children: [
              // Bagian Batas Waktu (Kiri)
              Row(
                mainAxisSize:
                    MainAxisSize.min, // Biar lebarnya pas dengan konten
                children: [
                  const Icon(
                    Icons.edit_calendar_rounded,
                    size: 20,
                    color: warningOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.data.catatan,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: warningOrange,
                    ),
                  ),
                ],
              ),

              const Spacer(), // <--- Ini yang bikin bagian Unit terdorong ke paling kanan
              // Bagian Unit (Kanan)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory_2, size: 20, color: subTextGrey),
                  const SizedBox(width: 8),
                  Text(
                    "${widget.data.totalUnit} Unit",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
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
