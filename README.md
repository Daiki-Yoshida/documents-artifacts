# documents-artifacts

再利用可能なengineering knowledgeと、そこからproject向けに配布するAI runtime guidanceを管理するrepository。

このrepositoryは、**情報の完全性を守る第1情報源**と、**AIのtoken効率・routingを優先する第2情報源**を分離する。

## 情報源モデル

```text
第0情報源
Chat / Issue / 調査 / 実験 / ユーザー・AIからの提言
        ↓
documents/knowledge/records/
        ↓
documents/knowledge/subjects/
第1情報源・正本
        ↓ projection
artifacts/
第2情報源・AI runtime guidance
        ↓ whole-pack sync
target project / documents/artifacts/
```

ファイル化された情報に疑義・矛盾・意味差がある場合は、`documents/knowledge/` を最優先で確認する。

## Repository Layout

```text
.
├─ README.md
├─ artifacts.sh
├─ artifacts/                 # Artifact v2。AI向け第2情報源
│  ├─ INDEX.md                # 小さいtask router
│  ├─ design/
│  ├─ implementation/
│  ├─ operation/
│  ├─ documentation/
│  ├─ project/
│  ├─ execution/
│  └─ safety/
├─ docs-jp/                   # legacy human/source-log領域
├─ documents/
│  ├─ INDEX.md
│  ├─ knowledge/              # 第1情報源
│  └─ project/                # このrepository自身の運用・migration docs
└─ tests/
```

## Knowledge

`documents/knowledge/` が正本。

- `records/`: 第0情報源を原文のまま保存する。
- `subjects/`: semantic ownershipで整理した現在のknowledge。
- `system/`: knowledge / record / subject / traceability / artifact projection規則。

新しいreusable knowledgeをartifactだけへ直接追加しない。

詳細:

```text
documents/knowledge/INDEX.md
documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
```

## Artifact v2

`artifacts/` は、subjectsをそのままコピーしたものではない。

subjectsは**semantic ownership**で正規化し、artifactsは**AI consumption / routing**で再構成する。

主原則:

- whole packをtarget projectへ配布する。
- AIは必ず `artifacts/INDEX.md` からtaskに必要なfileだけ読む。
- file数ではなく、1 taskあたりの**small relevant context**を最適化する。
- history / provenance / migration detailはruntime artifactから圧縮する。
- normative strength / condition / exception / negative guardは落とさない。
- concise Englishをruntime defaultとし、日本語canonical knowledgeとの二言語重複を避ける。
- project-local ruleがgeneric guidanceを意図的にspecializeする場合はlocal ruleを優先する。
- installed copyはmanaged derived snapshotであり、project固有ruleやgeneric correctionを直接書き込まない。

設計とprojection map:

```text
documents/project/ARTIFACT_ARCHITECTURE_V2.md
documents/project/migration/ARTIFACT_PROJECTION_MAP_V2.md
```

## Distribution

`artifacts.sh` はArtifact v2全体を1つのmanaged packとして扱う。

### Sync / update

対話:

```bash
./artifacts.sh
```

非対話:

```bash
./artifacts.sh --target /path/to/project --non-interactive
```

sync先:

```text
<target>/documents/artifacts/
```

syncはmanaged rootを**完全置換**する。旧artifact、stale file、target側で直接加えたmanaged-copy差分は残さない。

### List

```bash
./artifacts.sh --list
```

配布pack内のrelative file pathを表示する。

### Remove

```bash
./artifacts.sh --target /path/to/project --remove --non-interactive
```

removeは `documents/artifacts/` 全体を明示的に削除する。project-ownedな他の `documents/` 内容は対象にしない。

旧 `--modules` interfaceはArtifact v2で廃止した。部分installではなく、**whole-pack delivery + selective reading**を使う。

## Update Flow

```text
new source / decision
  ↓
records
  ↓
subjects
  ↓
artifact projection review
  ↓
artifacts/
  ↓
target projects
```

artifactの誤りを見つけた場合はknowledgeを確認する。knowledgeが正しくartifactだけが誤っているならprojection errorとしてartifactを修正する。knowledge自体に訂正が必要なら、根拠となる新しい第0情報源をrecordへ追加してからsubjects→artifactsの順で更新する。

## Validation

```bash
bash -n artifacts.sh
bash tests/test-artifacts.sh

bash -n tests/test-knowledge-integrity.sh
bash tests/test-knowledge-integrity.sh
```

legacy artifactのGit blob / migration inventoryは監査証拠としてhistoryとmigration docsから引き続き検証するが、現在のruntime `artifacts/` はArtifact v2である。
