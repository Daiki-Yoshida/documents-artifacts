全ての検証が完了しました。最終レポートです。

## 実施したタスク:並列 Work ランタイム対応

### 実際に読んだ artifact ファイル
- `documents/artifacts/INDEX.md`
- `documents/artifacts/project/WORKSPACE.md`, `WORKTREES.md`, `WORK_IDENTITY.md`, `WORK_LIFECYCLE.md`
- `documents/artifacts/execution/INDEX.md`, `COMMANDS_AND_CI.md`, `HOST_AND_CONTAINER.md`
- `documents/artifacts/operation/CHANGE_LIFECYCLE.md`, `VERIFICATION_AND_DONE.md`

### 実際に読んだプロジェクト内ファイル
- `documents/INDEX.md`, `documents/project/DEVELOPMENT.md`, `.worktrees/PROJECT_COORDINATION.md`, `.worktrees/feat/{schema-preview,other-work}/documents/WORK.md`
- `package.json`, `Makefile`, `compose.yml`, `Dockerfile`, `README.md`, `.gitignore`, `AGENTS.md`
- `scripts/{resource-identity,resource-check,test}.js`, `src/app.js`

### 追加した公開コマンドインターフェース
`DIR` パスロケータで対象 Work を指定します(ガイダンス推奨の Make 慣習):

```bash
make DIR=.worktrees/feat/schema-preview work-up       # Work ランタイム起動
make DIR=.worktrees/feat/schema-preview work-status   # コンテナ状態
make DIR=.worktrees/feat/schema-preview work-config   # 解決済み compose 設定のレンダリング(ドライラン)
make DIR=.worktrees/feat/schema-preview work-run ARGS="npm test"  # Work ランタイム内で任意コマンド実行
make DIR=.worktrees/feat/schema-preview work-down     # 停止(ボリューム保持)
make DIR=.worktrees/feat/schema-preview work-cleanup  # down + Work スコープの DB ボリューム削除(破壊的)
```

`DIR` は Work Root(`.worktrees/<type>/<name>`)またはその `main` チェックアウトを指すだけのパスロケータです。`scripts/work-runtime.sh` がそこから Work ID `<type>/<name>` を導出し、確認済み Work の契約(`documents/WORK.md` の存在 + `main` が登録済み git worktree であること)を検証します。ライフサイクル全操作が単一のリゾルバ(`scripts/resource-identity.js` → `scripts/work-runtime.js env`)経由で同一 ID を解決するため、起動と停止が別リソースを指すことはありません。

### リソース毎のスコーピング判断と根拠
| リソース | スコープ | 根拠 |
|---|---|---|
| toolchain image `work-runtime-dev:node20` | プロジェクト共有 | ソースは bind mount でありイメージは per-run のスナップショットではない(README / HOST_AND_CONTAINER「安全に共有可能なキャッシュ・イメージは再利用」) |
| `pkg-cache` ボリューム | プロジェクト共有 | ダウンロードキャッシュは消費者によらず同一(README 明記) |
| `db-data` ボリューム | Work スコープ `work-runtime-resources-<slug>-db-data` | タスク明記:mutable DB state を default runtime と共有しない(Work-scoped mutable state) |
| host port | Work スコープ(FNV-1a で 30000–49999 に決定的写像、8080 不可) | タスク明記:port 衝突禁止。乱数・時刻なし・Work ID から決定的導出で「run 毎に新しい Work identity を mint しない」を担保 |
| Compose project / コンテナ名 / network | Work スコープ `work-runtime-resources-<slug>` / `<slug>-net` | 両 Work のチェックアウト dir 名はどちらも `main` なので project 名を明示しないとコンテナ名 `main-app-1` が同一 daemon 上で衝突する。また Compose の通常の per-project 分離と同じで、同一 network 上での `app` エイリアス曖昧解決を避けるため network も分離 |

`compose.work.yml`(Management Root 所有のオーバーライド)を Work チェックアウトの `compose.yml` に重ねる方式を採用。**これが重要な設計点です**:最初 env 変数だけで差し込もうとしましたが、Work チェックアウトは古い `compose.yml` を持つブランチ上にあるため `DB_VOLUME_NAME`/`NETWORK_NAME` が効かないことを `work-config` のレンダリングで実際に検出し、オーバーライドファイル方式に修正しました。オーバーライドは `ports: !override` で Work ポートのみを公開し、`:?` 必須マーカーで env 欠落時に default 値へ静かにフォールバックしない(=ライフサイクル欠陥防止)ようにしています。プロジェクト側の `compose.yml` は最終的に無変更です。

### 変更・追加ファイル
- 変更: `scripts/resource-identity.js`(`workRuntime()` 実装、slug/FNV-1a ポート/`composeProject` 追加)、`Makefile`(`COMPOSE_PROJECT_NAME` export + `work-*` ターゲット)、`README.md`、`documents/project/DEVELOPMENT.md`、両 `WORK.md` の Status
- 新規: `scripts/work-runtime.js`(コンテナ内リゾルバ)、`scripts/work-runtime.sh`(ホスト側 wrapper、executable)、`compose.work.yml`
- `compose.yml` は差分なし(一度変更後、設計変更により元に復元)

### 実際に実行した検証と結果(Docker/Compose v5.3.1 利用可能)
- `make resource-check` → **全 11 項目 PASS**(実装後と最終の 2 回実行)
- `make verify` → `test: ok` + resource-check 全 PASS
- `docker run work-runtime-dev:node20 node scripts/work-runtime.js env` → schema-preview: port 44060、other-work: port 31722、決定的・一意。不正 identity は exit 2
- `work-config` → project/port/DB volume/network/pkg-cache/バインド元が全て正しいことをレンダリングで確認(`/main` 付き・末尾 `/` の DIR でも同一解決)
- `make up` + `work-up`×2 → 3 ランタイム並行起動、`curl :8080/:44060/:31722` 全て `{"status":"ok"}`
- `work-run ARGS="npm test"` → Work ランタイム内で `test: ok`
- `work-down` → Work コンテナ+network 削除・volume 保持、`work-cleanup` → Work DB volume のみ削除(共有 cache・default の volume 無傷)、`make down` → default 停止
- 不正 DIR(未指定/存在しない/Work Root 外形)→ 全て非ゼロ終了の明確なエラー
- 両 worktree チェックアウトは `git status` クリーンのまま

### 未検証・残課題
- `!override` は新しい Compose 機能(v5.3.1 で動作確認);古い Compose では非対応の可能性
- ポートはハッシュ導出のため将来の新規 Work 間で理論上 1/20000 の衝突可能性あり(確認済み 2 Work では非衝突を実測)
- 検証実行の副作用として `work-runtime-resources-net` network が残存(default runtime 用、`make down` で削除される想定内)。`work-runtime-resources-{db-data,pkg-cache}` は作業前から存在するボリュームで未変更
- ホスト Node/npm は検証には一切未使用(全て `make`/`docker compose`/toolchain コンテナ経由)
