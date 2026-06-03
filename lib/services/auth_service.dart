import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/datasources/auth_mock_datasource.dart';
import '../data/models/user_model.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/auth_repository.dart';

class AuthService implements AuthRepository {
  final AuthMockDatasource _datasource = AuthMockDatasource();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel? _currentUser;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final user = await _datasource.login(email: email, password: password);
    _currentUser = user;
    return user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final user = await _datasource.register(
      name: name, email: email, password: password, phone: phone,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<UserEntity> loginWithGoogle() async {
    // 1. Buka popup pilih akun Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Login Google dibatalkan');

    // 2. Ambil auth credentials
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 3. Sign in ke Firebase
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final firebaseUser = userCredential.user;
    if (firebaseUser == null) throw Exception('Gagal login dengan Google');

    // 4. Kirim idToken ke backend Laravel untuk dapat JWT
    // TODO: uncomment saat backend siap
    // final idToken = googleAuth.idToken;
    // final response = await dio.post('/auth/google', data: {'token': idToken});
    // final jwtToken = response.data['token'];

    // Sementara pakai Firebase UID sebagai token
    final firebaseToken = await firebaseUser.getIdToken();

    final user = UserModel.fromJson({
      'id': firebaseUser.uid,
      'name': firebaseUser.displayName ?? '',
      'email': firebaseUser.email ?? '',
      'phone': firebaseUser.phoneNumber,
      'photo_url': firebaseUser.photoURL,
      'role': 'user',
      'token': firebaseToken,
    });

    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Cek apakah masih ada sesi Firebase
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null && _currentUser == null) {
      final token = await firebaseUser.getIdToken();
      _currentUser = UserModel.fromJson({
        'id': firebaseUser.uid,
        'name': firebaseUser.displayName ?? '',
        'email': firebaseUser.email ?? '',
        'phone': firebaseUser.phoneNumber,
        'photo_url': firebaseUser.photoURL,
        'role': 'user',
        'token': token,
      });
    }
    return _currentUser;
  }
}