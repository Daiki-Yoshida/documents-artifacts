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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
