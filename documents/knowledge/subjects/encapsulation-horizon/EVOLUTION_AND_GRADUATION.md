# Encapsulation Horizon — Evolution and Graduation

責務の成熟、AND test、inner horizonへのgraduation、outer surface維持、内部自由の将来costを扱う。

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
