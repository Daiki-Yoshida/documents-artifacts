# Issue #189 — Bundle intake design context

本ファイルは、B案を選択した後、実装指示の直前に提示されたassistant回答を支える文脈を保存する。元のChatGPT応答を直接exportしたbyte-identical原文ではなく、会話の表示から再構成した設計内容の記録である。sourceの完全な文字単位の一致は保証しない。

## 提示した設計案（文脈記録）

- Bundleは「1つの判断や出来事を再構築するための第0情報源の集合」とする。同じ話題・Issue・期間というだけでまとめない。
- 取り込み単位はevent数・Issue番号・作業期間ではなく、記録する出来事とその証拠関係で区切る。
- 1つのBundleは関連source eventを識別できるように保存する。短い承認や訂正が対象とする提案・調査を同じBundleか別recordへの参照で追跡可能にする。
- Fidelity（各収録本文が原文にどの程度忠実か）とCoverage（会話全体、選定した完全event群、Issue本文、snapshotのどこまでを対象にしたか）は別の軸とする。選定した各eventは原則全文を保持し、選定eventを超えた完全性は主張しない。
- Event / Bundle / Snapshotの3形を許容し、単独eventでは本文をRECORD.mdに直接置ける。Bundleではfileの数や固定名称を強制せず、境界とsource inventoryを示す。
- Bundleは取り込み時に閉じたsource集合とし、後から発生した新判断で古いBundleを増補・再解釈しない。追加判断は別recordから参照する。
- 出典（識別可能なURL等）、収録範囲、原文加工状況、出来事・取得・保存日時を判明している範囲で区別する。得られないIDや日時は推測しない。
- 既存recordsの再配置や画一化はしない。RECORD_MODELとKNOWLEDGE_UPDATE_WORKFLOWを最小限で改善し、必要なら新規形式だけに軽量な機械検証を追加する。

本ファイルは「先行する回答の忠実な全文保存」を名乗らない。今回の採用された設計の再構成を助ける補助説明であり、原文のユーザー決定はUSER_MESSAGES.md、Issue原文はISSUE_189_BODY.mdに分離して保全する。
