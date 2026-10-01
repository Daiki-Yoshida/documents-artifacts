> 監査参照用翻訳（非正本）。原文: `artifacts/safety/DIAGNOSTICS_AND_RECOVERY.md`（commit `93b0fab575f28698e61ae56202004eeab75d6861`）。[固定GitHub版](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/artifacts/safety/DIAGNOSTICS_AND_RECOVERY.md)。翻訳: GPT-6-Luna high。

# 診断と復旧

開発環境/操作が失敗した場合に読む。

## 変更の前に観察することを優先する

次に相当する操作を提供または求める。

- help
- diagnostics
- 変更を加えないstatus
- 最終検証

診断情報に秘密情報を出力してはならない。

選択されたリポジトリ/checkoutを示す。また、該当する場合はWork Identity、worktree、runtime namespace、ポート、mount、所有権を示す。

## 順番に診断する

```yaml
1_target: "ワークスペース/コンポーネント/ブランチ/checkout/worktree"
2_host_boundary: "必要なcontrol-planeツールと権限"
3_versions: "コンテナ/runtime/ツール/lockの状態"
4_runtime: "コンテナ/ネットワーク/ポート/mount/所有権/ボリューム"
5_command: "公開コマンドのパラメーターと終了ステータス"
6_git: "dirty状態、ブランチ所有権、worktreeメタデータ、リモート参照"
7_ci_difference: "プロバイダー設定または外部ワークスペース参照の不一致"
```

## 復旧ルール

- 影響を受けたWorkスコープのリソースだけを修復/再作成することを優先する
- 再ビルド/削除の前にソース変更を保持する
- forceを使う前に失敗内容を理解する
- 最初からグローバルなDocker pruneや広範囲のファイル削除を行わない
- 失敗したレイヤーと根拠を報告する
- 失敗した操作を再実行して成功するまでは、復旧完了と判断してはならない。再実行がブロックされているか、許可されていない場合は、補助的な確認に置き換えたり、安全でない効果を繰り返したりせず、復旧は未検証/未完了と報告する
