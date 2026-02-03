import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_styles.dart';
import '../../../features/admin/dashboard/dashboard_page.dart';
import '../../../features/peminjam/dashboard/dashboard_page.dart';
import '../../../features/petugas/dashboard/dashboard_page.dart';

class LoginCard extends StatefulWidget {
  final String roboto;
  const LoginCard({super.key, required this.roboto});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variabel untuk menyimpan pesan error di bawah field
  String? _errorEmail;
  String? _errorPassword;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 1. Fungsi Validasi Input Manual
  bool _validateInputs() {
    setState(() {
      _errorEmail = null;
      _errorPassword = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool isValid = true;

    if (email.isEmpty) {
      _errorEmail = 'Email tidak boleh kosong';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _errorEmail = 'Format email tidak sesuai';
      isValid = false;
    }

    if (password.isEmpty) {
      _errorPassword = 'Password tidak boleh kosong';
      isValid = false;
    } else if (password.length < 6) {
      _errorPassword = 'Password minimal 6 karakter';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  // 2. Fungsi Eksekusi Login ke Supabase
  Future<void> _handleLogin() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final authResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = authResponse.user;
      if (user == null) return;

      final data = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('auth_user_id', user.id)
          .single();
      
      final role = data['role'];

      if (!mounted) return;

      // Berhasil login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardAdminPage()));
      } else if (role == 'petugas') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPetugasPage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPeminjamPage()));
      }
    } on AuthException catch (e) {
      setState(() {
        // Validasi Password salah vs Email salah dari server
        if (e.message.toLowerCase().contains('invalid login credentials')) {
          _errorEmail = 'Email mungkin salah';
          _errorPassword = 'Password mungkin salah';
        } else if (e.message.toLowerCase().contains('email not found')) {
          _errorEmail = 'Email tidak ditemukan';
        } else {
          _errorEmail = e.message;
        }
      });
    } catch (e) {
      // Validasi Jaringan tidak tersedia
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jaringan tidak tersedia atau gangguan server'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang',
            style: TextStyle(
              fontFamily: widget.roboto,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(49, 47, 52, 1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Silahkan masuk untuk mengelola pinjaman.',
            style: TextStyle(
              fontFamily: widget.roboto,
              fontSize: 13,
              color: const Color.fromRGBO(72, 141, 117, 1),
            ),
          ),
          const SizedBox(height: 15),
          const Text('Email'),
          const SizedBox(height: 6),
          TextField(
            controller: _emailController,
            onChanged: (_) => setState(() => _errorEmail = null),
            style: TextStyle(
              fontFamily: widget.roboto,
              fontSize: 14,
              color: const Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'nama@brantas.sch.id',
              errorText: _errorEmail,
              hintStyle: TextStyle(
                fontFamily: widget.roboto,
                fontSize: 13,
                color: const Color.fromRGBO(140, 170, 160, 1),
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: const Icon(Icons.email_outlined, color: Color.fromRGBO(72, 141, 117, 1)),
              border: LoginStyles.inputBorder(),
              enabledBorder: LoginStyles.inputBorder(),
              focusedBorder: LoginStyles.focusedBorder(),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Password'),
          const SizedBox(height: 6),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onChanged: (_) => setState(() => _errorPassword = null),
            style: TextStyle(
              fontFamily: widget.roboto,
              fontSize: 14,
              color: const Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'masukkan password anda',
              errorText: _errorPassword,
              hintStyle: TextStyle(
                fontFamily: widget.roboto,
                fontSize: 13,
                color: const Color.fromRGBO(140, 170, 160, 1),
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              prefixIconColor: const Color.fromRGBO(72, 141, 117, 1),
              suffixIconColor: const Color.fromRGBO(72, 141, 117, 1),
              border: LoginStyles.inputBorder(),
              enabledBorder: LoginStyles.inputBorder(),
              focusedBorder: LoginStyles.focusedBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Masuk ke Akun',
                      style: TextStyle(
                          fontFamily: widget.roboto,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(height: 24, thickness: 2, color: Color.fromRGBO(205, 238, 226, 1)),
          Center(
            child: Column(
              children: [
                Text(
                  'AKSES TERSEDIA UNTUK',
                  style: TextStyle(
                      fontFamily: widget.roboto,
                      fontSize: 11,
                      color: const Color.fromRGBO(7, 131, 88, 1),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    LoginStyles.roleChip('Admin', widget.roboto),
                    LoginStyles.roleChip('Petugas', widget.roboto),
                    LoginStyles.roleChip('Peminjam', widget.roboto),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}