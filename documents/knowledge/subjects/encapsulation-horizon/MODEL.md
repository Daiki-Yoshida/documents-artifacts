# Encapsulation Horizon — 境界設計の原本

```yaml
document_scope: "reference_material"
exported_artifact: false
default_copy_target: false
ai_loading: "AIに毎回読ませる文書ではない。これは思想の原本(source of truth/rationale)であり、AI常読のコンテキストファイルではない"
language: "japanese"
purpose: "境界設計思想（Encapsulation Horizon）の全推論を保存する原本。artifacts/ はこの思想の運用サブセットを圧縮符号化したものであり、本書がその出典である"
authored_by: "project owner"
```

## 0. この文書の位置づけ

`artifacts/` の各文書は **AIが毎回読む運用版**である。トークン効率のため圧縮されており、
圧縮は必ず文脈を落とす。落ちた文脈は、別のAIセッションや別の読み手による**再解釈（伝言ゲーム）**を招く。

本書はそれを防ぐための **原本** である。ここには結論だけでなく、結論に至る**推論の全鎖**を残す。
artifacts が矛盾して見えたり、運用ルールの「なぜ」が失われたときは、**本書が最終的な出典**となる。

```yaml
relation:
  this_document: "思想の全推論（why の why まで）。非配布・非AI常読"
  artifacts/:     "上記の運用サブセット。配布・AI常読。圧縮版"
  rule: "artifacts は本書から導出される。両者が食い違ったら本書が正。artifacts からは本書を参照しない（配布先に存在しないため）"
```

---

## 1. 出発点 — 境界面は固く、内部は柔軟に

設計の中心命題は一つ。

> **境界面（外部に公開する契約）は固く（strict・stable）、その内部実装は柔軟（free）であれ。**

経路探索モジュールを例にとる。外部に公開するインターフェイス／境界面はガチガチに固定したい。
だが内部実装は完全に自由でよい——メモリポインタを直接動かそうが、並列処理をぶん回そうが、
GPUに投げようが**どうでもいい**。大切なのは境界面であり、**内部はその内部自身の責任**だからだ。

この非対称性が全ての出発点である。「外は契約、中は自由。」

---

## 2. 境界はフラクタル（スケール不変）

境界＝契約という原理は**再帰的**である。同じ規律が全スケールに効き、ある層の単位は
一つ下の層の単位から構成される。

```text
function / interface  →  class  →  機能のまとまり  →  library  →  service  →  application / public API
```

どの高さでも、単位は「契約（Signature + Semantics + Constraints）で定義された黒箱」である。
アプリケーション全体すら一つの境界づけられた単位であり、その公開APIがその契約である。

したがって「境界面は固く、内部は柔軟に」も**原理的には全スケールに適用可能**だ。

---

## 3. 緊張 — フラクタルを“強制”すると破綻する

ここに罠がある。**フラクタルだからといって、全スケールで硬化を*強制*してはならない。**

- **全部硬化させる** → あらゆる関数・クラスに固い契約・mapping・indirection を課す＝
  **継ぎ目地獄（death by a thousand seams）**。封じ込めの利得を統合コストが上回り、
  バグは継ぎ目に棲む。over-modularization。
- **どこも硬化させない** → 泥団子（big ball of mud）。境界がなく、変更が全体に伝播する。

両極とも誤り。正解はその中間に**意図的な切断線**を引くことである。

---

## 4. 解 — Encapsulation Horizon（カプセル化の地平線）

**フラクタルは「適用*可能*な範囲」の記述(descriptive)、地平線は「実際に硬化を*強制*する範囲」の規範(prescriptive)。**
この二層を分けて持つことが解である。原理は全スケールに効くが、**硬化を強制する高さを一段に選んでコミットする**。

> **Encapsulation Horizon**：
> ある高さを選び、その面を固い契約として硬化させる。
> **その内側は一つの柔軟ゾーンとして扱い、内部の下位境界は硬化を強制しない**（＝内部の責任）。
> その外側・その面は硬い契約として守る。

地平線を**選んでコミットすること自体**が設計判断である。フラクタルに全部固めるのでも、
全く固めないのでもなく、「ここで切る」を決める。これは YAGNI を*構造化*したものだ。

地平線は**コスト非対称性**に正確に乗る：

