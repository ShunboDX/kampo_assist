# CI セキュリティチェック運用ガイド
（bundler-audit / brakeman）

このドキュメントは、**CI（GitHub Actions）でセキュリティチェックが失敗した場合に、
原因を素早く理解し、適切に対処するためのガイド**です。

---

## CIで何をチェックしているか

### bundler-audit
- Gem の **既知の脆弱性（CVE / GHSA）** を検出
- 依存関係に脆弱性がある場合、CIを失敗させる

### brakeman
- Rails アプリに対する **静的セキュリティ解析**
- よくある脆弱性パターンや、EOL（サポート終了）状態を検出

---

## CIが失敗したときの最短確認手順（ローカル）

まずは以下を **上から順に実行**する。

```bash
bundle exec brakeman
bin/bundler-audit check --update
bundle exec rspec