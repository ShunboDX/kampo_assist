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

7. Render 用の Gem 設定（PostgreSQL 使用）

開発では SQLite、本番では PostgreSQL を利用するため Gemfile を調整：

group :production do
  gem "pg", "~> 1.5"
end


push して反映完了。

8. 本番用 database.yml の設定（Rails 8 / Solid 構成）

Rails 8 は SolidCache / SolidQueue / SolidCable のため
production で複数の DB 接続が必要。

以下を config/database.yml に追加：

production:
  primary:
    url: <%= ENV["DATABASE_URL"] %>

  cache:
    url: <%= ENV["DATABASE_URL"] %>

  queue:
    url: <%= ENV["DATABASE_URL"] %>

  cable:
    url: <%= ENV["DATABASE_URL"] %>


※ これを設定しないと以下のエラーが発生する：

The `cable` database is not configured for the `production` environment.

9. Render で Web Service を作成

GitHub と Render を連携

リポジトリ kampo_assist を選択

デプロイ対象ブランチ: main

設定：

Build コマンド
bundle install && bundle exec rake db:migrate

Start コマンド
bundle exec puma -C config/puma.rb

10. Render の環境変数設定

Render Dashboard → Environment Variables に設定：

KEY	VALUE
DATABASE_URL	Render が自動生成
RAILS_ENV	production
RACK_ENV	production
SECRET_KEY_BASE	Render の Generate を利用
11. デプロイとエラー対応

最初のデプロイで発生した SolidCable エラー：

The `cable` database is not configured…


→ database.yml を修正して再デプロイ
→ デプロイ成功

12. 本番環境での動作確認

Render のログにて以下を確認：

アプリ起動成功

/assets/* へのアクセスがログに記録

実際の Web ページが閲覧できる

ここまでで完了したセットアップ一覧
・Rails プロジェクト作成
・GitHub リポジトリ作成 & push
・Home#index 実装
・RuboCop（Rails 8 標準）
・dotenv 設定
・RSpec 導入
・Render へデプロイ準備
・PostgreSQL 化
・database.yml 調整（Solid 系対応）
・Render で環境変数設定
・本番デプロイ成功

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
