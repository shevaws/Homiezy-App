import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);

/// Mock datasource — ganti dengan real API call saat backend sudah siap
class AuthMockDatasource {
  // Simulasi delay network
  static const _delay = Duration(milliseconds: 1200);

  // Mock user database
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'name': 'Budi Santoso',
      'email': 'budi@example.com',
      'password': 'password123',
      'phone': '081234567890',
      'photo_url': null,
      'role': 'user',
    },
  ];

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_delay);

    // Cari user
    final user = _mockUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception('Email atau password salah'),
    );

    return UserModel.fromJson({
      ...user,
      'token': 'mock_jwt_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    await Future.delayed(_delay);

    // Cek email sudah terdaftar
    final exists = _mockUsers.any((u) => u['email'] == email);
    if (exists) throw Exception('Email sudah terdaftar');

    final newUser = {
      'id': (_mockUsers.length + 1).toString(),
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'photo_url': null,
      'role': 'user',
    };

    _mockUsers.add(newUser);

    return UserModel.fromJson({
      ...newUser,
      'token': 'mock_jwt_token_${newUser['id']}_${DateTime.now().millisecondsSinceEpoch}',
    });
  }

    Future<UserModel> loginWithGoogle() async {
    await Future.delayed(_delay);

    // Langsung return mock user, skip Google token
    return UserModel.fromJson({
      'id': 'google_001',
      'name': 'Google User',
      'email': 'googleuser@gmail.com',
      'phone': null,
      'photo_url': null,
      'role': 'user',
      'token': 'mock_google_token_${DateTime.now().millisecondsSinceEpoch}',
    });
  }
}