import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class EditPeminjamanDialog extends StatelessWidget {
  final PeminjamanModel data;
  const EditPeminjamanDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color.fromRGBO(62, 159, 127, 1);

    // Kita gunakan MediaQuery untuk cek tinggi layar
    final double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        // Membatasi tinggi maksimal dialog agar tidak mentok layar
        constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Mengikuti tinggi konten
          children: [
            // --- HEADER (Tetap/Sticky) ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Edit Peminjaman',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // --- BODY (Scrollable & Responsive) ---
            Flexible(
              // Pakai Flexible supaya Column di dalamnya bisa scroll
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _label('Kode Peminjaman'),
                    _field(data.kode, enabled: false),
                    const SizedBox(height: 16),

                    _label('Nama Peminjam'),
                    _dropdown('Pilih nama peminjam', value: data.nama),
                    const SizedBox(height: 16),

                    // Row untuk Tanggal (Bisa dibungkus Wrap jika layar sangat sempit)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Tanggal Pinjam'),
                                  _dateField(data.tanggal),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Batas Kembali'),
                                  _dateField(data.tanggal),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Button Row
                    Row(
                      children: [
                        Expanded(
                          child: _btn('Batal', context, isOutlined: true),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _btn('Simpan', context)),
                      ],
                    ),
                    // Padding tambahan di bawah supaya tidak terlalu mepet saat keyboard muncul
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom / 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS (Tetap sama dengan sedikit penyesuaian font) ---
  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Color(0xFF312F34),
      ),
    ),
  );

  Widget _field(String val, {bool enabled = true}) => TextFormField(
    initialValue: val,
    enabled: enabled,
    style: const TextStyle(fontSize: 13),
    decoration: InputDecoration(
      filled: !enabled,
      fillColor: enabled ? Colors.white : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
      ),
    ),
  );

  Widget _dateField(String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFCDEEE2)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            val,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: Color(0xFF3E9F7F),
        ),
      ],
    ),
  );

  Widget _dropdown(String hint, {String? value}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFCDEEE2)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        items: [],
        onChanged: (v) {},
        hint: Text(hint, style: const TextStyle(fontSize: 13)),
      ),
    ),
  );

  Widget _btn(String t, BuildContext ctx, {bool isOutlined = false}) =>
      SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: () async {
            if (isOutlined) {
              Navigator.pop(ctx);
            } else {
              // Logika Simpan ke Supabase
              try {
                await Supabase.instance.client
                    .from('peminjaman')
                    .update({
                      'status': data.status, // Misal ingin ubah status
                      // 'batas_kembali': value_baru,
                    })
                    .eq('id_peminjaman', data.id);

                Navigator.pop(ctx, true); // Tutup dan kirim status sukses
              } catch (e) {
                print('Gagal update: $e');
              }
            }
          },

          child: Text(
            t,
            style: TextStyle(
              color: isOutlined ? const Color(0xFF3E9F7F) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
}
