# Encapsulation Horizon — Glossary

Encapsulation Horizon subjectで使う用語と、その意味を扱う。

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
