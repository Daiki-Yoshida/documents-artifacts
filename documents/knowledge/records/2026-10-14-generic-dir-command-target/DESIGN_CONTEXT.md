# Selected assistant design context — immediately preceding Issue/records instruction

出典: このChatGPT会話。ユーザーの最終「Issueにして」指示が参照する直前のassistant返信1件。個別message locatorは未取得。下記の4-tilde Markdown fenceは保存用の外枠。会話のAPIエクスポートとのbyte-for-byte一致は検証していない。

~~~~markdown
ああ、なるほど。私の理解も少しWork Identityに引っ張られていましたね。

**`DIR` は、ただのディレクトリパス。そのパスをどう扱うかは、呼び出されたコマンドが決める。**

これが本来の設計思想ですね。

例えば、全部同じインターフェイスで表現できます。

```bash id="eev65o"
# 指定ディレクトリを対象にDocker環境を起動
make DIR=.worktrees/feat/hogehoge docker-up

# 指定ディレクトリを対象にテスト
make DIR=.worktrees/feat/hogehoge/game test

# 指定ディレクトリを対象にlint
make DIR=components/web lint

# 指定ディレクトリを基準にコード生成
make DIR=components/api generate
```

ここでは `DIR` がWorkを表すのか、Repositoryを表すのか、作業ディレクトリを表すのかを、共通仕様として決める必要がないんです。

`docker-up` がWork単位の操作なら、渡されたパスを検証して、必要に応じてWork Identityを導出すればよい。`test` ならテスト対象、`generate` なら生成先など、各コマンドが用途を定義します。

そして、**Tab補完の話はかなり重要です。**

`WORK=feat/hogehoge` は抽象的な識別子なので、利用者はWork名や命名規約を覚える必要があります。

一方、`DIR=.worktrees/feat/hogehoge/` は実在するファイルシステムのパスです。Project Rootから辿れて、シェルの補完機能も活用しやすい。人間にもAIにも、既存のディレクトリ構造をそのまま操作対象の指定に使える利点があります。

### となると、Artifactの改善点も変わってきます

現行の `COMMANDS_AND_CI.md` は、`DIR` を汎用パスとして扱うところまでは正しいです。

しかし、その説明を **Execution Target Directory = build/install/test等の実行先** に寄せすぎています。

さらに、Worktree操作には `WORK + REPO` を使う、という別の公開インターフェイスが強く規定されています。

このため、AIがコマンドの種類ごとに `WORK=` や `REPO=` といった引数を増やす判断をしやすい構造になっています。

私なら、共通規約の中心を次のように定義し直します。

> **`DIR` は、Project Rootを基準とする汎用的なディレクトリパス指定である。**
>
> `DIR` 自体にWork Identity、Repository Identity、Runtime Identityなどの意味を与えない。
>
> 指定されたパスの用途、必要な存在条件、そこから導出する識別子や操作対象は、個々の公開コマンドの契約が決定する。
>
> コマンドがWork IdentityやRepository Identityを必要とする場合は、指定パスとProject側の既存構造・管理情報を検証したうえで解決してよい。
>
> 公開コマンドの設計では、利用者が実際のディレクトリパスを指定できる一貫したインターフェイスを優先する。

これなら `DIR` をWork専用にする必要もありませんし、内部でWork Identityを使うこととも矛盾しません。

ただし、既存の `WORK + REPO` によるWorktree作成・削除契約まで変更するかは、別途整合を確認する必要があります。そこも利用者にパスを渡させる設計へ統一するなら、操作対象の検証と安全条件を再設計することになります。

**要するに、利用者に公開するインターフェイスを統一し、対象に応じた意味解決はコマンド内部へカプセル化する。**

これですね。汎用の `DIR` にしていること自体に意味がある、という点を、今のKnowledgeとArtifactではもっと明確にした方がよいと思います。
~~~~
