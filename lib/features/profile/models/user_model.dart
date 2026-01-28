enum UserRole { admin, petugas, peminjam }

class UserModel {
  final String nama;
  final String email;
  final UserRole role;

  UserModel({
    required this.nama,
    required this.email,
    required this.role,
  });

  // Fungsi untuk mendapatkan inisial (Contoh: Erlynda Agustina -> EA)
  String get inisial {
    List<String> names = nama.trim().split(" ");
    String initials = "";
    if (names.length > 1) {
      initials = names[0][0] + names[1][0];
    } else if (names.isNotEmpty) {
      initials = names[0][0];
    }
    return initials.toUpperCase();
  }

  // Mendapatkan string label role
  String get roleLabel {
    switch (role) {
      case UserRole.admin: return 'Admin';
      case UserRole.petugas: return 'Petugas';
      case UserRole.peminjam: return 'Peminjam';
    }
  }
}

// DATA DUMMY (Bisa kamu ganti role-nya di sini untuk testing)
final currentUser = UserModel(
  nama: "Erlynda Agustina",
  email: "erlyndaaa@gmail.com",
  role: UserRole.admin, 
);