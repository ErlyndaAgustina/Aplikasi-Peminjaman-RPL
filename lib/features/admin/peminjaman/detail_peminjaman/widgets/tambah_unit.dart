import 'package:flutter/material.dart';

class TambahUnitModal extends StatelessWidget {
  const TambahUnitModal({super.key});

@override
Widget build(BuildContext context) {
  return Dialog(
    // Mengatur warna background dialog agar sedikit transparan jika diinginkan
    // Atau tetap putih tapi pastikan showDialog-nya benar
    backgroundColor: Colors.white, 
    elevation: 0, // Menghilangkan bayangan agar lebih flat dan clean
    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER (Sesuai Gambar: Ada Icon Box & Close Button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color.fromRGBO(62, 159, 127, 1),
            child: Row(
              children: [
                // Icon Box Putih Transparan (Sesuai Gambar)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Tambah Unit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),

          // BODY
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // INFO BOX (Warna Hijau Muda Sesuai Gambar)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(234, 247, 242, 1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info, color: Color.fromRGBO(62, 159, 127, 1), size: 20),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Hanya unit dengan status tersedia yang dapat dipilih untuk ditambahkan ke peminjaman.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(62, 159, 127, 1),
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("Kategori *"),
                  _buildDropdown("Pilih kategori"),

                  const SizedBox(height: 16),

                  _buildLabel("Alat *"),
                  _buildDropdown("Pilih alat"),

                  const SizedBox(height: 16),

                  _buildLabel("Unit Alat *"),
                  _buildDropdown("Pilih unit alat"),

                  const SizedBox(height: 16),

                  _buildLabel("Kondisi Alat *"),
                  _buildTextField("Masukkan kondisi alat"),

                  const SizedBox(height: 30),

                  // BUTTONS (Rounded Buttons)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(color: Color.fromRGBO(62, 159, 127, 1), fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Tambah",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color.fromRGBO(49, 47, 52, 1)),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(62, 159, 127, 1)),
          items: const [],
          onChanged: (val) {},
        ),
      ),
    );
  }
}