## Phase B — Work Identityと実装対象の確定（2026-10-14）

ユーザーから「行っていこう。WorkIdentity はあなたが決めていいよ。」と実装への進行およびWork Identity選定の委任を受領した。

**選定Work Identity:** `refactor/generic-dir-command-routing`

対象はIssue #209のPhase Aレビュー（[comment](https://github.com/Daiki-Yoshida/documents-artifacts/issues/209#issuecomment-6164942185)）に沿う、generic `DIR` の公開入力規約と、worktree/Docker等のcommand-owned target interpretationとの整合。

進め方:
1. 既存のsource BundleはDraft PR #210の独立した4ファイルとして保持し、意味内容をretroactively変更しない。
2. 新規のWork実装判断・原文は新Recordで保存し、`development-execution/S003`、`work-identity/S006` の現行正本を更新する。安全・所有権・Docker identityの既存規約を維持する。
3. `artifacts/execution/COMMANDS_AND_CI.md` と `artifacts/project/WORKTREES.md` をtask routing向けに投影する。
4. `DIR` のcmd固有解釈、Work Root→Docker scope、Repo-specific path→Worktree identity、create-existing区別、unauthorized/out-of-scope/ambiguous target、up/down同一identityに焦点を当てたdeterministic fixtureを追加・検証する。
5. Draft PR #210をsource-onlyとして残し、そのHEADを土台に**別のWork実装ブランチ/PR**で変更を隔離する。GitHub上でmainへのmergeやtarget Projectへのsyncはこの段階で行わない。

環境に完全なrepository checkoutがなくshell suiteを実行できない場合、その点を正確に記録し、実行できた検証と未実行を区別する。GitHub Actions、外部有料CI、新規ホスト依存は使用しない。

この記録はWork Identity選定と実装スコープの宣言であり、原文記録と最終的な正本改定を混同しない。