```yaml
above_or_at_horizon: "誤りが高価（外へ伝播する）→ 正確性・安定性に投資（accuracy mandatory）"
below_horizon:       "誤りが contained（内に留まる）→ 速度・自由を取る（speed acceptable）"
```

---

## 5. 地平線の正体 — 責務 ＝「機能のまとまり」

当初これを「モジュールがミクロ/マクロの境」と表現したが、それは**境界を定数化しすぎていた**。
地平線は固定スケールではなく、**選ばれ・動く**ものである。

地平線の本質は **SRP の「責務」** と同じである。

> 漏れず・単一の柔軟ゾーンとして理解し続けられる最大の内部 ＝ **一つの責務**。

「module」という語は言語ゲームで意味がぶれるため、本書では基体中立な語
**「機能のまとまり」** を用いる。これは関数・クラス・パッケージ・サービスのいずれにもなれる
（＝だからこそフラクタルである）。これは Parnas が "module" で*本来*意味していたもの
——責務（reason to change）による分割——の原義の回復でもある。

> **硬化の単位 ＝ 一つの「呼び出し側に整合した責務」を負う「機能のまとまり」。**
> その**外面**を固め、内部は柔軟に保つ。

`module` は地平線の**既定値**として優秀である（独立変更・所有・テスト・デプロイの単位と一致する）。
だが**原理の床ではない**。地平線は責務の高さで決まり、下にも上にもずれる（§8 参照）。

### 責務は曖昧さを消したのではなく、構造化した

SRP の「reason to change」は観測者・高度(altitude)相対である。「経路を返す」は呼び出し側では一責務、
内部では多責務。つまり**責務それ自体が入れ子(nested)**であり、これは欠陥ではなく
**地平線が成立する理由**だ。客観的な「床」が得られたのではなく、**候補地平線の入れ子階層**が得られた。
判断は消えず形が変わる——「唯一の真の責務を探す」ではなく「**どの責務 altitude で硬化するか**を選ぶ」。

### 責務 ＝ 意味の束（meaning bundle）

責務は、関数・メソッド群・クラス名ではない。**ある高度・ある呼び出し側から見て、その単位が*存在する理由*を説明する「意味の束」**である。

```text
意味(meaning) → 責務(responsibility) → 契約(contract) → 境界(boundary)
```

すべてのコードに意味はあるが、すべての意味が境界に値するわけではない。意味は責務へ束ねられ、安定した責務は契約となり、契約は境界となる。

ただし**意味は「説明の終点」であって「操作テスト」ではない**。`meaning` は最も観測不能・主観的で、AI も人も「これは一貫した意味の束か」を確実に判定できない。だから*操作*には観測可能な症状を使う：

```yaml
meaning_is_terminus: "responsibility の根は meaning。だが meaning 自体はテストに使わない（観測不能）"
operate_on_symptoms: ["reason-to-change（一つの変更理由か）", "caller-coherence（呼び出し側に一つの能力に見えるか）", "AND テスト（§8）"]
rule: "meaning で理解し、症状で操作する。artifacts には meaning を持ち込まず症状で書く。"
```

---

## 6. 硬化の条件 — 一責務は必要条件にすぎない

一責務の「機能のまとまり」は硬い境界の**候補**にすぎない。実際に*硬化すべきか*には2つの門番が要る。

```yaml
guard_1_stability:
  rule: "責務がまだ発見途上なら硬化しない（早すぎる硬化は間違った分割を ossify=化石化させる）"
  note: "SRP は境界を *どこに* 置けるかを言う。*いつ* 固めるかは *成熟* が言う"
guard_2_seam_cost:
  rule: "二つの責務が別でも、相互作用が極端に密なら間に硬い面を置かない（高トラフィックの料金所になる）"
  note: "凝集は『変わる理由』だけでなく結合・相互作用密度でもある"
```

> **規則：一責務 かつ 安定 かつ 継ぎ目が安い ときに硬化する。**

---

## 6.5. 探索方向・既定状態・初期地平線（Macro → Micro / Harden-by-Default / Module = prior）

§6 は硬化の*条件*を与えた。本節は、その条件を**どの方向から・どんな既定で・どこを初期値に**適用するかを定める。

### 探索方向は マクロ → ミクロ。既定は「硬化」。

