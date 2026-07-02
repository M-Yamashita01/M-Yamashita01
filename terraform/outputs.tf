output "repository_urls" {
  description = "HTML URL of every managed repository."
  value       = { for name, repo in github_repository.this : name => repo.html_url }
}

output "managed_repositories" {
  description = "Names of all repositories managed by this module."
  value       = keys(github_repository.this)
}
