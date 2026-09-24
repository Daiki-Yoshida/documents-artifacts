# Knowledge System

`system/` は、knowledgeをどう保存・整理・検証するかという仕組み自体を定義する。

## Documents

| Document | 責務 |
|---|---|
| `KNOWLEDGE_MODEL.md` | INDEX / system / records / subjects の全体モデル |
| `RECORD_MODEL.md` | 原文・snapshot recordの保存単位、命名、改変禁止、metadata |
| `SUBJECT_MODEL.md` | recordsを責務・domain knowledgeとして整理する規則 |
| `TRACEABILITY_MODEL.md` | subjectsからrecordsへ戻って意味を検証する規則 |
| `ARTIFACT_MODEL.md` | 第1情報源からAI向け第2情報源へprojection・routingする規則 |

systemを変更する場合も、根拠となるユーザー判断・議論を先にrecordsへ保存する。
