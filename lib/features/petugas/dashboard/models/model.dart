import 'package:flutter/material.dart';

class TransaksiModel {
  final String namaPeminjam;
  final String alat;
  final String durasi;
  final String status;

  const TransaksiModel({
    required this.namaPeminjam,
    required this.alat,
    required this.durasi,
    required this.status,
  });

  Color get statusColor {
  switch (status.toLowerCase()) {
    case 'dipinjam': return Colors.blue;
    case 'selesai': return Colors.green;
    case 'menunggu': return Colors.grey;
    case 'ditolak': return Colors.red;
    case 'dikembalikan': return Colors.orange; // Tambahkan ini
    default: return Colors.orange;
  }
}

  // Helper untuk mengubah string status database ke label UI
  String get statusLabel => status[0].toUpperCase() + status.substring(1);
}