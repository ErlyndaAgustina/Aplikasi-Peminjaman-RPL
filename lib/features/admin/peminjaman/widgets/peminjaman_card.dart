import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../detail_peminjaman/detail_peminjaman_page.dart';
import 'edit_peminjaman_dialog.dart';
import 'hapus_peminjaman_dialog.dart';
import '../models/models.dart';
import 'status_chip.dart';

const String roboto = 'Roboto';

class PeminjamanCard extends StatefulWidget {
  final PeminjamanModel data;
  final VoidCallback onChanged;

  const PeminjamanCard({
    super.key,
    required this.data,
    required this.onChanged,
  });

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
          // BARIS 1: Nama dan Status
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

          // Kode Peminjaman
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

          // BARIS: Tanggal dan Jam
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 6),
              Text(widget.data.tanggal, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 40),
              const Icon(Icons.schedule, size: 14),
              const SizedBox(width: 6),
              Text(
                "Jam ${widget.data.jam}",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // BARIS: Batas Kembali
          Row(
            children: [
              const Icon(Icons.edit_calendar, size: 16, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                "Batas: ${widget.data.batasKembali}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Warning Terlambat
          if (widget.data.status.toLowerCase() == 'terlambat') ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  "Terlambat ${widget.data.durasiTerlambat} hari",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),

          // TOMBOL AKSI (View, Edit, Delete)
          Row(
            children: [
              const Spacer(),
              _iconBtn(
                Icons.visibility,
                const Color.fromRGBO(236, 254, 248, 1),
                iconColor: const Color.fromRGBO(93, 93, 93, 1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPeminjamanPage(
                        peminjamanId:
                            widget.data.idPeminjaman, // Kirim ID-nya ke sini!
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              _iconBtn(
                Icons.edit,
                const Color.fromRGBO(236, 254, 248, 1),
                iconColor: const Color.fromRGBO(93, 93, 93, 1),
                onTap: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) =>
                        EditPeminjamanDialog(data: widget.data),
                  );
                  if (result == true) widget.onChanged();
                },
              ),
              const SizedBox(width: 6),
              _iconBtn(
                Icons.delete,
                const Color.fromRGBO(255, 119, 119, 0.22),
                iconColor: const Color.fromRGBO(255, 2, 2, 1),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        HapusPeminjamanDialog(namaPeminjam: widget.data.nama),
                  );

                  if (confirmed == true) {
                    await Supabase.instance.client
                        .from('peminjaman')
                        .delete()
                        .eq('id_peminjaman', widget.data.id);
                    widget.onChanged();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(
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
