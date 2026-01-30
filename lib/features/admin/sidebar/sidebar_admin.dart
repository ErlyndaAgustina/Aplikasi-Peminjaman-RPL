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
  final _supabase = Supabase.instance.client;

  // Fungsi untuk ambil data user yang sedang login dari database
  Future<Map<String, dynamic>> _getUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    return await _supabase
        .from('users')
        .select()
        .eq('auth_user_id', user.id)
        .single();
  }

  // Helper untuk buat inisial (Contoh: Admin Brantas -> AB)
  String _getInisial(String nama) {
    List<String> names = nama.trim().split(" ");
    if (names.length > 1) {
      return (names[0][0] + names[1][0]).toUpperCase();
    }
    return names[0].isNotEmpty ? names[0][0].toUpperCase() : "?";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header Dinamis menggunakan FutureBuilder
            FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }

                // Jika error atau data kosong, pakai fallback default
                final userData = snapshot.data;
                final String nama = userData?['nama'] ?? 'Admin';
                final String email = userData?['email'] ?? 'admin@brantas.sch.id';
                final String role = userData?['role'] ?? 'Admin';

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar Dinamis
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(217, 253, 240, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _getInisial(nama),
                                style: const TextStyle(
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
                              Text(
                                nama,
                                style: const TextStyle(
                                  fontFamily: roboto,
                                  fontSize: 14, // Dikecilkan sedikit agar muat
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromRGBO(49, 47, 52, 1),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontFamily: roboto,
                                  fontSize: 11,
                                  color: Color.fromRGBO(72, 141, 117, 1),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Label Role Dinamis
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(217, 253, 240, 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  role.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: roboto,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(1, 85, 56, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 20, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Logo RPLKIT
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.dashboard_customize,
                    color: Color.fromRGBO(62, 159, 127, 1),
                    size: 30,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 3, color: Color.fromRGBO(205, 238, 226, 1)),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    onTap: () => _navigate(context, const DashboardAdminPage()),
                  ),
                  _buildMenuItem(
                    icon: Icons.group_outlined,
                    title: 'Manajemen Pengguna',
                    onTap: () => _navigate(context, const ManajemenPenggunaPage()),
                  ),
                  _buildMenuItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'Manajemen Alat',
                    onTap: () => _navigate(context, const ManajemenAlatPage()),
                  ),
                  _buildMenuItem(
                    icon: Icons.category_outlined,
                    title: 'Manajemen Kategori',
                    onTap: () => _navigate(context, const ManajemenKategoriPage()),
                  ),
                  _buildMenuItem(
                    icon: Icons.assignment_outlined,
                    title: 'Manajemen Peminjaman',
                    onTap: () => _navigate(context, const ManajemenPeminjamanPage()),
                  ),
                  _buildMenuItem(
                    icon: Icons.assignment_return_outlined,
                    title: 'Manajemen Pengembalian',
                    onTap: () => _navigate(context, const PengembalianPage()),
                  ),
                  _buildMenuItem(
                    icon: Icons.history_outlined,
                    title: 'Log Aktivitas',
                    onTap: () => _navigate(context, const LogAktivitasPage()),
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
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Logout', style: TextStyle(fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper navigasi biar kode lebih bersih
  void _navigate(BuildContext context, Widget page) {
    Navigator.pop(context); // Tutup drawer
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromRGBO(72, 141, 117, 1), size: 22),
      title: Text(title, style: const TextStyle(fontFamily: roboto, fontSize: 13, fontWeight: FontWeight.w700, color: Color.fromRGBO(72, 141, 117, 1))),
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 8,
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