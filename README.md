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
├─ install.sh                 # curl | sh remote bootstrap
├─ artifacts.sh               # managed pack sync/remove implementation
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

### GitHub からの直接 install/update

対象Projectの**Project Root**で、次の1行を実行する。初回installとupdateは同じcommand。

<!-- remote-delivery-snippet -->
```bash
curl -fsSL https://raw.githubusercontent.com/Daiki-Yoshida/documents-artifacts/main/install.sh | sh
```
<!-- /remote-delivery-snippet -->

`install.sh` はremote acquisition専用の薄いbootstrapであり、Artifact v2の同期処理そのものは既存の `artifacts.sh` へ委譲する。

```text
current Project Root
  ↓ ./documents/ の存在確認
install.sh
  ↓ GitHub main snapshotを一時取得
artifacts.sh
  ↓ whole-pack exact replacement
./documents/artifacts/
```

- **Project Root guard**: 実行directoryに既存の `./documents/` が無い場合は、日本語 / Englishのエラーを表示して終了する。bootstrapが `documents/` を勝手に作ることはない。
- **symlink guard**: `./documents/` がsymlinkの場合も処理を中止する。
- **完全置換**: `./documents/artifacts/` が無ければinstall、存在すればupdateとして、managed root全体を現在のpackで完全置換する。stale fileやmanaged copyへの直接編集は残らない。
- **取得方式**: GitHub上の公式repository `main` archiveを `curl` で一時directoryへ取得・展開し、そのsnapshot内の `artifacts.sh` を実行する。source checkoutをtargetへ常置しない。
- **前提**: `sh`, `bash`, `curl`, `tar`, `mktemp` とgithub.comへのoutbound network。Git clientはremote install/updateには不要。
- **log**: bootstrapのstatus/errorは日本語 / English併記で出力する。
- **failure safety**: source取得・展開・validationが失敗した場合はmanaged replacementを開始しない。sync失敗時のstage/promote/rollback semanticsは `artifacts.sh` と同じ。
- **temporary cleanup**: success / failure / signalのいずれでもbootstrap用temporary directoryを削除する。
- **project-owned files**: `AGENTS.md`、`README.md`、project `documents/INDEX.md` 等には触れない。自動commitもしない。
- **固定source**: source repositoryは `Daiki-Yoshida/documents-artifacts`、refは `main` 固定。commit/tag/ref選択やbackground updaterは提供しない。
- sync後はtarget repositoryをGitでreviewし、Project側でcommitする。

`artifacts.sh` 単体をraw URLからpipe実行する方法は使わない。sibling `artifacts/` packが必要なため、remote入口は `install.sh` とする。

local checkoutがある場合の従来の `./artifacts.sh --target ...` 利用とremovalは変わらない。

### Project-owned entry hooks

installerがmanagedにするのは `documents/artifacts/` のみ。agentをpackへ導くproject側の入口 (`AGENTS.md`、`README.md`、project `documents/INDEX.md` など) はadopting project自身が所有し、pack updateはそれらを書き換えない。

最小例 — projectの `documents/INDEX.md` に、既存のowner routeと並べてgeneric linkを1本置く:

```markdown
| Question | Owner |
|---|---|
| ...      | ...   |

Reusable guidance for common engineering work is installed under
`artifacts/`; start at `artifacts/INDEX.md` when a task needs it.
```

hookはroot `artifacts/INDEX.md` へのgeneric linkに留める。task固有のleaf pathやleaf要約をentry surfaceへ書かず、選択的読みはagent側のroutingに任せる。

hookの強度はadopting projectの選択:

- **conditional link** — 「taskが必要とするとき `artifacts/INDEX.md` を見よ」(参照は条件付き)。
- **required entry** — 「projectのengineering/documentation変更の前に `artifacts/INDEX.md` を参照し、taskに関連するguidanceだけを適用せよ」(root参照を必須化。whole-pack preloadは要求しない)。

どちらもproject-ownedなadoption判断であり、効果の優位は各projectの計測でのみ判断する (1回のrun結果から因果的な優位は主張しない)。`tests/` の `project-entry-discovery` / `project-entry-required` scenarioが両variantの観測条件を規定する。

根拠・運用:

```text
documents/knowledge/subjects/documentation/S003_WORKFLOW.md  # canonical
artifacts/documentation/PRINCIPLES_AND_ROUTING.md            # installed guidance
artifacts/documentation/WORKFLOW_AND_MAINTENANCE.md
```

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
sh -n install.sh
bash -n artifacts.sh
bash tests/test-artifacts.sh

bash -n tests/test-knowledge-integrity.sh
bash tests/test-knowledge-integrity.sh

bash tests/test-agent-harness.sh
```

legacy artifactのGit blob / migration inventoryは監査証拠としてhistoryとmigration docsから引き続き検証するが、現在のruntime `artifacts/` はArtifact v2である。


## Execution-agent Artifact tests

Artifact v2のAI routing / behaviorを実project fixture上で検証するharnessは `tests/` に置く。

```bash
bash tests/scripts/prepare-agent-test.sh --scenario contract-boundary
```

prepare scriptが表示するsource repository外のtemporary `repo/` をexecution agentのworking directoryにし、そのrun rootの `PROMPT.md` のみをtaskとして渡す。評価基準 `tests/scenarios/<scenario>/EXPECTATIONS.md` はagentへ事前提示しない。

詳細: `tests/INDEX.md`
