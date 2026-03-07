#!/bin/bash

# Read JSON input from stdin
INPUT=$(cat)

# Extract the command and output
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
OUTPUT=$(echo "$INPUT" | jq -r '(.tool_response.stdout // "") + "\n" + (.tool_response.stderr // "")')

# Only act on xcodebuild commands
if ! echo "$COMMAND" | grep -q "xcodebuild"; then
  exit 0
fi

# Extract scheme and project from command
SCHEME=$(echo "$COMMAND" | grep -oE '\-scheme\s+\S+' | awk '{print $2}')
PROJECT=$(echo "$COMMAND" | grep -oE '\-project\s+\S+' | awk '{print $2}' | xargs basename | sed 's/\.xcodeproj//')

# Determine success or failure
if echo "$OUTPUT" | grep -q "BUILD SUCCEEDED"; then
  TITLE="Build Succeeded"
elif echo "$OUTPUT" | grep -q "BUILD FAILED"; then
  TITLE="Build Failed"
else
  exit 0  # Skip if neither (e.g., clean, help, etc.)
fi

MESSAGE="${SCHEME:-xcodebuild} | ${PROJECT:-Project} Project"

osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""