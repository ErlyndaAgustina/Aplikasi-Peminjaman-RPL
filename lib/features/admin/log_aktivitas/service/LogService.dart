import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/model.dart';

class LogService {
  final _supabase = Supabase.instance.client;

  Future<List<LogAktivitasModel>> fetchLogs() async {
    try {
      final response = await _supabase
          .from('log_aktivitas')
          .select('''
            *,
            users (nama, role),
            log_aktivitas_alat (
              alat_unit (
                kode_unit,
                alat (nama_alat)
              )
            )
          ''')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => LogAktivitasModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Error fetch log: $e');
      return [];
    }
  }
}