# Stage 2-A-2：records全105ディレクトリの意味・採否追跡台帳

**状態：全105ディレクトリ／206ファイルを全文取得・一次点検済み。**

## この台帳で区別すること

- 原本・snapshot：**その時点の記述内容**であり、現在の哲学の自動承認ではない。
- Git commit/PR/Issue：**実装状態や提案・検証の証拠**であり、それだけでOwner自身の思想の制定を意味しない。
- Ownerの採用・訂正・却下：対象の提案、意味上の適用範囲、後続の判断を照合して有効状態を判断する。
- 同じディレクトリに複数種別のeventが存在し得る。下表の「一次的な役割」は**監査で注目した入口の意味**であって、内部の全主張を一つのstatusに還元した分類ではない。
- 原文が英語の資料は英語で保存する。その内容を日本語の哲学候補へ転記する際、翻訳による規範強度や条件の変化を認めず、原文参照を維持する。
- 収録対象：`documents/knowledge/records/` tree `2e632c2c545402766404b8223847022fb6975233`（Stage 2-A-1/A-2開始時の固定点）。
- **recordsに保存された全命題が正しい・現行であるという意味ではない。** 現行判断は後続採用・関係とOwnerの確認に基づく。

## 全105ディレクトリ

| recordディレクトリ（`records/`配下） | ファイル数 | 一次的な役割 | 哲学抽出・Decision Lineageでの留意点 |
| --- | ---: | --- | --- |
| `2026-01-31-bounded-contracts-refinement-source` | 4 | 旧設計原本 | interfaceを手段とするBounded Contract思想の変遷 |
| `2026-01-31-bounded-contracts-standardization-commit` | 1 | 実装差分 | 境界・契約の表現改定。Ownerの独立承認とは限らない |
| `2026-01-31-code-standards-refinement-commit` | 1 | 実装差分 | failure/interface設計など初期仕様の修正 |
| `2026-01-31-dependency-boundary-refinement-commit` | 1 | 実装差分 | 外部依存を囲う方針の技術的精緻化 |
| `2026-01-31-dependency-boundary-refinement-source` | 4 | 旧設計原本 | dependency／contract／OOの変遷を照合 |
| `2026-01-31-design-principles-foundation-commit` | 1 | 旧設計の差分 | 初期のinterface中心／契約思想。現在の強さは後続訂正で限定 |
| `2026-01-31-domain-model-refinement-source` | 3 | 旧設計原本 | rich/lightweight domain modelの条件化 |
| `2026-01-31-domain-modeling-refinement-commit` | 1 | 実装差分 | 単純domainにもRich Modelを強制しない方向の改定 |
| `2026-01-31-entity-mutability-refinement-commit` | 1 | 実装差分 | 状態遷移・rich mutable modelの選択規則 |
| `2026-01-31-initial-code-design-source` | 4 | 旧設計原本 | 初期の契約・継承・状態の考え。現行基準として自動採用しない |
| `2026-06-13-design-principles-reference-snapshot` | 3 | 旧参照原本 | bounded unit／contract／内部自由の基礎と旧AI文書方針 |
| `2026-06-13-external-boundary-refinement-commit` | 1 | 実装差分 | interface全件強制から実際の境界要否へ修正 |
| `2026-06-13-module-mapping-testing-refinement-commit` | 1 | 実装差分 | 責務・module・mapping・契約テストの整理 |
| `2026-06-13-operational-discipline-commit` | 1 | 実装差分 | 変更手順と完了検証の旧規則。後続の要求達成区別に注意 |
| `2026-06-21-encapsulation-horizon-artifact-commit` | 1 | 実装差分 | 地平線をAI運用版へ実装した経緯 |
| `2026-06-21-encapsulation-source-alignment-commit` | 1 | 実装差分 | 日本語源流との不足箇所の同期・昇格負債 |
| `2026-06-21-project-structure-origin-commit` | 1 | 実装差分 | 境界原理の物理配置への実現 |
| `2026-06-22-design-review-guard-commit` | 1 | 実装差分 | 公開面・責務分割の誤読防止 |
| `2026-06-22-horizon-search-direction-commit` | 1 | 実装差分 | マクロ→ミクロへの地平線の選定方針 |
| `2026-07-01-brownfield-policy-commit` | 1 | 実装差分 | 小変更の比例性、既存範囲と逸脱防止 |
| `2026-07-02-design-doc-update-commit` | 1 | 実装差分 | 旧文書の更新履歴。個別規範の承認を推定しない |
| `2026-07-02-design-principles-final-source-snapshot` | 6 | 旧原本／snapshot | 旧Design Philosophy・Coding Standardsのまとまった版。後続決定と照合 |
| `2026-07-09-documentation-atomicity-commit` | 1 | 実装差分 | 旧ドキュメントだけのブランチ運用。現在の無条件規則としない |
| `2026-07-09-documentation-consistency-fixes-commit` | 1 | 実装差分 | 文書authority・情報の重複・routing表現の修正履歴 |
| `2026-07-09-documentation-split-commit` | 1 | 旧実装差分 | 旧『AI効率優先』段階。後続『正確性優先』へ置換 |
| `2026-07-09-documentation-strategy-final-source-snapshot` | 5 | 旧原本／snapshot | 情報正確性・Routing・Git等の歴史的な英文原本 |
| `2026-07-09-documentation-v2-2-review-fixes-commit` | 1 | 実装差分 | 旧文書の役割矛盾・版情報等の是正 |
| `2026-07-09-documentation-v2-restructure-commit` | 1 | 修正差分 | トークン効率優先から情報正確性優先への変更 |
| `2026-07-18-development-environment-initial-pr` | 1 | 実装提案／PR | 開発環境契約の初期導入。PR単独で哲学制定しない |
| `2026-07-18-environment-standards-origin-commit` | 1 | 実装差分 | host/container境界、公開コマンド等の具体化 |
| `2026-07-18-environment-workflow-origin-commit` | 1 | 実装差分 | 実行の再現性・変更手順・検証を具体化 |
| `2026-07-18-workspace-structure-origin-commit` | 1 | 実装差分 | 初期workspace構成。repository役割は後続改定 |
| `2026-07-19-optional-worktree-policy-commit` | 1 | 修正差分 | worktree全件必須ではなく必要時の分離 |
| `2026-08-02-task-resource-ownership-pr` | 1 | PR／提案 | 資源の責務とlifecycle統一の改定 |
| `2026-08-02-task-resource-reconciliation-commit` | 1 | 実装差分 | 作業資源の残存と完了評価 |
| `2026-08-03-development-environment-final-source-snapshot` | 6 | 旧原本／snapshot | 開発環境を契約として捉える思想と当時の具体的規則 |
| `2026-08-03-docker-resource-reuse-pr` | 1 | PR／提案 | 資源を無条件に重複生成せず安全に再利用 |
| `2026-09-06-design-principles-proposals` | 1 | 提案（未採用部分あり） | #1の提案1〜5。保留4・修正採用1/2/3/5と区別 |
| `2026-09-15-cross-artifact-consistency-issue` | 1 | 監査・修正提案 | 契約への適合≠成果全体の正しさ等の不整合 |
| `2026-09-15-cross-artifact-consistency-pr` | 1 | PR／実装経緯 | contract conformanceと要求達成の誤同一視を修正 |
| `2026-09-15-design-principles-contract-decision` | 1 | 修正採用と保留 | 1/2/3/5は修正採用、性能提案4は保留 |
| `2026-09-15-design-principles-proposal-status` | 1 | 完了・採否整理 | 修正採用の実装結果。保留項目の別管理を確認 |
| `2026-09-15-performance-redesign-hold` | 1 | 保留判断 | 性能による契約再設計はこの時点では未制定 |
| `2026-09-20-performance-contract-evolution` | 1 | 後続採用 | 性能が実際の制約である場合に限り契約形状変更を検討 |
| `2026-09-20-work-identity-artifactization-pr` | 1 | PR／実装経緯 | Workの目標意味を資源・作業文書の共通軸へ |
| `2026-09-20-worktree-command-contract-pr` | 1 | PR／実装経緯 | worktree作成操作の契約（後続DIR再検討あり） |
| `2026-09-20-worktree-materialization-pr` | 1 | PR／実証 | Git / WSL実測境界つきの実装手段。哲学普遍化禁止 |
| `2026-09-21-artifact-source-redesign` | 1 | Owner方向提示 | 知識正本とAI配布物の責務分離に関する相談 |
| `2026-09-21-development-documentation-subjects-implementation` | 1 | 実装経緯 | 旧資料の責務別subject分解。日本語原則の既定化 |
| `2026-09-21-development-subject-split-implementation` | 1 | 実装・是正 | 開発環境umbrellaから4責務を分離 |
| `2026-09-21-docs-jp-snapshot` | 17 | 旧日本語源流／snapshot | Encapsulation Horizon/文書哲学/環境思想の日本語原本を保存 |
| `2026-09-21-encapsulation-horizon-subject-rebuild` | 1 | Owner実装指示 | 元原理を責務別subjectsへ分解する許可。意味の一括承認ではない |
| `2026-09-21-knowledge-only-phase` | 1 | Owner指示 | 正本整備までArtifactsを先行実装しない |
| `2026-09-21-knowledge-record-accuracy` | 1 | Owner採用判断 | recordsの正確性＝採否を含む原文保存。全命題の肯定ではない |
| `2026-09-21-knowledge-scaling-requirements` | 1 | Owner問題提起 | 記録増加に耐える保守構造の必要性 |
| `2026-09-21-knowledge-source-model` | 1 | Owner源流判断 | 記録／正本／派生の異なる情報責務 |
| `2026-09-21-knowledge-source-model-implementation` | 1 | 実装・保存報告 | 記録の完全性と意味正本の段階分離 |
| `2026-09-21-knowledge-structure-implementation` | 1 | Owner指示 | 知識管理構造の実装許可 |
| `2026-09-21-knowledge-system-subjects-implementation` | 1 | 実装経緯 | subjects保全・旧文書分解の実績 |
| `2026-09-21-records-subjects-model` | 1 | Ownerの明示判断 | 肥大化を許容し意味劣化を避け**日本語で**整理 |
| `2026-09-21-subject-prefix-implementation` | 1 | 実装指示 | 文書の番号付与という旧物理方式。A-4で再判断 |
| `2026-09-21-subject-section-prefix` | 1 | Owner指示 | 旧leaf命名の実施。哲学の分割単位は別 |
| `2026-09-21-work-identity-subject-rebuild` | 1 | Owner実装指示 | Work Identityの責務ごとに再配置 |
| `2026-09-21-worktree-reference-validation-pr` | 1 | PR／実証 | worktree参照実装の検証範囲と未検証を区別 |
| `2026-09-22-add-more-subjects` | 1 | Owner評価 | 初期日本語subjectsに対する評価、継続指示 |
| `2026-09-22-development-environment-subject-split` | 1 | Owner問題提起 | work-identityとの責務重複の是正要求 |
| `2026-09-22-six-subject-cross-audit-fixes` | 1 | Owner修正指示 | 複数subjectのauthority衝突を是正 |
| `2026-09-22-six-subject-cross-audit-implementation` | 1 | 監査・修正証拠 | 歴史を失わず責務再編、原文の保存を重視 |
| `2026-09-22-workspace-work-identity-alignment` | 1 | Owner修正承認 | 静的workspaceとWorkの動的境界を合わせる |
| `2026-09-22-workspace-work-identity-transition-context` | 1 | 歴史資料 | 当時の知識・設計状態。現行規則として復活しない |
| `2026-09-23-knowledge-integrity-implementation` | 1 | 実装／修正 | 原文言語と対象範囲の取り扱いの是正 |
| `2026-09-24-artifact-delivery-routing-redesign` | 1 | Owner方向採用 | 旧配布方式からの設計変更。現行Stage 3を先取りしない |
| `2026-09-24-code-design-recovery-continuation` | 1 | Owner継続指示 | source-backed復元継続。個別規範の直接制定ではない |
| `2026-09-24-knowledge-integrity-repair` | 1 | Owner修正指示 | 短文指示のみで新哲学の中身を創作しない |
| `2026-09-24-strong-contract-explicit-not-maximal` | 1 | 後続是正判断 | 必要な保証を明示し偶然の実装性質を過剰な公開保証にしない |
| `2026-09-24-yagni-encapsulation-horizon-decision` | 1 | Ownerの原文 | コスト回避YAGNIを拒み契約面を強固にする意図。精緻化の妥当性に留保 |
| `2026-09-27-integration-root-routing-gap` | 1 | 実装/テスト証拠 | 規範の欠落ではなく入口配送の欠落。哲学ではなくStage 3留保 |
| `2026-09-27-work-runtime-lifecycle-propagation` | 1 | 実装/テスト証拠 | Work資源のidentityを全操作に伝播する必要 |
| `2026-10-03-historical-branch-cleanup-conversation` | 1 | 履歴会話 | ブランチ削除とGit履歴保存の区別 |
| `2026-10-03-knowledge-effective-status-lineage` | 4 | 採用済み管理契約 | source/semantic/current評価を区別しHISTORY・unresolvedを保存 |
| `2026-10-03-project-component-chat-transcript` | 2 | Owner会話・採用経緯 | 親子階層の旧解釈を責務roleへ変更 |
| `2026-10-03-project-component-documentation-boundary` | 3 | 設計判断 | Project Repository/Componentの責務別モデル（後続名称修正） |
| `2026-10-03-project-root-execution-routing` | 5 | 設計判断とOwner指示 | Agent Root・Work Root・実行対象の3役割を分離 |
| `2026-10-03-subject-consistency-convergence` | 3 | 監査・是正 | 正本間のowner・物理位置の一貫性を修正 |
| `2026-10-03-subject-effective-status-lineage-audit` | 5 | 監査と是正 | 旧/現行が混在するleafの採否を明示（current conflictではなくtrace欠落） |
| `2026-10-04-management-root-repository-terminology` | 2 | 後続名称採用 | Project Repository→Management Root Repository。意味の同一性と変更部分を照合 |
| `2026-10-04-negative-alternative-leakage` | 2 | 初期設計 | Artifact投影でのNAL。後続で一般概念へ拡張 |
| `2026-10-04-workspace-physical-topology` | 2 | 監査・是正 | 責務roleと物理配置/Git所有権を別軸として保持 |
| `2026-10-07-generalized-nal-adoption` | 2 | Ownerによる採用 | NAL一般化の短文承認。採用対象の元提案へ参照 |
| `2026-10-07-generalized-nal-issue` | 2 | 実装Issue | 一般化NALの定義と適用範囲の実装計画 |
| `2026-10-07-generalized-nal-proposal` | 2 | AI提案の全文 | Owner採用記録の参照対象。原文だけでの採用扱い禁止 |
| `2026-10-12-project-root-write-boundary` | 2 | Owner意図・設計課題 | Project Rootを通常の書込境界とし、必要な例外は別判断 |
| `2026-10-13-project-root-write-boundary-completion` | 9 | 採用・レビュー証拠 | 実効的書込先と権限・副作用、対象スコープの完了結果 |
| `2026-10-13-record-intake-regulation` | 4 | 採用済み管理契約 | event/bundle/snapshot、原文のfidelityと収録範囲の区別 |
| `2026-10-13-work-records-implementation-adoption` | 4 | 後続Owner承認 | Workの経過記録を簡潔に保全する運用の採用 |
| `2026-10-13-work-records-proposal` | 4 | 提案と文脈 | 作業文書・履歴の扱い。採用は後続recordで確認 |
| `2026-10-14-generic-dir-command-target` | 4 | Owner意図と設計論点 | DIRは汎用パス引数、意味はpublic commandが決める |
| `2026-10-14-generic-dir-implementation-adoption` | 4 | 後続実装承認 | DIRからWork/Repoを安全に解決、path自体は許可ではない |
| `2026-10-30-management-baseline-coordination` | 3 | Owner是正と事故事実 | VCSと基準文書の状態座標・操作権限を区別 |
| `2026-10-31-rule-class-adoption` | 4 | Owner採用・候補混在 | RC1/2/3名称・意味は採用、222候補の個別分類は未承認 |
| `2026-11-10-dev-layers-terminology` | 3 | Owner用語採用 | 哲学・方法論・AI-Orchestrationの三層と制定語彙 |
| `2026-11-11-dev-artifacts-owner-memo` | 2 | Owner源流メモ | 関係語彙・3層目的・哲学最終承認の要望 |
| `2026-11-11-dev-artifacts-stage1-governance` | 3 | Owner承認 | repository/models/operationsの管理構造採用 |
| `2026-11-11-stage2-language-issue` | 2 | Owner是正要求 | 日本語原文から哲学を再抽出、英語化による変質を警戒 |
| `2026-11-11-stage2-philosophy-first` | 2 | Owner工程採用 | A-1/A-2→A-3吟味→A-4分類→A-5仮正本化 |

