# Encapsulation Horizon — Hardening Policy

どの責務を、いつ、どの方向から硬化するか。stability / seam cost / macro→micro / harden-by-default / module=prior / maturity / split decisionを扱う。

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
