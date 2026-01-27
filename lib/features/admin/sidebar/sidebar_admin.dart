import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/login_page.dart';
import '../alat/manajemen_alat_page.dart';
import '../dashboard/dashboard_page.dart';
import '../kategori/manajemen_kategori_page.dart';
import '../log_aktivitas/log_aktivitas_page.dart';
import '../peminjaman/manajemen_peminjaman_page.dart';
import '../pengembalian/pengembalian_page.dart';
import '../users/manajemen_pengguna_page.dart';

class SidebarAdminDrawer extends StatefulWidget {
  const SidebarAdminDrawer({super.key});

  static const String roboto = 'Roboto';

  @override
  State<SidebarAdminDrawer> createState() => _SidebarAdminDrawerState();
}

class _SidebarAdminDrawerState extends State<SidebarAdminDrawer> {
  static const String roboto = SidebarAdminDrawer.roboto;

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
                      // Avatar Siswa
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(217, 253, 240, 1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'AD',
                            style: TextStyle(
                              fontFamily: roboto,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(72, 141, 117, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Admin',
                            style: TextStyle(
                              fontFamily: roboto,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(49, 47, 52, 1),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'admin@brantas.sch.id',
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
                              color: Color.fromRGBO(217, 253, 240, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(
                                fontFamily: roboto,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(1, 85, 56, 1),
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
                          builder: (context) => const DashboardAdminPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.group,
                    title: 'Manajemen Pengguna',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManajemenPenggunaPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.list_alt_outlined,
                    title: 'Manajemen Alat',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManajemenAlatPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.category,
                    title: 'Manajemen Kategori',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManajemenKategoriPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.assignment,
                    title: 'Manajemen Peminjaman',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManajemenPeminjamanPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.assignment_return,
                    title: 'Manajemen Pengembalian',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PengembalianPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history_outlined,
                    title: 'Log Aktivitas',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogAktivitasPage(),
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
                    // JANGAN tutup drawer dulu, langsung tampilkan dialog
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

  Future<void> _handleLogout(BuildContext navigationContext) async {
    try {
      print('Starting logout...');
      
      // Lakukan logout
      await Supabase.instance.client.auth.signOut();
      print('Logout complete');
      
      // Gunakan navigationContext yang sudah disimpan sebelum widget disposed
      print('Navigating to login...');
      
      // Navigate ke login page dengan menghapus semua route sebelumnya
      Navigator.of(navigationContext).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
      
      print('Navigation complete');
    } catch (e) {
      print('Error during logout: $e');
      
      // Tampilkan error jika context masih tersedia
      if (navigationContext.mounted) {
        ScaffoldMessenger.of(navigationContext).showSnackBar(
          SnackBar(
            content: Text('Gagal logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLogoutDialog() {
    // Simpan context dari scaffold/page, bukan dari drawer
    final scaffoldContext = context;
    
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
            onPressed: () {
              // Tutup dialog
              Navigator.pop(dialogContext);
              
              // Tutup drawer
              Navigator.pop(scaffoldContext);
              
              // Panggil fungsi logout dengan context yang valid
              _handleLogout(scaffoldContext);
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