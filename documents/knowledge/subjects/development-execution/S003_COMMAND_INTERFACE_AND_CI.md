# 開発実行 — 公開コマンドとCI

人・AI・CIが利用するgeneric public command surface、操作意味、local/CIの実行経路を扱う。Work Identity固有operationのsemantic contractは `../work-identity/` が主所有する。

## 操作内容を明確にする

コマンド名も開発環境契約の一部です。

```yaml
原則: "実行前に、操作対象と起こることを判断できなければならない"
必要なこと:
  - "曖昧な操作には対象範囲を付ける"
  - "通常の後片付けと、データを捨てる強制削除を分ける"
  - "生のツール構文ではなく、安定した目的を公開する"
  - "失敗を隠さず、次に確認すべきことが分かる出力を残す"
```

プロジェクト内で意味が一つに定まるなら、短いコマンド名でも構いません。

---

## 3. 公開コマンド

projectは、日常操作を見つけやすい公開command interfaceを持ちます。

```yaml
推奨構成:
  Makefile: "公開操作名、help、parameter、単純な依存関係"
  wrapper: "checkout選択や環境準備を共通化する任意のCLI入口"
  scripts: "複雑な分岐、検証、orchestration、cleanup、provider固有処理"
```

### Makefile

- targetは生のcommand列ではなく、安定した目的を表す。
- 複雑なshell処理は `scripts/` などへ分離する。
- help targetで操作、parameter、破壊的効果を説明する。
- 構造化parameterには専用変数を使い、quoteが曖昧になる万能引数を避ける。
- ローカルとCIは、可能な限り同じtargetまたはscriptを呼ぶ。

### target名

対象や副作用が曖昧になる場合は `<scope>-<action>` を使います。

- すべてへ機械的にprefixを付ける必要はない。
- `help`、`check`、`test`、`validate` はproject内の意味が一つなら短いままでよい。
- `up`、`down`、`reset`、`clean`、`deploy`、`logs` は通常scopeを必要とする。
- 互換aliasを残す場合でも、正規targetを明記する。

### 操作の意味

- command文書には対象、見える効果、破壊範囲を書く。破壊性・confirmation boundaryは `../development-safety/` と整合させる。
- 非破壊commandを同じ名前のまま破壊的処理へ変えない。
- stop、container削除、volume削除、完全purgeを分ける。
- 最終検証の標準commandを一つ定義する。
- 部分検証は実装中や診断用であり、最終gateの代替ではない。
- 失敗時はnon-zeroで終了し、診断可能な出力を残す。

### scoped command familyのresolution一貫性

`<scope>-up` / `<scope>-status` / `<scope>-config` / `<scope>-verify` / `<scope>-down` / `<scope>-cleanup` のようなcommand familyは、同じtarget/scope resolverを使う。

command名が同じscopeを示していても、内部のscope/identity resolutionが異なれば契約として不十分である。create系commandがWork-specific configを解決し、stop/cleanup系commandがそれを落としてdefault名へfallbackする実装は、別のresource setを対象にし得る。

非自明なidentity derivationは、Makefile / JS / shell等で別々に再実装してdriftさせるより、1つのproject-owned resolver / script / configへ寄せ、全lifecycle commandがそれを共有する。ただし固定値や単純な結合まで過剰に抽象化する必要はない。

通常stopとdestructive purgeは引き続き分離し、cleanup/purge系commandも同じscoped resolutionを使って対象を限定する。

---

## Public commandはproject-owned execution interface

Makefile / wrapper / scriptsで構成するpublic command surfaceは、単なる入力短縮ではない。

人・AI・CIがprojectの意図したenvironment selection、scope resolution、safety boundary、verification pathを通ってroutine operationを実行するための **project-owned execution interface** である。

Project-owned public operationがrequested operationを提供している場合、人・AI・CIはroutine executionでそのinterfaceを優先し、underlying tool commandを独自に再構築して迂回しない。

例えばprojectが `make dev-install`、`make test`、`make dev-up` 等を正規operationとして提供しているなら、AIが対象checkoutへ移動して `npm install`、raw `docker compose`、provider-specific command等を独自の正規導線として作らない。

raw commandを利用してよい状況には少なくとも次がある。

- public interface自体を実装・修正している
- diagnostics / failure isolationのためunderlying toolを直接観測する必要がある
- requested operationを表すpublic interfaceが存在しない
- project documentationがraw operation自体を明示的な正規導線としている

この例外はraw commandの全面禁止を意味しない。ただしpublic interfaceを迂回する場合も、そのinterfaceが担っていたenvironment selection、scope、safety、verification semanticsを意図せず失わない。

## Execution Target Directory と `DIR`

Project RootをAI development sessionのentry surfaceとして維持しながら、build / install / test / lint / run / dev-up / verify等を別checkoutやworktreeへ作用させるため、public commandは必要に応じて **Execution Target Directory** を受け取れる。

Makefileをpublic routerとして使うprojectでは、そのnamed parameterとして `DIR` を利用できる。

```text
Agent Session Root
  = Project Root

Public Command Surface
  = Project Repository側のMakefile / wrapper

DIR
  = public operationが実際に作用するExecution Target Directory
```

Make-based projectでの典型形:

```bash
make DIR=.worktrees/feat/pathfinding/game dev-install
make DIR=.worktrees/feat/pathfinding/game test
make DIR=components/web lint
```

すべてのtargetへ機械的に `DIR` 対応を要求しない。対象directoryが固定されたproject-level operationでは不要である。

