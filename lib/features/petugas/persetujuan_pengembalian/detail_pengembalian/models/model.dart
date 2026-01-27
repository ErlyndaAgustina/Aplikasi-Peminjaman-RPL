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
  });

  int get totalDenda => dendaKerusakan + dendaTerlambat;
}

// Gunakan data dummy yang sudah terisi untuk simulasi Detail
final dummyDetailPengembalian = PengembalianModel(
  nama: 'Siti Aminah',
  kode: 'PJM-20260114-gh6t',
  tanggalPinjam: '2 Januari 2026',
  jamPelajaran: 'Jam ke 2',
  batasKembali: '2 Januari 2026, 09.00',
  tanggalKembali: '02/01/2026', // Sudah diisi
  jamKembali: '10:30',          // Sudah diisi
  dendaKerusakan: 25000,        // Sudah diisi
  catatan: 'Layar Macbook ada goresan tipis di pojok kanan.',
  dendaTerlambat: 50000,
  units: [
    UnitDipinjam(nama: 'Macbook Pro', kode: 'Unit: LPT-001-U1'),
    UnitDipinjam(nama: 'Arduino', kode: 'Unit: LPT-002-A1'),
  ],
);