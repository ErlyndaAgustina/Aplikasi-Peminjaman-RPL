class LogAktivitasModel {
  final String aksi; // Approve, Create, Update
  final String kategori; // Peminjaman, Alat
  final String deskripsi;
  final String namaUser;
  final String role;
  final String tanggal;
  final String alat;
  final String unit;

  LogAktivitasModel({
    required this.aksi,
    required this.kategori,
    required this.deskripsi,
    required this.namaUser,
    required this.role,
    required this.tanggal,
    required this.alat,
    required this.unit,
  });
}

final List<LogAktivitasModel> logDummy = [
  LogAktivitasModel(
    aksi: 'Approve',
    kategori: 'Peminjaman',
    deskripsi: 'Menyetujui peminjaman Macbook Pro oleh Siti Aminah',
    namaUser: 'Siti Aminah',
    role: 'Petugas',
    tanggal: '12 Oktober 2025',
    alat: 'Macbook Pro',
    unit: 'Unit: LPT-001-U1',
  ),
  LogAktivitasModel(
    aksi: 'Create',
    kategori: 'Peminjaman',
    deskripsi: 'Mengajukan peminjaman Arduino untuk praktikum IoT',
    namaUser: 'Siti Aminah',
    role: 'Peminjam',
    tanggal: '12 Oktober 2025',
    alat: 'Arduino',
    unit: 'Unit: LPT-002-A1',
  ),
  LogAktivitasModel(
    aksi: 'Update',
    kategori: 'Alat',
    deskripsi: 'Memperbarui jumlah stok Proyektor',
    namaUser: 'Erlynda',
    role: 'Admin',
    tanggal: '12 Oktober 2025',
    alat: 'Proyektor',
    unit: 'Unit: LPT-001-P1',
  ),
];
