#!/bin/bash
# Watches for accepted solutions and pushes them to GitHub.
# Only commits when the .accepted marker is present (written by the extension on AC).

REPO="/Volumes/workplace/LeetCode"
INTERVAL=10
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

cd "$REPO" || exit 1

while true; do
    sleep "$INTERVAL"

    # Only proceed if the extension wrote the .accepted marker
    [ -f "$REPO/.accepted" ] || continue

    # Remove the marker immediately so we don't double-commit
    rm -f "$REPO/.accepted"

    # Small delay in case the file is still being written
    sleep 2

    git -C "$REPO" add -A
    git -C "$REPO" diff --cached --quiet && continue

    MSG=$(git -C "$REPO" diff --cached --name-only | grep '\.cpp$' | sed 's|.*/||;s|\.cpp$||' | paste -sd ', ' -)
    [ -z "$MSG" ] && MSG="update"
    git -C "$REPO" commit -m "solve: $MSG"
    git -C "$REPO" push
done
