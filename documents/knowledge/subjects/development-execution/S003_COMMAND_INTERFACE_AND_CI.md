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

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-27-work-runtime-lifecycle-propagation/RECORD.md`
