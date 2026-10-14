## Phase A — 独立設計レビュー：`DIR` の公開入力と内部Identity解決（2026-10-14）

**レビュー対象:** `main` `f4cbdd877a3bbb6eb327888c407eed9cfbe462cb`、Issue #209、Issue #148の原文記録、および未統合のsource-preservation Draft PR #210。今回のコメントは**設計レビュー**であり、canonical/Artifact/テスト改定の実施・merge完了を意味しない。

### 判定：現行の「既存ディレクトリ限定」と「WORK+REPO必須」に、ユーザー意図との具体的な不整合がある

現行 `documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md` と `artifacts/execution/COMMANDS_AND_CI.md` は、`DIR` がパスでありWork Identity等ではないという核心は保っている。しかし例示と導線が**既存checkoutへのbuild/test/install/runのexecution target**に偏っている。

さらに `documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md` は、worktree create/status/removeの公開入力を `WORK + REPO (+ BASE)` に限定し、callerによるpath入力を明示的に禁止している。この制約は `artifacts/project/WORKTREES.md` にも投影されている。これは「公開コマンドでは汎用的なディレクトリパスを指定し、用途・意味解決は**そのコマンド自身**が引き受ける」という今回明示された設計意図と、少なくともpublic input surfaceの範囲で衝突する。

`tests/repositories/work-runtime-lifecycle/Makefile` には実際に `make work-up WORK=feat/schema-preview` の実装がある。ただし2026-09-27のDocker scope/lifecycle検証用fixtureであり、2026-10-03のgeneric `DIR`契約より前の構造で、**全ProjectへのWORK入力強制というnormative根拠ではない**。Issue #209で報告された外部ProjectがこのfixtureのためにそのUIを実装したとまでは立証されていない。

### 収束候補：公開パス指定と内部のsemantic identityを明確に二層化する

```text
Project Rootからのpublic command
  make DIR=<directory-path> <operation>
       │
       ├─ DIR自体はディレクトリパスのみ
       │  （Work/Repository/Runtime Identityや権限を意味しない）
       ↓
operation-owned target interpretation
  ├─ 期待するtarget種別・必要な存在条件・範囲を検証
  ├─ Projectの既存構造・stable repository mapping・Git実状態と照合
  ├─ 必要ならWork Identity + repository selector等を内部解決
  └─ 当該operationの効果とscope/安全条件を適用
       ↓
実際の変更・検証・Resource Identity
```

`DIR` の意味は全commandで「指定対象のディレクトリパス」。`DIR` が表すディレクトリを**そのままprocess CWDにする義務はない**。`docker-up` はWork Rootを受けてProject-owned Compose設定・Work-scoped runtimeを解決できるし、`test` はそのrepository checkoutで検証できる。生成操作なら作成先・基準点として解釈してよい。

```bash
make DIR=.worktrees/feat/hogehoge/ docker-up
make DIR=.worktrees/feat/hogehoge/ docker-status
make DIR=.worktrees/feat/hogehoge/ docker-down
make DIR=.worktrees/feat/hogehoge/game/ test
make DIR=components/api/ generate
```

**Worktree lifecycleについての推奨:** generic public interfaceとして `DIR` を認めることと、内部identity解決をdeterministicに行うことは両立する。例えば `make DIR=.worktrees/feat/hogehoge/game worktree-create` を採用する場合、与えたパスを自由配置先として許可するのではなく、**Project Rootの正規Worktree構造に完全一致する候補locator**として検証し、`WORK=feat/hogehoge` と `REPO=game` 相当の意味を内部で解決する。Git worktreeの登録・branch・repo所有権・Work Identity確認・sparse条件などは既存contractのまま厳密にpreflightする。対象path未作成の場合は、存在する祖先の実体境界と正規配置を検証し、予期しないsymlink/既存内容を拒否する。具体的にどのpath shapeを各lifecycle operationが受けるかはcommandのpublic contractで宣言する。

`DIR=.worktrees/feat/hogehoge/` はWork Rootを指す。複数参加repositoryが存在する中で、**単一repositoryのworktreeをcreate/removeする操作**にこれだけを渡しても選択が曖昧である。Projectが全参加repositoryを対象にする別operationを明示的に定義するのでなければ、そのケースは勝手に一つを選ばず拒否すべき。repo-specific pathの入力はこの曖昧さを避けられる。

