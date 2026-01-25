import 'dart:ui';
import 'package:flutter/material.dart';

enum StatusPeminjaman {
  menunggu,
  disetujui,
  ditolak,
}

extension StatusExt on StatusPeminjaman {
  String get label {
    switch (this) {
      case StatusPeminjaman.menunggu:
        return 'Menunggu';
      case StatusPeminjaman.disetujui:
        return 'Disetujui';
      case StatusPeminjaman.ditolak:
        return 'Ditolak';
    }
  }

  Color get color {
    switch (this) {
      case StatusPeminjaman.menunggu:
        return Color.fromRGBO(1, 85, 56, 1);
      case StatusPeminjaman.disetujui:
        return Color.fromRGBO(235, 98, 26, 1);
      case StatusPeminjaman.ditolak:
        return Color.fromRGBO(255, 2, 2, 1);
    }
  }

  Color get bgColor {
    switch (this) {
      case StatusPeminjaman.menunggu:
        return Color.fromRGBO(217, 253, 240, 1);
      case StatusPeminjaman.disetujui:
        return Color.fromRGBO(255, 237, 213, 1);
      case StatusPeminjaman.ditolak:
        return Color.fromRGBO(255, 119, 119, 0.22);
    }
  }
}

class DetailPeminjamanModel {
  final String nama;
  final String kode;
  final StatusPeminjaman status;
  final String tanggalPinjam;
  final String jamPelajaran;
  final String batasKembali;
  final List<UnitPinjamanModel> units;

  DetailPeminjamanModel({
    required this.nama,
    required this.kode,
    required this.status,
    required this.tanggalPinjam,
    required this.jamPelajaran,
    required this.batasKembali,
    required this.units,
  });
}

class UnitPinjamanModel {
  final String nama;
  final String kategori;
  final String kode;

  UnitPinjamanModel({
    required this.nama,
    required this.kategori,
    required this.kode,
  });
}

/// 🔥 GANTI STATUS DI SINI UNTUK TES UI
final dummyDetailPeminjaman = DetailPeminjamanModel(
  nama: 'Budi Santoso',
  kode: 'PJM-20260114-dcb',
  status: StatusPeminjaman.menunggu, // ← coba ganti
  tanggalPinjam: '2 Januari 2026',
  jamPelajaran: '2 - 3',
  batasKembali: '2 Januari 2026, 09.00',
  units: [
    UnitPinjamanModel(
      nama: 'Macbook Pro',
      kategori: 'Perangkat Komputasi',
      kode: 'LPT-001-U1',
    ),
    UnitPinjamanModel(
      nama: 'Macbook Pro',
      kategori: 'Perangkat Komputasi',
      kode: 'LPT-001-U2',
    ),
  ],
);
