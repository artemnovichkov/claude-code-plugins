#!/bin/bash
# Export a Figma node as a PNG image using the Figma REST API.
# Usage: export-figma-node.sh <fileKey> <nodeId> <output_path>
# Requires: FIGMA_ACCESS_TOKEN env var (personal access token from Figma settings)

set -euo pipefail

# Auto-load .env from repo root if present
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
if [ -f "$REPO_ROOT/.env" ]; then
  while IFS='=' read -r key value; do
    # Skip comments and blank lines; only export simple KEY=VALUE pairs
    [[ "$key" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$key" ]] && continue
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | sed 's/^["'"'"']//;s/["'"'"']$//')
    export "$key=$value"
  done < "$REPO_ROOT/.env"
fi

FILE_KEY="${1:?Usage: export-figma-node.sh <fileKey> <nodeId> <output_path>}"
NODE_ID="${2:?Missing nodeId}"
OUTPUT="${3:?Missing output path}"

# Validate inputs — fileKey: alphanumeric/hyphens, nodeId: digits and colons/hyphens
if [[ ! "$FILE_KEY" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Error: Invalid fileKey — only alphanumeric, hyphens, underscores allowed." >&2
  exit 1
fi
if [[ ! "$NODE_ID" =~ ^[0-9]+([:-][0-9]+)*$ ]]; then
  echo "Error: Invalid nodeId — expected format like '123:456' or '123-456'." >&2
  exit 1
fi

# Sanitize output path — reject path traversal and absolute paths
case "$OUTPUT" in
  *..*)
    echo "Error: Output path must not contain '..'." >&2
    exit 1
    ;;
  /*)
    echo "Error: Output path must be relative, not absolute." >&2
    exit 1
    ;;
esac

if [ -z "${FIGMA_ACCESS_TOKEN:-}" ]; then
  echo "Error: FIGMA_ACCESS_TOKEN env var not set." >&2
  echo "Get one from: https://www.figma.com/developers/api#access-tokens" >&2
  exit 1
fi

# URL-encode the node ID (replace : with %3A)
ENCODED_NODE_ID="${NODE_ID//:/%3A}"

# Get the image export URL from Figma API
RESPONSE=$(curl -sf \
  -H "X-Figma-Token: ${FIGMA_ACCESS_TOKEN}" \
  "https://api.figma.com/v1/images/${FILE_KEY}?ids=${ENCODED_NODE_ID}&format=png&scale=3&use_absolute_bounds=true")

IMAGE_URL=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(list(d['images'].values())[0])")

if [ -z "$IMAGE_URL" ] || [ "$IMAGE_URL" = "null" ]; then
  echo "Error: Failed to get image URL from Figma API. Check fileKey/nodeId and token." >&2
  exit 1
fi

# Download the image
curl -sf -o "$OUTPUT" "$IMAGE_URL"
echo "Saved to $OUTPUT"
