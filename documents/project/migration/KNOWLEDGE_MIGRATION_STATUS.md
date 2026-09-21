# Knowledge Migration Status

```yaml
document_type: "repository_local_migration_status"
authority: "derived_from_documents/knowledge"
language: "Japanese"
```

## 現在地

第1情報源モデルへの移行を開始済み。

### 完了

- `documents/knowledge/` を第1情報源として定義。
- 第0→第1→第2情報源の更新方向をrepo documentationへ反映。
- user決定メッセージ3件を原文単位でrecord化。
- 旧 `docs-jp/**/source-logs/` 5件を本文無加工で `documents/knowledge/records/legacy-source-logs/` へコピー。
- 5件のsource logはcopy元とcopy先のGit blob SHA一致を確認。
- 旧artifactの意味保存監査用に作成した英語の再構成候補は `documents/project/migration/semantic-preservation-candidate/` へ退避。
- `artifacts/` 自体は未変更。

## Legacy source log の扱い

copyした5件は、内容を現在の結論へ書き換えていない。

内部に旧authority、旧status、当時の評価が含まれていても、そのまま保存している。

これは:

```text
内部の全命題を現在も肯定する
```

という意味ではなく、

```text
その時点で何が提言・評価・採用・却下されていたかを
記録として正確に保存する
```

ため。

## 未完了: legacy artifact-only knowledge

現行artifact 14 Markdownは英語主体であり、かつ第2情報源として圧縮・再構成された文書。

現在のルールには同時に:

1. `documents/knowledge/` は日本語であること。
2. 第1情報源へ取り込むsource本文は原文を変えないこと。

がある。

そのため、英語のlegacy artifact本文をそのままknowledgeへコピーすると言語方針に反し、日本語へ翻訳して入れると原文無加工方針に反する。

この矛盾を勝手に解消しない。

現時点では:

- 現行artifactはそのままGit上に保持。
- 意味保存詳細監査結果は `semantic-preservation-candidate/` に保持。
- source logがある領域はknowledgeへ原文コピー済み。
- source logが不足するlegacy artifact-only知識はmigration pending。

## 次に決める必要があること

非日本語の第0/legacy sourceをknowledgeへ保存する場合のルール。

候補例:

- 原文をknowledge内に完全保存し、日本語onlyを「説明本文の標準」と解釈する。
- 原文bytesを別raw storeへ置き、knowledgeには完全な日本語訳とraw参照を置く。
- 原文と完全日本語訳を同一recordに併記する。

どれを採る場合も、情報劣化を起こす要約・抜粋・意訳は不可。
