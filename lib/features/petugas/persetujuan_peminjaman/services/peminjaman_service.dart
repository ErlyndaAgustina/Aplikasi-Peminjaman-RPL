import 'package:supabase_flutter/supabase_flutter.dart';
import '../detail_peminjaman/models/model.dart';
import '../models/model.dart';

class PeminjamanService {
  final supabase = Supabase.instance.client;

  // PASTIKAN FUNGSI INI ADA DAN NAMANYA PERSIS 'fetchPeminjaman'
  Future<List<PeminjamanModel>> fetchPeminjaman(String status) async {
  try {
    final response = await supabase
        .from('peminjaman')
        .select('''
          *, 
          users(nama),
          detail_peminjaman(
            alat_unit(
              alat(nama_alat)
            )
          )
        ''') // Ditambah detail_peminjaman supaya model.fromMap bisa baca alatnya
        .eq('status', status)
        .order('created_at', ascending: false);

    // Casting ke List<PeminjamanModel> dengan eksplisit
    final dataList = response as List;
    return dataList.map((data) => PeminjamanModel.fromMap(data)).toList();
  } catch (e) {
    print('Error fetch peminjaman: $e');
    return [];
  }
}
  Future<DetailPeminjamanModel?> fetchDetailPeminjaman(String id) async {
    try {
      final response = await supabase
          .from('peminjaman')
          .select('''
            *,
            users(nama),
            detail_peminjaman(
              alat_unit(
                kode_unit,
                alat(nama_alat, kategori(nama_kategori))
              )
            )
          ''')
          .eq('id_peminjaman', id)
          .single();

      return DetailPeminjamanModel.fromMap(response);
    } catch (e) {
      print('Error detail: $e');
      return null;
    }
  }

  // Fungsi Update Status
  Future<void> updateStatus(String id, String status) async {
    await supabase
        .from('peminjaman')
        .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id_peminjaman', id);
  }
}