ミクロからマクロに積み上げる（小さく固めて上へ）のではなく、**最外面から内へ降下し、各層の*公開面*を既定で硬化する**。降下しながら、深くなるほど「柔軟へ反転する」圧が増す。

```yaml
direction: "macro → micro（最外面から内へ降下）"
default_state: "降下中、各層の*公開面*は既定で硬化する。地平線より内側の*内部*は既定で柔軟。『既定で硬化』は*面*の話であって『interface を全部作れ』ではない（→ §13 誤読防止）。"
flip_with_depth:
  at_or_above_horizon: "既定＝硬化（緩めるには理由が要る：例 chatty cluster）"
  below_horizon:       "既定＝柔軟（固めるには理由が要る：graduation トリガ §8）"
relax_pressure: "深くなるほど柔軟既定への反転圧が単調増加する"
```

### なぜ「上から・硬化既定」なのか — 2つの非対称

```yaml
blast_radius: "マクロを硬化し損なう=破滅的（外へ伝播）。ミクロを過剰硬化=contained。迷えば上を固める方が安全側。"
correction_cost: "硬化→柔軟(relax=内部契約を消す/併合)は安い（内部は既に厳しい規律に従い、外部呼び出し者もいない）。柔軟→硬化(graduate, §9 の支払い日)は高い。∴『default-harden＋必要なら緩める』は『default-flexible＋必要なら割る』を、硬化が要りやすい階層で支配する。"
```

過剰硬化は安く取り消せるが、過少硬化は高くつく。だから既定を硬化に置く。これは §9 の訂正コスト非対称から導かれる *方向の定理* である。

### 初期地平線 ＝ module（floor ではなく prior）

降下が**ミクロまで暴走する**のを防ぐため、降下の*既定停止深度*が要る。その既定 ＝ **module**。

```yaml
initial_horizon: "module"
status: "緩い prior（初期値）であって floor（不変の床）ではない"
meaning:
  at_or_above_module: "既定＝硬化"
  below_module:       "既定＝柔軟（固めるには理由が要る）"
day_1_rule: "day 1 の硬化深度は『module まで。それ以深は理由が出るまで柔軟』。最外面と主要 module 面を固め、サブモジュールは既定で柔軟。"
why_module: "独立変更・所有・テスト・デプロイの単位と一致し、責務が*名指せる程度に粗く・まだ流動的でない程度に細かい*高度に、多くのプロジェクトで最初に安定して一致するから。"
```

**prior と floor の違い**が、以前「module＝ミクロ/マクロの境（constant）」と書いて外した点との分岐である。constant（floor）ではなく、成熟度で更新される初期値（prior）。

### 成熟度が地平線を動かす（時間軸）

```yaml
t0_immature: "地平線＝module（場合により上）。深追いしない。"
maturing:    "サブ責務が結晶化（AND テスト発火, §8）したら、その部分だけ module より下へ地平線を降ろす（graduation）。"
reverse:     "常に一緒に変わる chatty な module 群は、地平線を module より上へ。"
```

### 早期段階の警告 — 過剰硬化の正体とコスト

この方針を**ドメイン未成熟の初期**に適用すると過剰硬化を招きうる。**それはマクロ定義の誤りではなく、本来柔軟であるべきミクロ段階まで硬化させてしまうこと**を指す。relax が安いので「全柔軟よりマシ」だが、なお避けるべき。理由：

```yaml
early_overharden_cost:
  upfront_waste: "必要か不明な micro 単位に完全な契約を先払いで書き、後で捨てる。"
  exploration_friction: "硬い内部境界が、正しい seam を発見する高速な作り替えを阻む＝ドメインの成熟そのものを遅らせる（最重要）。"
  organizational_inertia: "relax は技術的には安いが、固めた境界には人・テストが乗り粘る。"
rule: "未成熟な間は module より下へ降りない。最外面と*安定した* module 面のみ硬化する。"
```

### グリーンフィールドの但し書き

```yaml
unconditional: "最外面（app/service の公開API）は無条件に硬い（定義上必ず存在し、blast radius 最大）。"
conditional:   "内部の module 分割が未発見なら、その module seam も guard_1（安定性, §6）に従い安定するまで固めない。prior は『module まで降下硬化』だが、*どの* module seam を固めるかは安定性で選ぶ。"
```

