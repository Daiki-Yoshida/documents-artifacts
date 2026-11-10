# Stage 2-A-1：旧subjectsの全件確認台帳

**状態：作業中。** この台帳はファイルの確認状況を記録するもので、哲学としての分類や意味の承認を表さない。

- 調査対象：旧 `Daiki-Yoshida/documents-artifacts` の `main@7ad8bb4f948359633003a47fa6bfcc8d6853ddb6` に固定した `documents/knowledge/subjects/`。
- 対象は **70ファイル（INDEX 10件・本文leaf 60件）**。
- **全文取得・初期確認済み31件、未確認39件**。意味を全件抽出・保存できたという主張ではない。
- HISTORYを含め、旧subjectsに哲学・方法論が混在する可能性を排除しない。
- `全文確認済み` はGitHubから本文全体を取得して初期レビューを行ったという意味であり、recordsとの根拠照合まで済んだことを意味しない。
- `未確認` はこの段階で本文レビューを実施していないという意味。
- 英語の初稿は[言語是正記録](A1_A2_LANGUAGE_CORRECTION.md)に示す理由で不適切。粗哲学候補は[日本語版](A1_ROUGH_PHILOSOPHY.md)を使用する。
- 旧ファイル本文・blob SHA・調査時点は変更せず、調査の管理情報だけを日本語化する。

