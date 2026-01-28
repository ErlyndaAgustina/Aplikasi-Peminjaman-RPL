class AlatModel {
  final String nama;
  final String kode;
  final String kategori;
  final int jumlah;

  AlatModel({
    required this.nama,
    required this.kode,
    required this.kategori,
    required this.jumlah,
  });
}

final alatList = [
  AlatModel(
    nama: 'Macbook Pro',
    kode: 'LPT-001',
    kategori: 'Perangkat Komputasi',
    jumlah: 12,
  ),
  AlatModel(
    nama: 'Arduino',
    kode: 'LPT-002',
    kategori: 'Perangkat Mobile & IoT',
    jumlah: 10,
  ),
  AlatModel(
    nama: 'Router',
    kode: 'LPT-003',
    kategori: 'Perangkat Jaringan',
    jumlah: 15,
  ),
];