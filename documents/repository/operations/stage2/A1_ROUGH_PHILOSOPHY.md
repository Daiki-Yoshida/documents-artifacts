# Stage 2-A-1：粗哲学の抽出候補（未承認）

> **重要：この文書は正式なDev-Philosophyではありません。**
> 2026-11-11の初稿を英語で書いたことは、原文言語・意味の保存を重視する設計方針に反する不備でした。以下は英語の候補から単純に訳し戻したものではなく、確認した**旧subjectsの日本語原文**に立ち戻って再記述した、暫定的な分析です。初稿はGit履歴に残りますが、今後の判断根拠には使用しません。

## 調査範囲と表現上のルール

- 調査元：旧`documents-artifacts`の`main@7ad8bb4f948359633003a47fa6bfcc8d6853ddb6`に固定した`documents/knowledge/subjects/`。
- **70ファイルすべてを全文取得・初期点検**。未確認の旧subjectsファイルは0件。ただしこれだけでは各候補の完全な意味保存と採用状態の確定を保証しません。
- 直接引用は旧subjectsの日本語記述。引用の**Markdown強調記号や折り返し改行のみ表示上整理**しており、全文原文とのbyte一致を意味しません。引用の次に置く「抽出候補」はAIによる仮の整理であり、**元文の代替でもOwnerの制定済み思想でもありません**。
- 「哲学か方法論か」「概念が独立しているか」「どのファイルに分けるか」はA-3・A-4まで確定しません。P01〜P17は追跡用の仮IDです。
- 古いsubjectsには後続訂正を含むものがあります。原文recordにおける採否・訂正・有効範囲の検証はA-2で継続します。
- 出典パスは特記しない限り`documents/knowledge/subjects/`からの相対パスです。

## P01 — 境界の契約と内部の自由

**旧subjectsの記述（日本語原文から引用）**

> 境界面（外部に公開する契約）は固く（strict・stable）、その内部実装は柔軟（free）であれ。

> 内部の自由度と境界面の契約完全性は双対(dual)である。

**仮の抽出候補：** 外部に公開した境界の契約は厳密に守り、その契約を満たす限り内部実装の変更自由を確保する。ここでいう契約は単なる型・シグネチャではなく、外部へ影響する意味、資源、失敗、決定性、データ等の漏洩経路を考慮する。

**根拠：** `encapsulation-horizon/S001_CORE_PRINCIPLE.md` 第1・4節、`encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` 第7節、`code-design/S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md`。

**留保：** 「内部は自由」は「内部は不正確でもよい」ではない。実際に必要な保証の範囲や、自由と契約完全性の因果関係をA-2で確認する。

## P02 — 責務・高度に応じて選ぶ動的な境界

**旧subjectsの記述（日本語原文から引用）**

> フラクタルだからといって、全スケールで硬化を強制してはならない。

> 硬化の単位 ＝ 一つの「呼び出し側に整合した責務」を負う「機能のまとまり」。

> 規則：一責務 かつ 安定 かつ 継ぎ目が安い ときに硬化する。

**仮の抽出候補：** 境界をどの高さで厳密な契約として扱うかは、責務の意味、成熟度、呼び出し側からの一貫性、継ぎ目の維持費用などに基づき選ぶ。すべての関数・クラスを一律に硬化するわけではなく、責務が成熟・変化すれば境界を再評価する。

**根拠：** `encapsulation-horizon/S001_CORE_PRINCIPLE.md` 第2〜4節、`S002_RESPONSIBILITY_AND_HORIZON.md` 第5節、`S003_HARDENING_POLICY.md` 第6節、`S006_EVOLUTION_AND_GRADUATION.md` 第8節。

**留保：** 旧文書でもANDの出現は機械的な分割命令ではなく警告である。`module`は初期判断の目安であり、不変の下限ではない。これらの区別を削らない。

## P03 — 概念の意味と最初の利用者・配置を分離する

**旧subjectsの記述（日本語原文から引用）**

> 概念はその意味の高度に置く。最初の呼び出し側は消費者であって所有者ではない。

