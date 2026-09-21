# 日本語ドキュメント

`docs-jp/` は、人間が各 artifact の目的・背景・設計判断を日本語で確認するための補助ドキュメント領域です。

**現在有効な規範の唯一の正本は `artifacts/` 配下の英語ドキュメントです。** `docs-jp/` は `artifacts/` を上書きしません。内容に差異がある場合は、常に `artifacts/` 側を正とします。

`docs-jp/` には、現在の artifact を説明する補助文書に加えて、設計判断に至った推論・検討・過去の方針を保存する **source log / rationale log（情報源ログ）** を置くことがあります。

情報源ログの扱いは次のとおりです。

- 現在の規範ではなく、設計判断の背景や将来の再検討材料です。
- 作成時点の古い方針・用語・判断を意図的に含むことがあります。
- `artifacts/` と食い違っても、情報源ログ側から `artifacts/` を上書き解釈しません。
- 情報源ログに有用な考えがある場合は、改めて評価したうえで `artifacts/` を明示的に更新します。
- 履歴・差分・過去版の復元は Git に任せ、独自の版管理機構は持ちません。

```text
docs-jp/
├─ design-principles/
├─ documentation-strategy/          # INDEX_JP.md is current routing; detailed 2.1-era files are source logs
└─ development-environment-strategy/
```

日本語ドキュメントは `artifacts.sh` の配布対象ではありません。対象プロジェクトへ配布するのは、選択された `artifacts/<module>/` のみです。
