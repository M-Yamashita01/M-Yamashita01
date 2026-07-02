# Place a shared renovate.json into each opted-in repository so dependency
# update config is managed as code instead of clicked in per repo.
resource "github_repository_file" "renovate" {
  for_each = {
    for name, cfg in local.repositories : name => cfg
    if cfg.manage_renovate
  }

  repository          = github_repository.this[each.key].name
  branch              = each.value.default_branch
  file                = "renovate.json"
  content             = file("${path.module}/files/renovate.json")
  commit_message      = "chore: manage renovate config via Terraform"
  commit_author       = "Terraform"
  commit_email        = "terraform@users.noreply.github.com"
  overwrite_on_create = true
}
