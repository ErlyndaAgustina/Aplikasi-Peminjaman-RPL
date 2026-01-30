class LogAktivitasModel {
  final String aksi;
  final String kategori;
  final String deskripsi;
  final String namaUser;
  final String role;
  final String tanggal;
  final String alat;
  final String unit;

  LogAktivitasModel({
    required this.aksi,
    required this.kategori,
    required this.deskripsi,
    required this.namaUser,
    required this.role,
    required this.tanggal,
    required this.alat,
    required this.unit,
  });

  factory LogAktivitasModel.fromMap(Map<String, dynamic> map) {
    // Mengambil data user dari join
    final userData = map['users'] ?? {};
    
    // Mengambil data unit & alat dari join log_aktivitas_alat
    // Kita ambil data pertama jika ada
    final logAlat = (map['log_aktivitas_alat'] as List).isNotEmpty 
        ? map['log_aktivitas_alat'][0] 
        : null;
    
    final unitData = logAlat?['alat_unit'] ?? {};
    final alatData = unitData['alat'] ?? {};

    return LogAktivitasModel(
      aksi: map['aksi'] ?? '-',
      kategori: map['entitas'] ?? '-', // Di DB kolomnya 'entitas'
      deskripsi: map['deskripsi'] ?? '-',
      namaUser: userData['nama'] ?? 'System',
      role: userData['role'] ?? '-',
      tanggal: map['created_at'] != null 
          ? _formatTanggal(map['created_at']) 
          : '-',
      alat: alatData['nama_alat'] ?? 'Tidak ada alat',
      unit: unitData['kode_unit'] != null 
          ? 'Unit: ${unitData['kode_unit']}' 
          : 'Unit: -',
    );
  }

  static String _formatTanggal(String raw) {
    DateTime dt = DateTime.parse(raw).toLocal();
    List<String> bulan = [
      "", "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return "${dt.day} ${bulan[dt.month]} ${dt.year}";
  }
}