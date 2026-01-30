enum UserRole { admin, petugas, peminjam }

class UserModel {
  final String idUser;
  final String authUserId;
  final String nama;
  final String email;
  final UserRole role;
  final DateTime? createdAt;

  UserModel({
    required this.idUser,
    required this.authUserId,
    required this.nama,
    required this.email,
    required this.role,
    this.createdAt,
  });

  // Mapping dari Database (Map) ke Model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idUser: map['id_user'],
      authUserId: map['auth_user_id'],
      nama: map['nama'] ?? 'Tanpa Nama',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.peminjam,
      ),
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
    );
  }

  String get inisial {
    List<String> names = nama.trim().split(" ");
    if (names.length > 1) {
      return (names[0][0] + names[1][0]).toUpperCase();
    } else if (names.isNotEmpty && names[0].isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return "?";
  }

  String get roleLabel => role.name.substring(0, 1).toUpperCase() + role.name.substring(1);
}