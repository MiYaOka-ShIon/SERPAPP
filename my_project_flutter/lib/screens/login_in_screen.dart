import 'package:flutter/material.dart';
import 'package:my_project_flutter/screens/shop_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ShopPage(),
              ),
            );
          },
          child: const Text('Microsoftアカウントでログイン'),
        ),
      ),
    );
  }
}
