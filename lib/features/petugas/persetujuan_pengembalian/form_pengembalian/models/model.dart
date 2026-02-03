import 'package:intl/intl.dart';

class UnitDipinjam {
  final String nama;
  final String kode;

  UnitDipinjam({
    required this.nama,
    required this.kode,
  });
}

class PengembalianModel {
  final String nama;
  final String kode;
  final String tanggalPinjam;
  final String jamPelajaran;
  final String batasKembali;
  final String batasKembaliRaw;

  String tanggalKembali;
  String jamKembali;
  int dendaKerusakan;
  int dendaTerlambat;
  String catatan;

  final List<UnitDipinjam> units;

  PengembalianModel({
    required this.nama,
    required this.kode,
    required this.tanggalPinjam,
    required this.jamPelajaran,
    required this.batasKembali,
    this.tanggalKembali = '',
    this.jamKembali = '',
    this.dendaKerusakan = 0,
    this.dendaTerlambat = 0,
    this.catatan = '',
    required this.units,
    required this.batasKembaliRaw,
  });

  int get totalDenda => dendaKerusakan + dendaTerlambat;

  factory PengembalianModel.fromSupabase(Map<String, dynamic> map) {
    final user = map['users'] as Map<String, dynamic>?;
    final details = map['detail_peminjaman'] as List? ?? [];
    
    List<UnitDipinjam> mappedUnits = details.map((d) {
      final unit = d['alat_unit'];
      final alat = unit?['alat'];
      return UnitDipinjam(
        nama: alat?['nama_alat'] ?? 'Tidak diketahui',
        kode: unit?['kode_unit'] ?? '-',
      );
    }).toList();

    return PengembalianModel(
      nama: user?['nama'] ?? 'Tanpa Nama',
      kode: map['kode_peminjaman'] ?? '-',
      // PERBAIKAN DI SINI:
      batasKembaliRaw: map['batas_kembali'] ?? DateTime.now().toIso8601String(),
      tanggalPinjam: _formatTanggalIndo(map['tanggal_pinjam']),
      batasKembali: _formatTanggalIndo(map['batas_kembali']),
      jamPelajaran: "Jam ${map['jam_mulai']} - ${map['jam_selesai']}",
      units: mappedUnits,
    );
  }
}

String _formatTanggalIndo(String? tanggalRaw) {
  if (tanggalRaw == null || tanggalRaw == '-' || tanggalRaw.isEmpty) return '-';
  try {
    DateTime date = DateTime.parse(tanggalRaw);
    return DateFormat('d MMMM y, HH:mm', 'id_ID').format(date);
  } catch (e) {
    return tanggalRaw;
  }
}