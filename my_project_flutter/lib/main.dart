import 'package:flutter/material.dart';
import 'package:my_project_client/my_project_client.dart';
import 'package:my_project_flutter/screens/login_page.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:window_manager/window_manager.dart';

late final Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // ウィンドウ固定設定
  const windowOptions = WindowOptions(
    size: Size(1020, 1280),
    minimumSize: Size(1020, 1280),
    maximumSize: Size(1920, 1280),
    center: true,
    title: 'オフィスいずこ',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Serverpod 初期化（※ 今回は未使用だが残す）
  final serverUrl = await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // ← Flutter初期表示画面
    );
  }
}
