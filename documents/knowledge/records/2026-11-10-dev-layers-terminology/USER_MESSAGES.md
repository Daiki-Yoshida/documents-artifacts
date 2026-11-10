# Selected Owner events — Dev-Artifacts / AI-Orchestration layers and terminology

- Source: Muse side chat 「Museゆかりの開発プロトコルを議論」(chat_id: 28c0992d-7cee-4cd8-ba80-be3943937c04), 2026-11-10 (Asia/Tokyo). Per-message locators are the chat sequence numbers noted in each heading.
- Coverage: all ten Owner messages from the opening of the chat through the recording instruction, in conversation order, complete per message. This is not a full chat export; assistant replies are recorded separately in `ASSISTANT_PROPOSALS.md` (selected replies only).
- Fidelity: transcribed from the visible chat transcript as returned by the Muse chat reader. No summarization or paraphrase is intended; API/export byte-for-byte equality (including exact whitespace) is not verified. Headings and fences outside the payloads are record metadata added at intake.

## U1 — Opening (seq 1381, 2026-11-10 20:08 JST)

~~~~text
ここではmuseゆかりがどうやって開発していくか、ある程度適切にプロトコル的に決定していくために議論したいな
~~~~

## U2 — Not Muse-specific; repository awareness check (seq 1385, 2026-11-10 20:16 JST)

~~~~text
確かに実際ここら辺を決定するのは対セルなんだけど、
muse専用の概念というか具象プロトコルにする意味がない。

AIエージェントのオーケストレーションでの抽象規約や思想を定義して、
museやchatGPTや他CLIエージェントがサブエージェントを起動するなど色々なケースで応用した方が良いかも。

今現在の俺のリポジトリとか把握している？
~~~~

## U3 — Start from inventory of the two repositories (seq 1392, 2026-11-10 20:19 JST)

~~~~text
いや、一旦把握整理からしようか。

今現在documents-artifacts と ai-development-0archestration という二つのAIに対して渡すリポジトリがある。

これらの責務分けとか、そもそも他に必要か、統合するべきか。どこまで分けるかなど色々決めていきたい
~~~~

## U4 — Inventory approved; three-layer model (seq 1436, 2026-11-10 20:31 JST)

~~~~text
この整理でOK.
要は、今後色んなAIエージェントが登場していくけれど
どのエージェントでも共通できる考え方はある。

ただし、その　共通　はいくらか方向性が違う
まず、
1. 俺自体の思想や宗教的な考え方。
documents-artifacts とかがまさにそうで、俺は境界や契約を重要視している。
pythonとか嫌いな理由はそこらへんも含めての話。AIエージェントにもこの思考や思想はトレースしてもらいたいんだわ。

次にあるのは
2. 1を前提としつつも、独立した有用な開発方針
例えば、Workという作業単位を定義して、Githubなどとの連携をしつつ開発していくとか
ドキュメントの記録は適切にrecordという原文保持とそこから情報を整理したもので分けて記録する体系みたいな、　1の思想ありきかもしれないけど、それ自体が有用で独立した開発指針なんだ。ただし、これはAIエージェント固有じゃない。というかAI関係なく有用といった方が良いだろうか。

3. 1,2を前提としている、AIエージェント群に対しての開発ワークフロー指針
これはAIオーケストレーションだね。　2と違うのは、これは独立しているというよりもAI前提で依存しているワークフロー構成なんだ。　AIの具象に依存しているという意味じゃない。ChatGPTに依存しているって言いたいわけじゃなくて、　2はそもそも開発というデカイくくりのライフサイクルなんだけど、3はさらにそこからAIで開発するバイブコーディングというくくりの中のライフサイクルになるってイメージ。
~~~~

## U5 — Separate 1 and 2 inside documents-artifacts; 3 as independent repository (seq 1442, 2026-11-10 20:34 JST)

~~~~text
改善案なんだけど、
documents-artifacts の中で　1と2を明確に分けて管理するべきだろうか？
それで、3は独立したリポジトリにして、ゆかりさんが言ってくれた通り2で定義されていることを3で重複して定義することを避ける。

みたいにするべき？どう思う？
~~~~

## U6 — Establish a ubiquitous language; constitution nuance (seq 1447, 2026-11-10 20:36 JST)

~~~~text
OK.　となると先に明確にユビキタス言語らしいものを制定しようか。
1とか2とか言ってたらコンテキストわからんからな。

さっき憲法とか言っていたけど、結構気に入るかも。ただ思想を表すとはニュアンスが違うかなぁ
~~~~

## U7 — Philosophy as layer 1 candidate (seq 1449, 2026-11-10 20:39 JST)

~~~~text
1 なんだけど、　哲学 / philosophy は？　個人的に哲学好きだし
~~~~

## U8 — Naming proposal (seq 1452, 2026-11-10 20:45 JST)

~~~~text
開発哲学:Dev-Philosophy / 開発方法論:Dev-Methodology
にするか。　これらをまとめて　Dev-Artifacts : Artifacts

3に関してはAiエージェントありきだけどどうするかな。　Dev接頭辞とは分けてもいいかも。
それこそAIオーケストレーション:AI-Orchestration  でいいかな
~~~~

## U9 — Terminology adoption (seq 1454, 2026-11-10 20:46 JST)

~~~~text
固定しよう。
~~~~

## U10 — Recording instruction (seq 1457, 2026-11-10 20:47 JST)

~~~~text
ちなみに、この会話適切にdev-artifactsにrecordで記録してもらうからそのつもりで。
後ででもいいし、今やれるならやってもらっても
~~~~