---

## 6.6. 決定表（split / seam-cost）

判断重めの語（stable / cheap seam / cohesive）を機械化するための表。

```yaml
responsibility_split:
  keep_together:
    - "複数ステップが上位の一意味に従属する"
    - "同じビジネス理由で変わる"
    - "呼び出し側に一つの一貫能力に見える"
    - "割ると chatty な継ぎ目になる"
    - "別テストにすると setup がほぼ重複する"
  split:
    - "peer-level の AND（別 actor/policy/lifecycle）"
    - "片方は頻繁に変わり片方は安定"
    - "下位責務を独立にテストできる"
    - "外面を保ったまま内部地平線を足せる"
seam_cost:
  cheap:
    - "境界越え呼び出しが低頻度"
    - "データ形が安定・所有が明確"
    - "共有可変不変条件が少ない"
    - "契約経由でテストしやすい"
  expensive:
    - "高頻度の往復呼び出し"
    - "共有可変状態／データ形が一緒に変わる"
    - "多くの変更で両側を編集する"
    - "mapping を増やすのに変更影響を減らさない"
```

---

## 6.7. 概念の高度 — YAGNI は「機構」を縛るのであって「意味」を縛らない

§6.5 の「module より下は既定で柔軟」「予期的分割は YAGNI 違反」には既知の誤読がある。
**「最初の消費者しかいない概念は、その消費者専用に作ってよい」という誤読**である。

例：RPG で「階段」をダンジョン機能が最初に必要とした。エージェントは YAGNI を理由に
`DungeonStairs`（ダンジョン型に依存し、契約も無い）として実装した。だが「階段」の責務は
「作動時にアクターを接続された場所間で移動させる」であり、この一文に「ダンジョン」は現れない。
つまり**概念の意味の高度は feature より上**にあり、ダンジョンは最初の消費者にすぎない。

```yaml
principle: "概念はその意味の高度に置く。最初の呼び出し側は消費者であって所有者ではない。"
test: "その単位の責務を一文で述べる。文に feature 名が不要なら、概念は feature より汎用。"
yagni_bounds: "YAGNI が禁じるのは投機的な機構（使われない interface・余分な継ぎ目・早すぎる共有モジュール抽出）。概念の意味を消費者で汚染しないことは機構ではなく、YAGNI の適用対象外。"
apply:
  neutral_model: "概念は『それが何であるか』で命名・型付けする。契約・型は消費 feature の型に依存しない。"
  feature_policy: "feature 固有の差分は、概念の契約の実装・合成・パラメータとして feature 側が所有する。"
  placement_may_wait: "中立な概念が物理的に最初の消費者 module 内に居るのは可（Rule of Two/Three までは共有先へ抽出しない）。YAGNI が縛るのは置き場所と機構の量であって、意味の中立性ではない。"
asymmetry: "作成時に中立を保つのはほぼ無料（命名＋feature 型を import しないだけ）。後から汚染を除くのは高い（参照と semantics が拡散済み）。§6.5 の訂正コスト非対称と同型。"
independent_axes: "概念の高度（意味がどの層に属するか）と硬化深度（どこまで契約を強制するか, §6.5）は独立の軸。中立にモデル化しても地平線は下がらず、機構も増えない。"
```

---

## 7. 内部の自由は、境界面の完全性で買う（双対）

「内部はその内部自身の責任、好きにしてよい」は正しい。ただし
**内部の自由度と境界面の契約完全性は双対(dual)である。**

内部で暴れるほど**漏れる経路が増える**。署名(Signature)を守っても、次のチャネルから漏れる：

```yaml
leakage_channels:
  signature:    "型・引数・戻り値"
  semantics:    "値の正しさ・順序・冪等性（並列化で実行ごとに違う経路を返す等）"
  resource:     "CPU・メモリ・コネクションプール・実行時間上限の食い潰し（共有資源は契約に現れない隠れチャネル）"
  failure:      "タイムアウト無し・リトライ嵐・例外の伝播・共有可変状態の破壊"
  determinism:  "非決定性が呼び出し側の安定性仮定を壊す"
  data:         "永続データの内部不変条件の破壊（コードより長生きし、後から読む全員を汚染する）"
```

