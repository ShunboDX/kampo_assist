# CI セキュリティチェック運用（bundler-audit / brakeman）

## 何をしているか
- bundler-audit: Gem の脆弱性（CVE / GHSA）を検出する
- brakeman: Rails アプリの静的解析でセキュリティリスクを検出する

## 今回の対応（2026-02-14）
- Ruby 3.2.2 は 2026-03-31 にサポート終了（EOL）予定のため、Brakeman(EOLRuby) が警告 → CI fail
  - 対応：Ruby を 3.3.6 に更新（.ruby-version）
- faraday 2.14.0 に脆弱性（CVE-2026-25765）があり、bundler-audit が検出 → CI fail
  - 対応：faraday を 2.14.1 以上へ更新（Gemfile.lock）

## CI が落ちた時の確認コマンド
```bash
bundle exec brakeman
bin/bundler-audit check --update
bundle exec rspec

**commit**
```bash
git add docs/ci_security.md
git commit -m "docs: add CI security checks guide (brakeman/bundler-audit)"
git push -u origin docs/ci-security-maintenance