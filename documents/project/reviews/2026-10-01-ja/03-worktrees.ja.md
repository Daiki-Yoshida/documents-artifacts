> 監査参照用翻訳（非正本）。原文: `artifacts/project/WORKTREES.md`（commit `93b0fab575f28698e61ae56202004eeab75d6861`）。[固定GitHub版](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/artifacts/project/WORKTREES.md)。翻訳: GPT-6-Luna high。

# Worktreeの契約

Work固有のGit worktreeを作成、診断、または削除するときに限り、これを読む。

## 識別情報の入力

通常の操作では、次を使用する。

```yaml
WORK: "<work-type>/<work-name>"
REPO: "<安定したプロジェクトリポジトリセレクター>"
BASE: "Workブランチが存在せず、かつ文書化されたデフォルトがない場合に、開始参照として必要"
```

プロジェクトが単一リポジトリであっても、公開契約がプロジェクトの将来的な拡張時に変わらないよう、`REPO`を明示する。

呼び出し側は次の値を手動で指定するべきではない。

- 任意のworktreeパス
- sparse-checkoutを使うかどうか
- 原則としてブランチ名

これらはWorkとリポジトリの識別情報から決定論的に解決する。

## パス

```text
<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/
```

無関係なファイルシステム上の内容が対象パスを占有している場合は、安全側に停止する。

## ブランチの意味

ブランチの開始参照とupstreamは別々に決定する。

Workブランチが存在しない場合:

- 明示された`BASE`または文書化されたプロジェクトのデフォルトを使う
- 偶然の現在のHEADをベースとして使わない
- ベースから作成しても、そのベースブランチを自動的に追跡することにはならない

同名のリモートWorkブランチは、プロジェクトポリシーに従って、対応するリモートブランチを追跡してもよい。

## Project Repositoryのmaterialization不変条件

選択されたリポジトリのブランチツリーに、追跡対象であるプロジェクトレベルの`.worktrees/**`調整状態が含まれる場合、ネストされたlinked worktreeでプロジェクトレベルの`.worktrees/`ツリーを再帰的にmaterializeしては**ならない**。

検証済みの作成手順:

```bash
git worktree add --no-checkout <path> <branch>

git -C <path>   sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <path>   reset --hard HEAD
```

この低レベル手順は、プロジェクトが管理する作成操作でラップするべきである。worktreeのローカル状態はworktreeとともに削除されるため、再作成時にもポリシーを再適用する。

プロジェクトレベルの追跡対象調整ツリーを含まない独立したComponent Repositoryに、このsparseポリシーをむやみに適用してはならない。

## 作成契約

少なくとも次を事前確認する。

- Project Root/リポジトリが解決される
- Workの構文が有効である
- ブランチが決定論的に解決される
- ブランチが存在しない場合、明示または文書化されたベースがある
- 対象パスが存在しないか、要求されたものと正確に一致する登録済みworktreeである
- 無関係な内容がパスを占有していない
- ブランチが、互換性のない別の書き込み可能worktreeによって所有されていない
- 必要な場合、Project Repositoryのignore境界が隣接worktreeのパスをカバーする
- 必要なmaterialization機能がサポートされている

作成操作は冪等であるべきである。

- 有効なworktreeが正確に既存する場合 → 何もせず成功
- 既存状態が競合または無効の場合 → 診断して失敗
- デフォルトでは、ブランチを横取りしたり、破壊的な修復を行ったりしない

成功を返す前に、次を検証する。

- 登録済みGit worktreeのパスが、解決済みパスと一致する
- checkout済みブランチが、解決済みWorkブランチと一致する
- 書き込み可能なcheckoutが1つのみという所有権不変条件が保たれている
- Project Repositoryのcheckoutでは、Work Documentsがmaterializeされ、追跡対象であり、隣接worktreeのパスが通常の未追跡プロジェクト内容として現れない。Work Documentsを一括でignoreしてはならない
- materialization契約が適用される場合、通常のリポジトリ内容がmaterializeされ、ネストされた`.worktrees/`が存在せず、worktreeローカルのsparse状態が有効である

コマンドが終了コード0で終了していても、これらの確認に失敗した作成は成功ではない。

作成が途中で失敗した場合、安全であれば、その呼び出しで作成した状態だけをロールバックする。既存のworktreeやブランチを削除してはならない。

## Status契約

Statusは変更を加えず、識別情報とmaterializationを診断するのに十分な情報を表示するべきである。

- Work Identity
- リポジトリセレクター/ルート
- 解決済みブランチ/パス
- 登録状態
- 現在のHEAD/ブランチ
- clean/dirty状態
- 該当する場合はmaterialization/sparse状態
- ネストされたプロジェクトレベルの`.worktrees/`が存在しないか
- 関連する場合はWork Documentsの可視性

Git/ファイルシステムを信頼できる情報源として使い、重複するレジストリを作成しない。

## 削除契約

少なくとも次を事前確認する。

- 解決済みパスが、想定リポジトリの登録済みworktreeである
- 解決済みの識別情報/ブランチが、要求されたWORK/REPOの想定と一致する
- worktreeに未コミットの変更がない
- プロジェクトポリシーに従ってコミットが保持される

通常の削除:

- 選択した登録済みworktreeだけを対象にする
- dirty状態なら拒否する
- forceではなく通常の`git worktree remove`を使う
- ブランチを削除しない
- Work Documentsを削除しない
- Work Rootを削除しない
- 隣接リポジトリを削除しない

強制削除、ブランチ削除、Work Rootの一括消去、保持されないコミットの喪失、または共有リソースの削除は破壊的操作であり、安全上のガイダンスを必要とする。

## 検証の範囲

参照検証では、次の条件でこの契約が実証された。

```yaml
topology: "単一リポジトリ"
REPO: "main"
case: "Project Repository自体をlinked worktreeにする"
Git: "2.43.0"
OS: "WSL2/Linux"
```

検証済み: materialization、create/status/remove、冪等な作成、競合ガード、dirty状態での削除拒否、削除と再作成、base-refとupstreamの分離。

この参照実装で完全には検証されていない項目:

- 実際の複数リポジトリのマッピング
- 独立したComponent Repositoryの通常のmaterialization経路
- macOS / ネイティブWindows Git
- すべての旧版/新版Git

これら未検証の領域を、実験で証明済みであるかのように示してはならない。
