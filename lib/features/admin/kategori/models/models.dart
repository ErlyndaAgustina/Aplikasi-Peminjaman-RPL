class KategoriModel {
  final String? id;
  final String nama;
  final String deskripsi;
  final int totalAlat;

  KategoriModel({
    this.id,
    required this.nama,
    required this.deskripsi,
    this.totalAlat = 0,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    // Supabase mengembalikan count dalam bentuk list atau objek nested
    // tergantung query-nya. Kita ambil dari path 'alat'
    final alatCountList = json['alat'] as List?;
    final count = (alatCountList != null && alatCountList.isNotEmpty)
        ? alatCountList[0]['count'] ?? 0
        : 0;

    return KategoriModel(
      id: json['id_kategori'],
      nama: json['nama_kategori'] ?? '',
      deskripsi: json['keterangan'] ?? '',
      totalAlat: count,
    );
  }
}