import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_app/domain/entities/user.dart';
import 'package:kakeibo_app/domain/repositories/auth_repository.dart';
import 'package:kakeibo_app/presentation/state/states/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  
  AuthNotifier({required this.authRepository}) : super(const AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // 既存の認証情報をチェック
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        state = AuthState(
          user: user,
          status: AuthStatus.authenticated,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      state = const AuthState(status: AuthStatus.loading);
      
      final user = await authRepository.signInWithEmailPassword(email, password);
      
      state = AuthState(
        user: user,
        status: AuthStatus.authenticated,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      throw e; // UIでのエラーハンドリングのため再スロー
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const AuthState(status: AuthStatus.loading);
      
      final user = await authRepository.signInWithGoogle();
      
      state = AuthState(
        user: user,
        status: AuthStatus.authenticated,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      throw e;
    }
  }

  Future<void> signInWithApple() async {
    try {
      state = const AuthState(status: AuthStatus.loading);
      
      final user = await authRepository.signInWithApple();
      
      state = AuthState(
        user: user,
        status: AuthStatus.authenticated,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      throw e;
    }
  }
}
