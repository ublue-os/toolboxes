#!/usr/bin/env bash
set -euo pipefail

repo=$(git rev-parse --show-toplevel)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Exercise the actual workflow commands: digest updates must keep pulling the
# tag, while tag updates must change the build input without editing a Containerfile.
while IFS= read -r metadata; do
    directory=${metadata%/*}
    name=${directory##*/}
    [[ "$directory" != apps/* ]] || name="$name-app"
    workflow="$repo/.github/workflows/build-$name.yml"
    image=$(yq -r '.image' "$repo/$metadata")
    [[ "$image" =~ ^[^[:space:]@]+:[^[:space:]@]+@sha256:[a-f0-9]{64}$ ]]
    grep -qx 'ARG BASE_IMAGE' "$repo/$directory/Containerfile."*
    read_step=$(yq -r '.jobs.push-ghcr.steps[] | select(.name == "Read base image tag") | .run' "$workflow")
    [[ -n "$read_step" ]]
    mkdir -p "$tmp/$directory"
    for reference in \
        "test.invalid/base:1@sha256:$(printf 'a%.0s' {1..64})" \
        "test.invalid/base:1@sha256:$(printf 'b%.0s' {1..64})" \
        "test.invalid/base:2@sha256:$(printf 'b%.0s' {1..64})"; do
        printf 'image: %s\n' "$reference" > "$tmp/$metadata"
        : > "$tmp/env"
        (cd "$tmp"; GITHUB_ENV="$tmp/env" bash -e -c "$read_step")
        grep -Fxq "BASE_IMAGE=${reference%@*}" "$tmp/env"
    done
    for event in pull_request push; do
        yq -e ".on.$event.paths | contains([\"$directory/**\", \".github/workflows/build-$name.yml\"])" "$workflow" >/dev/null
    done
done < <(cd "$repo"; find toolboxes apps -name image-version.yaml | sort)

# Downstream images must still be checked for changes to their parent toolbox.
for pair in 'steambox arch-toolbox' 'docker-app ubuntu-toolbox' 'incus-app ubuntu-toolbox'; do
    read -r child parent <<< "$pair"
    for event in pull_request push; do
        yq -e ".on.$event.paths | contains([\"toolboxes/$parent/**\", \".github/workflows/build-$parent.yml\"])" \
            "$repo/.github/workflows/build-$child.yml" >/dev/null
    done
done

echo 'Image update checks passed'
