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

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
