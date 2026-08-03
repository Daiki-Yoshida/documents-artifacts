# documents-artifacts

3つのドキュメント戦略プロジェクトの配布用アーティファクト（`artifacts/`）を一括で同期するための親プロジェクトです。

## 構成

本リポジトリは、以下の3つの子プロジェクトを同ディレクトリ配下に束ねています。各子プロジェクトはそれぞれ独自のGitリポジトリとして管理されており、親リポジトリ（本リポジトリ）はこれらを `.gitignore` で除外しています。

```yaml
design-principles:
  path: "design-principles/"
  scope: "コード設計・実装品質・AIワークフロー"
  artifacts: "INDEX.md, DESIGN_PHILOSOPHY.md, CODING_STANDARDS.md, AI_WORKFLOW.md, PROJECT_STRUCTURE.md"

documentation-strategy:
  path: "documentation-strategy/"
  scope: "AI向けドキュメントの構造と運用"
  artifacts: "INDEX.md, DOCUMENTATION_PHILOSOPHY.md, FILE_AND_STRUCTURE.md, DOCUMENT_WORKFLOW.md"

development-environment-strategy:
  path: "development-environment-strategy/"
  scope: "開発環境・ツール・実行・リポジトリ運用"
  artifacts: "INDEX.md, DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md, ENVIRONMENT_STANDARDS.md, WORKSPACE_STRUCTURE.md, ENVIRONMENT_WORKFLOW.md"
```

## リポジトリ管理の方針

- 親リポジトリ（`documents-artifacts`）は、配布用スクリプト、テスト、本READMEなど、親側のメタファイルだけを管理します。
- 3つの子ディレクトリは親の `.gitignore` で除外され、それぞれの子Gitリポジトリで独立に管理されます。
- GitHub上の子リポジトリは従来通りそれぞれ残置します。
- 配布スクリプトは子リポジトリに対して `git pull`、`git reset` などを実行しません。配布前に必要なrefへ更新してください。

## 使い方

### 3つのアーティファクトを一括同期

```bash
./copy-all-artifacts.sh path/to/target/documents/artifacts
```

指定したディレクトリ配下に各プロジェクト名のサブディレクトリを作り、それぞれの `artifacts/*.md` を配置します。同名ファイル（`INDEX.md` など）の衝突を避けるため、配布元ごとにサブディレクトリを分けます。

```text
<destination>/
├─ .documents-artifacts-manifest
├─ design-principles/                  (*.md)
├─ documentation-strategy/             (*.md)
└─ development-environment-strategy/   (*.md)
```

引数を省略した場合はカレントディレクトリを同期先とします。

### 更新時の動作

`copy-all-artifacts.sh` は、同期先の `.documents-artifacts-manifest` に、このスクリプトが配布したファイルだけを記録します。

```yaml
追加: "配布元に新しく存在するMarkdownを配置する"
更新: "配布元と同じpathにあるファイルの内容が変わっていれば上書きする"
維持: "内容が同じ管理対象と、現在の配布対象pathに含まれない同期先独自ファイルは変更しない"
削除: "前回manifestにあり、現在の配布元からなくなったファイルだけを削除する"
```

初回実行でmanifestが存在しない場合は、既存ファイルを削除しません。現在の配布元ファイルを追加・更新してmanifestを作成し、次回以降の削除範囲を確定します。配布元と同じpathに既存ファイルがある場合、そのファイルは更新対象となり、同期後はmanifestの管理対象になります。

そのため、旧スクリプトで過去に配布され、すでに配布元から削除されたファイルは、初回のmanaged syncでは自動判定できません。

スクリプトは書き込み前に、3つすべての子プロジェクトについて `artifacts/` とトップレベルMarkdownの存在を確認します。入力不足、危険なmanifest entry、symlinkによる管理pathの差し替え、通常ファイル以外との衝突がある場合は、同期開始前に失敗します。

配布先Gitのcommit、rollback、checkout、resetは行いません。同期結果の確認と復旧は、配布先プロジェクトのGit履歴で行ってください。

### 個別にコピーする場合

各子プロジェクトには従来のコピースクリプトも残っています。必要に応じて個別に実行できます。

```bash
bash design-principles/copy-design-docs.sh path/to/target
bash documentation-strategy/copy-design-docs.sh path/to/target
bash development-environment-strategy/copy-environment-docs.sh path/to/target
```

個別スクリプトは親のmanifest同期対象ではありません。廃止ファイルを含めて3セットを繰り返し更新する場合は、`copy-all-artifacts.sh` を使用してください。

## 検証

親スクリプトの同期契約は、合成した一時ワークスペースで検証できます。

```bash
bash -n copy-all-artifacts.sh
bash tests/test-copy-all-artifacts.sh
```

テストは、初回導入、上書き、追加、廃止済み管理ファイルの削除、同期先独自ファイルの保護、入力不足時のpreflight失敗、unsafe manifest、symlink、管理pathの型衝突を確認します。

## 各アーティファクトの読み方

各プロジェクトのアーティファクトは `INDEX.md` を入口として読む設計になっています。詳細は各子プロジェクトのREADMEと `artifacts/INDEX.md` を参照してください。
