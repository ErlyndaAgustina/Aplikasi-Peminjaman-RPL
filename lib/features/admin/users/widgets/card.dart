import 'package:flutter/material.dart';
import 'model.dart';
import 'role_badge.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color.fromRGBO(217, 253, 235, 1),
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(72, 141, 117, 1),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontFamily: roboto,
                        color: Color.fromRGBO(49, 47, 52, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 13,
                        color: Color.fromRGBO(72, 141, 117, 1),
                      ),
                    ),
                  ],
                ),
              ),
              RoleBadge(role: user.role),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(72, 141, 117, 1), // hijau
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Color.fromRGBO(1, 85, 56, 1),
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color.fromRGBO(1, 85, 56, 1),
                      fontFamily: roboto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(255, 2, 2, 1), // merah
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.delete, size: 16,
                    color: Color.fromRGBO(255, 2, 2, 1)),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 2, 2, 1),
                      fontFamily: roboto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
