#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

require_file() { test -f "$1" || { echo "MISSING: $1" >&2; exit 1; }; }
for f in \
  documents/repository/INDEX.md \
  documents/repository/REPOSITORY_STRUCTURE.md \
  documents/repository/models/INDEX.md \
  documents/repository/models/KNOWLEDGE_MODEL.md \
  documents/repository/models/RECORD_MODEL.md \
  documents/repository/models/SUBJECT_MODEL.md \
  documents/repository/models/DECISION_LINEAGE_MODEL.md \
  documents/repository/models/TRACEABILITY_MODEL.md \
  documents/repository/models/DEV_LAYERS_MODEL.md \
  documents/repository/models/AUTHORITY_GOVERNANCE_MODEL.md \
  documents/repository/operations/INDEX.md \
  documents/repository/operations/KNOWLEDGE_UPDATE_WORKFLOW.md \
  documents/repository/legacy/INDEX.md \
  documents/knowledge/INDEX.md
do
  require_file "$f"
done

test -d documents/knowledge/records || { echo "records missing" >&2; exit 1; }
test -d documents/knowledge/subjects/dev-philosophy || { echo "philosophy directory missing" >&2; exit 1; }
test -d documents/knowledge/subjects/dev-methodology || { echo "methodology directory missing" >&2; exit 1; }
test -d artifacts || { echo "artifacts directory missing" >&2; exit 1; }
test ! -d documents/knowledge/system || { echo "old system directory is still active" >&2; exit 1; }
test ! -d documents/project || { echo "old project directory is still active" >&2; exit 1; }

grep -q "Owner" documents/repository/models/AUTHORITY_GOVERNANCE_MODEL.md
grep -q "Dev-Philosophy" documents/repository/models/DEV_LAYERS_MODEL.md
grep -q "Stage 2" documents/repository/models/SUBJECT_MODEL.md
grep -q "Stage 3" documents/repository/REPOSITORY_STRUCTURE.md
echo "PASS: dev-artifacts Stage 1 layout and governance smoke"
