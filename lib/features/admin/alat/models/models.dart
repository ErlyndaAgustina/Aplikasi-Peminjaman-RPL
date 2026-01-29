class AlatModel {
  final String id;
  final String nama;
  final String kode;
  final String kategoriId;
  final String kategoriNama;
  final int jumlah;

  AlatModel({
    required this.id,
    required this.nama,
    required this.kode,
    required this.kategoriId,
    required this.kategoriNama,
    required this.jumlah,
  });

  factory AlatModel.fromMap(Map<String, dynamic> map) {
    // Mengambil data dari join query Supabase '*, kategori(*)'
    final kategori = map['kategori'] as Map<String, dynamic>?;
    return AlatModel(
      id: map['id_alat']?.toString() ?? '',
      nama: map['nama_alat'] ?? '',
      kode: map['kode_alat'] ?? '',
      kategoriId: map['id_kategori']?.toString() ?? '',
      kategoriNama: kategori?['nama_kategori'] ?? 'Tanpa Kategori',
      jumlah: map['jumlah'] ?? 0,
    );
  }
}

class KategoriModel {
  final String id;
  final String nama;

  KategoriModel({required this.id, required this.nama});

  factory KategoriModel.fromMap(Map<String, dynamic> map) {
    return KategoriModel(
      id: map['id_kategori'].toString(),
      nama: map['nama_kategori'],
    );
  }
}