class PeminjamanModel {
  final String id;
  final String nama;
  final String kode;
  final String tanggal;
  final String jam;
  final String status;
  final String? catatan;
  final String batasKembali;
  final int durasiTerlambat;
  final String idPeminjaman; // Ini yang kita panggil di navigasi

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
    required this.idPeminjaman,
  });

  factory PeminjamanModel.fromSupabase(Map<String, dynamic> map) {
    final userData = map['users'] as Map<String, dynamic>?;
    final namaUser = userData?['nama'] ?? 'Tanpa Nama';

    // 1. Format Tanggal Pinjam
    DateTime dtPinjam = DateTime.parse(map['tanggal_pinjam']);
    String tglFormatted =
        "${dtPinjam.day} ${_getMonthName(dtPinjam.month)} ${dtPinjam.year}";

    // 2. Format Jam Pelajaran
    String jamPelajaran = "Jam ${map['jam_mulai']} - ${map['jam_selesai']}";

    // 3. Format Batas Kembali
    DateTime? dtBatas = map['batas_kembali'] != null
        ? DateTime.parse(map['batas_kembali'])
        : null;
    String batasFormatted = dtBatas != null
        ? "${dtBatas.day} ${_getMonthName(dtBatas.month)} ${dtBatas.year}, ${dtBatas.hour.toString().padLeft(2, '0')}:${dtBatas.minute.toString().padLeft(2, '0')}"
        : "-";

    // 4. Hitung Durasi Terlambat
    int terlambatHari = 0;
    if (map['status'] == 'terlambat' && dtBatas != null) {
      // Ambil tanggal hari ini tanpa jam (00:00)
      DateTime today = DateTime.now();
      DateTime todayDate = DateTime(today.year, today.month, today.day);

      // Ambil tanggal batas tanpa jam (00:00)
      DateTime batasDate = DateTime(dtBatas.year, dtBatas.month, dtBatas.day);

      // Hitung selisih harinya
      terlambatHari = todayDate.difference(batasDate).inDays;

      if (terlambatHari < 0) terlambatHari = 0;
    }

    return PeminjamanModel(
      id: map['id_peminjaman'] ?? '',
      nama: namaUser,
      kode: map['kode_peminjaman'] ?? '-',
      tanggal: tglFormatted,
      jam: jamPelajaran,
      status: map['status'] ?? 'dipinjam',
      batasKembali: batasFormatted,
      durasiTerlambat: terlambatHari,
      catatan: map['status'] == 'terlambat' ? 'Melewati batas kembali' : null,
      idPeminjaman: map['id_peminjaman'] ?? '',
    );
  }

  static String _getMonthName(int month) {
    const months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return months[month - 1];
  }
}
