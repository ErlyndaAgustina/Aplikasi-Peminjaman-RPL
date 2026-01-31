class PeminjamanModel {
  final String id;
  final String nama;
  final String kode;
  final String tanggal;
  final String jam;
  final String status;
  final String? catatan;
  final String batasKembali; // Tambahkan ini
  final int durasiTerlambat; // Tambahkan ini

  PeminjamanModel({
    required this.id,
    required this.nama,
    required this.kode,
    required this.tanggal,
    required this.jam,
    required this.status,
    required this.batasKembali,
    required this.durasiTerlambat,
    this.catatan,
  });

  factory PeminjamanModel.fromSupabase(Map<String, dynamic> map) {
    final userData = map['users'] as Map<String, dynamic>?;
    final namaUser = userData?['nama'] ?? 'Tanpa Nama';
    
    // 1. Format Tanggal Pinjam
    DateTime dtPinjam = DateTime.parse(map['tanggal_pinjam']);
    String tglFormatted = "${dtPinjam.day} ${_getMonthName(dtPinjam.month)} ${dtPinjam.year}";

    // 2. Format Jam Pelajaran (Sesuai request kamu: Jam 1-5)
    String jamPelajaran = "${map['jam_mulai']} - ${map['jam_selesai']}";

    // 3. Format Batas Kembali (Orange)
    DateTime? dtBatas = map['batas_kembali'] != null ? DateTime.parse(map['batas_kembali']) : null;
    String batasFormatted = dtBatas != null 
        ? "${dtBatas.day} ${_getMonthName(dtBatas.month)} ${dtBatas.year}, ${dtBatas.hour.toString().padLeft(2, '0')}:${dtBatas.minute.toString().padLeft(2, '0')}"
        : "-";

    // 4. Hitung Durasi Terlambat
    int terlambatHari = 0;
    if (map['status'] == 'terlambat' && dtBatas != null) {
      terlambatHari = DateTime.now().difference(dtBatas).inDays;
      if (terlambatHari < 0) terlambatHari = 0; // Biar nggak minus
    }

    return PeminjamanModel(
      id: map['id_peminjaman'],
      nama: namaUser,
      kode: map['kode_peminjaman'] ?? '-',
      tanggal: tglFormatted,
      jam: jamPelajaran, // Sekarang isinya "1 - 5"
      status: map['status'] ?? 'dipinjam',
      batasKembali: batasFormatted,
      durasiTerlambat: terlambatHari,
      catatan: map['status'] == 'terlambat' ? 'Melewati batas kembali' : null,
    );
  }

  // Helper untuk nama bulan agar cantik seperti di desain
  static String _getMonthName(int month) {
    const months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
    return months[month - 1];
  }
}