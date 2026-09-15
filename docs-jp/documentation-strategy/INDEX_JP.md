# ドキュメント戦略 - 索引

```yaml
document_type: "index"
target_audience: "ai_agents"
language: "english"
role: "エクスポートされたドキュメント戦略アーティファクトセットの入口"
strategy_version: "2.1.0"
```

> **注**: このファイルは `artifacts/INDEX.md` の日本語訳です。AIエージェントが読むべき正式版は `artifacts/INDEX.md`（英語）です。この翻訳は人間による内容確認用です。

本ファイルはエクスポートされた戦略の入口です。最初に読んでください。

## 読む順序

```yaml
1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  正確性優先、スコープ、記録としてのgit、design-principlesとの関係
2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: ファイル役割、ディレクトリ配置、バージョニング、git規約、階層、削除
3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: セットアップ、更新、ブラウンフィールド、陳腐化対応、バージョンbump、削除
```

初回接触時は 1 → 2 → 3 の順に読む。特定のタスクの場合は、クイックタスクルーティングから該当箇所へジャンプする。

## 基礎レンズ

これらのアーティファクトは **正確性第一・ルーティング駆動** のドキュメントパラダイムを前提としている。

```yaml
core_idea: "ドキュメントはAIエージェントに正確な情報を適切なタイミングで提供する。トークン効率はファイル構造とルーティングによって達成され、情報の切り詰めによることはない。"
priority: "正確性 > ルーティング > トークン効率"
scope: "documents/ のみ — コード設計ではなく、gitのタイミングではなく、ブランチングではない"
audience: "documents/ は完全にAI向け。人間向けコンテンツは docs-jp/ に置く"
recording: "Gitは記録ツールである — コミットメッセージの形式とバージョン追跡を管理し、コミットのタイミングは管理しない"
```

## Ownership Map（唯一の情報源）

各概念は正確に1つのドキュメントに存在する。複製せずリンクすること。

```yaml
DOCUMENTATION_PHILOSOPHY.md:
  owns:
    - "情報の正確性を最優先（正確性 > トークン効率）"
    - "スコープ境界: documents/ のみ、コードではない"
    - "記録ツールとしてのGit（原則、タイミングではない）"
    - "デフォルトでAI向け。人間向けは別の関心事"
    - "切り詰めよりルーティング: ファイルを分割し、情報を縮小しない"
    - "design-principlesとの関係（ドメイン境界、使用パターン、同時読みガイダンス）"
    - "よくある誤読"

FILE_AND_STRUCTURE.md:
  owns:
    - "documents/ ディレクトリ: 全てAI向け"
    - "docs-jp/ ディレクトリ: 人間向け（日本語）"
    - "INDEX.md の役割: ルーティングハブ + ドキュメントバージョンレジストリ"
    - "ファイル役割: エージェントエントリファイル、INDEX.md、プロジェクトドキュメント、参照ドキュメント"
    - "ドキュメントバージョニングシステム: セマンティックバージョン + gitコミットハッシュ"
    - "二段階コミットハッシュワークフロー"
    - "陳腐化検出の実践（git log コマンド）"
    - "INDEX.md のバージョンbump（index_version）"
    - "ドキュメント用のgitコミットメッセージ規約"
    - "相互参照・ルーティング戦略（相対パス）"
    - "ディレクトリ分割ガイド（三の法則）"
    - "階層プロジェクト（親子ドキュメント）"
    - "ドキュメント削除ルール"
    - "複数開発者によるINDEX.md競合の緩和"
    - "ファイルフォーマット標準"

DOCUMENT_WORKFLOW.md:
  owns:
    - "新規プロジェクトセットアップ: ステップバイステップ"
    - "ブラウンフィールド導入: 監査、分類、移行"
    - "継続的ドキュメント更新"
    - "陳腐化対応: 検出、分類、更新フロー"
    - "バージョンbumpワークフロー（二段階コミット）"
    - "ドキュメント作成デシジョンツリー"
    - "ドキュメント削除ワークフロー"
    - "再読み込みトリガー"
    - "確認ゲート（L0–L3）"
```

## クイックタスクルーティング

```yaml
"新規プロジェクトのドキュメントをセットアップ":           "DOCUMENT_WORKFLOW.md（新規プロジェクトセットアップ）+ FILE_AND_STRUCTURE.md（ファイル役割）"
"既存プロジェクトに本戦略を導入":                         "DOCUMENT_WORKFLOW.md（ブラウンフィールド導入）"
"既存ドキュメントを更新":                                 "DOCUMENT_WORKFLOW.md（継続的更新）+ FILE_AND_STRUCTURE.md（適切なファイルを見つける）"
"ドキュメントが陳腐化している（HEADより遅れている）":     "DOCUMENT_WORKFLOW.md（陳腐化対応）+ FILE_AND_STRUCTURE.md（陳腐化検出）"
"ドキュメントのバージョンをbumpする":                     "DOCUMENT_WORKFLOW.md（バージョンbump）+ FILE_AND_STRUCTURE.md（バージョニングシステム）"
"更新後にコミットハッシュを記録する":                     "DOCUMENT_WORKFLOW.md（二段階コミット）+ FILE_AND_STRUCTURE.md（コミットハッシュワークフロー）"
"ドキュメントのgitコミットメッセージを書く":              "FILE_AND_STRUCTURE.md（gitコミット規約）"
"この情報はどのファイルに置くべきか":                     "FILE_AND_STRUCTURE.md（ファイル役割定義）"
"新規ディレクトリを作成すべきか":                         "FILE_AND_STRUCTURE.md（ディレクトリ分割ガイド）"
"マルチサービスプロジェクトの構造化方法":                 "FILE_AND_STRUCTURE.md（階層プロジェクト）"
"documents/INDEX.md のセットアップ":                     "FILE_AND_STRUCTURE.md（INDEX.mdの役割）+ DOCUMENT_WORKFLOW.md（新規プロジェクトセットアップ）"
"ドキュメントを削除する":                                 "DOCUMENT_WORKFLOW.md（ドキュメント削除）+ FILE_AND_STRUCTURE.md（ドキュメント削除ルール）"
"ドキュメントを二つに分割する":                           "FILE_AND_STRUCTURE.md（ディレクトリ分割ガイド）+ DOCUMENT_WORKFLOW.md（バージョンbump）"
"いつ本戦略を再読み込みすべきか":                         "DOCUMENT_WORKFLOW.md（再読み込みトリガー）"
"本戦略は何を管理対象とするか":                           "DOCUMENTATION_PHILOSOPHY.md（スコープ境界）"
"design-principlesとの関係":                              "DOCUMENTATION_PHILOSOPHY.md（design-principlesとの関係）"
```
