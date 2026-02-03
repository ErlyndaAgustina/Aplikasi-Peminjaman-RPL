import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HapusUnitDialog extends StatelessWidget {
  final String idDetail;
  final String namaUnit;

  const HapusUnitDialog({
    super.key,
    required this.idDetail,
    required this.namaUnit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(25),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 70),
          const SizedBox(height: 20),
          Text(
            "Apakah yakin ingin menghapus Unit $namaUnit?",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color.fromRGBO(49, 47, 52, 1),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(62, 159, 127, 1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Batal",
                    style: TextStyle(
                      color: Color.fromRGBO(62, 159, 127, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    try {
                      final response = await Supabase.instance.client
                          .from('detail_peminjaman')
                          .select('id_unit')
                          .eq('id_detail', idDetail)
                          .single();

                      final String idUnit = response['id_unit'];

                      await Supabase.instance.client
                          .from('detail_peminjaman')
                          .delete()
                          .eq('id_detail', idDetail);

                      await Supabase.instance.client
                          .from('alat_unit')
                          .update({
                            'status': 'tersedia',
                          })
                          .eq('id_unit', idUnit);

                      if (context.mounted) Navigator.pop(context, true);
                    } catch (e) {
                      debugPrint("Gagal memproses penghapusan: $e");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")),
                        );
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Hapus",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
