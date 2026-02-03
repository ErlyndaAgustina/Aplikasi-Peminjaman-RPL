
enum StatusPengembalian { dikembalikan, selesai }

class PengembalianModel {
  final String id;
  final String nama;
  final String kode;
  final String tanggal;
  final String jam;
  final List<String> alat;
  final StatusPengembalian status;

  const PengembalianModel({
    required this.id,
    required this.nama,
    required this.kode,
    required this.tanggal,
    required this.jam,
    required this.alat,
    required this.status,
  });

  factory PengembalianModel.fromMap(Map<String, dynamic> map) {
  final List detailList = map['detail_peminjaman'] as List? ?? [];
  List<String> daftarNamaAlat = detailList.map((d) {
    final alatUnit = d['alat_unit'];
    if (alatUnit != null && alatUnit['alat'] != null) {
      return alatUnit['alat']['nama_alat']?.toString() ?? '-';
    }
    return '-';
  }).toList();

  return PengembalianModel(
    id: map['id_peminjaman'].toString(),
    nama: map['users']?['nama'] ?? 'Tanpa Nama', 
    kode: map['kode_peminjaman'] ?? '-',
    tanggal: map['tanggal_pinjam'] ?? '-',
    jam: "Jam ke ${map['jam_mulai']}",
    alat: daftarNamaAlat,
    status: map['status'] == 'selesai' 
        ? StatusPengembalian.selesai 
        : StatusPengembalian.dikembalikan,
  );
}

  String get statusLabel => status == StatusPengembalian.selesai ? 'Selesai' : 'Menunggu';
  String get buttonText => status == StatusPengembalian.dikembalikan ? 'Proses Pengembalian' : 'Lihat Detail';
}