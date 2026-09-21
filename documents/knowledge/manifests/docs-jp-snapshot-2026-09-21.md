# docs-jp snapshot manifest — 2026-09-21

```yaml
manifest_type: "knowledge provenance manifest"
language: "日本語"
source_snapshot_commit: "d68ec413b4bb3dafe90e1aaed3c8de9487b1453c"
source_root: "docs-jp/"
copy_policy: "本文無加工"
verification: "copy元とknowledge側copyのGit blob SHA一致を確認"
source_file_count: 16
captured_file_count: 16
```

## 目的

このmanifestは、旧 `docs-jp/` に存在した情報を `documents/knowledge/` へ取り込む際のprovenanceだけを管理する。

各本文の意味を要約・再解釈しない。

旧文書内部に記載されたauthority、status、当時の正本path、当時の評価も、歴史的記録の一部として改変していない。

現在の判断は、それらの記述単独ではなく、後続するknowledge recordを含めた時系列・評価関係から読み取る。

## 分類

```yaml
original_or_rationale:
  meaning: "owner authored original notes / rationale / design source log"

experiment_or_validation:
  meaning: "実験・検証結果を保存したrecord"

historical_translation:
  meaning: "過去artifact/versionを日本語化した履歴資料"

human_companion:
  meaning: "当時のartifactを人間向けに案内・説明する派生文書"

legacy_authority_policy:
  meaning: "当時のdocs-jp/artifacts authority関係そのものを記録した文書"
```

分類は「現在その内容を採用する」という意味ではない。

## Capture一覧

| 分類 | copy元 | knowledge側 | blob SHA |
|---|---|---|---|
| legacy_authority_policy | `docs-jp/README.md` | `records/legacy-docs-jp/README.md` | `f27bc8759b2479ff82763a50bec304286fa82c80` |
| human_companion | `docs-jp/design-principles/ENCAPSULATION_HORIZON_JP.md` | `records/legacy-docs-jp/design-principles/ENCAPSULATION_HORIZON_JP.md` | `43e95ed85bf68fd77fde1d212ac3e8cbfb4a2484` |
| original_or_rationale | `docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md` | `records/legacy-source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md` | `ecad4ecf22fe510b7f71ef0e7c9be684298d73c9` |
| historical_translation | `docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` | `records/legacy-docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` | `d42d372288b567ad581f278776dec2aeb73f2c67` |
| historical_translation | `docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md` | `records/legacy-docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md` | `4efa0fc46f40c34501065fe5e39d179db6d6f8eb` |
| historical_translation | `docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md` | `records/legacy-docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md` | `18df39991d46a01ba359c6f661b9b4177cc94d46` |
| human_companion | `docs-jp/development-environment-strategy/INDEX.md` | `records/legacy-docs-jp/development-environment-strategy/INDEX.md` | `eefbe361cfc8fca4f012c33d27348ce0433ea3a3` |
| historical_translation | `docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md` | `records/legacy-docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md` | `0880df2c6f076a1db8cd636d5bd47e453016c016` |
| original_or_rationale | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md` | `records/legacy-source-logs/WORK_IDENTITY_DESIGN_JP.md` | `914c937eb0ae9813b4c736d74723212126bda04e` |
| experiment_or_validation | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md` | `records/legacy-source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md` | `eb7a9d28d05297128845056b9c019796ad31efad` |
| original_or_rationale | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md` | `records/legacy-source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md` | `9fd3fbdc6dc9dfda105bfb4ef956b77fec7557a2` |
| experiment_or_validation | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md` | `records/legacy-source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md` | `dc5ef3b599a35d6f908f10c536ead3886cfb539c` |
| historical_translation | `docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md` | `records/legacy-docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md` | `0f1d8fa44761a67262d9347b60a8004e6d41b5d3` |
| historical_translation | `docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md` | `records/legacy-docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md` | `1a09132c1b5718fdfd75efc11049d65627f9c667` |
| historical_translation | `docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md` | `records/legacy-docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md` | `9ab9bebb551096aed78643d2d35153c5168c2f2a` |
| human_companion | `docs-jp/documentation-strategy/INDEX_JP.md` | `records/legacy-docs-jp/documentation-strategy/INDEX_JP.md` | `2834c1dad901366cc438e5fe05112b0e4954dbea` |

## 完了条件

`docs-jp/` snapshot `d68ec413b4bb3dafe90e1aaed3c8de9487b1453c` に存在した16ファイルについて、knowledge側で本文を失わず参照可能な状態になった。

これにより、今後 `docs-jp/` 自体の役割や配置を変更しても、このsnapshot時点の情報は `documents/knowledge/` から復元・検証できる。