Make以外のpublic routerを使うprojectは、同じ意味のnamed / structured directory parameterを提供してよい。

### `DIR` の意味境界

generic `DIR` は、**path-valued execution target selector** である。

`DIR` 自体は次を意味しない。

- Work Identity
- Work Root
- Repository Selector
- Branch Identity
- Runtime Identity
- operation authority / authorization

そのためgeneric contractでは、`DIR=.worktrees/feat/hoge` を受け取って暗黙に `/main` や `/android` を追加するなど、Work topologyやrepository roleを意味論として埋め込まない。

project固有の高位selector / resolverが独自規約としてpathを派生することはできるが、generic `DIR` の意味は指定されたdirectory pathそのものに留める。

### path resolution contract

`DIR` を採用するpublic interfaceでは、次を基本とする。

- relative `DIR` はProject Rootを基準にresolveする。
- trailing slash等の表記差はnormalizeしてよい。
- pathはshell fragmentではなく1つのpath valueとしてquoteして扱う。
- operationがexisting targetを要求する場合、対象が存在しなければfail closedする。
- symlink / canonicalizationがscope判定へ影響する場合、解決後の実体pathも検証する。
- absolute pathまたはProject Root外pathは、projectが明示的にsupportするときのみ許容することをdefaultとする。
- `DIR` 未指定時は「processの現在CWDだから」という理由だけで対象を決めず、commandがdocumentしたdefault targetへresolveする。

`DIR` を指定できることは、そのdirectoryに対する任意operationのauthorityを与えない。破壊操作では `DIR` だけをscope / authorizationの根拠にせず、`../development-safety/` のidentity、precondition、confirmation ruleを適用する。

### Agent Session Rootとの接続

routine operationは次の形を取れる。

```text
AI session
  stays rooted at Project Root
       ↓
project-owned Makefile / wrapper
       ↓ DIR=<resolved-target>
project-owned script / resolver
       ↓
target repository / worktree
       ↓
underlying tool
```

内部scriptやsubprocessがtarget directoryへ `cd` する、`git -C` を利用する、tool固有のworking-directory optionを使うことは問題ない。

区別すべきなのは、AIがproject contextを取得する **Agent Session Root** と、個々のoperationが作用する **Execution Target Directory / subprocess working directory** である。

## Work Identity commandとの入力境界

Worktree lifecycle operationとgeneric execution-target selectionを混同しない。

`../work-identity/S006_WORKTREE_COMMANDS.md` が所有するworktree create/status/removeは、`WORK + REPO (+ BASE)` からbranch/path/materializationをdeterministically解決し、routine callerへarbitrary pathを入力させない。

一方、既に存在・materializeされたcheckout/worktreeにbuild/install/test/lint/run等を作用させるgeneric public operationでは、target directoryが可変なら `DIR=<path>` を利用できる。

```text
worktree-create / status / remove
  identity input = WORK + REPO (+ BASE)
  DIR            = canonical identity inputではない

build / install / test / lint / run / dev-up / verify
  execution targetが可変なら DIR=<path> を利用可能
```

`DIR` はWork Identityを作るAPIでも、repository worktreeをmaterializeするAPIでもない。

## Project-specific specialization example — `plaru_expo`

以下は**generic `DIR` の推奨形を示す例ではなく、project-specific higher-level specializationの実例**である。

`Daiki-Yoshida/plaru_expo` では、workspace rootのMakefileをpublic interfaceとして利用し、AI / developerがworkspace rootからcommandを実行したまま `DIR` でtask Work Rootを指定する実装がある。

例:

```bash
make DIR=.worktrees/feat/example-change docker-dev-install
make DIR=.worktrees/feat/example-change docker-dev-typecheck
make DIR=.worktrees/feat/example-change android-dev-up
```

このprojectでは `DIR=.worktrees/<task>` をtask Work Rootとして解釈し、operationに応じて `/main` または `/android` をproject-localに派生する。**この意味はgeneric `DIR` contractとは異なる。** またGit helper側の `DIR` も `.worktrees/<type>/<task>` 系へ限定されている。

このtask-pair specializationは `plaru_expo` 固有の規約として扱う。

generic knowledgeへ採用するのは、

- Project / workspace rootのpublic interfaceからtargetを選択できること
- named `DIR` parameterでexecution target selectionを表現できること

であり、`/main` / `/android` の暗黙派生をgeneric `DIR` contractへ持ち込まない。

## Work Identity固有commandとの接続

このsubjectはMakefile / wrapper / scripts等の**generic public command surface**を所有する。

一方、Work Identityとrepository selectorを入力とするworktree create/status/remove、branch/path resolution等のsemantic contractは `../work-identity/S006_WORKTREE_COMMANDS.md` が主所有する。

```text
development-execution
  generic public command / implementation routing
        ↓
work-identity
  Work-specific semantic operation
```

Work Identity operationをpublic commandとして公開する場合も、その意味契約をこのsubjectへ複製しない。

## 7. ローカルとCI

- CIのworkflow YAMLへbuild/test本体を再実装せず、project管理commandを呼ぶ。
- provisioningが異なっても、最終的には同じ検証scriptへ合流させる。
- provider固有準備はCI edgeに置き、project動作はrepository管理commandへ置く。
- CIで別Workspace Repositoryを利用する場合は、使用refを明示する。
- 未指定の外部workspace最新版へ偶然依存しない。

## Sources

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-10-03-project-root-execution-routing/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-27-work-runtime-lifecycle-propagation/RECORD.md`
