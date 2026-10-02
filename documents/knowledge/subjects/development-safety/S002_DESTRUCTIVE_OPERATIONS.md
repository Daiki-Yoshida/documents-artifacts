# 開発安全性 — 破壊的操作

通常操作と破壊的操作の境界、対象範囲、明示性、global destructive operationを日常workflowへ混ぜない原則を扱う。

## 5. 破壊的操作

```yaml
通常操作:
  性質: "source変更と永続dataを保持する"
破壊的操作:
  性質: "source変更、commit、volume、DB、cache、remote状態を失う可能性がある"
  必須:
    - "明示的な名前"
    - "狭い対象範囲"
    - "事前条件確認"
    - "削除内容の報告"
```

- global Docker pruneのようなhost全体操作を通常project lifecycleへ入れない。
- cleanup対象は決定的なProject / Work identityで限定する。
- DB reset、volume削除、worktree強制削除、remote deploy破棄を曖昧な `clean` にまとめない。

Project / Work / Runのownershipとlifecycleは `../work-identity/` が所有する。このsubjectは、それらを削除・破棄するoperationの安全条件を所有する。

## Directory selectorは破壊権限ではない

public commandが `DIR=<path>` のようなExecution Target Directory selectorを持つ場合も、directory pathを指定できること自体は、そのdirectoryに対する破壊操作のauthorizationを意味しない。

特にdelete / reset / purge / force等では、

- `DIR` だけからProject / Work / repository identityを推測して削除対象を決めない。
- symlink / canonical pathがscope判定へ影響する場合は、解決後の対象を検証する。
- Project Root外やabsolute pathを受け取るoperationは、projectが明示的にsupportしている場合に限る方向をdefaultとする。
- 既存のownership、identity、precondition、confirmation boundaryを通す。
- routine execution向けのdirectory selectorを、force cleanup用の万能target指定へ拡張しない。

`DIR` のgeneric execution semanticsは `../development-execution/S003_COMMAND_INTERFACE_AND_CI.md` が所有する。このsubjectは、そのselectorが破壊操作の安全条件を短絡しないことを所有する。

## Sources

- `../../records/2026-10-03-project-root-execution-routing/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
