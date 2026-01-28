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

  List<UserModel> get _filteredUsers {
    return users.where((user) {
      final userName = (user.name).toLowerCase();
      final userEmail = (user.email).toLowerCase();
      final query = _searchQuery.toLowerCase();

      final matchesSearch = userName.contains(query) || userEmail.contains(query);
      final matchesRole = _selectedRoleFilter == "Semua Role" || user.role == _selectedRoleFilter;

      return matchesSearch && matchesRole;
    }).toList();
  }

  void _openUserForm({UserModel? user}) {
    showDialog(
      context: context,
      builder: (context) => UserFormModal(
        user: user,
        onSave: (updatedUser) {
          setState(() {
            if (user != null) {
              int index = users.indexOf(user);
              users[index] = updatedUser;
            } else {
              users.add(updatedUser);
            }
          });
        },
      ),
    );
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
              onRoleSelected: (role) => setState(() => _selectedRoleFilter = role),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return UserCard(
                    user: user,
                    onEdit: (selectedUser) => _openUserForm(user: selectedUser),
                    onDelete: (selectedUser) {
                      setState(() => users.removeWhere((u) => u == selectedUser));
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
          border: Border(bottom: BorderSide(color: Color.fromRGBO(216, 199, 246, 1), width: 1)),
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
      label: const Text('Tambah Pengguna',
          style: TextStyle(fontFamily: roboto, fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari Nama atau Email...',
          prefixIcon: const Icon(Icons.search, size: 22, color: Color.fromRGBO(72, 141, 117, 1)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 1), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color.fromRGBO(72, 141, 117, 1), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
        Text('Manajemen Pengguna',
            style: TextStyle(fontFamily: roboto, fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(49, 47, 52, 1))),
        SizedBox(height: 2),
        Text('RPLKIT • SMK Brantas Karangkates',
            style: TextStyle(fontFamily: roboto, fontSize: 12, color: Color.fromRGBO(72, 141, 117, 1))),
      ],
    );
  }
}