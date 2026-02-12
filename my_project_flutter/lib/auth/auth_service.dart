import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:http/http.dart' as http;

class WindowsEntraAuthService {
  static const clientId = "5dc86638-59b9-46df-9f4c-f78686c86f29";
  static const tenantId = "7e80b39f-2bf1-4395-a356-64b74b4015bb";

  static const redirectPort = 54321;
  static const redirectUri = "http://localhost:54321";

  static const scopes = "openid profile offline_access User.Read";

  // =============================
  // PKCE生成
  // =============================
  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (_) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll("=", "");
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = sha256.convert(utf8.encode(verifier)).bytes;
    return base64UrlEncode(bytes).replaceAll("=", "");
  }

  Future<String> login() async {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    final authUrl =
        "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/authorize"
        "?client_id=$clientId"
        "&response_type=code"
        "&redirect_uri=$redirectUri"
        "&response_mode=query"
        "&scope=${Uri.encodeComponent(scopes)}"
        "&code_challenge=$codeChallenge"
        "&code_challenge_method=S256";

    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        title: "Microsoft Login",
        windowWidth: 600,
        windowHeight: 800,
      ),
    );

    final completer = Completer<String>();

    webview.addOnUrlRequestCallback((url) {
      if (url.startsWith(redirectUri)) {
        final uri = Uri.parse(url);
        final code = uri.queryParameters["code"];

        if (code != null) {
          webview.close();
          completer.complete(code);
        }
      }
    });

    webview.launch(authUrl);

    final code = await completer.future;

    // =============================
    // トークン交換
    // =============================
    final tokenResponse = await http.post(
      Uri.parse(
          "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "client_id": clientId,
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectUri,
        "code_verifier": codeVerifier,
        "scope": scopes,
      },
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception("トークン取得失敗: ${tokenResponse.body}");
    }

    final data = jsonDecode(tokenResponse.body);
    return data["access_token"];
  }
}
