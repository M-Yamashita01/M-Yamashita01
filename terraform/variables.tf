variable "github_owner" {
  description = "GitHub personal account (username) that owns the repositories."
  type        = string
  default     = "M-Yamashita01"
}

variable "github_token" {
  description = <<-EOT
    GitHub Personal Access Token (classic) with at least the `repo` scope
    (add `delete_repo` and `workflow` if you manage deletions / workflow files).
    Leave null and export GITHUB_TOKEN instead of committing a token.
  EOT
  type        = string
  default     = null
  sensitive   = true
}

variable "defaults" {
  description = "Baseline settings applied to every managed repository. Per-repository values override these."
  type = object({
    visibility             = optional(string, "private")
    has_issues             = optional(bool, true)
    has_projects           = optional(bool, false)
    has_wiki               = optional(bool, false)
    allow_merge_commit     = optional(bool, false)
    allow_squash_merge     = optional(bool, true)
    allow_rebase_merge     = optional(bool, false)
    allow_auto_merge       = optional(bool, true)
    delete_branch_on_merge = optional(bool, true)
    vulnerability_alerts   = optional(bool, true)
    default_branch         = optional(string, "main")
  })
  default = {}
}

variable "repositories" {
  description = "Repositories to manage. Map key = repository name. Any field left unset inherits from `defaults`."
  type = map(object({
    description            = optional(string, "")
    homepage_url          = optional(string, "")
    topics                = optional(list(string), [])
    archived              = optional(bool, false)
    visibility            = optional(string)
    has_issues            = optional(bool)
    has_projects          = optional(bool)
    has_wiki              = optional(bool)
    allow_merge_commit    = optional(bool)
    allow_squash_merge    = optional(bool)
    allow_rebase_merge    = optional(bool)
    allow_auto_merge      = optional(bool)
    delete_branch_on_merge = optional(bool)
    vulnerability_alerts  = optional(bool)
    default_branch        = optional(string)

    # Behaviour toggles handled by this module (not raw provider fields):
    manage_renovate        = optional(bool, true)  # place/manage renovate.json
    protect_default_branch = optional(bool, true)  # create branch protection
    required_approvals     = optional(number, 0)   # 0 = no review required
    required_checks        = optional(list(string), []) # required status check contexts
  }))
  default = {}
}