> **内部を奔放にしたいなら、境界面はその分だけ semantics・resource・failure・determinism・data まで
> “閉じ切った”契約でなければならない。**
> 雑な契約 ＋ 奔放な内部 ＝ 漏洩。
> 完全な契約 ＋ 奔放な内部 ＝ 堅牢 × 柔軟。
> 「内部は自分の責任」が真になるのは、**境界面が全漏洩チャネルを閉じている時だけ**であり、
> そうでなければそれは alibi（言い訳）にすぎない。

**内部の自由の対価は、境界面の厳密さである。**

---

## 8. 動的性 — 責務が割れたら地平線を引き直す

ドメインは成熟し変化する。ある「機能のまとまり」が**一つの責務でなくなった**とき、地平線を引き直す。

例：経路探索が成熟し、「グリッド表現」「探索アルゴリズム」「ヒューリスティック計算」が
それぞれ独立した責務に分かれ始めたら、**責務ごとに「機能のまとまり」へ分割**する。

```yaml
trigger_is_reactive:
  rule: "責務の記述に AND が現れた瞬間に割る（『グリッド計算 AND 探索 AND ヒューリスティック』）"
  do_not: "予期して先に割らない。予測的分割は over-modularization の再来であり YAGNI 違反"
  meaning: "SRP は作成時の一度きりの判断ではなく、時間軸上で再評価され続ける地平線である"

this_is_fractal_reactivating_inside:
  note: "内部の下位構造が内部地平線(inner horizon)へ昇格する。フラクタルが内側で再起動する瞬間"

ideal_split_preserves_outer_surface:
  rule: "理想の分割は外面(outer surface)を固定したまま内面(inner horizons)を足す"
  caller_view: "呼び出し側は依然『経路をくれ』と言うだけ"
  red_flag: "成熟分割が外側の契約を壊すなら、元の責務の引き方が間違っていたサイン"
```

### AND テストの精緻化 — AND は警告であって分割命令ではない

```yaml
and_is_a_warning: "AND の出現は注意信号。自動的な分割命令ではない。"
subordinate_and:
  example: "経路を返すには、候補を評価し AND コストを計算し AND 経路を再構成する。"
  verdict: "上位の一意味（pathfinding）に従属する内部ステップ → まとめて保持。継ぎ目が安く独立変更圧が観測されたときのみ割る。"
peer_level_and:
  example: "経路を返す AND 課金する AND 通知する。"
  verdict: "別 actor / policy / lifecycle / 変更理由を持つ peer-level の意味 → 割る、または内部地平線を立てる。"
rule: "AND が現れたから割るのではない。peer-level の意味を一つの呼び出し側整合責務に従属させられない ときに割る。"
```

---

## 9. コスト — 昇格は「内部自由の負債」の支払い日

§7 と §8 は接続する。内部を奔放にしてよいのは**昇格(graduation)が起きるまで**である。

下位責務が硬い境界へ graduate するとき、その面（semantics/resource/failure/…）を
**後付けで**、しかも奔放に育った内部に対して建てねばならない。

```yaml
cost_model:
  internal_freedom: "graduation までは安い"
  settlement_day:   "graduation で精算される（内部に対して契約面を遡って建てる）"
  implication: "長命な『機能のまとまり』では支払い日が来ることを前提に内部の放任度を決める（放任 ⇔ 将来の昇格コストのトレード）"
```

封じ込めは内部腐敗を**安全**にするが**無料**にはしない。封じ込めは*繰り延べ*であって帳消しではない。

---

## 10. まとめ（一文）

> 硬化の単位は **「一つの呼び出し側に整合した責務を負う『機能のまとまり』」**。
> その**外面を、責務が安定し継ぎ目が安いときに**固め、内部は柔軟に保つ。
> 内部の放任度は、外面が全漏洩チャネル（signature/semantics/resource/failure/determinism/data）を
> 閉じている度合いで買う。
> 責務が割れた（AND が出た）ら地平線を引き直し、内部の下位責務を硬い「機能のまとまり」へ昇格させる
> ——理想は**外面を保ったまま内面を足す**。そして内部放任の対価は、昇格時にまとめて払う。

