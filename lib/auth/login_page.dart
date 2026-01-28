import 'package:flutter/material.dart';
import 'widgets/login_card.dart';

const String roboto = 'Roboto';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', width: 250, fit: BoxFit.contain),
                const SizedBox(height: 2),
                const Text(
                  'Sistem Peminjaman Alat\nRekayasa Perangkat Lunak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: roboto,
                    fontSize: 14,
                    color: Color.fromRGBO(72, 141, 117, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                const LoginCard(roboto: roboto),
                const SizedBox(height: 16),
                const Text.rich(
                  TextSpan(
                    text: 'Butuh bantuan? ',
                    style: TextStyle(fontFamily: roboto, fontSize: 13, color: Color.fromRGBO(72, 141, 117, 1)),
                    children: [
                      TextSpan(
                        text: 'Hubungi IT Support',
                        style: TextStyle(fontFamily: roboto, color: Color.fromRGBO(20, 72, 54, 1), fontWeight: FontWeight.w700),
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
}