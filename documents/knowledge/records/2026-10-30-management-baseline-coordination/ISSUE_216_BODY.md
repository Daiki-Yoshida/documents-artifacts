## Issueの目的

複数RepositoryのAI開発において、**Work DocumentsのGit所有、Project baselineでの可視化、変更を加えるGit ref、Primary Checkoutの作業ツリー状態、commit/push/mergeの権限**をエージェントが混同し、不必要な手順・説明の錯綜・統合判断の遅延を生じさせたインシデントを記録する。

個別プロジェクトの経緯を証拠として保全しつつ、他プロジェクトにも転用可能な**誤認の構造、判断時に保持すべき区別、検証シナリオ**を提案する。**このIssueは原因分析・再発防止設計の検討依頼であり、Artifact改変・ルール改定・実装・新Work Identity作成を直ちに承認するものではない。**

## 1. 起きたこと — 具体事例（事実と未確認を分離）

対象：Kotoba Rogue（Management Root Repository: `Daiki-Yoshida/kotoba-rogue`、独立Component Repository: `Daiki-Yoshida/kotoba-rogue-game`、Work Identity: `feat/actor-neutral-combat`、管理Issue #16）。両Repositoryはprivate。以下のリンクには別途アクセス権が必要。

- Project規則 `AGENTS.md` は `.worktrees/<type>/<name>/documents/**` を**Management Root RepositoryがGitで追跡**し、Management `main` をcoordination baselineとして扱う。Componentの実装は独立Git履歴で所有する。
- Supervisorは、Component実装のmain変更禁止をManagementのWork Documents/調整文書へ過度に一般化し、**Managementにも同名Workブランチを設け、そのWork branchに正本文書更新とWork Documentsを保全する方針**をR0032で指示した。Management側のWork branchやPRが常に不正という意味ではない。今回、Project-localの公開経路・対象/権限を先に分解せず、必要性を十分説明せず増やした判断が問題。
- R0032の結果、ManagementのWork branchへ **Work Documents 32件（`INDEX.md` 1、`PLAN.md` 1、records 30）がcommit/push済み**となった。追加でProject Documentation 2件の変更。**32件はGitに未保存だったわけではない**。
- 一方、Management Primary Checkoutは `main` を指し、同じ物理パスのファイルがローカルでは `untracked` と報告された。Supervisorはこれを「Work Documents自体が未追跡・統合の特別な障害」かのように繰り返し説明し、退避や独立の修正ゲートを強調した。**Git trackingはrepositoryの全branchに共通の二値ではなく、commit/tree/refに対して判定される。** Work branchでtracked/mainでは未登録という状態と、primary checkoutでuntrackedという状態は両立する。
- Ownerはまず「Work DocumentsはGit管理されるはず」と指摘し、その後「baselineってmain？普通にfeat/actor-neutral-combatの変更に32件を入れろ」と是正を要求。Supervisorは「baseline公開の不足」→「branchに入っているから追加不要」と説明を変え、理解しにくい訂正コメントと不要な往復を増やした。**問題の多くはコード欠陥ではなく、Gitの状態座標と運用権限の誤解、説明の不一致による意思決定上のインシデント**。
- 最終的にOwnerは**Management PR #17のみ即時マージ、Component PR #20は未マージ**を明示指示。Management PR #17をmerge commit方式でマージし、GitHub上で **merge SHA `b82ffcb70a284b71ff5689b6f44a7cbc0ea075a1`、Management mainの同SHA、Work Documents 32件（records 30）全てがmainでtracked**であることを独立確認。Component PR #20はその直後もOPEN/DRAFT/未マージであり、Component main `da383dc3dc8868746f7eabd90ab152f966589a6c` は不変。
- 今回の操作はGitHub remoteのPR mergeである。**OwnerのWSL Management Primary Checkoutを同期・変更したとは主張しない**。merge後のローカルworktree/index/untracked状態は未測定。データ消失・Git履歴破損は観測されていない。

### 追跡可能な一次資料

