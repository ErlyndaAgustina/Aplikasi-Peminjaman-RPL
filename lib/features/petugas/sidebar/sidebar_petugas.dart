import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/login_page.dart';
import '../cetak_laporan/cetak_laporan_page.dart';
import '../dashboard/dashboard_page.dart';
import '../persetujuan_peminjaman/persetujuan_peminjaman_page.dart';
import '../persetujuan_pengembalian/persetujuan_pengembalian_page.dart';

class SidebarPetugasDrawer extends StatefulWidget {
  const SidebarPetugasDrawer({super.key});

  static const String roboto = 'Roboto';

  @override
  State<SidebarPetugasDrawer> createState() => _SidebarPetugasDrawerState();
}

class _SidebarPetugasDrawerState extends State<SidebarPetugasDrawer> {
  static const String roboto = SidebarPetugasDrawer.roboto;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header dengan X button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Petugas
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(219, 234, 254, 1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'PS',
                            style: TextStyle(
                              fontFamily: roboto,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(37, 99, 235, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Petugas',
                            style: TextStyle(
                              fontFamily: roboto,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(49, 47, 52, 1),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Petugas@brantas.sch.id',
                            style: TextStyle(
                              fontFamily: roboto,
                              fontSize: 12,
                              color: Color.fromRGBO(72, 141, 117, 1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(219, 234, 254, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Petugas',
                              style: TextStyle(
                                fontFamily: roboto,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(37, 99, 235, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Logo RPLKIT
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.dashboard_customize,
                      color: Color.fromRGBO(62, 159, 127, 1),
                      size: 30,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 3,
                color: Color.fromRGBO(205, 238, 226, 1),
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPetugasPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.assignment,
                    title: 'Setujui Peminjaman',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PersetujuanPeminjamanPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.assignment_return,
                    title: 'Pengembalian Alat',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PersetujuanPengembalianPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.picture_as_pdf_outlined,
                    title: 'Cetak Laporan',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CetakLaporanPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: roboto,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromRGBO(72, 141, 117, 1),
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: roboto,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color.fromRGBO(72, 141, 117, 1),
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      horizontalTitleGap: 12,
    );
  }

  void _showLogoutDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Konfirmasi Logout',
        style: TextStyle(
          fontFamily: roboto,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        'Apakah Anda yakin ingin keluar?',
        style: TextStyle(fontFamily: roboto, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text(
            'Batal',
            style: TextStyle(fontFamily: roboto, color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              print('Starting logout...');
              
              // ✅ PENTING: Simpan navigator SEBELUM menutup dialog/drawer
              final navigator = Navigator.of(context, rootNavigator: true);
              
              // Tutup dialog dan drawer sekaligus
              Navigator.pop(dialogContext); // tutup dialog
              Navigator.pop(context); // tutup drawer
              
              // Tunggu sebentar agar UI selesai update
              await Future.delayed(const Duration(milliseconds: 300));
              
              // Lakukan logout
              await Supabase.instance.client.auth.signOut();
              print('Logout complete');
              
              // Tunggu sebentar lagi
              await Future.delayed(const Duration(milliseconds: 100));
              
              print('Navigating to login...');
              
              // Navigate ke login menggunakan navigator yang sudah disimpan
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
              
              print('Navigation complete');
            } catch (e) {
              print('Error during logout: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(220, 38, 38, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Ya, Logout',
            style: TextStyle(fontFamily: roboto, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
}