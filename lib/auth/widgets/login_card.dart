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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            style: TextStyle(
              fontFamily: widget.roboto,
              fontSize: 14,
              color: const Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'nama@brantas.sch.id',
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
            style: TextStyle(
              fontFamily: widget.roboto,
              fontSize: 14,
              color: const Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'masukkan password anda',
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
              onPressed: () async {
                try {
                  final authResponse = await Supabase.instance.client.auth.signInWithPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  final user = authResponse.user;
                  if (user == null) return;
                  final data = await Supabase.instance.client.from('users').select('role').eq('auth_user_id', user.id).single();
                  final role = data['role'];
                  if (!context.mounted) return;
                  if (role == 'admin') {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardAdminPage()));
                  } else if (role == 'petugas') {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPetugasPage()));
                  } else if (role == 'peminjam') {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPeminjamPage()));
                  }
                } catch (e) {
                  debugPrint('Login error: $e');
                }
              },
              child: Text(
                'Masuk ke Akun',
                style: TextStyle(fontFamily: widget.roboto, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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
                  style: TextStyle(fontFamily: widget.roboto, fontSize: 11, color: const Color.fromRGBO(7, 131, 88, 1), fontWeight: FontWeight.w500),
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