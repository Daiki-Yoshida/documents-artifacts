# Short Approval Provenance Audit — 2026-09-24

```yaml
document_type: "repository_local_audit"
authority: "derived_evidence_not_a_new_source_record"
scope: "Issue #30"
baseline_commit: "fc2af723d0c49236cca208697a96c84ff7b9f13f"
audit_date: "2026-09-24"
```

## 問題と証拠の強さ

短文のユーザー指示が `records/` に原文保存されていても、その指示が指した**直前のAI提案原文**まで保存・検証できるとは限らない。今回GitHub上のPR本文を第0情報源として別record化したが、これらは**後続の実装説明**であり、チャットのAI提案全文と同一とは証明できない。

この監査表はユーザー原文、過去recordに含まれる承認対象の記述、GitHub側の後続実装証拠、未取得原文を混同せず追跡するための補助。過去record本文は後から追記・言い換えしない。

## 主な短文承認と関連資料

| 保存済みユーザー原文record | 後続のGitHub実装説明record | 現在検証できること | 引き続き不足するもの |
|---|---|---|---|
| [knowledge-only-phase](../../knowledge/records/2026-09-21-knowledge-only-phase/RECORD.md)「行っていく。…knowledge のみ…」 | [PR #23](../../knowledge/records/2026-09-21-knowledge-source-model-implementation/RECORD.md)、[PR #24](../../knowledge/records/2026-09-21-knowledge-system-subjects-implementation/RECORD.md) | ユーザーがknowledge優先を明示。後続PRがknowledge-first構造の導入を記述 | 関連する直前AI提案全文は未取得 |
| [knowledge-structure-implementation](../../knowledge/records/2026-09-21-knowledge-structure-implementation/RECORD.md)「いいですね。一旦その形で実装してほしい。」 | [PR #24](../../knowledge/records/2026-09-21-knowledge-system-subjects-implementation/RECORD.md) | 構造再編の実装内容を後続PR本文から追跡可能 | 「その形」に該当するAI提案の完全原文は未取得 |
| [work-identity-subject-rebuild](../../knowledge/records/2026-09-21-work-identity-subject-rebuild/RECORD.md)「おｋ。作り直していこう」 | [PR #24](../../knowledge/records/2026-09-21-knowledge-system-subjects-implementation/RECORD.md) | Work Identity subject-native再編の後続内容を確認 | 再編の直前AI提案全文は未取得 |
| [encapsulation-horizon-subject-rebuild](../../knowledge/records/2026-09-21-encapsulation-horizon-subject-rebuild/RECORD.md)「一旦 sbjects 作成して…」 | [PR #24](../../knowledge/records/2026-09-21-knowledge-system-subjects-implementation/RECORD.md) | 原文で作成指示、PRで作成・再編結果を確認 | 直前AI提案全文は未取得 |
| [subject-section-prefix](../../knowledge/records/2026-09-21-subject-section-prefix/RECORD.md)「一旦それやってほしい」 | [PR #25](../../knowledge/records/2026-09-21-subject-prefix-implementation/RECORD.md) | ユーザー原文自身が`S001_CORE_PRINCIPLE.md`例を示し、PRが導入範囲・規則を説明 | `SNNN_`の詳細仕様に至る直前提案全文は未取得 |
| [add-more-subjects](../../knowledge/records/2026-09-22-add-more-subjects/RECORD.md)「ほかのsubjectsも作成していこう」 | [PR #26](../../knowledge/records/2026-09-21-development-documentation-subjects-implementation/RECORD.md) | 追加指示と後続のdocumentation / development-environment作成が確認可能 | 具体的に何を含めるかの直前AI提案原文は未取得 |
| [development-environment-subject-split](../../knowledge/records/2026-09-22-development-environment-subject-split/RECORD.md)「行っていく。」 | [PR #27](../../knowledge/records/2026-09-21-development-subject-split-implementation/RECORD.md) | 同一record内にユーザーの分割意見原文も保存。PRが実装した責務分解を説明 | その間のAIによる分割提案の完全原文は未取得 |
| [workspace-work-identity-alignment](../../knowledge/records/2026-09-22-workspace-work-identity-alignment/RECORD.md)「修正を行って」 | [PR #27](../../knowledge/records/2026-09-21-development-subject-split-implementation/RECORD.md)、[conversation transition context](../../knowledge/records/2026-09-22-workspace-work-identity-transition-context/RECORD.md) | 旧recordの承認対象テキストに加え、当時作成されたLibraryのcontext移行artifactがworkspace/work-identity監査の問題1〜4・推奨修正・作業方針を詳細に保持する | transition artifactは元チャット直前assistantメッセージそのものとは証明できない。逐語的approval referentの完全復元は未完了 |
| [six-subject-cross-audit-fixes](../../knowledge/records/2026-09-22-six-subject-cross-audit-fixes/RECORD.md)「修正して」 | [PR #28](../../knowledge/records/2026-09-22-six-subject-cross-audit-implementation/RECORD.md) | 後続PRには実施した横断監査修正とレビュー時の追加修正が記録されている | 指示直前のAI監査・修正提案の完全原文は未取得。PRでの後続レビュー内容を承認対象へ遡及させない |
| [knowledge-integrity-repair](../../knowledge/records/2026-09-24-knowledge-integrity-repair/RECORD.md)「修正を開始。」 | [PR #31](../../knowledge/records/2026-09-23-knowledge-integrity-implementation/RECORD.md) | 後続PRに実施内容・レビューによる追加修正が記録されている | 指示直前のAI調査本文とPR本文の同一性は未検証 |

上記の関連付けは**話題と時間順に基づく調査用のリンク**であり、PR本文を「AIが直前に提案した原文」として認定するものではない。PRは作成後・レビュー後に更新されるため、取得時点の本文とPR作成当初の本文すら同一とは限らない。

## Library conversation artifactの追加回収

2026-09-22 08:28 JST頃に作成されたChatGPT Library writing blockを取得し、[workspace/work-identity transition context](../../knowledge/records/2026-09-22-workspace-work-identity-transition-context/RECORD.md) として788行の本文を無要約・無抜粋で保存した。

このartifactには、PR #27の作業中contextとして次が詳細に含まれる。

- development-environmentをworkspace-structure / development-execution / development-safetyへ分割し、work-identityを維持する責務整理
- workspace-structure / work-identityのstatic / dynamic境界
- `.worktrees/` path矛盾
- `.worktrees/` tracking / ignore矛盾
- 旧Task Worktreeのhistory化
- Workspace Repository / Project Repository / Project Rootの接続
- REPO selector ownership
- PR #27へ行う具体的修正案
- artifactsを明示指示なしに変更しない作業方針

これは**会話由来の保存artifact**として、GitHub PR本文より承認前contextに近い証拠である。一方、Library writing blockが「修正を行って」の直前assistantメッセージそのものをbyte-for-byte保存したものとは証明できない。そのため、Issue #30の「直前AI提案原文を取得」という完了条件を満たしたとは扱わない。

## 今回保存したGitHub sourceの範囲

[GitHub PR #23](../../knowledge/records/2026-09-21-knowledge-source-model-implementation/RECORD.md)、[#24](../../knowledge/records/2026-09-21-knowledge-system-subjects-implementation/RECORD.md)、[#25](../../knowledge/records/2026-09-21-subject-prefix-implementation/RECORD.md)、[#26](../../knowledge/records/2026-09-21-development-documentation-subjects-implementation/RECORD.md)、[#27](../../knowledge/records/2026-09-21-development-subject-split-implementation/RECORD.md)、[#28](../../knowledge/records/2026-09-22-six-subject-cross-audit-implementation/RECORD.md)、[#31](../../knowledge/records/2026-09-23-knowledge-integrity-implementation/RECORD.md) の**現存PR本文全文**を、それぞれprovenanceとともに `records/` に取得保存した。

各snapshotのmetadataはGitHub APIのcreated/updated時刻と取得日を区別する。元チャットの正確なテキストが見つかった場合は、後から過去recordを「もっともらしく」書き換えるのではなく、別の原文recordとして保存して関係付ける。

## 次の取得境界

元チャットの原文について、今回参照可能なGitHub Issue・PR・現存recordsからは、上表の直前AI提案全文を確認できなかった。Issue #30の完全完了判定は保留し、元チャットの直接エクスポート等の検証可能な第0情報源が得られた場合だけ、取得できたsource eventを無加工でrecord化する。

本文を取得できないままGitHub実装説明からAI提案を再構成したものを「原文」として保存してはならない。
