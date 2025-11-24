#!/usr/bin/env bash
set -euo pipefail

# Creates GitHub issues from markdown files in .github/issues/
# Usage: REPO=owner/repo ./scripts/create_issues_with_gh.sh

ISSUES_DIR=".github/issues"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install from https://cli.github.com/ and run 'gh auth login'"
  exit 1
fi

# Determine repo
if [ -z "${REPO:-}" ]; then
  ORIGIN=$(git remote get-url origin 2>/dev/null || true)
  if [ -z "$ORIGIN" ]; then
    echo "Set REPO=owner/repo or configure git remote 'origin'."
    exit 1
  fi
  # convert ssh or https url to owner/repo
  REPO=$(echo "$ORIGIN" | sed -E 's#git@github.com:(.*).git#\1#; s#https://github.com/(.*).git#\1#; s#https://github.com/(.*)#\1#')
fi

echo "Creating issues in repo: $REPO"

for f in "$ISSUES_DIR"/*.md; do
  [ -e "$f" ] || continue
  title=$(sed -n '1p' "$f" | sed 's/^# *//')
  second_line=$(sed -n '2p' "$f")
  labels=""
  body=$(tail -n +3 "$f" | sed 's/^/\n/')

  # parse labels if second line starts with 'Labels:'
  if echo "$second_line" | grep -qi '^Labels:'; then
    labels=$(echo "$second_line" | sed -E 's/Labels:\s*//I' | tr -d '\r')
    # body should skip the second line
    body=$(tail -n +4 "$f")
  fi

  echo "- Creating: $title"
  if [ -n "$labels" ]; then
    gh issue create --repo "$REPO" --title "$title" --body "$body" --label $labels || true
  else
    gh issue create --repo "$REPO" --title "$title" --body "$body" || true
  fi
  sleep 0.4
done

echo "Done. Review issues on GitHub."
