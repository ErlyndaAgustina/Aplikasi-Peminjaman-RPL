class AlatPinjamModel {
  final String nama;
  final String unitKode;

  AlatPinjamModel({required this.nama, required this.unitKode});
}

// Data Dummy satu file dengan model
final alatTerpilih = AlatPinjamModel(
  nama: 'Macbook Pro',
  unitKode: 'LTP-001-U1',
);