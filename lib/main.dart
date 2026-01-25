import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'features/admin/dashboard/dashboard_page.dart';
import 'features/petugas/dashboard/dashboard_page.dart';
import 'features/petugas/persetujuan_peminjaman/persetujuan_peminjaman_page.dart';
import 'features/petugas/persetujuan_peminjaman/detail_peminjaman/detail_peminjaman_page.dart';
import 'features/petugas/persetujuan_pengembalian/persetujuan_pengembalian_page.dart';
import 'features/petugas/cetak_laporan/cetak_laporan_page.dart';
import 'features/peminjam/dashboard/dashboard_page.dart';
import 'features/peminjam/daftar_alat/daftar_alat_peminjam_page.dart';
import 'features/peminjam/ajukan_pinjaman/ajukan_peminjaman_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AjukanPeminjamanPage(),
    );
  }
}
