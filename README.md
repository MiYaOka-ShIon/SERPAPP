# My Project (Serverpod & Flutter)

このプロジェクトは、**Serverpod**（バックエンド）と **Flutter Desktop**（フロントエンド）で構成されたシステムです。

## ⚙️ 事前準備
プロジェクトを動かす前に、開発環境に以下のツールがインストールされていることを確認してください。

- **Flutter SDK** (Stable)
- **Dart SDK**
- **Docker Desktop**
- **Serverpod CLI** (`dart pub global activate serverpod_cli`)
- **Windows 開発者モード** (Windows設定 > システム > 開発者向け > 開発者モードをON)
- **環境変数の追加** C:\Users\・・・\flutter\bin と　C:\Users\・・・\AppData\Local\Pub\Cache\bin　を追加する
---

## 🚀 立ち上げ手順

リポジトリをクローンした後、以下の手順で環境を構築します。

### 1. 依存関係の解決
各ディレクトリでパッケージをインストールします。

```powershell
# サーバー側
cd my_project_server
dart pub get

# アプリ側
cd ../my_project_flutter
flutter pub get

```

### 2. パスワード設定(無視でお願いします)
~~セキュリティのためパスワードファイルはGit管理外です。以下のファイルを作成してください。~~

~~ファイルパス: my_project_server/config/passwords.yaml~~

内容例:

YAML

 開発用データベースのパスワード
~~database: password~~

 Redisのパスワード（デフォルトは空でOK）
redis: 

### 3. コード生成 (Serverpod Generate)
モデル定義から通信用コードを自動生成します。

```powershell

cd ../my_project_server
serverpod generate

```

### 4. データベースとサーバーの起動
Dockerを使用してPostgreSQLとRedisを起動し、テーブルを構築します。

```powershell

# コンテナの起動
docker compose up -d

# データベースのマイグレーション適用（初回のみ）
dart bin/main.dart --apply-migrations
```
エラーが出ると思います。モック作成がメインの場合は無視で構いません

5. Flutterアプリの実行
```powershell

cd ../my_project_flutter
flutter run -d windows
```

## 🛠 開発ルール
# モデルの変更: 
  my_project_server/lib/src/protocol/ 内の .yaml ファイルを変更した後は、必ず serverpod generate を実行してください。

# DBスキーマの変更: 
  モデルの変更をDBに反映させるには、serverpod create-migration を実行した後、サーバーを --apply-migrations 付きで再起動します。

# ディレクトリ構成:

my_project_server: サーバーサイドのロジック、DB定義

my_project_client: サーバーとアプリを繋ぐ自動生成コード（直接編集禁止）

my_project_flutter: Windows デスクトップアプリ本体

# 🆘 トラブルシューティング
'rm' は認識されていません: Windowsのコマンドプロンプトではなく、PowerShellを使用してください。

Symlink error: Windowsの設定から「開発者モード」をONにしてください。

Database connection refused: Docker Desktopが起動しているか、development.yaml の host が localhost になっているか確認してください。


---

~~### 5. GitHubへの反映コマンド (これをターミナルで実行してください)~~(無視でお願いします_2)

```powershell
git add README.md
git add .
git commit -m "docs: update README and project files"
git push origin main
```
