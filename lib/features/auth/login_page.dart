import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 247, 242, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 2),

                Text(
                  'Sistem Peminjaman Alat\nRekayasa Perangkat Lunak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: roboto,
                    fontSize: 14,
                    color: const Color.fromRGBO(72, 141, 117, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                /// CARD LOGIN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromRGBO(205, 238, 226, 0.28),
                    ),
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
                          fontFamily: roboto,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(49, 47, 52, 1),
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        'Silahkan masuk untuk mengelola pinjaman.',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontSize: 13,
                          color: const Color.fromRGBO(72, 141, 117, 1),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// EMAIL
                      const Text('Email'),
                      const SizedBox(height: 6),
                      TextField(
                        style: const TextStyle(
                          fontFamily: roboto,
                          fontSize: 14,
                          color: Color.fromRGBO(72, 141, 117, 1),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'nama@brantas.sch.id',
                          hintStyle: const TextStyle(
                            fontFamily: roboto,
                            fontSize: 13,
                            color: Color.fromRGBO(140, 170, 160, 1),
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color.fromRGBO(72, 141, 117, 1),
                          ),
                          border: _inputBorder(),
                          enabledBorder: _inputBorder(),
                          focusedBorder: _focusedBorder(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// PASSWORD
                      const Text('Password'),
                      const SizedBox(height: 6),
                      TextField(
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontFamily: roboto,
                          fontSize: 14,
                          color: Color.fromRGBO(72, 141, 117, 1),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'masukkan password anda',
                          hintStyle: const TextStyle(
                            fontFamily: roboto,
                            fontSize: 13,
                            color: Color.fromRGBO(140, 170, 160, 1),
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          prefixIconColor: const Color.fromRGBO(
                            72,
                            141,
                            117,
                            1,
                          ),
                          suffixIconColor: const Color.fromRGBO(
                            72,
                            141,
                            117,
                            1,
                          ),
                          border: _inputBorder(),
                          enabledBorder: _inputBorder(),
                          focusedBorder: _focusedBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                            fontFamily: roboto,
                            fontSize: 13,
                            color: Color.fromRGBO(20, 72, 54, 1),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(62, 159, 127, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Masuk ke Akun',
                            style: TextStyle(
                              fontFamily: roboto,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Divider(
                        height: 24,
                        thickness: 2,
                        color: Color.fromRGBO(205, 238, 226, 1),
                      ),

                      /// ROLE
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'AKSES TERSEDIA UNTUK',
                              style: TextStyle(
                                fontFamily: roboto,
                                fontSize: 11,
                                color: Color.fromRGBO(7, 131, 88, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              children: [
                                _roleChip('Admin'),
                                _roleChip('Petugas'),
                                _roleChip('Peminjam'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text.rich(
                  TextSpan(
                    text: 'Butuh bantuan? ',
                    style: TextStyle(
                      fontFamily: roboto,
                      fontSize: 13,
                      color: Color.fromRGBO(72, 141, 117, 1),
                    ),
                    children: [
                      TextSpan(
                        text: 'Hubungi IT Support',
                        style: TextStyle(
                          fontFamily: roboto,
                          color: Color.fromRGBO(20, 72, 54, 1), // warna berbeda
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 0.49)),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color.fromRGBO(72, 141, 117, 1),
        width: 1.4,
      ),
    );
  }

  static Widget _roleChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 253, 240, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: roboto,
          fontSize: 11,
          color: Color.fromRGBO(1, 85, 56, 1),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
