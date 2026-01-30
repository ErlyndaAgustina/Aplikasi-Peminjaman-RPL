import 'package:flutter/material.dart';
import '../../profile/profile_page.dart';
import '../sidebar/sidebar_admin.dart';
import 'models/model.dart';
import 'widgets/card.dart';
import 'widgets/user_form_modal.dart';
import 'widgets/role_filter_chips.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String roboto = 'Roboto';

class ManajemenPenggunaPage extends StatefulWidget {
  const ManajemenPenggunaPage({super.key});

  @override
  State<ManajemenPenggunaPage> createState() => _ManajemenPenggunaPageState();
}

class _ManajemenPenggunaPageState extends State<ManajemenPenggunaPage> {
  String _searchQuery = "";
  String _selectedRoleFilter = "Semua Role";
  final _supabase = Supabase.instance.client;

  // Di ManajemenPenggunaPage
  void _openUserForm({UserModel? user}) {
  showDialog(
    context: context,
    builder: (context) => UserFormModal(
      user: user,
      onSave: (data) async {
        try {
          final String roleLower = data['role'].toString().toLowerCase();
          final String emailBaru = data['email'];

          if (user != null) {
            // === MODE EDIT ===
            
            // 1. Update Email di Supabase Auth (WAJIB)
            // Ini yang mengubah data di tabel internal auth.users
            await _supabase.auth.updateUser(
              UserAttributes(email: emailBaru),
            );

            // 2. Update Data di Tabel public.users
            await _supabase
                .from('users')
                .update({
                  'nama': data['nama'],
                  'email': emailBaru, // Supaya email di tabel kita juga update
                  'role': roleLower,
                })
                .eq('id_user', user.idUser);

            _showSnackBar("Berhasil memperbarui data & email!", Colors.green);
          } else {
            // === MODE TAMBAH BARU ===
            
            // 1. SignUp ke Auth
            final AuthResponse res = await _supabase.auth.signUp(
              email: emailBaru,
              password: data['password'],
              data: {'nama': data['nama'], 'role': roleLower},
            );

            final String? newAuthId = res.user?.id;

            // 2. Insert/Upsert ke Tabel public.users
            if (newAuthId != null) {
              await _supabase.from('users').upsert({
                'auth_user_id': newAuthId,
                'nama': data['nama'],
                'email': emailBaru,
                'role': roleLower,
              }, onConflict: 'auth_user_id');
              _showSnackBar("Pengguna baru ditambahkan!", Colors.green);
            }
          }
        } catch (e) {
          // Jika error "Email change requires confirmation", 
          // berarti setting di dashboard Supabase belum benar-benar mati.
          _showSnackBar("Gagal: $e", Colors.red);
        }
      },
    ),
  );
}

  void _showSnackBar(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarAdminDrawer(),
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAddButton(),
            const SizedBox(height: 12),
            _buildSearchField(),
            const SizedBox(height: 16),
            RoleFilterChips(
              selectedRole: _selectedRoleFilter,
              onRoleSelected: (role) =>
                  setState(() => _selectedRoleFilter = role),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                // Real-time stream dari tabel users
                stream: _supabase.from('users').stream(primaryKey: ['id_user']),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Center(child: Text("Error: ${snapshot.error}"));
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());

                  final allUsers = snapshot.data!
                      .map((m) => UserModel.fromMap(m))
                      .toList();

                  // Logic Filter
                  final filtered = allUsers.where((u) {
                    final matchesSearch =
                        u.name.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        u.email.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                    final matchesRole =
                        _selectedRoleFilter == "Semua Role" ||
                        u.role.toLowerCase() ==
                            _selectedRoleFilter.toLowerCase();
                    return matchesSearch && matchesRole;
                  }).toList();

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final u = filtered[index];
                      return UserCard(
                        user: u,
                        onEdit: (selected) => _openUserForm(user: selected),
                        onDelete: (selected) async {
                          // Hapus data di tabel public.users
                          await _supabase
                              .from('users')
                              .delete()
                              .eq('id_user', selected.idUser);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- Sub-Widgets Layout ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(216, 199, 246, 1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              _buildMenuButton(context),
              const SizedBox(width: 12),
              const Expanded(child: _AppBarTitle()),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePenggunaPage(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color.fromRGBO(217, 253, 240, 0.49),
                  child: Icon(
                    Icons.person,
                    color: Color.fromRGBO(62, 159, 127, 1),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 253, 240, 0.49),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Builder(
        builder: (context) => GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: const Icon(Icons.menu, color: Color.fromRGBO(62, 159, 127, 1)),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () => _openUserForm(),
      icon: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 22),
      label: const Text(
        'Tambah Pengguna',
        style: TextStyle(
          fontFamily: roboto,
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari Nama atau Email...',
          prefixIcon: const Icon(
            Icons.search,
            size: 22,
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color.fromRGBO(205, 238, 226, 1),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color.fromRGBO(72, 141, 117, 1),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Manajemen Pengguna',
          style: TextStyle(
            fontFamily: roboto,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(49, 47, 52, 1),
          ),
        ),
        SizedBox(height: 2),
        Text(
          'RPLKIT • SMK Brantas Karangkates',
          style: TextStyle(
            fontFamily: roboto,
            fontSize: 12,
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
        ),
      ],
    );
  }
}