これは SRP・カプセル化・フラクタルを一枚に畳んだ**動的原理**である。
「module で割る」ではなく「**責務 altitude で地平線を選び、安定 × 継ぎ目コストで硬化を判断し、
AND の出現で再分割する（外面保持）**」。

適用は**マクロ→ミクロに降下し、各層の公開面を既定で硬化**（内部は既定で柔軟）。降下の**初期停止深度は module（floor でなく prior）**で、
**成熟度に応じて地平線が動く**。早期は module より下へ降りない（過剰硬化＝本来柔軟であるべきミクロまで固めること、を避ける）。

---

## 11. artifacts との対応（この原本が出典である運用版）

本書の各部は、artifacts では以下に**圧縮符号化**されている。artifacts 単独では「なぜ」が落ちるため、
意図の確認は常に本書へ戻ること。

| 本書の節 | 対応する artifact |
| :--- | :--- |
| §1 境界面は固く内部は柔軟 | `DESIGN_PHILOSOPHY.md` → Redefining OOP（Shell vs Core Logic） |
| §2 フラクタル | `DESIGN_PHILOSOPHY.md` → Boundaries Are Recursive (Scale-Invariant) |
| §4–5 地平線・コスト非対称 | `DESIGN_PHILOSOPHY.md` → Module Shell vs Internal / `accuracy_vs_speed`；`PROJECT_STRUCTURE.md` |
| §5 責務＝機能のまとまり | `DESIGN_PHILOSOPHY.md` → Responsibility-Driven Design (SRP) |
| §6 硬化の条件・YAGNI | `CODING_STANDARDS.md` → Interface Requirement Threshold |
| §6.5 探索方向・既定・初期地平線 | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon（direction / default-harden / module=prior / maturity）；`AI_WORKFLOW.md` → Pre-Implementation Scan #1（Module Shell & Horizon） |
| §7 完全な契約・漏洩チャネル | `DESIGN_PHILOSOPHY.md` → Bounded Contracts / Module Shell の `leakage_channels`＋`duality`；`CODING_STANDARDS.md` → Interface Documentation（Semantics に resource/determinism を宣言）, Error/Concurrency 契約 |
| §8 AND テスト・再分割 | `DESIGN_PHILOSOPHY.md` → SRP validation（"AND" appears → split）, Encapsulation Horizon（`re_draw_reactively`） |
| §8 外面保持 | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon（`preserve_outer_surface`）；`CODING_STANDARDS.md` → Contract Evolution（`internal_split`） |
| §9 昇格コスト | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon（`graduation_cost`） |
| §5 意味の束 | （原本のみ。artifacts には持ち込まず症状で操作） |
| §6.6 決定表 | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon の split/seam-cost cue（圧縮）；`CODING_STANDARDS.md` |
| §6.7 概念の高度 | `DESIGN_PHILOSOPHY.md` → Concept Altitude；`CODING_STANDARDS.md` → Concept Generality；`AI_WORKFLOW.md` → Pre-Implementation Scan #3 |
| §8 AND 精緻化 | `DESIGN_PHILOSOPHY.md` → SRP validation（Refined AND） |
| §13.1 誤読防止 | `DESIGN_PHILOSOPHY.md` → Common Misreadings to Prevent |
| §13.2 module 四義 | `AI_WORKFLOW.md` → Pre-Implementation Scan（module 解決） |
| §13.3 確認段階 | `AI_WORKFLOW.md` → Contract Confirmation Gate（L0–L3） |

> 注：`module` は artifacts では「主境界(primary boundary)」として既定値扱い。本書の §5 が示すとおり
> それは**既定値であって原理の床ではない**。artifacts がそこを定数のように書いている箇所は、
> 本書の動的地平線で上書き解釈する。

---

## 12. 用語集

