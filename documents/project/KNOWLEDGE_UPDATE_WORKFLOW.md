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
documents/knowledge/records/
        ↓
documents/knowledge/subjects/
第1情報源
        ↓ projection
artifacts/
第2情報源
        ↓ distribution
target projects
```

根拠record:

- [knowledge-source-model](../knowledge/records/2026-09-21-knowledge-source-model/RECORD.md)
- [knowledge-record-accuracy](../knowledge/records/2026-09-21-knowledge-record-accuracy/RECORD.md)

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

記録の外側にはprovenance metadataを付与してよい。保存先は原則 `documents/knowledge/records/YYYY-MM-DD-<short-title>/` とする。

短い採用・修正指示が直前のAI提案や監査結果を参照している場合、その指示だけで承認対象を推測復元しない。取得可能な元提案・監査結果を別source eventとして記録する。

## 3. 議論の評価を保存する

第1情報源は「内部のすべての命題が肯定的に正しい」という意味ではない。

提言、仮説、反論、否定、採用、保留、訂正、後続判断を、その評価関係と時系列ごと保存する。

過去案が後から否定された場合、過去recordを書き換えず、新しいsource eventを追加する。

## 4. Subjectへの反映

`records/` は原文・snapshot、`subjects/` は責務別knowledgeを担当する。新しい判断をsubject本文だけで発明しない。

1. 必要なrecordと後続の採用・却下・訂正recordを確認する。
2. `subjects/INDEX.md` から主責務を持つsubjectを選ぶ。
3. 主authorityを更新し、関係subjectの局所再述・routingを整合させる。
4. traceabilityを維持する。
5. 新subjectは旧module名ではなく独立した知識対象に基づいて作る。

構造規則は `documents/knowledge/system/SUBJECT_MODEL.md`、traceabilityは `TRACEABILITY_MODEL.md` に従う。

## 5. 日本語

`records/` は原文言語を維持し、整理済み `subjects/` と `system/` は日本語を標準とする。技術用語、path、command、API名は意味精度のため原語を維持してよい。

Artifact runtime languageは `ARTIFACT_MODEL.md` に従い、現在はconcise Englishをdefaultとする。

## 6. Artifact projection

Artifact v2はsubjectsのdirectory構造をコピーしない。

projection時は:

- semantic ownershipはsubjectsへ残す。
- AIが同じtaskで同時に必要とするknowledgeをcontext co-occurrenceでまとめる。
- root / directory INDEXをrouterとして使う。
- history / provenance / migration detailを通常runtime contextから圧縮する。
- normative strength / condition / exception / negative guard / ownership boundaryを保持する。
- 同じruleを複数leafの独立authorityとして作らない。
- translationで意味の強さを変えない。

詳細:

```text
documents/knowledge/system/ARTIFACT_MODEL.md
documents/project/ARTIFACT_ARCHITECTURE_V2.md
documents/project/migration/ARTIFACT_PROJECTION_MAP_V2.md
```

artifact本文に疑義がある場合、artifact同士で正しさを決めずknowledgeへ戻る。

## 7. 更新方向

```text
第0情報源
  ↓
records
  ↓
subjects
  ↓
artifacts
  ↓
target projects
```

禁止:

- artifactだけを編集して新しいreusable knowledgeを成立させる。
- target projectのinstalled copyを正本扱いする。
- artifact要約を根拠に原文recordを書き換える。
- project-local overrideをgeneric artifact本体へ逆輸入する。

artifact側で誤りを発見した場合:

1. knowledgeを確認する。
2. knowledgeが正しくartifactだけが誤っているならprojection errorとしてartifactを修正する。
3. knowledgeにも訂正が必要なら根拠となる第0情報源を新recordへ取り込む。
4. subjectsを更新する。
5. artifact projectionを再確認する。
6. target projectへ再syncする。

## 8. recordの修正

原文record本文は原則append-onlyの履歴として扱う。

取り込み時の転記ミスなどsourceとの不一致は正確な原文へ訂正してよい。判断の変化を過去recordへの上書きで表現しない。

## 9. Artifact v2の保守

旧3 module layoutは2026-09-24にArtifact v2へ置換済み。

現在の配布単位は**1 whole pack**。

変更時:

1. knowledge変更の有無を確認する。
2. `ARTIFACT_PROJECTION_MAP_V2.md` で影響leafを特定する。
3. 必要leafだけを更新する。
4. cross-file authorityが二重化していないか確認する。
5. root/directory routingが適切か確認する。
6. internal link、代表task routing、token量を確認する。
7. `bash tests/test-artifacts.sh` と `bash tests/test-knowledge-integrity.sh` を実行する。
8. target projectへwhole-pack syncする。

新しいartifact directory/fileを作る判断はsubject ownershipではなくtask routing / context co-occurrenceで行う。

旧14 artifactは現行runtimeへ復活させない。必要なhistorical comparisonはGit historyとmigration auditを利用する。
