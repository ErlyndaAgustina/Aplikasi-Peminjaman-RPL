enum StatusTransaksi { dipinjam, ditolak, menunggu, dikembalikan, selesai }

class PeminjamTransaksiModel {
  final String kode;
  final String namaAlat;
  final String idAlat;
  final String tanggal;
  final String jam;
  final String batasKembali;
  final StatusTransaksi status;

  const PeminjamTransaksiModel({
    required this.kode,
    required this.namaAlat,
    required this.idAlat,
    required this.tanggal,
    required this.jam,
    required this.batasKembali,
    required this.status,
  });
}