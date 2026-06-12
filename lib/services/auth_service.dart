import 'package:dio/dio.dart';
import '../data/models/user_model.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/auth_repository.dart';
import 'api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';

class AuthService implements AuthRepository {
  UserModel? _currentUser;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      if (data['success'] == true) {
        await ApiService.saveToken(data['token']);
        final user = UserModel.fromJson({
          ...data['user'],
          'token': data['token'],
        });
        _currentUser = user;
        return user;
      }
      throw Exception(data['message'] ?? 'Login gagal');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Gagal terhubung ke server';
      throw Exception(message);
    }
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await ApiService.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });

      final data = response.data;
      if (data['success'] == true) {
        await ApiService.saveToken(data['token']);
        final user = UserModel.fromJson({
          ...data['user'],
          'token': data['token'],
        });
        _currentUser = user;
        return user;
      }
      throw Exception(data['message'] ?? 'Registrasi gagal');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Gagal terhubung ke server';
      throw Exception(message);
    }
  }

  @override
Future<UserEntity> loginWithGoogle() async {
  try {
    // 1. Sign in dengan Google
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile'], serverClientId: '419265499367-gbrv10dvo4nkvdbsjtumj2m083bcovrm.apps.googleusercontent.com');
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw Exception('Login Google dibatalkan');

    // 2. Ambil idToken
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) throw Exception('Gagal mendapatkan token Google');

    // 3. Kirim idToken ke Laravel
    final response = await ApiService.dio.post('/auth/google', data: {
      'id_token': idToken,
    });

    final data = response.data;
    if (data['success'] == true) {
      await ApiService.saveToken(data['token']);
      final user = UserModel.fromJson({
        ...data['user'],
        'token': data['token'],
      });
      _currentUser = user;
      return user;
    }
    throw Exception(data['message'] ?? 'Login Google gagal');

  } on DioException catch (e) {
    final message = e.response?.data['message'] ?? 'Login Google gagal';
    throw Exception(message);
  }
}

  @override
  Future<void> logout() async {
    try {
      await ApiService.dio.post('/auth/logout');
    } catch (_) {
      // Tetap logout lokal meski API gagal
    }
    await ApiService.deleteToken();
    _currentUser = null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final token = await ApiService.getToken();
      if (token == null) return null;

      final response = await ApiService.dio.get('/auth/me');
      final data = response.data;

      if (data['success'] == true) {
        final user = UserModel.fromJson({
          ...data['user'],
          'token': token,
        });
        _currentUser = user;
        return user;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<UserEntity> updateProfile({
  required String name,
  String? phone,
}) async {
  try {
    final response = await ApiService.dio.put('/profile', data: {
      'name': name,
      'phone': phone,
    });

    final data = response.data;
    if (data['success'] == true) {
      final token = await ApiService.getToken();
      final user = UserModel.fromJson({
        ...data['data'],
        'token': token,
      });
      _currentUser = user;
      return user;
    }
    throw Exception(data['message'] ?? 'Gagal update profil');
  } on DioException catch (e) {
    throw Exception(
        e.response?.data['message'] ?? 'Gagal terhubung ke server');
  }
}
}