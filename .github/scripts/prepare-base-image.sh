#!/usr/bin/env bash
set -euo pipefail

# The digest records upstream changes for Renovate. Never use it to pull an
# image: upstream registries may remove it before the update PR can be merged.
image=$(sed -n 's/^image: //p' "$1")
if [[ ! "$image" =~ ^[^[:space:]@]+:[^[:space:]@]+@sha256:[a-f0-9]{64}$ ]]; then
    echo "Invalid base image reference in $1" >&2
    exit 1
fi
echo "BASE_IMAGE=${image%@*}" >> "$GITHUB_ENV"
