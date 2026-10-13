# Work Records Protocol — 最終指示の直前に示されたassistant設計回答

## Provenance

- Source: 2026-10-13のこのChatGPT会話におけるassistant返信（個別の永続message locator未取得）
- Coverage: ユーザーのEvent U3（Work Documentsの元の意図の訂正）に対するassistant返信1件。後続のユーザーEvent U4が「かなりよさそう」と言及した対象。先行するassistant返信やtool出力は含まない
- Fidelity: チャット上で表示されたMarkdown/DILを含む本文の手動転記。元のAPI生本文とのbyte-for-byte一致・見た目のレンダリング変化は検証していない。以下のfenceとメタデータは保存時の外枠
- Status: 設計提案・解釈であり、規約としてcanonical化されたわけではない

## 本文

~~~~text
なるほど。元の設計資料まで確認してみました。

結論から言うと、**今回の `documents/archive/works/` 案は、元々のWork Documentsの設計思想と矛盾していません。** 私が前回「設計上の衝突」と表現したのは、少し強すぎましたね。

ただし、現在の規約には、元の意図よりも広く解釈できる禁止事項が書かれています。

## 1. 現行規約の確認結果

現在の [S003_WORK_DOCUMENTS.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/main/documents/knowledge/subjects/work-identity/S003_WORK_DOCUMENTS.md) には、次の3つの規則があります。

| 規則 | 現在の記述 |
|---|---|
| 正本への統合 | Work完了時、今後も必要な知識をProject Documentationへ統合 |
| 不要文書の整理 | 作業中だけ必要な仮説やログなどは破棄 |
| 履歴の保存 | Git historyを使用し、独自archive directoryを作らない |

さらに、2026年9月21日に保存された旧設計原本 `WORK_IDENTITY_DESIGN_JP.md` の第13節・第20節にも、同じ規則が存在していました。

つまり、Artifactへの変換過程で誤って付け加えられた禁止ではありません。

**元の設計段階から「Git履歴があるため、Work Documentsを別途アーカイブする必要はない」と規定されていた**わけです。

## 2. 元の意図と今回の提案は両立する

ここで、Work DocumentsとWork Recordsを区別すると明確になります。

<box border radius="lg" padding={3} gap={2}>
  <text weight="medium">Work完了時の新しいモデル案</text>
  <box background="surface-secondary" radius="md" padding={3} align="center">
    **Work Documents**
    <text size="xs" color="secondary">設計・調査・実装経緯・Records</text>
  </box>
  <row justify="center" gap={2}>
    <icon name="arrow-down" color="secondary"/>
    <text size="xs" color="secondary">Reconciliation</text>
  </row>
  <grid columns={2} gap={2}>
    <grid-item>
      <box border radius="md" padding={3} gap={1} height="100%">
        **現行知識**

        <text size="xs">確定仕様・制約・必要な設計理由</text>
        <divider color="subtle"/>
        <text color="secondary" size="xs">`documents/` の正本文書へ統合</text>
      </box>
    </grid-item>
    <grid-item>
      <box border radius="md" padding={3} gap={1} height="100%">
        **開発履歴**

        <text size="xs">AIの判断・問題・試行錯誤の記録</text>
        <divider color="subtle"/>
        <text color="secondary" size="xs">`documents/archive/works/` へ移管</text>
      </box>
    </grid-item>
  </grid>
  <box align="center" gap={1}>
    <icon name="trash-2" color="secondary"/>
    <text size="xs" color="secondary">不要になったWork固有の作業文書を整理</text>
  </box>
</box>

従来の「メインドキュメントに吸収整理する」という意図は、そのまま維持できます。

今回追加するのは、**正本文書へ統合する知識とは別に、開発の過程そのものにも保存価値を認める**という判断です。

例えば、最終的にA案が採用された場合、現在の仕様にはA案とその重要な採用理由を記録します。一方、B案を試した際の詳細な問題やAI間のレビュー履歴などは、必要に応じてアーカイブから参照できます。

アーカイブが現在の仕様の正本になるわけではありません。

## 3. では、規約のどこを変える必要があるか

重要なのは、現在の「アーカイブ禁止」を撤廃するだけでなく、**何をアーカイブするのかを明確にすること**です。

私は、現行の規約を次のように再定義するのが適切だと思います。

> Work完了時には、Work Documentsに含まれる永続的な知識をProject Documentationの適切な正本へ統合する。
>
> 統合後のWork Documentsを、そのまま複製して保存する必要はない。不要な作業文書は整理・削除でき、その変更履歴はGitで追跡する。
>
> ただし、開発過程の判断・調査・問題解決などを記録するWork Recordsは、Work完了後にProject Documentation配下の非日常参照アーカイブへ移管できる。
>
> アーカイブは現在有効な仕様を定義する正本ではなく、歴史的な判断とその根拠を保存する領域とする。Gitは引き続き、それらの変更履歴を管理する。

これなら従来の原則を維持しながら、今回の新しい要件を追加できます。

## 4. 変更が必要な箇所

現行のリポジトリでは、少なくとも次の文書に関係します。

| 文書 | 対応 |
|---|---|
| `work-identity/S003_WORK_DOCUMENTS.md` | Work Recordsと完了時アーカイブの関係を追加 |
| `work-identity/S004_LIFECYCLE_AND_RESOURCES.md` | Work完了処理にRecords移管を追加 |
| `documentation/S003_WORKFLOW.md` | 正本文書への統合と履歴保存の責務を分離 |
| `artifacts/project/WORK_LIFECYCLE.md` など | 新しい正本規約をAI向けに反映 |

もちろん正式に変更する際は、今回の議論を第0情報源として記録し、既存のKnowledgeからArtifactへ順番に反映することになります。

---

## 私の判断

今回の説明で、設計の整理がかなり進みました。

従来のWork Documentsは、**開発中の知識を管理し、完了後は正本へ吸収して役割を終えるもの**。

新しいWork Recordsは、**開発の過程を記録し、完了後も履歴資料として残すもの**。

そして、Git historyは両者の変更履歴を管理するものです。

この3つは競合しません。

ただし、`documents/archive/works/` は物理的には `documents/` 配下でも、現行仕様を表す正本文書とは意味的に異なる領域です。この区別は規約として必要ですね。

したがって、**既存のWork Documents設計を否定・置換するのではなく、Work Recordsという新しい保存責務を追加し、それに合わせてアーカイブ禁止規則を限定する**のが適切です。

現時点のリポジトリにはまだその例外が定義されていませんが、変更方針としては十分に整合していると思います。
~~~~
