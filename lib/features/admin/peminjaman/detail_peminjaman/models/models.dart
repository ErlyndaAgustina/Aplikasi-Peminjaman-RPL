class UnitDipinjamModel {
  final String namaUnit;
  final String kodeUnit;
  final String kondisi;
  final String kategori;

  UnitDipinjamModel({
    required this.namaUnit,
    required this.kodeUnit,
    required this.kondisi,
    required this.kategori,
  });
}

class DetailPeminjamanModel {
  final String namaPeminjam;
  final String kodePeminjaman;
  final String tanggal;
  final String jam;
  final int totalUnit;
  final String status;
  final String catatan;

  DetailPeminjamanModel({
    required this.namaPeminjam,
    required this.kodePeminjaman,
    required this.tanggal,
    required this.jam,
    required this.totalUnit,
    required this.status,
    required this.catatan,
  });
}


final detailPeminjamanDummy = DetailPeminjamanModel(
  namaPeminjam: 'Budi Santoso',
  kodePeminjaman: 'PJM-20260114-d1cb',
  tanggal: '12 Oktober 2025',
  jam: 'Jam 1 - 5',
  totalUnit: 2,
  status: 'Dipinjam',
  catatan: 'Batas: 12 Oktober 2025, 10.20'
);

final List<UnitDipinjamModel> unitDipinjamDummy = [
  UnitDipinjamModel(
    namaUnit: 'Macbook Pro',
    kodeUnit: 'LPT-001-01',
    kondisi: 'Baik',
    kategori: 'Perangkat Komputasi',
  ),
  UnitDipinjamModel(
    namaUnit: 'Arduino',
    kodeUnit: 'LPT-002-01',
    kondisi: 'Baik',
    kategori: 'Perangkat Mobile & IoT',
  ),
];