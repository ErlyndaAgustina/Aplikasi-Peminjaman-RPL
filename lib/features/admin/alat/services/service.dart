import 'package:supabase_flutter/supabase_flutter.dart';
import '../detail_alat/models/model.dart';
import '../models/models.dart';

class AlatService {
  final supabase = Supabase.instance.client;
  Future<List<AlatModel>> fetchAlat() async {
    try {
      final response = await Supabase.instance.client
          .from('alat')
          .select('*, alat_unit(count), kategori(nama_kategori)')
          .order('nama_alat', ascending: true);

      return (response as List).map((data) {
        final int hitungUnit = (data['alat_unit'] as List).isNotEmpty
            ? data['alat_unit'][0]['count'] ?? 0
            : 0;

        return AlatModel.fromMap(data, jumlahUnit: hitungUnit);
      }).toList();
    } catch (e) {
      print("Error Fetch Alat: $e");
      return [];
    }
  }

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

  Future<List<UnitAlatModel>> fetchUnitAlat(String idAlat) async {
    try {
      final res = await supabase
          .from('alat_unit')
          .select()
          .eq('id_alat', idAlat)
          .order('kode_unit', ascending: true);
      return res.map<UnitAlatModel>((e) => UnitAlatModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetchUnitAlat: $e');
      return [];
    }
  }

  Future<void> insertUnitAlat(Map<String, dynamic> data) async {
    await supabase.from('alat_unit').insert(data);
  }

  Future<void> updateUnitAlat(String idUnit, Map<String, dynamic> data) async {
    await supabase.from('alat_unit').update(data).eq('id_unit', idUnit);
  }

  Future<void> deleteUnitAlat(String idUnit) async {
    await supabase.from('alat_unit').delete().eq('id_unit', idUnit);
  }

  Future<AlatModel?> fetchAlatById(String id) async {
    try {
      final res = await supabase
          .from('alat')
          .select('*, kategori(*)')
          .eq('id_alat', id)
          .single();

      return AlatModel.fromMap(res);
    } catch (e) {
      print('Error fetchAlatById: $e');
      return null;
    }
  }
}
