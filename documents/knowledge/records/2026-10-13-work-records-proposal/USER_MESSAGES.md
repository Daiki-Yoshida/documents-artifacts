# Work Records Protocol — 選定したユーザーメッセージ

- Source: 2026-10-13のこのChatGPT会話（個別の恒久message locatorなし）
- Coverage: この判断に関係する下記4件のユーザー発言。それ以外の発言・assistant返答は本文に含めない。
- Fidelity: 会話内で表示されたメッセージ本文の手動転記。原文APIによるbyte-level照合は未実施。見出し・区切りfenceはこの保存時に追加した外枠であり、source messageの一部ではない。
- Order: U1 → U2 → U3 → U4（実際の会話順。間にassistant返信がある）

## Event U1 — 初期の提案

~~~~text
新しい適切な記録プロトコルを提唱したい。



> AIの記録を適切にリポジトリ側に記録する事。
>
> \
> ChatGPTのブラウザChatでも、実行エージェントの記録でもなんでも。\
> そのリポジトリに対して操作などを行ったりした場合は、適切に記録が必要。



具体的には、例えばWSL内のCLI実行エージェントで開発を行った場合、その開発の内容ややり取りはGithubのコミットという形でしか見れない。コミットメッセージなどで適切に記録には残っているが、その判断理由や発生した問題などは適切にドキュメントにしなければならない問題がある。

ChatGPTのブラウザのChat(あなたのことね)でリポジトリを直接開発・編集する場合でも同様で、

コミットメッセージしか履歴が無いのは問題。せっかくChatで有益な議論ができても、それが喪失する可能性を内包してしまっている。



そこで、適切にリポジトリに記録してしまいたいと思った。せっかくWorkドキュメントという物を用意しているし、そこにrecordsといったものを持ち込みたい。これはdocuments-artifacts のrecords と似たものだが、そこまで厳密性は必要ない。





上記の考え方についてどう思う？
~~~~

## Event U2 — Work Recordsの終了後の扱い

~~~~text
Work Recordsは作業終了までの詳細な開発記録
として扱い、開発終了後は、.worktrees/ じゃない ./documents/ の別の場所に、普段は読み取らないアーカイブとして移せばいいかも。
~~~~

## Event U3 — 元のWork Documents設計意図の訂正

~~~~text
現行の [S003_WORK_DOCUMENTS.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/main/documents/knowledge/subjects/work-identity/S003_WORK_DOCUMENTS.md)    　なんだけど、本来私が意図していたのは


```
開発終了後、Workドキュメントは適切に　メインドキュメントに吸収整理されるから、不要になるので削除していい。削除しても一応記録はGitに残るし
```



という意味だった。 それを踏まえると、documents/archive/works/　に記録を移すのも、メインドキュメントに吸収整理される、という意図から出ていないと思うけど、現状どうなっている？
~~~~

## Event U4 — Issue化と記録の指示

~~~~text
かなりよさそう。Issueにできる？　あとrecords に記録して
~~~~
