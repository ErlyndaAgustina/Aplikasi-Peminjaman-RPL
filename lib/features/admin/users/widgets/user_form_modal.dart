import 'package:flutter/material.dart';
import '../models/model.dart';

class UserFormModal extends StatefulWidget {
  final UserModel? user;
  // Ubah parameter onSave dari UserModel menjadi Map
  final Function(Map<String, dynamic>) onSave;

  const UserFormModal({super.key, this.user, required this.onSave});

  @override
  State<UserFormModal> createState() => _UserFormModalState();
}

class _UserFormModalState extends State<UserFormModal> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController; // Tambahkan ini
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? "");
    emailController = TextEditingController(text: widget.user?.email ?? "");
    passwordController = TextEditingController(); // Inisialisasi kosong
    selectedRole = widget.user?.role ?? "Pilih Role";
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          // Tambahkan scroll agar aman saat keyboard muncul
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(isEdit),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Nama Lengkap *"),
                    _textField(nameController, "Contoh: Baskara El Patron"),
                    const SizedBox(height: 12),
                    _label("Email *"),
                    _textField(emailController, "baskara@brantas.sch.id"),

                    // Input Password hanya muncul saat Tambah Pengguna Baru
                    if (!isEdit) ...[
                      const SizedBox(height: 12),
                      _label("Password *"),
                      _textField(
                        passwordController,
                        "Minimal 6 karakter",
                        isPassword: true,
                      ),
                    ],

                    const SizedBox(height: 12),
                    _label("Role"),
                    _dropdownRole(),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, isEdit),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isEdit) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(
                color: Color.fromRGBO(62, 159, 127, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            // Di UserFormModal - Bagian onPressed tombol simpan/tambah
            onPressed: () {
              // 1. Cek Nama & Email tidak kosong
              if (nameController.text.isEmpty || emailController.text.isEmpty) {
                _showSnackBar("Nama dan Email wajib diisi!");
                return;
              }

              // 2. Cek apakah Role sudah dipilih
              if (selectedRole == "Pilih Role") {
                _showSnackBar("Silakan pilih Role terlebih dahulu!");
                return;
              }

              // 3. Validasi Password (untuk tambah baru)
              if (widget.user == null && passwordController.text.length < 6) {
                _showSnackBar("Password minimal 6 karakter");
                return;
              }

              // 4. Validasi Format Email
              final email = emailController.text.trim().toLowerCase();
              bool emailValid = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(email);

              if (!emailValid) {
                _showSnackBar("Format email tidak valid!");
                return;
              }

              // Jika semua lolos, baru panggil onSave
              widget.onSave({
                'nama': nameController.text.trim(),
                'email': email,
                'password': passwordController.text,
                'role': selectedRole
                    .toLowerCase(), // Pastikan dikirim dalam huruf kecil
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
            ),
            child: Text(
              isEdit ? "Simpan" : "Tambah",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isEdit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(62, 159, 127, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isEdit ? Icons.edit_square : Icons.add_circle,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isEdit ? "Edit Pengguna" : "Tambah Pengguna",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // --- Helper Form Widgets (pindahkan helper methods ke sini) ---
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    ),
  );

  Widget _textField(
    TextEditingController ctrl,
    String hint, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromRGBO(62, 159, 127, 1)),
        ),
      ),
    );
  }

  Widget _dropdownRole() {
    // Pastikan value yang dikirim ke Dropdown disesuaikan formatnya
    // Kita buat daftar role yang konsisten (huruf kapital di tampilan, kecil di value)
    final List<String> roleOptions = ['admin', 'petugas', 'peminjam'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // Pakai toLowerCase() supaya matching dengan daftar roleOptions
          value: (selectedRole == "Pilih Role" || selectedRole.isEmpty)
              ? null
              : selectedRole.toLowerCase(),
          hint: const Text(
            "Pilih Role",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          isExpanded: true,
          items: roleOptions.map((val) {
            return DropdownMenuItem(
              value: val, // ini 'admin' (kecil)
              child: Text(
                val[0].toUpperCase() + val.substring(1),
              ), // ini 'Admin' (Tampilan saja yang besar)
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              selectedRole = val!;
            });
          },
        ),
      ),
    );
  }
}
