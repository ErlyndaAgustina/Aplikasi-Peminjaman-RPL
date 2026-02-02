import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml

class PengembalianModel {
  final String id;
  final String idDetailPeminjaman;
  final String idUnit;

  final String nama;
  final String kode;
  final String tanggal;
  final int terlambatMenit;
  final int dendaTerlambat;
  final int dendaRusak;
  final int totalDenda;
  final String catatan;
  final String namaAlat;
  final String kodeUnit;
  final int jamSelesai;

  PengembalianModel({
    required this.id,
    required this.idDetailPeminjaman,
    required this.idUnit,
    required this.nama,
    required this.kode,
    required this.tanggal,
    required this.terlambatMenit,
    required this.dendaTerlambat,
    required this.dendaRusak,
    required this.totalDenda,
    required this.catatan,
    required this.namaAlat,
    required this.kodeUnit,
    required this.jamSelesai,
  });

  factory PengembalianModel.fromJson(Map<String, dynamic> json) {
  final peminjaman = json['peminjaman'] as Map<String, dynamic>? ?? {};
 final user = peminjaman['users'] as Map<String, dynamic>? ?? {};
  final details = peminjaman['detail_peminjaman'] as List? ?? [];

  String namaAlat = 'Alat tidak diketahui';
  String kodeUnit = '-';
  String idDetail = '';
  String idUnit = '';

 if (details.isNotEmpty) {
    final detail = details[0];
    final unit = detail['alat_unit'] ?? {};
    final alat = unit['alat'] ?? {};

    // UBAH baris ini agar sesuai dengan hasil query (id_detail)
    idDetail = detail['id_detail'] ?? ''; 
    idUnit = unit['id_unit'] ?? '';
    namaAlat = alat['nama_alat'] ?? namaAlat;
    kodeUnit = unit['kode_unit'] ?? kodeUnit;
  }

  String formattedDate = '-';
  if (json['tanggal_kembali'] != null) {
    final dt = DateTime.parse(json['tanggal_kembali']);
    formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dt);
  }

  return PengembalianModel(
    id: json['id_pengembalian'],
    idDetailPeminjaman: idDetail,   // ✅ PAKAI YANG VALID
    idUnit: idUnit,                 // ✅ PAKAI YANG VALID
    nama: user['nama'] ?? 'User Tidak Ada',
    kode: peminjaman['kode_peminjaman'] ?? '-',
    tanggal: formattedDate,
    terlambatMenit: json['terlambat_menit'] ?? 0,
    dendaTerlambat: json['denda_terlambat'] ?? 0,
    dendaRusak: json['denda_rusak'] ?? 0,
    totalDenda: json['total_denda'] ?? 0,
    catatan: json['catatan_kerusakan'] ?? 'Tidak ada catatan',
    namaAlat: namaAlat,
    kodeUnit: kodeUnit,
    jamSelesai: peminjaman['jam_selesai'] ?? 0,
  );
}

}
