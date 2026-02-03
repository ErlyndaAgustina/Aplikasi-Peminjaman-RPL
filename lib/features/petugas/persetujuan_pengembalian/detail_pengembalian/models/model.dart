import 'package:intl/intl.dart';

class UnitDipinjam {
  final String nama;
  final String kode;

  UnitDipinjam({
    required this.nama,
    required this.kode,
  });
}

class DetailPengembalianModel {
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
  int terlambatMenit;
  String catatan;

  final List<UnitDipinjam> units;

  DetailPengembalianModel({
    required this.nama,
    required this.kode,
    required this.tanggalPinjam,
    required this.jamPelajaran,
    required this.batasKembali,
    required this.batasKembaliRaw,
    this.tanggalKembali = '',
    this.jamKembali = '',
    this.dendaKerusakan = 0,
    this.dendaTerlambat = 0,
    this.terlambatMenit = 0,
    this.catatan = '',
    required this.units,
  });

  int get totalDenda => dendaKerusakan + dendaTerlambat;

  factory DetailPengembalianModel.fromDetailSupabase(Map<String, dynamic> map) {
    final user = map['users'] as Map<String, dynamic>?;
    
    final pengembalianList = map['pengembalian'] as List?;
    final pengembalian = (pengembalianList != null && pengembalianList.isNotEmpty) 
        ? pengembalianList[0] 
        : {};

    final details = map['detail_peminjaman'] as List? ?? [];

    List<UnitDipinjam> mappedUnits = details.map((d) {
      final unit = d['alat_unit'];
      final alat = unit?['alat'];
      return UnitDipinjam(
        nama: alat?['nama_alat'] ?? 'Tidak diketahui',
        kode: unit?['kode_unit'] ?? '-',
      );
    }).toList();

    return DetailPengembalianModel(
      nama: user?['nama'] ?? 'Tanpa Nama',
      kode: map['kode_peminjaman'] ?? '-',
      batasKembaliRaw: map['batas_kembali'] ?? '',
      tanggalPinjam: _formatTanggalIndo(map['tanggal_pinjam']),
      batasKembali: _formatTanggalIndo(map['batas_kembali']),
      jamPelajaran: "Jam ${map['jam_mulai']} - ${map['jam_selesai']}",
      
      // Data dari tabel pengembalian (ambil dari kolom di database)
      tanggalKembali: _formatTanggalIndo(pengembalian['tanggal_kembali']),
      jamKembali: _formatJam(pengembalian['tanggal_kembali']),
      dendaKerusakan: pengembalian['denda_rusak'] ?? 0,
      dendaTerlambat: pengembalian['denda_terlambat'] ?? 0,
      terlambatMenit: pengembalian['terlambat_menit'] ?? 0, // <--- Ambil dari kolom DB
      catatan: pengembalian['catatan_kerusakan'] ?? '-',
      units: mappedUnits,
    );
  }

  // 3. Pindahkan helper ke dalam class atau jadikan fungsi static agar bisa diakses factory
  static String _formatTanggalIndo(String? tanggalRaw) {
    if (tanggalRaw == null || tanggalRaw.isEmpty) return '-';
    try {
      DateTime date = DateTime.parse(tanggalRaw);
      return DateFormat('d MMMM y, HH:mm', 'id_ID').format(date);
    } catch (e) {
      return tanggalRaw;
    }
  }

  static String _formatJam(String? tanggalRaw) {
    if (tanggalRaw == null || tanggalRaw.isEmpty) return '-';
    try {
      DateTime date = DateTime.parse(tanggalRaw);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '-';
    }
  }
}