# Workspace Structure / Work Identity alignment

```yaml
記録種別: "第0情報源からの原文記録"
情報源: "ChatGPT会話"
記録日: "2026-09-22"
原文言語: "日本語"
編集方針: "原文本文は無要約・無抜粋・無言い換え"
```

## ユーザー原文

```text
修正を行って
```

## 直前に承認された修正案の原文

```text
1. workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
   - Task_Worktree を現行基本用語から削除
   - 旧 .worktrees/<component>/<task> 構造を削除
   - Project Repository / Project Root とWorkspace Repositoryの対応を追加
   - .worktrees/ はWork Identity-owned namespaceとしてだけ記述

2. workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
   - .worktrees/ 全ignoreを撤回
   - Work Documents tracking / repository worktree ignoreの境界へ修正
   - Primary Checkout の意味をstatic repository resolutionに限定
   - stable repository identityとREPO selectorの接続を明文化

3. workspace-structure/S003_HISTORY.md
   - 削除した旧Task Worktree / old path / old ignore semanticsをこちらへ保存

work-identity 側は、大きな修正は不要。
INDEXかS002あたりに「Project Repository / Project Rootの静的定義はworkspace-structureを参照」と一文足す。
```
