import 'package:flutter/material.dart';
import 'package:my_project_flutter/screens/shop_page.dart';
import 'package:my_project_flutter/auth/auth_service.dart';

Future<String> getAccessTokenFromMicrosoft() async {
  final auth = WindowsEntraAuthService();
  return await auth.login();
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  
  get AuthService => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // ① Microsoft 認証（今はダミー）
              final accessToken = await getAccessTokenFromMicrosoft();

              // ② Flask にトークン送信
              final user =
                  await AuthService.authenticateWithBackend(accessToken);

              // ③ 成功したら画面遷移
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const ShopPage(),
                ),
              );

              // デバッグ用
              debugPrint(user.toString());
            } catch (e) {
              debugPrint(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ログイン失敗')),
              );
            }
          },
          child: const Text('Microsoftアカウントでログイン'),
        ),
      ),
    );
  }
}
