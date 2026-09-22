# ドキュメント — 保守とレビュー

documentの削除、再読、構造変更時のdocumentation固有の確認境界を扱う。

## 削除

documentを削除できる代表条件:

- 内容が廃止され、現在のprojectを説明しない。
- 別documentへ責務が統合され、旧fileを残すとauthorityが曖昧になる。
- ユーザーまたはproject規則が明示的に削除を求める。

削除時:

1. Project Documentation内で参照元を確認する。
2. link / routing entryを更新する。
3. 必要なknowledgeが別authorityへ移っていることを確認する。
4. fileを削除する。
5. Git historyへ削除理由が残る形でcommitする。

独自archive directoryやdocument version registryを削除のためだけに作らない。過去内容はGit historyから参照できる。

## 再読条件

```yaml
must_re_read:
  - "このdocumentation strategyを使うprojectへの初回接触"
  - "Project Documentation全体を新設または再構築する"
  - "brownfieldへstrategyを導入する"
  - "routing / authority modelそのものを変更する"
should_re_read:
  - "大規模なfile移動・rename"
  - "hierarchical / multi-repository documentation構造を変更する"
  - "情報のauthorityが不明"
no_re_read_needed:
  - "既存authority内の日常的な内容更新"
  - "確立済みroutingに従う局所追加"
```

## Documentation Change Level

このlevelは**documentation構造変更だけ**を分類する。開発操作の破壊性は `../development-safety/S005_CONFIRMATION_AND_REREAD.md`、code contract変更は `../encapsulation-horizon/S008_OPERATIONAL_GUARDS.md` の別軸である。

```yaml
DOC_L0_content:
  意味: "既存authority内の内容更新。routing/ownership変更なし"
  対応: "進める"

DOC_L1_additive:
  意味: "既存構造へ新規documentまたはcross referenceを追加"
  対応: "進めて報告"

DOC_L2_structural:
  意味: "file移動、rename、routing変更、authority移管、通常document削除"
  対応: "依頼から明確に必要な場合に進め、明示報告"

DOC_L3_model_change:
  意味: "Project Documentation全体の再構築、core routing/authority modelの変更"
  対応: "明示的な変更要求なしに実施しない"
```

同じ作業がhost変更・data破棄・public contract変更を伴う場合、それぞれのsubjectのlevelも独立に評価する。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
