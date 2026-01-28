class KategoriModel {
  final String nama;
  final String deskripsi;
  final int totalAlat;

  KategoriModel({
    required this.nama,
    required this.deskripsi,
    required this.totalAlat,
  });
}

final kategoriList = [
  KategoriModel(
    nama: 'Perangkat Jaringan',
    deskripsi: 'Router, Switch, Access Point',
    totalAlat: 24,
  ),
  KategoriModel(
    nama: 'Perangkat Komputasi',
    deskripsi: 'PC, Laptop, Monitor',
    totalAlat: 20,
  ),
  KategoriModel(
    nama: 'Perangkat Mobile & IoT',
    deskripsi: 'Arduino, Raspberry Pi',
    totalAlat: 15,
  ),
];