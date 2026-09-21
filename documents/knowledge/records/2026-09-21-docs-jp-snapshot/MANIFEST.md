# docs-jp snapshot — 2026-09-21

```yaml
record_type: "repository snapshot"
source_root: "docs-jp/"
source_snapshot_commit: "d68ec413b4bb3dafe90e1aaed3c8de9487b1453c"
captured_file_count: 16
payload_root: "files/docs-jp/"
copy_policy: "本文無加工"
integrity: "copy元とpayloadのGit blob SHA一致を確認"
```

## 目的

旧 `docs-jp/` に存在した情報を、1つのsnapshot recordとして保存する。

payload本文の意味をこのmanifestで要約・再解釈しない。

旧文書内部に書かれているauthority、status、当時の正本path、当時の判断も歴史的記録の一部として改変しない。

## Payload

```text
files/
└─ docs-jp/
   ├─ README.md
   ├─ design-principles/
   │  ├─ ENCAPSULATION_HORIZON_JP.md
   │  └─ source-logs/
   │     └─ ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md
   ├─ development-environment-strategy/
   │  ├─ DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md
   │  ├─ ENVIRONMENT_STANDARDS.md
   │  ├─ ENVIRONMENT_WORKFLOW.md
   │  ├─ INDEX.md
   │  ├─ WORKSPACE_STRUCTURE.md
   │  └─ source-logs/
   │     ├─ WORK_IDENTITY_DESIGN_JP.md
   │     ├─ WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md
   │     ├─ WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md
   │     └─ WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md
   └─ documentation-strategy/
      ├─ DOCUMENT_WORKFLOW_JP.md
      ├─ DOCUMENTATION_PHILOSOPHY_JP.md
      ├─ FILE_AND_STRUCTURE_JP.md
      └─ INDEX_JP.md
```

## Integrity

snapshot作成時に、16ファイルすべてについてsource側とpayload側のGit blob SHA一致を確認済み。

path移動によって本文内容は変更していない。

## 解釈

このrecordが保証するのは「snapshot時点で、これらの文書にこの内容が記録されていた」ことである。

各文書内部の個々の命題を現在も肯定する、という意味ではない。

現在のknowledgeとして利用するときは、後続recordやsubjectsで整理された評価関係も確認する。
