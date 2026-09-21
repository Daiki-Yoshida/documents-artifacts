# Knowledge Update Workflow

```yaml
document_type: "repository_local_workflow"
authority: "derived_from_documents/knowledge"
language: "Japanese"
first_source: "documents/knowledge/"
```

この文書は、このrepositoryを更新するための運用手順である。

意味上の根拠は常に `documents/knowledge/` を優先する。この文書とknowledgeが矛盾する場合、この文書を修正する。

## 1. 情報源モデル

```text
第0情報源
  Chat / Issue / 調査 / 実験 / ユーザー・AIの提言
        ↓
        ↓ 原文を情報劣化なく取り込む
        ↓
第1情報源
  documents/knowledge/
        ↓
        ↓ 用途に合わせて解釈・圧縮・再構成
        ↓
第2情報源
  artifacts/ 等のAI向け派生情報
```

根拠record:

- `documents/knowledge/records/K-2026-09-21-001.md`
- `documents/knowledge/records/K-2026-09-21-002.md`

## 2. 第0情報源の取り込み

第0情報源から第1情報源へ入れる際は、1つのsource eventを完全な単位として扱う。

例:

- Chatの1メッセージ
- Issue本文
- Issueの1コメント
- 調査結果の原文
- 実験結果の完全な出力/報告
- AIからの提言本文
- ユーザーによる採用・却下・訂正メッセージ

本文について禁止:

- 要約
- 抜粋
- 言い換え
- 順序変更
- 都合の悪い部分の削除
- 重複を理由とした削除
- 「現在は不要」という判断による歴史の消去

記録の外側には、source、日時、記録ID、明示された関係などのprovenance metadataを付与してよい。

## 3. 議論の評価を保存する

第1情報源は「内部のすべての命題が肯定的に正しい」という意味ではない。

提言、仮説、反論、否定、採用、保留、訂正、後続判断を、その評価関係と時系列ごと正確に保存する。

過去の案が後から否定された場合、過去recordを削除・書き換えて現在の結論だけにしない。否定や新しい判断を新しいsource eventとして追加する。

## 4. 日本語

`documents/knowledge/` は日本語で人間が監査可能な状態を維持する。

技術用語、固有名詞、path、command、code、API名などは、意味が明確になる場合は原語を維持してよい。

第0情報源が日本語以外の場合の「原文完全保存」と「knowledgeを日本語とする」両立方法は、別途明示的に決定するまで勝手に情報を落とす翻訳を行わない。

## 5. 第2情報源の生成

第2情報源では、用途に応じて以下を許可する。

- 現在有効な結論の抽出
- コンテキスト圧縮
- 重複除去
- 概念別・task別の再配置
- AI向け表現への変換
- progressive disclosure
- token消費効率の最適化
- 必要に応じた翻訳

ただし変換の根拠は第1情報源に追跡可能でなければならない。

第2情報源の内容に疑義がある場合、第2情報源同士で解決せず、knowledgeへ戻る。

## 6. 更新方向

通常の情報更新方向は一方向とする。

```text
第0情報源
  ↓
documents/knowledge/
  ↓
artifacts/
  ↓
target projects
```

禁止:

```text
artifactだけを編集して新しいreusable knowledgeを成立させる
target projectの派生copyを正本扱いする
artifactの要約を根拠にknowledgeの原文recordを書き換える
```

artifact側で誤りを発見した場合:

1. knowledgeを確認する。
2. knowledgeが正しくartifactだけが誤っているなら、第2情報源の変換ミスとして修正する。
3. knowledgeにも訂正が必要なら、その根拠となる第0情報源を新しいrecordとして取り込む。
4. その後、第1情報源に基づいてartifactを再更新する。

## 7. recordの修正

原文recordの本文は原則append-onlyの履歴として扱う。

取り込み時の転記ミスなど、sourceとの不一致を発見した場合は正確な原文へ訂正してよい。ただし、判断の変化を「訂正」として過去recordへ上書きしてはならない。

判断の変化・追加情報・反論・採用・却下は新しいrecordにする。

## 8. artifact migration

現在の `artifacts/` は旧module構造の派生情報として残っている。

新しいartifact構造を決める前に:

1. 現行artifactを生んだ既存source log・議論・決定を第1情報源へ完全に取り込む。
2. 不足しているsourceについては、利用可能な最も一次に近い記録をprovenance付きで保存する。
3. 第1情報源のcoverageを確認する。
4. その後にだけ、第2情報源としてartifactを再設計する。

旧artifactのlayoutを第1情報源の分類へ持ち込まない。
