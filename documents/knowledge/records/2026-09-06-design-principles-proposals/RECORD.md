# Source record: 2026-09-06-design-principles-proposals

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue body"
source_url: "https://github.com/Daiki-Yoshida/design-principles/issues/1"
source_created_at: "2026-09-06T17:59:05Z"
source_updated_at: "2026-09-15T20:53:07Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。PR/Issueは会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
AI向け配布文書が導く設計判断を改善するための提案です。「境界は厳密に、内部は柔軟に」という中心方針を維持しながら、契約の選択・検証・進化に必要な判断基準を補強します。

調査対象は [main / b863b24](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/README.md) です。対象は `artifacts/` の内容そのものです。以下は改訂案であり、採用する具体的な規則は検討のうえ確定します。着手優先度は **1. 契約の妥当性の検証** と **3. 互換性の判定** を高く想定します。

1. **契約への適合と、契約自体の妥当性を分けて検証する**

   現状：`CODING_STANDARDS.md` は契約テストを正しさの定義に置き、`AI_WORKFLOW.md` の最終検証も契約への適合を中心にしています。冒頭でユーザー意図を理解する手順や、Unit / Integration / E2Eへの言及は既にあります。

   課題：AIが要求を誤解し、その誤解から契約・実装・テストを作ると、相互に整合したまま要求を満たさない可能性があります。例えば階段の移動処理が契約どおり動いても、ゲーム内の操作から呼び出せなければ、プレイヤーは階段を利用できません。

   改善案：契約を設計する前に、要求由来の受入条件を明らかにし、最終検証でその条件へ戻ります。「実装が契約を満たすこと」と「契約を含む成果物が要求を満たすこと」を別の確認項目にします。確認手段は変更の影響範囲に合わせ、軽微な変更に一律のE2Eや詳細分析を要求しません。

   対象：[Contract Verification](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/CODING_STANDARDS.md#contract-verification-the-primary-validation)、[AI Workflow](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/AI_WORKFLOW.md)。

2. **Concept Altitudeに、意味の同一性を確かめる基準を加える**

   現状：「責務の一文にfeature名が不要なら、そのfeatureより汎用的」という判定を使います。共有モジュールへの物理的な切り出しを待つ規則は既にあります。

   課題：説明を抽象化すれば、異なる概念も同じ一文にできます。例えば「申請を承認する」と説明できても、取消可否・承認後の権限・失敗後の状態が異なれば、共通の契約として扱えるとは限りません。これは共有ファイルを作る時期とは別の、概念定義の問題です。

   改善案：feature名を省けることを、汎用性を調べる手掛かりに位置づけます。中立的な命名を維持しつつ、不変条件、成功・失敗の事後条件、ライフサイクル、変更理由から、意味を共通化できる範囲を確かめます。判断材料が不足している場合は中立的な局所モデルとして扱い、根拠のない広い再利用契約を宣言しません。

   対象：[Concept Altitude](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/DESIGN_PHILOSOPHY.md#concept-altitude-yagni-bounds-mechanism-not-meaning)、[Concept Generality](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/CODING_STANDARDS.md#concept-generality-consumer-neutral-modeling)、`AI_WORKFLOW.md` のPre-Implementation Scan。

3. **追加変更の分類に、呼び出し側・実装側双方の互換性確認を入れる**

   現状：契約の進化は追加を基本とし、確認ゲートでは公開メソッド追加などをL2の例にしています。公開Semanticsの変更を破壊的変更として扱う規則もあります。

   課題：「追加」という変更の形だけでは互換性を判断できません。既存のインターフェースに実装必須のメソッドを追加すると、呼び出し側が変わらなくても、その実装クラスやFakeが壊れます。

   改善案：互換性の判定を「既存の呼び出し側と実装側が、従来の保証のまま成立するか」に置きます。L2として進める前に、呼び出し側・実装側、利用言語や公開形態に応じたソース・実行時・通信上の互換性を確認します。追加でも既存の契約当事者を壊す変更は、破壊的変更として扱います。

   対象：[Contract Evolution](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/CODING_STANDARDS.md#contract-evolution--versioning)、[Contract Confirmation Gate](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/AI_WORKFLOW.md#process)。
   技術的な参考：[Microsoft — Breaking changes](https://learn.microsoft.com/en-us/dotnet/standard/library-guidance/breaking-changes)。

4. **性能要求を、公開する操作の粒度を決める入力として扱う**

   現状：性能のためにシグネチャを歪めず、最適化は内部で行う方針を強く求めています。

   課題：内部の最適化だけでは要求を満たせず、契約の操作粒度を再検討すべき場合があります。例えば大量の住民の経路探索では、1件ずつ同期的に返すAPIより、複数件をまとめて要求できるAPIが適切な場合があります。

   改善案：性能要求を初期の契約設計に含めます。既存契約ではまず内部最適化を検討し、実測によって要求を満たせないと分かった場合は、バッチ化・ストリーミング・境界の粒度も再設計の候補にします。公開する能力の意味、実装の交換可能性、互換性の規則を維持しながら判断します。

   この項目は設計方針の補強提案です。性能を理由とする変更の採用条件と、既存の抽象化方針との境界を明確にします。

   対象：[Performance vs. Abstraction Policy](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/DESIGN_PHILOSOPHY.md#performance-vs-abstraction-policy)、`AI_WORKFLOW.md` の設計・検証手順。

5. **境界の選択に、状態の所有権と一括して守る不変条件を組み込む**

   現状：Entityの不変条件や、Applicationによるトランザクション調整には言及があります。これらを境界の分割判断へどう使うかを補強します。

   課題：「所持金を減らす」「アイテムを増やす」を別モジュールへ分けた場合、各操作がそれぞれの契約を満たしていても、途中失敗によってお金だけ減る可能性があります。公開APIの整理だけでは、購入全体の整合性を保証できません。

   改善案：境界を分割する前に、状態の変更権限を持つ単位、複数の状態について同時に成立すべき条件、途中失敗時の責任を明らかにします。整合性の要求に応じて、トランザクション・補償・再試行などを誰が担うかを判断します。その結果を、責務の安定性や連携コストと並ぶ分割判断の入力にします。

   対象：[Application Boundary](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/CODING_STANDARDS.md#3-application-boundary-moduleapplication)、[Encapsulation Horizon](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/DESIGN_PHILOSOPHY.md#encapsulation-horizon-the-hardening-line)、[Project Structure](https://github.com/Daiki-Yoshida/design-principles/blob/b863b24bfdf4e8a96fd005e36decedd02beaafbe/artifacts/PROJECT_STRUCTURE.md)。

改訂の評価には、次のような短い設計課題と期待する判断を用います。

| 設計課題 | 期待する判断 |
| --- | --- |
| 個別の契約テストは成功するが、ユーザー操作から機能を利用できない | 要求由来の受入条件に照らして未達を検出する |
| 同じ一文で説明できるが、不変条件・事後条件の異なる概念がある | 共通化する意味の範囲を検証し、根拠のない汎用化を避ける |
| インターフェースへ実装必須のメソッドを追加する | 実装側への破壊的変更を認識し、L2へ自動分類しない |
| 内部最適化後も性能要求を満たせず、操作の粒度が制約になっている | 根拠を示して契約の粒度を再検討し、互換性も確認する |
| 購入の途中で、減金後にアイテム付与が失敗する | 状態の所有権・整合性条件・失敗時の責任を設計する |

完了条件：

- [ ] 5点について採否・採用する規則・判断理由が明確になっている。
- [ ] 採用した規則が、INDEXのOwnership Mapに従う正本と、必要なワークフローへ反映されている。
- [ ] 思想の変更を伴う箇所は、日本語原本との導出関係を確認している。
- [ ] 上記の設計課題で、改訂後の文書に基づくAIの判断を確認している。
- [ ] 軽微な変更への分析量の調整や、既存プロジェクトの明示的規約を優先する方針が維持されている。

~~~~
