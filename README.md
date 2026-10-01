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

### GitHub からの直接 install/update (source checkout 常置なし)

このrepositoryをcloneして維持しなくても、GitHub `main` branchから直接install/updateできる。内部では一時directoryへの shallow clone で配布物を取得し、取得した snapshot の `artifacts.sh` を実行して、成功/失敗に関わらず一時checkoutを削除する。transportにGitを使うだけで、新しいruntime・package manager・ref選択・background updater・target側の自動commitは導入しない。

対象projectのrootで実行する (初回installとupdateは同一command):

<!-- remote-delivery-snippet -->
```bash
(
  set -euo pipefail
  target="${ARTIFACT_TARGET:-$PWD}"
  tmp="$(mktemp -d)"
  trap 'rm -rf -- "$tmp"' EXIT
  GIT_TERMINAL_PROMPT=0 git clone -q --depth 1 --branch main \
    https://github.com/Daiki-Yoshida/documents-artifacts.git \
    "$tmp/documents-artifacts"
  bash "$tmp/documents-artifacts/artifacts.sh" \
    --target "$target" --non-interactive
)
```
<!-- /remote-delivery-snippet -->

- **完全置換**: syncは `<target>/documents/artifacts/` を旧内容から完全に置き換える。stale fileやmanaged copyへの直接編集は残らない。
- **前提**: `git` と `mktemp` (coreutils)、github.comへのoutbound network。公開repositoryのためcredential/tokenは不要。既存のGit credential helper/SSH設定があればそのまま使われ、auth設定の変更やtokenの入力要求・記録は行わない (`GIT_TERMINAL_PROMPT=0` は対話的credential promptを抑制するだけで、auth設定自体は変更しない)。
- targetはcommand実行時の `$PWD` を既定とし、取得処理を始める前に `target=` として明示的にcaptureされる。別pathへinstallする場合は、subshell blockの先頭に代入行を追加する ( `( ... )` の外側への `VAR=x` 前置はBashでは無効構文なので使わない):

  ```bash
  (
    ARTIFACT_TARGET=/path/to/project
    set -euo pipefail
    ...
  )
  ```

  `--non-interactive` を外せばconfirm prompt付きで実行できる。
- downloadはtargetへの変更を開始する前に完了する。fetchまたはsource validationの失敗時はinstalled packは変更されず、一時checkoutも削除される。
- sync後はtarget repositoryをGitでreviewし、project側でcommitする (自動commitはしない — 導入先の既存commitはそのまま残る)。
- `AGENTS.md`、`README.md`、project `documents/INDEX.md` などのproject-owned entry hookには触れない。targetには `artifacts/` の内容のみが `documents/artifacts/` へ届き、source repositoryの `.git` や他の内容は届かない。
- source repository URLは上記の公式repositoryに固定される。取得refは常に `main` — commit/tag/ref選択・mirror/source差し替えinterfaceはこのversionでは提供しない (test/offline検証はtest-local Git shimで行う)。
- stage/promote/backup動作はlocal `artifacts.sh` と同一で、実証済みの範囲を超えたcrash-atomicityは主張しない。raw URLから `artifacts.sh` 単体を直接実行する方法は推奨しない — sibling `artifacts/` directoryが必須のため。

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