```yaml
Encapsulation Horizon: "硬化（固い契約の強制）を打ち切る高さ。これより外/この面は固く、内側は単一の柔軟ゾーン"
機能のまとまり: "一つの責務のもとに集まった単位。基体中立（関数〜サービスのいずれにもなれる）。本書が module の代わりに使う語"
責務 (responsibility): "一つの変更理由(reason to change)かつ呼び出し側に整合した一貫能力。入れ子(nested)で altitude 相対"
硬化 (hardening): "境界面を固い契約として固定すること。全漏洩チャネルを閉じる行為を含む"
昇格 (graduation): "内部の下位責務が独立した硬い『機能のまとまり』へ繰り上がること"
漏洩チャネル: "契約をすり抜けて内部が外へ影響する経路（signature/semantics/resource/failure/determinism/data）"
descriptive/prescriptive: "フラクタルは適用可能性の記述、地平線は強制範囲の規範。両者を分けて持つ"
探索方向 (macro→micro): "最外面から内へ降下して硬化を決める。逆(micro→macro)の積み上げではない"
harden-by-default: "各層の*公開面*を既定で硬化（≠ interface を全部作る）。地平線より内側は既定で柔軟。深さとともに柔軟既定へ反転"
初期地平線 (module=prior): "降下の既定停止深度の初期値。floor ではなく成熟度で動く prior"
意味の束 (meaning bundle): "責務の根。ある高度・呼び出し側から見て単位が存在する理由。reason-to-change と caller-coherence はその*観測可能な症状*（操作はこちら）"
peer-level AND / subordinate AND: "AND が peer-level の意味（別 actor/policy/lifecycle）なら割る。上位の一意味に従属するステップなら割らない"
confirmation level (L0–L3): "変更リスクの段階。内部=進行／局所契約=進行+報告／公開追加=含意あれば進行+明示／破壊・副作用=要確認"
module の四義: "semantic（責務）／code（package等）／deployable（実行体）／hardening-horizon（今 契約境界として扱う単位）。操作前に解決する"
概念の高度 (concept altitude): "概念の意味が属する層。硬化深度とは独立の軸。最初の消費者は所有者ではない（§6.7）"
```

---

## 13. 運用ガード（誤読防止・module 解決・確認段階）

### 13.1 誤読防止リスト（Common Misreadings to Prevent）

```yaml
misreadings:
  - "『公開面を既定で硬化』＝ interface を全部作る、ではない（地平線より内側は既定で柔軟）"
  - "AND が出た ＝ 常に分割、ではない（従属ステップは保持。§8）"
  - "Domain purity ＝ Date/Color/Text を Domain に置くな、ではない（出自で判定。概念なら可）"
  - "one public surface ＝ 巨大ファサード一つ、ではない（audience 別の named/governed 面は可）"
  - "UseCase は技術に触れるな、ではない（調停は可・*所有*は不可）"
  - "契約ドキュメント ＝ どこにでも冗長コメント、ではない（load-bearing な意味だけ）"
  - "module ＝ フォルダ、ではない（四義を解決せよ。§13.2）"
  - "Result ＝ 例外を投げるな、ではない（期待される業務失敗が Result。システム障害は throw 可）"
  - "内部の柔軟 ＝ 内部は雑でよい、ではない（外面が全漏洩チャネルを閉じている前提。§7）"
  - "public contract ＝ メソッド署名だけ、ではない（Semantics+Constraints+副作用+失敗+資源+決定性+データ）"
  - "YAGNI／module より下は柔軟 ＝ 汎用概念を feature 専用に作ってよい、ではない（YAGNI は機構と置き場所を縛る。意味の中立性は縛らない。§6.7）"
```

### 13.2 module の四義（操作前に解決）

```yaml
module_resolution:
  semantic_module: "責務 / 機能 / 機能領域"
  code_module: "package / namespace / folder / assembly / crate"
  deployment_module: "実行体：app / service / worker / frontend"
  hardening_horizon: "今 安定契約境界として扱っている単位"
ask_first: "このタスクの『module』は semantic か physical か deployable か、今の硬化地平線か？"
```

### 13.3 確認段階（severity）の根拠

二値の確認ゲートは過剰ブロックになる。L0–L3 で AI の自律性と安全性を両立させる（運用表は `artifacts/AI_WORKFLOW.md` → Contract Confirmation Gate）。

```yaml
levels:
  L0_internal: "private/refactor/test/doc → 進行"
  L1_local_contract: "module-local interface / 内部 port / 非公開 DTO → 進行＋報告"
  L2_public_additive: "新公開メソッド / optional フィールド / 要求機能に要る endpoint → タスクに明確に含意されれば進行＋明示報告"
  L3_breaking_or_side_effect: "破壊的変更 / 公開 semantics 変更 / 破壊的操作 / 新規外部副作用 / 永続データ移行 → 事前確認必須"
```
