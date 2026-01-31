import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/login_page.dart';
import '../ajukan_pengembalian/ajukan_pengembalian_page.dart';
import '../daftar_alat/daftar_alat_peminjam_page.dart';
import '../dashboard/dashboard_page.dart';

class SidebarPeminjamDrawer extends StatefulWidget {
  const SidebarPeminjamDrawer({super.key});
  static const String roboto = 'Roboto';

  @override
  State<SidebarPeminjamDrawer> createState() => _SidebarPeminjamDrawerState();
}

class _SidebarPeminjamDrawerState extends State<SidebarPeminjamDrawer> {
  final _supabase = Supabase.instance.client;
  String _userName = "Loading...";
  String _userEmail = "...";
  String _initials = "??";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk mengambil data peminjam dari Supabase
  Future<void> _loadUserData() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        // Ambil data detail dari tabel public.users
        final userData = await _supabase
            .from('users')
            .select('nama, email')
            .eq('auth_user_id', user.id)
            .single();

        setState(() {
          _userName = userData['nama'] ?? "Siswa";
          _userEmail = userData['email'] ?? user.email ?? "-";

          // Logika Inisial: "Andi Pratama" -> "AP"
          List<String> names = _userName.trim().split(" ");
          if (names.length > 1) {
            _initials = "${names[0][0]}${names[1][0]}".toUpperCase();
          } else {
            _initials = _userName.length >= 2
                ? _userName.substring(0, 2).toUpperCase()
                : _userName[0].toUpperCase();
          }
        });
      } catch (e) {
        setState(() {
          _userName = "Peminjam";
          _userEmail = user.email ?? "-";
          _initials = "PM";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const String roboto = SidebarPeminjamDrawer.roboto;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header Dinamis
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Siswa Dinamis
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 237, 213, 1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              fontFamily: roboto,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(235, 98, 26, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: const TextStyle(
                              fontFamily: roboto,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(49, 47, 52, 1),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userEmail,
                            style: const TextStyle(
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
                              color: const Color.fromRGBO(255, 237, 213, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Peminjam',
                              style: TextStyle(
                                fontFamily: roboto,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(235, 98, 26, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Logo RPLKIT
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
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
                          builder: (context) => const DashboardPeminjamPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.list_alt_outlined,
                    title: 'Daftar Alat',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DaftarAlatPeminjamPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.assignment_return_outlined,
                    title: 'Ajukan Pengembalian',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AjukanPengembalianPage(),
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
                  onPressed: () => _showLogoutDialog(),
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
          fontFamily: SidebarPeminjamDrawer.roboto,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color.fromRGBO(72, 141, 117, 1),
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: 8,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(
            fontFamily: SidebarPeminjamDrawer.roboto,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(
            fontFamily: SidebarPeminjamDrawer.roboto,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: SidebarPeminjamDrawer.roboto,
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context, rootNavigator: true);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              await _supabase.auth.signOut();
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(220, 38, 38, 1),
            ),
            child: const Text(
              'Ya, Logout',
              style: TextStyle(
                fontFamily: SidebarPeminjamDrawer.roboto,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
