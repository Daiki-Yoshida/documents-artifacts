ええ、その考え方が適切だと思います。

現行の開発ブランチ `refactor/dev-artifacts-restructure` にある管理文書を改めて確認しました。

結論として、**旧 `documents-artifacts` の管理モデルは大部分を継承できます。新規に設計が必要なのは、主に「権威・承認管理」と「新しい階層の関係」です。**

Stage 1でrecordsの抽出方法やArtifactsの射影方式まで作り直す必要はありません。

## 1. 既存文書をどう継承するか

まず、既存文書の移行先を整理します。

| 旧文書 | 新しい配置候補 | 対応 |
|---|---|---|
| `KNOWLEDGE_MODEL.md` | `repository/models/` | 構造変更に合わせて修正 |
| `RECORD_MODEL.md` | `repository/models/` | ほぼそのまま継承 |
| `DECISION_LINEAGE_MODEL.md` | `repository/models/` | 基本モデルを継承 |
| `TRACEABILITY_MODEL.md` | `repository/models/` | ほぼそのまま継承 |
| `SUBJECT_MODEL.md` | `repository/models/` | Stage 1では基本責務のみ整理。詳細はStage 2 |
| `ARTIFACT_MODEL.md` | Stage 3で決定 | 旧モデルをそのまま現行規則にしない |
| `REPOSITORY_STRUCTURE.md` | `repository/` | 新構造へ変更 |
| `KNOWLEDGE_UPDATE_WORKFLOW.md` | `repository/operations/` | 共通運用を継承し、Stage 2・3の詳細を切り離す |

旧 `ARTIFACT_ARCHITECTURE_V2.md` や既存の射影監査、Agentテスト資料などは、現時点では旧設計の資料として保全するのがよいでしょう。

特に `RECORD_MODEL.md` は、現在の原文保存やevent / bundle / snapshotの定義がそのまま使えます。

一方、`KNOWLEDGE_MODEL.md` には変更が必要です。以前は `knowledge/` が管理規則まで包含していましたが、今後は管理規則を `repository/models/` が所有するためです。

## 2. Stage 1で不足している設計

私が重要だと思うのは、次の4点です。

### ① 権威と所有権の整理

現在の設計では `documents/knowledge/` がファイル化された情報の最優先の情報源です。

しかし、新構造では、すべての権威を単一のディレクトリの上下関係で説明できません。

例えば、

| 対象 | 定義権・判断根拠 |
|---|---|
| recordsの保存契約 | `repository/models/` |
| 記録に実際に何が存在したか | `knowledge/records/` |
| Dev-Philosophyの内容 | Ownerが制定した `knowledge/subjects/dev-philosophy/` |
| Dev-Methodologyの内容 | `knowledge/subjects/dev-methodology/`。哲学を前提とする |
| リポジトリでの実施手順 | `repository/operations/` |

これらは互いに異なる責務を所有しています。

**管理モデルが開発哲学より偉いわけでも、開発哲学がrecordの原文保存規則を自由に変更できるわけでもありません。**

規範的な優先順位と、各概念の定義権を分ける必要があります。

ここはStage 1で明文化したいですね。

### ② Dev-Philosophyの承認管理

旧体系にはDecision Lineageが存在し、採用・却下・訂正・更新を管理できます。

これ自体は継承できます。

ただし、新たに次の区別が必要です。

- 哲学として抽出・提案されたもの
- Ownerが正式に制定したもの
- 制定後に変更・撤回されたもの

少なくとも**AIが抽出しただけでは制定済みのDev-Philosophyにならない**という契約を置く必要があります。

具体的な候補の保存形式や、recordsから承認状態を解決する詳細な手順はStage 2で設計すれば十分です。

### ③ 哲学と方法論の関係

これは既に用語が決まっています。

Dev-MethodologyはDev-Philosophyを「実現する」。

さらに、概念によって「具体化する」「参照する」「包含する」「委譲する」「所有する」などの関係を使用します。

Stage 1では、少なくとも両者の意味上の関係と定義権の境界を規定しておきたいです。

ただし、**個々の既存知識がどちらの層へ所属するかはStage 2まで決めない**。

これで分類作業と管理体系の設計を分離できます。

### ④ 移行中の規則の有効性

これが意外と重要です。

現在の開発ブランチには、新しい `documents/repository/` が既に存在する一方、旧 `documents/knowledge/system/` と `documents/project/` も残っています。

旧文書には、現在では採用しない選択的読み込みの指示や、旧ディレクトリへの参照もあります。

そのため、Stage 1の完了時には次の状態にすることを推奨します。

**現在有効な管理規則は `documents/repository/` を正本とし、旧管理文書が独立した現行規則として残らない。**

過去の判断や記録は削除せず、Git履歴や既存recordsから確認できます。

また、`README.md`、`documents/INDEX.md`、`documents/knowledge/INDEX.md` などの入口も、新しい構造へ揃える必要があります。

## 3. Stage 1の完成形

私なら、Stage 1は次の状態を目標にします。

```text id="g2dg2n"
documents/
├── INDEX.md
│
├── repository/
│   ├── INDEX.md
│   ├── REPOSITORY_STRUCTURE.md
│   ├── models/
│   │   ├── INDEX.md
│   │   ├── KNOWLEDGE_MODEL.md
│   │   ├── RECORD_MODEL.md
│   │   ├── SUBJECT_MODEL.md
│   │   ├── DECISION_LINEAGE_MODEL.md
│   │   ├── TRACEABILITY_MODEL.md
│   │   └── ... 権威・承認管理の定義
│   └── operations/
│       ├── INDEX.md
│       └── KNOWLEDGE_UPDATE_WORKFLOW.md
│
└── knowledge/
    ├── INDEX.md
    ├── records/
    │   └── YYYY-MM-DD-name/
    └── subjects/
        ├── dev-philosophy/
        └── dev-methodology/
```

このツリーにおける追加の管理モデル名は、まだ確定しません。

`subjects/` の2領域は空で構いませんし、`artifacts/` も空のままです。

Stage 1では、モデルの配置・責務・権威・基本的な更新境界だけを整えればよいでしょう。

## 4. 私が最も重視すること

今回の再編で、既存の管理モデルを無理に捨てる必要はありません。

むしろ、既存の次の性質は残すべきです。

- recordsは原文を保存する。
- subjectsは意味の完全性を守る。
- Decision Lineageで判断の採否や変化を追跡する。
- traceabilityによって根拠へ戻れる。
- 未決定事項を勝手に制定済みにしない。

これらは3層モデルと矛盾しません。

新たに必要なのは、**Dev-PhilosophyとDev-Methodologyを導入したことによって生まれる、定義権・制定権・層間関係の契約**です。

---

### 私の提案

Stage 1で新規に検討するものは、できるだけ次の2つに絞りたいです。

**A. Authority / Governance Model（仮称）**

誰が何を所有し、何を制定できるか。Dev-PhilosophyのOwner承認や、管理規則との関係を定義する。

**B. Dev Layers Model（仮称）**

Dev-Philosophy、Dev-Methodology、AI-Orchestrationの責務・前提関係・固定語彙を定義する。

この2つを既存の `KNOWLEDGE_MODEL` などと整合させ、あとは新しいディレクトリ構成へ移行する。

**これでStage 1は十分成立する**と考えます。

今のところ、新しい管理体系を一から作る必要は見当たりませんね。既存の成熟した部分を残し、新しい体系に必要な契約だけを増やす方が合理的です。

なお、今回は設計上の検討のみで、GitHubのファイルやIssueは変更していません。