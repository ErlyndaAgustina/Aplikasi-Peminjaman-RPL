import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml

class PengembalianModel {
  final String id;
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
    // Ambil data dari hasil join
    final peminjaman = json['peminjaman'] ?? {};
    final user = peminjaman['users'] ?? {};

    // Ambil detail pertama dari list detail_peminjaman
    final details = peminjaman['detail_peminjaman'] as List? ?? [];
    String nAlat = 'Alat tidak diketahui';
    String kUnit = '-';

    if (details.isNotEmpty) {
      final unit = details[0]['alat_unit'] ?? {};
      final alat = unit['alat'] ?? {};
      nAlat = alat['nama_alat'] ?? 'Alat tidak diketahui';
      kUnit = unit['kode_unit'] ?? '-';
    }

    // Format Tanggal: Hanya Tanggal Bulan Tahun
    String formattedDate = '-';
    if (json['tanggal_kembali'] != null) {
      DateTime dt = DateTime.parse(json['tanggal_kembali']);
      formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dt); 
      // Hasil: 31 Januari 2026
    }

    return PengembalianModel(
      id: json['id_pengembalian'],
      nama: user['nama'] ?? 'Tanpa Nama',
      kode: peminjaman['kode_peminjaman'] ?? '-',
      tanggal: formattedDate,
      terlambatMenit: json['terlambat_menit'] ?? 0,
      dendaTerlambat: json['denda_terlambat'] ?? 0,
      dendaRusak: json['denda_rusak'] ?? 0,
      totalDenda: json['total_denda'] ?? 0,
      catatan: json['catatan_kerusakan'] ?? 'Tidak ada catatan',
      namaAlat: nAlat,
      kodeUnit: kUnit,
      jamSelesai: peminjaman['jam_selesai'] ?? 0,
    );
  }
}