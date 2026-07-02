locals {
  # Merge each repository's explicit settings over the shared defaults.
  repositories = {
    for name, cfg in var.repositories : name => {
      description  = cfg.description
      homepage_url = cfg.homepage_url
      topics       = cfg.topics
      archived     = cfg.archived

      visibility             = coalesce(cfg.visibility, var.defaults.visibility)
      has_issues             = cfg.has_issues != null ? cfg.has_issues : var.defaults.has_issues
      has_projects           = cfg.has_projects != null ? cfg.has_projects : var.defaults.has_projects
      has_wiki               = cfg.has_wiki != null ? cfg.has_wiki : var.defaults.has_wiki
      allow_merge_commit     = cfg.allow_merge_commit != null ? cfg.allow_merge_commit : var.defaults.allow_merge_commit
      allow_squash_merge     = cfg.allow_squash_merge != null ? cfg.allow_squash_merge : var.defaults.allow_squash_merge
      allow_rebase_merge     = cfg.allow_rebase_merge != null ? cfg.allow_rebase_merge : var.defaults.allow_rebase_merge
      allow_auto_merge       = cfg.allow_auto_merge != null ? cfg.allow_auto_merge : var.defaults.allow_auto_merge
      delete_branch_on_merge = cfg.delete_branch_on_merge != null ? cfg.delete_branch_on_merge : var.defaults.delete_branch_on_merge
      vulnerability_alerts   = cfg.vulnerability_alerts != null ? cfg.vulnerability_alerts : var.defaults.vulnerability_alerts
      default_branch         = coalesce(cfg.default_branch, var.defaults.default_branch)

      manage_renovate        = cfg.manage_renovate
      protect_default_branch = cfg.protect_default_branch
      required_approvals     = cfg.required_approvals
      required_checks        = cfg.required_checks
    }
  }
}
