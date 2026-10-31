# Purpose

Artifact v2に既存する規範を **規則単位** で分類し、AIが「推奨だからWork Identityそのものを採用しない」と解釈する余地をなくすための **NormLevel（NL）設計・初期棚卸し**。

> Ownerの方向性（2026-10-31、Chat内・個別メッセージURL未取得）：
> 「L1~L3概念みたいに　文字＋数字での重要度の方が管理しやすいかも。1文字である必要はない。　重要度1とかそんな感じの単語＋数字で管理したいな」
>
> 「導入していこう。まずは現状のartifactsの各要素のNLを定義したいね」

## Snapshot / scope

- Repository: `Daiki-Yoshida/documents-artifacts`
- Examined main: `960c3682fe9172b90b60d05c22078eb1cafc0df1`
- Artifact Markdown: **42 files**, including root INDEX + seven directory INDEX files (**8 routers**) and **34 normative leaves**.
- 7 domain-by-domain candidate inventories will be appended as individual Issue comments. **Proposed classification, not yet enacted canonical authority.**
- Classification unit: individual normative decision, constraint, default, project-defined value — not whole file, not every explanatory sentence.
- No artifact/subject/record/source file mutations in this phase. Do not label candidate NLs as already adopted or validated.

## Proposed NL semantics

| Code | Meaning | Behavior |
|---|---|---|
| `NormLevel3` / `NL3` | Required | Must satisfy an applicable rule/contract; AI may not casually skip it. Its applicability condition remains explicit. |
| `NormLevel2` / `NL2` | Recommended | Default preference; a task/project-grounded alternative can be selected with explanation when necessary. |
| `NormLevel1` / `NL1` | Project Defined | Selection of a specific implementation value/topology/tool/policy is owned by the target project; once selected, its actual binding force is provided by project-local authority. |

**NL is normative obligation/delegation, not safety/change impact level.** DOC_Lx, SAFETY_Lx and contract Lx classify *impact/confirmation*, not NL. `NL1` does not mean "unimportant" or "ignore". Explanations, examples and router entries do not automatically become distinct normative rules.

A rule's working form is `level + applicability + required meaning`. Separate the NL3 need to have an identity/owner/contract from NL1 freedom to choose names/frameworks/strategies.

## Owner decision candidates (not silently applied)

1. **Work Identity universal adoption:** Promote Work Identity to `NL3` for concrete implementation efforts in projects adopting the Artifact pack, including new project/new chat continuation. Reuse an existing Work Identity; new identities use the owner confirmation gate; exploratory discussion remains outside that trigger. This changes current `when a project uses the Work Identity model` scope in `artifacts/operation/CHANGE_LIFECYCLE.md` and its canonical subject.
2. **Separate mechanisms:** Having a Work Identity must not automatically create a Git branch, linked worktree, container, DB, or duplicate Project-Scoped resources. Need/ownership contracts remain binding; the materialization choices have their own levels.
3. **Local authority vs NL3:** Distinguish project-local *specialization* from intentional Owner-approved *exception/rejection*. Do not silently bypass a required common contract because a local practice is merely absent; do not assume the pack overrides an explicit Owner decision. Resolve this precedence before changing the current "reusable guidance is a default" sentence.
4. **Adoption/entry:** Decide when an installed Artifact pack is mandatory to read versus merely linked by the project-owned entry hook. Do not automatically equate a missing hook with explicit opt-out.
5. **NL wording vs amount:** Do not multiply NAL-oriented prohibitions or duplicate NL metadata into all router/leaf files. Prefer one authoritative definition with task-relevant projection and focused validation.

## Planned classification review criteria

- Match current effective canonical source, not only imperative wording in runtime Artifact.
- Keep required safety, ownership, semantic contracts, preconditions, exceptions and existing decision lineage.
- Mark genuinely new obligations and ambiguous classifications for Owner review.
- Distinguish a preferred mechanism (`NL2`), a concrete project choice (`NL1`), and an invariant that holds *after that mechanism is chosen* (`NL3`).
- Use positive-first wording. Preserve negative guards only where a realistic failure would otherwise recur.
- After approval: preserve this decision as a new immutable source record; resolve owner subjects + projection; review 36 existing agent scenarios for impact; measure real fresh-agent behavior (do not treat static routing or a Git smoke alone as an AI behavior PASS).

## Exclusions

No universal forced creation of Worktrees, Docker resources, extra layer/classes, registries, or "one NL per Markdown file". No mass rewrite of all 42 files merely to repeat labels. No automatic changes to adopting projects. No GitHub Actions/external paid CI.