## 横断的な系譜の照合結果

| 主題 | 先行source／提案 | 後続の判断・解釈 | A-1へ反映する境界 |
| --- | --- | --- | --- |
| interface中心から境界の意味中心へ | 2026-01-31のdesign-principles source／commit、2026-06-13 reference | 選択済みの実際のboundaryに契約を定義する。全classへinterfaceを強制しない | P01/P02/P07。言語機構を思想そのものと取り違えない |
| 契約適合と要求の達成 | 2026-07-02の旧強いContract Test表現、09-06の提案1 | 2026-09-15の修正採用1、提案status。検証は両者を区別 | P12候補。Contract Testが合格しただけで要求達成とはしない |
| Concept Altitudeとsemantic identity | 旧Encapsulation Horizonの一文判定、09-06の提案2 | 2026-09-15修正採用2。一文は中立性の兆候、同一性の証明ではない | P03。複数consumerの共通化の強制へ一般化しない |
| additiveとcompatible | 旧契約進化と09-06提案3 | 2026-09-15修正採用3。consumer/provider双方で有効な次元の互換性を見る | P13候補。新しい形式の追加＝無条件安全ではない |
| 性能と契約の粒度 | 2026-09-06の提案4／09-15の保留 | 2026-09-20にload-bearing requirementと証拠条件つきで進化を認める | P14候補。保留を現行未解決として残さず、変更無制限とも解さない |
| YAGNIと外部契約 | 2026-09-21日本語原本、2026-09-24 OwnerのYAGNI原文 | 選択責務の完全性と内部機構の予測的追加を区別する旧subjects。ただしOwnerの強度との関係に留保 | P04/P05。**A-3で本人と解釈を照合** |
| NALの一般化 | 2026-10-04のArtifact向けNAL、10-07のAI原案 | 2026-10-07 Ownerの明示採用により目的に応じた文脈構成へ一般化 | P08。必要な反例・ガード・未解決事項を削らない |
| 文書の優先価値 | 2026-07-09旧AI効率／routingを重視した段階 | 07-09後続でaccuracy > routing > token、2026-09-21 Ownerが日本語subjectsと意味完全性を明示 | P09/P17。旧選択的読込をStage3の権威としない |
| repository roleと所有 | parent/child旧役割、Project RepositoryとComponent Repo | 10-03に責務へ整理、10-04にManagement Root命名、物理包含はGit権限と別 | P15。物理上下を規範の所有関係へ短絡しない |
| Work Identity / Resource | 旧Task Worktree、09-21 Work Identity設計原本 | 後続worktree契約、10-14 DIR変更、10-31 RC3適用条件を区別 | P11。Workを無条件にbranch/worktree生成義務にしない |
| source/semantic/currentの分離 | 09-21 Ownerのknowledge/records/subjects判断 | 10-03 Decision Lineage、10-13 record intake規則 | P16候補。旧／否定済み意味の保存を承認と混同しない |
| VCS・書込権限 | 10-12 Project Root書込境界、10-30 baseline事例 | 実行対象の物理pathと許可された操作、write/commit/pushを別に評価 | P10/P15。実装手順は方法論側にも多い |
| 記録の日本語 | 09-21 records-subjects-modelのOwner原文 | 11-11 Ownerの英語資料への異議と修正 | A-1候補・中間資料を日本語で作り、原文と解釈を区別 |

## A-3へ引き継ぐ未確定事項

- 哲学としての独立性・規範強度についてOwnerが未承認の候補。
- 2026-09-24のYAGNI原意とその後の「選択された契約／投機的内部機構」分離の相互関係。
- 安全・Work Identity・文書管理・プロジェクト権限など、方法論としての具象が強い知識を哲学の本体にどこまで含めるか。
- 既存の哲学候補を相互に包含・参照・実現関係として整理すること。**分類単位はA-4まで保留**。

**監査上の結論：** 105ディレクトリすべての原文の所在・一次意味点検を実施し、採否が変わる主要なDecision Lineageの系譜を照合した。文書名・ファイル名やAIの言い換えから新規哲学の採用を推定していない。残るOwnerの思想上の判断はA-3で行う。Stage2-Cで層間監査を再実施する。
