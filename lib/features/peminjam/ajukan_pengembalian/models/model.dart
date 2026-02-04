// models/model.dart
class TransaksiModel {
  final String id;
  final String kode;
  final String namaAlat;
  final String idAlat;
  final DateTime tanggalPinjam;
  final DateTime batasKembali;
  final String jam; 
  final String status;

  TransaksiModel({
    required this.id,
    required this.kode,
    required this.namaAlat,
    required this.idAlat,
    required this.tanggalPinjam,
    required this.batasKembali,
    required this.jam,
    required this.status,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map) {
  // Ambil list detail_peminjaman
  final List detailList = map['detail_peminjaman'] as List? ?? [];
  
  // Ambil unit dari item pertama jika ada
  Map<String, dynamic>? unit;
  Map<String, dynamic>? alat;
  
  if (detailList.isNotEmpty) {
    unit = detailList[0]['alat_unit'];
    if (unit != null) {
      alat = unit['alat'];
    }
  }

  return TransaksiModel(
    id: map['id_peminjaman'] ?? '',
    kode: map['kode_peminjaman'] ?? '-', 
    namaAlat: alat?['nama_alat'] ?? 'Alat tidak diketahui',
    idAlat: unit?['kode_unit'] ?? '-',
    tanggalPinjam: map['tanggal_pinjam'] != null 
        ? DateTime.parse(map['tanggal_pinjam']) 
        : DateTime.now(),
    batasKembali: map['batas_kembali'] != null 
        ? DateTime.parse(map['batas_kembali']) 
        : DateTime.now(),
    jam: "Jam ke ${map['jam_mulai']?.toString() ?? '?'}",
    status: map['status'] ?? 'dipinjam',
  );
}

  // Helper untuk format tanggal Indonesia manual
  String get tanggalFormatted {
    List months = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun", 
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];
    return "${tanggalPinjam.day} ${months[tanggalPinjam.month - 1]} ${tanggalPinjam.year}";
  }

  String get batasKembaliFormatted {
    List months = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun", 
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];
    return "${batasKembali.day} ${months[batasKembali.month - 1]} ${batasKembali.year}, ${batasKembali.hour.toString().padLeft(2, '0')}.${batasKembali.minute.toString().padLeft(2, '0')}";
  }
}