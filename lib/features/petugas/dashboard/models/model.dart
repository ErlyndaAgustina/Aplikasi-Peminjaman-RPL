import 'package:flutter/material.dart';

enum StatusTransaksi {
  dipinjam,
  selesai,
  terlambat,
}

class TransaksiModel {
  final String namaPeminjam;
  final String alat;
  final String durasi;
  final StatusTransaksi status;

  const TransaksiModel({
    required this.namaPeminjam,
    required this.alat,
    required this.durasi,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case StatusTransaksi.dipinjam:
        return Colors.blue;
      case StatusTransaksi.selesai:
        return Colors.green;
      case StatusTransaksi.terlambat:
        return Colors.red;
    }
  }

  String get statusLabel {
    switch (status) {
      case StatusTransaksi.dipinjam:
        return 'Dipinjam';
      case StatusTransaksi.selesai:
        return 'Selesai';
      case StatusTransaksi.terlambat:
        return 'Terlambat';
    }
  }
}

/// =======================
/// DUMMY PEMINJAMAN AKTIF
/// =======================
final List<TransaksiModel> dummyPeminjamanAktif = [
  TransaksiModel(
    namaPeminjam: 'Budi Santoso',
    alat: 'Macbook Pro, Arduino',
    durasi: 'Jam 1 - 5',
    status: StatusTransaksi.dipinjam,
  ),
  TransaksiModel(
    namaPeminjam: 'Siti Aminah',
    alat: 'Macbook Pro',
    durasi: 'Jam 1 - 5',
    status: StatusTransaksi.terlambat,
  ),
];

/// =======================
/// DUMMY PENGEMBALIAN
/// =======================
final List<TransaksiModel> dummyPengembalianTerbaru = [
  TransaksiModel(
    namaPeminjam: 'Budi Santoso',
    alat: 'Macbook Pro, Arduino',
    durasi: 'Jam 1 - 5',
    status: StatusTransaksi.selesai,
  ),
  TransaksiModel(
    namaPeminjam: 'Siti Aminah',
    alat: 'Macbook Pro',
    durasi: 'Jam 1 - 5',
    status: StatusTransaksi.terlambat,
  ),
];
