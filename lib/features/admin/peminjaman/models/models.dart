class PeminjamanModel {
  final String nama;
  final String kode;
  final String tanggal;
  final String jam;
  final String status;
  final String? catatan;

  PeminjamanModel({
    required this.nama,
    required this.kode,
    required this.tanggal,
    required this.jam,
    required this.status,
    this.catatan,
  });
}

final peminjamanList = [
  PeminjamanModel(
    nama: 'Budi Santoso',
    kode: 'PJM-20260114-d1cb',
    tanggal: '12 Oktober 2025',
    jam: 'Jam 1–5',
    status: 'Dipinjam',
    catatan: 'Batas: 12 Oktober 2025, 10.20',
  ),
  PeminjamanModel(
    nama: 'Siti Aminah',
    kode: 'PJM-20260114-g6ht',
    tanggal: '2 Januari 2026',
    jam: 'Jam 2',
    status: 'Dipinjam',
  ),
  PeminjamanModel(
    nama: 'Andi Wijaya',
    kode: 'PJM-20260114-h7jt',
    tanggal: '13 Januari 2026',
    jam: 'Jam 5–7',
    status: 'Terlambat',
    catatan: 'Terlambat 2 hari',
  ),
];
