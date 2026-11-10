# Stage 2 Workflow — Philosophy first

Status: **Owner adopted on 2026-11-11**. Workflow definition only: no philosophy or methodology content is established here.

## Premise

Dev-Philosophy is the foundation; Dev-Methodology **実現する** Dev-Philosophy; AI-Orchestration is a separate, more concrete agent protocol built upon the first two layers. Analysis therefore starts with philosophy rather than forcing legacy leaves into a predefined taxonomy.

## Stage 2-A — Establish the philosophy foundation

| Step | Procedure | Output / transition |
| --- | --- | --- |
| **A-1** | Extract **rough philosophy** candidates from the **entire former subjects corpus** at the pinned old `main` commit. Preserve provenance, uncertainty, mixed passages and relevant objections. Do not classify files wholesale. | Candidate inventory and full-corpus coverage ledger, **not** official subjects |
| **A-2** | Inspect **all records** against rough candidates: missing claims, meaning drift, adoption/rejection/supersession, implicit philosophy not in subjects. Record coverage of each record and its payload; no claim of full coverage while anything is unread or unresolved. | Record-by-record audit and provisional revised philosophy candidates |
| **A-3** | Owner personally examines the proposed philosophy, debates with ChatGPT, revises and accepts/rejects meanings. | Explicit scope-aware Owner judgments, captured as source records |
| **A-4** | **After Owner consensus**, derive subject partition units and structure from the agreed philosophy; do **not** pre-impose categories or legacy leaf boundaries. | Owner-agreed philosophy taxonomy/structure |
| **A-5** | Write the philosophy side into `documents/knowledge/subjects/dev-philosophy/` **provisionally**. Distinguish content approval from arrangement approval and mark unapproved claims as non-authoritative. | Provisional philosophy subjects, not yet final Stage 2-D release |

- A-1/A-2 scratch reports, inventories, and evidence go under `documents/repository/operations/stage2/`; none are the canonical philosophy.
- Source evidence is `documents/knowledge/records/` and the old subject `main` snapshot. Do not amend raw past records to suit current conclusions.
- Owner's explicit final approval is mandatory before a philosophy idea is **enacted**. A-3 is a required gate; AI extraction is not approval.
- A-4 must follow A-3 consensus. A-5 follows A-4, and its tentative status is never hidden.
- A-1 and A-2 are ordered for substantive interpretation, but a records inventory and source coverage setup may start in parallel with the A-1 reading. Early record insights cannot be treated as the final completeness audit.

## Stage 2-B / C / D — High-level adopted boundaries

- **B:** Extract Dev-Methodology, stating how it realizes the philosophy. Do not manufacture a philosophical premise where none is supported; discoveries may trigger revisiting A.
- **C:** Cross-check omissions, meaning drift, duplicate semantic ownership, unaddressed lineages, and links between philosophy and methodology.
- **D:** Resolve review findings, owner-approval/status issues and traceability, then complete Stage 2. Detailed substeps remain undecided.

## No Stage 3 leakage

Do not define subjects→artifacts projection, reading scheme, or packaging here. Keep `artifacts/` unpopulated and do not distribute this development branch. Stage 3 will be designed after actual subjects exist.

## Status / evidence

- [Source adoption record](../../../knowledge/records/2026-11-11-stage2-philosophy-first/)
- [Issue #221](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221)
- [A-1 / A-2 evidence workspace](stage2/INDEX.md)

Recorded as a repo-local workflow derived from the Owner's decision; not a replacement for the source record.
