#!/usr/bin/env bash
# Create one GitHub issue for each case/question whose answer is still `TODO`.
#
# Idempotent: skips any item whose title already matches an existing issue
# (open or closed). Safe to re-run after new TODOs are added.
#
# Requirements:
#   - `gh` CLI installed and authenticated (`gh auth login`)
#   - Run from inside this repository
#
# Usage:
#   ./scripts/create-todo-issues.sh            # create issues
#   DRY_RUN=1 ./scripts/create-todo-issues.sh  # preview without creating

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

if ! command -v gh >/dev/null 2>&1; then
    echo "error: gh CLI is not installed. See https://cli.github.com/" >&2
    exit 1
fi

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

# Snapshot of existing titles so we don't duplicate.
mapfile -t EXISTING < <(gh issue list --state all --limit 1000 --json title -q '.[].title')

is_existing() {
    local title="$1"
    local t
    for t in "${EXISTING[@]}"; do
        [[ "$t" == "$title" ]] && return 0
    done
    return 1
}

# True iff the first non-empty line under `## Answer` is exactly `TODO`.
is_todo() {
    awk '
        /^## Answer/ { in_answer = 1; next }
        in_answer && NF { print; exit }
    ' "$1" | grep -qx 'TODO'
}

# First bold question line, with markers stripped and trimmed to the first sentence.
# Matches both `**...` at start of line and list-prefixed `- **...` / `* **...`.
extract_snippet() {
    awk '
        /^\*\*/ || /^[-*]+[ \t]+\*\*/ {
            line = $0
            sub(/^[-*]+[ \t]+/, "", line)
            gsub(/\*\*/, "", line)
            sub(/[?.!].*/, "", line)
            gsub(/^[ \t]+|[ \t]+$/, "", line)
            print line
            exit
        }
    ' "$1"
}

# Everything up to (but not including) `## Answer`, followed by a source link.
make_body() {
    local file="$1"
    local url="https://github.com/$REPO/blob/main/$file"
    awk '/^## Answer/ { exit } { print }' "$file"
    printf '\n---\n\nSource file: [`%s`](%s)\n\nReplace the `TODO` placeholder in that file with your answer.\nSee the [README](https://github.com/%s/blob/main/README.md) for contribution guidelines.\n' \
        "$file" "$url" "$REPO"
}

process() {
    local file="$1"
    is_todo "$file" || return 0

    local slug snippet title
    slug=$(basename "$file" .md)
    snippet=$(extract_snippet "$file")

    if [[ -n "$snippet" ]]; then
        if (( ${#snippet} > 80 )); then
            snippet="${snippet:0:77}..."
        fi
        title="$slug: $snippet"
    else
        title="Solve $slug"
    fi

    if is_existing "$title"; then
        printf 'skip    %s\n' "$title"
        return 0
    fi

    if [[ "${DRY_RUN:-}" == "1" ]]; then
        printf 'would   %s\n' "$title"
        return 0
    fi

    local body
    body=$(make_body "$file")
    gh issue create --title "$title" --body "$body" >/dev/null
    printf 'created %s\n' "$title"
}

for f in cases/case-*.md questions/question-*.md; do
    process "$f"
done
