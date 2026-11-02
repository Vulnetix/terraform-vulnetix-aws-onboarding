#!/usr/bin/env bash
# Copy the bootstrap template from vdb-site main, the copy the console
# deploys, so this module deploys the same stack. Run from a checkout that
# has Vulnetix/vdb-site beside it:
#
#   scripts/sync-template.sh [path/to/vdb-site]
set -euo pipefail
src="${1:-../vdb-site}"
git -C "$src" fetch -q origin main
rev="$(git -C "$src" rev-parse --short origin/main)"
out="$(dirname "$0")/../templates/aws-bootstrap.yaml"
{
  echo "# Copied from Vulnetix/vdb-site api/internal/handler/assets/aws-bootstrap.yaml"
  echo "# at $rev by scripts/sync-template.sh. Do not edit here: change it there and re-sync,"
  echo "# so this module and the console deploy the same stack."
  git -C "$src" show origin/main:api/internal/handler/assets/aws-bootstrap.yaml
} >"$out"
echo "templates/aws-bootstrap.yaml now matches vdb-site $rev"
