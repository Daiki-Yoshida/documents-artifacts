# Development Safety

このsubjectは、**開発操作をどう安全に行い、失敗をどう診断・復旧するか**を扱う。

Work固有resourceのownership/lifecycleは `../work-identity/`、実行環境の具体的materializationは `../development-execution/` が主所有する。

## 構成

```text
development-safety/
├─ INDEX.md
├─ S001_SAFETY_PRINCIPLES.md
├─ S002_DESTRUCTIVE_OPERATIONS.md
├─ S003_DIAGNOSTICS_AND_RECOVERY.md
├─ S004_INTEGRATION.md
└─ S005_CONFIRMATION_AND_REREAD.md
```

### S001_SAFETY_PRINCIPLES.md

安全性の優先順位、安全で使いやすい日常経路を扱う。

### S002_DESTRUCTIVE_OPERATIONS.md

通常操作と破壊的操作の境界、scope、明示性を扱う。

### S003_DIAGNOSTICS_AND_RECOVERY.md

状態診断、検証、失敗時の確認順序と復旧を扱う。

### S004_INTEGRATION.md

repository境界を守った統合と、統合後の再検証を扱う。

### S005_CONFIRMATION_AND_REREAD.md

変更riskに応じた確認境界と、環境・構造文書の再読条件を扱う。

## 再編元

旧 `development-environment` のうち、安全性・破壊操作・診断・復旧・確認境界をこのsubjectへ移管した。
