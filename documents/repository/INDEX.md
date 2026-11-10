# Repository

この領域は、dev-artifactsリポジトリの知識管理体系と、それを実行するリポジトリ固有の運用を扱う。`knowledge/`の**親権威**ではなく、管理対象と定義権を切り分けた領域である。

## Entry points

| Path | Role |
| --- | --- |
| [models/](models/INDEX.md) | 体系・層・所有権・承認・記録などの**管理契約** |
| [operations/](operations/INDEX.md) | 管理契約の具体的実施手順 |
| [REPOSITORY_STRUCTURE.md](REPOSITORY_STRUCTURE.md) | 全体配置・移行中の境界 |
| [legacy/](legacy/INDEX.md) | 旧管理文書・Artifact v2設計・監査等の非現行参考資料 |

## Authority

- Dev-Philosophyの内容を制定するのはOwner。モデルはその**制定手続き**を定義し、内容を創作しない。
- 原文は[records](../knowledge/records/)で保持し、[subjects](../knowledge/subjects/)は意味上の正本となる。
- Artifactsは正本からの派生物。射影・読み込み方式はStage 3で決定する。
- Issue / PR は進捗の管理場であり、原文記録を代替しない。

## Stage

Stage 1: 管理モデル・外枠の運用を整備。Stage 2: records→subjects。Stage 3: subjects→artifacts。

根拠: [Issue #221](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221) / [Stage 1 adoption record](../knowledge/records/2026-11-11-dev-artifacts-stage1-governance/)