**仮の抽出候補：** 概念の意味を、その概念を最初に必要とした機能へ不要に従属させない。ただし、消費者に依存しない名前を付けられることは、複数の消費者が同一の契約を共有できる証拠ではない。意味の一般性、物理配置、契約の共有は別々に判断する。

**根拠：** `encapsulation-horizon/S004_CONCEPT_ALTITUDE.md` 第6.7節。

**留保：** 「責務を一文で説明できる」は中立性を考える手掛かりであり、意味の同一性の証明ではない。後続の修正採用記録をA-2で確認する。

## P04 — YAGNIの適用範囲と必要な契約の完全性

**旧subjectsの記述（日本語原文から引用）**

> YAGNI が禁じるのは投機的な機構（使われない interface・余分な継ぎ目・早すぎる共有モジュール抽出）。

> hardeningを待てるのは「まだ何を固めるべきか分からない」からであり、「固めるのが大変だから」だけではない。

**仮の抽出候補：** YAGNIにより将来を予測した公開機能や内部機構の追加を抑える一方、現在選んだ責務を成立させるために必要な契約・保証を、作成コストが高いという理由だけで省略しない。

**根拠：** `encapsulation-horizon/S003_HARDENING_POLICY.md` 第6・6.5節、`S004_CONCEPT_ALTITUDE.md` 第6.8節、`S005_CONTRACT_COMPLETENESS.md` 第7節。

**留保：** Ownerの2026-09-24原文には、内部の堅牢化や基盤設計に対するYAGNIの適用をさらに渋る強い意図がある。旧subjectsでの整理がその意味を正しく保持したか**未解決**。この候補を最終的な哲学として採用しない。

## P05 — 強い契約は最大限に制限する契約ではない

**旧subjectsの記述（日本語原文から引用）**

> 「strong contract」は必要な意味・制約を明示的に閉じることであり、現在の実装が偶発的に持つobservable propertyを最大限にpublic guaranteeへ昇格することではない。

**仮の抽出候補：** 必要な契約は十分に明示するが、現在の実装が偶然持つ性質まで無条件に外部保証へ組み込まず、内部の変更可能性を保つ。要求や選択した責務から必要とされる性質は例外なく検討対象となる。

**根拠：** `encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` 第7節（2026-09-24追加）。

**留保：** 「強い＝最大限の保証」と誤読しない。原文recordの採用関係をA-2で確認する。

## P06 — 状態・副作用・業務結果の所有境界

**旧subjectsの記述（日本語原文から引用）**

> mutable stateは1つのclear ownerを持つ。

> 1つのbusiness outcomeが複数state ownerをまたぐ場合、参加者の内部stateを奪わずに、coordinationとfailure policyを所有するboundaryを明確にする。

**仮の抽出候補：** 状態や副作用を消去するのではなく、その所有者と外部への影響を明らかにして境界へ閉じ込める。複数の所有者にまたがる結果には調整・失敗方針の責務を定める。

**根拠：** `code-design/S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md`、`code-design/S004_STATE_OWNERSHIP_AND_CONSISTENCY.md`。

**留保：** atomic transaction、retry、compensationなどの具体的手段は哲学の原理と区別する。方法論に属するかどうかの決定はまだ行わない。

## P07 — 設計判断で優先するものと技術的手段の位置づけ

**旧subjectsの記述（日本語原文から引用）**

> 内部実装を美しくするために、1〜4を犠牲にしない。

> class / interface / objectはboundaryを表現するmechanismであり、それ自体が設計目的ではない。

**仮の抽出候補：** 境界や契約の明確さ、外部との安定した接点、変更影響の局所化、副作用の明示性を、内部実装の見た目や特定の言語パラダイムより優先する。継承も合成も目的ではなく、必要な契約に応じた手段として扱う。

**根拠：** `code-design/S001_REALIZATION_MODEL.md`、`S003_INHERITANCE_BOUNDARY.md`、`S012_DESIGN_PRIORITY.md`。

**留保：** 「継承は禁止」「常に合成を使う」といった別の規範を作らない。順位自体の根拠record・採用状態はA-2で調査する。

## P08 — 必要な文脈を直接伝えることとNAL

