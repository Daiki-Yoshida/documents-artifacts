# K-2026-10-03-001

```yaml
記録種別: "第0情報源からの会話記録"
情報源: "ChatGPT会話内のユーザー・アシスタントメッセージ"
記録日: "2026-10-03"
原文言語: "日本語"
編集方針: "会話本文の文面を転記。表示上のMarkdown記号は一部省略。実行エージェント向け委譲文・実行ログ・報告は除外"
収録範囲: "会話全体ではなく、historical branch整理前の状態確認とbranch削除後のGit履歴保持についてのユーザー・ChatGPT間の該当やりとり"
```

## 原文

### ユーザー

現状報告をしてほしい

### ChatGPT

現状はかなり綺麗です。Daiki-Yoshida/documents-artifacts は、長く残っていたKnowledge / Artifact / evaluation / branch cleanupまでほぼ収束しています。

- main: 36cd4af96ff3174fb165e55c0148ad2439dab38b
- Open Issue: 0
- Open PR: 0
- Artifact v2: 41/41全面監査完了。唯一のF-001も修正・独立validation・main merge済み
- Knowledge migration / provenance: #29 / #30をcurrent authority基準で再評価しclose。未回収provenanceは「未解決だがnon-blocking」として明示的に残している
- 旧evaluation backlog: #135〜#144はcurrent mainへ全て収束済み。current defectなし
- merged remote branch cleanup: 68本をatomic delete済み
- 現在のremote branches: 18本 = main + historical 17本
- historical 17本: #186で全件監査済み。KEEP_AS_BRANCH=0
- archive tags: 17本すべてannotated tagとして作成済み
- tag target: 17/17が各branchのexact HEADへ正しくpeelすることを独立確認済み
- unique historical commits: 合計387件。archive tagから保持されている
- #186: closed / completed
- #187: closed / completed
- repository files / main: archive作業では変更なし

現在は意図的に、

    main
    +
    17 historical branches
    +
    17 annotated archive tags

という冗長で安全な状態です。

残る最後のrepository hygieneは、archive tagで履歴保存が完了した17本のhistorical branchを削除することです。ただしこれはまだ実行していません。

次に進める場合は、

    17 branch HEAD再確認
    ↓
    17 archive tagのpeeled target再確認
    ↓
    387 unique commitsのreachability確認
    ↓
    dry-run
    ↓
    17 branchをatomic delete
    ↓
    最終状態 = mainだけ + archive tags 17本

という専用TASKになります。

つまり、実装・監査上の未解決Issueは現在ゼロで、残っているのは最後のbranch整理だけという状態です。

### ユーザー

githubの履歴にはのこるんだっけ

### ChatGPT

残ります。今回のやり方なら、17本のbranchを削除しても、そのbranch固有のGit履歴は消えません。

理由は、削除前に各branchのHEADへannotated tagを作ったからです。

    historical branch
        ↓
    HEAD
        ↓
    そのbranch固有の過去commits

    archive tag ──→ 同じHEAD

なのでbranch refを消しても、

    archive/branches/docs/knowledge-structure
        ↓
    e595228...
        ↓
    その祖先commit全部

という到達経路が残ります。

今回でいうと、17個のarchive tagによって、合計387個のunique commitが保持される状態まで確認済みです。

ただし「mainの履歴に入る」という意味ではありません。たとえば、

    git log main

だけでは、その17branch固有のcommitは出てこないものがあります。

一方で、

    git log archive/branches/docs/knowledge-structure

なら、その当時の履歴を辿れますし、GitHubでもarchive tagやcommit SHAから参照できます。

つまりbranch削除後は、

    Branches
      mainだけ

    Tags
      archive/branches/... × 17

    Git objects
      historical commitsも保持

という整理になります。

逆に、将来archive tagまで削除して、ほかのrefからも到達不能にすると、そのcommitは永続保持を保証できなくなります。だから今回の17 tagは、言ってみれば「branchを消しても歴史を残すための保管札」です。

なので今なら、17 historical branchを消しても履歴を失わずにGitHubのbranch一覧だけ綺麗にできます。
