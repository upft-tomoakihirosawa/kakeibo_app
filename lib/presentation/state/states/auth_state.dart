import 'package:kakeibo_app/domain/entities/user.dart';

enum AuthStatus {
  initial,      // 初期状態
  authenticated, // 認証済み
  unauthenticated, // 未認証
  loading,      // 認証処理中
  error,        // エラー発生
}

class AuthState {
  final User? user;
  final AuthStatus status;
  final String? errorMessage;
  
  const AuthState({
    this.user,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  // ゲッター
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;

  // イミュータブルな状態更新のためのメソッド
  AuthState copyWith({
    User? user,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
