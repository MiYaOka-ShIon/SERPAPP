import 'package:flutter/material.dart';
import 'package:my_project_flutter/screens/shop_page.dart';
import 'package:my_project_flutter/auth/auth_service.dart';

Future<String> getAccessTokenFromMicrosoft() async {
  final auth = WindowsEntraAuthService();
  return await auth.login();
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final auth = WindowsEntraAuthService();

              final accessToken = await auth.login();

              debugPrint("TOKEN取得成功");

              if (!context.mounted) return;

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const ShopPage(),
                ),
              );
            } catch (e) {
              debugPrint("ログインエラー: $e");

              if (!context.mounted) return;

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
