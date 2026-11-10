# Stage 2-A-1：旧subjects全70ファイルの監査台帳

**状態：A-1の全文確認・一次抽出完了。** 最終的な哲学の意味・採否・独立性の確定はA-2とOwnerによるA-3の対象。

## 固定した情報源と監査範囲

- 旧リポジトリ `Daiki-Yoshida/documents-artifacts` の `main@7ad8bb4f948359633003a47fa6bfcc8d6853ddb6` に固定した `documents/knowledge/subjects/`。
- **全70ファイル（INDEX 10、その他leaf 60）の全文をGitHubから取得し、意味上の候補・後続判断・歴史的文脈の初期確認を実施**。未取得・未点検の旧subjectsファイルは0件。
- 下表は*個々のファイルに哲学と方法論が混在する*ことを前提とした論点メモであり、**ファイル全体の哲学/方法論分類表ではない**。
- ソースの言語を保持して読み、粗哲学は[日本語の暫定候補](A1_ROUGH_PHILOSOPHY.md)として抽出する。英語に一度変換して哲学を再構成しない。
- この段階で「原文から意味が完全に抽出できた」「Ownerが承認した」「後続recordとの採否が全て解決した」とは主張しない。それらの検証・吟味はA-2/A-3で取り扱う。

## 旧subjects全ファイルの確認記録

