#!/usr/bin/env bash
set -euo pipefail

# Create GitHub issues from markdown files under .github/issues using GITHUB_TOKEN
# Usage: REPO=owner/repo ./scripts/create_issues_with_token.sh

ISSUES_DIR=".github/issues"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN not set in environment. Export a token with 'repo' or 'public_repo' scope." >&2
  exit 1
fi

if [ -z "${REPO:-}" ]; then
  ORIGIN=$(git remote get-url origin 2>/dev/null || true)
  if [ -z "$ORIGIN" ]; then
    echo "Set REPO=owner/repo or configure git remote 'origin'." >&2
    exit 1
  fi
  REPO=$(echo "$ORIGIN" | sed -E 's#git@github.com:(.*).git#\1#; s#https://github.com/(.*).git#\1#; s#https://github.com/(.*)#\1#')
fi

echo "Creating issues in repo: $REPO"

for f in "$ISSUES_DIR"/*.md; do
  [ -e "$f" ] || continue
  title=$(sed -n '1p' "$f" | sed 's/^# *//')
  second_line=$(sed -n '2p' "$f" || true)
  labels=()
  body=$(tail -n +3 "$f" | sed -e 's/^/\n/')

  if echo "$second_line" | grep -qi '^Labels:'; then
    # parse labels into JSON array
    raw=$(echo "$second_line" | sed -E 's/Labels:\s*//I' | tr -d '\r')
    # split by comma or space
    IFS=',' read -ra parts <<< "$raw"
    labels_json="["
    first=true
    for p in "${parts[@]}"; do
      # trim
      lab=$(echo "$p" | sed -E 's/^\s+|\s+$//g')
      if [ -n "$lab" ]; then
        if [ "$first" = true ]; then
          labels_json+="\"$lab\""
          first=false
        else
          labels_json+=", \"$lab\""
        fi
      fi
    done
    labels_json+"]"
  else
    labels_json="[]"
  fi

  payload=$(jq -n --arg t "$title" --arg b "$body" --argjson lbs "$labels_json" '{title: $t, body: $b, labels: $lbs}')

  echo "- Creating: $title"
  resp=$(curl -sS -w "\n%{http_code}" -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$REPO/issues \
    -d "$payload") || true

  http=$(echo "$resp" | tail -n1)
  body_resp=$(echo "$resp" | sed '$d')

  if [ "$http" = "201" ]; then
    url=$(echo "$body_resp" | jq -r .html_url)
    echo "  Created: $url"
  else
    echo "  Failed (HTTP $http):" >&2
    echo "$body_resp" | jq -r '.message, .errors[]?.message' 2>/dev/null || echo "$body_resp"
    echo "  --- file: $f ---" >&2
  fi

  sleep 0.3
done

echo "Done. Review created issues on GitHub."
