class AlatModel {
  final String idAlat; // Tambahkan ID dari Supabase
  final String nama;
  final String kode;
  final String kategori;
  final int jumlah;

  AlatModel({
    required this.idAlat,
    required this.nama,
    required this.kode,
    required this.kategori,
    required this.jumlah,
  });

  // Factory untuk convert dari JSON Supabase
  factory AlatModel.fromSupabase(Map<String, dynamic> data) {
    // Kita asumsikan relasi ke kategori dan alat_unit sudah di-join
    return AlatModel(
      idAlat: data['id_alat'] ?? '',
      nama: data['nama_alat'] ?? '',
      kode: data['kode_alat'] ?? '',
      kategori: data['kategori']?['nama_kategori'] ?? 'Tanpa Kategori',
      // Menghitung jumlah unit yang statusnya 'tersedia'
      jumlah: (data['alat_unit'] as List?)?.length ?? 0,
    );
  }
}

List<AlatModel> keranjangAlat = [];