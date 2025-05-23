import 'package:kakeibo_app/domain/entities/user.dart';
import 'package:kakeibo_app/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  User? _currentUser;

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<User> signInWithEmailPassword(String email, String password) async {
    // 実際の実装ではFirebase Authを使用
    await Future.delayed(const Duration(seconds: 1)); // 遅延をシミュレート
    
    if (email == 'test@example.com' && password == 'password123') {
      _currentUser = User(
        id: 'mock-user-id',
        email: email,
        displayName: 'テストユーザー',
      );
      return _currentUser!;
    } else {
      throw Exception('メールアドレスまたはパスワードが正しくありません');
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    // 実際の実装ではGoogle Sign-Inを使用
    await Future.delayed(const Duration(seconds: 1)); // 遅延をシミュレート
    
    _currentUser = User(
      id: 'mock-google-user-id',
      email: 'google-user@example.com',
      displayName: 'Googleユーザー',
      photoUrl: 'https://example.com/profile.jpg',
    );
    return _currentUser!;
  }

  @override
  Future<User> signInWithApple() async {
    // 実際の実装ではApple Sign-Inを使用
    await Future.delayed(const Duration(seconds: 1)); // 遅延をシミュレート
    
    _currentUser = User(
      id: 'mock-apple-user-id',
      email: 'apple-user@example.com',
      displayName: 'Appleユーザー',
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500)); // 遅延をシミュレート
    _currentUser = null;
  }
}
