class UserModel {
  final String idUser;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.idUser,
    required this.name,
    required this.email,
    required this.role,
  });

  String get initials {
    if (name.isEmpty) return "??";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idUser: map['id_user'] ?? '',
      name: map['nama'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'peminjam',
    );
  }
}