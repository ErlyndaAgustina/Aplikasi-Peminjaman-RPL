import 'package:flutter/material.dart';

class RoleFilterChips extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleFilterChips({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final roles = ['Semua Role', 'Admin', 'Petugas', 'Peminjam'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: roles.map((role) => _buildChip(role)).toList(),
      ),
    );
  }

  Widget _buildChip(String label) {
    final bool isActive = selectedRole == label;
    return GestureDetector(
      onTap: () => onRoleSelected(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color.fromRGBO(62, 159, 127, 1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : const Color.fromRGBO(1, 85, 56, 1),
          ),
        ),
      ),
    );
  }
}