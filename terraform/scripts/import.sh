#!/usr/bin/env bash
# Import existing GitHub repositories into Terraform state so that `apply`
# updates them in place instead of failing to re-create them.
#
#   ./scripts/import.sh repo-one repo-two repo-three
#
# Run from the terraform/ directory after `terraform init`.
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <repo-name> [<repo-name> ...]" >&2
  exit 1
fi

for repo in "$@"; do
  echo ">> importing ${repo}"
  terraform import "github_repository.this[\"${repo}\"]" "${repo}"
done

echo "Done. Run 'terraform plan' to review any drift."
