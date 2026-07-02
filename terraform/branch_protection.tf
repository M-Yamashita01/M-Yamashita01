# Branch protection for the default branch of each opted-in repository.
# NOTE: Branch protection / rulesets on PRIVATE personal repositories require a
# paid plan (GitHub Pro or higher). On the Free plan this only works for PUBLIC
# repositories. Set `protect_default_branch = false` where it does not apply.
resource "github_branch_protection" "default_branch" {
  for_each = {
    for name, cfg in local.repositories : name => cfg
    if cfg.protect_default_branch
  }

  repository_id = github_repository.this[each.key].node_id
  pattern       = each.value.default_branch

  enforce_admins                  = false
  allows_deletions                = false
  allows_force_pushes             = false
  require_conversation_resolution = true

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_approvals > 0 ? [1] : []
    content {
      required_approving_review_count = each.value.required_approvals
      dismiss_stale_reviews           = true
    }
  }

  dynamic "required_status_checks" {
    for_each = length(each.value.required_checks) > 0 ? [1] : []
    content {
      strict   = true
      contexts = each.value.required_checks
    }
  }
}
