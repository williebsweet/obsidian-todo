#!/bin/sh

set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
SUBMIT_REPO="${RAYCAST_SUBMIT_REPO:-$HOME/Documents/GitHub/raycast-extensions-submit}"
EXTENSION_NAME="${RAYCAST_EXTENSION_NAME:-obsidian-todo}"
TARGET_DIR="$SUBMIT_REPO/extensions/$EXTENSION_NAME"

if [ ! -d "$SUBMIT_REPO/.git" ]; then
  echo "Submission repo not found at: $SUBMIT_REPO" >&2
  echo "Set RAYCAST_SUBMIT_REPO or create the sparse checkout first." >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"

rsync -a --delete \
  --exclude ".git" \
  --exclude "node_modules" \
  --exclude "dist" \
  --exclude ".DS_Store" \
  --exclude "raycast-env.d.ts" \
  "$ROOT_DIR"/ "$TARGET_DIR"/

cat <<EOF
Synced $EXTENSION_NAME into:
  $TARGET_DIR

Next steps:
  cd "$SUBMIT_REPO"
  git checkout -b "submit/$EXTENSION_NAME-\$(date +%Y%m%d-%H%M%S)"
  git add extensions/$EXTENSION_NAME
  git commit -m "Add $EXTENSION_NAME extension"
  git push -u origin HEAD
  open "https://github.com/raycast/extensions/compare/main...williebsweet:extensions:\$(git branch --show-current)?expand=1"
EOF
