resource "github_repository" "this" {
  for_each = local.repositories

  name         = each.key
  description  = each.value.description
  homepage_url = each.value.homepage_url
  topics       = each.value.topics
  visibility   = each.value.visibility
  archived     = each.value.archived

  has_issues   = each.value.has_issues
  has_projects = each.value.has_projects
  has_wiki     = each.value.has_wiki

  allow_merge_commit     = each.value.allow_merge_commit
  allow_squash_merge     = each.value.allow_squash_merge
  allow_rebase_merge     = each.value.allow_rebase_merge
  allow_auto_merge       = each.value.allow_auto_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge

  vulnerability_alerts = each.value.vulnerability_alerts

  # Ensures newly created repos have a default branch so branch protection and
  # renovate.json can be applied. Ignored for already-existing (imported) repos.
  auto_init = true

  lifecycle {
    # Safety net: stop Terraform from deleting a real repository (and its code)
    # if an entry is removed from the map or `terraform destroy` is run.
    # Comment this out deliberately when you truly intend to delete a repo.
    prevent_destroy = true

    ignore_changes = [
      auto_init, # only meaningful at creation time
    ]
  }
}
