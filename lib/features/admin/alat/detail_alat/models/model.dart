class UnitAlatModel {
  final String idUnit;
  final String idAlat;
  final String kodeUnit;
  final String kondisi;
  final String status;
  final String? videoUrl;

  UnitAlatModel({
    required this.idUnit,
    required this.idAlat,
    required this.kodeUnit,
    required this.kondisi,
    required this.status,
    this.videoUrl,
  });

  factory UnitAlatModel.fromMap(Map<String, dynamic> map) {
    return UnitAlatModel(
      idUnit: map['id_unit'] ?? '',
      idAlat: map['id_alat'] ?? '',
      kodeUnit: map['kode_unit'] ?? '',
      kondisi: map['kondisi'] ?? '',
      status: map['status'] ?? '',
      videoUrl: map['video_url'],
    );
  }
}