- [Kotoba Rogue Work Issue #16（private）](https://github.com/Daiki-Yoshida/kotoba-rogue/issues/16)、[Management PR #17（MERGED / private）](https://github.com/Daiki-Yoshida/kotoba-rogue/pull/17)、[Component PR #20（DRAFT / private）](https://github.com/Daiki-Yoshida/kotoba-rogue-game/pull/20)
- [R0032 指示：Management Work branchに保全](https://github.com/Daiki-Yoshida/kotoba-rogue/issues/16#issuecomment-6499002158) → [R0032完了](https://github.com/Daiki-Yoshida/kotoba-rogue/issues/16#issuecomment-6499092838) → [R0033 原本32/32 SHA一致というExecutor報告](https://github.com/Daiki-Yoshida/kotoba-rogue/issues/16#issuecomment-6499283778)
- [Supervisorのbaseline公開に関する第1訂正](https://github.com/Daiki-Yoshida/kotoba-rogue/issues/16#issuecomment-6500779249) → [その後の再訂正](https://github.com/Daiki-Yoshida/kotoba-rogue/issues/16#issuecomment-6500898325)（混乱自体の経緯）
- [Artifact v2 canonical Work Documents](https://github.com/Daiki-Yoshida/documents-artifacts/blob/6d099edd4574e72fa179127de56145a0ccffe1f7/documents/knowledge/subjects/work-identity/S003_WORK_DOCUMENTS.md)、[Git所有境界](https://github.com/Daiki-Yoshida/documents-artifacts/blob/6d099edd4574e72fa179127de56145a0ccffe1f7/documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md)、[Work lifecycle](https://github.com/Daiki-Yoshida/documents-artifacts/blob/6d099edd4574e72fa179127de56145a0ccffe1f7/documents/knowledge/subjects/work-identity/S004_LIFECYCLE_AND_RESOURCES.md)、[Artifact VCS authority](https://github.com/Daiki-Yoshida/documents-artifacts/blob/6d099edd4574e72fa179127de56145a0ccffe1f7/artifacts/operation/VERSION_CONTROL_AND_REPORTING.md)

## 2. 設計原則として元々存在していたこと

現在のcanonical/Artifactから直接確認できる範囲：

1. **Ownership**: Work DocumentsはManagement Root Repository所有のtracked file。Work Root下のrepository-specific Git worktreeとは別種のリソース。Componentの実装ソースはComponent側の独立Git履歴が所有。
2. **Visibility**: Work Documentsはactive WorkとしてProject baselineから参照できることを目標とする。baselineはProject-localのstable coordination branchで、常にliteral `main`とは限らない。
3. **Authorization**: 上記visibilityの目標は、default branchのcommit/push/merge権限を自動発生させない。Project-local VCS規則とOwnerの承認が先行する。未公開時には公開pendingと保全場所を区別して報告する。
4. **Lifecycle**: Active Work Documents → durableなProject Documentationへreconcile／Work Recordsのみ所定のArchiveへ移管。Workの一部RepositoryのmergeだけでWork全体を完了扱いしない。

**評価仮説:** 原則そのものが無かったわけではない。実行時に原則を組み合わせ、具体的な`repository + ref + checkout + operation + authority`へ解決する段階の失敗が主因。既存規範が十分か、新たなrouting/testが必要かは**結論を先取りせず**検証する。

## 3. 他Projectへ一般化できるインシデント構造

### A. 独立した座標の混線（state-coordinate conflation）

同じパス・同じWork Identityでも、以下は別々の問い：

| 問い | 判定対象 | 今回事例の具体的混同 |
|---|---|---|
| 誰が所有するか | Project内Repository role / path ownership | Work DocumentsをComponentのGit worktreeと同列に扱いがち |
| どこに記録済みか | Git repository + **commit/refのtree** | Work branchでtrackedなのにmainで未登録＝Git管理されていない、と混同 |
| ローカルで何と見えるか | Primary/linked checkoutのHEAD・index・working tree | `git status`のuntrackedを全branchの追跡状態と同一視 |
| どこから見えるべきか | Project baseline/coordination visibility | baseline公開のlifecycle目標と今回の即時operation scopeを混同 |
| 何を変更できるか | operation別のVCS authority / Owner/Project規則 | Component mainへの保護をManagement文書への一律禁止として適用 |
| 統合後に何が変わるか | GitHub remote refs vs 各ローカルcheckout | remote PR mergeとWSL Primary Checkout同期を同一視する危険 |

ここでの事故は、個々の検査が完全に誤りというより、**異なる座標上では同時に真である事実を矛盾扱いし、不要な対処を提案したこと**。

### B. 安全制約の過剰一般化（authority/routing misapplication）

「mainの無許可writeを避ける」という一般安全規則は必要。しかし、実行前に**対象Repository、ファイル所有者、Project固有のcoordination VCS workflow、操作（commit/push/merge）の個別権限**を解決しないと、正当な文書保存・参照性が阻害される。保護のためにWork branchを増やすこと自体が新たな調整面/PR/説明コストを生む。

逆に、Work Documentsをbaselineで可視化したいからといって、**無承認のmain直接pushを一般許可するのも誤り**。修正すべきは一律のYes/Noではなく、特定操作への正しい権限ルーティング。

### C. 状態報告の非自己整合（evidence/provenance drift）

「未追跡」「未公開」「未統合」「未検証」「危険」は異なる状態なのに、同じ言葉や一般的な『STOP』で一括説明すると、Ownerは進行度を判断できない。新しい証拠・Owner訂正が入った時は、以前の判定のどの前提が変わったかを**単一の現状スナップショットと明確な撤回範囲**で示す。訂正を重ねて矛盾した事実関係を増殖させない。

## 4. 提案する再発防止の判断モデル（具象実装・規範改定は未確定）

各Workで操作前に、少なくとも次を**概念的に**解決する。新しいmanifest/schema/DSLを強制する意図はない。

- `Work Identity` と、そのWorkに参加する独立Repository一覧
- Work Documentsの**静的Git所有者**とComponentのソース所有者
- 目的の **target ref / baseline ref / local checkout HEAD** を区別した現在位置
- 対象ファイルの **tracked-on-which-ref / local untracked / remote published** の別々の状態
- **operation別**の委譲・Owner承認（編集、commit、push、PR作成、Ready、merge、ローカルcheckout更新、削除）
- 必要な最小変更・想定副作用・事後検証（remote tree、PR、local statusは別の証拠）

推奨する判断順序の一例：

1. Project-localのRepository ownership/AGENTS規則を調べ、Work DocumentsとComponentソースの対象repoを決める。
2. Project-localのcoordination branchと操作別権限を調べ、**許可された最小のGit操作**を選ぶ。baselineへの直接publicationが未承認なら、Work branchでGit保全し、baseline visibilityをPENDINGと報告する。どちらか一方を無条件の全Project共通方式にしない。
3. 現状を報告する際は、`repo@ref`のtree、`checkout HEAD/index/status`、remote PR状態を区別する。例えば`local untracked`は`remote Work branchにGit履歴がない`という結論を含まない。
4. 安全操作を実行する直前・直後には**その操作が対象とするrefと所有範囲だけを検証**。remote merge後にローカルが未更新なら別の未同期状態として扱う。
5. 追加のbranch/Worktree/PR/HOLDを提案する場合、Projectの既定workflowでは不足する**具体的理由**を説明できること。説明できなければ新たな運用面を増やさない。

## 5. 検証してほしい代表シナリオ（他Projectでも実装可能な抽象形）

- **S1. 文書と実装でGit所有が異なる**：ManagementとComponentが別repo。Work DocumentsはManagement管理、実装はComponent Work branch。両者を一つのリポジトリと誤認せず対応できる。
- **S2. Project-localでManagementのcoordination document commitが許可済み**：汎用的な「default branch直接write禁止」を絶対規則として上書きせず、認可済みの最小publication経路を選ぶ。
- **S3. baseline publication権限が未付与**：この場合だけWork branch保全/PENDING等を適切に選び、無権限main変更も「完全未保全」という虚偽報告も避ける。
- **S4. Main checkout上はuntracked、Work branch上はtracked**：両状態を矛盾・消失・違反と断定せず、ref依存と衝突リスクを正確に説明する。
- **S5. GitHub PR merge済み、ローカルPrimaryは旧HEAD**：remote integration完了とlocal materialization/sync pendingを区分する。ローカルの未追跡原本があれば安全なpreflightを別に実施する。
- **S6. Ownerが前提誤認を指摘**：最新の実状態を1回再測定し、誤った説明だけを明示的に撤回する。追加Round・不要な逆戻りの運用作業を発生させない。

## 6. 受入条件・非目標

**本Issueの設計成果として期待すること**：①事実/推論/未確認を分離したインシデント解析、②上記モデルで問題を再現できるか、③既存canonical/Artifact/test routingで足りるかの検証、④不足が実証された場合に限る最小の補強案とテスト、⑤Project固有規則・VCS authorityを損なわないこと。

**非目標**：Work Documentsを常にmainへ無権限で直接pushする共通規則の追加／ManagementでWork branchを一律禁止すること／全Workのbranch統一命名を強制／個別のKotoba Rogue残WorkやComponent PR #20の勝手なmerge／巨大な新しい状態DBや必須manifestの導入／本件を根拠とする無関係なArtifact全面改稿。

GitHub上のManagement PR #17のマージは完了したが、**本Issue自体の分析・規範改善・テストは未着手**。既存の[Work Records設計Issue #204](https://github.com/Daiki-Yoshida/documents-artifacts/issues/204)、[multi-repo配置事例Issue #191](https://github.com/Daiki-Yoshida/documents-artifacts/issues/191)の既存契約や履歴も参照し、重複したモデルを導入しない。