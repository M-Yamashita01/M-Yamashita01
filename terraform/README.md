# GitHub リポジトリ設定の Terraform 管理

個人 GitHub アカウント配下のリポジトリ設定（可視性・マージ方式・ブランチ保護・
Renovate 設定など）を、画面をぽちぽちせずコードで一括管理するための Terraform モジュールです。
`integrations/github` プロバイダと `for_each` を使い、共通設定をまとめて全リポジトリへ適用します。

## 管理できるもの

- リポジトリ本体の設定（`github_repository`）: description / topics / 可視性 / Issues・Wiki・Projects の有効化 / マージ方式（squash のみ許可など）/ `delete_branch_on_merge` / 脆弱性アラート
- デフォルトブランチのブランチ保護（`github_branch_protection`）: レビュー必須数・必須ステータスチェック・force push 禁止・会話解決必須 など
- `renovate.json` の配置（`github_repository_file`）: 全リポジトリへ同じ Renovate 設定をコードで配布

## 前提

- Terraform >= 1.5
- GitHub Personal Access Token (classic)。最低 `repo` スコープ（削除も管理するなら `delete_repo`、
  ワークフローファイルを触るなら `workflow` も付与）
- **プラン制約**: private リポジトリでブランチ保護 / ruleset を使うには **GitHub Pro 以上の有料プラン** が必要です。
  Free プランでは public リポジトリのみ有効。該当する場合は `protect_default_branch = false` にしてください。

## 使い方

```bash
cd terraform

# 1. トークンは環境変数で渡す（ファイルにコミットしない）
export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx

# 2. 管理対象を定義
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars

# 3. 初期化
terraform init

# 4. 既存リポジトリを import（重要 / 下記参照）
./scripts/import.sh repo-one repo-two

# 5. 差分確認 & 適用
terraform plan
terraform apply
```

## 既存リポジトリの import（重要）

このモジュールは `github_repository` リソースを宣言します。**すでに存在する**リポジトリを
`terraform.tfvars` に書いてそのまま `apply` すると、Terraform は新規作成しようとして
`name already exists` で失敗します。既存リポジトリは必ず state に import してください。

```bash
# terraform.tfvars の repositories キーごとに実行
terraform import 'github_repository.this["repo-name"]' repo-name

# まとめて実行する場合
./scripts/import.sh repo-one repo-two repo-three
```

import 後に `terraform plan` を実行すると、現状と `terraform.tfvars` の設定との差分が確認できます。
まずは `defaults` を現状に近づけ、意図した差分だけが出る状態にしてから `apply` するのが安全です。

## 新しいリポジトリを追加する

`terraform.tfvars` の `repositories` にキーを追加して `apply` するだけです。
新規リポジトリは `auto_init = true` により初期化され、`renovate.json` とブランチ保護も自動で適用されます。

```hcl
repositories = {
  "my-new-service" = {
    description     = "New service"
    topics          = ["go"]
    required_checks = ["build", "test"]
  }
}
```

## 設定の優先順位

各リポジトリの値は `defaults` を上書きします（未指定の項目は `defaults` を継承）。
共通で変えたいものは `defaults` を、個別に変えたいものは各リポジトリ側を編集してください。

## 安全策

`github_repository` には `lifecycle { prevent_destroy = true }` を設定しています。
`terraform destroy` やマップからのエントリ削除で**実在するリポジトリが消えるのを防ぎます**。
本当に削除したいときだけ、意図的にこの行を外してください。

## state の扱い

デフォルトはローカル state です。チームで共有したり紛失を防ぎたい場合は、
`versions.tf` の `backend` ブロックを有効化してリモート state（S3 など）を設定してください。
`.gitignore` により `*.tfstate` と実 `*.tfvars` はコミットされません。
