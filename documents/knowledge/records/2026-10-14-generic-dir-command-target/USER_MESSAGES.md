# Generic DIR command targeting — selected user source events

出典: 2026-10-14のこのChatGPT会話。以下は選定した各ユーザーメッセージの本文を順序どおり、event単位で収録したもの。個別message locatorは未取得。見出しと `~~~~text` fenceは保存用の外枠であり、会話本文ではない。

## User source event 1 — DIR調査依頼

~~~~text
DIR= の指定について調べてほしい
~~~~

## User source event 2 — WORK指定の実装とDIR本来意図

~~~~text
WORK= という指定は記述されていない？
artifacts を参照させていたプロジェクトが、 make WORK=feat/hogehoge/ docker-up の様な実装にしていた。　本来自分が意識していたのは、 make DIR=.worktrees/feat/hogehoge/ docker-up みたいな、プロジェクトルートからのディレクトリパスを渡すことで、コマンド側が　パスの引数を自動的にwork指定と解釈してくれることだったんだけど
~~~~

## User source event 3 — 汎用のDIRパス・コマンド別解釈・Tab補完

~~~~text
そうそうそう、　DIR=　指定は単なるパスなんだよ。　用は、コマンドごとに、パスをもらったときに受け取り方を変えればいいだけ。

あるコマンドならそこでDockerUPするんだ、となるし、あるコマンドならそこから何か作成するんだ、となる。　"指定対象" というだけ。　それを汎用のDIR にしているんだよね。

むしろ、汎用にするからこそ意味があるんだよね。毎回WORKとか別の指定だと困る。違いすぎるし入力補完が聞かない(ファイルパスならコマンドのルートを起点に、tabキーで簡単に入力補完ができる)
~~~~

## User source event 4 — Issue化と原文保存の指示

~~~~text
Issueにして。recordsにも記録。recordsの記録方法は適切にartifacts参照してね。
~~~~
