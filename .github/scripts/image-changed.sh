#!/usr/bin/env bash
set -euo pipefail

# Manual builds (and the first push to a branch) always build the image.
if [[ -z "$BASE_SHA" || "$BASE_SHA" =~ ^0+$ ]]; then
    echo 'changed=true' >> "$GITHUB_OUTPUT"
    exit 0
fi

# Run every workflow, but skip unrelated build jobs so required checks can
# succeed even when another image has a broken upstream dependency.
if git diff --quiet "$BASE_SHA" "$GITHUB_SHA" -- \
    "$IMAGE_PATH" "$WORKFLOW_PATH" \
    .github/workflows/image-changes.yml .github/scripts; then
    echo 'changed=false' >> "$GITHUB_OUTPUT"
else
    status=$?
    if [[ "$status" != 1 ]]; then
        exit "$status"
    fi
    echo 'changed=true' >> "$GITHUB_OUTPUT"
fi
