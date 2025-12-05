# README初期セットアップ 完了済みタスクまとめ
本プロジェクトで、開発開始からここまでに実施した初期セットアップ内容をまとめます。環境構築の再現性を高めるため、作業ログとして記録しています。

1. Rails プロジェクトの作成
以下のコマンドで新規 Rails アプリを作成しました。

rails new kampo_assist
作成後、GitHub にリポジトリを作成し、main ブランチへ初回 push を完了。

Ruby バージョンの確認
Ruby 3.2.2

2. TOP ページ（Home#index）の作成
コントローラを作成：

rails g controller home index
ルート設定を追加：

config/routes.rb
root "home#index"

ブラウザで動作確認済み：
 http://localhost:3000

3. RuboCop（コード解析ツール）のセットアップ
Rails 8 標準の rubocop-rails-omakase が自動導入されているため、 .rubocop.yml は既に存在しており、基本設定も完了済み。
RuboCop の動作確認：

bundle exec rubocop
結果：

30 files inspected, no offenses detected
→ Omakase スタイルに準拠し、現状コードに問題なし。

4. dotenv の準備（環境変数管理）
.env ファイルを作成：

touch .env
.gitignore によって Git 管理外であることも確認済み。
今後 API キーや環境変数はここへ記述する。

5. 開発サーバー動作確認
以下のコマンドで起動し、正常動作することを確認：

bin/rails s
アクセス URL：
 http://localhost:3000

6. RSpec（テスト環境）の導入
RSpec の導入と初期化：

bundle add rspec-rails --group "development,test"
bin/rails g rspec:install
RSpec の動作確認：

bundle exec rspec
基本的なテスト設定が完了し、以降の開発で利用可能。

 テストの実行方法
プロジェクトのテストはすべて RSpec で実行します。
▼ 全テスト実行

bundle exec rspec
▼ 特定ディレクトリのみ（例：リクエストスペック）

bundle exec rspec spec/requests

ここまでで環境構築済みの内容
* Rails アプリ作成
* GitHub リポジトリ作成 & 初回 push
* Home#index の実装 & root 設定
* RuboCop 導入（Rails 8 標準）
* dotenv 設定
* 開発サーバー起動確認
* RSpec 導入・動作確認

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
