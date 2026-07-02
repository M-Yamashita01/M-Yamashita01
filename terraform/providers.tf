provider "github" {
  owner = var.github_owner
  # If github_token is null, the provider falls back to the GITHUB_TOKEN
  # environment variable. Prefer the env var so tokens never touch the repo.
  token = var.github_token
}