**旧subjectsの記述（日本語原文から引用）**

> consumerの目的に必要なmodel・判断・手順を直接記述し、それを正しく適用するためのcondition・exception・rationale・constraintを添える。

**仮の抽出候補：** 説明・指示では、受け手の目的に必要な意味や判断材料を中心に据える。不採用案を否定するだけのために不要な代替モデルを詳述し、判断を混乱させない。ただし必要な比較、反例、訂正、禁止、安全条件、履歴は残す。

**根拠：** `context-shaping/S001_POSITIVE_FIRST_CONTEXT.md`、`S002_NEGATIVE_ALTERNATIVE_LEAKAGE.md`、`S003_APPLICABILITY_AND_GUARDS.md`。

**留保：** これは哲学か、説明作成の方法論かを未判定とする。NALは未解決事項や反証を消す基準ではない。

## P09 — 情報の正確性と伝達効率の関係

**旧subjectsの記述（日本語原文から引用）**

> 正確性とトークン効率が競合する場合、正確性が勝つ。

**仮の抽出候補：** 知識や判断材料を保存・提示する際は、意味の正確性や必要な情報の完全性を、単なるトークン節約より重く扱う。

**根拠：** `documentation/S001_PRINCIPLES.md` の核心原則。

**留保：** 同じ旧文書は、解決策として選択的ルーティングを推奨している。しかし**それをDev-Philosophyの必須原則に昇格させない**。現在のOwnerは少なくとも哲学について全体把握を必須としており、配布方式はStage 3で判断する。

## P10 — 安全性と使いやすさを両立する設計

**旧subjectsの記述（日本語原文から引用）**

> 安全な操作を最も簡単な操作にする

**仮の抽出候補：** 安全のための手順を複雑にするだけでなく、安全な操作が日常的に選びやすい構造を設計する。実行対象、責務、副作用、再現性を明確にする。

**根拠：** `development-safety/S001_SAFETY_PRINCIPLES.md`、`development-execution/S001_EXECUTION_MODEL.md`。

**留保：** Docker-first等の具体的な技術選択は、価値判断と同一視しない。優先順位の全体も後続recordと照合する。

## P11 — Workの同一性を目的の意味から考える

**旧subjectsの記述（日本語原文から引用）**

> 開発作業の管理単位を、ツール固有の識別子や個々の実行回数ではなく、「何を実現するための開発作業なのか」という意味のある単位へ統一する。

**仮の抽出候補：** 開発作業の単位はGitブランチや実行ツールで定義するのではなく、達成する開発目標の意味によって同一性を持つ。

**根拠：** `work-identity/S001_IDENTITY_MODEL.md`、`engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md`。

**留保：** 方法論との境界が不明瞭。特にWork IdentityのRC3適用条件を、すべての人間開発に無条件に拡大しない。

## P12 — 契約適合と依頼の目的達成は別の評価

**旧subjects：** `code-design/S009_TESTING_AND_RUNTIME.md`、`S010_COMPATIBILITY_AND_VERIFICATION.md`、`engineering-operation/S005_VERIFICATION_AND_DONE.md`。

**仮の意味：** 契約・実装・テストが内部で一致していても、契約そのものが利用者の求める結果を表していなければ、目的は達成されない。形式上の正しさと外側の達成目的を混同しない。

**A-2で確認した判断：** `2026-09-06-design-principles-proposals/`の提案1→`2026-09-15-design-principles-contract-decision/`の修正採用1。旧「Contract Test＝正しさ全体」という解釈は非現行。

**留保：** 哲学上の価値判断と、要求を実際に検証する具体的な方法論を区別する。

## P13 — 契約の互換性は当事者への保証で決まる

**旧subjects：** `code-design/S010_COMPATIBILITY_AND_VERIFICATION.md`、`encapsulation-horizon/S008_OPERATIONAL_GUARDS.md`。

**仮の意味：** 公開した契約の変更を「追加だから安全」と判断せず、呼び出し側と実装側の双方に対して、従来の意味・保証が維持されるかを問う。

**A-2で確認した判断：** `2026-09-15-design-principles-contract-decision/`の修正採用3。追加形状を互換性とみなす旧解釈を修正した。

