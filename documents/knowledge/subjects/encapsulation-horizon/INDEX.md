# Encapsulation Horizon

このsubjectは、**境界面をどのscaleで硬化し、どこから内部自由を許容するか**を扱うEncapsulation Horizonのknowledgeを管理する。

通常は `S001_CORE_PRINCIPLE.md` から読み、設計判断に応じて各責務文書へ進む。

## 構成

```text
encapsulation-horizon/
├─ INDEX.md
├─ S001_CORE_PRINCIPLE.md
├─ S002_RESPONSIBILITY_AND_HORIZON.md
├─ S003_HARDENING_POLICY.md
├─ S004_CONCEPT_ALTITUDE.md
├─ S005_CONTRACT_COMPLETENESS.md
├─ S006_EVOLUTION_AND_GRADUATION.md
├─ S007_GLOSSARY.md
├─ S008_OPERATIONAL_GUARDS.md
└─ S009_HISTORY.md
```

### S001_CORE_PRINCIPLE.md

「境界面は固く、内部は柔軟に」という出発点、boundaryのfractal性、その全面強制が生む破綻、Encapsulation Horizonという解、全体のまとめを扱う。

### S002_RESPONSIBILITY_AND_HORIZON.md

地平線の単位を固定scaleではなくresponsibility / meaning bundle / caller coherenceとして捉える考え方を扱う。

### S003_HARDENING_POLICY.md

hardeningの条件、stability、seam cost、macro→micro、harden-by-default、module=prior、maturity、split decisionを扱う。

### S004_CONCEPT_ALTITUDE.md

概念の意味が属する高度、YAGNI、最初のconsumer、neutral modeling、physical placement、hardening depthとの独立性を扱う。

### S005_CONTRACT_COMPLETENESS.md

内部自由とboundary contract完全性の双対、signature以外のleakage channel、内部自由を安全に成立させる条件を扱う。

### S006_EVOLUTION_AND_GRADUATION.md

責務の成熟、AND test、inner horizonへのgraduation、outer surfaceの維持、内部自由の将来costを扱う。

### S007_GLOSSARY.md

Encapsulation Horizon subject内で使用する用語を扱う。

### S008_OPERATIONAL_GUARDS.md

誤読防止、moduleの四義、confirmation levelなど、原理を実際の設計・AI workflowへ適用する際のguardを扱う。

### S009_HISTORY.md

原本の旧positioning、旧artifactとのauthority関係、artifactへの圧縮対応を歴史的文脈として保持する。

現在の第1情報源が旧artifactであることを意味しない。

## Traceability

主要source record:

```text
../../records/2026-09-21-docs-jp-snapshot/
└─ files/docs-jp/design-principles/source-logs/
   └─ ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md
```

今回のsubject-native再編では、原本のH2 section **17 / 17** が新しい責務文書内へ欠落なく再配置されていることを機械確認した。

検証結果:

```yaml
source_sections: 17
missing: 0
duplicated: 0
all_sections_exactly_once: true
original_preamble_count: 1
```

初回再編では意味変更リスクを抑えるため、section本文は原則そのまま保持し、主に以下だけを変更した。

- responsibility単位でのfile再配置
- subject-native title / intro / source参照の追加
- 旧authority / artifact対応文脈の `HISTORY.md` への分離

今後文体・重複・構造をさらに整理する場合も、recordsへのtraceabilityを維持し、条件・例外・反論・推論・誤読防止を失わないこと。
