# Work Identity — Identity Model

Work Identityそのものの意味、確定タイミング、命名、Gitとの依存関係を扱う。以下はsource recordの該当sectionを、責務単位へ再配置したもの。本文の意味内容は変更していない。

## 目的

開発作業の管理単位を、ツール固有の識別子や個々の実行回数ではなく、**「何を実現するための開発作業なのか」**という意味のある単位へ統一する。

その単位を **Work Identity** と呼ぶ。

Work Identity は単なる命名規則ではなく、次の三つをまとめる境界である。

```yaml
work_identity:
  meaning: "何を実現するための開発作業か"
  owns:
    - "ownership"
    - "resource identity"
    - "lifecycle"
```

目標は、Git、worktree、Docker、テスト状態、ログ、生成物、作業ドキュメントなどを、同じ開発目的から追跡できる状態にすることである。

---

---

## なぜ Work Identity が必要か

開発中には複数の識別子が自然に発生する。

- Git branch
- Git worktree
- Docker Compose project
- container / network / volume
- test database / fixture
- logs
- temporary output
- working documents
- individual test or command executions

これらが独立した命名・ライフサイクルを持つと、同じ開発目的に属する状態であっても関連性が失われる。

望ましい関係は次である。

```text
User Goal
   ↓
Work Identity
   ├─ Git branch / worktree
   ├─ runtime state
   ├─ test state
   ├─ logs / outputs
   └─ Work Documents
```

Work Identity は、これらを意味的に束ねる上位概念である。

---

---

## Work Identity を確定するタイミング

Work Identity は、アイデア相談や設計議論を始めた瞬間には作らない。

次の順序を基本とする。

```text
ユーザーが目標を提示
        ↓
人間 / AI で調査・設計・協議
        ↓
実装する内容が具体化
        ↓
Work Identity を明示的に確定
        ↓
実装開始
```

### 確定ルール

- Work Identity は **実装作業へ移る直前**に確定する。
- AI は Work Identity の候補を提案してよい。
- 実装開始前に、ユーザーがその Work Identity を明示的に確認する。
- まだ目的が曖昧な調査・相談段階では、Work Identity の生成を急がない。

これにより、Work Identity は会話や実行の都合ではなく、実際の開発目標から導出される。

---

---

## 命名モデル

基本的な意味表現は次とする。

```text
<work-type>/<work-name>
```

例:

```text
feat/pathfinding
fix/login-timeout
refactor/payment-boundary
```

### work-type

`feat`、`fix`、`refactor` など、作業の種類を表す。

Git を利用する場合、この種別は branch prefix と意味的に一致させることを基本とする。

ただし、具体的な branch naming convention は各プロジェクトが所有する。

### work-name

作業の対象・責務・目標が人間に理解できる固有名を使用する。

ランダム値や単なる実行回数ではなく、**何を変更しているかが分かる名前**を優先する。

---

---

## Git との関係

Work Identity は Git に依存しない。

```text
Work Identity
    │
    ├─ Git available
    │    └─ branch / worktree で表現・追跡
    │
    └─ Git unavailable / not applicable
         └─ Work Identity 自体で lifecycle を管理
```

Git は推奨される主要な追跡手段であり、通常のソフトウェア開発では branch を利用することが望ましい。

ただし概念の依存方向は次である。

```text
Work Identity
    ↓
Git representation
```

Git branch が Work Identity を定義するのではない。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
