#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -----------------------------------------------------------------------------
# NAME: git-cleanup.sh
# DESCRIPTION: Switches to main branch, pulls latest changes, and deletes
#              the current branch if it has been merged
# USAGE: ./git-cleanup.sh
#
# This script is intended to be run from a Git feature branch. It ensures
# that your main branch is up to date, and removes the current branch cleanly
# if it's no longer needed.
# -----------------------------------------------------------------------------

branch=$(git symbolic-ref --short HEAD)

if [ "$branch" = "main" ]; then
    echo "You're already on main - nothing to clean."
    exit 0
fi

echo "Cleaning branch: $branch"
git switch main
git pull
git branch -d "$branch"

