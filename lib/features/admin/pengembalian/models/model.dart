class PengembalianModel {
  final String nama;
  final String kode;
  final String tanggal;
  final int terlambatMenit;
  final int totalDenda;
  final bool selesai;

  PengembalianModel({
    required this.nama,
    required this.kode,
    required this.tanggal,
    required this.terlambatMenit,
    required this.totalDenda,
    required this.selesai,
  });
}

final List<PengembalianModel> dummyPengembalian = [
  PengembalianModel(
    nama: 'Siti Aminah',
    kode: 'PJM-20260114-gfh',
    tanggal: '2 Januari 2026',
    terlambatMenit: 0,
    totalDenda: 0,
    selesai: true,
  ),
  PengembalianModel(
    nama: 'Dewangga Putra',
    kode: 'PJM-20260114-tt8',
    tanggal: '2 Januari 2026',
    terlambatMenit: 44,
    totalDenda: 45000,
    selesai: true,
  ),
  PengembalianModel(
    nama: 'Hanzel Frey',
    kode: 'PJM-20260114-t8u',
    tanggal: '6 Januari 2026',
    terlambatMenit: 0,
    totalDenda: 30000,
    selesai: true,
  ),
];
