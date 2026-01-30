class UserModel {
  final String idUser; // UUID dari database
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.idUser,
    required this.name,
    required this.email,
    required this.role,
  });

  // Ambil inisial otomatis dari nama
  String get initials {
    if (name.isEmpty) return "??";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  // Konversi dari Map Supabase ke Model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idUser: map['id_user'] ?? '',
      name: map['nama'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'peminjam',
    );
  }
}