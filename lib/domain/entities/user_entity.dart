class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String role; // 'user' | 'mitra' | 'admin'
  final String? token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.role,
    this.token,
  });

  bool get isLoggedIn => token != null && token!.isNotEmpty;
}