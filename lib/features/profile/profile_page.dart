import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/login_page.dart';
import 'models/user_model.dart';

class ProfilePenggunaPage extends StatefulWidget {
  const ProfilePenggunaPage({super.key});

  @override
  State<ProfilePenggunaPage> createState() => _ProfilePenggunaPageState();
}

class _ProfilePenggunaPageState extends State<ProfilePenggunaPage> {
  final _supabase = Supabase.instance.client;

  // Fungsi untuk mengambil data user dari tabel public.users
  Future<UserModel> _fetchUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User tidak login");

    final response = await _supabase
        .from('users')
        .select()
        .eq('auth_user_id', user.id)
        .single();

    return UserModel.fromMap(response);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color.fromRGBO(62, 159, 127, 1);
    const Color mintGreen = Color.fromRGBO(217, 253, 240, 1);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      appBar: _buildAppBar(context),
      body: FutureBuilder<UserModel>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Gagal memuat profil: ${snapshot.error}"),
            );
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [
                // Card Profile
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: mintGreen,
                        child: Text(
                          data.inisial,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data.nama,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF312F34),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(
                        thickness: 1,
                        color: Color.fromRGBO(234, 247, 242, 1),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoTile(
                        "Posisi",
                        data.roleLabel,
                        Icons.badge_outlined,
                        mintGreen,
                        primaryGreen,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoTile(
                        "Alamat Email",
                        data.email,
                        Icons.email_outlined,
                        mintGreen,
                        primaryGreen,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildLogoutButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widget Helpers ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 253, 240, 0.49),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(62, 159, 127, 1),
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Profile Pengguna',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF312F34),
            ),
          ),
          Text(
            'RPLKIT • SMK Brantas Karangkates',
            style: TextStyle(fontSize: 12, color: Color(0xFF488D75)),
          ),
        ],
      ),
      shape: const Border(
        bottom: BorderSide(color: Color.fromRGBO(216, 199, 246, 1), width: 1),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah kamu yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await _supabase.auth.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              "Ya, Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    String label,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
