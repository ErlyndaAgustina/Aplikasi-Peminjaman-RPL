import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class AlatService {
  final supabase = Supabase.instance.client;

  /// AMBIL SEMUA ALAT (DENGAN JOIN KATEGORI)
  Future<List<AlatModel>> fetchAlat() async {
    try {
      final res = await supabase
          .from('alat')
          .select('*, kategori(*)')
          .order('nama_alat');
      return res.map<AlatModel>((e) => AlatModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetchAlat: $e');
      return [];
    }
  }

  /// AMBIL SEMUA KATEGORI (Hanya satu fungsi saja)
  Future<List<KategoriModel>> getKategori() async {
    try {
      final res = await supabase
          .from('kategori')
          .select()
          .order('nama_kategori', ascending: true);
      
      return res.map<KategoriModel>((e) => KategoriModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getKategori: $e');
      return [];
    }
  }

  /// INSERT
  Future<void> insertAlat(Map<String, dynamic> data) async {
    await supabase.from('alat').insert(data);
  }

  /// UPDATE
  Future<void> updateAlat(String id, Map<String, dynamic> data) async {
    await supabase.from('alat').update(data).eq('id_alat', id);
  }

  /// DELETE
  Future<void> deleteAlat(String id) async {
    await supabase.from('alat').delete().eq('id_alat', id);
  }
}

