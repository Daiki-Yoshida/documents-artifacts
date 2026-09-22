# ドキュメント — 導入と更新ワークフロー

新規project、brownfield、継続的更新、Work completion時のreconciliationという主要documentation workflowを扱う。

## ユースケース

```yaml
1_new_project: "新規projectへdocumentation routingを導入する"
2_existing_project: "brownfieldの既存documentationを保全しながら整合する"
3_ongoing_updates: "意味変更に応じて継続更新する"
4_work_reconciliation: "Work Documentsから恒久knowledgeをProject Documentationへ統合する"
```

## ユースケース1: 新規プロジェクトセットアップ

1. `../workspace-structure/` またはproject固有規則からProject Root / repository構成を確認する。
2. 既存のdocumentation conventionがあれば再利用する。
3. Project Documentationのrouting entryを用意する。
4. 現時点で必要なproject-level / reference / topic documentだけを作る。
5. agent entryを使う場合はProject Documentationへroutingする。
6. 空directoryや将来用documentを投機的に量産しない。

固定の `documents/project/` / `documents/reference/` / `docs-jp/` 構成を導入条件にはしない。

## ユースケース2: 既存プロジェクト導入（ブラウンフィールド）

既存documentationを先に監査し、内容を次の観点で把握する。

```yaml
audit:
  - "何を説明しているか"
  - "誰が読むか"
  - "現在も正確か"
  - "どのdocumentがauthorityか"
  - "routingが成立しているか"
  - "重複が矛盾を生んでいないか"
```

構造移行と内容改善を無条件に同時実施しない。

- 既存local conventionが明確で有効なら尊重する。
- file移動・rename時はcross referenceを更新する。
- obsolete情報を削除する場合は `S004_MAINTENANCE_AND_REVIEW.md` に従う。
- document version / commit registryを新規導入しない。
- 移行のためだけにaudience別directoryを強制しない。

## ユースケース3: 継続的ドキュメント更新

documentationはcalendarではなく、**意味が変わったとき**に更新する。

代表trigger:

- architecture / contract / constraintの変更
- workflow / operationの変更
- public interfaceや重要なbehaviorの変更
- routing先やfile ownershipの変更
- 古い説明を発見したとき

更新時:

1. 主authorityを特定する。
2. そのdocumentを更新する。
3. 関連する局所再述・cross referenceも必要なら更新する。
4. file追加・移動・削除時はrouting entryを更新する。
5. Git diff / historyと実装を照合して正確性を確認する。

`last_updated_commit` のようなdocument-local metadataだけでstalenessを判定しない。

## Work Documents reconciliation

Work Identityの完了時、`../work-identity/S003_WORK_DOCUMENTS.md` に従ってWork Documentsをreconcileする。

```text
Work Documents
    ↓
恒久knowledgeとして必要か
    ├─ yes → Project Documentation内の主authorityへ統合
    └─ no  → Work completion時に削除可能
```

採用されなかった案や検証途中の情報をProject Documentationへ機械的に全コピーしない。一方、将来の判断に必要な反論・制約・検証結果は失わない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
