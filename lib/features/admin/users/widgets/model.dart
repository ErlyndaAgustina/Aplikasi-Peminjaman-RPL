class UserModel {
  final String initials;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.initials,
    required this.name,
    required this.email,
    required this.role,
  });
}

final users = [
  UserModel(
    initials: 'AD',
    name: 'Admin',
    email: 'admin@brantas.sch.id',
    role: 'Admin',
  ),
  UserModel(
    initials: 'PS',
    name: 'Petugas',
    email: 'petugas@brantas.sch.id',
    role: 'Petugas',
  ),
  UserModel(
    initials: 'SW',
    name: 'Siswa',
    email: 'siswa@brantas.sch.id',
    role: 'Peminjam',
  ),
];