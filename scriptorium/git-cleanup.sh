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

# Swicth to main and update
git switch main
git pull

# Check if the branch was merged before deleting
if git branch --merged | grep -q "\b$branch\b"; then
    echo "Branch '$branch' is merged - deleting it."
    git branch -d "$branch"
else
    echo "Branch '$branch' in NOT merged into main!"
    echo "Use 'git branch -D $branch' to force delete if you are sure."
    exit 1
fi