**留保：** source/binary/wire/schema等の確認方式や変更levelは方法論に属し得る。P01の契約原理の具体化かもしれない。

## P14 — 重要な要求が契約の形そのものを見直させる

**旧subjects：** `code-design/S011_PERFORMANCE_SHAPED_INTERACTION.md`。

**仮の意味：** 境界の契約は重要でも、現実の要求と証拠を無視して形を固定化することが目的ではない。性能要件が実際に重要で、既存のinteraction shapeが障害なら契約形状を再評価できる。

**A-2で確認した判断：** `2026-09-15-performance-redesign-hold/`では**保留**、`2026-09-20-performance-contract-evolution/`で証拠とload-bearing要件を前提に進化を許容。保留を現在のstatusとして残さない。

**留保：** この考えがP12の「目的」を実現する具体論か、それ自体が哲学的価値かはA-3で検討する。

## P15 — 意味上の所有権と物理的な配置は別

**旧subjects：** `workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md`、`S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md`、`documentation/S001_PRINCIPLES.md`。

**仮の意味：** あるものが物理的に他のものの内部へ配置されても、それだけで意味の所有権、変更権限、Git上の親子関係は発生しない。

**A-2で確認した判断：** `2026-10-03-project-component-documentation-boundary/`で親子構造から責務別モデルへ整理、`2026-10-04-management-root-repository-terminology/`で役割名を更新、`2026-10-04-workspace-physical-topology/`で物理包含と権威の別軸を確認。

**留保：** repositoryの例から抽出した一般原理。P03「意味の高度」やP11「Work Identity」と共通する根かどうかは不明。

## P16 — 原文の保存、現在の評価、利用目的を区別する

**旧subjects：** `documentation/S001_PRINCIPLES.md`、`S006_HISTORY.md`、`work-identity/S003_WORK_DOCUMENTS.md`。

**仮の意味：** 過去に提案・議論された情報を完全に保持することは、その全情報を現在採用していることを意味しない。情報の正確さ、採用状態、配布・提示の必要性を別の軸で扱う。

**A-2で確認した判断：** `2026-09-21-knowledge-record-accuracy/`、`2026-10-03-knowledge-effective-status-lineage/`、`2026-10-13-record-intake-regulation/`。

**留保：** Ownerの開発哲学そのものというより、repository管理の契約かもしれない。両領域への独立した二重制定は避ける。

## P17 — 操作の権限・対象・事実を分離する

**旧subjects：** `engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md`、`S006_VERSION_CONTROL_AND_REPORTING.md`、`development-safety/S002_DESTRUCTIVE_OPERATIONS.md`。

**仮の意味：** 操作が技術的に可能であることは、実行を許されていることではない。対象の実効的な書込先・副作用・Owner権限を評価する。また、書込・commit・push・merge・検証・完了はそれぞれ別の状態である。

**A-2で確認した判断：** `2026-10-12-project-root-write-boundary/`、`2026-10-13-project-root-write-boundary-completion/`、`2026-10-30-management-baseline-coordination/`。

**留保：** 具体的なGit運用はDev-Methodology。区別する価値判断がP10やP15に含まれる可能性がある。

## A-1完了とOwner吟味への引き継ぎ

- 旧subjects **70/70ファイル**を全文取得し、哲学・方法論・歴史に関わる意味を一次点検済み。ファイル未確認は0件。
- ここまでのP01〜P17は**17個の未承認の候補**であり、哲学の最終個数、概念の上下関係、分類単位を確定したものではない。
- [A-2 records全件台帳](A2_RECORDS_COVERAGE.md)、[系譜の監査](A2_DECISION_LINEAGE_REVIEW.md)による採否・訂正・意味差の検証を受けた状態であり、解釈に保留があるものは明示する。
- A-3でOwnerと思想の本体を議論し、A-4の合意後にのみ哲学の構造を確定する。
- [A-1/A-2完了監査とOwnerへの論点](A1_A2_COMPLETION_REPORT.md)に検証の限界を記す。

**現時点で制定済みの哲学は、この候補群には存在しない。**
