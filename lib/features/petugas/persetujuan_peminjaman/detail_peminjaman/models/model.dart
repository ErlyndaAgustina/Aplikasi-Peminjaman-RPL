import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        return const Color.fromRGBO(1, 85, 56, 1);
      case StatusPeminjaman.disetujui:
        return const Color.fromRGBO(235, 98, 26, 1);
      case StatusPeminjaman.ditolak:
        return const Color.fromRGBO(255, 2, 2, 1);
    }
  }

  Color get bgColor {
    switch (this) {
      case StatusPeminjaman.menunggu:
        return const Color.fromRGBO(217, 253, 240, 1);
      case StatusPeminjaman.disetujui:
        return const Color.fromRGBO(255, 237, 213, 1);
      case StatusPeminjaman.ditolak:
        return const Color.fromRGBO(255, 119, 119, 0.22);
    }
  }
}

class DetailPeminjamanModel {
  final String nama;
  final String kode;
  final StatusPeminjaman status;
 final DateTime tanggalPinjam; // Ubah ke DateTime
  final String jamPelajaran;
  final DateTime batasKembali;  // Ubah ke DateTime
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

  String get tanggalPinjamFormat => 
      DateFormat('dd MMMM yyyy', 'id_ID').format(tanggalPinjam);

  // Getter untuk format "03 Februari 2026, 10:14"
  String get batasKembaliFormat => 
      DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(batasKembali);

  // Fungsi untuk konversi dari JSON Supabase ke Model
  factory DetailPeminjamanModel.fromMap(Map<String, dynamic> map) {
    // Parsing Status
    StatusPeminjaman currentStatus;
    switch (map['status']?.toString().toLowerCase()) {
      case 'dipinjam':
        currentStatus = StatusPeminjaman.disetujui;
        break;
      case 'ditolak':
        currentStatus = StatusPeminjaman.ditolak;
        break;
      default:
        currentStatus = StatusPeminjaman.menunggu;
    }

    // Parsing List Unit dari detail_peminjaman
    List<UnitPinjamanModel> listUnit = [];
    if (map['detail_peminjaman'] != null) {
      for (var item in (map['detail_peminjaman'] as List)) {
        final unitData = item['alat_unit'];
        if (unitData != null) {
          listUnit.add(UnitPinjamanModel(
            nama: unitData['alat']?['nama_alat'] ?? 'Alat Tidak Diketahui',
            kategori: unitData['alat']?['kategori']?['nama_kategori'] ?? 'Umum',
            kode: unitData['kode_unit'] ?? '-',
          ));
        }
      }
    }

    return DetailPeminjamanModel(
      nama: map['users']?['nama'] ?? 'Tanpa Nama',
      kode: map['kode_peminjaman'] ?? '-',
      status: currentStatus,
      // Parsing string dari database ke DateTime
      tanggalPinjam: map['tanggal_pinjam'] != null 
          ? DateTime.parse(map['tanggal_pinjam']) 
          : DateTime.now(),
      jamPelajaran: "${map['jam_mulai'] ?? 0} - ${map['jam_selesai'] ?? 0}",
      // Parsing batas_kembali
      batasKembali: map['batas_kembali'] != null 
          ? DateTime.parse(map['batas_kembali']) 
          : DateTime.now(),
      units: listUnit,
    );
  }
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