| 元ファイル | Git blob SHA | 本文確認 | 主な論点・抽出時の注意 |
| --- | --- | --- | --- |
| `documents/knowledge/subjects/code-design/INDEX.md` | `71ba2e2dcd84ee5e878cdab32d5681ec7748e95c` | 全文取得・一次意味点検済み | コード設計責務の索引。境界原理と実現手順の区別 |
| `documents/knowledge/subjects/code-design/S001_REALIZATION_MODEL.md` | `fba5508a074f1666454cb739a8a2f6bec3a19db9` | 全文取得・一次意味点検済み | 契約中心のソフトウェア観・OO解釈の原理候補 |
| `documents/knowledge/subjects/code-design/S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md` | `39d211f532f337f693392444df2c21f8070d0399` | 全文取得・一次意味点検済み | 内部実装の自由と副作用の封じ込め |
| `documents/knowledge/subjects/code-design/S003_INHERITANCE_BOUNDARY.md` | `5dda82400f7e02e2bc841059ed555b58dce94726` | 全文取得・一次意味点検済み | 継承の意味・適用条件。一般的な継承禁止とは区別 |
| `documents/knowledge/subjects/code-design/S004_STATE_OWNERSHIP_AND_CONSISTENCY.md` | `a95abff26fed351b8399d8e1c38d8cd26da49ab3` | 全文取得・一次意味点検済み | 状態所有者と業務結果の調整責務 |
| `documents/knowledge/subjects/code-design/S005_CODE_STRUCTURE.md` | `d455a1efedcd4cb0e318518c8a4bd36da5562e15` | 全文取得・一次意味点検済み | 機能・層・公開面の具象構成。境界原理から分離 |
| `documents/knowledge/subjects/code-design/S006_DEPENDENCY_AND_EXTERNALS.md` | `a1b2890806e185ee3fbed8e6d9d4ebf1d2eb09ad` | 全文取得・一次意味点検済み | 依存方向・外部技術隔離。一般理念と手段の混在 |
| `documents/knowledge/subjects/code-design/S007_DOMAIN_AND_DATA_BOUNDARIES.md` | `7eb244850708ce8c6b2d14645372da1dffc6e6ac` | 全文取得・一次意味点検済み | ドメイン意味、型、DTO、データ所有境界 |
| `documents/knowledge/subjects/code-design/S008_FAILURE_ASYNC_AND_CONTRACTS.md` | `1c0d8b68b1a1cc20961dec35418167933ed92eca` | 全文取得・一次意味点検済み | 業務失敗とシステム障害、意味上の契約と実装方式 |
| `documents/knowledge/subjects/code-design/S009_TESTING_AND_RUNTIME.md` | `6317a00df75f940ac7c88a4cf43091f95cf0b53d` | 全文取得・一次意味点検済み | 契約適合と要求達成の区別、テストと実行形態 |
| `documents/knowledge/subjects/code-design/S010_COMPATIBILITY_AND_VERIFICATION.md` | `916f13ca401069a632a95b8a44d56726b137ccd1` | 全文取得・一次意味点検済み | 追加と互換性の区別、双方の契約当事者 |
| `documents/knowledge/subjects/code-design/S011_PERFORMANCE_SHAPED_INTERACTION.md` | `fce8fdcdc13f7a9955c96443d512a9c0376e5657` | 全文取得・一次意味点検済み | 実測性能要件が契約形状に影響する限定条件 |
| `documents/knowledge/subjects/code-design/S012_DESIGN_PRIORITY.md` | `8b55eac6f186c7e73aee880d15fd4c7403f9e218` | 全文取得・一次意味点検済み | 境界・契約・変更局所性と内部美観の判断優先 |
| `documents/knowledge/subjects/code-design/S013_HISTORY.md` | `fc97774e92806f33edd9a4e6e4b1cca72f532710` | 全文取得・一次意味点検済み | 旧表現・訂正・採用履歴。旧規則の復活に注意 |
| `documents/knowledge/subjects/context-shaping/INDEX.md` | `6471752cb334efdaa42df958069cd87eff0f338e` | 全文取得・一次意味点検済み | 目的指向の文脈構成の責務境界 |
| `documents/knowledge/subjects/context-shaping/S001_POSITIVE_FIRST_CONTEXT.md` | `409f39494a90c0ffdc7e4288991338fc8b531322` | 全文取得・一次意味点検済み | 目的に必要な意味を直接伝えるPositive-first |
| `documents/knowledge/subjects/context-shaping/S002_NEGATIVE_ALTERNATIVE_LEAKAGE.md` | `e9b32f3d9865df5189929647cfb413d227fb7580` | 全文取得・一次意味点検済み | NALの定義・不要な否定案の再導入 |
| `documents/knowledge/subjects/context-shaping/S003_APPLICABILITY_AND_GUARDS.md` | `7c060fdc0638afefe21ec06c70827492bca0ffa6` | 全文取得・一次意味点検済み | 対比が必要な場合、否定的制約と意味保存 |
| `documents/knowledge/subjects/development-execution/INDEX.md` | `a11f43ce927bf288d6d5a17c5d83aab8c73de6ec` | 全文取得・一次意味点検済み | 実行環境・公開操作・制御面の責務 |
| `documents/knowledge/subjects/development-execution/S001_EXECUTION_MODEL.md` | `43076ae1d27354d6be85108ed827ca7cfab4f0a0` | 全文取得・一次意味点検済み | 開発環境を契約とすること、再現性の意味 |
| `documents/knowledge/subjects/development-execution/S002_HOST_AND_CONTAINER.md` | `258843291b553ea47b7ecc3716a9f6b0808c2cf1` | 全文取得・一次意味点検済み | host/container・Docker・資源実装の具体規則 |
| `documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md` | `3ec48a9415abbfe105d46a4cfbb9fb5be77dd7c3` | 全文取得・一次意味点検済み | 公開操作の意味とDIRの役割、ローカル・CI |
| `documents/knowledge/subjects/development-execution/S004_ADOPTION_AND_MIGRATION.md` | `f3a3a4c37daebae43d12b2e15499cde3465e8f06` | 全文取得・一次意味点検済み | 新規・既存環境への段階導入手順 |
| `documents/knowledge/subjects/development-execution/S005_HISTORY.md` | `b6aa399a0585e3ff160b6b5c085c40758c667d6e` | 全文取得・一次意味点検済み | 旧umbrellaの分解と旧権威表現 |
| `documents/knowledge/subjects/development-safety/INDEX.md` | `5232f95315a61dde88cb7a9b49210e843cff2435` | 全文取得・一次意味点検済み | 安全操作、破壊、診断、確認責務の索引 |
| `documents/knowledge/subjects/development-safety/S001_SAFETY_PRINCIPLES.md` | `f7329cf4f4036395bb256a1169af26f58af41783` | 全文取得・一次意味点検済み | 安全を容易にする価値観、再現性・効率との優先 |
| `documents/knowledge/subjects/development-safety/S002_DESTRUCTIVE_OPERATIONS.md` | `de60d9e68cf83f81ee853aad780c240e63621eea` | 全文取得・一次意味点検済み | 実際の破壊対象・権限・所有境界 |
| `documents/knowledge/subjects/development-safety/S003_DIAGNOSTICS_AND_RECOVERY.md` | `f4db7280eaef3c731d09158fcf91fb73c1005d08` | 全文取得・一次意味点検済み | 検証・失敗時診断と回復の手順 |
| `documents/knowledge/subjects/development-safety/S004_INTEGRATION.md` | `328ab34b716733491dc9c602d45b9a0f08bc71c6` | 全文取得・一次意味点検済み | repository間統合時の安全性・再検証 |
| `documents/knowledge/subjects/development-safety/S005_CONFIRMATION_AND_REREAD.md` | `507cf56a35883788ea2deccfb47698ed68263f49` | 全文取得・一次意味点検済み | 危険度に比例した事前確認と再読 |
| `documents/knowledge/subjects/documentation/INDEX.md` | `19cb79f69b4626bb12d7d00ca7ab05a2a222d368` | 全文取得・一次意味点検済み | 文書の意味上の所有範囲、旧権威記述の注意 |
| `documents/knowledge/subjects/documentation/S001_PRINCIPLES.md` | `dce81d192ef91498c03085a7e8cc7dfc7d11075f` | 全文取得・一次意味点検済み | 情報正確性・完全性とトークン効率の優先 |
| `documents/knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md` | `73ec819c47dba71fd40a1576c5eb35a368c01da1` | 全文取得・一次意味点検済み | 文書構造・情報owner・必要時の参照 |
| `documents/knowledge/subjects/documentation/S003_WORKFLOW.md` | `97fc2284d1a1105de43e9aef036d948e7b2a6a88` | 全文取得・一次意味点検済み | 文書更新・reconciliation・managed派生物の境界 |
| `documents/knowledge/subjects/documentation/S004_MAINTENANCE_AND_REVIEW.md` | `6c5fba4699da5542e03a47655193e7622e61391a` | 全文取得・一次意味点検済み | 文書削除、保守、再確認の条件 |
| `documents/knowledge/subjects/documentation/S005_FORMAT_AND_GIT.md` | `f2414415efb3b9f4d6f6fee7e33484f8164fcaa5` | 全文取得・一次意味点検済み | Gitを変更履歴に使うこと、文書形式 |
| `documents/knowledge/subjects/documentation/S006_HISTORY.md` | `6de0a440d464be3ef60836a771bc6ef1f498d1a4` | 全文取得・一次意味点検済み | 旧AI優先・旧権威・旧version管理の非現行モデル |
| `documents/knowledge/subjects/encapsulation-horizon/INDEX.md` | `614a09755a4dac96615df32900fc752503e8153b` | 全文取得・一次意味点検済み | 責務高度と硬化地平線の概念と源流 |
| `documents/knowledge/subjects/encapsulation-horizon/S001_CORE_PRINCIPLE.md` | `602a7213f96cbacd8f04d852a5f77ded3689f886` | 全文取得・一次意味点検済み | 外の契約と内部の自由、フラクタル・地平線 |
| `documents/knowledge/subjects/encapsulation-horizon/S002_RESPONSIBILITY_AND_HORIZON.md` | `17c5c9d43d44166b8d00cece943bacfb40bc98bd` | 全文取得・一次意味点検済み | 責務を意味の束と捉えること、呼出側高度 |
| `documents/knowledge/subjects/encapsulation-horizon/S003_HARDENING_POLICY.md` | `de921b79f4832741ad7350be013481b3b610f85c` | 全文取得・一次意味点検済み | 責務安定性・継ぎ目費用・hardeningの時機 |
| `documents/knowledge/subjects/encapsulation-horizon/S004_CONCEPT_ALTITUDE.md` | `5241fbbac6a20c78adae1100e8aaf0fe8edaefe0` | 全文取得・一次意味点検済み | 意味の高度、YAGNIの範囲、後続の訂正 |
| `documents/knowledge/subjects/encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` | `71e48c95239dfd1c83270268655d4ec23377165b` | 全文取得・一次意味点検済み | 契約完全性・漏洩チャネル・過剰保証の訂正 |
| `documents/knowledge/subjects/encapsulation-horizon/S006_EVOLUTION_AND_GRADUATION.md` | `7225dd5689f1839469d4163beaaa31eca6898cbb` | 全文取得・一次意味点検済み | 責務成熟・内側の境界昇格・将来費用 |
| `documents/knowledge/subjects/encapsulation-horizon/S007_GLOSSARY.md` | `9182bab453dd7951d5d2e0b9a62e98099bb8187b` | 全文取得・一次意味点検済み | 原理の語彙と、複数意味を持つmoduleの区別 |
| `documents/knowledge/subjects/encapsulation-horizon/S008_OPERATIONAL_GUARDS.md` | `a82f100ca19b609e9c29815df2848b898d8bd684` | 全文取得・一次意味点検済み | 原理の誤読防止・変更影響レベルの運用 |
| `documents/knowledge/subjects/encapsulation-horizon/S009_HISTORY.md` | `d7d8b47e537e3b14637400a8e561344f7264fc48` | 全文取得・一次意味点検済み | 旧日本語原本と派生Artifactの歴史的関係 |
| `documents/knowledge/subjects/engineering-operation/INDEX.md` | `a59e4847d23caf5b596b745c8b3528a6bdd3ae6f` | 全文取得・一次意味点検済み | 実装の進め方・権限・検証の責務索引 |
| `documents/knowledge/subjects/engineering-operation/S001_CHANGE_LIFECYCLE.md` | `87338c4d7597cc0a164e86dff32b856a0ea4baae` | 全文取得・一次意味点検済み | 探索/設計/実装の区別とWork開始ゲート |
| `documents/knowledge/subjects/engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md` | `191729a68df627463ec5f949f4f3aed2e92e4e59` | 全文取得・一次意味点検済み | Owner権限、RC強度、Project固有の具体化 |
| `documents/knowledge/subjects/engineering-operation/S003_PRE_IMPLEMENTATION_SCAN.md` | `34914576ac4fc932ac13f9529673f883de71aaa5` | 全文取得・一次意味点検済み | 変更影響に比例した設計上の事前確認 |
| `documents/knowledge/subjects/engineering-operation/S004_CONFIRMATION_AND_ROUTING.md` | `676a583ce07574ca9588b3a08bfe6de2914d150c` | 全文取得・一次意味点検済み | 判断主体ごとに確認条件を委譲する |
| `documents/knowledge/subjects/engineering-operation/S005_VERIFICATION_AND_DONE.md` | `175425f0cb563501f70a81b00a90171c14eeb405` | 全文取得・一次意味点検済み | 契約適合と要求達成、未検証を隠さない |
| `documents/knowledge/subjects/engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md` | `8f3defd98a5caeaddde7a37b72b505fccb550352` | 全文取得・一次意味点検済み | file/commit/push/mergeを区別、事実と報告 |
| `documents/knowledge/subjects/engineering-operation/S007_BROWNFIELD_AND_APPROACH.md` | `d4deb8bc5a479bf986c6194b98ee1db762d48b46` | 全文取得・一次意味点検済み | scope逸脱を避ける改善と既存規約尊重 |
| `documents/knowledge/subjects/engineering-operation/S008_HISTORY.md` | `af6b5148908d15484e3b2b45a141c50b71ab2ab2` | 全文取得・一次意味点検済み | 旧AI workflowと後続訂正 |
| `documents/knowledge/subjects/INDEX.md` | `e14a6949c8260d2bc2266b604eb5f235a72415a1` | 全文取得・一次意味点検済み | 旧subjects全体の索引・責務所有関係 |
| `documents/knowledge/subjects/work-identity/INDEX.md` | `6f9676e7af893935412553491d4bbfa282068d93` | 全文取得・一次意味点検済み | Workの意味・資源・文書・実装形態の責務 |
| `documents/knowledge/subjects/work-identity/S001_IDENTITY_MODEL.md` | `a5228c66eaa7eb0bc86750146ff92d65ec2d1212` | 全文取得・一次意味点検済み | 目的から導くWork Identityと実装確定条件 |
| `documents/knowledge/subjects/work-identity/S002_WORK_ROOT_AND_REPOSITORIES.md` | `098cf3c4e722f636bd732480da61050c95f2c7a3` | 全文取得・一次意味点検済み | Work RootとAgent Root、単一/複数repo構成 |
| `documents/knowledge/subjects/work-identity/S003_WORK_DOCUMENTS.md` | `ca3a81f08e0b69dfee242df889c61c44f1f17c79` | 全文取得・一次意味点検済み | 開発判断の進行記録と仕様正本・履歴の分離 |
| `documents/knowledge/subjects/work-identity/S004_LIFECYCLE_AND_RESOURCES.md` | `2d9efb63c82e05df9c41e8ead23bcf4ef5c59172` | 全文取得・一次意味点検済み | Work/Run/Project資源所有とcleanupの境界 |
| `documents/knowledge/subjects/work-identity/S005_WORKTREE_MATERIALIZATION.md` | `6af1698485f094381ef8f41bbe1a0f68c3aba48f` | 全文取得・一次意味点検済み | Git worktreeの具体的物理化・実験証拠 |
| `documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md` | `a129f366e4076872a3ee8ee8b028adc107e798e9` | 全文取得・一次意味点検済み | public command・パス指定と内部identity解決 |
| `documents/knowledge/subjects/work-identity/S007_VALIDATION.md` | `d01fcce15a4b5c4a529e664d9fcf3306e49dc107` | 全文取得・一次意味点検済み | 参照実装の検証事実と未検証範囲 |
| `documents/knowledge/subjects/work-identity/S008_HISTORY.md` | `85c75aef5aa79fb16f441e415ede7289bb7df613` | 全文取得・一次意味点検済み | 旧Task Worktreeと過去Artifact化方針 |
| `documents/knowledge/subjects/workspace-structure/INDEX.md` | `8966db46e078086ac82d2b40c0d1b6b91936efe5` | 全文取得・一次意味点検済み | 静的なProject/Repository/Git所有の責務 |
| `documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md` | `05477df5481790876c38a8881fae292bacb17c30` | 全文取得・一次意味点検済み | Management Root/Component役割と物理配置 |
| `documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md` | `544486be85f4e8fe283ba448e46343cd643c8d1f` | 全文取得・一次意味点検済み | Git ownershipと物理的包含の独立 |
| `documents/knowledge/subjects/workspace-structure/S003_HISTORY.md` | `b01974487f0e25ebd0c0049b3fa12227f1f6e686` | 全文取得・一次意味点検済み | 旧Project/Workspace/親子roleと後続改称 |

## 抽出結果と未確定の範囲

全70ファイルに対する意味の一次スクリーニングを終え、**粗哲学候補の新規検討事項と修正事項**を[粗哲学](A1_ROUGH_PHILOSOPHY.md)に反映する。

- `*_HISTORY.md`等は、原文・旧規則と現在評価の違いを検査するために読み、旧案を無条件に再採用しない。
- INDEX、テスト、実験・検証文書も除外せず確認した。**名前やファイルの配置だけで「哲学だから／哲学ではないから」と結論を出していない**。
- 独立した哲学命題の数、優先順位、配置単位はA-3/A-4に未確定として残す。
- A-1の網羅的な**ファイル調査**は完了。records由来の追加発見・補正は[A-2](A2_FINDINGS.md)に追跡する。
