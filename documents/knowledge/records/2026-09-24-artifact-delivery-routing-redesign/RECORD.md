# Artifact delivery / routing redesign source — 2026-09-24

```yaml
記録種別: "第0情報源からの原文記録"
情報源: "ChatGPT会話内のユーザーメッセージ"
記録日: "2026-09-24"
原文言語: "日本語"
編集方針: "各収録メッセージ本文は無要約・無抜粋・無言い換え"
関係: "legacy artifact packagingを破棄し、subjectsをAIへ効率的に継承するartifact architecture再設計の原意"
```

## ユーザー原文 1 — legacy構成を前提にしない

```text
いや、artifacts/  の中身は大幅に変えたいな。　そもそもartifacts/ の構成がよくなかったんだよね。履歴に残ってないかな？
```

## ユーザー原文 2 — artifactの目的

```text
進めていこう。　 artifacts/ ファイルをそのままいろいろなプロジェクトに渡すことで、 subjects の内容を適切に様々なプロジェクトのAIに継承させることが目的だ。　　ただし、 subjects と異なるのは、　AIのトークン効率やそれに伴う適切なファイルサイズやファイルルーティンを実現することだ。
```
