import 'package:intl/intl.dart';

class PeminjamanModel {
  final String idPeminjaman;
  final String nama;
  final String kode;
  final DateTime tanggal;
  final int jamMulai;
  final int jamSelesai;
  final String status;
  final List<String> alat;

  PeminjamanModel({
    required this.idPeminjaman,
    required this.nama,
    required this.kode,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.status,
    this.alat = const [],
  });

  // Ini yang kamu minta, hasilnya: "03 Februari 2026"
  String get tanggalFormat => DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal);

  // Tambahan: Format jam biar rapi (Contoh: 08:00 - 10:00)
  String get durasiPinjam => 
      "${jamMulai.toString().padLeft(2, '0')}:00 - ${jamSelesai.toString().padLeft(2, '0')}:00";

  factory PeminjamanModel.fromMap(Map<String, dynamic> map) {
  final userData = map['users'] as Map<String, dynamic>?;
  final namaUser = userData?['nama'] ?? 'User';

  List<String> listAlat = [];
  // Ambil detail_peminjaman dari map yang sama
  if (map['detail_peminjaman'] != null) {
    final details = map['detail_peminjaman'] as List;
    for (var item in details) {
      final namaAlat = item['alat_unit']?['alat']?['nama_alat'];
      if (namaAlat != null) {
        listAlat.add(namaAlat.toString());
      }
    }
  }

  return PeminjamanModel(
    idPeminjaman: map['id_peminjaman']?.toString() ?? '',
    nama: namaUser,
    kode: map['kode_peminjaman'] ?? '-',
    tanggal: map['tanggal_pinjam'] != null 
        ? DateTime.parse(map['tanggal_pinjam']) 
        : DateTime.now(),
    jamMulai: map['jam_mulai'] ?? 0,
    jamSelesai: map['jam_selesai'] ?? 0,
    status: map['status'] ?? 'menunggu',
    alat: listAlat,
  );
}
}