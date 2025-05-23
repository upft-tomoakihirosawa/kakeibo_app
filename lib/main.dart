import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_app/domain/repositories/auth_repository.dart';
import 'package:kakeibo_app/domain/repositories/auth_repository_factory.dart';
import 'package:kakeibo_app/presentation/screens/auth/login_screen.dart';
import 'package:kakeibo_app/presentation/state/notifiers/auth_notifier.dart';
import 'package:kakeibo_app/presentation/state/states/auth_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// プロバイダー定義
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // 環境に応じたリポジトリを返す
  bool useMock = false; // 開発中は必要に応じてtrueに変更
  return AuthRepositoryFactory.create(useMock: useMock);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository: repository);
});

void main() async {
  // Firebase初期化処理を追加
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: kIsWeb 
        ? const FirebaseOptions(
            apiKey: "YOUR_API_KEY",
            authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
            projectId: "YOUR_PROJECT_ID",
            storageBucket: "YOUR_PROJECT_ID.appspot.com",
            messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
            appId: "YOUR_APP_ID",
          ) 
        : null, // モバイルの場合はデフォルト設定を使用
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 認証状態を監視
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      title: '家計簿アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF6366F1),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6366F1),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