| 旧subjectsファイル | Git blob SHA | A-1での確認状況 |
| --- | --- | --- |
| `documents/knowledge/subjects/code-design/INDEX.md` | `71ba2e2dcd84ee5e878cdab32d5681ec7748e95c` | 全文確認済み |
| `documents/knowledge/subjects/code-design/S001_REALIZATION_MODEL.md` | `fba5508a074f1666454cb739a8a2f6bec3a19db9` | 全文確認済み |
| `documents/knowledge/subjects/code-design/S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md` | `39d211f532f337f693392444df2c21f8070d0399` | 全文確認済み |
| `documents/knowledge/subjects/code-design/S003_INHERITANCE_BOUNDARY.md` | `5dda82400f7e02e2bc841059ed555b58dce94726` | 全文確認済み |
| `documents/knowledge/subjects/code-design/S004_STATE_OWNERSHIP_AND_CONSISTENCY.md` | `a95abff26fed351b8399d8e1c38d8cd26da49ab3` | 全文確認済み |
| `documents/knowledge/subjects/code-design/S005_CODE_STRUCTURE.md` | `d455a1efedcd4cb0e318518c8a4bd36da5562e15` | 未確認 |
| `documents/knowledge/subjects/code-design/S006_DEPENDENCY_AND_EXTERNALS.md` | `a1b2890806e185ee3fbed8e6d9d4ebf1d2eb09ad` | 未確認 |
| `documents/knowledge/subjects/code-design/S007_DOMAIN_AND_DATA_BOUNDARIES.md` | `7eb244850708ce8c6b2d14645372da1dffc6e6ac` | 未確認 |
| `documents/knowledge/subjects/code-design/S008_FAILURE_ASYNC_AND_CONTRACTS.md` | `1c0d8b68b1a1cc20961dec35418167933ed92eca` | 未確認 |
| `documents/knowledge/subjects/code-design/S009_TESTING_AND_RUNTIME.md` | `6317a00df75f940ac7c88a4cf43091f95cf0b53d` | 未確認 |
| `documents/knowledge/subjects/code-design/S010_COMPATIBILITY_AND_VERIFICATION.md` | `916f13ca401069a632a95b8a44d56726b137ccd1` | 未確認 |
| `documents/knowledge/subjects/code-design/S011_PERFORMANCE_SHAPED_INTERACTION.md` | `fce8fdcdc13f7a9955c96443d512a9c0376e5657` | 未確認 |
| `documents/knowledge/subjects/code-design/S012_DESIGN_PRIORITY.md` | `8b55eac6f186c7e73aee880d15fd4c7403f9e218` | 全文確認済み |
| `documents/knowledge/subjects/code-design/S013_HISTORY.md` | `fc97774e92806f33edd9a4e6e4b1cca72f532710` | 未確認 |
| `documents/knowledge/subjects/context-shaping/INDEX.md` | `6471752cb334efdaa42df958069cd87eff0f338e` | 全文確認済み |
| `documents/knowledge/subjects/context-shaping/S001_POSITIVE_FIRST_CONTEXT.md` | `409f39494a90c0ffdc7e4288991338fc8b531322` | 全文確認済み |
| `documents/knowledge/subjects/context-shaping/S002_NEGATIVE_ALTERNATIVE_LEAKAGE.md` | `e9b32f3d9865df5189929647cfb413d227fb7580` | 全文確認済み |
| `documents/knowledge/subjects/context-shaping/S003_APPLICABILITY_AND_GUARDS.md` | `7c060fdc0638afefe21ec06c70827492bca0ffa6` | 全文確認済み |
| `documents/knowledge/subjects/development-execution/INDEX.md` | `a11f43ce927bf288d6d5a17c5d83aab8c73de6ec` | 全文確認済み |
| `documents/knowledge/subjects/development-execution/S001_EXECUTION_MODEL.md` | `43076ae1d27354d6be85108ed827ca7cfab4f0a0` | 全文確認済み |
| `documents/knowledge/subjects/development-execution/S002_HOST_AND_CONTAINER.md` | `258843291b553ea47b7ecc3716a9f6b0808c2cf1` | 未確認 |
| `documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md` | `3ec48a9415abbfe105d46a4cfbb9fb5be77dd7c3` | 未確認 |
| `documents/knowledge/subjects/development-execution/S004_ADOPTION_AND_MIGRATION.md` | `f3a3a4c37daebae43d12b2e15499cde3465e8f06` | 未確認 |
| `documents/knowledge/subjects/development-execution/S005_HISTORY.md` | `b6aa399a0585e3ff160b6b5c085c40758c667d6e` | 未確認 |
| `documents/knowledge/subjects/development-safety/INDEX.md` | `5232f95315a61dde88cb7a9b49210e843cff2435` | 全文確認済み |
| `documents/knowledge/subjects/development-safety/S001_SAFETY_PRINCIPLES.md` | `f7329cf4f4036395bb256a1169af26f58af41783` | 全文確認済み |
| `documents/knowledge/subjects/development-safety/S002_DESTRUCTIVE_OPERATIONS.md` | `de60d9e68cf83f81ee853aad780c240e63621eea` | 未確認 |
| `documents/knowledge/subjects/development-safety/S003_DIAGNOSTICS_AND_RECOVERY.md` | `f4db7280eaef3c731d09158fcf91fb73c1005d08` | 未確認 |
| `documents/knowledge/subjects/development-safety/S004_INTEGRATION.md` | `328ab34b716733491dc9c602d45b9a0f08bc71c6` | 未確認 |
| `documents/knowledge/subjects/development-safety/S005_CONFIRMATION_AND_REREAD.md` | `507cf56a35883788ea2deccfb47698ed68263f49` | 未確認 |
| `documents/knowledge/subjects/documentation/INDEX.md` | `19cb79f69b4626bb12d7d00ca7ab05a2a222d368` | 全文確認済み |
| `documents/knowledge/subjects/documentation/S001_PRINCIPLES.md` | `dce81d192ef91498c03085a7e8cc7dfc7d11075f` | 全文確認済み |
| `documents/knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md` | `73ec819c47dba71fd40a1576c5eb35a368c01da1` | 未確認 |
| `documents/knowledge/subjects/documentation/S003_WORKFLOW.md` | `97fc2284d1a1105de43e9aef036d948e7b2a6a88` | 未確認 |
| `documents/knowledge/subjects/documentation/S004_MAINTENANCE_AND_REVIEW.md` | `6c5fba4699da5542e03a47655193e7622e61391a` | 未確認 |
| `documents/knowledge/subjects/documentation/S005_FORMAT_AND_GIT.md` | `f2414415efb3b9f4d6f6fee7e33484f8164fcaa5` | 未確認 |
| `documents/knowledge/subjects/documentation/S006_HISTORY.md` | `6de0a440d464be3ef60836a771bc6ef1f498d1a4` | 未確認 |
| `documents/knowledge/subjects/encapsulation-horizon/INDEX.md` | `614a09755a4dac96615df32900fc752503e8153b` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S001_CORE_PRINCIPLE.md` | `602a7213f96cbacd8f04d852a5f77ded3689f886` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S002_RESPONSIBILITY_AND_HORIZON.md` | `17c5c9d43d44166b8d00cece943bacfb40bc98bd` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S003_HARDENING_POLICY.md` | `de921b79f4832741ad7350be013481b3b610f85c` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S004_CONCEPT_ALTITUDE.md` | `5241fbbac6a20c78adae1100e8aaf0fe8edaefe0` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` | `71e48c95239dfd1c83270268655d4ec23377165b` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S006_EVOLUTION_AND_GRADUATION.md` | `7225dd5689f1839469d4163beaaa31eca6898cbb` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S007_GLOSSARY.md` | `9182bab453dd7951d5d2e0b9a62e98099bb8187b` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S008_OPERATIONAL_GUARDS.md` | `a82f100ca19b609e9c29815df2848b898d8bd684` | 全文確認済み |
| `documents/knowledge/subjects/encapsulation-horizon/S009_HISTORY.md` | `d7d8b47e537e3b14637400a8e561344f7264fc48` | 未確認 |
| `documents/knowledge/subjects/engineering-operation/INDEX.md` | `a59e4847d23caf5b596b745c8b3528a6bdd3ae6f` | 全文確認済み |
| `documents/knowledge/subjects/engineering-operation/S001_CHANGE_LIFECYCLE.md` | `87338c4d7597cc0a164e86dff32b856a0ea4baae` | 未確認 |
| `documents/knowledge/subjects/engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md` | `191729a68df627463ec5f949f4f3aed2e92e4e59` | 全文確認済み |
| `documents/knowledge/subjects/engineering-operation/S003_PRE_IMPLEMENTATION_SCAN.md` | `34914576ac4fc932ac13f9529673f883de71aaa5` | 未確認 |
| `documents/knowledge/subjects/engineering-operation/S004_CONFIRMATION_AND_ROUTING.md` | `676a583ce07574ca9588b3a08bfe6de2914d150c` | 未確認 |
| `documents/knowledge/subjects/engineering-operation/S005_VERIFICATION_AND_DONE.md` | `175425f0cb563501f70a81b00a90171c14eeb405` | 未確認 |
| `documents/knowledge/subjects/engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md` | `8f3defd98a5caeaddde7a37b72b505fccb550352` | 未確認 |
| `documents/knowledge/subjects/engineering-operation/S007_BROWNFIELD_AND_APPROACH.md` | `d4deb8bc5a479bf986c6194b98ee1db762d48b46` | 未確認 |
| `documents/knowledge/subjects/engineering-operation/S008_HISTORY.md` | `af6b5148908d15484e3b2b45a141c50b71ab2ab2` | 未確認 |
| `documents/knowledge/subjects/INDEX.md` | `e14a6949c8260d2bc2266b604eb5f235a72415a1` | 全文確認済み |
| `documents/knowledge/subjects/work-identity/INDEX.md` | `6f9676e7af893935412553491d4bbfa282068d93` | 全文確認済み |
| `documents/knowledge/subjects/work-identity/S001_IDENTITY_MODEL.md` | `a5228c66eaa7eb0bc86750146ff92d65ec2d1212` | 全文確認済み |
| `documents/knowledge/subjects/work-identity/S002_WORK_ROOT_AND_REPOSITORIES.md` | `098cf3c4e722f636bd732480da61050c95f2c7a3` | 未確認 |
| `documents/knowledge/subjects/work-identity/S003_WORK_DOCUMENTS.md` | `ca3a81f08e0b69dfee242df889c61c44f1f17c79` | 未確認 |
| `documents/knowledge/subjects/work-identity/S004_LIFECYCLE_AND_RESOURCES.md` | `2d9efb63c82e05df9c41e8ead23bcf4ef5c59172` | 未確認 |
| `documents/knowledge/subjects/work-identity/S005_WORKTREE_MATERIALIZATION.md` | `6af1698485f094381ef8f41bbe1a0f68c3aba48f` | 未確認 |
| `documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md` | `a129f366e4076872a3ee8ee8b028adc107e798e9` | 未確認 |
| `documents/knowledge/subjects/work-identity/S007_VALIDATION.md` | `d01fcce15a4b5c4a529e664d9fcf3306e49dc107` | 未確認 |
| `documents/knowledge/subjects/work-identity/S008_HISTORY.md` | `85c75aef5aa79fb16f441e415ede7289bb7df613` | 未確認 |
| `documents/knowledge/subjects/workspace-structure/INDEX.md` | `8966db46e078086ac82d2b40c0d1b6b91936efe5` | 全文確認済み |
| `documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md` | `05477df5481790876c38a8881fae292bacb17c30` | 未確認 |
| `documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md` | `544486be85f4e8fe283ba448e46343cd643c8d1f` | 未確認 |
| `documents/knowledge/subjects/workspace-structure/S003_HISTORY.md` | `b01974487f0e25ebd0c0049b3fa12227f1f6e686` | 未確認 |

## 今後の確認

[粗哲学候補（未承認）](A1_ROUGH_PHILOSOPHY.md)は日本語原文から再検討した暫定の抽出。残り39ファイルを含む全70ファイルについて、意味ある主張の所在と取り扱いを確認するまでA-1を完了としない。
