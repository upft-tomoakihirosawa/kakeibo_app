import 'package:flutter/foundation.dart';
import 'package:kakeibo_app/domain/repositories/auth_repository.dart';
import 'package:kakeibo_app/domain/repositories/mock_auth_repository.dart';
import 'package:kakeibo_app/domain/repositories/web_auth_repository.dart';

class AuthRepositoryFactory {
  static AuthRepository create({bool useMock = false}) {
    if (useMock) {
      return MockAuthRepository();
    }
    
    // WebとMobileで異なる実装を提供
    if (kIsWeb) {
      return WebAuthRepository();
    } else {
      // モバイル向け実装 (今回は簡略化のためMockを使用)
      return MockAuthRepository();
    }
  }
}
