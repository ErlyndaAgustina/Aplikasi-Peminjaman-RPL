enum StatusPengembalian { dipinjam, selesai }

class PengembalianModel {
  final String nama;
  final String kode;
  final String tanggal;
  final String jam;
  final List<String> alat;
  final StatusPengembalian status;

  const PengembalianModel({
    required this.nama,
    required this.kode,
    required this.tanggal,
    required this.jam,
    required this.alat,
    required this.status,
  });

  String get statusLabel =>
      status == StatusPengembalian.selesai ? 'Selesai' : 'Dipinjam';

  String get buttonText => status == StatusPengembalian.dipinjam
      ? 'Proses Pengembalian'
      : 'Lihat Detail';
}
