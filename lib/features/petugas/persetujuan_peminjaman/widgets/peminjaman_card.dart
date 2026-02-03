import 'package:flutter/material.dart';
import '../detail_peminjaman/detail_peminjaman_page.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class PeminjamanCard extends StatefulWidget {
  final PeminjamanModel data;
  final VoidCallback onRefresh;

  const PeminjamanCard({
    super.key,
    required this.data,
    required this.onRefresh,
  });

  @override
  State<PeminjamanCard> createState() => _PeminjamanCardState();
}

class _PeminjamanCardState extends State<PeminjamanCard> {
  // Fungsi Helper untuk warna teks status
  Color getStatusColor() {
    final status = widget.data.status.toLowerCase();
    if (status == 'dipinjam') return const Color.fromRGBO(235, 98, 26, 1);
    if (status == 'ditolak') return const Color.fromRGBO(255, 2, 2, 1);
    return const Color.fromRGBO(1, 85, 56, 1); // Menunggu
  }

  // Fungsi Helper untuk warna background status
  Color bgStatusColor() {
    final status = widget.data.status.toLowerCase();
    if (status == 'dipinjam') return const Color.fromRGBO(255, 237, 213, 1);
    if (status == 'ditolak') return const Color.fromRGBO(255, 119, 119, 0.22);
    return const Color.fromRGBO(217, 253, 240, 1); // Menunggu
  }

  String getButtonText() {
    return widget.data.status.toLowerCase() == 'menunggu' ? 'Proses' : 'Detail';
  }

  // 1. Tambahkan fungsi helper di dalam class PeminjamanCard atau di luar class
String _getDisplayStatus(String dbStatus) {
  if (dbStatus == 'dipinjam') {
    return 'Disetujui'; // Mengubah 'dipinjam' menjadi 'Disetujui' di UI
  }
  // Kamu juga bisa merapikan status lain
  if (dbStatus == 'menunggu') return 'Menunggu';
  if (dbStatus == 'ditolak') return 'Ditolak';
  
  return dbStatus;
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header (Nama & Status)
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
                  _getDisplayStatus(widget.data.status),
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

          /// Kode Peminjaman
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

          /// Tanggal & Jam Pelajaran
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                widget.data.tanggalFormat,
                style: const TextStyle(fontFamily: roboto, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "Jam ke ${widget.data.jamMulai} - ${widget.data.jamSelesai}",
                style: const TextStyle(fontFamily: roboto, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Daftar Alat (Biru Box)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    widget.data.alat.isEmpty
                        ? "Klik detail untuk lihat alat"
                        : widget.data.alat.toSet().join(
                            ', ',
                          ), // Menggunakan .toSet() agar nama alat yang sama tidak muncul double
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 13,
                      color: Color.fromRGBO(37, 99, 235, 1),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Action Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPeminjamanPage(
                      peminjamanId: widget.data.idPeminjaman,
                    ),
                  ),
                ).then((_) {
                  widget.onRefresh();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
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
