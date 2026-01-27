enum StatusTransaksi { dipinjam, terlambat }

class TransaksiModel {
  final String kode;
  final String namaAlat;
  final String idAlat;
  final String tanggal;
  final String jam;
  final String batasKembali;
  final StatusTransaksi status;

  const TransaksiModel({
    required this.kode,
    required this.namaAlat,
    required this.idAlat,
    required this.tanggal,
    required this.jam,
    required this.batasKembali,
    required this.status,
  });
}

final List<TransaksiModel> dummyPeminjaman = [
  const TransaksiModel(
    kode: 'PJM-20260114-g6ht',
    namaAlat: 'Macbook Pro',
    idAlat: 'LTP-001-U1',
    tanggal: '2 Januari 2026',
    jam: 'Jam ke 2',
    batasKembali: '2 Januari 2026, 09.00',
    status: StatusTransaksi.dipinjam,
  ),
  const TransaksiModel(
    kode: 'PJM-20260114-g6ht',
    namaAlat: 'Arduino',
    idAlat: 'LTP-002-A1',
    tanggal: '2 Januari 2026',
    jam: 'Jam ke 2',
    batasKembali: '1 Januari 2026, 09.00',
    status: StatusTransaksi.terlambat,
  ),
];