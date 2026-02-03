class DetailPeminjamanModel {
  final String idPeminjaman;
  final String namaPeminjam;
  final String kodePeminjaman;
  final String tanggal;
  final String jam;
  final int totalUnit;
  final String status;
  final String catatan;

  DetailPeminjamanModel({
    required this.idPeminjaman,
    required this.namaPeminjam,
    required this.kodePeminjaman,
    required this.tanggal,
    required this.jam,
    required this.totalUnit,
    required this.status,
    required this.catatan,
  });

  factory DetailPeminjamanModel.fromJson(Map<String, dynamic> json) {
  final listDetail = json['detail_peminjaman'] as List? ?? [];
  
  String batasFormatted = "-";
  if (json['batas_kembali'] != null) {
    DateTime dtBatas = DateTime.parse(json['batas_kembali']);
    const months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
    
    batasFormatted = "Batas: ${dtBatas.day} ${months[dtBatas.month - 1]} ${dtBatas.year}, ${dtBatas.hour.toString().padLeft(2, '0')}:${dtBatas.minute.toString().padLeft(2, '0')}";
  }

  return DetailPeminjamanModel(
    idPeminjaman: json['id_peminjaman'],
    namaPeminjam: json['users']['nama'],
    kodePeminjaman: json['kode_peminjaman'],
    tanggal: json['tanggal_pinjam'], 
    jam: "Jam ${json['jam_mulai']} - ${json['jam_selesai']}",
    totalUnit: listDetail.length,
    status: json['status'],
    catatan: batasFormatted,
  );
}
}

class UnitDipinjamModel {
  final String idDetail;
  final String namaUnit;
  final String kodeUnit;
  final String kondisi;
  final String kategori;

  UnitDipinjamModel({
    required this.idDetail,
    required this.namaUnit,
    required this.kodeUnit,
    required this.kondisi,
    required this.kategori,
  });

  factory UnitDipinjamModel.fromJson(Map<String, dynamic> json) {
    final unit = json['alat_unit'];
    final alat = unit['alat'];
    return UnitDipinjamModel(
      idDetail: json['id_detail'],
      namaUnit: alat['nama_alat'],
      kodeUnit: unit['kode_unit'],
      kondisi: unit['kondisi'],
      kategori: alat['kategori']['nama_kategori'],
    );
  }
}