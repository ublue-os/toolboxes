#!/usr/bin/env bash
set -euo pipefail

repo=$(git rev-parse --show-toplevel)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Every recorded digest must be stripped before it reaches a builder.
while IFS= read -r metadata; do
    : > "$tmp/env"
    GITHUB_ENV="$tmp/env" bash "$repo/.github/scripts/prepare-base-image.sh" "$metadata"
    expected=$(sed -n 's/^image: \([^@]*\)@.*/BASE_IMAGE=\1/p' "$metadata")
    [[ $(cat "$tmp/env") == "$expected" ]]
done < <(find "$repo/toolboxes" "$repo/apps" -name image-version.yaml)

# Malformed metadata must fail without writing environment variables.
for image in 'image: example:latest' 'image: example:latest@sha256:invalid' \
    $'image: example:latest@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\nimage: other:latest'; do
    printf '%s\n' "$image" > "$tmp/invalid.yaml"
    : > "$tmp/env"
    if GITHUB_ENV="$tmp/env" bash "$repo/.github/scripts/prepare-base-image.sh" "$tmp/invalid.yaml" 2>/dev/null; then
        echo 'Malformed metadata was accepted' >&2
        exit 1
    fi
    [[ ! -s "$tmp/env" ]]
done

# Use real commits to exercise the same diff as PRs, merge groups and pushes.
git init -q "$tmp/repo"
cd "$tmp/repo"
git config user.name 'Image update tests'
git config user.email 'test@example.com'
git -c commit.gpgsign=false commit -q --allow-empty -m base
base=$(git rev-parse HEAD)

check_change() {
    local expected=$1
    local compare_base=$2
    : > "$tmp/output"
    BASE_SHA="$compare_base" GITHUB_SHA=HEAD IMAGE_PATH=toolboxes/ubuntu-toolbox \
        WORKFLOW_PATH=.github/workflows/build-ubuntu-toolbox.yml \
        GITHUB_OUTPUT="$tmp/output" bash "$repo/.github/scripts/image-changed.sh" || return $?
    if [[ $(cat "$tmp/output") != "changed=$expected" ]]; then
        echo "Expected changed=$expected for base '$compare_base'" >&2
        exit 1
    fi
}

commit_file() {
    mkdir -p "$(dirname "$1")"
    echo change >> "$1"
    git add "$1"
    git -c commit.gpgsign=false commit -qm "Change $1"
}

check_change true ''
check_change true 0000000000000000000000000000000000000000
check_change false "$base"
commit_file toolboxes/arch-toolbox/image-version.yaml
check_change false "$base"
commit_file README.md
check_change false "$base"
commit_file toolboxes/ubuntu-toolbox/image-version.yaml
check_change true "$base"
base=$(git rev-parse HEAD)
commit_file .github/workflows/build-ubuntu-toolbox.yml
check_change true "$base"
base=$(git rev-parse HEAD)
commit_file .github/scripts/prepare-base-image.sh
check_change true "$base"
base=$(git rev-parse HEAD)
commit_file .github/workflows/image-changes.yml
check_change true "$base"

# Git errors must fail the check instead of silently skipping a build.
if check_change true invalid-ref 2>/dev/null; then
    echo 'An invalid comparison commit was accepted' >&2
    exit 1
fi

echo 'Image update checks passed'
