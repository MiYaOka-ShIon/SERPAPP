import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print('登録');
          },
          child: const Text('登録'),
        ),
      ),
    );
  }
}