`BASE` のような**指定対象とは別の操作設定**が本当に必要な場合は許容するが、Work/Repoのlocatorを毎回別引数へ転記させることをdefaultにしない。既存 `WORK + REPO` syntaxは互換性が必要なProjectで残してよいが、共通の公開DIR方針を否定する規範として要求しない。

### 安全性と運用境界（維持する保証）

- Relative `DIR` はProject Root基準。shell fragmentでなく1つのpath valueとしてquote、trailing slash等は安全に正規化。absolute/out-of-rootの許容はProject-local authorityに従う。
- **既存対象を扱うcommandと新規作成commandでは、対象pathの存在要件が異なる。** createで最終pathを必ず既存とする規則にはしない。存在する親directory、Git所有権、symlink/realpath、予想外のfilesystem内容、canonical shapeは検証する。
- `DIR` は権限やWork Identity確定の証明ではない。Worktree新設/branch開始/破壊操作には従来のconfirmation/safety gateを適用する。
- `docker-up/status/config/verify/down/cleanup` は、同じ指定を同じWork/Resource Identityに解決する単一のproject-owned resolver/config sourceを共有する。指定pathの綴り違い（末尾slash等）でResource Identityを変えず、down/cleanupがdefault scopeへfallbackしない。
- Work-scopedの可変データ・volume等を隔離し、共有可能なimage/cacheは必要以上に複製しない。破壊的cleanupでshared cacheを消さない。
- AI development sessionはProject Rootから開始。公開commandはProject Root側の正規入口。Component Repositoryの独立Git ownershipを保持する。

### 変更対象の優先順位（設計レビュー時点の提案）

1. **主owner:** `documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md` に「generic directory locator + operation-owned interpretation + completion/usability」のcurrent modelを記述。`DIR` をexisting checkout専用と読む制約を解除。
2. **Worktree semantic owner:** `documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md` のpublic `WORK + REPO` 必須／caller path禁止を再設計。**安全なdeterministic identity・Git registration・materialization contractは維持**し、ユーザー側の入力方式と内部識別を分ける。
3. **Projection:** `artifacts/execution/COMMANDS_AND_CI.md` と `artifacts/project/WORKTREES.md` へtask-relevantに反映。`artifacts/INDEX.md` の現行routeを活用し、無関係なleafを広範に増やさない。
4. **周辺照合:** `work-identity/S004_LIFECYCLE_AND_RESOURCES.md`、`development-execution/S002_HOST_AND_CONTAINER.md`、development-safetyの既存guardを維持。必要なcross-referenceだけ追加。
5. **テスト:** 既存のproject-root-execution-routing / work-runtime-lifecycle fixtureは履歴・既存の検証対象として保持し、新しい代表的なpositive/negative controlを最小限追加。Work Root `DIR` →同じRuntime identityのup/status/down、Component path→test、正規Repo Worktree path→create/status/remove、unknown repo/不正階層/symlink越境/曖昧なWork Root/未承認Work/dirty removeを評価。まずDocker実起動を伴わないrendered config/dry-runでscope一致を確認し、追加のdaemon依存試験は別途環境・権限を確認する。

### 証拠とステータス

- 元の設計意図: `documents/knowledge/records/2026-10-03-project-root-execution-routing/USER_MESSAGES.md`、Issue #148。
- 今回の訂正意図: source BundleのDraft PR #210（`documents/knowledge/records/2026-10-14-generic-dir-command-target/`）。**PR #210はまだmain未統合**。
- 今回はGitHub上の現行文書・fixtureを比較するread-only設計監査。上記は収束**提案**であり、canonical/Artifactの改定・各Projectへのsync・実行試験・PR mergeを済ませた主張ではない。
- GitHub Actions、外部CI、課金runner等は使わない。

**レビュー結論:** ユーザーの要求する公開UIは、既存のinternal Work Identity/安全境界を壊さず実現可能。変更の主要点は「`DIR` に意味を背負わせず、public operationが指定pathから必要なsemantic targetを解決する」責務の明確化、およびS006のcaller input制約の見直しにある。