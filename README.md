# documents-artifacts

3つのドキュメント戦略プロジェクトの配布用アーティファクト（`artifacts/`）を一括でコピーするための親プロジェクトです。

## 構成

本リポジトリは、以下の3つの子プロジェクトを同ディレクトリ配下に束ねています。各子プロジェクトはそれぞれ独自の Git リポジトリとして独立に管理されており、親リポジトリ（本リポジトリ）はこれらを `.gitignore` で除外しています。

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

- 親リポジトリ（`documents-artifacts`）は、バンドル用スクリプトと本 README など、親側のメタファイルのみを管理します。
- 3つの子ディレクトリは親の `.gitignore` で除外され、それぞれの子 Git リポジトリで独立に管理されます。
- GitHub 上の子リポジトリは従来通りそれぞれ残置します。

## 使い方

### 3つのアーティファクトを一括コピー

```bash
./copy-all-artifacts.sh path/to/target/documents/artifacts
```

実行すると、指定したディレクトリ配下に各プロジェクト名のサブディレクトリが作成され、それぞれの `artifacts/*.md` が配置されます。同名ファイル（`INDEX.md` など）の衝突を回避するため、ソースごとにサブディレクトリを分けています。

```
<destination>/
  design-principles/                  (*.md)
  documentation-strategy/             (*.md)
  development-environment-strategy/   (*.md)
```

引数を省略した場合はカレントディレクトリをコピー先とします。

### 個別にコピーする場合

各子プロジェクトには従来のコピースクリプトも残っています。必要に応じて個別に実行できます。

```bash
bash design-principles/copy-design-docs.sh path/to/target
bash documentation-strategy/copy-design-docs.sh path/to/target
bash development-environment-strategy/copy-environment-docs.sh path/to/target
```

## 各アーティファクトの読み方

各プロジェクトのアーティファクトは `INDEX.md` を入口として読む設計になっています。詳細は各子プロジェクトの README と `artifacts/INDEX.md` を参照してください。
