import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:kakeibo_app/domain/entities/user.dart' as app;
import 'package:kakeibo_app/domain/repositories/auth_repository.dart';

class WebAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  WebAuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Future<app.User?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return app.User.fromFirebase(user);
  }

  @override
  Future<app.User> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('認証に失敗しました。ユーザー情報が取得できません。');
      }
      return app.User.fromFirebase(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('ユーザーが見つかりません。メールアドレスを確認してください。');
        case 'wrong-password':
          throw Exception('パスワードが正しくありません。');
        case 'invalid-email':
          throw Exception('メールアドレスの形式が正しくありません。');
        default:
          throw Exception('認証エラー: ${e.message}');
      }
    } catch (e) {
      throw Exception('認証中にエラーが発生しました: $e');
    }
  }

  @override
  Future<app.User> signInWithGoogle() async {
    try {
      // Web専用のGoogle認証実装
      final provider = firebase_auth.GoogleAuthProvider();
      final userCredential = await _firebaseAuth.signInWithPopup(provider);
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Google認証に失敗しました。ユーザー情報が取得できません。');
      }
      return app.User.fromFirebase(user);
    } catch (e) {
      throw Exception('Google認証中にエラーが発生しました: $e');
    }
  }

  @override
  Future<app.User> signInWithApple() async {
    try {
      // Web専用のApple認証実装
      final provider = firebase_auth.OAuthProvider('apple.com');
      final userCredential = await _firebaseAuth.signInWithPopup(provider);
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Apple認証に失敗しました。ユーザー情報が取得できません。');
      }
      return app.User.fromFirebase(user);
    } catch (e) {
      throw Exception('Apple認証中にエラーが発生しました: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
