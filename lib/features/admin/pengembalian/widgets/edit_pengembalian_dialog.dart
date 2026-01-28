import 'package:flutter/material.dart';
import '../models/model.dart';

class EditPengembalianDialog extends StatelessWidget {
  final PengembalianModel data;
  const EditPengembalianDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _inputLabel('Nama Peminjam'),
                    _dropdown(data.nama),
                    
                    _inputLabel('Kode Peminjaman'),
                    _dropdown(data.kode),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _inputLabel('Kembali Pada'),
                              _dateField(data.tanggal),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _inputLabel('Jam ke'),
                              _textField('2'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    _inputLabel('Unit yang dikembalikan'),
                    _dropdown('Macbook Pro\nKode: LPT-001-U1'),
                    
                    _inputLabel('Terlambat'),
                    _textField('${data.terlambatMenit} menit'),

                    // --- BAGIAN YANG DIPERBAIKI (TAMBAHAN FIELD) ---
                    _inputLabel('Denda Terlambat'),
                    _textField('Rp 0'),
                    
                    _inputLabel('Denda Rusak'),
                    _textField('Rp 0'),
                    
                    _inputLabel('Catatan Kerusakan'),
                    _textField('Tidak ada kerusakan apapun'),
                    // ----------------------------------------------

                    _inputLabel('Total Denda'),
                    _textField('Rp ${data.totalDenda}'),
                    
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _btn('Batal', context, isOutlined: true)),
                        const SizedBox(width: 12),
                        Expanded(child: _btn('Simpan', context)),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF3E9F7F),
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
            child: const Icon(Icons.edit, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Edit Pengembalian',
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
    );
  }

  Widget _inputLabel(String t) => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          t,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF312F34),
          ),
        ),
      );

  Widget _textField(String val) => TextFormField(
        initialValue: val,
        style: const TextStyle(fontSize: 13, color: Color(0xFF3E9F7F)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCDEEE2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3E9F7F)),
          ),
        ),
      );

  Widget _dropdown(String val) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCDEEE2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF3E9F7F)),
            value: val,
            items: [
              DropdownMenuItem(
                value: val,
                child: Text(
                  val,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF3E9F7F)),
                ),
              )
            ],
            onChanged: (v) {},
          ),
        ),
      );

  Widget _dateField(String val) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCDEEE2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              val,
              style: const TextStyle(fontSize: 13, color: Color(0xFF3E9F7F)),
            ),
            const Spacer(),
            const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF3E9F7F)),
          ],
        ),
      );

  Widget _btn(String t, BuildContext ctx, {bool isOutlined = false}) => SizedBox(
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isOutlined ? Colors.white : const Color(0xFF3E9F7F),
            side: const BorderSide(color: Color(0xFFCDEEE2)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            t,
            style: TextStyle(
              color: isOutlined ? const Color(0xFF3E9F7F) : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}