# 日本語ドキュメント

`docs-jp/` は、人間が各 artifact の目的や内容を日本語で確認するためのドキュメント領域です。

AI / CLI エージェント向けの正本は `artifacts/` 配下の英語ドキュメントです。英語版と日本語版の内容に差異がある場合は、`artifacts/` 側を正とします。

```text
docs-jp/
├─ design-principles/
├─ documentation-strategy/
└─ development-environment-strategy/
```

日本語ドキュメントは `artifacts.sh` の配布対象ではありません。対象プロジェクトへ配布するのは、選択された `artifacts/<module>/` のみです。
