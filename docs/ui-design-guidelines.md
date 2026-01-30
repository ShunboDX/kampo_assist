# UI Design Guidelines (Tailwind CSS)

本ドキュメントは、「漢方アシスト」における UI 設計の共通ルールを定義するものです。  
Tailwind CSS を用いたレイアウト・余白・文字サイズの基準を明文化し、画面ごとの UI のばらつきを防ぐことを目的とします。

---

## 1. レイアウト（Container）
全ページの基本レイアウトは、以下のコンテナを基準とする。

```erb
<div class="mx-auto max-w-6xl px-4 py-8">
  ...
</div>```

## 2. レイアウト（Container）
```<body class="min-h-screen bg-[#FAFCFB] text-slate-900">```

方針
背景色: bg-[#FAFCFB]
基本文字色: text-slate-900
サブテキスト: text-slate-600

3. 見出し・テキストのスケール
ページタイトル（h1）
```<h1 class="text-2xl md:text-3xl font-bold tracking-tight text-slate-900">```

セクション見出し（h2）
```<h2 class="text-xl md:text-2xl font-bold text-slate-900">```

本文（p）
```<p class="text-base text-slate-700">```

補足説明
```<p class="text-sm text-slate-600">```

4. レイアウトの原則
UI は「余白」を優先して設計する
画面幅は container によって統一する
新規画面は必ず本ガイドラインに従う
Tailwind の utility class を基本とし、独自CSSは最小限に留める

5. 適用範囲
本ガイドラインは、以下の画面に適用される。
検索フロー（Step1 / Step2 / Results）
漢方詳細画面
お気に入り・検索履歴
管理画面（最低限のレスポンシブ対応）

6. 今後の拡張予定
UIコンポーネント（Button / Card / Alert）の共通化
レスポンシブ設計の明文化
Tailwind Design Token の整理

---