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

## Generic `DIR` — 公開コマンドのディレクトリ指定

Project RootをAI development sessionのentry surfaceとして維持する。Project-owned Makefile / wrapperで指定対象のdirectoryが可変となる場合は、**`DIR=<directory-path>`を汎用的なpublic inputとして優先する**。すべてのtargetに機械的に`DIR`を追加する義務ではなく、固定対象のoperationは固有の入口を使ってよい。

`DIR`自体は**指定されたパス**を表すだけで、Work Identity / Work Root / Repository Selector / Branch Identity / Runtime Identity / authorizationという意味を持たない。**受け取ったパスの意味・期待する対象の種類・存在要件・副作用は、呼び出されたoperationのcontractが決める。** パスをsubprocessのCWDへ変更することが共通の目的ではない。

~~~bash
# Work Rootをもとに、該当WorkのDocker環境を操作
make DIR=.worktrees/feat/pathfinding/ docker-up
make DIR=.worktrees/feat/pathfinding/ docker-status
make DIR=.worktrees/feat/pathfinding/ docker-down

# Repository checkoutをテスト対象にする
make DIR=.worktrees/feat/pathfinding/game/ test

# 指定ディレクトリを基準に生成する
make DIR=components/api/ generate

# 正規のWorktree配置候補を指定して作成する
make DIR=.worktrees/feat/pathfinding/game/ worktree-create
~~~

これはProjectが定義し得るoperation例であり、すべてのProjectが同じtarget名を提供する義務を意味しない。利用者はProject Rootから実在パスを辿れ、対応したshell環境ではTabによるpath補完を活用しやすい。補完動作はshell/Make設定にも依存するため、全環境で自動的に成立するとは仮定しない。

### 各operationによる対象の解決

- Work-scoped `docker-up` のような操作では、Work Rootとして検証した`DIR`から**operation内部で**Work Identityや必要なDocker Resource Identityを導出してよい。`DIR`をWork Identityへ一律に変換する規約ではない。
- `test` / `lint` なら受け取ったcheckout directoryそのものが対象となり得る。生成操作ならそのdirectoryを作成先や作成基準として利用できる。
- `worktree-create/status/remove` の公開inputも`DIR`の正規配置候補から内部のWork Identity + stable Repository Selectorを解決できる。Git worktreeのsemantic contractとpreflightは`../work-identity/S006_WORKTREE_COMMANDS.md`が主所有する。
- Work Rootしか示されず複数Repositoryのうち一つを選べない等、operationの指定対象が不明確なら勝手に選択しない。Work全体に作用するoperationなら、その範囲を明示的に定義する。

### Path resolution / 安全条件

- relative `DIR`はProject Rootから解決し、processの現在CWDに依存しない。末尾slash等の無害な表記差をnormalizeできる。
- 指定は1つのquoteされたpath valueとして扱い、shell fragmentをevalしない。path固有の`/main`、`/android`等の派生は必要なら**operation固有のresolver**が行い、`DIR`全体の意味にはしない。
- 既存対象が必要な操作では、targetが存在しなければfailする。一方、作成操作は最終targetの未存在を許容し、既存祖先のrealpath/symlink、正規配置、Git所有権や衝突の有無を検証してから作成する。
- absoluteまたはProject Root外のpathと書込はProjectの明示的なsupportとauthorityが必要。symlinkやmount後の実効targetも安全上重要なら検証する。
- `DIR`省略時はoperationがdocumentしたdefault targetを使う。省略が意図せず別Workやdefault Docker scopeへのfallbackにならないこと。
- **パス指定は承認・権限ではない。** Work Identityの確定、Git worktree登録・branch照合、destructive/external操作の安全gateを維持する。

### 同じoperation familyの解決一貫性

`docker-up/status/config/verify/down/cleanup`などは同じ入力pathとProject状態から同じsemantic target・Runtime/Resource Identityを解決する。非自明なderivationはProject所有の単一resolver/config sourceに寄せる。startだけWork-specificでdownやcleanupがdefault設定を使用する実装にしない。実行側は`S002_HOST_AND_CONTAINER.md`、Work resource lifecycleは`../work-identity/S004_LIFECYCLE_AND_RESOURCES.md`、destructive safetyは`../development-safety/`が所有する。

### Worktree lifecycleとの分担

Worktreeの公開コマンドは`DIR=<canonical-worktree-path>`を受けて、**内部**でWork Identity + Repository Selector + 必要なBASEを解決する形を採用できる。作成候補の最終directoryは未存在でもよいが、任意pathへのmaterializationを許すものではない。`BASE`等の独立した設定は必要に応じて別パラメータにできる。既存Projectが`WORK + REPO`というpublic syntaxを互換性のために保持することは許容するが、generic guidanceではその入力を利用者へ必須化しない。

### Project固有の先行例 — `plaru_expo`

`Daiki-Yoshida/plaru_expo`では`DIR=.worktrees/<task>`からoperationによって`/main`または`/android`を派生する。これはcommand-owned interpretationの実例であり、generic `DIR`のパス値にWorkやrepository roleを組み込む規範ではない。Project-local resolverが必要な対象の解決と検証を担う。

## Work Identity固有commandとの接続

このsubjectはMakefile / wrapper / scripts等の**generic public command surface**を所有する。

一方、worktree create/status/removeのWork Identity・repository selector・branch/path resolution等の**semantic contract**は `../work-identity/S006_WORKTREE_COMMANDS.md` が主所有する。内部identityを利用者が直接引数として指定する必要はない。

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
- CIでlocal開発時とは別のManagement Root Repository / project-level tool checkoutを利用する場合は、使用refを明示する。
- 未指定の外部workspace最新版へ偶然依存しない。

## Sources

- `../../records/2026-10-14-generic-dir-implementation-adoption/` — Work進行とIdentity選定の委任
- `../../records/2026-10-14-generic-dir-command-target/` — DIRの汎用入力に関するユーザーの訂正意図

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-10-03-project-root-execution-routing/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-27-work-runtime-lifecycle-propagation/RECORD.md`
