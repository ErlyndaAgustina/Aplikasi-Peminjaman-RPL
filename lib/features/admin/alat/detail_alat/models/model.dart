class UnitAlatModel {
  final String kodeUnit;
  final String kondisi;
  final String status;

  UnitAlatModel({
    required this.kodeUnit,
    required this.kondisi,
    required this.status,
  });
}

final unitAlatList = [
  UnitAlatModel(
    kodeUnit: 'LTP-001-U1',
    kondisi: 'Baik',
    status: 'Tersedia',
  ),
  UnitAlatModel(
    kodeUnit: 'LTP-001-U2',
    kondisi: 'Baik',
    status: 'Dipinjam',
  ),
  UnitAlatModel(
    kodeUnit: 'LTP-001-U3',
    kondisi: 'Mati total',
    status: 'Rusak',
  ),
  UnitAlatModel(
    kodeUnit: 'LTP-001-U4',
    kondisi: 'Keyboard repair',
    status: 'Perbaikan',
  ),
];