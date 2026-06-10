#!/bin/bash

# Exit on error
set -e

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only)

# If no files are staged at all, exit early safely
if [ -z "$STAGED_FILES" ]; then
    echo "No staged files found. Skipping version bump."
    exit 0
fi

# Check if any staged files exist outside the excluded patterns
SHOULD_RUN=$(echo "$STAGED_FILES" | tr ' ' '\n' | grep -vE "^(\.github/workflows/|notebooks/)" || true)

if [ -z "$SHOULD_RUN" ]; then
  echo "All changed files are excluded. Skipping version bump."
  exit 0
fi

echo "Checking local repo version against remote main branch."