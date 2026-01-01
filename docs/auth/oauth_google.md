# Google OAuth ログイン仕様（Sorcery）

## 概要
本ドキュメントは、本アプリにおける **Google OAuth ログイン仕様** を定義する。  
既存の Sorcery による email/password ログインに加え、Google アカウントを用いた
SNSログインを提供する。

本仕様は、実装時のブレ防止および将来的なSNS追加を見据えた設計判断の共有を目的とする。

---

## 対象範囲
- 認証ライブラリ：Sorcery
- SNSプロバイダ：Google
- 対象Issue：#142（仕様決定）、#146〜#148（実装・検証）

---

## 用語
| 用語 | 説明 |
|---|---|
| provider | OAuthプロバイダ名（本仕様では `"google"`） |
| uid | Googleが発行するユーザー識別子（sub相当） |
| email_verified | Google側でメールアドレスが検証済みかどうか |
| Authorization | User と OAuth アカウントを紐付ける中間エンティティ |

---

## 基本方針
- ユーザーの一意性は **`provider + uid`** によって担保する
- メールアドレスは補助的な識別子として扱う
- 将来のSNS追加を考慮し、User に provider 固有の uid は直接持たせない

---

## DB設計方針
- User と OAuth アカウントは **中間テーブル方式** で管理する
- 中間テーブル（例：`authorizations`）に以下の情報を保持する

### 主なカラム例
- user_id
- provider（"google"）
- uid
- email（任意：監査/確認用）
- name（任意）

### 制約
- `provider + uid` に **unique制約** を付与する

---

## ログイン処理フロー

### 優先順位
OAuth コールバック時のユーザー判定は、以下の優先順位で行う。

1. **provider + uid が既に存在する場合**
   - 紐付いている User でログインする
2. **provider + uid が存在せず、email_verified=true かつ email が既存Userと一致する場合**
   - 既存Userに OAuth アカウントを紐付けしてログインする
3. **provider + uid が存在せず、email_verified=true かつ email 一致Userが存在しない場合**
   - 新規Userを作成し、OAuth アカウントを紐付けしてログインする
4. **上記以外**
   - ログイン失敗として扱う

---

## 新規User作成時の仕様
- email：Googleから取得した email を設定する
- name：Googleの表示名を設定（該当カラムが存在する場合）
- password：未設定でも可（Sorceryの通常ログインを必須としない）

---

## Sorceryでのログイン制御
- OAuthログイン成功時は **`auto_login(user)`** を使用する
- ログアウト処理は既存の `logout` を踏襲する

---

## セキュリティ方針
- **email_verified=false の場合は自動紐付けを行わない**
- 未検証メールによる既存Userの乗っ取りを防止するため、
  email一致による紐付けは email_verified=true の場合に限定する

---

## エラー・キャンセル時の挙動
- Google認証がキャンセルされた場合
- 必要なOAuth情報が取得できない場合
- 検証条件（email_verified 等）を満たさない場合

上記いずれの場合も、ログイン画面へリダイレクトし、
フラッシュメッセージを表示する。

（例）
- 「Googleログインに失敗しました」

---

## テスト・動作確認観点（#148）
- provider + uid が既に存在する場合、正しいUserでログインできる
- email_verified=true かつ email一致の場合、既存Userに紐付けられる
- email_verified=true かつ email不一致の場合、新規Userが作成される
- email_verified=false の場合、ログインが失敗する
- 認証キャンセル時にエラー表示される

---

## 将来拡張
- GitHub / Apple など他SNSを追加する場合も、本仕様を踏襲する
- provider を切り替えることで同一設計で対応可能とする
