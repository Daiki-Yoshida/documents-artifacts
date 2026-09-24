# Encapsulation Horizon — Contract Completeness

内部自由と境界contract完全性の双対、signature以外のleakage channel、内部自由の成立条件を扱う。

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

### Small surface, strong contract

境界を厳密にすることは、公開能力を無制限に増やすことではない。
**surfaceは必要最小限に保ち、そのsurfaceで約束した意味は強く閉じる。**

```yaml
small_surface:
  rule: "現在の責務から導出されないfuture capabilityやextension pointを公開しない"
strong_contract:
  rule: "選択済みsurfaceでは、既知のsemantics / constraints / failure / resource / determinism / dataを必要な範囲で閉じる"
yagni:
  allowed: "surface breadthと内部の投機的機構を削る"
  not_allowed: "既知のcontract completenessを、creation costが高い・今のconsumerが使わないという理由だけで削る"
```

contract completenessへ投資するほど、その内側はcontractを守る限り自由に交換できる。
したがって**外側を厳密にすることと、内側でYAGNIを強く使うことは矛盾せず、相互に成立条件を与える。**

### Strong contract は explicit であり maximally restrictive ではない（2026-09-24 追加）

「strong contract」は**必要な意味・制約を明示的に閉じる**ことであり、
**現在の実装が偶発的に持つobservable propertyを最大限にpublic guaranteeへ昇格することではない。**

```yaml
guarantee_promotion:
  rule: "次のいずれにも該当しないimplementation propertyをpublic guaranteeへ自動昇格させない"
  promote_only_if:
    - "selected responsibilityから導出される"
    - "user / product requirementとしてload-bearingである"
    - "callerが安定保証として依存すべき性質である"
  incidental_examples:
    - "shortestness"
    - "deterministic tie-breaking"
    - "ordering"
    - "complexity"
    - "caching behavior"
  note: "これらはalgorithm choiceから偶発的に生じる性質であり、要求または責務上必要でない限りinternal freedomを狭めるcontractへしない"
```

逆方向も同じである。これらの性質が既にcaller-visible requirementとして必要なら、当然contract completenessとして明示する。
「保証すべき場合は保証する。しかしcurrent implementation propertyであるだけでは保証へ昇格しない」がこのruleの要点であり、shortestnessやdeterminismを一般に禁止する規範ではない。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
- `../../records/2026-09-24-yagni-encapsulation-horizon-decision/RECORD.md`
- `../../records/2026-09-24-strong-contract-explicit-not-maximal/RECORD.md`
